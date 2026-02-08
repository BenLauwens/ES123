### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ c4a4bfe6-79fc-11eb-389d-fb0dda01299f
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

# ╔═╡ 6e3f9f5e-79fc-11eb-22ec-47b9055afb05
md"""# Case Study: Word Play

This chapter presents a second case study, which involves solving word puzzles by searching for words that have certain properties. For example, we’ll find the longest palindromes in English and search for words whose letters appear in alphabetical order. And I will present another program development plan: reduction to a previously solved problem."""

# ╔═╡ dc744022-7a03-11eb-015f-47cde5608878
md"""## Reading Word Lists

For the exercises in this chapter we need a list of English words. There are lots of word lists available on the web, but the one most suitable for our purpose is one of the word lists collected and contributed to the public domain by Grady Ward as part of the [Moby lexicon](http://www.gutenberg.org/ebooks/3201) project. It is a list of 113,809 official crosswords; that is, words that are considered valid in crossword puzzles and other word games. In the Moby collection, the filename is *113809of.fic*; you can download a copy, with the simpler name *words.txt*, from these lectures’ GitHub repository.

This file is in plain text, so you can open it with a text editor, but you can also read it from Julia. The built-in function open takes a name of the file as a parameter and returns a file stream you can use to read the file:
"""

# ╔═╡ 15878448-b69e-447f-82c7-3bbc8016da14
begin
	path = joinpath(splitdir(@__FILE__)[1], "..", "data")
	fin = open(joinpath(path, "words.txt"))
end

# ╔═╡ cc8702f4-c0c6-4465-b334-edbc360befc3
md"""`path` is a string pointing to the local directory containing the data files. The functions `joinpath` and `splitdir`, and the macro `@__FILE__` will be detailed in Chapter 14. `fin` is a file stream used for input. When it is no longer needed, it has to be closed with `close(fin)`.

Julia provides several function for reading, including `readline`, which reads characters from the file until it gets to a *NEWLINE* and returns the result as a string:
"""

# ╔═╡ c7689458-dd39-48fd-9f9a-b0532158b7c5
readline(fin)

# ╔═╡ 0e3263b0-ffc3-45eb-baec-7ec45038d4e5
md"""The first word in this particular list is “aa”, which is a kind of lava.

The file stream keeps track of where it is in the file, so if you call `readlin`e again, you get the next word:
"""

# ╔═╡ 7d164697-51a3-4f7a-92b0-99e2fccd2cda
readline(fin)

# ╔═╡ d845252c-33b6-42e4-96e4-203f311cda9c
md"""The next word is “aah”, which is a perfectly legitimate word, so stop looking at me like that.

You can also use a file as part of a `for` loop. This program reads *words.txt* and prints each word, one per line:
"""

# ╔═╡ 4e2a5519-3ff1-4b05-9314-1849d10e2af8
let i = 1
	for line in eachline(joinpath(path, "words.txt"))
		println(line)
		if i == 10 break end
		i = i + 1
	end
end

# ╔═╡ 28712e7c-37cd-4bec-9129-cfe671bd8fde
md"""Only the first 10 words are printed ... this book is not a thesaurus.
"""

# ╔═╡ 1b1cb464-7a05-11eb-1069-a5d56ef55821
md"""## Exercises

### Exercise 9-1

Write a program that reads *words.txt* and prints only the words with more than 20 characters (not counting whitespace).

### Exercise 9-2

In 1939 Ernest Vincent Wright published a 50,000-word novel called Gadsby (Wetzel Publishing) that does not contain the letter *e*. Since *e* is the most common letter in English, that’s not easy to do.

In fact, it is difficult to construct a solitary thought without using that most common symbol. It is slow going at first, but with caution and hours of training you can gradually gain facility.

All right, I’ll stop now.

Write a function called `hasno_e` that returns true if the given word doesn’t have the
letter *e* in it.

Modify your program from the previous exercise to print only the words that have no *e* and compute the percentage of the words in the list that have no *e*.

### Exercise 9-3

Write a function named `avoids` that takes a word and a string of forbidden letters, and that returns true if the word doesn’t use any of the forbidden letters.

Modify your program to prompt the user to enter a string of forbidden letters and then print the number of words that don’t contain any of them. Can you find a combination of five forbidden letters that excludes the smallest number of words?

### Exercise 9-4

Write a function named `usesonly` that takes a word and a string of letters, and that returns true if the word contains only letters in the list. Can you make a sentence using only the letters *acefhlo*? Other than *"Hoe alfalfa"*?

### Exercise 9-5

Write a function named `usesall` that takes a word and a string of required letters, and that returns true if the word uses all the required letters at least once. How many words are there that use all the vowels *aeiou*? How about *aeiouy*?

### Exercise 9-6

Write a function called `isabecedarian` that returns `tru`e if the letters in a word appear in alphabetical order (double letters are okay). How many abecedarian words are there?
"""

# ╔═╡ 3ec4f68e-7a06-11eb-0942-0399471b3818
md"""## Search

All of the exercises in the previous section have something in common; they can be solved with the search pattern. The simplest example is:
"""

# ╔═╡ 5e3fd695-fef3-4fa6-86f1-3907cadd32e2
function hasno_e(word)
	for letter in word
		if letter == 'e'
			return false
		end
	end
	return true
end

# ╔═╡ 193292bb-1e81-4158-967c-c8f2c87c5e35
md"""The `for` loop traverses the characters in `word`. If we find the letter *e*, we can immediately return `false`; otherwise, we have to go to the next letter. If we exit the loop normally, that means we didn’t find an *e*, so we return `true`.

You could write this function more concisely using the `∉` (**`\notin TAB`**) operator, but I started with this version because it demonstrates the logic of the search pattern.

`avoids` is a more general version of `hasno_e`, but it has the same structure:
"""

# ╔═╡ abc8dbc3-64ad-4cb5-93bb-86c6549a486a
function avoids(word, forbidden)
	for letter in word
		if letter ∈ forbidden
			return false
		end
	end
	return true
end

# ╔═╡ df4bbd1d-7a0b-460a-a7ea-756d296b19d6
md"""We can return `false` as soon as we find a forbidden letter; if we get to the end of the loop, we return `true`.

`usesonly` is similar except that the sense of the condition is reversed:
"""

# ╔═╡ 63bc1159-b1e2-4bb2-be42-42ae59b0ea54
function usesonly(word, available)
	for letter in word
		if letter ∉ available
			return false
		end
	end
	return true
end

# ╔═╡ f3ba4ef5-dd5d-474a-a36f-90cda90481fe
md"""Instead of an array of forbidden letters, we have an array of available letters. If we find a letter in word that is not in available, we can return `false`.

`usesall` is similar except that we reverse the role of the word and the string of letters:
"""

# ╔═╡ a903047b-aabf-4684-bb9d-e3e65b6c6ffa
function usesall(word, required)
	for letter in required
		if letter ∉ word
			return false
		end
	end
	return true
end

# ╔═╡ 57ce0e1f-c63e-47c9-a1fb-0a81f30436ee
md"""Instead of traversing the letters in `word`, the loop traverses the required letters. If any of the required letters do not appear in `word`, we can return `false`.

If you were really thinking like a computer scientist, you would have recognized that `usesall` was an instance of a previously solved problem, and you would have written:
"""

# ╔═╡ 07cc69c9-3434-4d8e-8758-9039b735c5ae
usesall_alternative(word, required) = usesonly(required, word)

# ╔═╡ b67e845f-f309-4718-ad9b-ac4192bb4dad
md"""This is an example of a program development plan called *reduction to a previously solved problem*, which means that you recognize the problem you are working on as an instance of a solved problem and apply an existing solution.
"""

# ╔═╡ 07b18184-7a07-11eb-165a-ff024559c0a5
md"""## Looping with Indices

I wrote the functions in the previous section with for loops because I only needed the characters in the strings; I didn’t have to do anything with the indices.

For `isabecedarian` we have to compare adjacent letters, which is a little tricky with a `for` loop:
"""

# ╔═╡ eeef5017-b1a1-4b24-b175-82098b9f1398
function isabecedarian(word)
	previous = ' '
	for c in word
		if c < previous
			return false
		end
		previous = c
	end
	return true
end

# ╔═╡ 5eb39f47-cfb4-41f5-b07b-d99eac92f8a1
md"""An alternative is to use recursion:
"""

# ╔═╡ c4a5d2a3-5063-425b-96a4-6e09c8b56364
function isabecedarian_recursion(word)
	if length(word) <= 1
		return true
	end
	i = firstindex(word)
	j = nextind(word, i)
	if word[i] > word[j]
		return false
	end
	return isabecedarian(word[j:end])
end

# ╔═╡ 6824989e-a7e0-428f-9dc3-11910ad10771
md"""Another option is to use a `while` loop:
"""

# ╔═╡ 79598111-9b43-4620-bdb0-900e2a2c1348
function isabecedarian_while(word)
	i = firstindex(word)
	j = nextind(word, 1)
	while j <= sizeof(word)
		if word[j] < word[i]
			return false
		end
		i = j
		j = nextind(word, i)
	end
	return true
end

# ╔═╡ d9bf2dc1-1945-414d-960a-f969fad3c596
md"""The loop starts at `i=1` and `j=nextind(word, 1)` and ends when `j>sizeof(word)`. Each time through the loop, it compares the ith character (which you can think of as the current character) to the `j`th character (which you can think of as the next).

If the next character is less than (alphabetically before) the current one, then we have discovered a break in the abecedarian trend, and we return `false`.

If we get to the end of the loop without finding a fault, then the word passes the test. To convince yourself that the loop ends correctly, consider an example like `"flossy"`.


Here is a version of `ispalindrome` that uses two indices; one starts at the beginning and goes up, and the other starts at the end and goes down:
"""

# ╔═╡ bef62fb0-0920-4050-a8ce-5d43a968d949
function ispalindrome(word)
	i = firstindex(word)
	j = lastindex(word)
	while i < j
		if word[i] != word[j]
			return false
		end
		i = nextind(word, i)
		j = prevind(word, j)
	end
	return true
end

# ╔═╡ 174fca69-6bb3-48c3-9611-6dd62de4ef7e
md"""Or we could reduce to a previously solved problem and write function
"""

# ╔═╡ b3b08d2d-95f6-498f-94e8-f35e1b6d70f9
ispalindrome_alternative(word) = isreverse(word, word)

# ╔═╡ 5d69a82e-1625-4c29-95dc-9f25aa3131c8
md"""using `isreverse` from “Debugging”.
"""

# ╔═╡ d373aa0e-7a07-11eb-14d0-c7e1a531b225
md"""## Debugging

Testing programs is hard. The functions in this chapter are relatively easy to test because you can check the results by hand. Even so, it is somewhere between difficult and impossible to choose a set of words that tests for all possible errors.

Taking `hasno_e` as an example, there are two obvious cases to check: words that have an *e* should return `false`, and words that don’t should return `true`. You should have no trouble coming up with one of each.

Within each case, there are some less obvious subcases. Among the words that have an *e*, you should test words with an *e* at the beginning, the end, and somewhere in the middle. You should test long words, short words, and very short words, like the empty string. The empty string is an example of a *special case*, which is one of the nonobvious cases where errors often lurk.

In addition to the test cases you generate, you can also test your program with a word list like *words.txt*. By scanning the output, you might be able to catch errors, but be careful: you might catch one kind of error (words that should not be included, but are) and not another (words that should be included, but aren’t).

In general, testing can help you find bugs, but it is not easy to generate a good set of test cases, and even if you do, you can’t be sure your program is correct. According to a legendary computer scientist:

> Program testing can be used to show the presence of bugs, but never to show their absence!
> —Edsger W. Dijkstra
"""

# ╔═╡ 71ae6498-7a08-11eb-025e-03eb7a5c2d8b
md"""## Glossary

*file stream*:
A value that represents an open file.

*reduction to a previously solved problem*:
A way of solving a problem by expressing it as an instance of a previously solved problem.

*special case*:
A test case that is atypical or nonobvious (and less likely to be handled correctly).
"""

# ╔═╡ 9e542172-7a08-11eb-2d03-75c8a0ff571a
md"""## Exercise

### Exercise 9-7

This question is based on a Puzzler that was broadcast on the radio program [Car Talk](https://www.cartalk.com/):

> Give me a word with three consecutive double letters. I’ll give you a couple of words that almost qualify, but don’t. For example, the word committee, c-o-m-m-i-t-t-e-e. It would be great except for the i that sneaks in there. Or Mississippi—M-i-s-s-i-s-s-i-p-p-i. If you could take out those i’s it would work. But there is a word that has three consecutive pairs of letters and to the best of my knowledge this may be the only word. Of course there are probably 500 more but I can only think of one. What is the word?

Write a program to find it.
"""

# ╔═╡ 3121945a-7a09-11eb-3274-553912ceed46
md"""### Exercise 9-8

Here’s another Car Talk Puzzler:

> I was driving on the highway the other day recently and I happened to notice my odometer. Like most odometers nowadays, it shows six digits, in whole miles only—no tenths of a mile. So, if my car had 300,000 miles, for example, I’d see 3-0-0-0-0-0. ...
>
> Now, what I saw that day was very interesting. I noticed that the last 4 digits were palindromic, that is they read the same forwards as backwards. For example, “5-4-4-5” is a palindrome. So my odometer could have read 3-1-5-4-4-5 ... .
>
> One mile later, the last 5 numbers were palindromic. For example, it could have read 3-6-5-4-5-6.
>
> One mile after that, the middle 4 out of 6 numbers were palindromic. ... And you ready for this? One mile later, all 6 were palindromic! ...
>
> The question is, what did [I] see on the odometer when [I] first looked?

Write a Julia program that tests all the six-digit numbers and prints any numbers that satisfy these requirements.
"""

# ╔═╡ 6560b396-7a09-11eb-3a40-cf56131c10f6
md"""### Exercise 9-9

Here’s a third Car Talk Puzzler that you can solve with a search:

> Recently I had a visit with my mom and we realized that the two digits that make up my age when reversed result in her age. For example, if she’s 73, I’m 37. We wondered how often this has happened over the years but we got sidetracked with other topics and we never came up with an answer.
>
> When I got home I figured out that the digits of our ages have been reversible six times so far. I also figured out that if we’re lucky it would happen again in a few years, and if we’re really lucky it would happen one more time after that. In other words, it would have happened 8 times over all. So the question is, how old am I now?

Write a Julia program that searches for solutions to this Puzzler.

!!! tip
    You might find the function `lpad` useful.
"""

# ╔═╡ Cell order:
# ╟─c4a4bfe6-79fc-11eb-389d-fb0dda01299f
# ╟─6e3f9f5e-79fc-11eb-22ec-47b9055afb05
# ╟─dc744022-7a03-11eb-015f-47cde5608878
# ╠═15878448-b69e-447f-82c7-3bbc8016da14
# ╟─cc8702f4-c0c6-4465-b334-edbc360befc3
# ╠═c7689458-dd39-48fd-9f9a-b0532158b7c5
# ╟─0e3263b0-ffc3-45eb-baec-7ec45038d4e5
# ╠═7d164697-51a3-4f7a-92b0-99e2fccd2cda
# ╟─d845252c-33b6-42e4-96e4-203f311cda9c
# ╠═4e2a5519-3ff1-4b05-9314-1849d10e2af8
# ╟─28712e7c-37cd-4bec-9129-cfe671bd8fde
# ╟─1b1cb464-7a05-11eb-1069-a5d56ef55821
# ╟─3ec4f68e-7a06-11eb-0942-0399471b3818
# ╠═5e3fd695-fef3-4fa6-86f1-3907cadd32e2
# ╟─193292bb-1e81-4158-967c-c8f2c87c5e35
# ╠═abc8dbc3-64ad-4cb5-93bb-86c6549a486a
# ╟─df4bbd1d-7a0b-460a-a7ea-756d296b19d6
# ╠═63bc1159-b1e2-4bb2-be42-42ae59b0ea54
# ╟─f3ba4ef5-dd5d-474a-a36f-90cda90481fe
# ╠═a903047b-aabf-4684-bb9d-e3e65b6c6ffa
# ╟─57ce0e1f-c63e-47c9-a1fb-0a81f30436ee
# ╠═07cc69c9-3434-4d8e-8758-9039b735c5ae
# ╟─b67e845f-f309-4718-ad9b-ac4192bb4dad
# ╟─07b18184-7a07-11eb-165a-ff024559c0a5
# ╠═eeef5017-b1a1-4b24-b175-82098b9f1398
# ╟─5eb39f47-cfb4-41f5-b07b-d99eac92f8a1
# ╠═c4a5d2a3-5063-425b-96a4-6e09c8b56364
# ╟─6824989e-a7e0-428f-9dc3-11910ad10771
# ╠═79598111-9b43-4620-bdb0-900e2a2c1348
# ╟─d9bf2dc1-1945-414d-960a-f969fad3c596
# ╠═bef62fb0-0920-4050-a8ce-5d43a968d949
# ╟─174fca69-6bb3-48c3-9611-6dd62de4ef7e
# ╠═b3b08d2d-95f6-498f-94e8-f35e1b6d70f9
# ╟─5d69a82e-1625-4c29-95dc-9f25aa3131c8
# ╟─d373aa0e-7a07-11eb-14d0-c7e1a531b225
# ╟─71ae6498-7a08-11eb-025e-03eb7a5c2d8b
# ╟─9e542172-7a08-11eb-2d03-75c8a0ff571a
# ╟─3121945a-7a09-11eb-3274-553912ceed46
# ╟─6560b396-7a09-11eb-3a40-cf56131c10f6
