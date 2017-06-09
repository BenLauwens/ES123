# Course: ES123
# By: Ben Lauwens

using ES123

# Objective: put the message "Hello, $first_name (age $age)" on the screen
# Input: string first_name, integer age
# Output: "Hello, $first_name (age $age)"
# Processing: nihil

print("Please enter your first name: ")
first_name = chomp(readline())
print("Please enter your age: ")
# parse tries to convert the string input to an integer
age = parse(Int, readline())
println("Hello, ", first_name, " (age ", age, ")")
