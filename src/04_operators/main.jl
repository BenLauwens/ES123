# Course: ES123
# By: Ben Lauwens

using ES123

# Objective: Apply operators to a floating-point value
# Input: floating-point $v
# Output: $v, $v+1, 3*$v, $v+$v, $v*$v, $v/2
# Processing: nihil

print("Please enter a floating-point value: ")
v = parse(Float64, readline())
println("v == ", v)
println("v+1 == ", v+1)
println("3*v == ", 3*v)
println("v+v == ", v+v)
println("v*v == ", v*v)
println("v/2 == ", v/2)
