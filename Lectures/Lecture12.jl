### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ b0dff76e-8726-11eb-31c8-ab5878dd9ed4
begin
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

# ╔═╡ bef082a6-8726-11eb-088f-5ffda6b048e7
md"""# Tuples

This chapter presents one more built-in type, the tuple, and then shows how arrays, dictionaries, and tuples work together. It also introduces a useful feature for variable-length argument arrays, the gather and scatter operators."""

# ╔═╡ d10a4cb8-8726-11eb-27e2-b55de2487e54
md"""## Tuples Are Immutable

A *tuple* is a sequence of values. The values can be of any type, and they are indexed by integers, so in that respect tuples are a lot like arrays. The important difference is that tuples are immutable and that each element can have its own type.

Syntactically, a tuple is a comma-separated list of values:
"""

# ╔═╡ a072a4e1-e305-4c29-8c53-3162c1dc2f8f
t = 'a', 'b', 'c', 'd', 'e'

# ╔═╡ b00ef910-d474-4d4e-9814-911be012791f
md"""Although it is not necessary, it is common to enclose tuples in parentheses:

```julia
julia> t = ('a', 'b', 'c', 'd', 'e')
('a', 'b', 'c', 'd', 'e')
```

To create a tuple with a single element, you have to include a final comma:
"""

# ╔═╡ 1bcdb3d3-fa10-4c3e-8c2e-0c39226bf73e
t1 = ('a',)

# ╔═╡ b8be1e3b-53e6-45f7-888d-a9d383d97d0c
typeof(t1)

# ╔═╡ 63472745-3abe-492f-b76c-91118a64d609
md"""!!! danger
    A value in parentheses without comma is not a tuple:
"""

# ╔═╡ f1f1b0c6-d5cf-474f-a702-885389409466
t2 = ('a')

# ╔═╡ 0bbb8d2a-c136-4eb1-b939-7f3bbb23790f
typeof(t2)

# ╔═╡ e7f58da6-0880-45b7-ad10-f077d578fed6
md"""Another way to create a tuple is using the built-in function `tuple`. With no argument, it creates an empty tuple:
"""

# ╔═╡ 39a03954-748f-4a58-8f7f-c33be44a0074
tuple()

# ╔═╡ 01c55f85-0b4a-45ea-a81c-f5fcd7b04d52
md"""If multiple arguments are provided, the result is a tuple with the given arguments:
"""

# ╔═╡ b2ab1635-3985-4e48-8ffc-bcf9aed62adc
t3 = tuple(1, 'a', π)

# ╔═╡ ef6c337b-e259-4faf-bff5-abe1445fb431
md"""Because `tuple` is the name of a built-in function, you should avoid using it as a variable name.

Most array operators also work on tuples. The bracket operator indexes an element:
"""

# ╔═╡ 448849a5-7d66-48cd-b2d5-443edcfb13d1
t[1]

# ╔═╡ 6caa6ab7-26cb-4216-aea0-35f342cba051
md"""And the slice operator selects a range of elements:
"""

# ╔═╡ 739c0483-32b1-488f-bca1-a15337a619d0
t[2:4]

# ╔═╡ 6c3dafdb-2e93-448a-a6e6-bb191fe9935e
md"""But if you try to modify one of the elements of the tuple, you get an error:
"""

# ╔═╡ 7724772a-8a9f-49b4-9ec5-936ee4390091
t[1] = 'A'

# ╔═╡ 62813f2f-cf36-4704-a1c7-f79ab7180edd
md"""Because tuples are immutable, you can’t modify the elements.

The relational operators work with tuples and other sequences. Julia starts by comparing the first element from each sequence. If they are equal, it goes on to the next elements, and so on until it finds elements that differ. Subsequent elements are not considered (even if they are really big):
"""

# ╔═╡ a8c4b3e9-1c67-4f16-818a-9731e904bdba
(0, 1, 2) < (0, 3, 4)

# ╔═╡ 34c36b42-ad2c-49ef-a12a-8310013a2779
(0, 1, 200000) < (0, 3, 4)

# ╔═╡ c7ffd72e-8727-11eb-0f6d-fb8e9395741c
md"""## Tuple Assignment

It is often useful to swap the values of two variables. With conventional assignments, you have to use a temporary variable. For example, to swap `a` and `b`:
"""

# ╔═╡ 3e0e6b1d-bd0c-4916-a5cb-13220af75383
let
	a = 1
	b = 2
	temp = a
	a = b
	b = temp
	@show a b
end;

# ╔═╡ 2676060c-84f1-4a7a-bc09-8997a98a243a
md"""This solution is cumbersome; *tuple assignment* is more elegant:
"""

# ╔═╡ 6794a593-0c13-4fd9-8080-69b160d2977e
let
	a = 1
	b = 2
	a, b = b, a
	@show a b
end;

# ╔═╡ 98b668b4-2207-473c-8339-53931140aa13
md"""The left side is a tuple of variables; the right side is a tuple of expressions. Each value is assigned to its respective variable. All the expressions on the right side are evaluated before any of the assignments.

The number of variables on the left has to be fewer than the number of values on the right:
"""

# ╔═╡ 01571ccf-b45a-4bcf-b1e4-c2bbcc6a589c
let
	(a, b) = (1, 2, 3)
end

# ╔═╡ 8fa099aa-f4e2-489d-a412-6480464220e1
let
	a, b, c = 1, 2
end

# ╔═╡ b755595e-a351-43a5-b0a3-792555a27aa5
md"""More generally, the right side can be any kind of sequence (string, array, or tuple). For example, to split an email address into a username and a domain, you could write:
"""

# ╔═╡ 827a4273-4902-4818-969d-9c071b35a26a
let
	addr = "julius.caesar@rome"
	uname, domain = split(addr, '@')
	@show addr uname
end;

# ╔═╡ 6947ebd7-97db-4328-9bd6-46caeca0b242
md"""The return value from `split` is an array with two elements; the first element is assigned to `uname`, the second to `domain`.
"""

# ╔═╡ 574b6fb0-8728-11eb-0eca-51b778a97602
md"""## Tuples as Return Values

Strictly speaking, a function can only return one value, but if the value is a tuple, the effect is the same as returning multiple values. For example, if you want to divide two integers and compute the quotient and remainder, it is inefficient to compute `x ÷ y` and then `x % y`. It is better to compute them both at the same time.
The built-in function `divrem` takes two arguments and returns a tuple of two values, the quotient and remainder. You can store the result as a tuple:
"""

# ╔═╡ b6d84fd4-3890-4f56-b24f-8ed745df81c8
dr = divrem(7, 3)

# ╔═╡ 11e977a2-1852-42e5-b502-40077b0aff1b
md"""Or use tuple assignment to store the elements separately:
"""

# ╔═╡ ec5b268c-f462-49fa-9a70-fd0fb416ed4e
let
	q, r = divrem(7, 3)
	@show q r
end;

# ╔═╡ dc53a47a-a75b-49e6-ae6e-cfb84d48d956
md"""Here is an example of a function that returns a tuple:
"""

# ╔═╡ c6fe0005-d65f-4414-9bbd-250911e440f3
minmax(t) = minimum(t), maximum(t)

# ╔═╡ 2e006454-8e48-46ce-9650-035ebbd67e70
md"""`maximum` and `minimum` are built-in functions that find the largest and smallest ele‐ ments of a sequence. `minmax` computes both and returns a tuple of two values. The built-in function `extrema` is more efficient."""

# ╔═╡ a5a354be-8728-11eb-2ab3-4f994c1939c1
md"""## Variable-Length Argument Tuples

Functions can take a variable number of arguments. A parameter name that ends with `...` *gathers* arguments into a tuple. For example, `printall` takes any number of arguments and prints them:
"""

# ╔═╡ 454858dd-8017-407f-9f05-f67f5d65dadc
printall(args...) = println(args)

# ╔═╡ 038ac172-809e-4860-ad0c-797550859b5c
md"""The gather parameter can have any name you like, but `args` is conventional. Here’s how the function works:
"""

# ╔═╡ fe676b2e-1c9a-4236-b1bd-d725d944fd7f
printall(1, 2.0, '3')

# ╔═╡ 55620e4a-21d1-469e-934e-63d61d670c7b
md"""The complement of gather is *scatter*. If you have a sequence of values and you want to pass it to a function as multiple arguments, you can use the `...` operator. For example, `divrem` takes exactly two arguments; it doesn’t work with a tuple:
"""

# ╔═╡ 03068be6-7f49-4cc4-bd88-15fee40b30e1
c = (7, 3)

# ╔═╡ 0ae3a857-8826-4113-9aef-5b022a90a4b3
divrem(c)

# ╔═╡ 07ae2136-0f5a-461b-9e67-ecce1b960b61
md"""But if you scatter the tuple, it works:
"""

# ╔═╡ 3ac8da57-e7eb-4804-a731-a8598b932951
divrem(c...)

# ╔═╡ 8d8531cc-b72a-411a-8e6c-275e6864ed3d
md"""Many of the built-in functions use variable-length argument tuples. For example, `max` and `min` can take any number of arguments:
"""

# ╔═╡ 26b60f50-0e33-4f61-98cd-0dd26d5d1bd1
max(1, 2, 3)

# ╔═╡ 55a396be-426c-46fd-95c8-686a995a3f55
md"""But sum does not:
"""

# ╔═╡ d8402345-1e62-4156-802c-fd56b8459780
sum(1, 2, 3)

# ╔═╡ 4842d2db-64cf-4ec7-a3ef-e2d0d8d6bdff
md"""In the Julia world, gather is often called “slurp” and scatter “splat.”
"""

# ╔═╡ 19ee0db4-8729-11eb-3ca7-737de22181ff
md"""### Exercise 12-1

Write a function called `sumall` that takes any number of arguments and returns their sum."""

# ╔═╡ 3d55da4a-8729-11eb-3d2f-37fb30c62793
md"""## Arrays and Tuples

`zip` is a built-in function that takes two or more sequences and returns a collection of tuples where each tuple contains one element from each sequence. The name of the function refers to a zipper, which joins and interleaves two rows of teeth.

This example zips a string and an array:
"""

# ╔═╡ 16d726c7-ed6b-4dce-840e-64de7688a4da
z = let
	s = "abc"
	t = [1, 2, 3]
	zip(s, t)
end

# ╔═╡ d3bf52e3-b19b-4ed9-a008-40ced8d2bde2
md"""The result is a *zip object* that knows how to iterate through the pairs. The most common use of `zip` is in a `for` loop:
"""

# ╔═╡ bd347bc3-0505-4bf7-a23a-4cb6ad8b3d12
for pair in z
   println(pair)
end

# ╔═╡ f265f7ad-2642-4809-ad88-fb0a42b10b5e
md"""A zip object is a kind of *iterator*, which is any object that iterates through a sequence. Iterators are similar to arrays in some ways, but unlike arrays, you can’t use an index to select an element from an iterator.

If you want to use array operators and functions, you can use a zip object to make an array:
"""

# ╔═╡ c185bec2-e939-4eb0-ae8e-3cf8071cfac5
collect(z)

# ╔═╡ 7a742e2c-3b2a-456c-a4ad-07f542444b71
md"""The result is an array of tuples; in this example, each tuple contains a character from the string and the corresponding element from the array.

If the sequences are not the same length, the result has the length of the shorter one:
"""

# ╔═╡ 80c0c34f-5bcd-47b9-9d8a-6fdd0fb2a4f4
collect(zip("Anne", "Elk"))

# ╔═╡ 26fc4184-5a8d-492f-ad1e-86385be63a6e
md"""You can use tuple assignment in a `for` loop to traverse an array of tuples:
"""

# ╔═╡ d98ea074-d7d2-4fba-bc26-6c5a78c9f377
for (letter, number) in collect(z)
	println(number, " ", letter)
end

# ╔═╡ a02bf0f6-410d-4370-9776-b67103b89e90
md"""Each time through the loop, Julia selects the next tuple in the array and assigns the elements to `letter` and `number`. The parentheses around (letter, number) are compulsory.

If you combine `zip`, `for`, and tuple assignment, you get a useful idiom for traversing two (or more) sequences at the same time. For example, `hasmatch` takes two sequences, `t1` and `t2`, and returns true if there is an index `i` such that `t1[i] == t2[i]`:
"""

# ╔═╡ 5a5ae587-f1b7-40e5-a5f7-9edd5b225f70
function hasmatch(t1, t2)
	for (x, y) in zip(t1, t2)
		if x == y
			return true
		end
	end
	return false
end

# ╔═╡ b8712390-7c61-4ccb-967a-1dd1423c4e43
md"""If you need to traverse the elements of a sequence and their indices, you can use the built-in function `enumerate`:
"""

# ╔═╡ 230a9a1b-0fd5-4441-8270-38719e5e29a6
for (index, element) in enumerate("abc")
	println(index, " ", element)
end

# ╔═╡ ce45c731-d8cd-47c9-aaa5-187e4b08f733
md"""The result from `enumerate` is an enumerate object, which iterates a sequence of pairs; each pair contains an index (starting from 1) and an element from the given sequence.
"""

# ╔═╡ 221a3360-872a-11eb-2ead-8d1358efe435
md"""## Dictionaries and Tuples

Dictionaries can be used as iterators that iterate the key-value pairs. You can use a dictionary in a `for` loop like this:
"""

# ╔═╡ 916c4792-aab2-496b-b033-9b99ac655504
let
	d = Dict('a'=>1, 'b'=>2, 'c'=>3);
	for (key, value) in d
		println(key, " ", value)
	end
end

# ╔═╡ d94079d8-d82d-4295-abba-083612df2386
md"""As you should expect from a dictionary, the items are in no particular order.

Going in the other direction, you can use an array of tuples to initialize a new dictionary:
"""

# ╔═╡ 72b73482-e198-4d0c-83e6-0c837464ebbc
let
	t = [('a', 1), ('c', 3), ('b', 2)];
	Dict(t)
end

# ╔═╡ c6daca60-2284-42e1-9a77-79be5ce39d6e
md"""Combining `Dict` with `zip` yields a concise way to create a dictionary:
"""

# ╔═╡ 86f8b171-598f-40c8-9838-537139d846b5
Dict(zip("abc", 1:3))

# ╔═╡ 13f02778-0394-4078-a360-4b5d22b7d960
md"""It is common to use tuples as keys in dictionaries. For example, a telephone directory might map from *last-name*, *first-name* pairs to telephone numbers. Assuming that we have defined `last`, `first`, and `number`, we could write:

```julia
directory[last, first] = number
```

The expression in brackets is a tuple. We could use tuple assignment to traverse this
dictionary:

```julia
for ((last, first), number) in directory
	println(first, " ", last, " ", number)
end
```

This loop traverses the key-value pairs in `directory`, which are tuples. It assigns the elements of the key in each tuple to `last` and `first`, and the value to `number`, then prints the name and corresponding telephone number.

There are two ways to represent tuples in a state diagram. The more detailed version shows the indices and elements just as they appear in an array. For example, the tuple `("Cleese", "John")` would appear as in Figure 12-1.
"""

# ╔═╡ ce6beec2-872a-11eb-3b39-5531bfc637cb
Drawing(width=720, height=70) do
	@info "State diagram."
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	rect(x=285, y=10, width=150, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=295, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("1")
	end
	line(x1=315, y1=25, x2=355, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=375, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Cleese")
	end
	text(x=295, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("2")
	end
	line(x1=315, y1=45, x2=355, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=375, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("John")
	end
end

# ╔═╡ c580c4b4-872b-11eb-1aaf-b51e08f9f26c
md"""But in a larger diagram you might want to leave out the details. For example, a diagram of the telephone directory might appear as in Figure 12-2."""

# ╔═╡ c608335e-872b-11eb-278e-51296de15fbc
Drawing(width=720, height=150) do
	@info "State diagram."
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	rect(x=175, y=10, width=370, height=130, fill="rgb(242, 242, 242)", stroke="black")
	text(x=355, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do
		str("(\"Cleese\", \"John\")")
	end
	line(x1=365, y1=25, x2=405, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=425, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("08700 100 222")
	end
	text(x=355, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do
		str("(\"Chapman\", \"Graham\")")
	end
	line(x1=365, y1=45, x2=405, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=425, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("08700 100 222")
	end
	text(x=355, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do
		str("(\"Idle\", \"Eric\")")
	end
	line(x1=365, y1=65, x2=405, y2=65, stroke="black", marker_end="url(#arrow)")
	text(x=425, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("08700 100 222")
	end
	text(x=355, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do
		str("(\"Gilliam\", \"Terry\")")
	end
	line(x1=365, y1=85, x2=405, y2=85, stroke="black", marker_end="url(#arrow)")
	text(x=425, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("08700 100 222")
	end
	text(x=355, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do
		str("(\"Jones\", \"Terry\")")
	end
	line(x1=365, y1=105, x2=405, y2=105, stroke="black", marker_end="url(#arrow)")
	text(x=425, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("08700 100 222")
	end
	text(x=355, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do
		str("(\"Palin\", \"Michael\")")
	end
	line(x1=365, y1=125, x2=405, y2=125, stroke="black", marker_end="url(#arrow)")
	text(x=425, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("08700 100 222")
	end
end

# ╔═╡ 286fe504-872d-11eb-06d3-e1c2682eff9c
md"""Here the tuples are shown using Julia syntax as a graphical shorthand. The telephone number in the diagram is the complaints line for the BBC, so please don’t call it."""

# ╔═╡ 3260e720-872d-11eb-065c-93bbb15621b9
md"""## Sequences of Sequences

I have focused on arrays of tuples, but almost all of the examples in this chapter also work with arrays of arrays, tuples of tuples, and tuples of arrays. To avoid enumerating the possible combinations, it is sometimes easier to talk about sequences of sequences.

In many contexts, the different kinds of sequences (strings, arrays, and tuples) can be used interchangeably. So how should you choose one over the others?

To start with the obvious, strings are more limited than other sequences because the elements have to be characters. They are also immutable. If you need the ability to change the characters in a string (as opposed to creating a new string), you might want to use an array of characters instead.

Arrays are more common than tuples, mostly because they are mutable. But there are a few cases where you might prefer tuples:

* In some contexts, like a `return` statement, it is syntactically simpler to create a tuple than an array.
* If you are passing a sequence as an argument to a function, using tuples reduces the potential for unexpected behavior due to aliasing.
* For performance reasons. The compiler can specialize on the type.

Because tuples are immutable, they don’t provide functions like `sort!` and `reverse!`, which modify existing arrays. But Julia provides the built-in functions `sort`, which takes an array and returns a new array with the same elements in sorted order, and `reverse`, which takes any sequence and returns a sequence of the same type in reverse order.
"""

# ╔═╡ 6cd09676-872d-11eb-0ffd-3fd772eb7db4
md"""## Debugging

Arrays, dictionaries, and tuples are examples of *data structures*; in this chapter we are starting to see compound data structures, like arrays of tuples, or dictionaries that contain tuples as keys and arrays as values. Compound data structures are useful, but they are prone to what I call *shape errors*; that is, errors caused when a data structure has the wrong type, size, or structure. For example, if you are expecting an array with one integer and I give you a plain old integer (not in an array), it won’t work.

Julia allows you to attach a type to elements of a sequence. How this is done is detailed in Lecture 17. Specifying the type eliminates a lot of shape errors.
"""

# ╔═╡ 96a213d2-872d-11eb-25e4-fdd44a16150d
md"""## Glossary

*tuple*:
An immutable sequence of elements where every element can have its own type.

*tuple assignment*:
An assignment with a sequence on the right side and a tuple of variables on the left. The right side is evaluated and then its elements are assigned to the variables on the left.

*gather*:
The operation of assembling a variable-length argument tuple.

*scatter*:
The operation of treating a sequence as a list of arguments.

*zip object*:
The result of calling a built-in function zip, an object that iterates through a sequence of tuples.

*iterator*:
An object that can iterate through a sequence, but that does not provide array operators and functions.

*data structure*:
A collection of related values, often organized in arrays, dictionaries, tuples, etc.

*shape error*:
An error caused because a value has the wrong shape; that is, the wrong type or size.
"""

# ╔═╡ e7f038d6-872d-11eb-28a3-6307d3e72e85
md"""## Exercises

### Exercise 12-2

Write a function called `mostfrequent` that takes a string and prints the letters in decreasing order of frequency. Find text samples from several different languages and see how letter frequency varies between languages. Compare your results with the tables at [https://en.wikipedia.org/wiki/Letter_frequencies](https://en.wikipedia.org/wiki/Letter_frequencies).
"""

# ╔═╡ 05a7a222-872e-11eb-3de9-c73ab5da92a0
md"""### Exercise 12-3

More anagrams!

1. Write a program that reads a word list from a file (see “Reading Word Lists”) and prints all the sets of words that are anagrams. Here is an example of what the output might look like:

   ```
   ["deltas", "desalt", "lasted", "salted", "slated", "staled"]
   ["retainers", "ternaries"]
   ["generating", "greatening"]
   ["resmelts", "smelters", "termless"]
   ```

   !!! tip
       You might want to build a dictionary that maps from a collection of letters to an array of words that can be spelled with those letters. The question is, how can you represent the col‐ lection of letters in a way that can be used as a key?

2. Modify the previous program so that it prints the longest array of anagrams first, followed by the second longest, and so on.

3. In Scrabble a “bingo” is when you play all seven tiles in your rack, along with a letter on the board, to form an eight-letter word. What collection of eight letters forms the most possible bingos?
"""

# ╔═╡ 586908a2-872e-11eb-3919-f96ba66ee674
md"""### Exercise 12-4

Two words form a “metathesis pair” if you can transform one into the other by swap‐ ping two letters; for example, “converse” and “conserve.” Write a program that finds all of the metathesis pairs in *words.txt*.

!!! tip
    Don’t test all pairs of words, and don’t test all possible swaps.

*Credit*: This exercise is inspired by an example at [http://puzzlers.org](http://puzzlers.org).
"""

# ╔═╡ 8a7b57dc-872e-11eb-189c-7f2d7cb2e695
md"""### Exercise 12-5

Here’s another Car Talk Puzzler:

> What is the longest English word, that remains a valid English word, as you remove its letters one at a time?
>
> Now, letters can be removed from either end, or the middle, but you can’t rearrange any of the letters. Every time you drop a letter, you wind up with another English word. If you do that, you’re eventually going to wind up with one letter and that too is going to be an English word—one that’s found in the dictionary. I want to know what’s the longest word. What’s the word, and how many letters does it have?
>
> I’m going to give you a little modest example: Sprite. Ok? You start off with sprite, you take a letter off, one from the interior of the word, take the r away, and we’re left with the word spite, then we take the e off the end, we’re left with spit, we take the s off, we’re left with pit, it, and I.

Write a program to find all words that can be reduced in this way, and then find the longest one.

!!! tip
    This exercise is a little more challenging than most, so here are some suggestions:

    1. You might want to write a function that takes a word and com‐ putes an array of all the words that can be formed by removing one letter. These are the “children” of the word.

    2. Recursively, a word is reducible if any of its children are reducible. As a base case, you can consider the empty string reducible.

    3. The word list I provided, *words.txt*, doesn’t contain singleletter words. So, you might want to add “I,” “a,” and the empty string.

    4. To improve the performance of your program, you might want to memoize the words that are known to be reducible.
"""

# ╔═╡ Cell order:
# ╟─b0dff76e-8726-11eb-31c8-ab5878dd9ed4
# ╟─bef082a6-8726-11eb-088f-5ffda6b048e7
# ╟─d10a4cb8-8726-11eb-27e2-b55de2487e54
# ╠═a072a4e1-e305-4c29-8c53-3162c1dc2f8f
# ╟─b00ef910-d474-4d4e-9814-911be012791f
# ╠═1bcdb3d3-fa10-4c3e-8c2e-0c39226bf73e
# ╠═b8be1e3b-53e6-45f7-888d-a9d383d97d0c
# ╟─63472745-3abe-492f-b76c-91118a64d609
# ╠═f1f1b0c6-d5cf-474f-a702-885389409466
# ╠═0bbb8d2a-c136-4eb1-b939-7f3bbb23790f
# ╟─e7f58da6-0880-45b7-ad10-f077d578fed6
# ╠═39a03954-748f-4a58-8f7f-c33be44a0074
# ╟─01c55f85-0b4a-45ea-a81c-f5fcd7b04d52
# ╠═b2ab1635-3985-4e48-8ffc-bcf9aed62adc
# ╟─ef6c337b-e259-4faf-bff5-abe1445fb431
# ╠═448849a5-7d66-48cd-b2d5-443edcfb13d1
# ╟─6caa6ab7-26cb-4216-aea0-35f342cba051
# ╠═739c0483-32b1-488f-bca1-a15337a619d0
# ╟─6c3dafdb-2e93-448a-a6e6-bb191fe9935e
# ╠═7724772a-8a9f-49b4-9ec5-936ee4390091
# ╟─62813f2f-cf36-4704-a1c7-f79ab7180edd
# ╠═a8c4b3e9-1c67-4f16-818a-9731e904bdba
# ╠═34c36b42-ad2c-49ef-a12a-8310013a2779
# ╟─c7ffd72e-8727-11eb-0f6d-fb8e9395741c
# ╠═3e0e6b1d-bd0c-4916-a5cb-13220af75383
# ╟─2676060c-84f1-4a7a-bc09-8997a98a243a
# ╠═6794a593-0c13-4fd9-8080-69b160d2977e
# ╟─98b668b4-2207-473c-8339-53931140aa13
# ╠═01571ccf-b45a-4bcf-b1e4-c2bbcc6a589c
# ╠═8fa099aa-f4e2-489d-a412-6480464220e1
# ╟─b755595e-a351-43a5-b0a3-792555a27aa5
# ╠═827a4273-4902-4818-969d-9c071b35a26a
# ╟─6947ebd7-97db-4328-9bd6-46caeca0b242
# ╟─574b6fb0-8728-11eb-0eca-51b778a97602
# ╠═b6d84fd4-3890-4f56-b24f-8ed745df81c8
# ╟─11e977a2-1852-42e5-b502-40077b0aff1b
# ╠═ec5b268c-f462-49fa-9a70-fd0fb416ed4e
# ╟─dc53a47a-a75b-49e6-ae6e-cfb84d48d956
# ╠═c6fe0005-d65f-4414-9bbd-250911e440f3
# ╟─2e006454-8e48-46ce-9650-035ebbd67e70
# ╟─a5a354be-8728-11eb-2ab3-4f994c1939c1
# ╠═454858dd-8017-407f-9f05-f67f5d65dadc
# ╟─038ac172-809e-4860-ad0c-797550859b5c
# ╠═fe676b2e-1c9a-4236-b1bd-d725d944fd7f
# ╟─55620e4a-21d1-469e-934e-63d61d670c7b
# ╠═03068be6-7f49-4cc4-bd88-15fee40b30e1
# ╠═0ae3a857-8826-4113-9aef-5b022a90a4b3
# ╟─07ae2136-0f5a-461b-9e67-ecce1b960b61
# ╠═3ac8da57-e7eb-4804-a731-a8598b932951
# ╟─8d8531cc-b72a-411a-8e6c-275e6864ed3d
# ╠═26b60f50-0e33-4f61-98cd-0dd26d5d1bd1
# ╟─55a396be-426c-46fd-95c8-686a995a3f55
# ╠═d8402345-1e62-4156-802c-fd56b8459780
# ╟─4842d2db-64cf-4ec7-a3ef-e2d0d8d6bdff
# ╟─19ee0db4-8729-11eb-3ca7-737de22181ff
# ╟─3d55da4a-8729-11eb-3d2f-37fb30c62793
# ╠═16d726c7-ed6b-4dce-840e-64de7688a4da
# ╟─d3bf52e3-b19b-4ed9-a008-40ced8d2bde2
# ╠═bd347bc3-0505-4bf7-a23a-4cb6ad8b3d12
# ╟─f265f7ad-2642-4809-ad88-fb0a42b10b5e
# ╠═c185bec2-e939-4eb0-ae8e-3cf8071cfac5
# ╟─7a742e2c-3b2a-456c-a4ad-07f542444b71
# ╠═80c0c34f-5bcd-47b9-9d8a-6fdd0fb2a4f4
# ╟─26fc4184-5a8d-492f-ad1e-86385be63a6e
# ╠═d98ea074-d7d2-4fba-bc26-6c5a78c9f377
# ╟─a02bf0f6-410d-4370-9776-b67103b89e90
# ╠═5a5ae587-f1b7-40e5-a5f7-9edd5b225f70
# ╟─b8712390-7c61-4ccb-967a-1dd1423c4e43
# ╠═230a9a1b-0fd5-4441-8270-38719e5e29a6
# ╟─ce45c731-d8cd-47c9-aaa5-187e4b08f733
# ╟─221a3360-872a-11eb-2ead-8d1358efe435
# ╠═916c4792-aab2-496b-b033-9b99ac655504
# ╟─d94079d8-d82d-4295-abba-083612df2386
# ╠═72b73482-e198-4d0c-83e6-0c837464ebbc
# ╟─c6daca60-2284-42e1-9a77-79be5ce39d6e
# ╠═86f8b171-598f-40c8-9838-537139d846b5
# ╟─13f02778-0394-4078-a360-4b5d22b7d960
# ╟─ce6beec2-872a-11eb-3b39-5531bfc637cb
# ╟─c580c4b4-872b-11eb-1aaf-b51e08f9f26c
# ╟─c608335e-872b-11eb-278e-51296de15fbc
# ╟─286fe504-872d-11eb-06d3-e1c2682eff9c
# ╟─3260e720-872d-11eb-065c-93bbb15621b9
# ╟─6cd09676-872d-11eb-0ffd-3fd772eb7db4
# ╟─96a213d2-872d-11eb-25e4-fdd44a16150d
# ╟─e7f038d6-872d-11eb-28a3-6307d3e72e85
# ╟─05a7a222-872e-11eb-3de9-c73ab5da92a0
# ╟─586908a2-872e-11eb-3919-f96ba66ee674
# ╟─8a7b57dc-872e-11eb-189c-7f2d7cb2e695
