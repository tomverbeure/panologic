
#include "global.h"

int cur_x = 0;
int cur_y = 0;

void scroll()
{
    for(int l=0;l<25;++l){
        for(int c=0;c<80;++c){
            SBUF[l * 128 + c] = (l==24) ? ' ' : SBUF[(l+1)*128 + c];
        }
    }
}

void next_line()
{
    cur_x = 0;
    ++cur_y;
    if (cur_y >= 25){
        scroll();
        cur_y = 24;
    }
}

void print(char *str)
{
    while(*str != '\0'){
        if (*str == '\n'){
            next_line();

            ++str;
            continue;
        }
        SBUF[cur_y * 128 + cur_x] = *str;
        ++str;

        ++cur_x;
        if (cur_x >= 80){
            next_line();
        }
    }
}

char hex_digits[] = "0123456789abcdef";

void print_int(int value, int hex)
{
    char buf[16] = "\0";
    if (hex) {
        for(int i=7;i>=0;--i){
            buf[7-i] = hex_digits[((value >> (i*4))&0xf)];
        }
        buf[8] = '\0';
    }

    print(buf);
}


