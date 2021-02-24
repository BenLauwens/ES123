### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 2444e25e-76e3-11eb-021a-e9e976b267bb
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ d77c9e58-76e2-11eb-27a0-23914499f29f
md"""# Strings

Strings are not like integers, floats, and booleans. A string is a *sequence*, which means it is an ordered collection of other values. In this chapter you’ll see how to access the characters that make up a string, and you’ll learn about some of the string helper functions provided by Julia.
"""

# ╔═╡ 3eeafd32-76e3-11eb-01dc-53af6f26eaf7
md"""## Characters

English language speakers are familiar with characters such as the letters of the alphabet (A, B, C, ...), numerals, and common punctuation. These characters are standar‐ dized and mapped to integer values between 0 and 127 by the *ASCII standard* (American Standard Code for Information Interchange).

There are, of course, many other characters used in non-English languages, including variants of the ASCII characters with accents and other modifications, related scripts such as Cyrillic and Greek, and scripts completely unrelated to ASCII and English, including Arabic, Chinese, Hebrew, Hindi, Japanese, and Korean.

The *Unicode standard* tackles the complexities of what exactly a character is, and is generally accepted as the definitive standard addressing this problem. It provides a unique number for every character on a worldwide scale.

A `Char` value represents a single character and is surrounded by single quotes:

```julia
julia> 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
julia> typeof('x')
Char
julia> '🍌'
'🍌': Unicode U+1F34C (category So: Symbol, other)
```

Even emojis are part of the Unicode standard (**`\:banana: TAB`**).
"""

# ╔═╡ b29b3ca6-76e3-11eb-0970-1bee030205f2
md"""## A String Is a Sequence

A string is a sequence of characters. You can access the characters one at a time with the bracket operator (`[]`):

```julia
julia> fruit = "banana"
"banana"
julia> letter = fruit[1]
'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
```

The second statement selects character number 1 from `fruit` and assigns it to `letter`.

The expression in brackets is called an *index*. The index indicates which character in the sequence you want (hence the name).

All indexing in Julia is 1-based—the first element of any integer-indexed object is found at index `1` or `begin` and the last element at index `end`:

```julia
julia> fruit[begin]
'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)
julia> fruit[end]
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
```

As an index, you can use an expression that contains variables and operators:

```julia
julia> i = 1
1
julia> fruit[i+1]
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase) 
julia> fruit[end-1]
'n': ASCII/Unicode U+006e (category Ll: Letter, lowercase)
```

But the value of the index has to be an integer. Otherwise, you get:

```julia
julia> letter = fruit[1.5]
ERROR: MethodError: no method matching getindex(::String, ::Float64)
```
"""

# ╔═╡ ade32e66-76e4-11eb-165e-13867b2cdc2d
md"""## `length`

`length` is a built-in function that returns the number of characters in a string:

```julia
julia> fruits = "🍌 🍎 🍐"
"🍌 🍎 🍐"
julia> len = length(fruits)
5
```

To get the last letter of a string, you might be tempted to try something like this:

```julia
julia> last = fruits[len]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```

But you might not get what you expect.

Strings are encoded using *UTF-8 encoding*. UTF-8 is a variable-width encoding, meaning that not all characters are encoded in the same number of bytes.

The function `sizeof` gives the number of bytes in a string: 

```julia
julia> sizeof("🍌")
4
```

Because an emoji is encoded in 4 bytes and string indexing is byte-based, the fifth element of fruits is a `SPACE`.

This also means that not every byte index into a UTF-8 string is necessarily a valid index for a character. If you index into a string at an invalid byte index, an error is thrown:

```julia
julia> fruits[2]
ERROR: StringIndexError("🍌 🍎 🍐", 2)
```

In the case of fruits, the character `🍌` is a 4-byte character, so the indices 2, 3, and 4 are invalid and the next character’s index is 5; this next valid index can be computed by `nextind(fruits, 1)`, the next index after that by `nextind(fruits, 5)` and so on.
"""

# ╔═╡ ac377fee-76e5-11eb-1736-9190b5c92214
md"""## Traversal

A lot of computations involve processing a string one character at a time. Often they start at the beginning, select each character in turn, do something to it, and continue until the end. This pattern of processing is called a *traversal*. One way to write a traversal is with a while loop:

```julia
index = firstindex(fruits) 
while index <= sizeof(fruits)
	letter = fruits[index] println(letter)
	index = nextind(fruits, index)
end
```

This loop traverses the string and displays each letter on a line by itself. The loop con‐ dition is `index <= sizeof(fruit)`, so when `index` is larger than the number of bytes in the string, the condition is `false` and the body of the loop doesn’t run.


The function `firstindex` returns the first valid byte index.
"""

# ╔═╡ 20c034f2-76e6-11eb-1f6d-891ef3f93b29
md"""#### Exercise 8-1

Write a function that takes a string as an argument and displays the letters backward, one per line.
"""

# ╔═╡ 2c1d4452-76e6-11eb-1cc4-0be827cdb64d
md"""Another way to write a traversal is with a `for` loop:

```julia
for letter in fruits 
	println(letter)
end
```

Each time through the loop, the next character in the string is assigned to the variable `letter`. The loop continues until no characters are left.


The following example shows how to use concatenation (string multiplication) and a for loop to generate an abecedarian series (i.e., in alphabetical order). In Robert McCloskey’s book *Make Way for Ducklings* (Puffin), the names of the ducklings are Jack, Kack, Lack, Mack, Nack, Ouack, Pack, and Quack. This loop outputs these names in order:

```julia
prefixes = "JKLMNOPQ"
suffix = "ack"
for letter in prefixes 
	println(letter * suffix)
end
```

Although the output isn’t quite right, because “Ouack” and “Quack” are misspelled:

```
Jack
Kack
Lack
Mack
Nack
Oack
Pack
Qack
```
"""

# ╔═╡ 84220d54-76e6-11eb-24d3-b7085b8766b8
md"""#### Exercise 8-2

Modify the program to fix this error.
"""

# ╔═╡ c170dc56-76e6-11eb-2bd1-050911e1915f
md"""## String Slices

A segment of a string is called a *slice*. Selecting a slice is similar to selecting a character:

```julia
julia> str = "Julius Caesar";

julia> str[1:6]
"Julius"
```

!!! tip
    A semicolon in REPL mode not only allows you to put multiple statements on one line but also hides the output.

The operator `[n:m]` returns the part of the string from the `n`th byte to the `m`th byte, so the same caution is needed as for simple indexing.

The `begin` / `end` keyword can be used to indicate the first / last byte of the string: 

```julia
julia> str[begin:6]
"Julius"
julia> str[8:end]
"Caesar"
```

If the first index is greater than the second the result is an empty string, represented by two quotation marks:

```julia
julia> str[8:7] 
""
```

An empty string contains no characters and has length 0, but other than that, it is the same as any other string.
"""

# ╔═╡ 559c8a42-76e7-11eb-371c-391c5deba644
md"""#### Exercise 8-3

Continuing this example, what do you think `str[:]` means? Try it and see."""

# ╔═╡ 67110424-76e7-11eb-14c3-e195649e6d41
md"""## Strings Are Immutable

It is tempting to use the `[]` operator on the left side of an assignment, with the intention of changing a character in a string. For example:

```julia
julia> greeting = "Hello, world!"
"Hello, world!"
julia> greeting[1] = 'J'
ERROR: MethodError: no method matching setindex!(::String, ::Char, ::Int64)
```

The reason for the error is that strings are *immutable*, which means you can’t change an existing string. The best you can do is create a new string that is a variation on the original:

```julia
julia> greeting = "J" * greeting[2:end] 
"Jello, world!"
```

This example concatenates a new first letter onto a slice of `greeting`. It has no effect on the original string.
"""

# ╔═╡ Cell order:
# ╟─2444e25e-76e3-11eb-021a-e9e976b267bb
# ╟─d77c9e58-76e2-11eb-27a0-23914499f29f
# ╟─3eeafd32-76e3-11eb-01dc-53af6f26eaf7
# ╟─b29b3ca6-76e3-11eb-0970-1bee030205f2
# ╟─ade32e66-76e4-11eb-165e-13867b2cdc2d
# ╟─ac377fee-76e5-11eb-1736-9190b5c92214
# ╟─20c034f2-76e6-11eb-1f6d-891ef3f93b29
# ╟─2c1d4452-76e6-11eb-1cc4-0be827cdb64d
# ╟─84220d54-76e6-11eb-24d3-b7085b8766b8
# ╟─c170dc56-76e6-11eb-2bd1-050911e1915f
# ╟─559c8a42-76e7-11eb-371c-391c5deba644
# ╟─67110424-76e7-11eb-14c3-e195649e6d41
