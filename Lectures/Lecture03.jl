### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 83a971d0-6806-11eb-3d06-d585d1137246
using PlutoUI

# ╔═╡ 6b429bb8-6803-11eb-0653-1538c7fdbe03
md"""# Functions

In the context of programming, a *function* is a named sequence of statements that performs a computation. When you define a function, you specify the name and the sequence of statements. Later, you can “call” the function by name."""

# ╔═╡ d0c2a30c-6803-11eb-3c6d-69265f8e8e8a
md"""## Function Calls

We have already seen one example of a function call:

```julia
julia> println("Hello, World!")
Hello, World!
```

The name of the function is `println`. The expression in parentheses is called the *argument* of the function.

It is common to say that a function “takes” an argument and “returns” a result. The result is also called the *return value*.

Julia provides functions that convert values from one type to another. The `parse` function takes a string and converts it to any number type, if it can, or complains otherwise:

```julia
julia> parse(Int64, "32")
32
julia> parse(Float64, "3.14159")
3.14159
julia> parse(Int64, "Hello")
ERROR: ArgumentError: invalid base 10 digit 'H' in "Hello"
```

`trunc` can convert floating-point values to integers, but it doesn’t round off; it chops off the fraction part:

```julia
julia> trunc(Int64, 3.99999)
3
julia> trunc(Int64, -2.3) 
-2
```

`float` converts integers to floating-point numbers: 

```julia
julia> float(32)
32.0
```

Finally, `string` converts its argument to a string:

```julia
julia> string(32) 
"32"
julia> string(3.14159) 
"3.14159"
```
"""

# ╔═╡ 5c7adb76-6804-11eb-3e57-4f0e9ff68b17
md"""## Math Functions

In Julia, most of the familiar mathematical functions are directly available. The following example uses `log10` to compute a signal-to-noise ratio in decibels (assuming that `signal_power` and `noise_power` are defined). `log`, which computes natural logarithms, is also provided:

```julia
ratio = signal_power / noise_power
decibels = 10 * log10(ratio)
```

This next example finds the sine of radians. The name of the variable is a hint that `sin` and the other trigonometric functions (`cos`, `tan`, etc.) take arguments in radians:

```julia
radians = 0.7
height = sin(radians)
```

To convert from degrees to radians, divide by 180 and multiply by π:

```julia
julia> degrees = 45
45
julia> radians = degrees / 180 * π 
0.7853981633974483
julia> sin(radians) 
0.7071067811865475
```

The value of the variable `π `is a floating-point approximation of π, accurate to about 16 digits.

If you know trigonometry, you can check the previous result by comparing it to the square root of 2 divided by 2:

```julia
julia> sqrt(2) / 2 
0.7071067811865476
```
"""

# ╔═╡ 14d4c81c-6805-11eb-330e-b31bc35b924e
md"""## Composition

So far, we have looked at the elements of a program—variables, expressions, and statements—in isolation, without talking about how to combine them.

One of the most useful features of programming languages is their ability to take small building blocks and *compose* them. For example, the argument of a function can be any kind of expression, including arithmetic operators:

```julia
x = sin(degrees/360*2*π)
```

and even function calls:

```julia
x = exp(log(x+1))
```

Almost anywhere you can put a value, you can put an arbitrary expression, with one exception: the left side of an assignment statement has to be a variable name. We’ll see exceptions to this later, but as a general rule any other expression on the left side is a syntax error:

```julia
julia> minutes = hours * 60 # right
120
julia> hours * 60 = minutes # wrong!
ERROR: syntax: "60" is not a valid function argument name
```
"""

# ╔═╡ 844c788e-6805-11eb-0387-6bf667e2ba6d
md"""## Adding New Functions

So far, we have only been using the functions that come with Julia, but it is also possible to add new functions. A *function definition* specifies the name of a new function and the sequence of statements that run when the function is called. Here is an example:

```julia
function printlyrics()
	println("I'm a lumberjack, and I'm okay.") 
	println("I sleep all night and I work all day.")
end
```

`function` is a keyword that indicates that this is a function definition. The name of the function is `printlyrics`. The rules for function names are the same as for varable names: they can contain almost all Unicode characters (see “Characters”), but the first character can’t be a number. You can’t use a keyword as the name of a function, and you should avoid having a variable and a function with the same name.
The empty parentheses after the name indicate that this function doesn’t take any arguments.

The first line of the function definition is called the *header*; the rest is called the *body*. The body is terminated with the keyword `end`, and it can contain any number of statements. For readability the body of the function should be indented.

The quotation marks must be "straight quotes," usually located next to Enter on the keyboard. “Curly quotes,” like the ones in this sentence, are not legal in Julia.

If you type a function definition in interactive mode, the REPL indents to let you know that the definition isn’t complete:

```julia
julia> function printlyrics()
println("I'm a lumberjack, and I'm okay.")
```

To end the function, you have to enter `end`.

The syntax for calling the new function is the same as for built-in functions:

```julia
julia> printlyrics()
I'm a lumberjack, and I'm okay.
I sleep all night and I work all day.
```

Once you have defined a function, you can use it inside another function. For exam‐ ple, to repeat the previous refrain, we could write a function called `repeatlyrics`:

```julia
function repeatlyrics() 
	printlyrics()
	printlyrics() 
end
```

And then call `repeatlyrics`:

```julia
julia> repeatlyrics()
I'm a lumberjack, and I'm okay.
I sleep all night and I work all day. 
I'm a lumberjack, and I'm okay.
I sleep all night and I work all day.
```

But that’s not really how the song goes.
"""

# ╔═╡ 44e3b72e-6806-11eb-2a26-2d3483ccd891
function printlyrics()
    println("I'm a lumberjack, and I'm okay.") 
    println("I sleep all night and I work all day.")
end

# ╔═╡ 6fb494e6-6806-11eb-2ce2-45aebe0c7c2e
function repeatlyrics() 
    printlyrics()
    printlyrics() 
end

# ╔═╡ 7404401e-6806-11eb-1d6f-85edc42e49be
with_terminal() do
	repeatlyrics()
end

# ╔═╡ 8eb04e9c-6806-11eb-2191-6f9a8bd5d57a
md"""## Definitions and Uses

Pulling together the code fragments from the previous section, the whole program looks like this:

```julia
function printlyrics()
	println("I'm a lumberjack, and I'm okay.") 
	println("I sleep all night and I work all day.")
end

function repeatlyrics() 
	printlyrics()
	printlyrics()
end

repeatlyrics()
```

This program contains two function definitions: `printlyrics` and `repeatlyrics`. Function definitions get executed just like other statements, but the effect is to create *function objects*. The statements inside the function do not run until the function is called, and the function definition generates no output.

As you might expect, you have to create a function before you can run it. In other words, the function definition has to run before the function gets called.
"""

# ╔═╡ ff341d78-6806-11eb-1cf9-e75f47ca002e
md"""#### Exercise 3-1

Move the last line of this program to the top, so the function call appears before the definitions. Run the program and see what error message you get.

Now move the function call back to the bottom and move the definition of `printlyrics` after the definition of `repeatlyrics`. What happens when you run this program?
"""

# ╔═╡ 850fbbd0-6807-11eb-382a-5b580659afad
md"""## Flow of Execution

To ensure that a function is defined before its first use, you have to know the order statements run in, which is called the *flow of execution*.

Execution always begins at the first statement of the program. Statements are run one at a time, in order, from top to bottom.

Function definitions do not alter the flow of execution of the program, but remember that statements inside a function don’t run until the function is called.

A function call is like a detour in the flow of execution. Instead of going to the next statement, the flow jumps to the body of the function, runs the statements there, and then comes back to pick up where it left off.

That sounds simple enough, until you remember that one function can call another. While in the middle of one function, the program might have to run the statements in another function. Then, while running that new function, the program might have to run yet another function!

Fortunately, Julia is good at keeping track of where it is, so each time a function com‐ pletes, the program picks up where it left off in the function that called it. When it gets to the end of the program, it terminates.

In summary, when you read a program, you don’t always want to read from top to bottom. Sometimes it makes more sense if you follow the flow of execution.
"""

# ╔═╡ bd2a3eee-6807-11eb-00f9-2dc1666a7ed9
md"""## Parameters and Arguments

Some of the functions we have seen require arguments. For example, when you call `sin` you pass a number as an argument. Some functions take more than one argument: `parse` takes two, a number type and a string.

Inside the function, the arguments are assigned to variables called *parameters*. Here is a definition for a function that takes an argument:

```julia
function printtwice(bruce) 
	println(bruce)
	println(bruce) 
end
```

This function assigns the argument to a parameter named `bruce`. When the function is called, it prints the value of the parameter (whatever it is) twice.

This function works with any value that can be printed:

```julia
julia> printtwice("Spam") 
Spam
Spam
julia> printtwice(42)
42
42
julia> printtwice(π) 
π
π
```

The same rules of composition that apply to built-in functions also apply to programmer-defined functions, so we can use any kind of expression as an argument for `printtwice`:

```julia
julia> printtwice("Spam "^4) 
Spam Spam Spam Spam
Spam Spam Spam Spam
julia> printtwice(cos(π)) 
-1.0
-1.0
```

The argument is evaluated before the function is called, so in these examples the expressions `"Spam "^4` and `cos(π)` are only evaluated once.

You can also use a variable as an argument:

```julia
julia> michael = "Eric, the half a bee." 
"Eric, the half a bee."
julia> printtwice(michael)
Eric, the half a bee.
Eric, the half a bee.
```

The name of the variable we pass as an argument (michael) has nothing to do with the name of the parameter (`bruce`). It doesn’t matter what the value was called back home (in the caller); here in `printtwice`, we call everybody `bruce`.
"""

# ╔═╡ d92f58e6-6808-11eb-1c83-49d4a6a8b4bd
md"""## Variables and Parameters Are Local

When you create a variable inside a function, it is local, which means that it only exists inside the function. For example:

```julia
function cattwice(part1, part2) 
	concat = part1 * part2 
	printtwice(concat)
end
```

This function takes two arguments, concatenates them, and prints the result twice. Here is an example that uses it:

```julia
julia> line1 = "Bing tiddle " 
"Bing tiddle "
julia> line2 = "tiddle bang." 
"tiddle bang."
julia> cattwice(line1, line2) 
Bing tiddle tiddle bang. 
Bing tiddle tiddle bang.
```

When `cattwice` terminates, the variable `concat` is destroyed. If we try to print it, we get an exception:

```julia
julia> println(concat)
ERROR: UndefVarError: concat not defined
```

Parameters are also local. For example, outside `printtwice`, there is no such thing as `bruce`.
"""

# ╔═╡ b0a0c234-6808-11eb-062f-b5be2390f714


# ╔═╡ Cell order:
# ╟─83a971d0-6806-11eb-3d06-d585d1137246
# ╟─6b429bb8-6803-11eb-0653-1538c7fdbe03
# ╟─d0c2a30c-6803-11eb-3c6d-69265f8e8e8a
# ╟─5c7adb76-6804-11eb-3e57-4f0e9ff68b17
# ╟─14d4c81c-6805-11eb-330e-b31bc35b924e
# ╟─844c788e-6805-11eb-0387-6bf667e2ba6d
# ╠═44e3b72e-6806-11eb-2a26-2d3483ccd891
# ╠═6fb494e6-6806-11eb-2ce2-45aebe0c7c2e
# ╠═7404401e-6806-11eb-1d6f-85edc42e49be
# ╟─8eb04e9c-6806-11eb-2191-6f9a8bd5d57a
# ╟─ff341d78-6806-11eb-1cf9-e75f47ca002e
# ╟─850fbbd0-6807-11eb-382a-5b580659afad
# ╟─bd2a3eee-6807-11eb-00f9-2dc1666a7ed9
# ╟─d92f58e6-6808-11eb-1c83-49d4a6a8b4bd
# ╠═b0a0c234-6808-11eb-062f-b5be2390f714
