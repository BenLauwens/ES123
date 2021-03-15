### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ bcaefa4e-85c6-11eb-3316-0db4881ebd30
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ 13d62b06-85c7-11eb-00b9-0399467b1ab5
md"""# Dictionaries

This chapter presents another built-in type called a dictionary."""

# ╔═╡ 1f1c885e-85c7-11eb-1452-13a8943ebc90
md"""## A Dictionary Is a Mapping

A *dictionary* is like an array, but more general. In an array, the indices have to be integers; in a dictionary they can be (almost) any type.

A dictionary contains a collection of indices, which are called *keys*, and a collection of *values*. Each key is associated with a single value. The association of a key and a value is called a *key-value* pair, or sometimes an *item*.

In mathematical language, a dictionary represents a *mapping* from keys to values, so you can also say that each key “maps to” a value. As an example, we’ll build a dictionary that maps from English to Spanish words, so the keys and the values are all strings.

The function `Dict` creates a new dictionary with no items (because Dict is the name of a built-in function, you should avoid using it as a variable name):

```julia
julia> eng2sp = Dict() 
Dict{Any,Any} with 0 entries
```

The types of the keys and values in the dictionary are specified in curly braces: here, both are of type `Any`.


The dictionary is empty. To add items to the dictionary, you can use square brackets:

```julia
julia> eng2sp["one"] = "uno";
```

This line creates an item that maps from the key `"one"` to the value `"uno"`. If we print the dictionary again, we see a key-value pair with an arrow `=>` between the key and value:

```julia
julia> eng2sp 
Dict{Any,Any} with 1 entry:
  "one" => "uno"
```

This output format is also an input format. For example, you can create a new dictionary with three items as follows:

```julia
julia> eng2sp = Dict("one" => "uno", "two" => "dos", "three" => "tres") Dict{String,String} with 3 entries:
  "two"   => "dos"
  "one"   => "uno"
  "three" => "tres"
```

Here all the initial keys and values are strings, so a `Dict{String,String}` is created. 

The order of the items in a dictionary is unpredictable. If you type the same example
on your computer, you might get a different result.

But that’s not a problem because the elements of a dictionary are never indexed with integer indices. Instead, you use the keys to look up the corresponding values:

```julia
julia> eng2sp["two"] 
"dos"
```

The key `"two"` always maps to the value `"dos"`, so the order of the items doesn’t matter.

If the key isn’t in the dictionary, you get an exception:

```julia
julia> eng2sp["four"]
ERROR: KeyError: key "four" not found
```

The `length` function works on dictionaries; it returns the number of key-value pairs: 

```julia
julia> length(eng2sp)
3
```

The function keys returns a collection with the keys of the dictionary: 

```julia
julia> ks = keys(eng2sp);

julia> print(ks) 
["two", "one", "three"]
```

Now you can use the `∈` operator to see whether something appears as a key in the dictionary:

```julia
julia> "one" ∈ ks 
true
julia> "uno" ∈ ks 
false
```

To see whether something appears as a value in a dictionary, you can use the function `values`, which returns a collection of values, and then use the `∈` operator:

```julia
julia> vs = values(eng2sp); 

julia> "uno" ∈ vs
true
```

The `∈` operator uses different algorithms for arrays and dictionaries. For arrays, it searches the elements of the array in order, as described in “Searching”. As the array gets longer, the search time gets longer in direct proportion.

For dictionaries, Julia uses an algorithm called a *hash table* that has a remarkable property: the `∈` operator takes about the same amount of time no matter how many items are in the dictionary.
"""

# ╔═╡ 27e4cf0c-85c8-11eb-0d95-ab9ddc845387
md"""## Dictionaries as Collections of Counters

Suppose you are given a string and you want to count how many times each letter appears. There are several ways you could do it:

* You could create 26 variables, one for each letter of the alphabet. Then you could traverse the string and, for each character, increment the corresponding counter, probably using a chained conditional.
* You could create an array with 26 elements. Then you could convert each character to a number (using the built-in function Int), use the number as an index into the array, and increment the appropriate counter.
* You could create a dictionary with characters as keys and counters as the corresponding values. The first time you see a character, you would add an item to the dictionary. After that you would increment the value of an existing item.

Each of these options performs the same computation, but each of them implements that computation in a different way.

An *implementation* is a way of performing a computation. Some implementations are better than others. For example, an advantage of the dictionary implementation is that we don’t have to know ahead of time which letters appear in the string and we only have to make room for the letters that do appear.

Here is what the code might look like:

```julia
function histogram(s) 
	d = Dict()
	for c in s
		if c ∉ keys(d)
			d[c] = 1 
		else
			d[c] += 1 
		end
	end
	d
end
```

The name of the function is `histogram`, which is a statistical term for a collection of counters (or frequencies).


The first line of the function creates an empty dictionary. The `for` loop traverses the string. Each time through the loop, if the character `c` is not in the dictionary, we create a new item with key `c` and the initial value `1` (since we have seen this letter once). If `c` is already in the dictionary we increment `d[c]`.

Here’s how it works:

```julia
julia> h = histogram("brontosaurus") Dict{Any,Any} with 8 entries:
  'n' => 1
  's' => 2
  'a' => 1
  'r' => 2
  't' => 1
  'o' => 2
  'u' => 2
  'b' => 1
```

The histogram indicates that the letters *a* and *b* appear once, *o* appears twice, and so on.

Dictionaries have a function called `get` that takes a key and a default value. If the key appears in the dictionary, `get` returns the corresponding value; otherwise, it returns the default value. For example:

```julia
julia> h = histogram("a") 
Dict{Any,Any} with 1 entry:
  'a' => 1
julia> get(h, 'a', 0) 
1
julia> get(h, 'b', 0) 
0
```
"""

# ╔═╡ c8dff15e-85c8-11eb-1230-bd39702cf460
md"""#### Exercise 11-1

Use `get` to write `histogram` more concisely. You should be able to eliminate the `if` statement. What does the function `get!` do? Can you use it to simplify `histogram`?
"""

# ╔═╡ 0b2e93b0-85c9-11eb-0dc3-61b1cbfb022b
md"""## Looping and Dictionaries

You can traverse the keys of a dictionary in a for statement. For example, `printhist` prints each key and the corresponding value:

```julia
function printhist(h) 
	for c in keys(h)
		println(c, " ", h[c]) 
	end
end
```

Here’s what the output looks like:

```julia
julia> h = histogram("parrot");

julia> printhist(h) 
a 1
r 2
p 1
o 1 
t 1
```

Again, the keys are in no particular order. To traverse the keys in sorted order, you can combine `sort` and `collect`:

```julia
julia> for c in sort(collect(keys(h))) 
	       println(c, " ", h[c])
       end
a 1 
o 1 
p 1 
r 2 
t 1
```
"""

# ╔═╡ 82a2f936-85c9-11eb-1d33-0d9dc98fdac0
md"""## Reverse Lookup

Given a dictionary `d` and a key `k`, it is easy to find the corresponding value `v = d[k]`. This operation is called a *lookup*.

But what if you have `v` and you want to find `k`? You have two problems. First, there might be more than one key that maps to the value `v`. Depending on the application, you might be able to pick one, or you might have to make an array that contains all of them. Second, there is no simple syntax to do a *reverse lookup*; you have to search.

!!! danger
    A reverse lookup is much slower than a forward lookup; if you have to do it often, or if the dictionary gets big, the performance of your program will suffer.

Here is a function that takes a value and returns the first key that maps to that value:

```julia
function reverselookup(d, v) 
	for k in keys(d)
		if d[k]==v 
			return k
		end 
	end
	error("LookupError") 
end
```

This function is yet another example of the search pattern, but it uses a function we haven’t seen before: `error`. The `error` function is used to produce an `ErrorException` that interrupts the normal flow of control. In this case it has the message `"LookupError"`, indicating that a key does not exist.


If we get to the end of the loop, that means `v` doesn’t appear in the dictionary as a value, so we throw an exception.

Here is an example of a successful reverse lookup:

```julia
julia> h = histogram("parrot"); 

julia> key = reverselookup(h, 2)
'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)
```

And an unsuccessful one:

```julia
julia> key = reverselookup(h, 3) 
ERROR: LookupError
```

The effect when you generate an exception is the same as when Julia throws one: it prints a stacktrace and an error message.

!!! tip
    Julia provides an optimized way to do a reverse lookup: findall(isequal(3), h).
"""

# ╔═╡ 6d87ad02-85ca-11eb-2a3d-999d28a7c4b7
md"""## Dictionaries and Arrays

Arrays can appear as values in a dictionary. For example, if you are given a dictionary that maps from letters to frequencies, you might want to invert it—that is, create a dictionary that maps from frequencies to letters. Since there might be several letters with the same frequency, each value in the inverted dictionary should be an array of letters.

Here is a function that inverts a dictionary:

```julia
function invertdict(d) 
	inverse = Dict()
	for key in keys(d) 
		val = d[key]
		if val ∉ keys(inverse) 
			inverse[val] = [key]
		else
			push!(inverse[val], key) 
		end
	end
	inverse
end
```

Each time through the loop, `key` gets a key from `d` and `val` gets the corresponding value. If `val` is not in `inverse`, that means we haven’t seen it before, so we create a new item and initialize it with a *singleton* (an array that contains a single element). Otherwise, we have seen this value before, so we append the corresponding key to the array.

Here is an example:

```julia
julia> hist = histogram("parrot");

julia> inverse = invertdict(hist) Dict{Any,Any} with 2 entries:
  2 => ['r']
  1 => ['a', 'p', 'o', 't']
```

Figure 11-1 is a state diagram showing `hist` and `inverse`. A dictionary is represented as a box with the key-value pairs inside. If the values are integers, floats, or strings, I draw them inside the box, but I usually draw arrays outside the box, just to keep the diagram simple.
"""

# ╔═╡ 4fb90040-85cb-11eb-23dd-ad9ea62b94c3
Drawing(width=720, height=150) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=105, y=80, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("hist ->") 
	end
	rect(x=120, y=20, width=150, height=110, fill="rgb(242, 242, 242)", stroke="black")
	text(x=140, y=40, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'o'") 
	end
	line(x1=170, y1=35, x2=220, y2=35, stroke="black", marker_end="url(#arrow)")
	text(x=240, y=40, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=140, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'a'") 
	end
	line(x1=170, y1=55, x2=220, y2=55, stroke="black", marker_end="url(#arrow)")
	text(x=240, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=140, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'p'") 
	end
	text(x=140, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'t'") 
	end
	text(x=140, y=120, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'r'") 
	end
	line(x1=170, y1=115, x2=220, y2=115, stroke="black", marker_end="url(#arrow)")
	text(x=240, y=120, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=170, y1=95, x2=220, y2=95, stroke="black", marker_end="url(#arrow)")
	text(x=240, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=170, y1=75, x2=220, y2=75, stroke="black", marker_end="url(#arrow)")
	text(x=240, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=410, y=80, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("inverse ->") 
	end
    rect(x=520, y=10, width=150, height=90, fill="rgb(242, 242, 242)", stroke="black")
	text(x=540, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=560, y1=25, x2=610, y2=25, stroke="black", marker_end="url(#arrow)")
	text(x=630, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'o'") 
	end
	text(x=540, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=560, y1=45, x2=610, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=630, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'a'") 
	end
	text(x=540, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3") 
	end
	line(x1=560, y1=65, x2=610, y2=65, stroke="black", marker_end="url(#arrow)")
	text(x=630, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'p'") 
	end
	text(x=540, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("4") 
	end
	line(x1=560, y1=85, x2=610, y2=85, stroke="black", marker_end="url(#arrow)")
	text(x=630, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'t'") 
	end
	rect(x=520, y=110, width=150, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=540, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=560, y1=125, x2=610, y2=125, stroke="black", marker_end="url(#arrow)")
	text(x=630, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("'r'") 
	end
	rect(x=420, y=10, width=50, height=130, fill="rgb(242, 242, 242)", stroke="black")
	text(x=440, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=460, y1=55, x2=510, y2=55, stroke="black", marker_end="url(#arrow)")
	text(x=440, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=460, y1=125, x2=510, y2=125, stroke="black", marker_end="url(#arrow)")
end

# ╔═╡ 26c0d704-85cf-11eb-2a13-293b42210e70
md"*Figure 11-1. State diagram.*"

# ╔═╡ 35e8ee92-85cf-11eb-215c-21912c5fc92b
md"""!!! note
    I mentioned earlier that a dictionary is implemented using a hash table. That means that the keys have to be *hashable*.
    
    A *hash* is a function that takes a value (of any kind) and returns an integer. Dictionaries use these integers, called hash values, to store and look up key-value pairs.
"""

# ╔═╡ 8316e7a0-85cf-11eb-2ecb-df63279cadc6
md"""## Memos

If you played with the `fibonacci` function from “One More Example”, you might have noticed that the bigger the argument you provide, the longer the function takes to run. Furthermore, the runtime increases quickly.

To understand why, consider Figure 11-2, which shows the *call graph* for `fibonacci` with `n = 4`.
"""

# ╔═╡ c1e519e8-85cf-11eb-2ce1-4bcd389f56bf
Drawing(width=720, height=310) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	rect(x=310, y=10, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=325, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=325, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=340, y1=45, x2=375, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=390, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("4") 
	end
	line(x1=310, y1=60, x2=260, y2=85, stroke="black", marker_end="url(#arrow)")
	line(x1=410, y1=60, x2=460, y2=85, stroke="black", marker_end="url(#arrow)")
	rect(x=150, y=90, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=165, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=165, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=180, y1=125, x2=215, y2=125, stroke="black", marker_end="url(#arrow)")
	text(x=230, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3") 
	end
	line(x1=150, y1=140, x2=130, y2=162, stroke="black", marker_end="url(#arrow)")
	rect(x=75, y=170, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=90, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=90, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=105, y1=205, x2=140, y2=205, stroke="black", marker_end="url(#arrow)")
	text(x=155, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=250, y1=140, x2=270, y2=162, stroke="black", marker_end="url(#arrow)")
	rect(x=225, y=170, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=240, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=240, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=255, y1=205, x2=290, y2=205, stroke="black", marker_end="url(#arrow)")
	text(x=305, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=75, y1=220, x2=53, y2=242, stroke="black", marker_end="url(#arrow)")
	rect(x=0, y=250, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=15, y=270, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=15, y=290, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=30, y1=285, x2=65, y2=285, stroke="black", marker_end="url(#arrow)")
	text(x=80, y=290, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	line(x1=175, y1=220, x2=197, y2=242, stroke="black", marker_end="url(#arrow)")
	rect(x=150, y=250, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=150+15, y=270, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=150+15, y=290, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=150+30, y1=285, x2=150+65, y2=285, stroke="black", marker_end="url(#arrow)")
	text(x=150+80, y=290, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("0") 
	end
	rect(x=470, y=90, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=485, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=485, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=500, y1=125, x2=535, y2=125, stroke="black", marker_end="url(#arrow)")
	text(x=550, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	line(x1=570, y1=140, x2=590, y2=162, stroke="black", marker_end="url(#arrow)")
	rect(x=720-175, y=170, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=720-175+15, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=720-175+15, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=720-175+30, y1=205, x2=720-175+65, y2=205, stroke="black", marker_end="url(#arrow)")
	text(x=720-175+80, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("0") 
	end
	line(x1=470, y1=140, x2=450, y2=162, stroke="black", marker_end="url(#arrow)")
	rect(x=720-325, y=170, width=100, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=720-325+15, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("fibonacci") 
	end
	text(x=720-325+15, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	line(x1=720-325+30, y1=205, x2=720-325+65, y2=205, stroke="black", marker_end="url(#arrow)")
	text(x=720-325+80, y=210, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
end

# ╔═╡ 2a7646fe-85d9-11eb-3bbe-95f975f3901f
md"*Figure 11-2. Call graph.*"

# ╔═╡ 388a8d90-85d9-11eb-08f1-6b622cfb2c11
md"""A call graph shows a set of function frames, with lines connecting each frame to the frames of the functions it calls. At the top of the graph, `fibonacci` with `n = 4` calls `fibonacci` with `n = 3` and `n = 2`. In turn, `fibonacci` with `n = 3` calls `fibonacci` with `n = 2`and `n = 1`, and so on.

Count how many times `fibonacci(0)` and `fibonacci(1)` are called. This is an inefficient solution to the problem, and it gets worse as the argument gets bigger.

One solution is to keep track of values that have already been computed by storing them in a dictionary. A previously computed value that is stored for later use is called a *memo*. Here is a “memoized” version of `fibonacci`:

```julia
const known = Dict(0=>0, 1=>1)

function fibonacci(n) 
	if n ∈ keys(known)
		return known[n] 
	end
    res = fibonacci(n-1) + fibonacci(n-2)
	known[n] = res
	res
end
```

`known` is a constant dictionary that keeps track of the Fibonacci numbers we already know. It starts with two items: `0` maps to `0` and `1` maps to `1`.

Whenever `fibonacci` is called, it checks `known`. If the result is already there, it can return immediately. Otherwise, it has to compute the new value, add it to the dictionary, and return it.

If you run this version of `fibonacci` and compare it with the original, you will find that it is much faster.
"""

# ╔═╡ 170c40ea-85da-11eb-2079-a912e41da021
md"""## Global Variables

In the previous example, `known` is created outside the function, so it belongs to the special frame called `Main`. Variables in `Main` are sometimes called *global* because they can be accessed from any function. Unlike local variables, which disappear when their function ends, global variables persist from one function call to the next.

For performance reasons, you should declare a global variable *constant* with the keyword `const`. You can no longer reassign the variable, but if it refers to a mutable value, you can modify the value.

!!! danger
    Global variables can be useful, but if you have a lot of them, and you modify them frequently, they can make programs hard to debug and perform badly.
"""

# ╔═╡ 698eb48a-85da-11eb-272f-157bb3fec731
md"""## Debugging

As you work with bigger datasets, it can become unwieldy to debug by printing and checking the output by hand. Here are some suggestions for debugging large datasets:
* Scale down the input.
  
  If possible, reduce the size of the dataset. For example, if the program reads a text file, start with just the first 10 lines, or with the smallest example you can find that errors. You should not edit the files themselves, but rather modify the pro‐ gram so it reads only the first n lines.
    
  If there is an error, you can reduce n to the smallest value that manifests the error, and then increase it gradually as you find and correct errors.

* Check summaries and types.
  
  Instead of printing and checking the entire dataset, consider printing summaries of the data: for example, the number of items in a dictionary or the total of an array of numbers.
  
  A common cause of runtime errors is a value that is not the right type. For debugging this kind of error, it is often enough to print the type of a value.
  
* Write self-checks.
  
  Sometimes you can write code to check for errors automatically. For example, if you are computing the average of an array of numbers, you could check that the result is not greater than the largest element in the array or less than the smallest. This is called a “sanity check.”
  
  Another kind of check compares the results of two different computations to see if they are consistent. This is called a “consistency check.”
  
* Format the output.

  Formatting debugging output can make it easier to spot an error. We saw an example in “Debugging”.
  
  Again, time you spend building scaffolding can reduce the time you spend debugging.
"""

# ╔═╡ 057b7444-85db-11eb-1dc3-179e19732c1c
md"""## Glossary

*dictionary*:
A mapping from keys to their corresponding values.

*key*:
An object that appears in a dictionary as the first part of a key-value pair.

*value*:
An object that appears in a dictionary as the second part of a key-value pair. This is more specific than our previous use of the word “value.”

*key-value pair*:
The representation of the mapping from a key to a value.

*item*:
In a dictionary, another name for a key-value pair.

*mapping*:
A relationship in which each element of one set corresponds to an element of another set.

*hash table*:
The algorithm used to implement Julia dictionaries.

*implementation*:
A way of performing a computation.

*lookup*:
A dictionary operation that takes a key and finds the corresponding value.

*reverse lookup*:
A dictionary operation that takes a value and finds one or more keys that map to it.

*singleton*:
An array (or other sequence) with a single element.

*hashable*:
A type that has a hash function.

*hash function*:
A function used by a hash table to compute the location for a key.

*call graph*:
A diagram that shows every frame created during the execution of a program, with an arrow from each caller to each callee.

*memo*:
A computed value stored to avoid unnecessary future computation.

*global variable*:
A variable defined outside a function. Global variables can be accessed from any function.

*constant global variable*
A global variable that cannot be reassigned.
"""

# ╔═╡ 64397616-85db-11eb-0150-fd07faf0ee9b
md"""## Exercises 

#### Exercise 11-2

Write a function that reads the words in words.txt and stores them as keys in a dictionary. It doesn’t matter what the values are. Then you can use the `∈` operator as a fast way to check whether a string is in the dictionar.

If you did “Exercise 10-10”, you can compare the speed of this implementation with the array `∈` operator and the bisection search.
"""

# ╔═╡ 9513aed2-85db-11eb-19ee-dd547267503b
md"""#### Exercise 11-3

Read the documentation of the dictionary function `get!` and use it to write a more concise version of `invertdict`.
"""

# ╔═╡ a5cd8176-85db-11eb-193c-75864c42871e
md"""#### Exercise 11-4

Memoize the Ackermann function from “Exercise 6-5” and see if memoization makes it possible to evaluate the function with bigger arguments.
"""

# ╔═╡ b8989c78-85db-11eb-3a4a-c3bb2dc3a988
md"""#### Exercise 11-5

If you did “Exercise 10-7”, you already have a function named `hasduplicates` that takes an array as a parameter and returns true if there is any object that appears more than once in the array.


Use a dictionary to write a faster, simpler version of `hasduplicates`.
"""

# ╔═╡ d4c39484-85db-11eb-0ed1-a3268690454e
md"""#### Exercise 11-6

Two words are “rotate pairs” if you can rotate one of them and get the other (see rotateword in “Exercise 8-11”).

Write a program that reads a word array and finds all the rotate pairs.
"""

# ╔═╡ e388e7f8-85db-11eb-0451-df6af9de2adc
md"""#### Exercise 11-7

Here’s another Puzzler from Car Talk:

> [A contributor] came upon a common one-syllable, five-letter word recently that has the following unique property. When you remove the first letter, the remaining letters form a homophone of the original word, that is a word that sounds exactly the same. Replace the first letter, that is, put it back and remove the second letter and the result is yet another homophone of the original word. And the question is, what’s the word?
> 
> Now I’m going to give you an example that doesn’t work. Let’s look at the five-letter word, ‘wrack.’ W-R-A-C-K, you know like to ‘wrack with pain.’ If I remove the first letter, I am left with a four-letter word, ‘R-A-C-K.’ As in, ‘Holy cow, did you see the rack on that buck! It must have been a nine-pointer!’ It’s a perfect homophone. If you put the ‘w’ back, and remove the ‘r,’ instead, you’re left with the word, ‘wack,’ which is a real word, it’s just not a homophone of the other two words.
> 
> But there is, however, at least one word that [I] know of, which will yield two homophones if you remove either of the first two letters to make two, new four-letter words. The question is, what’s the word?

You can use the dictionary from “Exercise 11-2” to check whether a string is in the word array.
!!! tip
    To check whether two words are homophones, you can use the Carnegie Mellon University Pronouncing Dictionary.

Write a program that lists all the words that solve the Puzzler.
"""

# ╔═╡ Cell order:
# ╟─bcaefa4e-85c6-11eb-3316-0db4881ebd30
# ╟─13d62b06-85c7-11eb-00b9-0399467b1ab5
# ╟─1f1c885e-85c7-11eb-1452-13a8943ebc90
# ╟─27e4cf0c-85c8-11eb-0d95-ab9ddc845387
# ╟─c8dff15e-85c8-11eb-1230-bd39702cf460
# ╟─0b2e93b0-85c9-11eb-0dc3-61b1cbfb022b
# ╟─82a2f936-85c9-11eb-1d33-0d9dc98fdac0
# ╟─6d87ad02-85ca-11eb-2a3d-999d28a7c4b7
# ╟─4fb90040-85cb-11eb-23dd-ad9ea62b94c3
# ╟─26c0d704-85cf-11eb-2a13-293b42210e70
# ╟─35e8ee92-85cf-11eb-215c-21912c5fc92b
# ╟─8316e7a0-85cf-11eb-2ecb-df63279cadc6
# ╟─c1e519e8-85cf-11eb-2ce1-4bcd389f56bf
# ╟─2a7646fe-85d9-11eb-3bbe-95f975f3901f
# ╟─388a8d90-85d9-11eb-08f1-6b622cfb2c11
# ╟─170c40ea-85da-11eb-2079-a912e41da021
# ╟─698eb48a-85da-11eb-272f-157bb3fec731
# ╟─057b7444-85db-11eb-1dc3-179e19732c1c
# ╟─64397616-85db-11eb-0150-fd07faf0ee9b
# ╟─9513aed2-85db-11eb-19ee-dd547267503b
# ╟─a5cd8176-85db-11eb-193c-75864c42871e
# ╟─b8989c78-85db-11eb-3a4a-c3bb2dc3a988
# ╟─d4c39484-85db-11eb-0ed1-a3268690454e
# ╟─e388e7f8-85db-11eb-0451-df6af9de2adc
