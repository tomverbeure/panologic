#include <stdint.h>

#include "global.h"
#include "i2c.h"
#include "audio.h"
#include "print.h"

#include "top_defines.h"

static inline uint32_t rdcycle(void) {
    uint32_t cycle;
    asm volatile ("rdcycle %0" : "=r"(cycle));
    return cycle;
}

static volatile int cnt = 0;

#define WAIT_CYCLES 200000

int main() 
{
    GPIO_CONFIG = 0xff;

    audio_init();

    print("Yo de manne!\n");

    //uint32_t start;

    int cntr = 0;

    while(1);

    for (;;) {
        print("counter: ");
        print_int(cntr, 1);
        print("\n");

        SBUF[1]++;
//        GPIO_DOUT_SET = 0x55;
//        GPIO_DOUT_CLR = 0xaa;

        for(int i=0;i<WAIT_CYCLES;++i){
            ++cnt;
        }

        GPIO_DOUT = 0x55;

//        start = rdcycle();
//        while ((rdcycle() - start) <= 20000000);

        for(int i=0;i<WAIT_CYCLES;++i){
            ++cnt;
        }

        GPIO_DOUT = 0xaa;

//        start = rdcycle();
//        while ((rdcycle() - start) <= 20000000);

        ++cntr;
    }
}
