### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ 2444e25e-76e3-11eb-021a-e9e976b267bb
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
"""

# ╔═╡ c6ea295e-e172-497d-8d21-e1f67b99c8f4
'x'

# ╔═╡ 3fdc38b1-79ca-4cfa-82d3-ddb3e652805d
typeof('x')

# ╔═╡ a683a0d3-1149-4efd-a50f-16ded14338e5
'🍌'

# ╔═╡ f91236cd-dbf7-4e61-82af-356397cab6bb
md"""Even emojis are part of the Unicode standard (**`\:banana: TAB`**).
"""

# ╔═╡ b29b3ca6-76e3-11eb-0970-1bee030205f2
md"""## A String Is a Sequence

A string is a sequence of characters. You can access the characters one at a time with the bracket operator (`[]`):
"""

# ╔═╡ 07d91b17-bd32-4472-9187-2c2548c2141b
fruit = "banana"

# ╔═╡ 01cee916-d6f2-41d1-b45f-ab33869f1a2c
letter = fruit[1]

# ╔═╡ 8222bd8d-cc71-4cb3-8a13-ad2a513e10f9
md"""The second statement selects character number 1 from `fruit` and assigns it to `letter`.

The expression in brackets is called an *index*. The index indicates which character in the sequence you want (hence the name).

All indexing in Julia is 1-based—the first element of any integer-indexed object is found at index `1` or `begin` and the last element at index `end`:
"""

# ╔═╡ 01d2fa7b-d382-4dd1-9bd6-0a2a0125b594
fruit[begin]

# ╔═╡ 7251c0b7-6bfe-49f5-8eb8-54684b341cbf
fruit[end]

# ╔═╡ edb7be60-9931-480c-8001-02c7ab084cfb
md"""As an index, you can use an expression that contains variables and operators:
"""

# ╔═╡ 61bce329-54a2-47eb-a326-489c678b6be1
i = 1

# ╔═╡ 9b7680b6-fa6f-4f86-a108-066fddea209f
fruit[i+1]

# ╔═╡ e89e7ae5-1530-435c-8629-f02ea48553cc
fruit[end-1]

# ╔═╡ 80a039ba-9b7a-47e3-9107-f9ec2c3dca4a
md"""But the value of the index has to be an integer. Otherwise, you get:
"""

# ╔═╡ 72323498-88be-408c-8195-6d9ad06c083b
fruit[1.5]

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

# ╔═╡ e6a4882e-79fc-11eb-3957-95357985303f
md"""## String Interpolation

Constructing strings using concatenation can become a bit cumbersome. To reduce the need for these verbose calls to string or repeated multiplications, Julia allows *string interpolation* using `$`:

```julia
julia> greet = "Hello" 
"Hello"
julia> whom = "World" 
"World"
julia> "$greet, $(whom)!" 
"Hello, World!"
```

This is more readable and convenient than string concatenation:

```julia
greet * ", " * whom * "!"
```

The shortest complete expression after the `$` is taken as the expression whose value is to be interpolated into the string. Thus, you can interpolate any expression into a string using parentheses:

```julia
julia> "1 + 2 = $(1 + 2)" 
"1 + 2 = 3"
```
"""

# ╔═╡ 36ac2624-79fd-11eb-1099-910ca7cea1c9
md"""## Searching
What does the following function do?

```julia
function find(word, letter) 
	index = firstindex(word) 
	while index <= sizeof(word)
		if word[index] == letter 
			return index
		end
		index = nextind(word, index) 
	end
	-1 
end
```

In a sense, `find` is the inverse of the `[]` operator. Instead of taking an index and extracting the corresponding character, it takes a character and finds the index where that character appears. If the character is not found, the function returns `-1`.


This is the first example we have seen of a `return` statement inside a loop. If `word[index] == letter`, the function breaks out of the loop and returns immediately.

If the character doesn’t appear in the string, the program exits the loop normally and returns `-1`.

This pattern of computation—traversing a sequence and returning when we find what we are looking for—is called a *search*.
"""

# ╔═╡ e04750c8-79fd-11eb-0249-ed3fb7e031b2
md"""#### Exercise 8-4

Modify `find` so that it has a third parameter, the index in word where it should start looking.
"""

# ╔═╡ 019a3968-79fe-11eb-206a-3d92d9352524
md"""## Looping and Counting

The following program counts the number of times the letter a appears in a string:

```julia
word = "banana" 
counter = 0
for letter in word
	if letter == 'a'
		counter = counter + 1
	end 
end
println(counter)
```

This program demonstrates another pattern of computation called a *counter*. The variable `counter` is initialized to `0` and then incremented each time an `a` is found. When the loop exits, counter contains the result—the total number of `a`’s.
"""

# ╔═╡ 5af18f32-79fe-11eb-1860-0f08e3d25a3f
md"""#### Exercise 8-5

Encapsulate this code in a function named `count`, and generalize it so that it accepts the string and the letter as arguments.

Then rewrite the function so that instead of traversing the string, it uses the three parameter version of `find` from the previous section.
"""

# ╔═╡ 8d5f176e-79fe-11eb-29fc-813db53b35a6
md"""## String Library

Julia provides functions that perform a variety of useful operations on strings. For example, the function `uppercase` takes a string and returns a new string with all uppercase letters:

```julia
julia> uppercase("Hello, World!") 
"HELLO, WORLD!"
```

As it turns out, there is a function named `findfirst` that is remarkably similar to the `find` function we wrote:

```julia
julia> findfirst("a", "banana") 
2:2
```

Actually, the `findfirst` function is more general than our function; it can find sub‐ strings, not just characters:

```julia
julia> findfirst("na", "banana") 
3:4
```

By default, `findfirst` starts at the beginning of the string, but the function `findnext` takes a third argument, the index where it should start looking:

```julia
julia> findnext("na", "banana", 4) 
5:6
```
"""

# ╔═╡ e80e049a-79fe-11eb-2ade-83a99e44e5a5
md"""## The `∈` Operator

The operator `∈` (**`\in TAB`**) is a Boolean operator that takes a character and a string and returns `true` if the first appears in the second: 

```julia
julia> 'a' ∈ "banana" # 'a' in "banana"
true
```

For example, the following function prints all the letters from `word1` that also appear in `word2`:

```julia
function inboth(word1, word2) 
	for letter in word1
		if letter ∈ word2 
			print(letter, " ")
		end 
	end
end
```

With well-chosen variable names, Julia sometimes reads like English. You could read this loop as “for (each) letter in (the first) word, if (the) letter is an element of (the second) word, print (the) letter.”

Here’s what you get if you compare `"apples"` and `"oranges"`: 

```julia
julia> inboth("apples", "oranges")
a e s
```
"""

# ╔═╡ 5487357e-79ff-11eb-2492-d35dfed491cc
md"""## String Comparison

The relational operators work on strings. To see if two strings are equal, use `==`:

```julia
word = "Pineapple" 
if word == "banana"
	println("All right, bananas.") 
end
```

Other relational operations are useful for putting words in alphabetical order:

```julia
if word < "banana"
	println("Your word, $word, comes before banana.")
elseif word > "banana"
	println("Your word, $word, comes after banana.")
else
	println("All right, bananas.")
end
```

Julia does not handle uppercase and lowercase letters the same way people do. All the uppercase letters come before all the lowercase letters, so:

```
Your word, Pineapple, comes before banana.
```

!!! tip
    A common way to address this problem is to convert strings to a standard format, such as all lowercase, before performing the comparison.
"""

# ╔═╡ a05f7e2a-79ff-11eb-16f9-db358e178910
md"""## Debugging

When you use indices to traverse the values in a sequence, it is tricky to get the beginning and end of the traversal right. Here is a function that is supposed to compare two words and return `true` if one of the words is the reverse of the other, but it contains two errors:

```julia
function isreverse(word1, word2)
	if length(word1) != length(word2)
		return false
    end
	i = firstindex(word1) 
	j = lastindex(word2) 
	while j >= 0
		j = prevind(word2, j) 
		if word1[i] != word2[j]
			return false
		end
		i = nextind(word1, i) 
	end
	true 
end
```

The first `if` statement checks whether the words are the same length. If not, we can return `false` immediately. Otherwise, for the rest of the function, we can assume that the words are the same length. This is an example of the guardian pattern; see “Checking Types”.

`i` and `j` are indices: `i` traverses `word1` forward while `j` traverses `word2` backward. If we find two letters that don’t match, we can return false immediately. If we get through the whole loop and all the letters match, we return `true`.

The function `lastindex` returns the last valid byte index of a string and `prevind` finds the previous valid index of a character.

If we test this function with the words `“pots”` and `“stop”`, we expect the return value `true`, but we get `false`:

```julia
julia> isreverse("pots", "stop") 
false
```

For debugging this kind of error, my first move is to print the values of the indices:

```julia
while j >= 0
	j = prevind(word2, j)
	@show i j
	if word1[i] != word2[j]
```

Now when I run the program again, I get more information:

```julia
julia> isreverse("pots", "stop") 
i = 1
j = 3
false
```

The first time through the loop, the value of `j` is `3`, but it has to be `4`. This can be fixed by moving `j = prevind(word2, j)` to the end of the `while` loop.

If I fix that error and run the program again, I get:

```julia
julia> isreverse("pots", "stop") 
i = 1
j = 4
i = 2
j = 3
i = 3
j = 2
i = 4
j = 1
i = 5
j = 0
ERROR: BoundsError: attempt to access "pots"
at index [5]
```

This time a `BoundsError` has been thrown. The value of `i` is `5`, which is out of range for the string `"pots"`.
"""

# ╔═╡ c657df0e-7a00-11eb-06e7-b1839a01a3b1
md"""#### Exercise 8-6

Run the program on paper, changing the values of `i` and `j` during each iteration. Find and fix the second error in this function.
"""

# ╔═╡ e8baffa4-7a00-11eb-3373-3d1dc1e6a952
md"""## Glossary

*sequence*:
An ordered collection of values where each value is identified by an integer index.

*ASCII standard*:
A character encoding standard for electronic communication specifying 128 characters.

*Unicode standard*:
A computing industry standard for the consistent encoding, representation, and handling of text expressed in most of the world’s writing systems.

*index*:
An integer value used to select an item in a sequence, such as a character in a string. In Julia indices start from 1.

*UTF-8 encoding*:
A variable-width character encoding capable of encoding all 1,112,064 valid code points in Unicode using one to four 8-bit bytes.

*traverse*:
To iterate through the items in a sequence, performing a similar operation on each.
slice

*empty string*:
A string with no characters and length 0, represented by two quotation marks.

*immutable*:
The property of a sequence whose items cannot be changed.

*string interpolation*:
The process of evaluating a string containing one or more placeholders, yielding a result in which the placeholders are replaced with their corresponding values.

*search*:
A pattern of traversal that stops when it finds what it is looking for.

*counter*:
A variable used to count something, usually initialized to zero and then incremented.
"""

# ╔═╡ 55115388-7a01-11eb-2a9e-a769127bc90d
md"""## Exercises 

#### Exercise 8-7

Read the [documentation of the string functions](https://docs.julialang.org/en/v1/manual/strings/). You might want to experiment with some of them to make sure you understand how they work. `strip` and `replace` are particularly useful.


The documentation uses a syntax that might be confusing. For example, in `search(string::AbstractString, chars::Chars, [start::Integer])`, the brackets indicate optional arguments. So, `string` and `chars` are required, but `start` is optional.
"""

# ╔═╡ bcb82726-7a01-11eb-1b75-7136ad9adfb6
md"""#### Exercise 8-8

There is a built-in function called count that is similar to the function in “Looping and Counting”. Read the documentation of this function and use it to count the number of `a`’s in `"banana"`.
"""

# ╔═╡ d33a25a0-7a01-11eb-35cc-573b861aadbb
md"""#### Exercise 8-9

A string slice can take a third index. The first specifies the start, the third the end, and the second the “step size”; that is, the number of spaces between successive characters. A step size of 2 means every other character; 3 means every third, etc. For example:

```julia
julia> fruit = "banana" 
"banana"
julia> fruit[1:2:6] 
"bnn"
```

A step size of `-1` goes through the word backward, so the slice `[end:-1:begin]` generates a reversed string.

Use this idiom to write a one-line version of `ispalindrome` from “Exercise 6-6”.
"""

# ╔═╡ 0d718e70-7a02-11eb-27e0-0f145b163d55
md"""#### Exercise 8-10

The following functions are all *intended* to check whether a string contains any lowercase letters, but at least some of them are wrong. For each function, describe what the function actually does (assuming that the parameter is a string).

```julia
function anylowercase1(s) 
	for c in s
		if islowercase(c) 
			return true
		else
			return false
		end 
	end
end

function anylowercase2(s) 
	for c in s
		if islowercase('c') 
			return "true"
		else
			return "false"
		end 
	end
end

function anylowercase3(s)
	for c in s
		flag = islowercase(c) 
	end
	flag
end

function anylowercase4(s) 
	flag = false
	for c in s
		flag = flag || islowercase(c)
	end
	flag
end

function anylowercase5(s) 
	for c in s
		if !islowercase(c) 
			return false
		end 
	end
	true 
end
```
"""

# ╔═╡ 7e1acfec-7a02-11eb-2b50-ff3f9e93545e
md"""#### Exercise 8-11

A Caesar cypher is a weak form of encryption that involves “rotating” each letter by a fixed number of places. To rotate a letter means to shift it through the alphabet, wrap‐ ping around to the beginning if necessary, so *`A`* rotated by 3 is *`D`* and *`Z`* rotated by 1 is *`A`*.

To rotate a word, rotate each letter by the same amount. For example, `"cheer"` rota‐ ted by 7 is `"jolly"` and `"melon"` rotated by –10 is `"cubed"`. In the movie *2001: A Space Odyssey*, the ship’s computer is called “HAL,” which is “IBM” rotated by –1.

Write a function called `rotateword` that takes a string and an integer as parameters, and returns a new string that contains the letters from the original string rotated by the given amount.

!!! tip
    You might want to use the built-in functions `Int`, which converts a character to a numeric code, and `Char`, which converts numeric codes to characters. Letters of the alphabet are encoded in alphabetical order, so, for example:
    
    ```julia
    julia> Int('c') - Int('a') 
    2
    ```
    
    because *c* is the third letter of the alphabet. But beware—the numeric codes for uppercase letters are different:
    
    ```julia
    julia> Char(Int('A') + 32)
    'a': ASCII/Unicode U+0061 (category Ll: Letter, lower case)
    ```

Potentially offensive jokes on the internet are sometimes encoded in ROT13, which is a Caesar cypher with rotation 13. If you are not easily offended, find and decode some of them.
"""

# ╔═╡ Cell order:
# ╟─2444e25e-76e3-11eb-021a-e9e976b267bb
# ╟─d77c9e58-76e2-11eb-27a0-23914499f29f
# ╟─3eeafd32-76e3-11eb-01dc-53af6f26eaf7
# ╠═c6ea295e-e172-497d-8d21-e1f67b99c8f4
# ╠═3fdc38b1-79ca-4cfa-82d3-ddb3e652805d
# ╠═a683a0d3-1149-4efd-a50f-16ded14338e5
# ╟─f91236cd-dbf7-4e61-82af-356397cab6bb
# ╟─b29b3ca6-76e3-11eb-0970-1bee030205f2
# ╠═07d91b17-bd32-4472-9187-2c2548c2141b
# ╠═01cee916-d6f2-41d1-b45f-ab33869f1a2c
# ╟─8222bd8d-cc71-4cb3-8a13-ad2a513e10f9
# ╠═01d2fa7b-d382-4dd1-9bd6-0a2a0125b594
# ╠═7251c0b7-6bfe-49f5-8eb8-54684b341cbf
# ╟─edb7be60-9931-480c-8001-02c7ab084cfb
# ╠═61bce329-54a2-47eb-a326-489c678b6be1
# ╠═9b7680b6-fa6f-4f86-a108-066fddea209f
# ╠═e89e7ae5-1530-435c-8629-f02ea48553cc
# ╟─80a039ba-9b7a-47e3-9107-f9ec2c3dca4a
# ╠═72323498-88be-408c-8195-6d9ad06c083b
# ╟─ade32e66-76e4-11eb-165e-13867b2cdc2d
# ╟─ac377fee-76e5-11eb-1736-9190b5c92214
# ╟─20c034f2-76e6-11eb-1f6d-891ef3f93b29
# ╟─2c1d4452-76e6-11eb-1cc4-0be827cdb64d
# ╟─84220d54-76e6-11eb-24d3-b7085b8766b8
# ╟─c170dc56-76e6-11eb-2bd1-050911e1915f
# ╟─559c8a42-76e7-11eb-371c-391c5deba644
# ╟─67110424-76e7-11eb-14c3-e195649e6d41
# ╟─e6a4882e-79fc-11eb-3957-95357985303f
# ╟─36ac2624-79fd-11eb-1099-910ca7cea1c9
# ╟─e04750c8-79fd-11eb-0249-ed3fb7e031b2
# ╟─019a3968-79fe-11eb-206a-3d92d9352524
# ╟─5af18f32-79fe-11eb-1860-0f08e3d25a3f
# ╟─8d5f176e-79fe-11eb-29fc-813db53b35a6
# ╟─e80e049a-79fe-11eb-2ade-83a99e44e5a5
# ╟─5487357e-79ff-11eb-2492-d35dfed491cc
# ╟─a05f7e2a-79ff-11eb-16f9-db358e178910
# ╟─c657df0e-7a00-11eb-06e7-b1839a01a3b1
# ╟─e8baffa4-7a00-11eb-3373-3d1dc1e6a952
# ╟─55115388-7a01-11eb-2a9e-a769127bc90d
# ╟─bcb82726-7a01-11eb-1b75-7136ad9adfb6
# ╟─d33a25a0-7a01-11eb-35cc-573b861aadbb
# ╟─0d718e70-7a02-11eb-27e0-0f145b163d55
# ╟─7e1acfec-7a02-11eb-2b50-ff3f9e93545e
