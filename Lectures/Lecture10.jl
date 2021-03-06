### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 54f89e42-7eb6-11eb-0a18-79732e59d627
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ 21cefe9c-7eb3-11eb-2469-2b7b3d1eccc3
md"""# Arrays

This chapter presents one of Julia’s most useful built-in types, the array. You will also learn about objects and what can happen when you have more than one name for the same object."""

# ╔═╡ 62637476-7eb6-11eb-0cb4-01f126c2feb8
md"""## An Array Is a Sequence

Like a string, an *array* is a sequence of values. In a string, the values are characters; in an array, they can be any type. The values in an array are called *elements* or sometimes *items*.

There are several ways to create a new array; the simplest is to enclose the elements in square brackets (`[ ]`):

```julia
[10, 20, 30, 40]
["crunchy frog", "ram bladder", "lark vomit"]
```

The first example is an array of four integers. The second is an array of three strings. The elements of an array don’t have to be the same type. The following array contains a string, a float, an integer, and another array:

```julia
["spam", 2.0, 5, [10, 20]]
```

An array within another array is *nested*.

An array that contains no elements is called an empty array; you can create one with empty brackets, `[]`.

As you might expect, you can assign array values to variables:

```julia
julia> cheeses = ["Cheddar", "Edam", "Gouda"]; 

julia> numbers = [42, 123];

julia> empty = [];

julia> print(cheeses, " ", numbers, " ", empty)
["Cheddar", "Edam", "Gouda"] [42, 123] Any[]
```

The function `typeof` can be used to find out the type of the array:

```julia
julia> typeof(cheeses) 
Array{String,1} 
julia> typeof(numbers) 
Array{Int64,1}
julia> typeof(empty) 
Array{Any,1}
```

The number indicates the dimensions (we’ll talk more about this in “Arrays”). The array `empty` contains values of type `Any`; that is, it can hold values of all types.
"""

# ╔═╡ daca2c98-7eb6-11eb-1c09-8f1e08b31315
md"""## Arrays Are Mutable

The syntax for accessing the elements of an array is the same as for accessing the characters of a string—using the bracket operator. The expression inside the brackets specifies the index. Remember that the indices start at 1:

```julia
julia> cheeses[1] 
"Cheddar"
```

Unlike strings, arrays are *mutable*; that is, their values can be changed. When the bracket operator appears on the left side of an assignment, it identifies the element of the array that will be assigned:

```julia
julia> numbers[2] = 5 
5
julia> print(numbers) 
[42, 5]
```

The second element of `numbers`, which used to be `123`, is now `5`.
Figure 10-1 shows the state diagrams for `cheeses`, `numbers`, and `empty`.
"""

# ╔═╡ 1b70a1d2-7eb7-11eb-2ab9-6739d60fcf89
Drawing(width=720, height=230) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=300, y=55, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("cheeses ->") 
	end
    rect(x=310, y=10, width=160, height=85, fill="rgb(242, 242, 242)", stroke="black")
	text(x=320, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=335, y1=25, x2=355, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=370, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Cheddar\"") 
	end
	text(x=320, y=55, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=335, y1=50, x2=355, y2=50, stroke="black", marker_end="url(#arrow)")
	text(x=370, y=55, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Edam\"") 
	end
	text(x=320, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3") 
	end
	line(x1=335, y1=75, x2=355, y2=75, stroke="black", marker_end="url(#arrow)")
	text(x=370, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Gouda\"") 
	end
	text(x=300, y=150, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("numbers ->") 
	end
    rect(x=310, y=105, width=160, height=85, fill="rgb(242, 242, 242)", stroke="black")
	text(x=320, y=125, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=335, y1=120, x2=355, y2=120, stroke="black", marker_end="url(#arrow)")
	text(x=370, y=125, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("42") 
	end
	text(x=320, y=165, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	text(x=370, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("123") 
	end
	line(x1=335, y1=158, x2=355, y2=150, stroke="black", stroke_dasharray="5,5", marker_end="url(#arrow)")
	text(x=370, y=180, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("5") 
	end
	line(x1=335, y1=162, x2=355, y2=170, stroke="black", marker_end="url(#arrow)")
	text(x=300, y=215, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("empty ->") 
	end
    rect(x=310, y=200, width=160, height=20, fill="rgb(242, 242, 242)", stroke="black")
end

# ╔═╡ c41c5b10-7ebb-11eb-06f6-57f0ccbbf9ac
md"*Figure 10-1. State diagram.*"

# ╔═╡ d3894a90-7ebb-11eb-0541-133459689a2d
md"""Arrays are represented by boxes with the elements of the array inside them. `cheeses` refers to an array with three elements indexed: 1, 2, and 3. `numbers` contains two elements; the diagram shows that the value of the second element has been reassigned from `123` to `5`. `empty` refers to an array with no elements.


Array indices work the same way as string indices (but without UTF-8 caveats):

- Any integer expression can be used as an index.
- If you try to read or write an element that does not exist, you get a BoundsError.
- The keyword end points to the last index of the array.

The `∈` operator also works on arrays:

```julia
julia> "Edam" ∈ cheeses 
true
julia> "Brie" in cheeses 
false
```
"""

# ╔═╡ 1628711e-7ebc-11eb-2cec-f71c338de835
md"""## Traversing an Array

The most common way to traverse the elements of an array is with a `for` loop. The syntax is the same as for strings:

```julia
for cheese in cheeses 
	println(cheese)
end
```

This works well if you only need to read the elements of the array. But if you want to write or update the elements, you need the indices. One technique is to use the built- in function `eachindex`:

```julia
for i in eachindex(numbers) 
	numbers[i] = numbers[i] * 2
end
```

This loop traverses the array and updates each element. Each time through the loop `i` gets the index of the next element. The assignment statement in the body uses `i` to read the old value of the element and to assign the new value.

A `for` loop over an empty array never runs the body:

```julia
for x in []
	println("This can never happen.")
end
```

Although an array can contain another array, the nested array still counts as a single element. The length of this array is 4:

```julia
["spam", 1, ["Brie", "Roquefort", "Camembert"], [1, 2, 3]]
```
"""

# ╔═╡ 9c7423e4-7ebc-11eb-391d-b3388978ea47
md"""## Array Slices

The slice operator (`[n:m]`) also works on arrays: 

```julia
julia> t = ['a', 'b', 'c', 'd', 'e', 'f'];

julia> print(t[1:3]) 
['a', 'b', 'c'] 
julia> print(t[3:end]) 
['c', 'd', 'e', 'f']
```

Using the slice operator without arguments makes a copy of the whole array:

```julia
julia> print(t[:])
['a', 'b', 'c', 'd', 'e', 'f']
```

Since arrays are mutable, it is often useful to make a copy before performing operations that modify arrays.

A slice operator on the left side of an assignment can update multiple elements:

```julia
julia> t[2:3] = ['x', 'y']; 

julia> print(t)
['a', 'x', 'y', 'd', 'e', 'f']
```
"""

# ╔═╡ eadf298e-7ebc-11eb-26e8-65a4f6640fbd
md"""## Array Library

Julia provides functions that operate on arrays. For example, `push!` adds a new element to the end of an array:

```julia
julia> t = ['a', 'b', 'c']; 

julia> push!(t, 'd');

julia> print(t) ['a', 'b', 'c', 'd']
```

`append!` adds the elements of the second array to the end of the first: 

```julia
julia> t1 = ['a', 'b', 'c'];

julia> t2 = ['d', 'e']; 

julia> append!(t1, t2);

julia> print(t1)
['a', 'b', 'c', 'd', 'e']
```

This example leaves `t2` unmodified.

`sort!` arranges the elements of the array from low to high:

```julia
julia> t = ['d', 'c', 'e', 'b', 'a']; 

julia> sort!(t);

julia> print(t)
['a', 'b', 'c', 'd', 'e']
```

`sort` returns a copy of the elements of the array in order: 

```julia
julia> t1 = ['d', 'c', 'e', 'b', 'a'];

julia> t2 = sort(t1);

julia> print(t1)
['d', 'c', 'e', 'b', 'a'] 
julia> print(t2)
['a', 'b', 'c', 'd', 'e']
```

!!! tip
    As a style convention in Julia, `!` is appended to names of functions that modify their arguments.
"""

# ╔═╡ 5b124fc4-7ebd-11eb-1a06-c9ea65c0953c
md"""## Map, Filter, and Reduce

To add up all the numbers in an array, you can use a loop like this:

```julia
function addall(t) 
	total = 0
	for x in t
		total += x 
	end
	total
end
```

`total` is initialized to 0. Each time through the loop, `x` gets one element from the array. The `+=` operator provides a short way to update a variable. This *augmented assignment statement*:

```julia
total += x
```

is equivalent to:

```julia
total = total + x
```

As the loop runs, `total` accumulates the sum of the elements; a variable used this wa is sometimes called an *accumulator*.

Adding up the elements of an array is such a common operation that Julia provides it
as a built-in function, `sum`: 

```julia
julia>t=[1,2,3,4];

julia> sum(t) 
10
```

An operation like this that combines a sequence of elements into a single value is sometimes called a *reduce operation*.

Often you want to traverse one array while building another. For example, the following function takes an array of strings and returns a new array that contains capitalized strings:

```julia
function capitalizeall(t) 
	res=[]
	for s in t
		push!(res, uppercase(s))
	end
	res
end
```

`res` is initialized with an empty array; each time through the loop, we append the next element. So, `res` is another kind of accumulator.


An operation like `capitalizeall` is sometimes called a *map* because it “maps” a func‐ tion (in this case `uppercase`) onto each of the elements in a sequence.


Another common operation is to select some of the elements from an array and return a subarray. For example, the following function takes an array of strings and returns an array that contains only the uppercase strings:

```julia
function onlyupper(t) 
	res=[]
	for s int
		if s == uppercase(s)
			push!(res, s) 
		end
	end
	res
end
```

An operation like `onlyupper` is called a *filter* because it selects some of the elements and filters out the others.

Most common array operations can be expressed as a combination of map, filter, and reduce.
"""

# ╔═╡ 8b9a193c-7ebe-11eb-3fc3-b76b75cd0186
md"""## Dot Syntax

For every binary operator, like `^`, there is a corresponding *dot operator*, like `.^`, that is automatically defined to perform the operation element-by-element on arrays. For example, `[1, 2, 3] ^ 3` is not defined, but `[1, 2, 3] .^ 3` is defined as computing the elementwise result `[1^3, 2^3, 3^3]`:

```julia
julia> print([1, 2, 3] .^ 3) 
[1, 8, 27]
```

Any Julia function `f` can be applied elementwise to any array with the *dot syntax*. For example, to capitalize an array of strings, we don’t need an explicit loop:

```julia
julia> t = uppercase.(["abc", "def", "ghi"]); 

julia> print(t)
["ABC", "DEF", "GHI"]
```

This is an elegant way to create a map. The function `capitalizeall` can be imple‐ mented by a one-liner:

```julia
capitalizeall(t) = uppercase.(t)
```
"""

# ╔═╡ e1966318-7ebe-11eb-37a1-775a6c3621aa
md"""## Deleting (Inserting) Elements

There are several ways to delete elements from an array. If you know the index of the element you want, you can use `splice!`:

```julia
julia> t = ['a', 'b', 'c'];

julia> splice!(t, 2)
'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase) 
julia> print(t)
['a', 'c']
```

`splice!` modifies the array and returns the element that was removed. 

`pop!` deletes and returns the last element:

```julia
julia> t = ['a', 'b', 'c'];

julia> pop!(t)
'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase) 
julia> print(t)
['a', 'b']
```

`popfirst!` deletes and returns the first element: 

```julia 
julia> t = ['a', 'b', 'c'];

julia> popfirst!(t)
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase) 
julia> print(t)
['b', 'c']
```

The functions `pushfirst!` and `push!` insert an element at the beginning and end, respectively, of the array.


If you don’t need the removed value, you can use the function `deleteat!`: 

```julia
julia> t = ['a', 'b', 'c'];

julia> print(deleteat!(t, 2)) 
['a', 'c']
```

The function `insert!` inserts an element at a given index: 

```julia
julia> t = ['a', 'b', 'c'];

julia> print(insert!(t, 2, 'x')) 
['a', 'x', 'b', 'c']
```
"""

# ╔═╡ 53f60b52-7ebf-11eb-140a-75c0c412b628
md"""## Arrays and Strings

A string is a sequence of characters and an array is a sequence of values, but an array of characters is not the same as a string. To convert from a string to an array of characters, you can use the function `collect`:

```julia
julia> t = collect("spam"); 

julia> print(t)
['s', 'p', 'a', 'm']
```

The collect function breaks a string or another sequence into individual elements. 

If you want to break a string into words, you can use the `split` function:

```julia
julia> t = split("pining for the fjords");

julia> print(t)
SubString{String}["pining", "for", "the", "fjords"]
```

An *optional argument* called a *delimiter* specifies which characters to use as word boundaries (we talked briefly about optional arguments in “Exercise 8-7”). The following example uses a hyphen as a delimiter:

```julia
julia> t = split("spam-spam-spam", '-'); 

julia> print(t)
SubString{String}["spam", "spam", "spam"]
```

`join` is the inverse of `split`. It takes an array of strings and concatenates the elements:

```julia
julia> t = ["pining", "for", "the", "fjords"]; 

julia> s = join(t, ' ')
"pining for the fjords"
```

In this case the delimiter is a space character. To concatenate strings without spaces, you don’t specify a delimiter.
"""

# ╔═╡ e08fed44-7ebf-11eb-1c6a-55ee8e49968e
md"""## Objects and Values

An *object* is something a variable can refer to. Until now, you might have used “object” and “value” interchangeably.

If we run these assignment statements:

```julia
a = "banana"
b = "banana"
```

we know that `a` and `b` both refer to a string, but we don’t know whether they refer to the same string. There are two possible states, as shown in Figure 10-2.
"""

# ╔═╡ 04e15ba6-7ec0-11eb-3c7d-211e84ba32c0
Drawing(width=720, height=70) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
    rect(x=210, y=10, width=140, height=50, fill="rgb(242, 242, 242)", stroke="black")
	rect(x=360, y=10, width=140, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=220, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("a") 
	end
	line(x1=235, y1=25, x2=255, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=270, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"banana\"") 
	end
	text(x=220, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("b") 
	end
	line(x1=235, y1=45, x2=255, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=270, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"banana\"") 
	end
	text(x=370, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("a") 
	end
	line(x1=385, y1=25, x2=405, y2=30, stroke="black", marker_end="url(#arrow)")
	text(x=420, y=40, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"banana\"") 
	end
	text(x=370, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("b") 
	end
	line(x1=385, y1=45, x2=405, y2=40, stroke="black", marker_end="url(#arrow)")
end

# ╔═╡ a2a6face-7ec2-11eb-313a-73f3916a14ad
md"*Figure 10-2. State diagrams.*"

# ╔═╡ b218e204-7ec2-11eb-3321-3f0082f5e74d
md"""In one case, `a` and `b` refer to two different objects that have the same value. In the second case, they refer to the same object.


To check whether two variables refer to the same object, you can use the `≡` (**`\equiv TAB`**) or `===` operator:

```julia
julia> a = "banana"; 

julia> b = "banana";

julia> a ≡ b 
true
```

In this example, Julia only created one string object, and both `a` and `b` refer to it. But when you create two arrays, you get two objects:

```julia
julia> a = [1, 2, 3]; 

julia> b = [1, 2, 3];

julia> a ≡ b false
```

So the state diagram looks like Figure 10-3.
"""

# ╔═╡ 91741fb0-7ec3-11eb-1c35-03f99160c75d
Drawing(width=720, height=70) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
    rect(x=290, y=10, width=140, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=300, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("a") 
	end
	line(x1=315, y1=25, x2=335, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=350, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("[1, 2, 3]") 
	end
	text(x=300, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("b") 
	end
	line(x1=315, y1=45, x2=335, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=350, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("[1, 2, 3]") 
	end
end

# ╔═╡ fec78276-7ec3-11eb-2876-ebd0e582766f
md"*Figure 10-3. State diagram.*"

# ╔═╡ 0d8047dc-7ec4-11eb-2b0c-91f0a3c01be7
md"""In this case we would say that the two arrays are equivalent, because they have the same elements, but not *identical*, because they are not the same object. If two objects are identical, they are also equivalent, but if they are equivalent, they are not necessarily identical.

To be precise, an object has a value. If you evaluate `[1, 2, 3]`, you get an array object whose value is a sequence of integers. If another array has the same elements, we say it has the same value, but it is not the same object."""

# ╔═╡ 32e15b56-7ec4-11eb-11d1-d576f5f7e355
md"""## Aliasing

If `a` refers to an object and you assign `b = a`, then both variables refer to the same object:

```julia
julia> a = [1, 2, 3]; 

julia> b = a;

julia> b ≡ a 
true
```

The state diagram looks like Figure 10-4.
"""

# ╔═╡ 4ff0e338-7ec4-11eb-15ff-a17321526a29
Drawing(width=720, height=70) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
    rect(x=290, y=10, width=140, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=300, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("a") 
	end
	line(x1=315, y1=25, x2=335, y2=30, stroke="black", marker_end="url(#arrow)")
	text(x=350, y=40, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("[1, 2, 3]") 
	end
	text(x=300, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("b") 
	end
	line(x1=315, y1=45, x2=335, y2=40, stroke="black", marker_end="url(#arrow)")
end

# ╔═╡ 85204788-7ec4-11eb-2337-c7f0728c2c5b
md"""The association of a variable with an object is called a *reference*. In this example, there are two references to the same object.

An object with more than one reference has more than one name, so we say that the object is *aliased*.

If the aliased object is mutable, changes made with one alias affect the other:

```julia
julia> b[1] = 42 
42
julia> print(a) 
[42, 2, 3]
```

!!! danger
    Although this behavior can be useful, it is error-prone. In general, it is safer to avoid aliasing when you are working with mutable objects.

For immutable objects like strings, aliasing is not as much of a problem. In this example:

```julia
a = "banana"
b = "banana"
```

it almost never makes a difference whether `a` and `b` refer to the same string or not.
"""

# ╔═╡ d9c3898a-7ec4-11eb-16de-a547447e325e
md"""## Array Arguments

When you pass an array to a function, the function gets a reference to the array. If the function modifies the array, the caller sees the change. For example, `deletehead!` removes the first element from an array:

```julia
deletehead!(t) = popfirst!(t)
```

Here’s how it is used:

```juli
julia> letters = ['a', 'b', 'c']; 

julia> deletehead!(letters);

julia> print(letters) 
['b', 'c']
```

The parameter `t` and the variable `letters` are aliases for the same object. The stack diagram looks like Figure 10-5.
"""

# ╔═╡ 11e91384-7ec5-11eb-325d-859e008c7cb1
Drawing(width=720, height=90) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=140, y=30, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("Main") 
	end
    rect(x=170, y=10, width=200, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("letters") 
	end
	line(x1=250, y1=25, x2=390, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=140, y=70, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("deletehead!") 
	end
    rect(x=170, y=50, width=200, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("t") 
	end
	line(x1=200, y1=65, x2=390, y2=65, stroke="black", marker_end="url(#arrow)")
	rect(x=400, y=10, width=90, height=70, fill="rgb(242, 242, 242)", stroke="black")
	text(x=410, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=425, y1=25, x2=440, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=455, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'a'") 
	end
	text(x=410, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=425, y1=45, x2=440, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=455, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'b'") 
	end
	text(x=410, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3") 
	end
	line(x1=425, y1=65, x2=440, y2=65, stroke="black", marker_end="url(#arrow)")
	text(x=455, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'c'") 
	end
end

# ╔═╡ e4ab98a4-7ec6-11eb-2293-2f901f40ffb0
md"*Figure 10-5. Stack diagram.*"

# ╔═╡ f68d4f86-7ec6-11eb-167b-cbf4bac179d6
md"""Since the array is shared by two frames, I drew it between them.

It is important to distinguish between operations that modify arrays and operations that create new arrays. For example, push! modifies an array, but vcat creates a new array.

Here’s an example using `push!`: 

```juli
julia> t1 = [1, 2];

julia> t2 = push!(t1, 3); 

julia> print(t1)
[1, 2, 3]
```

`t2` is an alias of `t1`.

Here’s an example using `vcat`:

```julia
julia> t3 = vcat(t1, [4]);

julia> print(t1) 
[1, 2, 3] 
julia> print(t3) 
[1, 2, 3, 4]
```

The result of `vcat` is a new array, and the original array is unchanged.


This difference is important when you write functions that are supposed to modify
arrays.

For example, this function *does not* delete the head of an array:

```julia
function baddeletehead(t)
	t = t[2:end]               # WRONG!
end
```

The slice operator creates a new array and the assignment makes `t` refer to it, but that doesn’t affect the caller:

```julia
julia> t4 = baddeletehead(t3); 

julia> print(t3)
[1, 2, 3, 4]
julia> print(t4) 
[2, 3, 4]
```

At the beginning of `baddeletehead`, `t` and `t3` refer to the same array. At the end, `t` refers to a new array, but `t3` still refers to the original unmodified array.


An alternative is to write a function that creates and returns a new array. For example, `tail` returns all but the first element of an array:

```julia
tail(t) = t[2:end]
```

This function leaves the original array unmodified. Here’s how it is used:

```julia
julia> letters = ['a', 'b', 'c']; 

julia> rest = tail(letters);

julia> print(rest) 
['b', 'c']
```
"""

# ╔═╡ 96e036b0-7ec7-11eb-0308-1d445f8d21fa
md"""## Debugging

Careless use of arrays (and other mutable objects) can lead to long hours of debugging. Here are some common pitfalls and ways to avoid them:

* Most array functions modify the argument. This is the opposite of the string functions, which return a new string and leave the original alone.
  
  If you are used to writing string code like this:
  
  ```julia
  new_word = strip(word)
  ```
  
  It is tempting to write array code like this:
  
  ```julia
  t2 = sort!(t1)
  ```
  
  Because `sort!` returns the modified original array `t1`, `t2` is an alias of `t1`.

  !!! tip 
      Before using array functions and operators, you should read the documentation carefully and then test them in interactive mode.

* Pick an idiom and stick with it.
  
  Part of the problem with arrays is that there are too many ways to do things. For example, to remove an element from an array, you can use `pop!`, `popfirst!`, `delete_at`, or even a slice assignment. To add an element, you can use `push!`, `pushfirst!`, `insert!`, or `vcat`. Assuming that `t` is an array and `x` is an array element, these are correct:
  
  ```julia
  insert!(t, 4, x)
  push!(t, x)
  append!(t, [x])
  ```
  
  And these are wrong:
  
  ```julia
  insert!(t, 4, [x])     # WRONG!
  push!(t, [x])          # WRONG!
  vcat(t, [x])           # WRONG!
  ```

* Make copies to avoid aliasing.
  
  If you want to use a function like sort! that modifies the argument, but you need to keep the original array as well, you can make a copy:
  
  ```julia
  julia> t = [3, 1, 2];
  
  julia> t2 = t[:]; # t2 = copy(t) 
  
  julia> sort!(t2);
  
  julia> print(t) 
  [3, 1, 2] 
  julia> print(t2) 
  [1, 2, 3]
  ```
  
  In this example you could also use the built-in function `sort`, which returns a new sorted array and leaves the original alone:
  
  ```julia
  julia> t2 = sort(t);
  
  julia> println(t) 
  [3, 1, 2]
  julia> println(t2) 
  [1, 2, 3]
  ```
"""

# ╔═╡ eb6f80ea-7ec8-11eb-1b60-916222e958db
md"""## Glossary

*array*:
A sequence of values.

*element*:
One of the values in an array (or other sequence); also called items.

*nested array*:
An array that is an element of another array.

*mutable*:
The property of a value that can be modified.

*augmented assignment*:
A statement that updates the value of a variable using an operator like `=.`

*accumulator*:
A variable used in a loop to add up or accumulate a result.

*reduce operation*:
A processing pattern that traverses a sequence and accumulates the elements into a single result.

*map*:
A processing pattern that traverses a sequence and performs an operation on each element.

*filter*:
A processing pattern that traverses a sequence and selects the elements that sat‐ isfy some criterion.

*dot operator*:
A binary operator that is applied element-by-element to arrays.

*dot syntax*:
Syntax used to apply a function elementwise to any array.

*optional argument*:
An argument that is not required.

*delimiter*:
A character or string used to indicate where a string should be split.

*object*:
Something a variable can refer to. An object has a type and a value.

*equivalent*:
Having the same value.

*identical*:
Being the same object (which implies equivalence).

*reference*:
The association between a variable and its value.

*aliasing*:
A circumstance where two or more variables refer to the same object.
"""

# ╔═╡ 4ac0178a-7ec9-11eb-2e69-51752445551a
md"""## Exercises 

#### Exercise 10-1

Write a function called `nestedsum` that takes an array of arrays of integers and adds up the elements from all of the nested arrays. For example:

```julia
julia> t = [[1, 2], [3], [4, 5, 6]]; 

julia> nestedsum(t)
21
```
"""

# ╔═╡ 6c3c929e-7ec9-11eb-00e3-87c9c28c60bc
md"""#### Exercise 10-2

Write a function called `cumulsum` that takes an array of numbers and returns the cumulative sum; that is, a new array where the ith element is the sum of the first ``i`` elements from the original array. For example:

```julia
julia> t = [1, 2, 3]; 

julia> print(cumulsum(t))
Any[1, 3, 6]
```
"""

# ╔═╡ a81cc482-7ec9-11eb-018d-f933e7d86b01
md"""#### Exercise 10-3

Write a function called `interior` that takes an array and returns a new array that contains all but the first and last elements. For example:

```julia
julia>t=[1,2,3,4]; 

julia> print(interior(t))
[2, 3]
```
"""

# ╔═╡ c1a1c43e-7ec9-11eb-3454-6d078f7a70de
md"""#### Exercise 10-4

Write a function called `interior!` that takes an array, modifies it by removing the first and last elements, and returns `nothing`. For example:

```julia
julia> t=[1,2,3,4]; 

julia> interior!(t)

julia> print(t) 
[2, 3]
```
"""

# ╔═╡ dd4164ce-7ec9-11eb-0504-e3e6966b861b
md"""#### Exercise 10-5

Write a function called `issort` that takes an array as a parameter and returns `true` if the array is sorted in ascending order and `false` otherwise. For example:

```julia
julia> issort([1, 2, 2]) 
true
julia> issort(['b', 'a']) 
false
```
"""

# ╔═╡ 0393e21e-7eca-11eb-1d46-a394c6c31f3f
md"""#### Exercise 10-6

Two words are anagrams if you can rearrange the letters from one to spell the other. Write a function called `isanagram` that takes two strings and returns `true` if they are anagrams.
"""

# ╔═╡ 18bd9022-7eca-11eb-0f83-43fc924505a1
md"""#### Exercise 10-7

Write a function called `hasduplicates` that takes an array and returns `true` if there is any element that appears more than once. It should not modify the original array.
"""

# ╔═╡ 33230758-7eca-11eb-34b6-6b89f1c8afd4
md"""#### Exercise 10-8

This exercise pertains to the so-called Birthday Paradox.

If there are 23 students in your class, what are the chances that 2 of you have the same birthday? You can estimate this probability by generating random samples of 23 birthdays and checking for matches.

!!! tip
    You can generate random birthdays with `rand(1:365)`.
"""

# ╔═╡ 4db45f7c-7eca-11eb-0d84-697b0f34ba19
md"""#### Exercise 10-9

Write two versions of a function that reads the file *words.txt* and builds an array with one element per word, one using `push!` and the other using the idiom `t = [t..., x]`. Which one takes longer to run? Why?
"""

# ╔═╡ 644ba7a4-7eca-11eb-005c-450b665506f8
md"""#### Exercise 10-10

To check whether a word is in the word array you just built, you could use the `∈` operator, but it would be slow because it searches through the words in order.

Because the words are in alphabetical order, we can speed things up with a bisection search (also known as a binary search), which is similar to what you do when you look a word up in the dictionary. You start in the middle and check to see whether the word you are looking for comes before the word in the middle of the array. If so, you search the first half of the array the same way. Otherwise, you search the second half.

Either way, you cut the remaining search space in half. If the word array has 113,809 words, it will take about 17 steps to find the word or conclude that it’s not there.

Write a function called `inbisect` that takes a sorted array and a target value and returns `true` if the word is in the array and `false` if it’s not.
"""

# ╔═╡ 9b0559d6-7eca-11eb-0e90-b35daf751f26
md"""#### Exercise 10-11

Two words are a “reverse pair” if each is the reverse of the other. Write a function `reversepairs` that finds all the reverse pairs in the word array.
"""

# ╔═╡ b70a0e20-7eca-11eb-2181-a3b160b3c369
md"""#### Exercise 10-12

Two words “interlock” if taking alternating letters from each forms a new word. For example, “shoe” and “cold” interlock to form “schooled.”

1. Write a program that finds all pairs of words that interlock.
   
   !!! tip
       Don’t enumerate all pairs!
   
   *Credit*: This exercise is inspired by an example at [http://puzzlers.org](http://puzzlers.org).

2. Can you find any words that are three-way interlocked (i.e., every third letter forms a word, starting from the first, second, or third letter)?
"""

# ╔═╡ Cell order:
# ╟─54f89e42-7eb6-11eb-0a18-79732e59d627
# ╟─21cefe9c-7eb3-11eb-2469-2b7b3d1eccc3
# ╟─62637476-7eb6-11eb-0cb4-01f126c2feb8
# ╟─daca2c98-7eb6-11eb-1c09-8f1e08b31315
# ╟─1b70a1d2-7eb7-11eb-2ab9-6739d60fcf89
# ╟─c41c5b10-7ebb-11eb-06f6-57f0ccbbf9ac
# ╟─d3894a90-7ebb-11eb-0541-133459689a2d
# ╟─1628711e-7ebc-11eb-2cec-f71c338de835
# ╟─9c7423e4-7ebc-11eb-391d-b3388978ea47
# ╟─eadf298e-7ebc-11eb-26e8-65a4f6640fbd
# ╟─5b124fc4-7ebd-11eb-1a06-c9ea65c0953c
# ╟─8b9a193c-7ebe-11eb-3fc3-b76b75cd0186
# ╟─e1966318-7ebe-11eb-37a1-775a6c3621aa
# ╟─53f60b52-7ebf-11eb-140a-75c0c412b628
# ╟─e08fed44-7ebf-11eb-1c6a-55ee8e49968e
# ╟─04e15ba6-7ec0-11eb-3c7d-211e84ba32c0
# ╟─a2a6face-7ec2-11eb-313a-73f3916a14ad
# ╟─b218e204-7ec2-11eb-3321-3f0082f5e74d
# ╟─91741fb0-7ec3-11eb-1c35-03f99160c75d
# ╟─fec78276-7ec3-11eb-2876-ebd0e582766f
# ╟─0d8047dc-7ec4-11eb-2b0c-91f0a3c01be7
# ╟─32e15b56-7ec4-11eb-11d1-d576f5f7e355
# ╟─4ff0e338-7ec4-11eb-15ff-a17321526a29
# ╟─85204788-7ec4-11eb-2337-c7f0728c2c5b
# ╟─d9c3898a-7ec4-11eb-16de-a547447e325e
# ╟─11e91384-7ec5-11eb-325d-859e008c7cb1
# ╟─e4ab98a4-7ec6-11eb-2293-2f901f40ffb0
# ╟─f68d4f86-7ec6-11eb-167b-cbf4bac179d6
# ╟─96e036b0-7ec7-11eb-0308-1d445f8d21fa
# ╟─eb6f80ea-7ec8-11eb-1b60-916222e958db
# ╟─4ac0178a-7ec9-11eb-2e69-51752445551a
# ╟─6c3c929e-7ec9-11eb-00e3-87c9c28c60bc
# ╟─a81cc482-7ec9-11eb-018d-f933e7d86b01
# ╟─c1a1c43e-7ec9-11eb-3454-6d078f7a70de
# ╟─dd4164ce-7ec9-11eb-0504-e3e6966b861b
# ╟─0393e21e-7eca-11eb-1d46-a394c6c31f3f
# ╟─18bd9022-7eca-11eb-0f83-43fc924505a1
# ╟─33230758-7eca-11eb-34b6-6b89f1c8afd4
# ╟─4db45f7c-7eca-11eb-0d84-697b0f34ba19
# ╟─644ba7a4-7eca-11eb-005c-450b665506f8
# ╟─9b0559d6-7eca-11eb-0e90-b35daf751f26
# ╠═b70a0e20-7eca-11eb-2181-a3b160b3c369
