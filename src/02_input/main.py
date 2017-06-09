# Course: ES123
# By: Ben Lauwens

import ES123

# Objective: put the message "Hello, $first_name" on the screen
# Input: string first_name
# Output: "Hello, $first_name"
# Processing: nihil

first_name = input("Please enter your first name (followed by 'enter'): ")
# Default separator for a print statement is ' '
print("Hello, ", first_name, "!", sep='')
