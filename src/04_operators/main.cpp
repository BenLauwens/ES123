// Course: ES123
// By: Ben Lauwens

#include "ES123.hpp"

// Objective: Apply operators to a floating-point value
// Input: floating-point $v
// Output: $v, $v+1, 3*$v, $v+$v, $v*$v, $v/2
// Processing: nihil

int main(){
  double v;  // declare v as a floating-point
  cout << "Please enter a floating point value: ";
  cin >> v;
  cout << "v == " << v << endl
       << "v+1 == " << v+1 << endl
       << "3*v == " << 3*v << endl
       << "v+v == " << v+v << endl
       << "v*v == " << v*v << endl
       << "v/2 == " << v/2 << endl;
  return 0;
}
