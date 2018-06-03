#ifndef GLOBAL_H
#define GLOBAL_H

#include <stdio.h>
#include "top_defines.h"

typedef unsigned char byte;

#define GPIO_CONFIG     *((volatile uint32_t *)(0xf0000000 | GPIO_CONFIG_ADDR  ))
#define GPIO_DOUT       *((volatile uint32_t *)(0xf0000000 | GPIO_DOUT_ADDR    ))
#define GPIO_DIN        *((volatile uint32_t *)(0xf0000000 | GPIO_DIN_ADDR     ))
#define GPIO_DOUT_SET   *((volatile  int32_t *)(0xf0000000 | GPIO_DOUT_SET_ADDR))
#define GPIO_DOUT_CLR   *((volatile uint64_t *)(0xf0000000 | GPIO_DOUT_CLR_ADDR))

#endif
