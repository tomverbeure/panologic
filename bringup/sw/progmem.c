#include <stdint.h>

#include "top_defines.h"

#define GPIO_CONFIG     *((volatile uint32_t *)(0xf0000000 | GPIO_CONFIG_ADDR  ))
#define GPIO_DOUT       *((volatile uint32_t *)(0xf0000000 | GPIO_DOUT_ADDR    ))
#define GPIO_DIN        *((volatile uint32_t *)(0xf0000000 | GPIO_DIN_ADDR     ))
#define GPIO_DOUT_SET   *((volatile  int32_t *)(0xf0000000 | GPIO_DOUT_SET_ADDR))
#define GPIO_DOUT_CLR   *((volatile uint64_t *)(0xf0000000 | GPIO_DOUT_CLR_ADDR))

static inline uint32_t rdcycle(void) {
    uint32_t cycle;
    asm volatile ("rdcycle %0" : "=r"(cycle));
    return cycle;
}

volatile static cnt = 0;

#define WAIT_CYCLES 200000

int main() {

    GPIO_CONFIG = 0xff;

    uint32_t start;


    for (;;) {
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
    }
}
