# Course: ES123
# By: Ben Lauwens

using ES123

# Objective: put the message "Hello, $first_name" on the screen
# Input: string first_name
# Output: "Hello, $first_name"
# Processing: nihil

print("Please enter your first name (followed by 'enter'): ")
# the newline symbol is included in the string, chomp removes trailing newline
first_name = chomp(readline())
println("Hello, ", first_name, "!")
