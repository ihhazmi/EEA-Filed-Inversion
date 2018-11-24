//
//  main.c
//  EEA2
//
//  Created by Ibrahim Hazmi on 2015-06-27.
//  Copyright (c) 2015 University of Victoria. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main() {
    // Polynomial GCD
    unsigned int a, f, a_adj, q=1, r=0;
    int d=1;
    printf("a = "); scanf ("%x",&a);
    printf("f = "); scanf ("%x",&f);
    while (d>0){
        d= clz(a)- clz(f);
        if(d<0)
            a_adj = 0;
        else
            a_adj = a << d;
        r= f ^ a_adj;
        if((clz(r)-clz(f))>=1 & clz(r)<=clz(a)){
            q= q<< (clz(r)-clz(f));
            q=q+1;}
        else if((clz(r)-clz(f))>=1 & clz(r)>clz(a))
            q= q<< (clz(r)-clz(a)+1);
        f=r;
    }
    
    printf("r = %x\n",r);
    for (int n=0; n<32; n++){
        printf("%x",!!((r << n)& 0x80000000));
        if (n==3 | n==7 | n==11 | n==15 | n==19 | n==23 | n==27)
            printf(" "); /* insert a space between nybbles */
    }
    printf("\nq = %x\n",q);
    for (int i=0; i<32; i++){
        printf("%d",!!((q << i)& 0x80000000));
    if (i==3 | i==7 | i==11 | i==15 | i==19 | i==23 | i==27)
        printf(" "); /* insert a space between nybbles */
    }
    printf("\nCLZ(A) = %x\n",clz(a));
    return 0;
}
/*  int clz(unsigned int n)
{
        int i;
        for (i=0; i<32; ++i)
        	if (n & (0x80000000 >> i))
                return i;
    return 0;

} /* unsigned_divide */
 int clz(unsigned int x)
{  static const unsigned int bval[] =
    {0,1,2,2,3,3,3,3,4,4,4,4,4,4,4,4};
    unsigned int r = 0;
    if (x & 0xFFFF0000) { r += 16/1; x >>= 16/1; } //16-1 works
    if (x & 0x0000FF00) { r += 16/2; x >>= 16/2; }
    if (x & 0x000000F0) { r += 16/4; x >>= 16/4; }

    return 32-r + bval[(x & 0x0000F000)]+ bval[(x & 0x00000F00)]
    + bval[(x & 0x000000F0)]+ bval[(x & 0x0000000F)];}  //Should be for each digit of x!

/*return r + bval[x(15 downto 12)]+ bval[x(11 downto 8)]
+ bval[x(7 downto 4)]+ bval[x(3 downto 0)];}  //Should be for each digit of x!*/