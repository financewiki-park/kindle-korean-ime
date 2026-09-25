#include "hangul_core.h"
#include <assert.h>
#include <stdio.h>
static uint32_t feed(HangulState *s, const uint32_t *v, int n) { HangulResult r={0,0};int i;for(i=0;i<n;i++)r=hangul_feed(s,v[i]);return r.preedit; }
int main(void) {
  HangulState s; uint32_t ga[]={0x3131,0x314F}, han[]={0x314E,0x314F,0x3134};
  uint32_t gwa[]={0x3131,0x3157,0x314F}, gaksa[]={0x3131,0x314F,0x3131,0x3145,0x314F};
  hangul_reset(&s); assert(feed(&s,ga,2)==0xAC00); hangul_reset(&s); assert(feed(&s,han,3)==0xD55C);
  hangul_reset(&s); assert(feed(&s,gwa,3)==0xACFC); hangul_reset(&s); assert(feed(&s,gaksa,5)==0xC0AC);
  hangul_reset(&s); feed(&s,han,3); assert(hangul_backspace(&s).preedit==0xD558);
  puts("hangul core tests: ok"); return 0;
}
