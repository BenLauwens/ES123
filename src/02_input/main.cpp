// Course: ES123
// By: Ben Lauwens

#include "ES123.hpp"

// Objective: put the message "Hello, $first_name" on the screen
// Input: string first_name
// Output: "Hello, $first_name"
// Processing: nihil

int main(){
  string first_name; // declare first_name as a string
  cout << "Please enter your first name (followed by 'enter'): ";
  cin >> first_name;
  cout << "Hello, " << first_name << "!" << endl;
  return 0;
}
