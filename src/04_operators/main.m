# Course: ES123
# By: Ben Lauwens

# Objective: Apply operators to a floating-point value
# Input: floating-point $v
# Output: $v, $v+1, 3*$v, $v+$v, $v*$v, $v/2
# Processing: nihil

clear variables;

v = input("Please enter a floating-point value: ");
disp(['v == ', num2str(v)]);
disp(['v+1 == ', num2str(v+1)]);
disp(['3*v == ', num2str(3*v)]);
disp(['v+v == ', num2str(v+v)]);
disp(['v*v == ', num2str(v*v)]);
disp(['v/2 == ', num2str(v/2)]);
