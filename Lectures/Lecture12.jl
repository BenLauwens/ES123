### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ b0dff76e-8726-11eb-31c8-ab5878dd9ed4
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ bef082a6-8726-11eb-088f-5ffda6b048e7
md"""# Tuples

This chapter presents one more built-in type, the tuple, and then shows how arrays, dictionaries, and tuples work together. It also introduces a useful feature for variable-length argument arrays, the gather and scatter operators."""

# ╔═╡ d10a4cb8-8726-11eb-27e2-b55de2487e54
md"""## Tuples Are Immutable

A *tuple* is a sequence of values. The values can be of any type, and they are indexed by integers, so in that respect tuples are a lot like arrays. The important difference is that tuples are immutable and that each element can have its own type.

Syntactically, a tuple is a comma-separated list of values:

```julia
julia> t = 'a', 'b', 'c', 'd', 'e' 
('a', 'b', 'c', 'd', 'e')
```

Although it is not necessary, it is common to enclose tuples in parentheses:

```julia
julia> t = ('a', 'b', 'c', 'd', 'e') 
('a', 'b', 'c', 'd', 'e')
```

To create a tuple with a single element, you have to include a final comma:

```julia
julia> t1 = ('a',) 
('a',)
julia> typeof(t1) 
Tuple{Char}
```

!!! danger
    A value in parentheses without comma is not a tuple:
    
    ```julia
    julia> t2 = ('a')
    'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase) 
    julia> typeof(t2) 
    Char
    ```

Another way to create a tuple is using the built-in function `tuple`. With no argument, it creates an empty tuple:

```julia
julia> tuple() 
()
```

If multiple arguments are provided, the result is a tuple with the given arguments:

```julia
julia> t3 = tuple(1, 'a', pi) 
(1, 'a', π = 3.1415926535897...)
```

Because `tuple` is the name of a built-in function, you should avoid using it as a variable name.

Most array operators also work on tuples. The bracket operator indexes an element:

```julia
julia> t = ('a', 'b', 'c', 'd', 'e'); julia> t[1]
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
```

And the slice operator selects a range of elements:

```julia
julia> t[2:4] 
('b', 'c', 'd')
```

But if you try to modify one of the elements of the tuple, you get an error:

```julia
julia> t[1] = 'A'
ERROR: MethodError: no method matching setindex!(::NTuple{5,Char},::Char, ::Int64)
```

Because tuples are immutable, you can’t modify the elements.

The relational operators work with tuples and other sequences. Julia starts by comparing the first element from each sequence. If they are equal, it goes on to the next elements, and so on until it finds elements that differ. Subsequent elements are not considered (even if they are really big):

```julia
julia>(0, 1, 2) < (0, 3, 4)
true
julia> (0, 1, 2000000) < (0, 3, 4) 
true
```
"""

# ╔═╡ c7ffd72e-8727-11eb-0f6d-fb8e9395741c
md"""## Tuple Assignment

It is often useful to swap the values of two variables. With conventional assignments, you have to use a temporary variable. For example, to swap `a` and `b`:

```julia
temp=a 
a=b 
b=temp
```

This solution is cumbersome; *tuple assignment* is more elegant:

```julia
a, b = b, a
```

The left side is a tuple of variables; the right side is a tuple of expressions. Each value is assigned to its respective variable. All the expressions on the right side are evaluated before any of the assignments.

The number of variables on the left has to be fewer than the number of values on the right:

```julia
julia> (a, b) = (1, 2, 3)
(1, 2, 3)
julia>a, b, c= 1, 2
ERROR: BoundsError: attempt to access (1, 2) at index [3]
```

More generally, the right side can be any kind of sequence (string, array, or tuple). For example, to split an email address into a username and a domain, you could write:

```julia
julia> addr = "julius.caesar@rome" 
"julius.caesar@rome"
julia> uname, domain = split(addr, '@')
2-element Array{SubString{String},1}:
 "julius.caesar"
 "rome"
```

The return value from `split` is an array with two elements; the first element is assigned to `uname`, the second to `domain`:

```julia
julia> uname 
"julius.caesar" 
julia> domain 
"rome"
```
"""

# ╔═╡ 574b6fb0-8728-11eb-0eca-51b778a97602
md"""## Tuples as Return Values

Strictly speaking, a function can only return one value, but if the value is a tuple, the effect is the same as returning multiple values. For example, if you want to divide two integers and compute the quotient and remainder, it is inefficient to compute `x ÷ y` and then `x % y`. It is better to compute them both at the same time.
The built-in function divrem takes two arguments and returns a tuple of two values, the quotient and remainder. You can store the result as a tuple:

```julia
julia> t = divrem(7, 3) 
(2, 1)
```

Or use tuple assignment to store the elements separately:

```julia
julia> q, r = divrem(7, 3);
julia> @show q r; 
q = 2
r = 1
```

Here is an example of a function that returns a tuple:

```julia
minmax(t) = minimum(t), maximum(t)
```

`maximum` and `minimum` are built-in functions that find the largest and smallest ele‐ ments of a sequence. `minmax` computes both and returns a tuple of two values. The built-in function `extrema` is more efficient.
"""

# ╔═╡ a5a354be-8728-11eb-2ab3-4f994c1939c1
md"""## Variable-Length Argument Tuples

Functions can take a variable number of arguments. A parameter name that ends with `...` *gathers* arguments into a tuple. For example, `printall` takes any number of arguments and prints them:

```julia
printall(args...) = println(args)
```

The gather parameter can have any name you like, but `args` is conventional. Here’s how the function works:

```julia
julia> printall(1, 2.0, '3') 
(1, 2.0, '3')
```

The complement of gather is *scatter*. If you have a sequence of values and you want to pass it to a function as multiple arguments, you can use the `...` operator. For example, `divrem` takes exactly two arguments; it doesn’t work with a tuple:

```julia
julia> t = (7, 3); 

julia> divrem(t)
ERROR: MethodError: no method matching divrem(::Tuple{Int64,Int64})
```

But if you scatter the tuple, it works:

```julia
julia> divrem(t...) 
(2, 1)
```

Many of the built-in functions use variable-length argument tuples. For example, `max` and `min` can take any number of arguments:

```julia
julia> max(1, 2, 3) 
3
```

But sum does not: 

```julia
julia> sum(1, 2, 3)
ERROR: MethodError: no method matching sum(::Int64, ::Int64, ::Int64)
```

In the Julia world, gather is often called “slurp” and scatter “splat.”
"""

# ╔═╡ 19ee0db4-8729-11eb-3ca7-737de22181ff
md"""#### Exercise 12-1

Write a function called `sumall` that takes any number of arguments and returns their sum."""

# ╔═╡ 3d55da4a-8729-11eb-3d2f-37fb30c62793
md"""## Arrays and Tuples

`zip` is a built-in function that takes two or more sequences and returns a collection of tuples where each tuple contains one element from each sequence. The name of the function refers to a zipper, which joins and interleaves two rows of teeth.

This example zips a string and an array:

```julia
julia> s = "abc"; 

julia> t = [1, 2, 3];
julia> zip(s, t) 
Base.Iterators.Zip{Tuple{String,Array{Int64,1}}}(("abc", [1, 2, 3]))
```

The result is a *zip object* that knows how to iterate through the pairs. The most common use of `zip` is in a `for` loop:

```julia
julia> for pair in zip(s, t) 
	   	   println(pair)
	   end
('a', 1)
('b', 2)
('c', 3)
```

A zip object is a kind of *iterator*, which is any object that iterates through a sequence. Iterators are similar to arrays in some ways, but unlike arrays, you can’t use an index to select an element from an iterator.

If you want to use array operators and functions, you can use a zip object to make an array:

```julia
julia> collect(zip(s, t))
3-element Array{Tuple{Char,Int64},1}:
 ('a', 1)
 ('b', 2)
 ('c', 3)
```

The result is an array of tuples; in this example, each tuple contains a character from the string and the corresponding element from the array.

If the sequences are not the same length, the result has the length of the shorter one:

```julia
julia> collect(zip("Anne", "Elk")) 
3-element Array{Tuple{Char,Char},1}:
 ('A', 'E')
 ('n', 'l')
 ('n', 'k')
```

You can use tuple assignment in a `for` loop to traverse an array of tuples: 

```julia
julia> t = [('a', 1), ('b', 2), ('c', 3)];

julia> for (letter, number) in t 
           println(number, " ", letter)
       end
1a 2b 3c
```

Each time through the loop, Julia selects the next tuple in the array and assigns the elements to `letter` and `number`. The parentheses around (letter, number) are compulsory.

If you combine `zip`, `for`, and tuple assignment, you get a useful idiom for traversing two (or more) sequences at the same time. For example, `hasmatch` takes two sequences, `t1` and `t2`, and returns true if there is an index `i` such that `t1[i] == t2[i]`:

```julia
function hasmatch(t1, t2) 
	for (x, y) in zip(t1, t2)
		if x == y 
			return true
		end 
	end
	false 
end
```

If you need to traverse the elements of a sequence and their indices, you can use the built-in function `enumerate`:

```julia
julia> for (index, element) in enumerate("abc") 
           println(index, " ", element)
       end
1 a 
2 b 
3 c
```

The result from `enumerate` is an enumerate object, which iterates a sequence of pairs; each pair contains an index (starting from 1) and an element from the given sequence.
"""

# ╔═╡ 221a3360-872a-11eb-2ead-8d1358efe435
md"""## Dictionaries and Tuples

Dictionaries can be used as iterators that iterate the key-value pairs. You can use a dictionary in a `for` loop like this:

```julia
julia> d = Dict('a'=>1, 'b'=>2, 'c'=>3);

julia> for (key, value) in d 
           println(key, " ", value)
       end
a 1 
c 3 
b 2
```

As you should expect from a dictionary, the items are in no particular order.

Going in the other direction, you can use an array of tuples to initialize a new dictionary:

```julia
julia> t = [('a', 1), ('c', 3), ('b', 2)];

julia> d = Dict(t) 
Dict{Char,Int64} with 3 entries:
  'a' => 1
  'c' => 3
  'b' => 2
```

Combining `Dict` with `zip` yields a concise way to create a dictionary:

```julia
julia> d = Dict(zip("abc", 1:3)) 
Dict{Char,Int64} with 3 entries:
  'a' => 1
  'c' => 3
  'b' => 2
```

It is common to use tuples as keys in dictionaries. For example, a telephone directory might map from *last-name*, *first-name* pairs to telephone numbers. Assuming that we have defined `last`, `first`, and `number`, we could write:

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

# ╔═╡ bf393bf4-872b-11eb-0233-cbb084e3ad3f
md"*Figure 12-1. State diagram.*"

# ╔═╡ c580c4b4-872b-11eb-1aaf-b51e08f9f26c
md"""But in a larger diagram you might want to leave out the details. For example, a diagram of the telephone directory might appear as in Figure 12-2."""

# ╔═╡ c608335e-872b-11eb-278e-51296de15fbc
Drawing(width=720, height=150) do
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

# ╔═╡ 1f4b8a1e-872d-11eb-20b1-014ddea498de
md"*Figure 12-2. State diagram.*"

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

#### Exercise 12-2

Write a function called `mostfrequent` that takes a string and prints the letters in decreasing order of frequency. Find text samples from several different languages and see how letter frequency varies between languages. Compare your results with the tables at [https://en.wikipedia.org/wiki/Letter_frequencies](https://en.wikipedia.org/wiki/Letter_frequencies).
"""

# ╔═╡ 05a7a222-872e-11eb-3de9-c73ab5da92a0
md"""#### Exercise 12-3

More anagrams!

1. Write a program that reads a word list from a file (see “Reading Word Lists”) and prints all the sets of words that are anagrams. Here is an example of what the output might look like:
   
   ```julia
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
md"""#### Exercise 12-4

Two words form a “metathesis pair” if you can transform one into the other by swap‐ ping two letters; for example, “converse” and “conserve.” Write a program that finds all of the metathesis pairs in *words.txt*.

!!! tip
    Don’t test all pairs of words, and don’t test all possible swaps.

*Credit*: This exercise is inspired by an example at [http://puzzlers.org](http://puzzlers.org).
"""

# ╔═╡ 8a7b57dc-872e-11eb-189c-7f2d7cb2e695
md"""#### Exercise 12-5

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
# ╟─c7ffd72e-8727-11eb-0f6d-fb8e9395741c
# ╟─574b6fb0-8728-11eb-0eca-51b778a97602
# ╟─a5a354be-8728-11eb-2ab3-4f994c1939c1
# ╟─19ee0db4-8729-11eb-3ca7-737de22181ff
# ╟─3d55da4a-8729-11eb-3d2f-37fb30c62793
# ╟─221a3360-872a-11eb-2ead-8d1358efe435
# ╟─ce6beec2-872a-11eb-3b39-5531bfc637cb
# ╟─bf393bf4-872b-11eb-0233-cbb084e3ad3f
# ╟─c580c4b4-872b-11eb-1aaf-b51e08f9f26c
# ╟─c608335e-872b-11eb-278e-51296de15fbc
# ╟─1f4b8a1e-872d-11eb-20b1-014ddea498de
# ╟─286fe504-872d-11eb-06d3-e1c2682eff9c
# ╟─3260e720-872d-11eb-065c-93bbb15621b9
# ╟─6cd09676-872d-11eb-0ffd-3fd772eb7db4
# ╟─96a213d2-872d-11eb-25e4-fdd44a16150d
# ╟─e7f038d6-872d-11eb-28a3-6307d3e72e85
# ╟─05a7a222-872e-11eb-3de9-c73ab5da92a0
# ╟─586908a2-872e-11eb-3919-f96ba66ee674
# ╟─8a7b57dc-872e-11eb-189c-7f2d7cb2e695
