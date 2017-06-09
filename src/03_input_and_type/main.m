# Course: ES123
# By: Ben Lauwens

# Objective: put the message "Hello, $first_name (age $age)" on the screen
# Input: string first_name, number age
# Output: "Hello, $first_name (age $age)"
# Processing: nihil

clear variables;

first_name = input('Please enter your first name: ', 's'); #string input
age = input('Please enter your age: '); # number input
# num2str converts a number to a string
disp(['Hello, ', first_name, ' (age ', num2str(age), ')']);
