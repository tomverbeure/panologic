#include <stdint.h>

#include "global.h"
#include "i2c.h"
#include "print.h"

#include "top_defines.h"

static inline uint32_t rdcycle(void) {
    uint32_t cycle;
    asm volatile ("rdcycle %0" : "=r"(cycle));
    return cycle;
}

static volatile int cnt = 0;

#define WAIT_CYCLES 200000

i2c_ctx_t audio_i2c_ctx;

void audio_init()
{
	audio_i2c_ctx.base_addr = 0;
	audio_i2c_ctx.scl_pin_nr = 2;
	audio_i2c_ctx.sda_pin_nr = 3;

    i2c_init(&audio_i2c_ctx);
}

int main() 
{
    int result;


    audio_init();

    GPIO_CONFIG = 0xff;

    for(int i=2;i<256; i+=1){
        result = i2c_write_reg(&audio_i2c_ctx, i, 0, 0);

        print_byte(i, 1);
        print(" ");
        print_byte(result, 1);
        print(";  ");

        if (result) while (1);
    }

    print("Yo de manne!\n");

    uint32_t start;

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
