# Course: ES123
# By: Ben Lauwens

import ES123

# Objective: put the message "Hello, $first_name (age $age)" on the screen
# Input: string first_name, number age
# Output: "Hello, $first_name (age $age)"
# Processing: nihil

first_name = input("Please enter your first name: ")
# int tries to convert the string input to an integer
age = int(input("Please enter your first age: "))
print("Hello, ", first_name, " (age ", age, ")", sep='')
