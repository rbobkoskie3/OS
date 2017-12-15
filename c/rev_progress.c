#include <stdio.h>
#include <unistd.h>

// gcc -std=c99 -o <FILE> <FILE.c>
int main(void) {
   // Simulates progress from 100% to 0%
   for (int i=100; i>0; i--) {
      // BUG: If format is not specified, or
      // extra space not used,
      // Two %% signs will display when decimal goes below 100, e.g.,
      // Percent Complete: 99%%
      // Three %%% will display when decimal goes below 10, e.g.,
      // Percent Complete: 9%%%
      // printf("\rPercent Complete: %d%%", i);
      // Can fix BUG by defining number of places for decimal
      printf("\rPercent Complete: %3d%%", i);
      // Or fix BUG by adding in a space
      // printf("\rPercent Complete: %d%% ", i);
      fflush(stdout);
      sleep(1);
   }
}
