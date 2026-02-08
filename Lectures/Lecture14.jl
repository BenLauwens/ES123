### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ e89c8374-8a79-11eb-3029-7d8170bde727
begin
	this_file = split(basename(@__FILE__), '#')[1]
    import Pkg
    Pkg.activate(io = IOBuffer())
	deps = [pair.second for pair in Pkg.dependencies()]
	direct_deps = filter(p -> p.is_direct_dep, deps)
    pkgs = [x.name for x in direct_deps]
	if "NativeSVG" ∉ pkgs
		Pkg.add(url="https://github.com/BenLauwens/NativeSVG.jl.git")
	end
	using NativeSVG
	if "GDBM" ∉ pkgs
		Pkg.add(url="https://github.com/BenLauwens/GDBM.jl.git")
	end
end

# ╔═╡ 2d5e14a4-a305-4fb1-8272-4eedce375669
using GDBM

# ╔═╡ ed4fb46b-7bea-4e18-a06d-8f4564860adf
using Serialization

# ╔═╡ fa2d4204-8a79-11eb-0a0a-69a684f6c422
md"""# Files

This chapter introduces the idea of persistent programs that keep data in permanent storage, and shows how to use different kinds of permanent storage, like files and databases.
"""

# ╔═╡ 087bcda8-8a7a-11eb-0bdf-758ab26f7fae
md"""## Persistence

Most of the programs we have seen so far are transient, in the sense that they run for a short time and produce some output, but when they end, their data disappears. If you run the program again, it starts with a clean slate.

Other programs are *persistent*: they run for a long time (or all the time); they keep at least some of their data in permanent storage (a hard drive, for example); and if they shut down and restart, they pick up where they left off.

Examples of persistent programs are operating systems, which run pretty much whenever a computer is on, and web servers, which run all the time, waiting for requests to come in on the network.

One of the simplest ways for programs to maintain their data is by reading and writing text files. We have already seen programs that read text files; in this chapter we will see programs that write them.

An alternative is to store the state of the program in a database. In this chapter I will also present how to use a simple database.
"""

# ╔═╡ 23dd5184-8a7a-11eb-1dd0-35b05d248988
md"""## Reading and Writing

A *text file* is a sequence of characters stored on a permanent medium like a hard drive or flash memory. We saw how to open and read a file in “Reading Word Lists”.

To write a file, you have to open it with mode `"w"` as a second parameter:
"""

# ╔═╡ 30e9726e-12bc-443e-b036-0151e6043177
filename, fout = let
	dir = tempdir()
	filename = joinpath(dir, "output.txt")
	filename, open(filename, "w")
end

# ╔═╡ 6f7479b5-8b08-486e-acd1-fe7dc1f0b005
md"""If the file already exists, opening it in write mode clears out the old data and starts fresh, so be careful! If the file doesn’t exist a new one is created. In this case the file **`output.txt`** is created in a temporary directory. The function `joinpath` takes a directory and a filename and joins them into a complete path. `open` returns a file object and the `write` function puts data into the file:
"""

# ╔═╡ ce9cb280-fe46-4cdd-8125-b79ba5e6dc1c
let
	line1 = "This here's the wattle,\n"
	write(fout, line1)
end

# ╔═╡ 6c7f8119-e014-4a48-9c7a-35eccaae8371
md"""The return value is the number of characters that were written. The file object keeps track of where it is, so if you call write again, it adds the new data to the end of the file:
"""

# ╔═╡ e7609d73-d555-40bd-ab41-14f5eba30cd7
let
	line2 = "the emblem of our land.\n"
	write(fout, line2)
end

# ╔═╡ ff512694-0a27-466c-b4b3-dec2ca975abb
md"""When you are done writing, you should close the file:
"""

# ╔═╡ d13da4e1-1a7b-4f74-86c3-dbf3646f5e88
close(fout)

# ╔═╡ 2dcdda80-e545-4736-8cdf-807dca7ad5f3
md"""If you don’t close the file, it gets closed for you when the program ends.
"""

# ╔═╡ 6b77c68c-8a7a-11eb-2ba0-87a6effbfd81
md"""## Formatting

The argument of `write` has to be a string, so if we want to put other values in a file, we have to convert them to strings. The easiest way to do that is with `string` or string interpolation:
"""

# ╔═╡ f819ca9f-e424-4b36-b103-fb9403e2fb94
begin
	fout2 = open(filename, "a")
	write(fout2, string(150), '\n')
end

# ╔═╡ 40f80428-1211-495e-8859-40e64318a068
md"""An alternative is to use the `print` or `println` functions:
"""

# ╔═╡ e31c59bd-a58d-4575-bb51-f853d0edb9cc
let
	camels = 42
	println(fout2, "I have spotted $camels camels.")
	close(fout2)
end

# ╔═╡ b95c8cda-2b27-49cc-be51-98aca0c24b9c
md"""!!! tip
    A more powerful alternative is the `@printf` macro of the `Printf` package, which prints using a C-style format specification string.
"""

# ╔═╡ e880ce50-8a7a-11eb-3d3c-31a12cd844d3
md"""## Filenames and Paths

Files are organized into *directories* (also called “folders”). Every running program has a “current directory,” which is the default directory for most operations. For example, when you open a file for reading, Julia looks for it in the current directory.

The function `pwd` returns the name of the current directory:
"""

# ╔═╡ 28415fde-b4fd-4deb-81f6-e65d2fc4a544
cwd = pwd()

# ╔═╡ 0c5d51e8-1086-4207-be42-2dc06c3dd0de
Markdown.parse("""`cwd` stands for “current working directory.” The results is *$cwd*. A string like `"$cwd"` that identifies a file or directory is called a *path*.

A simple filename like *$this_file* is also considered a path, but it is a *relative path* because it relates to the current directory. If the current directory is *$cwd*, the filename *$this_file* would refer to *$cwd/$this_file*.

A path that begins with */* does not depend on the current directory; it is called an *absolute path*. To find the absolute path to a file, you can use `abspath`:
""")

# ╔═╡ 0edcafc4-bbeb-47be-bd68-fe27835c1103
let
	filename = split(basename(@__FILE__), '#')[1]
	println(filename)
	abspath(filename)
end

# ╔═╡ c30385f8-239b-4d58-8e80-3111b0eedca3
md"""The macro `@__FILE__` returns the absolute path of the current file. The function `basename` extracts the filename. In the notebook interface an identifier starting with `#` is added, which we can eliminate by splitting and taking the first part.

Julia provides other functions for working with filenames and paths. For example, `ispath` checks whether a file or directory exists:
"""

# ╔═╡ 6dddaad9-a5a3-456d-a7b0-699e633cb121
ispath(filename)

# ╔═╡ eeecb94e-01b7-42a4-89ca-cd8127073dd7
md"""If it exists, `isdir` checks whether it’s a directory:
"""

# ╔═╡ 83e46386-a9e2-479e-863c-5a1652145678
begin
	dir = @__DIR__
	println(dir)
	ispath(dir)
end

# ╔═╡ c541beed-5d2d-4b30-ae91-ea00ab59ef47
md"""The macro `@__DIR__` returns the directory of the current file. Similarly, `isfile` checks whether it’s a file.

`readdir` returns an array of the files (and other directories) in the given directory:
"""

# ╔═╡ 3d222470-485a-4c12-8c6e-8c39ddeb1da7
readdir(dir)

# ╔═╡ 7866e766-4e1b-4775-9fc0-e5cb56062e3f
md"""To demonstrate these functions, the following example “walks” through a directory, prints the names of all the files, and calls itself recursively on all the directories:
"""

# ╔═╡ fb0b0400-0bac-4cfc-956a-dd45482b76b1
function walk(dirname)
	for name in readdir(dirname)
		path = joinpath(dirname, name)
		if isfile(path)
			println(path)
		else
			walk(path)
		end
	end
end

# ╔═╡ b385c703-2d03-41ed-b077-b0f89f8bf86b
md"""!!! tip
    Julia provides a function called `walkdir` that is similar to this one but more versatile. As an exercise, read the documentation and use it to print the names of the files in a given directory and its subdirectories.
"""

# ╔═╡ 9ebf14b8-8a7b-11eb-3347-dbc6f1972fb2
md"""## Catching Exceptions

A lot of things can go wrong when you try to read and write files. If you try to open a file that doesn’t exist, you get a `SystemError`:
"""

# ╔═╡ 62ecd089-17cd-43f4-9f18-9d4ecb3055d1
open("bad_file")

# ╔═╡ d9354b74-76c6-43ac-9bf1-cf5da48c3f2c
md"""The same thing happens if you don’t have permission to access a file:
"""

# ╔═╡ 2c46c9f3-1bf6-4ff5-b5a7-6b50bfa46082
open("/etc/passwd", "w")

# ╔═╡ 4ad55cd4-1d46-49e0-a205-e53368d79791
md"""To avoid these errors you could use functions like `ispath` and `isfile`, but it would take a lot of time and code to check all the possibilities.

It’s easier to go ahead and try, and deal with problems if they happen—which is exactly what the `try` statement does. The syntax is similar to an `if` statement:
"""

# ╔═╡ 9b9fba28-69f4-49c3-bf8b-040683b88872
try
	fin = open("bad_file.txt")
catch exc
	println("Something went wrong: $exc")
end

# ╔═╡ 53966b4e-accd-4f76-9edd-70a1570f6c5f
md"""Julia starts by executing the `try` clause. If all goes well, it skips the `catch` clause and proceeds. If an exception occurs, it jumps out of the `try` clause and runs the `catch` clause.

Handling an exception with a `try` statement is called *catching* an exception. In this example, the except clause prints an error message that is not very helpful. In general, catching an exception gives you a chance to fix the problem, or try again, or at least end the program gracefully.

In code that performs state changes or uses resources like files, there is typically cleanup work (such as closing files) that needs to be done when the code is finished. Exceptions potentially complicate this task, since they can cause a block of code to exit before reaching its normal end. The `finally` keyword provides a way to run some code when a given block of code exits, regardless of how it exits:
"""

# ╔═╡ 27691b1b-ae01-48e6-bfb9-75a3722b5d89
let
	fin = open(filename)
	try
		line = readline(fin)
		println(line)
	finally
		close(fin)
	end
end

# ╔═╡ 47b10118-0606-43c8-bc9c-209b2840f65f
md"""The function `close` will always be executed.
"""

# ╔═╡ 22787ce0-8a7c-11eb-2c30-17f9710f7862
md"""## Databases

A *database* is a file that is organized for storing data. Many databases are organized like dictionaries, in the sense that they map from keys to values. The biggest difference between a database and a dictionary is that the database is on disk (or other permanent storage), so it persists after the program ends.

The `GDBM` package (`pkg"add https://github.com/BenLauwens/GDBM.jl.git"`) provides an interface to the *GDBM* (GNU dbm) library of functions for creating and updating database files. As an example, I’ll create a database that contains captions for image files.

Opening a database is similar to opening other files:
```
"""

# ╔═╡ 88d830ee-74ea-4bc4-8e9e-03d601629e17
begin
	db = DBM(joinpath(tempdir(), "captions"), "c")
end

# ╔═╡ 40f96b32-2801-40d5-80a9-6db31c894de0
md"""The mode `"c"` means that the database should be created if it doesn’t already exist. The result is a database object that can be used (for most operations) like a dictionary.

When you create a new item, `GDBM` updates the database file:
"""

# ╔═╡ d70344f8-f080-45ac-b74a-301098c4894d
db["cleese.png"] = "Photo of John Cleese doing a silly walk."

# ╔═╡ 69bb2449-eb6a-4312-a009-65e15e273932
db["cleese.png"]

# ╔═╡ fe90d618-7acf-408c-8b39-eb0ece871567
md"""Some functions that take a dictionary as an argument, like `keys` and `values`, don’t work with database objects. But iteration with a `for` loop works:
"""

# ╔═╡ aac96787-8ac2-4bee-83b0-224fa804e50a
for (key, value) in db
	println(key, ": ", value)
end

# ╔═╡ 5886ed3c-3968-4656-9174-7e4c71d6b69c
md"""As with other files, you should close the database when you are done:
"""

# ╔═╡ 4a644270-1003-4d1a-a973-5255d37187ea
close(db)

# ╔═╡ a350e348-8a7c-11eb-22a5-2b82d4b9ee63
md"""## Serialization

A limitation of `GDBM` is that the keys and the values have to be strings or byte arrays. If you try to use any other type, you get an error.

The functions `serialize` and `deserialize` can help. The `serialize` function can translate almost any type of object into a byte array (an `IOBuffer`) suitable for storage in a database:
"""

# ╔═╡ feb50727-6bdc-4257-8fef-109a2d9c9877
begin
	io = IOBuffer()
	t1 = [1, 2, 3]
	serialize(io, t1)
	s = take!(io)
end

# ╔═╡ 206200cf-91c7-4072-ac0c-1eff80409780
md"""The format isn’t obvious to human readers; it is meant to be easy for Julia to interpret. `deserialize` reconstitutes the object:
"""

# ╔═╡ 384f47f9-8be5-4fb1-9908-ed03b10350dd
t2 = deserialize(IOBuffer(s))

# ╔═╡ 5d0dab13-39c8-42d5-be16-d64becd62354
md"""`serialize` and `deserialize` write to and read from an `IOBuffer` object that represents an in-memory I/O stream. The function `take!` fetches the contents of the `IOBuffer` as a byte array and resets the `IOBuffer` to its initial state.


Although the new object has the same value as the old one, it is not (in general) the same object:
"""

# ╔═╡ a8527f03-5baf-4245-b554-74682cd86383
t1 == t2

# ╔═╡ fcd31936-b255-4423-a716-e294e3792fcb
t1 ≡ t2

# ╔═╡ 555749ae-0870-46c9-86e0-e658eba64154
md"""In other words, `serialization` and then `deserialization` has the same effect as copying the object.

You can use this to store nonstrings in a database.

!!! tip
    In fact, the storage of nonstrings in a database is so common that this functionality has been encapsulated in a package called `JLD`.
"""

# ╔═╡ 72f18e34-8a7d-11eb-2c21-311d92932b2a
md"""## Command Objects

Most operating systems provide a command-line interface, also known as a shell. Shells usually provide commands to navigate the filesystem and launch applications. For example, in Unix you can change directories with cd, display the contents of a directory with ls, and launch a web browser by typing (for example) **`firefox`**.

Any program that you can launch from the shell can also be launched from Julia using a *command object*:
"""

# ╔═╡ 5e0a99e9-ade9-4daa-9c8c-b93ec9837ae4
cmd = `echo hello`

# ╔═╡ 524ff43a-5121-41e2-8941-8a186e569dd8
md"""Backticks are used to delimit the command. The function `run` executes the command:
"""

# ╔═╡ 6755eae8-e4c2-4725-98b4-9afc0dbecf76
run(cmd)

# ╔═╡ c7abb09f-d595-4c6e-9e39-816eca0fab81
md"""`hello` is the output of the `echo` command, sent to `STDOUT`. The run function itself returns a process object, and throws an `ErrorException` if the external command fails to run successfully.

If you want to read the output of the external command, `read` can be used instead:
"""

# ╔═╡ e72ab4d0-ce31-4eb7-87e7-0ec6e0e5bc38
read(cmd, String)

# ╔═╡ f9d3aed4-8a7d-11eb-03cb-c11448a93747
md"""## Modules
We create a file named *wc.jl* with the following code:
"""

# ╔═╡ fa146477-a0b7-49b1-aba7-7d609056e6c6
wc_filename = let
	filename = joinpath(tempdir(), "wc.jl")
	fout = open(filename, "w")
	println(fout, """
function linecount(filename)
	count = 0
	for line in eachline(filename)
		count += 1
	end
	return count
end

print(linecount(@__FILE__))
	""")
	close(fout)
	filename
end

# ╔═╡ 816f10cc-8de4-465f-935b-a8c38565769c
include(wc_filename)

# ╔═╡ da5d487f-794c-4737-8310-8fd9cb8ca3c3
md"""If you run this program, it reads itself and prints the number of lines in the file, which is 10. You can also include it like this:
"""

# ╔═╡ ef8344af-f0e0-4d8c-bbea-8c6b83af4288
md"""What if you don’t want the `linecount` function to be directly available in `Main`, but you’d still like to use the function in different parts of your code? Julia introduces modules to create separate variable workspaces.

A module starts with the keyword `module` and ends with `end`. Using modules allows you to avoid naming conflicts between your own top-level definitions and those found in somebody else’s code. `import` allows you to control which names from other modules are visible, and `export` specifies which of your names are public (i.e., can be used outside the module without being prefixed with the name of the module):
"""

# ╔═╡ 7f60ce0d-5d73-45ab-b098-1e319ad7f577
wc_module = let
	filename = joinpath(tempdir(), "wc_module.jl")
	fout = open(filename, "w")
	println(fout, """
module LineCount
	export linecount
	function linecount(filename)
		count = 0
		for line in eachline(filename)
			count += 1
		end
		return count
	end
end
	""")
	close(fout)
	filename
end

# ╔═╡ 398e79ca-58c8-4e83-9174-a41c3e4c9249
let
	include(wc_module)
	using .LineCount
	linecount(wc_module)
end

# ╔═╡ aaf00fc8-fd25-4e43-8ca5-d3e9cbdcc977
md"""The `using` statement allows you to make use of a module’s public names from elsewhere, so you can use the `linecount` function that `LineCount` provides outside that module as follows:
"""

# ╔═╡ 5309866a-c6e8-41ac-9632-3cc51a9d7e85
md"""The `.` before `LineCount` specifies that the module is locally defined.

!!! danger
    If you import a module in the REPL that has already been imported, Julia does nothing. It does not reread the file, even if it has changed.

    If you want to reload a module, you have to restart the REPL. If you want to avoid this, you can use the `Revise` package to keep your sessions running longer.

    The notebook interface does this transparantly. 
    
    In the previous example however,  `LineCount.linecount` conflicts with the `linecount` function defined in **`wc.jl`**. A function call can be prefixed with the modulename to explicitely points to a specific function definition:  
"""

# ╔═╡ 2e74f1ed-7e13-4705-a300-fd4fc60e92cd
LineCount.linecount(wc_module)

# ╔═╡ 8c1051c6-8a7e-11eb-313e-c321a1f68d13
md"""## Debugging

When you are reading and writing files, you might run into problems with whitespace. These errors can be hard to debug because spaces, tabs, and newlines are normally invisible:
"""

# ╔═╡ 7afda572-2835-4477-a4b6-394996d2daf6
begin
	str = "1 2\t 3\n 4"
	println(str)
end

# ╔═╡ 1cbcba80-645c-444b-bd48-317144c66d49
md"""The built-in functions `repr` and `dump` can help. They take any object as an argument and return, respectively print a string representation of the object:
"""

# ╔═╡ aec30797-35a5-402b-ac17-0cefc246f40f
repr(str)

# ╔═╡ 16dbd8f8-cecd-4ad6-baba-f074f2703638
dump(str)

# ╔═╡ ab6e5d40-5616-4a05-b9fa-c97b56204703
md"""This can be helpful for debugging.

One other problem you might run into is that different systems use different characters to indicate the end of a line. Some systems use a *`NEWLINE`*, represented by `\n`. Others use a *`RETURN`* character, represented by `\r`. Some use both. If you move files between different systems, these inconsistencies can cause problems.

For most systems, there are applications to convert from one format to another. You can read more about newline characters and conversion applications or, of course, you could write one yourself.
"""

# ╔═╡ e93ab6a2-8a7e-11eb-1631-53da88e645bc
md"""## Glossary

*persistent*:
Pertaining to a program that runs indefinitely and keeps at least some of its data in permanent storage.

*text file*:
A sequence of characters stored in permanent storage, like a hard drive.

*directory*:
A named collection of files, also called a folder.

*path*:
A string that identifies a file.

*relative path*:
A path that starts from the current directory.

*absolute path*:
A path that starts from the topmost directory in the filesystem.

*catch*:
To prevent an exception from terminating a program using the `try ... catch ... finally` statements.

*database*:
A file whose contents are organized like a dictionary with keys that correspond to values.

*shell*:
A program that allows users to type commands and then executes them by starting other programs.

*command object*:
An object that represents a shell command, allowing a Julia program to run com‐ mands and read the results.

*module*:
A separate global variable workspace used to avoid naming conflicts.
"""

# ╔═╡ 21f358fa-8a7f-11eb-0630-4f3d9dbc6869
md"""## Exercises

### Exercise 14-1

Write a function called `sed` that takes as arguments a pattern string, a replacement string, and two filenames; it should read the first file and write the contents into the second file (creating it if necessary). If the pattern string appears anywhere in the file, it should be replaced with the replacement string.


If an error occurs while opening, reading, writing, or closing files, your program should catch the exception, print an error message, and exit.
"""

# ╔═╡ 35895b6c-8a7f-11eb-19e3-f96884b91d48
md"""### Exercise 14-2

If you have done “Exercise 12-3”, you’ll see that a dictionary is created that maps from a sorted string of letters to the array of words that can be spelled with those letters. For example, `"opst"` maps to the array `["opts", "post", "pots", "spot", "stop", "tops"]`.

Write a module that imports `anagramsets` and provides two new functions: `storeanagrams` should store the anagram dictionary using `JLD`, and `readanagrams` should look up a word and return an array of its anagrams.
"""

# ╔═╡ 5d0288be-8a7f-11eb-0519-dd123ae3db3c
md"""### Exercise 14-3

In a large collection of MP3 files, there may be more than one copy of the same song, stored in different directories or with different filenames. The goal of this exercise is to search for duplicates.

1. Write a program that searches a directory and all of its subdirectories, recursively, and returns an array of complete paths for all files with a given suffix (like *.mp3*).
2. To recognize duplicates, you can use `diff` (Unix, Linux, MacOS) or `fc` (Windows) to compare two files.
"""

# ╔═╡ Cell order:
# ╟─e89c8374-8a79-11eb-3029-7d8170bde727
# ╟─fa2d4204-8a79-11eb-0a0a-69a684f6c422
# ╟─087bcda8-8a7a-11eb-0bdf-758ab26f7fae
# ╟─23dd5184-8a7a-11eb-1dd0-35b05d248988
# ╠═30e9726e-12bc-443e-b036-0151e6043177
# ╟─6f7479b5-8b08-486e-acd1-fe7dc1f0b005
# ╠═ce9cb280-fe46-4cdd-8125-b79ba5e6dc1c
# ╟─6c7f8119-e014-4a48-9c7a-35eccaae8371
# ╠═e7609d73-d555-40bd-ab41-14f5eba30cd7
# ╟─ff512694-0a27-466c-b4b3-dec2ca975abb
# ╠═d13da4e1-1a7b-4f74-86c3-dbf3646f5e88
# ╟─2dcdda80-e545-4736-8cdf-807dca7ad5f3
# ╟─6b77c68c-8a7a-11eb-2ba0-87a6effbfd81
# ╠═f819ca9f-e424-4b36-b103-fb9403e2fb94
# ╟─40f80428-1211-495e-8859-40e64318a068
# ╠═e31c59bd-a58d-4575-bb51-f853d0edb9cc
# ╟─b95c8cda-2b27-49cc-be51-98aca0c24b9c
# ╟─e880ce50-8a7a-11eb-3d3c-31a12cd844d3
# ╠═28415fde-b4fd-4deb-81f6-e65d2fc4a544
# ╟─0c5d51e8-1086-4207-be42-2dc06c3dd0de
# ╠═0edcafc4-bbeb-47be-bd68-fe27835c1103
# ╟─c30385f8-239b-4d58-8e80-3111b0eedca3
# ╠═6dddaad9-a5a3-456d-a7b0-699e633cb121
# ╟─eeecb94e-01b7-42a4-89ca-cd8127073dd7
# ╠═83e46386-a9e2-479e-863c-5a1652145678
# ╟─c541beed-5d2d-4b30-ae91-ea00ab59ef47
# ╠═3d222470-485a-4c12-8c6e-8c39ddeb1da7
# ╟─7866e766-4e1b-4775-9fc0-e5cb56062e3f
# ╠═fb0b0400-0bac-4cfc-956a-dd45482b76b1
# ╟─b385c703-2d03-41ed-b077-b0f89f8bf86b
# ╟─9ebf14b8-8a7b-11eb-3347-dbc6f1972fb2
# ╠═62ecd089-17cd-43f4-9f18-9d4ecb3055d1
# ╟─d9354b74-76c6-43ac-9bf1-cf5da48c3f2c
# ╠═2c46c9f3-1bf6-4ff5-b5a7-6b50bfa46082
# ╟─4ad55cd4-1d46-49e0-a205-e53368d79791
# ╠═9b9fba28-69f4-49c3-bf8b-040683b88872
# ╟─53966b4e-accd-4f76-9edd-70a1570f6c5f
# ╠═27691b1b-ae01-48e6-bfb9-75a3722b5d89
# ╟─47b10118-0606-43c8-bc9c-209b2840f65f
# ╟─22787ce0-8a7c-11eb-2c30-17f9710f7862
# ╠═2d5e14a4-a305-4fb1-8272-4eedce375669
# ╠═88d830ee-74ea-4bc4-8e9e-03d601629e17
# ╟─40f96b32-2801-40d5-80a9-6db31c894de0
# ╠═d70344f8-f080-45ac-b74a-301098c4894d
# ╠═69bb2449-eb6a-4312-a009-65e15e273932
# ╟─fe90d618-7acf-408c-8b39-eb0ece871567
# ╠═aac96787-8ac2-4bee-83b0-224fa804e50a
# ╟─5886ed3c-3968-4656-9174-7e4c71d6b69c
# ╠═4a644270-1003-4d1a-a973-5255d37187ea
# ╟─a350e348-8a7c-11eb-22a5-2b82d4b9ee63
# ╠═ed4fb46b-7bea-4e18-a06d-8f4564860adf
# ╠═feb50727-6bdc-4257-8fef-109a2d9c9877
# ╟─206200cf-91c7-4072-ac0c-1eff80409780
# ╠═384f47f9-8be5-4fb1-9908-ed03b10350dd
# ╟─5d0dab13-39c8-42d5-be16-d64becd62354
# ╠═a8527f03-5baf-4245-b554-74682cd86383
# ╠═fcd31936-b255-4423-a716-e294e3792fcb
# ╟─555749ae-0870-46c9-86e0-e658eba64154
# ╟─72f18e34-8a7d-11eb-2c21-311d92932b2a
# ╠═5e0a99e9-ade9-4daa-9c8c-b93ec9837ae4
# ╟─524ff43a-5121-41e2-8941-8a186e569dd8
# ╠═6755eae8-e4c2-4725-98b4-9afc0dbecf76
# ╟─c7abb09f-d595-4c6e-9e39-816eca0fab81
# ╠═e72ab4d0-ce31-4eb7-87e7-0ec6e0e5bc38
# ╟─f9d3aed4-8a7d-11eb-03cb-c11448a93747
# ╠═fa146477-a0b7-49b1-aba7-7d609056e6c6
# ╟─da5d487f-794c-4737-8310-8fd9cb8ca3c3
# ╠═816f10cc-8de4-465f-935b-a8c38565769c
# ╟─ef8344af-f0e0-4d8c-bbea-8c6b83af4288
# ╠═7f60ce0d-5d73-45ab-b098-1e319ad7f577
# ╟─aaf00fc8-fd25-4e43-8ca5-d3e9cbdcc977
# ╠═398e79ca-58c8-4e83-9174-a41c3e4c9249
# ╟─5309866a-c6e8-41ac-9632-3cc51a9d7e85
# ╠═2e74f1ed-7e13-4705-a300-fd4fc60e92cd
# ╟─8c1051c6-8a7e-11eb-313e-c321a1f68d13
# ╠═7afda572-2835-4477-a4b6-394996d2daf6
# ╟─1cbcba80-645c-444b-bd48-317144c66d49
# ╠═aec30797-35a5-402b-ac17-0cefc246f40f
# ╠═16dbd8f8-cecd-4ad6-baba-f074f2703638
# ╟─ab6e5d40-5616-4a05-b9fa-c97b56204703
# ╟─e93ab6a2-8a7e-11eb-1631-53da88e645bc
# ╟─21f358fa-8a7f-11eb-0630-4f3d9dbc6869
# ╟─35895b6c-8a7f-11eb-19e3-f96884b91d48
# ╟─5d0288be-8a7f-11eb-0519-dd123ae3db3c
