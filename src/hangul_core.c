#include "hangul_core.h"

static const uint32_t consonants[] = {
  0x3131,0x3132,0x3133,0x3134,0x3135,0x3136,0x3137,0x3138,0x3139,0x313A,
  0x313B,0x313C,0x313D,0x313E,0x313F,0x3140,0x3141,0x3142,0x3143,0x3144,
  0x3145,0x3146,0x3147,0x3148,0x3149,0x314A,0x314B,0x314C,0x314D,0x314E
};
static const int initial[] = {0,1,-1,2,-1,-1,3,4,5,-1,-1,-1,-1,-1,-1,-1,6,7,8,-1,9,10,11,12,13,14,15,16,17,18};
static const int final[] = {1,2,3,4,5,6,7,0,8,9,10,11,12,13,14,15,16,17,18,0,19,20,21,22,0,23,24,25,26,27};

static int find(const uint32_t *items, int count, uint32_t value) {
    int i; for (i = 0; i < count; ++i) if (items[i] == value) return i; return -1;
}
static int initial_for(uint32_t c) { int x = find(consonants, 30, c); return x < 0 ? -1 : initial[x]; }
static int final_for(uint32_t c) { int x = find(consonants, 30, c); return x < 0 ? -1 : final[x]; }
static uint32_t consonant_for_initial(int l) { int i; for (i=0;i<30;i++) if(initial[i] == l) return consonants[i]; return 0; }
static int compose_vowel(int a, int b) {
    if(a==8&&b==0)return 9; if(a==8&&b==1)return 10; if(a==8&&b==20)return 11;
    if(a==13&&b==4)return 14; if(a==13&&b==5)return 15; if(a==13&&b==20)return 16;
    if(a==18&&b==20)return 19; return -1;
}
static int compose_final(int a, int b) {
    static const int table[28][28] = {{0}};
    if(a==1&&b==19)return 3; if(a==4&&b==22)return 5; if(a==4&&b==27)return 6;
    if(a==8&&b==1)return 9; if(a==8&&b==16)return 10; if(a==8&&b==17)return 11;
    if(a==8&&b==19)return 12; if(a==8&&b==25)return 13; if(a==8&&b==26)return 14;
    if(a==8&&b==27)return 15; if(a==17&&b==19)return 18; (void)table; return -1;
}
static int split_final(int t, int *first, int *second_l) {
    switch(t) { case 3:*first=1;*second_l=9;return 1; case 5:*first=4;*second_l=12;return 1;
    case 6:*first=4;*second_l=18;return 1; case 9:*first=8;*second_l=0;return 1;
    case 10:*first=8;*second_l=6;return 1; case 11:*first=8;*second_l=7;return 1;
    case 12:*first=8;*second_l=9;return 1; case 13:*first=8;*second_l=16;return 1;
    case 14:*first=8;*second_l=17;return 1; case 15:*first=8;*second_l=18;return 1;
    case 18:*first=17;*second_l=9;return 1; default:return 0; }
}
static int initial_from_final(int t) {
    switch(t) {
    case 1:return 0; case 2:return 1; case 4:return 2; case 7:return 3;
    case 8:return 5; case 16:return 6; case 17:return 7; case 19:return 9;
    case 20:return 10; case 21:return 11; case 22:return 12; case 23:return 14;
    case 24:return 15; case 25:return 16; case 26:return 17; case 27:return 18;
    default:return -1;
    }
}
static uint32_t syllable(int l,int v,int t) { return 0xAC00u + (uint32_t)((l*21+v)*28+t); }
void hangul_reset(HangulState *s) { s->l=-1;s->v=-1;s->t=0;s->standalone=0; }
uint32_t hangul_preedit(const HangulState *s) {
    if(s->l>=0 && s->v>=0) return syllable(s->l,s->v,s->t);
    if(s->l>=0) return consonant_for_initial(s->l);
    return s->standalone;
}
static HangulResult out(const HangulState *s, uint32_t commit) { HangulResult r={commit,hangul_preedit(s)};return r; }
HangulResult hangul_feed(HangulState *s, uint32_t j) {
    int ci=initial_for(j), fi=final_for(j), vi=(j>=0x314F&&j<=0x3163)?(int)(j-0x314F):-1;
    uint32_t old=hangul_preedit(s);
    if(ci>=0) {
        if(s->standalone) { uint32_t c=s->standalone; s->standalone=0;s->l=ci; return out(s,c); }
        if(s->l<0) { s->l=ci; return out(s,0); }
        if(s->v<0) { uint32_t c=old; s->l=ci; return out(s,c); }
        if(s->t==0 && fi>0) { s->t=fi; return out(s,0); }
        if(s->t>0) { int x=compose_final(s->t,fi); if(x>0){s->t=x;return out(s,0);} }
        { uint32_t c=old; s->l=ci;s->v=-1;s->t=0;return out(s,c); }
    }
    if(vi>=0) {
        if(s->standalone) { uint32_t c=s->standalone;s->standalone=0;return out(s,c); }
        if(s->l<0) { s->standalone=j;return out(s,0); }
        if(s->v<0) {s->v=vi;return out(s,0);}
        if(s->t==0) {int x=compose_vowel(s->v,vi);if(x>=0){s->v=x;return out(s,0);} {uint32_t c=old;s->l=-1;s->v=-1;s->standalone=j;return out(s,c);}}
        { int first, next; uint32_t c;
          if(split_final(s->t,&first,&next)){s->t=first;c=hangul_preedit(s);s->l=next;s->v=vi;s->t=0;return out(s,c);}
          next=initial_from_final(s->t);
          if(next<0) next=0; s->t=0;c=hangul_preedit(s);s->l=next;s->v=vi;return out(s,c); }
    }
    hangul_reset(s); return (HangulResult){old,j};
}
HangulResult hangul_backspace(HangulState *s) {
    if(s->standalone){s->standalone=0;return out(s,0);} if(s->t){s->t=0;return out(s,0);} if(s->v>=0){s->v=-1;return out(s,0);} if(s->l>=0){s->l=-1;return out(s,0);} return out(s,0);
}
