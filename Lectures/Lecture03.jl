### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ 83a971d0-6806-11eb-3d06-d585d1137246
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

# ╔═╡ 6b429bb8-6803-11eb-0653-1538c7fdbe03
md"""# Functions

In the context of programming, a *function* is a named sequence of statements that performs a computation. When you define a function, you specify the name and the sequence of statements. Later, you can “call” the function by name."""

# ╔═╡ d0c2a30c-6803-11eb-3c6d-69265f8e8e8a
md"""## Function Calls

We have already seen one example of a function call: 
"""

# ╔═╡ 1800c6a4-ff70-4499-86e1-07d5ff495bfd
println("Hello, World!")

# ╔═╡ dc752538-43f1-44fb-b526-16475e2a03cb
md"""The name of the function is `println`. The expression in parentheses is called the *argument* of the function.

It is common to say that a function “takes” an argument and “returns” a result. The result is also called the *return value*.

Julia provides functions that convert values from one type to another. The `parse` function takes a string and converts it to any number type, if it can, or complains otherwise:
"""

# ╔═╡ 43bac4c4-653d-4fdc-ad79-8ee2c2584c95
parse(Int64, "32")

# ╔═╡ 18a74656-33a9-41d7-b0b6-ab48f37b9202
parse(Float64, "3.14159")

# ╔═╡ 465f1d71-4f8d-4cce-97a9-25c697187da1
parse(Int64, "Hello")

# ╔═╡ 8cd91165-8538-4734-b7fd-eac9f04ab3e3
md"""`trunc` can convert floating-point values to integers, but it doesn’t round off; it chops off the fraction part:
"""

# ╔═╡ 27a9597d-06c4-46b2-afa3-7882b2997aaa
trunc(Int64, 3.99999)

# ╔═╡ db0cc555-31a4-4e7a-9e56-847a430c6919
trunc(Int64, -2.3) 

# ╔═╡ 12871031-7c0a-46d2-9e99-c1caf0986380
md"""`float` converts integers to floating-point numbers: 
"""

# ╔═╡ a38b1abd-74bd-40bc-8897-2455b4777db5
float(32)

# ╔═╡ 6fe51f2f-65b2-44d3-ab33-75ee093ab139
md"""Finally, `string` converts its argument to a string:
"""

# ╔═╡ 6ac117cc-c47f-46a8-8e67-99bdb794949e
string(32) 

# ╔═╡ 46f32313-f91d-4216-aca0-a9bec58561f0
string(3.14159) 

# ╔═╡ 5c7adb76-6804-11eb-3e57-4f0e9ff68b17
md"""## Math Functions

In Julia, most of the familiar mathematical functions are directly available. The following example uses `log10` to compute a signal-to-noise ratio in decibels (assuming that `signal_power` and `noise_power` are defined). `log`, which computes natural logarithms, is also provided:
"""

# ╔═╡ d6df8701-9e75-408c-a3ce-521c63c1efae
md"""This next example finds the sine of radians. The name of the variable is a hint that `sin` and the other trigonometric functions (`cos`, `tan`, etc.) take arguments in radians:
"""

# ╔═╡ 64d1a56b-5271-4f67-9c7d-ae61988b33c8
begin
	radians = π / 4
	height = sin(radians)
end

# ╔═╡ a3491cdf-7a67-45c6-9809-b7aaae3abe3f
md"""The value of the variable `π `is a floating-point approximation of π, accurate to about 16 digits.

To convert from degrees to radians, divide by 180 and multiply by π:
"""

# ╔═╡ b534c2d9-5eaf-4a4e-967a-f30ca67daffc
degrees = 45

# ╔═╡ ac35a41e-e7c2-4d7c-8263-897d46ea96f9
md"""A new compound statement is used in this example. Due to the mechanism how the reactivity of the notebook is implemented, a variable can be assigned in only one cell. Variables created in a `let` block have always a new location and are local to the block. The `radians` variable of the `let` block is a new variable and we don't have colliding definitions for the `radians` variable defined in the `begin` block. Variables defined outside the `let` block are still accessible inside.

If you know trigonometry, you can check the previous result by comparing it to the square root of 2 divided by 2:
"""

# ╔═╡ 20b00dd0-3644-4fbd-bcbd-b565523b0506
sqrt(2) / 2 

# ╔═╡ 46a2dff3-660c-4838-91d8-51f0b02060bf
md"""!!! tip
    A `let` block should be your first choice when using a compound statement. A `begin` block can be used when variables are assigned that have to be accessible from outside the block.
"""

# ╔═╡ 14d4c81c-6805-11eb-330e-b31bc35b924e
md"""## Composition

So far, we have looked at the elements of a program—variables, expressions, and statements—in isolation, without talking about how to combine them.

One of the most useful features of programming languages is their ability to take small building blocks and *compose* them. For example, the argument of a function can be any kind of expression, including arithmetic operators:
"""

# ╔═╡ 9d4c81b8-4306-4467-a4ae-b9cd6cae01db
md"""and even function calls:
"""

# ╔═╡ b5ca010d-48f3-4e55-a753-97b47dc60f39
md"""Almost anywhere you can put a value, you can put an arbitrary expression, with one exception: the left side of an assignment statement has to be a variable name. We’ll see exceptions to this later, but as a general rule any other expression on the left side is a syntax error:
"""

# ╔═╡ ed0dd3d4-3364-4e57-80dd-e0c0facc71f6
begin
	hours = 2
	minutes = hours * 60 # right
	hours * 60 = minutes # wrong!
end

# ╔═╡ 528153af-ec22-4068-b2b2-e920c059fe6c
begin
	signal_power = 0.1e-15 # 0.1 fWatt
	noise_power = 4e-15 # 4 fWatt
	ratio = signal_power / noise_power
	decibels = 10 * log10(ratio)
end

# ╔═╡ acb13fae-d14d-4c08-9916-6f3ac51cd945
let
	radians = degrees / 180 * π 
	sin(radians) 
end

# ╔═╡ d81ea2b9-5528-4e22-b747-a400cf84ddf2
x = sin(degrees / 360 * 2π)

# ╔═╡ 044ae05e-2396-459d-8740-ea928620cc97
exp(log(x+1))

# ╔═╡ 844c788e-6805-11eb-0387-6bf667e2ba6d
md"""## Adding New Functions

So far, we have only been using the functions that come with Julia, but it is also possible to add new functions. A *function definition* specifies the name of a new function and the sequence of statements that run when the function is called. Here is an example:
"""

# ╔═╡ bff25d47-cbd0-45dd-b83e-fdb21de50235
function printlyrics()
	println("I'm a lumberjack, and I'm okay.") 
	println("I sleep all night and I work all day.")
end

# ╔═╡ 7f296c1b-12c5-4916-b17e-9fb888f0c953
md"""`function` is a keyword that indicates that this is a function definition. The name of the function is `printlyrics`. The rules for function names are the same as for varable names: they can contain almost all Unicode characters (see “Characters”), but the first character can’t be a number. You can’t use a keyword as the name of a function, and you should avoid having a variable and a function with the same name.
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
"""

# ╔═╡ 0e7392d0-bcbb-4e22-9bd4-d989bafa316e
printlyrics()

# ╔═╡ ba4cd1eb-c2d4-4d98-a66f-c53d30cb66a8
md"""Once you have defined a function, you can use it inside another function. For example, to repeat the previous refrain, we could write a function called `repeatlyrics`:
"""

# ╔═╡ d8b2cf61-32f8-4191-8e4d-beb51b1ce7e4
function repeatlyrics() 
	printlyrics()
	printlyrics() 
end

# ╔═╡ 497a72bb-9c99-4deb-a714-87deaf37fd50
md"""And then call `repeatlyrics`:
"""

# ╔═╡ 549b213e-45e5-45e3-bb16-5f5c19be48f5
repeatlyrics()

# ╔═╡ c5161f26-7a40-4cb2-92dd-85ee87cbdb5c
md"""But that’s not really how the song goes.
"""

# ╔═╡ 5edc214e-68cb-11eb-23a6-2bbae196847e
md"""
!!! languages
    The function definition of `printlyrics` in Python has the same ingredients:

    ```python
    >>> def printlyrics():
    ...    print("I'm a lumberjack, and I'm okay.")
    ...    print("I sleep all night and I work all day.")
    ...    
    ```
    
    `def` instead of `function` is used to indicate that this is a function definition. The header ends with a colon and the body is indented. To end the function definition, you have to enter an empty line.

    In C the function definition of `printlyrics` is also similar:
    
    ```c
    void printlyrics() {
        printf("I'm a lumberjack, and I'm okay.\n");
        printf("I sleep all night and I work all day.\n");
    }
    ```

    The keyword `void` indicates that this function does not return a value. The body of the function is enclosed between brackets.

    MATLAB requires that the function is defined in a file having as name the function name and extension `.m`:

    ```matlab
    function printlyrics()
        disp("I'm a lumberjack, and I'm okay.")
        disp("I sleep all night and I work all day.")
    end
    ```

    The syntax is very familiar if you know Julia.
"""

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
"""

# ╔═╡ 2d882d96-f751-40d6-963c-1ad4f0b1af35
function printtwice(bruce) 
	println(bruce)
	println(bruce) 
end

# ╔═╡ 81f9ccbc-6143-47f3-abd6-645047a098da
md"""This function assigns the argument to a parameter named `bruce`. When the function is called, it prints the value of the parameter (whatever it is) twice.

This function works with any value that can be printed:
"""

# ╔═╡ 6f198f09-29ba-45fa-ae31-3020443e5a6f
printtwice("Spam") 

# ╔═╡ efd471aa-cdfa-456a-8b05-114dd6806793
printtwice(42)

# ╔═╡ 797e01dd-f6b8-4351-b18b-048e9034e45d
printtwice(π)

# ╔═╡ 68773bb1-7357-45e2-90f9-a4f1c2d97e4e
md"""The same rules of composition that apply to built-in functions also apply to programmer-defined functions, so we can use any kind of expression as an argument for `printtwice`:
"""

# ╔═╡ 818f33df-e7dd-4109-814b-963f91fe30a4
printtwice("Spam "^4) 

# ╔═╡ add7e8f0-7680-4794-9659-23fb8b54029e
printtwice(cos(π)) 

# ╔═╡ c9f63a60-6ed7-4bdd-80f2-774bce24c293
md"""The argument is evaluated before the function is called, so in these examples the expressions `"Spam "^4` and `cos(π)` are only evaluated once.

You can also use a variable as an argument:
"""

# ╔═╡ f0e5109a-600e-4935-a62a-04b8b3b0161c
michael = "Eric, the half a bee."

# ╔═╡ 2b71c511-4013-47af-ae78-aaaecaa15bc6
printtwice(michael)

# ╔═╡ 047aa249-7b80-491b-912e-a470331428a1
md"""The name of the variable we pass as an argument (michael) has nothing to do with the name of the parameter (`bruce`). It doesn’t matter what the value was called back home (in the caller); here in `printtwice`, we call everybody `bruce`.
"""

# ╔═╡ 05da4942-68ce-11eb-3634-4f77c713ba1e
md"""
!!! languages
    In Python the arguments of a function are specified after the function name:
    
    ```python
    >>> def printtwice(bruce):
    ...     print(bruce)
    ...     print(bruce)
    ...
    ```

    and this is also the case for MATLAB:

    ```matlab
    function printtwice(bruce)
        disp(bruce)
        disp(bruce)
    end
    ```
    
    The type of arguments has to be specified in C:
    
    ```c
    void printtwice(char* bruce) {
        printf("%s\n", bruce);
        printf("%s\n", bruce);
    }
    ```
    
    In this case `bruce` is of type `char*`, i.e. a pointer to the first character of the string.
"""

# ╔═╡ d92f58e6-6808-11eb-1c83-49d4a6a8b4bd
md"""## Variables and Parameters Are Local

When you create a variable inside a function, it is local, which means that it only exists inside the function. For example:
"""

# ╔═╡ 9ab6f64d-0621-4af0-9321-4f9401d190a2
function cattwice(part1, part2) 
	concat = part1 * part2 
	printtwice(concat)
end

# ╔═╡ ca8dc216-acc4-4e5b-b262-e71153b5fc9d
md"""This function takes two arguments, concatenates them, and prints the result twice. Here is an example that uses it:
"""

# ╔═╡ cc4e568a-19fe-4355-884b-20b17b0ca0ba
begin
	line1 = "Bing tiddle "
	line2 = "tiddle bang."
	cattwice(line1, line2)
end

# ╔═╡ b1aa718a-75b3-40c0-918e-f7d28c6299d5
md"""When `cattwice` terminates, the variable `concat` is destroyed. If we try to print it, we get an exception:
"""

# ╔═╡ baa2b86c-e0ad-4392-9f77-7ef4a6702eb2
println(concat)

# ╔═╡ 25468639-8a32-431b-a5c0-043f894c1a03
md"""Parameters are also local. For example, outside `printtwice`, there is no such thing as `bruce`.
"""

# ╔═╡ 23dd6e64-ee48-4604-b978-935e0b7b9a77
md"""!!! tip
    You can consider a `let` block as a function body that is executed immediately after its definition.
"""

# ╔═╡ b0a0c234-6808-11eb-062f-b5be2390f714
md"""## Stack Diagrams

To keep track of which variables can be used where, it is sometimes useful to draw a *stack diagram*. Like state diagrams, stack diagrams show the value of each variable, but they also show the function each variable belongs to.

Each function is represented by a *frame*. A frame is a box with the name of a function beside it and the parameters and variables of the function inside it. The stack diagram for the previous example is shown in Figure 3-1.
"""

# ╔═╡ 94c0413e-68d0-11eb-23c2-31909597a1f8
Drawing(width=720, height=220) do
    rect(x=210, y=10, width=400, height=60, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=45, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("Main") 
	end
	text(x=280, y=30, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("line1") 
	end
	text(x=290, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle \"") 
	end
	text(x=280, y=60, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("line2") 
	end
	text(x=290, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"tiddle bang\"") 
	end
	rect(x=210, y=80, width=400, height=90, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=130, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("cattwice") 
	end
	text(x=280, y=100, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("part1") 
	end
	text(x=290, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle \"") 
	end
	text(x=280, y=130, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("part2") 
	end
	text(x=290, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"tiddle bang\"") 
	end
	text(x=280, y=160, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("concat") 
	end
	text(x=290, y=160, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=160, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle tiddle bang\"") 
	end
	rect(x=210, y=180, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=200, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("printtwice") 
	end
	text(x=280, y=200, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("bruce") 
	end
	text(x=290, y=200, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=200, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle tiddle bang\"") 
	end
	@info "Stack diagram."
end

# ╔═╡ 73f6657c-68d1-11eb-1537-8b9791787e36
md"""The frames are arranged in a stack that indicates which function called which. In this example, `printtwice` was called by `cattwice`, and `cattwice` was called by `Main`, which is a special name for the topmost frame. When you create a variable outside of any function, it belongs to `Main`.

Each parameter refers to the same value as its corresponding argument. So, `part1` has the same value as `line1`, `part2` has the same value as `line2`, and `bruce` has the same value as `concat`.

If an error occurs during a function call, Julia prints the name of the function, the name of the function that called it, and the name of the function that called that, all the way back to `Main`.

For example, if you try to access `concat` from within `printtwice_err`, you get an `UndefVarError`:
"""

# ╔═╡ 400680b0-6162-4812-8a2d-c82e757a51a0
function printtwice_err(bruce) 
	println(bruce)
	concat
	println(bruce) 
end

# ╔═╡ 645d2eaf-17f1-4f95-8d1e-ec1d4e971727
function cattwice_err(part1, part2) 
	concat = part1 * part2 
	printtwice_err(concat)
end

# ╔═╡ d3580f24-4879-4e06-8b91-cd30e7cb60b6
cattwice_err(line1, line2)

# ╔═╡ b2f0648f-425e-4ec7-a542-62fdca047cc7
md"""This list of functions is called a *stacktrace*. It tells you what program file the error occurred in, and what line, and what functions were executing at the time. It also shows the line of code that caused the error.

The order of the functions in the stacktrace is the inverse of the order of the frames in the stack diagram. The function that is currently running is at the top.

When clicking on error locations specified in a stack trace, the corresponding code is highlighted in the notebook interface.
"""

# ╔═╡ a0971d9e-68d4-11eb-0614-0d91989881cd
md"""## Fruitful Functions and Void Functions

Some of the functions we have used, such as the math functions, return results; for lack of a better name, I call them *fruitful functions*. Other functions, like `printtwice`, perform an action but don’t return a value. They are called *void functions*.

When you call a fruitful function, you almost always want to do something with the result. For example, you might assign it to a variable or use it as part of an expression:
"""

# ╔═╡ 72f3b853-5015-49af-9ec0-39b0abd2f2de
y = cos(radians)

# ╔═╡ e68df0ff-53b3-4965-ab09-9579c385e717
golden = (sqrt(5) + 1) / 2

# ╔═╡ b049e781-b903-41b0-ad0a-971704ea5709
md"""When you call a function in interactive mode, Julia displays the result:
"""

# ╔═╡ 754f2403-ccbc-44dd-89d7-75548fbfd9ca
sqrt(5)

# ╔═╡ 7196b12d-b64d-47a7-ae71-b77bd5f8b8ad
md"""But in a script or in compound statement, if you call a fruitful function all by itself, the return value is lost forever!
"""

# ╔═╡ d4787e1f-24f9-4ba0-b309-c0ca1f16c4c0
begin
	sqrt(5)
	sqrt(9)
end

# ╔═╡ d1e3f107-bd3a-4a87-848e-1ab5b410f6af
md"""This `begin` block computes the square root of 5, but since it doesn’t store or display the result, it is not very useful. The square root of 9 however is the result of the compound statement, its last executed statement, and as such will be displayed. 

Void functions might display something on the screen or have some other effect, but they don’t have a return value. If you assign the result to a variable, you get a special value called `nothing`:
"""

# ╔═╡ ec761da6-35af-406c-9917-8e7f111a5325
result = printtwice("Bing")

# ╔═╡ 5ab48a64-8dbb-4502-bd8b-707dcd7482ce
show(result)

# ╔═╡ ae78dea0-e602-4a29-831d-577f14737af2
md"""To print the value `nothing`, you have to use the function `show`, which is like `print` but can handle this special value.

The value `nothing` is not the same as the string `"nothing"`. It is a special value that has its own type:
"""

# ╔═╡ 975a07b0-0034-4ed4-be80-12fd6a577e92
typeof(nothing) 

# ╔═╡ f89fd1a4-6867-4e2c-b6b7-ad7306e420b0
md"""The functions we have written so far are all void. We will start writing fruitful functions in a few chapters.
"""

# ╔═╡ fe683d58-68d5-11eb-22c6-8d59946b6043
md"""## Why Functions?

It may not be clear why it is worth the trouble to divide a program into functions. There are several reasons:

* Creating a new function gives you an opportunity to name a group of statements, which makes your program easier to read and debug.
* Functions can make a program smaller by eliminating repetitive code. Later, if you make a change, you only have to make it in one place.
* Dividing a long program into functions allows you to debug the parts one at a time and then assemble them into a working whole.
* Well-designed functions are often useful for many programs. Once you write and debug one, you can reuse it.
* In Julia, functions can improve performance a lot.
"""

# ╔═╡ 640b2da0-68d6-11eb-1e2d-cdf06b701b35
md"""## Debugging

One of the most important skills you will acquire is debugging. Although it can be frustrating, debugging is one of the most intellectually rich, challenging, and interesting parts of programming.

In some ways debugging is like detective work. You are confronted with clues and you have to infer the processes and events that led to the results you see.

Debugging is also like an experimental science. Once you have an idea about what is going wrong, you modify your program and try again. If your hypothesis was correct, you can predict the result of the modification, and you take a step closer to a working program. If your hypothesis was wrong, you have to come up with a new one. As Sherlock Holmes pointed out,

> When you have eliminated the impossible, whatever remains, however improbable, must be the truth.
> 
> —A. Conan Doyle, *The Sign of Four*

For some people, programming and debugging are the same thing. That is, program‐ ming is the process of gradually debugging a program until it does what you want. The idea is that you should start with a working program and make small modifications, debugging them as you go.

For example, Linux is an operating system that contains millions of lines of code, but it started out as a simple program Linus Torvalds used to explore the Intel 80386 chip. According to Larry Greenfield in *The Linux Users’ Guide* (version beta-1), “One of Linus’s earlier projects was a program that would switch between printing AAAA and BBBB. This later evolved to Linux.”
"""

# ╔═╡ d1f91354-68d6-11eb-011d-c7dbdb310949
md"""## Glossary

*function*:
A named sequence of statements that performs some useful operation. Functions may or may not take arguments and may or may not produce a result.

*function call*:
A statement that runs a function. It consists of the function name followed by an argument list in parentheses.

*argument*:
A value provided to a function when the function is called. This value is assigned to the corresponding parameter in the function.

*return value*:
The result of a function. If a function call is used as an expression, the return value is the value of the expression.

*composition*:
Using an expression as part of a larger expression, or a statement as part of a larger statement.

*`let` block*:
A compound statement always creating a new location for variables created in the block. Often used in a notebook cell to avoid definition collisions.

*function definition*:
A statement that creates a new function, specifying its name, parameters, and the statements it contains.

*header*:
The first line of a function definition.

*body*:
The sequence of statements inside a function definition.

*function object*:
A value created by a function definition. The name of the function is a variable that refers to a function object.

*flow of execution*:
The order statements run in.

*parameter*:
A name used inside a function to refer to the value passed as an argument.

*local variable*:
A variable defined inside a function. A local variable can only be used inside its function.

*stack diagram*:
A graphical representation of a stack of functions, their variables, and the values they refer to.

*frame*:
A box in a stack diagram that represents a function call. It contains the local variables and parameters of the function.

*stacktrace*:
A list of the functions that are executing, printed when an exception occurs.

*fruitful function*:
A function that returns a value.

*void function*:
A function that always returns nothing. 

*`nothing`*:
A special value returned by void functions.
"""

# ╔═╡ 924657fc-68d7-11eb-068e-1f86cd76b173
md"""## Exercises

!!! tip
    These exercises should be done using only the statements and other features introduced so far.
"""

# ╔═╡ ba4efec0-68d7-11eb-1670-f3b243ec16d4
md"""#### Exercise 3-2

Write a function named rightjustify that takes a string named s as a parameter and prints the string with enough leading spaces so that the last letter of the string is in column 70 of the display:

```julia
julia> rightjustify("monty")
                                                                       monty
```

!!! tip
    Use string concatenation and repetition. Also, Julia provides a built-in function called `length` that returns the length of a string, so the value of `length("monty")` is `5`.
"""

# ╔═╡ 21ee9e2a-68d8-11eb-2378-8f86ad348501
md"""#### Exercise 3-3

A function object is a value you can assign to a variable or pass as an argument. For example, `dotwice` is a function that takes a function object as an argument and calls it twice:

```julia
function dotwice(f) 
    f()
    f() 
end
```

Here’s an example that uses `dotwice` to call a function named `printspam` twice:

```julia
function printspam() 
    println("spam")
end

dotwice(printspam)
```

1. Type this example into a script and test it.
2. Modify `dotwice` so that it takes two arguments, a function object and a value, and calls the function twice, passing the value as an argument.
3. Copy the definition of `printtwice` from earlier in this chapter to your script.
4. Use the modified version of `dotwice` to call `printtwice` twice, passing `"spam"` as an argument.
5. Define a new function called `dofour` that takes a function object and a value and calls the function four times, passing the value as a parameter. There should be only two statements in the body of this function, not four.
"""

# ╔═╡ a6646e6e-68d8-11eb-2b06-75b6abfc177a
md"""#### Exercise 3-4

1. Write a function `printgrid` that draws a grid like the following:
   
   ```julia
   julia> printgrid()
   + - - - - + - - - - +
   |         |         |
   |         |         |
   |         |         |
   |         |         |
   + - - - - + - - - - +
   |         |         |
   |         |         |
   |         |         |
   |         |         |
   + - - - - + - - - - +
   ```
2. Write a function that draws a similar grid with four rows and four columns.

*Credit*: This exercise is based on an exercise in *Practical C Programming*, by Steve Oualline (O’Reilly).

!!! tip
    To print more than one value on a line, you can print a comma- separated sequence of values:
    
    ```julia
    println("+", "-")
    ```
    
    The function print does not advance to the next line:
    
    ```julia
    print("+ ")
    println("-")
    ```
    
    The output of these statements is `"+ -"` on the same line. The output from the next print statement would begin on the next line.
"""

# ╔═╡ Cell order:
# ╟─83a971d0-6806-11eb-3d06-d585d1137246
# ╟─6b429bb8-6803-11eb-0653-1538c7fdbe03
# ╟─d0c2a30c-6803-11eb-3c6d-69265f8e8e8a
# ╠═1800c6a4-ff70-4499-86e1-07d5ff495bfd
# ╟─dc752538-43f1-44fb-b526-16475e2a03cb
# ╠═43bac4c4-653d-4fdc-ad79-8ee2c2584c95
# ╠═18a74656-33a9-41d7-b0b6-ab48f37b9202
# ╠═465f1d71-4f8d-4cce-97a9-25c697187da1
# ╟─8cd91165-8538-4734-b7fd-eac9f04ab3e3
# ╠═27a9597d-06c4-46b2-afa3-7882b2997aaa
# ╠═db0cc555-31a4-4e7a-9e56-847a430c6919
# ╟─12871031-7c0a-46d2-9e99-c1caf0986380
# ╠═a38b1abd-74bd-40bc-8897-2455b4777db5
# ╟─6fe51f2f-65b2-44d3-ab33-75ee093ab139
# ╠═6ac117cc-c47f-46a8-8e67-99bdb794949e
# ╠═46f32313-f91d-4216-aca0-a9bec58561f0
# ╟─5c7adb76-6804-11eb-3e57-4f0e9ff68b17
# ╠═528153af-ec22-4068-b2b2-e920c059fe6c
# ╟─d6df8701-9e75-408c-a3ce-521c63c1efae
# ╠═64d1a56b-5271-4f67-9c7d-ae61988b33c8
# ╟─a3491cdf-7a67-45c6-9809-b7aaae3abe3f
# ╠═b534c2d9-5eaf-4a4e-967a-f30ca67daffc
# ╠═acb13fae-d14d-4c08-9916-6f3ac51cd945
# ╟─ac35a41e-e7c2-4d7c-8263-897d46ea96f9
# ╠═20b00dd0-3644-4fbd-bcbd-b565523b0506
# ╟─46a2dff3-660c-4838-91d8-51f0b02060bf
# ╟─14d4c81c-6805-11eb-330e-b31bc35b924e
# ╠═d81ea2b9-5528-4e22-b747-a400cf84ddf2
# ╟─9d4c81b8-4306-4467-a4ae-b9cd6cae01db
# ╠═044ae05e-2396-459d-8740-ea928620cc97
# ╟─b5ca010d-48f3-4e55-a753-97b47dc60f39
# ╠═ed0dd3d4-3364-4e57-80dd-e0c0facc71f6
# ╟─844c788e-6805-11eb-0387-6bf667e2ba6d
# ╠═bff25d47-cbd0-45dd-b83e-fdb21de50235
# ╟─7f296c1b-12c5-4916-b17e-9fb888f0c953
# ╠═0e7392d0-bcbb-4e22-9bd4-d989bafa316e
# ╟─ba4cd1eb-c2d4-4d98-a66f-c53d30cb66a8
# ╠═d8b2cf61-32f8-4191-8e4d-beb51b1ce7e4
# ╟─497a72bb-9c99-4deb-a714-87deaf37fd50
# ╠═549b213e-45e5-45e3-bb16-5f5c19be48f5
# ╟─c5161f26-7a40-4cb2-92dd-85ee87cbdb5c
# ╟─5edc214e-68cb-11eb-23a6-2bbae196847e
# ╟─8eb04e9c-6806-11eb-2191-6f9a8bd5d57a
# ╟─ff341d78-6806-11eb-1cf9-e75f47ca002e
# ╟─850fbbd0-6807-11eb-382a-5b580659afad
# ╟─bd2a3eee-6807-11eb-00f9-2dc1666a7ed9
# ╠═2d882d96-f751-40d6-963c-1ad4f0b1af35
# ╟─81f9ccbc-6143-47f3-abd6-645047a098da
# ╠═6f198f09-29ba-45fa-ae31-3020443e5a6f
# ╠═efd471aa-cdfa-456a-8b05-114dd6806793
# ╠═797e01dd-f6b8-4351-b18b-048e9034e45d
# ╟─68773bb1-7357-45e2-90f9-a4f1c2d97e4e
# ╠═818f33df-e7dd-4109-814b-963f91fe30a4
# ╠═add7e8f0-7680-4794-9659-23fb8b54029e
# ╟─c9f63a60-6ed7-4bdd-80f2-774bce24c293
# ╠═f0e5109a-600e-4935-a62a-04b8b3b0161c
# ╠═2b71c511-4013-47af-ae78-aaaecaa15bc6
# ╟─047aa249-7b80-491b-912e-a470331428a1
# ╟─05da4942-68ce-11eb-3634-4f77c713ba1e
# ╟─d92f58e6-6808-11eb-1c83-49d4a6a8b4bd
# ╠═9ab6f64d-0621-4af0-9321-4f9401d190a2
# ╟─ca8dc216-acc4-4e5b-b262-e71153b5fc9d
# ╠═cc4e568a-19fe-4355-884b-20b17b0ca0ba
# ╟─b1aa718a-75b3-40c0-918e-f7d28c6299d5
# ╠═baa2b86c-e0ad-4392-9f77-7ef4a6702eb2
# ╟─25468639-8a32-431b-a5c0-043f894c1a03
# ╟─23dd6e64-ee48-4604-b978-935e0b7b9a77
# ╟─b0a0c234-6808-11eb-062f-b5be2390f714
# ╟─94c0413e-68d0-11eb-23c2-31909597a1f8
# ╟─73f6657c-68d1-11eb-1537-8b9791787e36
# ╠═400680b0-6162-4812-8a2d-c82e757a51a0
# ╠═645d2eaf-17f1-4f95-8d1e-ec1d4e971727
# ╠═d3580f24-4879-4e06-8b91-cd30e7cb60b6
# ╟─b2f0648f-425e-4ec7-a542-62fdca047cc7
# ╟─a0971d9e-68d4-11eb-0614-0d91989881cd
# ╠═72f3b853-5015-49af-9ec0-39b0abd2f2de
# ╠═e68df0ff-53b3-4965-ab09-9579c385e717
# ╟─b049e781-b903-41b0-ad0a-971704ea5709
# ╠═754f2403-ccbc-44dd-89d7-75548fbfd9ca
# ╟─7196b12d-b64d-47a7-ae71-b77bd5f8b8ad
# ╠═d4787e1f-24f9-4ba0-b309-c0ca1f16c4c0
# ╟─d1e3f107-bd3a-4a87-848e-1ab5b410f6af
# ╠═ec761da6-35af-406c-9917-8e7f111a5325
# ╠═5ab48a64-8dbb-4502-bd8b-707dcd7482ce
# ╟─ae78dea0-e602-4a29-831d-577f14737af2
# ╠═975a07b0-0034-4ed4-be80-12fd6a577e92
# ╟─f89fd1a4-6867-4e2c-b6b7-ad7306e420b0
# ╟─fe683d58-68d5-11eb-22c6-8d59946b6043
# ╟─640b2da0-68d6-11eb-1e2d-cdf06b701b35
# ╟─d1f91354-68d6-11eb-011d-c7dbdb310949
# ╟─924657fc-68d7-11eb-068e-1f86cd76b173
# ╟─ba4efec0-68d7-11eb-1670-f3b243ec16d4
# ╟─21ee9e2a-68d8-11eb-2378-8f86ad348501
# ╟─a6646e6e-68d8-11eb-2b06-75b6abfc177a
