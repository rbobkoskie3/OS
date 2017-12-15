#include <stdio.h>
#include <unistd.h>

// gcc -std=c99 -o <FILE> <FILE.c>
int main(void) {
   // Simulates progress from 0% to 100%
   for (int i=0; i<=100; i++) {
      printf("\rPercent Complete: %d%%", i);
      fflush(stdout);
      sleep(1);
   }
}
