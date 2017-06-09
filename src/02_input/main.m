# Course: ES123
# By: Ben Lauwens

# Objective: put the message "Hello, $first_name" on the screen
# Input: string first_name
# Output: "Hello, $first_name"
# Processing: nihil

clear variables;

# to enter a string the second argument on input has to be 's'
first_name = input('Please enter your first name (followed by ''enter''): ', 's');
# strings can be joined by putting them in an array
disp(['Hello, ', first_name, '!']);
