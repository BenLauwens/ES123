// Course: ES123
// By: Ben Lauwens

#include "ES123.hpp"

// Objective: put the message "Hello, $first_name (age $age)" on the screen
// Input: string first_name, number age
// Output: "Hello, $first_name (age $age)"
// Processing: nihil

int main(){
  string first_name;  // declare first_name as a string
  int age;            // declare age as an integer
  cout << "Please enter your first name: ";
  cin >> first_name;
  cout << "Please enter your age: ";
  cin >> age;
  cout << "Hello, " << first_name << " (age " << age << ")" << endl;
  return 0;
}
