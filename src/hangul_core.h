#ifndef KOREAN_IME_HANGUL_CORE_H
#define KOREAN_IME_HANGUL_CORE_H

#include <stdint.h>

/* A small, allocation-free Dubeolsik composition engine. Input is a Unicode
 * compatibility jamo (U+3131..U+3163), as emitted by Kindle's Korean layout. */
typedef struct {
    int l;
    int v;
    int t;
    uint32_t standalone;
} HangulState;

typedef struct {
    uint32_t commit;  /* non-zero: commit this before preedit */
    uint32_t preedit; /* non-zero: replace the active preedit with this */
} HangulResult;

void hangul_reset(HangulState *state);
HangulResult hangul_feed(HangulState *state, uint32_t jamo);
HangulResult hangul_backspace(HangulState *state);
uint32_t hangul_preedit(const HangulState *state);

#endif
