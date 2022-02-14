### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ e89c8374-8a79-11eb-3029-7d8170bde727
begin
	import Pkg
    Pkg.activate()

    using PlutoUI
	using NativeSVG
	using GDBM
end

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

```julia
julia> fout = open("output.txt", "w")
IOStream(<file output.txt>)
```

If the file already exists, opening it in write mode clears out the old data and starts fresh, so be careful! If the file doesn’t exist, a new one is created. open returns a file object and the write function puts data into the file:

```julia
julia> line1 = "This here's the wattle,\n"; 

julia> write(fout, line1)
24
```

The return value is the number of characters that were written. The file object keeps track of where it is, so if you call write again, it adds the new data to the end of the file:

```julia
julia> line2 = "the emblem of our land.\n"; 

julia> write(fout, line2)
24
```

When you are done writing, you should close the file:

```julia
julia> close(fout)
```
If you don’t close the file, it gets closed for you when the program ends.
"""

# ╔═╡ 6b77c68c-8a7a-11eb-2ba0-87a6effbfd81
md"""## Formatting

The argument of `write` has to be a string, so if we want to put other values in a file, we have to convert them to strings. The easiest way to do that is with `string` or string interpolation:

```julia
julia> fout = open("output.txt", "w") 
IOStream(<file output.txt>)
julia> write(fout, string(150))
3
```

An alternative is to use the print or print(ln) functions:

```julia
julia> camels = 42
42
julia> println(fout, "I have spotted $camels camels.")
```

!!! tip
    A more powerful alternative is the `@printf` macro of the `Printf` package, which prints using a C-style format specification string.
"""

# ╔═╡ e880ce50-8a7a-11eb-3d3c-31a12cd844d3
md"""## Filenames and Paths

Files are organized into *directories* (also called “folders”). Every running program has a “current directory,” which is the default directory for most operations. For example, when you open a file for reading, Julia looks for it in the current directory.

The function `pwd` returns the name of the current directory: 

```julia
julia> cwd = pwd()
"/home/ben"
```

`cwd` stands for “current working directory.” The result in this example is */home/ben*, which is the home directory of a user named *ben*.

A string like `"/home/ben"` that identifies a file or directory is called a *path*.

A simple filename like *memo.txt* is also considered a path, but it is a *relative path* because it relates to the current directory. If the current directory is */home/ben*, the filename memo.txt would refer to */home/ben/memo.txt*.

A path that begins with */* does not depend on the current directory; it is called an *absolute path*. To find the absolute path to a file, you can use `abspath`:

```julia
julia> abspath("memo.txt") 
"/home/ben/memo.txt"
```

Julia provides other functions for working with filenames and paths. For example, `ispath` checks whether a file or directory exists:

```julia
julia> ispath("memo.txt") 
true
```

If it exists, `isdir` checks whether it’s a directory:

```julia
julia> isdir("memo.txt") 
false
julia> isdir("/home/ben") 
true
```

Similarly, `isfile` checks whether it’s a file.

`readdir` returns an array of the files (and other directories) in the given directory:

```julia
julia> readdir(cwd) 
3-element Array{String,1}:
 "memo.txt"
 "music"
 "photos"
```

To demonstrate these functions, the following example “walks” through a directory, prints the names of all the files, and calls itself recursively on all the directories:

```julia
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
```

`joinpath` takes a directory and a filename and joins them into a complete path.


!!! tip
    Julia provides a function called `walkdir` that is similar to this one but more versatile. As an exercise, read the documentation and use it to print the names of the files in a given directory and its subdirectories.
"""

# ╔═╡ 9ebf14b8-8a7b-11eb-3347-dbc6f1972fb2
md"""## Catching Exceptions

A lot of things can go wrong when you try to read and write files. If you try to open a file that doesn’t exist, you get a `SystemError`:

```julia
julia> fin = open("bad_file")
ERROR: SystemError: opening file "bad_file": No such file or directory
```

The same thing happens if you don’t have permission to access a file:

```julia
julia> fout = open("/etc/passwd", "w")
ERROR: SystemError: opening file "/etc/passwd": Permission denied
```

To avoid these errors you could use functions like `ispath` and `isfile`, but it would take a lot of time and code to check all the possibilities.


It’s easier to go ahead and try, and deal with problems if they happen—which is exactly what the `try` statement does. The syntax is similar to an `if` statement:

```julia
try
	fin = open("bad_file.txt") 
catch exc
	println("Something went wrong: $exc") 
end
```

Julia starts by executing the `try` clause. If all goes well, it skips the `catch` clause and proceeds. If an exception occurs, it jumps out of the `try` clause and runs the `catch` clause.

Handling an exception with a `try` statement is called *catching* an exception. In this example, the except clause prints an error message that is not very helpful. In general, catching an exception gives you a chance to fix the problem, or try again, or at least end the program gracefully.

In code that performs state changes or uses resources like files, there is typically cleanup work (such as closing files) that needs to be done when the code is finished. Exceptions potentially complicate this task, since they can cause a block of code to exit before reaching its normal end. The `finally` keyword provides a way to run some code when a given block of code exits, regardless of how it exits:

```julia
f = open("output.txt") 
try
	line = readline(f)
	println(line) 
finally
	close(f) 
end
```

The function `close` will always be executed.
"""

# ╔═╡ 22787ce0-8a7c-11eb-2c30-17f9710f7862
md"""## Databases

A *database* is a file that is organized for storing data. Many databases are organized like dictionaries, in the sense that they map from keys to values. The biggest difference between a database and a dictionary is that the database is on disk (or other permanent storage), so it persists after the program ends.

The `GDBM` package (`pkg"add https://github.com/BenLauwens/GDBM.jl.git"`) provides an interface to the *GDBM* (GNU dbm) library of functions for creating and updating database files. As an example, I’ll create a database that contains captions for image files.

Opening a database is similar to opening other files:

```julia
julia> using GDBM

julia> db = DBM("captions", "c")
DBM(<captions>)
```

The mode `"c"` means that the database should be created if it doesn’t already exist. The result is a database object that can be used (for most operations) like a dictionary.

When you create a new item, `GDBM` updates the database file:

```julia
julia> db["cleese.png"] = "Photo of John Cleese." 
"Photo of John Cleese."
```

When you access one of the items, `GDBM` reads the file: 

```julia
julia> db["cleese.png"]
"Photo of John Cleese."
```

If you make another assignment to an existing key, `GDBM` replaces the old value:

```julia
julia> db["cleese.png"] = "Photo of John Cleese doing a silly walk." 
"Photo of John Cleese doing a silly walk."
julia> db["cleese.png"]
"Photo of John Cleese doing a silly walk."
```

Some functions that take a dictionary as an argument, like `keys` and `values`, don’t work with database objects. But iteration with a `for` loop works:

```julia
for (key, value) in db 
	println(key, ": ", value)
end
```

As with other files, you should close the database when you are done:

```julia
julia> close(db)
```
"""

# ╔═╡ a350e348-8a7c-11eb-22a5-2b82d4b9ee63
md"""## Serialization

A limitation of `GDBM` is that the keys and the values have to be strings or byte arrays. If you try to use any other type, you get an error.


The functions `serialize` and `deserialize` can help. The `serialize` function can translate almost any type of object into a byte array (an `IOBuffer`) suitable for storage in a database:

```julia
julia> using Serialization 

julia> io = IOBuffer(); 

julia> t = [1, 2, 3];

julia> serialize(io, t)
24
julia> print(take!(io))
UInt8[0x37, 0x4a, 0x4c, 0x07, 0x04, 0x00, 0x00, 0x00, 0x15, 0x00, 0x08, 0xe2, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
```

The format isn’t obvious to human readers; it is meant to be easy for Julia to interpret. `deserialize` reconstitutes the object:

```julia
julia> io = IOBuffer(); 

julia> t1 = [1, 2, 3]; 

julia> serialize(io, t1)
24
julia> s = take!(io);

julia> t2 = deserialize(IOBuffer(s)); 

julia> print(t2)
[1, 2, 3]
```

`serialize` and `deserialize` write to and read from an `IOBuffer` object that represents an in-memory I/O stream. The function `take!` fetches the contents of the `IOBuffer` as a byte array and resets the `IOBuffer` to its initial state.


Although the new object has the same value as the old one, it is not (in general) the same object:

```julia
julia> t1 == t2 
true
julia> t1 ≡ t2 
false
```

In other words, `serialization` and then `deserialization` has the same effect as copying the object.

You can use this to store nonstrings in a database.
!!! tip
    In fact, the storage of nonstrings in a database is so common that
this functionality has been encapsulated in a package called `JLD`.
"""

# ╔═╡ 72f18e34-8a7d-11eb-2c21-311d92932b2a
md"""## Command Objects

Most operating systems provide a command-line interface, also known as a shell. Shells usually provide commands to navigate the filesystem and launch applications. For example, in Unix you can change directories with cd, display the contents of a directory with ls, and launch a web browser by typing (for example) **`firefox`**.

Any program that you can launch from the shell can also be launched from Julia using a *command object*:

```julia
julia> cmd = `echo hello` 
`echo hello`
```

Backticks are used to delimit the command. The function `run` executes the command:

```julia
julia> run(cmd); 
hello
```

`hello` is the output of the `echo` command, sent to `STDOUT`. The run function itself returns a process object, and throws an `ErrorException` if the external command fails to run successfully.


If you want to read the output of the external command, `read` can be used instead:

```julia
julia> a = read(cmd, String)
"hello\n"
```

For example, most Unix systems provide a command called `md5sum` or `md5` that reads the contents of a file and computes an [MD5 checksum](https://en.wikipedia.org/wiki/MD5). This command provides an efficient way to check whether two files have the same contents. The probability that different contents will yield the same checksum is very small (i.e., unlikely to happen before the universe collapses).

You can use a command object to run `md5` from Julia and get the result:

```julia
julia> filename = "output.txt" 
"output.txt"
julia> cmd = `md5 $filename` 
`md5 output.txt`
julia> res = read(cmd, String)
"MD5 (output.txt) = d41d8cd98f00b204e9800998ecf8427e\n"
```
"""

# ╔═╡ f9d3aed4-8a7d-11eb-03cb-c11448a93747
md"""## Modules
Suppose you have a file named *wc.jl* with the following code:

```julia
function linecount(filename) 
	count = 0
	for line in eachline(filename) 
		count += 1
	end
	count
end

print(linecount("wc.jl"))
```

If you run this program, it reads itself and prints the number of lines in the file, which is 9. You can also include it in the REPL like this:

```julia
julia> include("wc.jl") 
9
```

What if you don’t want the `linecount` function to be directly available in `Main`, but you’d still like to use the function in different parts of your code? Julia introduces modules to create separate variable workspaces.

A module starts with the keyword `module` and ends with `end`. Using modules allows you to avoid naming conflicts between your own top-level definitions and those found in somebody else’s code. `import` allows you to control which names from other modules are visible, and `export` specifies which of your names are public (i.e., can be used outside the module without being prefixed with the name of the module):

```julia
module LineCount 
	export linecount
	function linecount(filename) 
		count = 0
		for line in eachline(filename) 
			count += 1
		end
		count
	end 
end
```

The `using` statement allows you to make use of a module’s public names from elsewhere, so you can use the `linecount` function that `LineCount` provides outside that module as follows:

```julia
julia> using LineCount 

julia> linecount("wc.jl")
11
```

#### Exercise 14-1

Type this example into a file named *wc.jl*, include it into the REPL, and enter **`using LineCount`**.

!!! danger
    If you import a module that has already been imported, Julia does nothing. It does not reread the file, even if it has changed.
    
    If you want to reload a module, you have to restart the REPL. If you want to avoid this, you can use the `Revise` package to keep your sessions running longer.

"""

# ╔═╡ 8c1051c6-8a7e-11eb-313e-c321a1f68d13
md"""## Debugging

When you are reading and writing files, you might run into problems with whitespace. These errors can be hard to debug because spaces, tabs, and newlines are normally invisible:

```julia
julia> s = "1 2\t 3\n 4";

julia> println(s) 
1 2 	3
 4
```

The built-in functions `repr` and `dump` can help. They take any object as an argument and return a string representation of the object:

```julia
julia> repr(s)
"\"1 2\\t 3\\n 4\"" 
julia> dump(s) 
String "1 2\t 3\n 4"
```

This can be helpful for debugging.

One other problem you might run into is that different systems use different characters to indicate the end of a line. Some systems use a newline, represented by `\n`. Others use a Return character, represented by `\r`. Some use both. If you move files between different systems, these inconsistencies can cause problems.

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
A program that allows users to type commands and then executes them by start‐ ing other programs.

*command object*:
An object that represents a shell command, allowing a Julia program to run com‐ mands and read the results.

*module*:
A separate global variable workspace used to avoid naming conflicts.
"""

# ╔═╡ 21f358fa-8a7f-11eb-0630-4f3d9dbc6869
md"""## Exercises 

#### Exercise 14-2

Write a function called `sed` that takes as arguments a pattern string, a replacement string, and two filenames; it should read the first file and write the contents into the second file (creating it if necessary). If the pattern string appears anywhere in the file, it should be replaced with the replacement string.


If an error occurs while opening, reading, writing, or closing files, your program should catch the exception, print an error message, and exit.
"""

# ╔═╡ 35895b6c-8a7f-11eb-19e3-f96884b91d48
md"""#### Exercise 14-3

If you have done “Exercise 12-3”, you’ll see that a dictionary is created that maps from a sorted string of letters to the array of words that can be spelled with those letters. For example, `"opst"` maps to the array `["opts", "post", "pots", "spot", "stop", "tops"]`.

Write a module that imports `anagramsets` and provides two new functions: `storeanagrams` should store the anagram dictionary using `JLD`, and `readanagrams` should look up a word and return an array of its anagrams.
"""

# ╔═╡ 5d0288be-8a7f-11eb-0519-dd123ae3db3c
md"""#### Exercise 14-4

In a large collection of MP3 files, there may be more than one copy of the same song, stored in different directories or with different filenames. The goal of this exercise is to search for duplicates.

1. Write a program that searches a directory and all of its subdirectories, recur‐ sively, and returns an array of complete paths for all files with a given suffix (like *.mp3*).
2. To recognize duplicates, you can use `md5sum` or `md5` to compute a “checksum” for each file. If two files have the same checksum, they probably have the same contents.
3. To double-check, you can use the Unix command `diff`.
"""

# ╔═╡ Cell order:
# ╟─e89c8374-8a79-11eb-3029-7d8170bde727
# ╟─fa2d4204-8a79-11eb-0a0a-69a684f6c422
# ╟─087bcda8-8a7a-11eb-0bdf-758ab26f7fae
# ╟─23dd5184-8a7a-11eb-1dd0-35b05d248988
# ╟─6b77c68c-8a7a-11eb-2ba0-87a6effbfd81
# ╟─e880ce50-8a7a-11eb-3d3c-31a12cd844d3
# ╟─9ebf14b8-8a7b-11eb-3347-dbc6f1972fb2
# ╟─22787ce0-8a7c-11eb-2c30-17f9710f7862
# ╟─a350e348-8a7c-11eb-22a5-2b82d4b9ee63
# ╟─72f18e34-8a7d-11eb-2c21-311d92932b2a
# ╟─f9d3aed4-8a7d-11eb-03cb-c11448a93747
# ╟─8c1051c6-8a7e-11eb-313e-c321a1f68d13
# ╟─e93ab6a2-8a7e-11eb-1631-53da88e645bc
# ╟─21f358fa-8a7f-11eb-0630-4f3d9dbc6869
# ╟─35895b6c-8a7f-11eb-19e3-f96884b91d48
# ╟─5d0288be-8a7f-11eb-0519-dd123ae3db3c
