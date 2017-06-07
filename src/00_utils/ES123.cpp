#include <iostream>
#include <ctime>

static std::clock_t start = 0;

void tic(void){
  start = std::clock();
}

void toc(void){
  std::clock_t diff = std::clock() - start;
  std::cout << "elapsed time: " << 1.0 * diff / CLOCKS_PER_SEC << " seconds" << std::endl;
}
