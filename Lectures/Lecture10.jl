### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ 54f89e42-7eb6-11eb-0a18-79732e59d627
begin
	include("../src/chap10.jl")
    import Pkg
	io = IOBuffer()
    Pkg.activate(io = io)
	deps = [pair.second for pair in Pkg.dependencies()]
	direct_deps = filter(p -> p.is_direct_dep, deps)
    pkgs = [x.name for x in direct_deps]
	if "NativeSVG" ∉ pkgs
		Pkg.add(url="https://github.com/BenLauwens/NativeSVG.jl.git")
	end
	using NativeSVG
end

# ╔═╡ 21cefe9c-7eb3-11eb-2469-2b7b3d1eccc3
md"""# Arrays

This chapter presents one of Julia’s most useful built-in types, the array. You will also learn about objects and what can happen when you have more than one name for the same object."""

# ╔═╡ 62637476-7eb6-11eb-0cb4-01f126c2feb8
md"""## An Array Is a Sequence

Like a string, an *array* is a sequence of values. In a string, the values are characters; in an array, they can be any type. The values in an array are called *elements* or sometimes *items*.

There are several ways to create a new array; the simplest is to enclose the elements in square brackets (`[ ]`):
"""

# ╔═╡ 3bd528a6-b592-4448-b2b4-2e49fec5f96d
[10, 20, 30, 40]

# ╔═╡ d3ec8bc4-1990-46d2-ba5e-79f270f0de3d
["crunchy frog", "ram bladder", "lark vomit"]

# ╔═╡ 23dca6d3-d420-4ed0-929d-136241d7fb08
md"""The first example is an array of four integers. The second is an array of three strings. The elements of an array don’t have to be the same type. The following array contains a string, a float, an integer, and another array:
"""

# ╔═╡ 3b629903-9c79-4f12-9e9f-d6b169d76b9a
["spam", 2.0, 5, [10, 20]]

# ╔═╡ a7fa0a07-fe15-448b-a447-486353f88f9c
md"""An array within another array is *nested*.

An array that contains no elements is called an empty array; you can create one with empty brackets, `[]`.

As you might expect, you can assign array values to variables:
"""

# ╔═╡ 3e966a69-e5db-425e-b5c6-4c713f25ed26
begin
	cheeses = ["Cheddar", "Edam", "Gouda"]
	numbers = [42, 123]
	empty = []
	@show cheeses numbers empty
end

# ╔═╡ 9457c9a9-5019-4826-b5e2-8ad57e7f9dd8
md"""The function `typeof` can be used to find out the type of the array:
"""

# ╔═╡ 2c0bb6df-f85c-4a67-9dea-ca375d78758e
typeof(cheeses)

# ╔═╡ f32c3145-6bf1-49f1-957e-0d97b46a9d18
typeof(numbers)

# ╔═╡ d068cbee-d360-462a-978e-7b33c53510c6
typeof(empty)

# ╔═╡ 0553388c-42b2-4a14-b345-8ddff64010fe
md"""The number indicates the dimensions (we’ll talk more about this in “Arrays”). The array `empty` contains values of type `Any`; that is, it can hold values of all types.
"""

# ╔═╡ daca2c98-7eb6-11eb-1c09-8f1e08b31315
md"""## Arrays Are Mutable

The syntax for accessing the elements of an array is the same as for accessing the characters of a string—using the bracket operator. The expression inside the brackets specifies the index. Remember that the indices start at 1:
"""

# ╔═╡ ac3b1d75-d99d-4df5-8d01-d8c4af79bdfb
cheeses[1]

# ╔═╡ ceb4b7d3-4aaa-4a60-97a7-128dd7cacf09
md"""Unlike strings, arrays are *mutable*; that is, their values can be changed. When the bracket operator appears on the left side of an assignment, it identifies the element of the array that will be assigned:
"""

# ╔═╡ 864e21d6-657d-4fdc-9064-54f6d81848ad
begin 
	numbers[2] = 5
	numbers
end

# ╔═╡ 10d2d8a5-56f1-4316-9fb9-c90768911ffc
md"""The second element of `numbers`, which used to be `123`, is now `5`. Figure 10-1 shows the state diagrams for `cheeses`, `numbers`, and `empty`.
"""

# ╔═╡ 1b70a1d2-7eb7-11eb-2ab9-6739d60fcf89
Drawing(width=720, height=230) do
	@info "State diagram."
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

# ╔═╡ d3894a90-7ebb-11eb-0541-133459689a2d
md"""Arrays are represented by boxes with the elements of the array inside them. `cheeses` refers to an array with three elements indexed: 1, 2, and 3. `numbers` contains two elements; the diagram shows that the value of the second element has been reassigned from `123` to `5`. `empty` refers to an array with no elements.


Array indices work the same way as string indices (but without UTF-8 caveats):

- Any integer expression can be used as an index.
- If you try to read or write an element that does not exist, you get a BoundsError.
- The keyword end points to the last index of the array.

The `∈` operator also works on arrays:
"""

# ╔═╡ d579333e-f6bb-4c31-bec7-4dc49890ee87
"Edam" ∈ cheeses

# ╔═╡ 2d67d0c2-ccc3-4b5f-86d3-0c7b71f8d865
"Brie" in cheeses

# ╔═╡ 1628711e-7ebc-11eb-2cec-f71c338de835
md"""## Traversing an Array

The most common way to traverse the elements of an array is with a `for` loop. The syntax is the same as for strings:
"""

# ╔═╡ b08ef8b5-5cb1-4c33-a95d-4d4265b9452a
for cheese in cheeses
	println(cheese)
end

# ╔═╡ 69dc8391-75b8-42a5-b6e0-92675c2a19ca
md"""This works well if you only need to read the elements of the array. But if you want to write or update the elements, you need the indices. One technique is to use the built-in function `eachindex`:
"""

# ╔═╡ 415c6083-3448-41c4-a487-b2e2185aa437
for i in eachindex(numbers)
	numbers[i] = numbers[i] * 2
end

# ╔═╡ b442e711-0564-442a-bcba-282df94d5d4e
md"""This loop traverses the array and updates each element. Each time through the loop `i` gets the index of the next element. The assignment statement in the body uses `i` to read the old value of the element and to assign the new value.

A `for` loop over an empty array never runs the body:
"""

# ╔═╡ 1d19d278-0fbe-4a29-8de0-bbc44fe7680c
for x in []
	println("This can never happen.")
end

# ╔═╡ 19b839b6-60da-4955-aa73-8355eb302e6d
md"""Although an array can contain another array, the nested array still counts as a single element. The length of this array is 4:
"""

# ╔═╡ b2adf553-57fd-48f0-8101-81e9fd39beeb
length(["spam", 1, ["Brie", "Roquefort", "Camembert"], [1, 2, 3]])

# ╔═╡ 9c7423e4-7ebc-11eb-391d-b3388978ea47
md"""## Array Slices

The slice operator (`[n:m]`) also works on arrays:
"""

# ╔═╡ 34828da9-2a0e-4fb2-bfb2-eaadcdfdc767
begin
	t = ['a', 'b', 'c', 'd', 'e', 'f']
	@show t[1:3] t[3:end]
end;

# ╔═╡ 5444f8c0-f682-42d2-8efa-d19b0914e49b
md"""Using the slice operator without arguments makes a copy of the whole array:
"""

# ╔═╡ ff5e00e5-4b4e-47ee-863f-1af4e5cf5c09
t[:]

# ╔═╡ c2c75863-2694-49bf-b352-c6e610449e48
md"""Since arrays are mutable, it is often useful to make a copy before performing operations that modify arrays.

A slice operator on the left side of an assignment can update multiple elements:
"""

# ╔═╡ 71f768ef-4561-4e7d-9d17-a4d1b5c06bb2
begin
	t[2:3] = ['x', 'y']
	t
end

# ╔═╡ eadf298e-7ebc-11eb-26e8-65a4f6640fbd
md"""## Array Library

Julia provides functions that operate on arrays. For example, `push!` adds a new element to the end of an array:
"""

# ╔═╡ 4be9d49e-67b6-4574-9a69-dfc906470b1f
let
	t = ['a', 'b', 'c']
	push!(t, 'd')
	t
end

# ╔═╡ 24920891-4d02-4959-ae64-3c48cf26159d
md"""`append!` adds the elements of the second array to the end of the first:
"""

# ╔═╡ 4bc12745-b0f7-4748-ad80-d41e64293b0d
let
	t1 = ['a', 'b', 'c']
	t2 = ['d', 'e']
	append!(t1, t2)
	t1
end

# ╔═╡ e3d3be62-77d1-4931-b373-1ba0e10d46c1
md"""This example leaves `t2` unmodified.

`sort!` arranges the elements of the array from low to high:
"""

# ╔═╡ 017746a5-12e6-48b1-a630-63bef80c4138
let
	t = ['d', 'c', 'e', 'b', 'a']
	sort!(t)
	t
end

# ╔═╡ 9b317f1b-a622-45c0-9846-93d628ee3f1e
md"""`sort` returns a copy of the elements of the array in order:
"""

# ╔═╡ 37398b39-e173-4ba0-a2b6-fc99ef1dd302
let
	t1 = ['d', 'c', 'e', 'b', 'a']
	t2 = sort(t1)
	@show t1 t2
end;

# ╔═╡ 3dffdcb0-b5aa-432f-8948-9c0fdd141870
md"""!!! tip
    As a style convention in Julia, `!` is appended to names of functions that modify their arguments.
"""

# ╔═╡ 5b124fc4-7ebd-11eb-1a06-c9ea65c0953c
md"""## Map, Filter, and Reduce

To add up all the numbers in an array, you can use a loop like this:
"""

# ╔═╡ 569d9821-3ff2-4d25-a2e4-93c74ae1f548
function addall(t)
	total = 0
	for x in t
		total += x
	end
	return total
end

# ╔═╡ a4670c74-15a9-4000-b5b0-06536fbc5ba4
md"""`total` is initialized to 0. Each time through the loop, `x` gets one element from the array. The `+=` operator provides a short way to update a variable. This *augmented assignment statement*:

```julia
total += x
```

is equivalent to:

```julia
total = total + x
```

As the loop runs, `total` accumulates the sum of the elements; a variable used this way is sometimes called an *accumulator*.

Adding up the elements of an array is such a common operation that Julia provides it
as a built-in function, `sum`:
"""

# ╔═╡ e1c4ac8c-374e-4c14-8ac7-0f371fd41182
let
	t = [1,2,3,4]
	sum(t)
end

# ╔═╡ 2ef81cc1-b576-4899-9882-a37e8fb315e5
md"""An operation like this that combines a sequence of elements into a single value is sometimes called a *reduce operation*.

Often you want to traverse one array while building another. For example, the following function takes an array of strings and returns a new array that contains capitalized strings:
"""

# ╔═╡ 5f6844e6-6eb4-4b80-bcce-38b5af2d376f
function capitalizeall(t)
	ret = []
	for s in t
		push!(ret, uppercase(s))
	end
	return ret
end

# ╔═╡ 4c2aa623-e204-451e-bab3-8a7d3d092867
md"""`res` is initialized with an empty array; each time through the loop, we append the next element. So, `res` is another kind of accumulator.

An operation like `capitalizeall` is sometimes called a *map* because it “maps” a function (in this case `uppercase`) onto each of the elements in a sequence.

Another common operation is to select some of the elements from an array and return a subarray. For example, the following function takes an array of strings and returns an array that contains only the uppercase strings:
"""

# ╔═╡ d6808321-374e-4777-ad65-d6e7809674b4
function onlyupper(t)
	ret = []
	for s in t
		if s == uppercase(s)
			push!(ret, s)
		end
	end
	return ret
end

# ╔═╡ 39d4cc75-8054-412a-90cf-2734fc81b5be
md"""An operation like `onlyupper` is called a *filter* because it selects some of the elements and filters out the others.

Most common array operations can be expressed as a combination of map, filter, and reduce.
"""

# ╔═╡ 8b9a193c-7ebe-11eb-3fc3-b76b75cd0186
md"""## Dot Syntax

For every binary operator, like `^`, there is a corresponding *dot operator*, like `.^`, that is automatically defined to perform the operation element-by-element on arrays. For example, `[1, 2, 3] ^ 3` is not defined, but `[1, 2, 3] .^ 3` is defined as computing the elementwise result `[1^3, 2^3, 3^3]`:
"""

# ╔═╡ f1194b4b-f195-4e89-a2c8-ef8e11bf3c4b
[1, 2, 3] .^ 3

# ╔═╡ bccce7bb-c3e9-49ee-83d6-ad83af13213f
md"""Any Julia function `f` can be applied elementwise to any array with the *dot syntax*. For example, to capitalize an array of strings, we don’t need an explicit loop:
"""

# ╔═╡ 5ec73860-752d-4019-adc7-f280cbecb7c5
uppercase.(["abc", "def", "ghi"])

# ╔═╡ 0a10bbd1-7caa-4717-b9f4-21dbbc8c991e
md"""This is an elegant way to create a map. The function `capitalizeall` can be implemented by a one-liner:
"""

# ╔═╡ bf6b2383-8d82-495f-b188-a1ff78e220dc
capitalizeall_alternative(t) = uppercase.(t)

# ╔═╡ e1966318-7ebe-11eb-37a1-775a6c3621aa
md"""## Deleting (Inserting) Elements

There are several ways to delete elements from an array. If you know the index of the element you want, you can use `splice!`:
"""

# ╔═╡ 2a6852f0-ce43-45a8-8455-7b1bc8c61240
let
	t = ['a', 'b', 'c'];
	@show splice!(t, 2)
	t
end

# ╔═╡ c5d3b7b2-671b-4449-bdf4-ca49fcd5eaf6
md"""`splice!` modifies the array and returns the element that was removed.

`pop!` deletes and returns the last element:
"""

# ╔═╡ 84044848-0a4d-4648-be77-18f1fef8ed6c
let
	t = ['a', 'b', 'c'];
	@show pop!(t)
	t
end

# ╔═╡ 0fd96040-f69a-4e9f-80cb-f4e6b6bc1b2f
md"""`popfirst!` deletes and returns the first element:
"""

# ╔═╡ 5fc64564-ba40-48e8-a335-408e6f76b5e0
let
	t = ['a', 'b', 'c'];
	@show popfirst!(t)
	t
end

# ╔═╡ cffc35f7-7aa8-4252-bc2a-dce31be2b7aa
md"""The functions `pushfirst!` and `push!` insert an element at the beginning and end, respectively, of the array.

If you don’t need the removed value, you can use the function `deleteat!`:
"""

# ╔═╡ 40a69b0b-e2ba-4bc2-9bef-73730050d98e
let
	t = ['a', 'b', 'c']
	deleteat!(t, 2)
end

# ╔═╡ 544f4aa4-d5a3-4ab6-a075-7ecd544fc04d
md"""The function `insert!` inserts an element at a given index:
"""

# ╔═╡ ac5ff768-de94-4b44-8352-b38554a6c9de
let
	t = ['a', 'b', 'c']
	insert!(t, 2, 'x')
end

# ╔═╡ 53f60b52-7ebf-11eb-140a-75c0c412b628
md"""## Arrays and Strings

A string is a sequence of characters and an array is a sequence of values, but an array of characters is not the same as a string. To convert from a string to an array of characters, you can use the function `collect`:
"""

# ╔═╡ aadd5989-c101-40fe-ac1b-f9368aba21bc
collect("spam")

# ╔═╡ 85f9df0b-71be-4195-b20a-02a68cdf1b7c
md"""The `collect` function breaks a string or another sequence into individual elements.

If you want to break a string into words, you can use the `split` function:
"""

# ╔═╡ 6f6d5c47-7190-4c1a-a27f-0a0c60890ad8
split("pining for the fjords")

# ╔═╡ cc9e9b42-5ce2-4c46-9d29-76ad754af0a3
md"""An *optional argument* called a *delimiter* specifies which characters to use as word boundaries (we talked briefly about optional arguments in “Exercise 8-7”). The following example uses a hyphen as a delimiter:
"""

# ╔═╡ f604b971-0edc-4219-9438-58754a00c6a1
split("spam-spam-spam", '-')

# ╔═╡ 8d074dd4-2080-47e6-89b2-70df556a7605
md"""`join` is the inverse of `split`. It takes an array of strings and concatenates the elements:
"""

# ╔═╡ 53534f47-450e-44c5-9ae9-e2fdeb9a079b
let
	t = ["pining", "for", "the", "fjords"]
	join(t, ' ')
end

# ╔═╡ 71c297aa-0e32-4946-91f9-4887ee21e26e
md"""In this case the delimiter is a space character. To concatenate strings without spaces, you don’t specify a delimiter.
"""

# ╔═╡ e08fed44-7ebf-11eb-1c6a-55ee8e49968e
md"""## Objects and Values

An *object* is something a variable can refer to. Until now, you might have used “object” and “value” interchangeably.

If we run these assignment statements:
"""

# ╔═╡ c1838f14-b534-41dc-82bc-24c5f793feee
begin
	a = "banana"
	b = "banana"
end;

# ╔═╡ 77fbf578-1d81-4150-9c37-bf94218db3dc
md"""we know that `a` and `b` both refer to a string, but we don’t know whether they refer to the same string. There are two possible states, as shown in Figure 10-2.
"""

# ╔═╡ 04e15ba6-7ec0-11eb-3c7d-211e84ba32c0
Drawing(width=720, height=70) do
	@info "State diagrams."
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

# ╔═╡ b218e204-7ec2-11eb-3321-3f0082f5e74d
md"""In one case, `a` and `b` refer to two different objects that have the same value. In the second case, they refer to the same object.


To check whether two variables refer to the same object, you can use the `≡` (**`\equiv TAB`**) or `===` operator:
"""

# ╔═╡ c98bf7fc-a169-4b09-9b56-29dd5b93d74b
a ≡ b

# ╔═╡ 1a358e62-536f-4257-b929-f541639aa009
md"""In this example, Julia only created one string object, and both `a` and `b` refer to it. But when you create two arrays, you get two objects:
"""

# ╔═╡ 610582c1-446a-44b3-bd99-e78af0eb83af
let
	a = [1, 2, 3]
	b = [1, 2, 3]
	a ≡ b
end

# ╔═╡ 6145fac7-b479-40b1-a7a3-1f847c94a2c0
md"""So the state diagram looks like Figure 10-3.
"""

# ╔═╡ 91741fb0-7ec3-11eb-1c35-03f99160c75d
Drawing(width=720, height=70) do
	@info "State diagram."
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

# ╔═╡ 0d8047dc-7ec4-11eb-2b0c-91f0a3c01be7
md"""In this case we would say that the two arrays are equivalent, because they have the same elements, but not *identical*, because they are not the same object. If two objects are identical, they are also equivalent, but if they are equivalent, they are not necessarily identical.

To be precise, an object has a value. If you evaluate `[1, 2, 3]`, you get an array object whose value is a sequence of integers. If another array has the same elements, we say it has the same value, but it is not the same object."""

# ╔═╡ 32e15b56-7ec4-11eb-11d1-d576f5f7e355
md"""## Aliasing

If `a` refers to an object and you assign `b = a`, then both variables refer to the same object:
"""

# ╔═╡ 947ef1bb-d36f-4a1b-bcb4-2c3fbc3cdcaa
let
	a = [1, 2, 3]
	b = a
	b ≡ a
end

# ╔═╡ 88658a51-3857-4a9d-b734-d94274a82a42
md"""The state diagram looks like Figure 10-4.
"""

# ╔═╡ 4ff0e338-7ec4-11eb-15ff-a17321526a29
Drawing(width=720, height=70) do
	@info "State diagram."
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
"""

# ╔═╡ 8f3737a3-ff90-4b29-babd-81076efb798f
let 
	a = [1, 2, 3]
	b = a
	b[1] = 42
	a
end

# ╔═╡ 6eb47dbb-c77e-47f4-b2e4-2ccd028cc613
md"""!!! danger
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
"""

# ╔═╡ b9035333-7bbf-4988-ab45-8c70556efbb1
deletehead!(t) = popfirst!(t)

# ╔═╡ b7e73564-de21-473b-b432-c565eb83a8f3
md"""Here’s how it is used:
"""

# ╔═╡ 44939ae4-f59c-4eb3-9223-71633e56c3fc
let
	letters = ['a', 'b', 'c']
	deletehead!(letters)
	letters
end

# ╔═╡ 6a3b1047-992e-4bb3-bc32-514ce89efb88
md"""The parameter `t` and the variable `letters` are aliases for the same object. The stack diagram looks like Figure 10-5.
"""

# ╔═╡ 11e91384-7ec5-11eb-325d-859e008c7cb1
Drawing(width=720, height=90) do
	@info "Stack diagram."
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

# ╔═╡ f68d4f86-7ec6-11eb-167b-cbf4bac179d6
md"""Since the array is shared by two frames, I drew it between them.

It is important to distinguish between operations that modify arrays and operations that create new arrays. For example, push! modifies an array, but vcat creates a new array.

Here’s an example using `push!`:
"""

# ╔═╡ 6c358018-7efb-4ca0-a4f4-dc5d63d74697
let
	t1 = [1, 2]
	t2 = push!(t1, 3)
	t1
end

# ╔═╡ 3daedba9-54b7-47b1-953b-ce7aa9adea8f
md"""`t2` is an alias of `t1`.

Here’s an example using `vcat`:
"""

# ╔═╡ 793cb793-76ca-4c19-80bc-dcb4fc3f50a2
let
	t1 = [1, 2]
	t2 = vcat(t1, 3)
	t1
end

# ╔═╡ f8449e34-97b7-4919-868c-d01c7aac6d7b
md"""The result of `vcat` is a new array, and the original array is unchanged.


This difference is important when you write functions that are supposed to modify arrays.

For example, this function *does not* delete the head of an array:
"""

# ╔═╡ 07520673-531f-40c9-a2a4-5336d1b80697
function baddeletehead(t)
	t = t[2:end]               # WRONG!
end

# ╔═╡ 6128fd83-7b4b-4d23-beb6-9ddcb720850b
md"""The slice operator creates a new array and the assignment makes `t` refer to it, but that doesn’t affect the caller:
"""

# ╔═╡ 1f2f0428-35fd-4c86-b193-234e4698c4cd
let
	t1 = [1, 2, 3, 4]
	@show baddeletehead(t1)
	t1
end

# ╔═╡ c7b8633e-ef48-4575-93e2-f3ed76967df0
md"""At the beginning of `baddeletehead`, `t1` and `t` refer to the same array. At the end, `t` refers to a new array, but `t1` still refers to the original unmodified array.

An alternative is to write a function that creates and returns a new array. For example, `tail` returns all but the first element of an array:
"""

# ╔═╡ 6cb0468f-92df-4e06-b6c6-196354d9a8c2
tail(t) = t[2:end]

# ╔═╡ 658e704a-37e6-40bc-bf83-2360b2670101
md"""This function leaves the original array unmodified. Here’s how it is used:
"""

# ╔═╡ dad9d83b-2dc8-43bc-9fb4-2dad0d264fe5
let
	letters = ['a', 'b', 'c']
	tail(letters)
end

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
"""

# ╔═╡ 4ec3992f-ebc4-42db-ad59-61d1befb3fa7
let
	t1 = [3, 1, 2]
	t2 = t1[:] # t2 = copy(t)
	sort!(t2)
	@show t1 t2
end;

# ╔═╡ 5ee8da4d-34d4-43a9-9221-097a912b70b4
md"""!!! tip
    In this example you could also use the built-in function `sort`, which returns a new sorted array and leaves the original alone:
"""

# ╔═╡ 5f4d9fb9-f926-4b0b-a178-0485d1284ea2
let
	t1 = [3, 1, 2]
	t2 = sort(t1)
	@show t1 t2
end;

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
A processing pattern that traverses a sequence and selects the elements that satisfy some criterion.

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

### Exercise 10-1

Write a function called `nestedsum` that takes an array of arrays of integers and adds up the elements from all of the nested arrays. For example:
"""

# ╔═╡ 629b96af-7346-4b7c-98a9-da1de936fbcf
let
	t = [[1, 2], [3], [4, 5, 6]]
	nestedsum(t)
end

# ╔═╡ 6c3c929e-7ec9-11eb-00e3-87c9c28c60bc
md"""### Exercise 10-2

Write a function called `cumulsum` that takes an array of numbers and returns the cumulative sum; that is, a new array where the ith element is the sum of the first ``i`` elements from the original array. For example:
"""

# ╔═╡ 058e7062-a8d5-4cdc-bba5-1972d28849a3
let
	t = [1, 2, 3]
	cumulsum(t)
end

# ╔═╡ a81cc482-7ec9-11eb-018d-f933e7d86b01
md"""### Exercise 10-3

Write a function called `interior` that takes an array and returns a new array that contains all but the first and last elements. For example:
"""

# ╔═╡ 608ce9a0-a623-494d-8f0e-9f079cf6cf9a
let
	t = [1, 2, 3, 4]
	interior(t)
end

# ╔═╡ c1a1c43e-7ec9-11eb-3454-6d078f7a70de
md"""### Exercise 10-4

Write a function called `interior!` that takes an array, modifies it by removing the first and last elements, and returns `nothing`. For example:
"""

# ╔═╡ b43a74d8-97bb-410a-9a0b-917e35ece8ed
let
	t = [1, 2, 3, 4]
	@show interior!(t)
	t
end

# ╔═╡ dd4164ce-7ec9-11eb-0504-e3e6966b861b
md"""### Exercise 10-5

Write a function called `issort` that takes an array as a parameter and returns `true` if the array is sorted in ascending order and `false` otherwise. For example:
"""

# ╔═╡ 258d972b-97dd-4687-8ecc-d3185e18bb01
issort([1, 2, 2])

# ╔═╡ 07503e96-6309-4521-a322-52854ed0165f
issort(['b', 'a'])

# ╔═╡ 0393e21e-7eca-11eb-1d46-a394c6c31f3f
md"""### Exercise 10-6

Two words are anagrams if you can rearrange the letters from one to spell the other. Write a function called `isanagram` that takes two strings and returns `true` if they are anagrams.
"""

# ╔═╡ 18bd9022-7eca-11eb-0f83-43fc924505a1
md"""### Exercise 10-7

Write a function called `hasduplicates` that takes an array and returns `true` if there is any element that appears more than once. It should not modify the original array.
"""

# ╔═╡ 33230758-7eca-11eb-34b6-6b89f1c8afd4
md"""### Exercise 10-8

This exercise pertains to the so-called Birthday Paradox.

If there are 23 students in your class, what are the chances that 2 of you have the same birthday? You can estimate this probability by generating random samples of 23 birthdays and checking for matches.

!!! tip
    You can generate random birthdays with `rand(1:365)`.
"""

# ╔═╡ 4db45f7c-7eca-11eb-0d84-697b0f34ba19
md"""### Exercise 10-9

Write two versions of a function that reads the file *words.txt* and builds an array with one element per word, one using `push!` and the other using the idiom `t = [t..., x]`. Which one takes longer to run? Why?
"""

# ╔═╡ 644ba7a4-7eca-11eb-005c-450b665506f8
md"""### Exercise 10-10

To check whether a word is in the word array you just built, you could use the `∈` operator, but it would be slow because it searches through the words in order.

Because the words are in alphabetical order, we can speed things up with a bisection search (also known as a binary search), which is similar to what you do when you look a word up in the dictionary. You start in the middle and check to see whether the word you are looking for comes before the word in the middle of the array. If so, you search the first half of the array the same way. Otherwise, you search the second half.

Either way, you cut the remaining search space in half. If the word array has 113,809 words, it will take about 17 steps to find the word or conclude that it’s not there.

Write a function called `inbisect` that takes a sorted array and a target value and returns `true` if the word is in the array and `false` if it’s not.
"""

# ╔═╡ 9b0559d6-7eca-11eb-0e90-b35daf751f26
md"""### Exercise 10-11

Two words are a “reverse pair” if each is the reverse of the other. Write a function `reversepairs` that finds all the reverse pairs in the word array.
"""

# ╔═╡ b70a0e20-7eca-11eb-2181-a3b160b3c369
md"""### Exercise 10-12

Two words “interlock” if taking alternating letters from each forms a new word. For example, “shoe” and “cold” interlock to form “schooled.”

1. Write a program that finds all pairs of words that interlock.

   !!! tip
       Don’t enumerate all pairs!

   *Credit*: This exercise is inspired by an example at [http://puzzlers.org](http://puzzlers.org).

2. Can you find any words that are three-way interlocked (i.e., every third letter forms a word, starting from the first, second, or third letter)?
"""

# ╔═╡ Cell order:
# ╠═54f89e42-7eb6-11eb-0a18-79732e59d627
# ╟─21cefe9c-7eb3-11eb-2469-2b7b3d1eccc3
# ╟─62637476-7eb6-11eb-0cb4-01f126c2feb8
# ╠═3bd528a6-b592-4448-b2b4-2e49fec5f96d
# ╠═d3ec8bc4-1990-46d2-ba5e-79f270f0de3d
# ╟─23dca6d3-d420-4ed0-929d-136241d7fb08
# ╠═3b629903-9c79-4f12-9e9f-d6b169d76b9a
# ╟─a7fa0a07-fe15-448b-a447-486353f88f9c
# ╠═3e966a69-e5db-425e-b5c6-4c713f25ed26
# ╟─9457c9a9-5019-4826-b5e2-8ad57e7f9dd8
# ╠═2c0bb6df-f85c-4a67-9dea-ca375d78758e
# ╠═f32c3145-6bf1-49f1-957e-0d97b46a9d18
# ╠═d068cbee-d360-462a-978e-7b33c53510c6
# ╟─0553388c-42b2-4a14-b345-8ddff64010fe
# ╟─daca2c98-7eb6-11eb-1c09-8f1e08b31315
# ╠═ac3b1d75-d99d-4df5-8d01-d8c4af79bdfb
# ╟─ceb4b7d3-4aaa-4a60-97a7-128dd7cacf09
# ╠═864e21d6-657d-4fdc-9064-54f6d81848ad
# ╟─10d2d8a5-56f1-4316-9fb9-c90768911ffc
# ╟─1b70a1d2-7eb7-11eb-2ab9-6739d60fcf89
# ╟─d3894a90-7ebb-11eb-0541-133459689a2d
# ╠═d579333e-f6bb-4c31-bec7-4dc49890ee87
# ╠═2d67d0c2-ccc3-4b5f-86d3-0c7b71f8d865
# ╟─1628711e-7ebc-11eb-2cec-f71c338de835
# ╠═b08ef8b5-5cb1-4c33-a95d-4d4265b9452a
# ╟─69dc8391-75b8-42a5-b6e0-92675c2a19ca
# ╠═415c6083-3448-41c4-a487-b2e2185aa437
# ╟─b442e711-0564-442a-bcba-282df94d5d4e
# ╠═1d19d278-0fbe-4a29-8de0-bbc44fe7680c
# ╟─19b839b6-60da-4955-aa73-8355eb302e6d
# ╠═b2adf553-57fd-48f0-8101-81e9fd39beeb
# ╟─9c7423e4-7ebc-11eb-391d-b3388978ea47
# ╠═34828da9-2a0e-4fb2-bfb2-eaadcdfdc767
# ╟─5444f8c0-f682-42d2-8efa-d19b0914e49b
# ╠═ff5e00e5-4b4e-47ee-863f-1af4e5cf5c09
# ╟─c2c75863-2694-49bf-b352-c6e610449e48
# ╠═71f768ef-4561-4e7d-9d17-a4d1b5c06bb2
# ╟─eadf298e-7ebc-11eb-26e8-65a4f6640fbd
# ╟─4be9d49e-67b6-4574-9a69-dfc906470b1f
# ╟─24920891-4d02-4959-ae64-3c48cf26159d
# ╠═4bc12745-b0f7-4748-ad80-d41e64293b0d
# ╟─e3d3be62-77d1-4931-b373-1ba0e10d46c1
# ╠═017746a5-12e6-48b1-a630-63bef80c4138
# ╟─9b317f1b-a622-45c0-9846-93d628ee3f1e
# ╠═37398b39-e173-4ba0-a2b6-fc99ef1dd302
# ╟─3dffdcb0-b5aa-432f-8948-9c0fdd141870
# ╟─5b124fc4-7ebd-11eb-1a06-c9ea65c0953c
# ╠═569d9821-3ff2-4d25-a2e4-93c74ae1f548
# ╟─a4670c74-15a9-4000-b5b0-06536fbc5ba4
# ╠═e1c4ac8c-374e-4c14-8ac7-0f371fd41182
# ╟─2ef81cc1-b576-4899-9882-a37e8fb315e5
# ╠═5f6844e6-6eb4-4b80-bcce-38b5af2d376f
# ╟─4c2aa623-e204-451e-bab3-8a7d3d092867
# ╠═d6808321-374e-4777-ad65-d6e7809674b4
# ╟─39d4cc75-8054-412a-90cf-2734fc81b5be
# ╟─8b9a193c-7ebe-11eb-3fc3-b76b75cd0186
# ╠═f1194b4b-f195-4e89-a2c8-ef8e11bf3c4b
# ╟─bccce7bb-c3e9-49ee-83d6-ad83af13213f
# ╠═5ec73860-752d-4019-adc7-f280cbecb7c5
# ╟─0a10bbd1-7caa-4717-b9f4-21dbbc8c991e
# ╠═bf6b2383-8d82-495f-b188-a1ff78e220dc
# ╟─e1966318-7ebe-11eb-37a1-775a6c3621aa
# ╠═2a6852f0-ce43-45a8-8455-7b1bc8c61240
# ╟─c5d3b7b2-671b-4449-bdf4-ca49fcd5eaf6
# ╠═84044848-0a4d-4648-be77-18f1fef8ed6c
# ╟─0fd96040-f69a-4e9f-80cb-f4e6b6bc1b2f
# ╠═5fc64564-ba40-48e8-a335-408e6f76b5e0
# ╟─cffc35f7-7aa8-4252-bc2a-dce31be2b7aa
# ╠═40a69b0b-e2ba-4bc2-9bef-73730050d98e
# ╟─544f4aa4-d5a3-4ab6-a075-7ecd544fc04d
# ╠═ac5ff768-de94-4b44-8352-b38554a6c9de
# ╟─53f60b52-7ebf-11eb-140a-75c0c412b628
# ╠═aadd5989-c101-40fe-ac1b-f9368aba21bc
# ╟─85f9df0b-71be-4195-b20a-02a68cdf1b7c
# ╠═6f6d5c47-7190-4c1a-a27f-0a0c60890ad8
# ╟─cc9e9b42-5ce2-4c46-9d29-76ad754af0a3
# ╠═f604b971-0edc-4219-9438-58754a00c6a1
# ╟─8d074dd4-2080-47e6-89b2-70df556a7605
# ╠═53534f47-450e-44c5-9ae9-e2fdeb9a079b
# ╟─71c297aa-0e32-4946-91f9-4887ee21e26e
# ╟─e08fed44-7ebf-11eb-1c6a-55ee8e49968e
# ╠═c1838f14-b534-41dc-82bc-24c5f793feee
# ╟─77fbf578-1d81-4150-9c37-bf94218db3dc
# ╟─04e15ba6-7ec0-11eb-3c7d-211e84ba32c0
# ╟─b218e204-7ec2-11eb-3321-3f0082f5e74d
# ╠═c98bf7fc-a169-4b09-9b56-29dd5b93d74b
# ╟─1a358e62-536f-4257-b929-f541639aa009
# ╠═610582c1-446a-44b3-bd99-e78af0eb83af
# ╟─6145fac7-b479-40b1-a7a3-1f847c94a2c0
# ╟─91741fb0-7ec3-11eb-1c35-03f99160c75d
# ╟─0d8047dc-7ec4-11eb-2b0c-91f0a3c01be7
# ╟─32e15b56-7ec4-11eb-11d1-d576f5f7e355
# ╠═947ef1bb-d36f-4a1b-bcb4-2c3fbc3cdcaa
# ╟─88658a51-3857-4a9d-b734-d94274a82a42
# ╟─4ff0e338-7ec4-11eb-15ff-a17321526a29
# ╟─85204788-7ec4-11eb-2337-c7f0728c2c5b
# ╠═8f3737a3-ff90-4b29-babd-81076efb798f
# ╟─6eb47dbb-c77e-47f4-b2e4-2ccd028cc613
# ╟─d9c3898a-7ec4-11eb-16de-a547447e325e
# ╠═b9035333-7bbf-4988-ab45-8c70556efbb1
# ╟─b7e73564-de21-473b-b432-c565eb83a8f3
# ╠═44939ae4-f59c-4eb3-9223-71633e56c3fc
# ╟─6a3b1047-992e-4bb3-bc32-514ce89efb88
# ╟─11e91384-7ec5-11eb-325d-859e008c7cb1
# ╟─f68d4f86-7ec6-11eb-167b-cbf4bac179d6
# ╠═6c358018-7efb-4ca0-a4f4-dc5d63d74697
# ╟─3daedba9-54b7-47b1-953b-ce7aa9adea8f
# ╠═793cb793-76ca-4c19-80bc-dcb4fc3f50a2
# ╟─f8449e34-97b7-4919-868c-d01c7aac6d7b
# ╠═07520673-531f-40c9-a2a4-5336d1b80697
# ╟─6128fd83-7b4b-4d23-beb6-9ddcb720850b
# ╠═1f2f0428-35fd-4c86-b193-234e4698c4cd
# ╟─c7b8633e-ef48-4575-93e2-f3ed76967df0
# ╠═6cb0468f-92df-4e06-b6c6-196354d9a8c2
# ╟─658e704a-37e6-40bc-bf83-2360b2670101
# ╠═dad9d83b-2dc8-43bc-9fb4-2dad0d264fe5
# ╟─96e036b0-7ec7-11eb-0308-1d445f8d21fa
# ╠═4ec3992f-ebc4-42db-ad59-61d1befb3fa7
# ╟─5ee8da4d-34d4-43a9-9221-097a912b70b4
# ╠═5f4d9fb9-f926-4b0b-a178-0485d1284ea2
# ╟─eb6f80ea-7ec8-11eb-1b60-916222e958db
# ╟─4ac0178a-7ec9-11eb-2e69-51752445551a
# ╠═629b96af-7346-4b7c-98a9-da1de936fbcf
# ╟─6c3c929e-7ec9-11eb-00e3-87c9c28c60bc
# ╠═058e7062-a8d5-4cdc-bba5-1972d28849a3
# ╟─a81cc482-7ec9-11eb-018d-f933e7d86b01
# ╠═608ce9a0-a623-494d-8f0e-9f079cf6cf9a
# ╟─c1a1c43e-7ec9-11eb-3454-6d078f7a70de
# ╠═b43a74d8-97bb-410a-9a0b-917e35ece8ed
# ╟─dd4164ce-7ec9-11eb-0504-e3e6966b861b
# ╠═258d972b-97dd-4687-8ecc-d3185e18bb01
# ╠═07503e96-6309-4521-a322-52854ed0165f
# ╟─0393e21e-7eca-11eb-1d46-a394c6c31f3f
# ╟─18bd9022-7eca-11eb-0f83-43fc924505a1
# ╟─33230758-7eca-11eb-34b6-6b89f1c8afd4
# ╟─4db45f7c-7eca-11eb-0d84-697b0f34ba19
# ╟─644ba7a4-7eca-11eb-005c-450b665506f8
# ╟─9b0559d6-7eca-11eb-0e90-b35daf751f26
# ╟─b70a0e20-7eca-11eb-2181-a3b160b3c369
