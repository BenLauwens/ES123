### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 867b290c-6bd9-11eb-1afb-47757ee13936
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ 66ddc134-6bea-11eb-3bde-0fea30c863af
let
	t = Turtle()
	include("../src/chap05.jl")
	penup(t)
	forward(t, -200)
	turn(t, 90)
	forward(t, 60)
	turn(t,-90)
	pendown(t)
	koch(t, 400)
	Drawing(t, 720, 130)
end

# ╔═╡ 4cc6b8ac-6bd9-11eb-1d23-f5d9caf02cd3
md"""# Conditionals and Recursion

The main topic of this chapter is the `if` statement, which executes different code depending on the state of the program. But first I want to introduce two new operators: floor division and modulus."""

# ╔═╡ 81ea78c0-6bd9-11eb-1d3b-5f67fdf090f4
md"""## Floor Division and Modulus

The *floor division* operator, `÷` (**`\div TAB`**), divides two numbers and rounds down to an integer. For example, suppose the running time of a movie is 105 minutes. You might want to know how long that is in hours. Conventional division returns a floating-point number:

```julia
julia> minutes = 105
105
julia> minutes / 60
1.75
```

But we don’t normally write hours with decimal points. Floor division returns the integer number of hours, rounding down:

```julia
julia> hours = minutes ÷ 60
1
```

To get the remainder, you could subtract one hour in minutes:

```julia
julia> remainder = minutes - hours * 60
45
```

An alternative is to use the *modulus operator*, `%`, which divides two numbers and returns the remainder:

```julia
julia> remainder = minutes % 60
45
```

!!! tip
    The modulus operator is more useful than it seems. For example, you can check whether one number is divisible by another—if `x % y` is `0`, then `x` is divisible by `y`.

    Also, you can extract the rightmost digit or digits from a number. For example, `x % 10` yields the rightmost digit of an integer `x` (in base 10). Similarly, `x % 100` yields the last two digits.
"""

# ╔═╡ fa7e737c-6bd9-11eb-3cd0-d5b1d2ae7af1
md"""## Boolean Expressions

A *Boolean expression* is an expression that is either true or false. The following examples use the operator `==`, which compares two operands and produces `true` if they are equal and `false` otherwise:

```julia
julia> 5 == 5 
true
julia> 5 == 6 
false
```

`true` and `false` are special values that belong to the type `Bool`; they are not strings:

```julia
julia> typeof(true)
Bool
julia> typeof(false)
Bool
```

The `==` operator is one of the relational operators (operators that compare their operands). The others are:

```julia
x!=y # x is not equal to y
x≠y  # (\ne TAB)
x>y  # x is greater than y
x<y  # x is less than y
x>=y # x is greater than or equal to y x≥y # (\ge TAB)
x<=y # x is less than or equal to y
x≤y  # (\le TAB)
```

!!! danger
    Although these operations are probably familiar to you, the Julia symbols are different from the mathematical symbols. A common error is to use a single equals sign (`=`) instead of a double equals sign (`==`). Remember that `=` is an assignment operator and `==` is a relational operator. There is no such thing as `=<` or `=>`.
"""

# ╔═╡ 01a13616-6bdb-11eb-1b8b-8bdda36e623f
md"""## Logical Operators

There are three *logical operators*: `&&` (and), `||` (or), and `!` (not). The semantics (meaning) of these operators is similar to their meaning in English. For example, `x > 0 && x < 10` is true only if `x` is greater than `0` *and* less than `10`.

`n % 2 == 0 || n % 3 == 0` is true if *either or both* of the conditions is true; that is, if the number is divisible by 2 or 3.

Both `&&` and `||` associate to the right (i.e., grouped from the right), but `&&` has higher precedence than `||` does.

Finally, the `!` operator negates a Boolean expression, so `!(x > y)` is true if `x > y` is false; that is, if `x` is less than or equal to `y`.
"""

# ╔═╡ 7478967a-6bdb-11eb-03f7-81f894751f6d
md"""## Conditional Execution

In order to write useful programs, we almost always need the ability to check conditions and change the behavior of the program accordingly. *Conditional statements* give us this ability. The simplest form is the `if` statement:

```julia
if x > 0
	println("x is positive")
end
```

The Boolean expression after `if` is called the *condition*. If it is true, the indented statement runs. If not, nothing happens.

`if` statements have the same structure as function definitions: a header followed by a body terminated with the keyword `end`. Statements like this are called *compound statements*.

There is no limit on the number of statements that can appear in the body. Occasionally, it is useful to have a body with no statements (usually as a placeholder for code you haven’t written yet):

```julia
if x < 0
	# TODO: need to handle negative values!
end
```
"""

# ╔═╡ e75638d2-6bdb-11eb-0a7e-93446ea41c2d
md"""## Alternative Execution

A second form of the `if` statement is “alternative execution,” in which there are two possibilities and the condition determines which one runs. The syntax looks like this:

```julia
if x % 2 == 0
	println("x is even")
else
	println("x is odd") 
end
```

If the remainder when `x `is divided by 2 is 0, then we know that `x` is even, and the program displays an appropriate message. If the condition is false, the second set of statements runs. Since the condition must be true or false, exactly one of the alternatives will run. The alternatives are called *branches*, because they are branches in the flow of execution.
"""

# ╔═╡ 482d8390-6bdc-11eb-3e3c-33b9f4f244b9
md"""## Chained Conditionals

Sometimes there are more than two possibilities and we need more than two branches. One way to express a computation like that is using a *chained conditional*:

```julia
if x < y
	println("x is less than y")
elseif x > y
	println("x is greater than y")
else
	println("x and y are equal")
end
```

Again, exactly one branch will run. There is no limit on the number of `elseif` statements. If there is an `else` clause, it has to be at the end, but there doesn’t have to be one:

```julia
if choice == "a"
	draw_a()
elseif choice == "b"
	draw_b()
elseif choice == "c"
	draw_c()
end
```

Each condition is checked in order. If the first is false, the next is checked, and so on. If one of them is true, the corresponding branch runs and the statement ends. Even if more than one condition is true, only the first true branch runs.
"""

# ╔═╡ 9a3080ec-6be4-11eb-32eb-f162987e0fd6
md"""
!!! languages
    In Python, `if` statements have the same structure as function definitions: a header followed by an indented body.

    ```python
    if x < y:
        print('x is less than y')
    elif x > y:
        print('x is greater than y')
    else:
        print('x and y are equal')

    ```
    
    In the C programming language, we find a similar `if` statement:
    
    ```c
    if (x < y) {
        printf("x is less than y\n");
    }
    else if (x > y) {
        printf("x is greater than y\n");
    }
    else {
        printf("x and y are equal\n");
    }
    ```
"""

# ╔═╡ c0f31858-6bdc-11eb-00f8-9b4fb5bebb3e
md"""## Nested Conditionals

One conditional can also be nested within another. We could have written the example in the previous section like this:

```julia
if x == y
	println("x and y are equal")
else
	if x < y
		println("x is less than y") 
	else
		println("x is greater than y")
	end 
end
```

The outer conditional contains two branches. The first branch contains a simple statement. The second branch contains another `if` statement, which has two branches of its own. Those two branches are both simple statements, although they could have been conditional statements as well.

Although the (noncompulsory) indentation of the statements makes the structure apparent, *nested conditionals* become difficult to read very quickly. It is a good idea to avoid them when you can.

Logical operators often provide a way to simplify nested conditional statements. For example, we can rewrite the following code using a single conditional:

```julia
if 0 < x 
	if x < 10
		println("x is a positive single-digit number.") 
	end
end
```

The print statement runs only if we make it past both conditionals, so we can get the same effect with the `&&` operator:

```julia
if 0 < x && x < 10
	println("x is a positive single-digit number.")
end
```

For this kind of condition, Julia provides a more concise syntax:

```julia
if 0 < x < 10
	println("x is a positive single-digit number.")
end
```
"""

# ╔═╡ 81410cd0-6bdd-11eb-3ac7-21c132df1a56
md"""## Recursion

It is legal for one function to call another; it is also legal for a function to call itself. It may not be obvious why that is a good thing, but it turns out to be one of the most magical things a program can do. For example, look at the following function:

```julia
function countdown(n) 
	if n ≤ 0
		println("Blastoff!") 
	else
		print(n, " ")
		countdown(n-1) 
	end
end
```

If `n` is `0` or negative, it outputs the word `"Blastoff!"`. Otherwise, it outputs `n` and then calls a function named `countdown`—itself—passing `n-1` as an argument.

What happens if we call this function like this?

```julia
julia> countdown(3)
3 2 1 Blastoff!
```

* The execution of `countdown` begins with `n = 3`, and since `n` is greater than `0`, it outputs the value `3`, and then calls itself...
  * The execution of `countdown` begins with `n = 2`, and since `n` is greater than `0`, it outputs the value `2`, and then calls itself...

    * The execution of `countdown` begins with `n = 1`, and since `n` is greater than `0`, it outputs the value `1`, and then calls itself...

      * The execution of `countdown` begins with `n = 0`, and since `n` is not greater than `0`, it outputs the word `"Blastoff!"` and then returns.

    * The countdown that got `n = 1` returns.

  * The countdown that got `n = 2` returns.

* The countdown that got `n = 3` returns. And then you’re back in `Main`.

A function that calls itself is *recursive*; the process of executing it is called *recursion*. 

As another example, we can write a function that prints a string ``n`` times:

```julia
function printn(s, n) 
	if n ≤ 0
		return 
	end
	println(s)
	printn(s, n-1) 
end
```

If `n <= 0` the *`return` statement* exits the function. The flow of execution immediately returns to the caller, and the remaining lines of the function don’t run.

The rest of the function is similar to countdown: it displays s and then calls itself to display `s` `n-1` additional times. So, the number of lines of output is `1 + (n - 1)`, which adds up to `n`.

For simple examples like this, it is probably easier to use a `for` loop. But we will see examples later that are hard to write with a for loop and easy to write with recursion, so it is good to start early.
"""

# ╔═╡ 481f2708-6bde-11eb-2e2f-059722a2e288
md"""## Stack Diagrams for Recursive Functions

In “Stack Diagrams”, we used a stack diagram to represent the state of a program during a function call. The same kind of diagram can help us interpret a recursive function.

Every time a function gets called, Julia creates a frame to contain the function’s local variables and parameters. For a recursive function, there might be more than one frame on the stack at the same time.
"""

# ╔═╡ e7bc0384-6bdf-11eb-23d5-1f8454e713f2
Drawing(width=720, height=200) do
	text(x=320, y=30, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("Main") 
	end
    rect(x=360, y=10, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=320, y=70, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("countdown") 
	end
    rect(x=360, y=50, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=380, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=400, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=430, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3") 
	end
	text(x=320, y=110, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("countdown") 
	end
    rect(x=360, y=90, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=380, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=400, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=430, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	text(x=320, y=150, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("countdown") 
	end
    rect(x=360, y=130, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=380, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=400, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=430, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=320, y=190, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("countdown") 
	end
    rect(x=360, y=170, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=380, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=400, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=430, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("0") 
	end
end

# ╔═╡ 85d66ec4-6be0-11eb-32c2-f7068bc06a62
md"*Figure 5-1. Stack diagram.*"

# ╔═╡ 0658bd3c-6be0-11eb-21bd-d753ae791777
md"""As usual, at the top of the stack is the frame for `Main`. It is empty because we did not create any variables in `Main` or pass any arguments to it.

The four `countdown` frames have different values for the parameter `n`. The bottom of the stack, where `n = 0`, is called the *base case*. It does not make a recursive call, so there are no more frames."""

# ╔═╡ c7a395b0-6be1-11eb-2d6c-8d15b718faa9
md"""#### Exercise 5-1

As an exercise, draw a stack diagram for printn called with `s = "Hello"` and `n = 2`. Then write a function called `do_n` that takes a function object and a number, `n`, as arguments, and that calls the given function `n` times.
"""

# ╔═╡ f94724b0-6be1-11eb-2183-1d97bab81764
md"""## Infinite Recursion

If a recursion never reaches a base case, it goes on making recursive calls forever, and the program never terminates. This is known as *infinite recursion*, and it is generally not a good idea. Here is a minimal program with an infinite recursion:

```julia
function recurse() 
	recurse()
end
```

In most programming environments, a program with an infinite recursion does not really run forever. Julia reports an error message when the maximum recursion depth is reached:

```julia
julia> recurse()
ERROR: StackOverflowError: 
Stacktrace:
     [1] recurse() at ./REPL[1]:2 (repeats 80000 times)
```

This stacktrace is a little bigger than the one we saw in the previous chapter. When the error occurs, there are 80,000 `recurse` frames on the stack!

If you encounter an infinite recursion by accident, review your function to confirm that there is a base case that does not make a recursive call. And if there is a base case, check whether you are guaranteed to reach it.
"""

# ╔═╡ b5bbb0ac-6be2-11eb-33fd-7971aa3a4c24
md"""## Keyboard Input

The programs we have written so far accept no input from the user. They just do the same thing every time.

Julia provides a built-in function called readline that stops the program and waits for the user to type something. When the user presses Return or Enter, the program resumes and readline returns what the user typed as a string:

```julia
julia> text = readline()
What are you waiting for?
"What are you waiting for?"
```

Before getting input from the user, it is a good idea to print a prompt telling her what to type:

```julia
julia> print("What...is your name? "); readline()
What...is your name? Arthur, King of the Britons! 
"Arthur, King of the Britons!"
```

A semicolon (`;`) allows you to put multiple statements on the same line. In the REPL, only the last statement returns its value. semicolon (;) allows you to put multiple statements on the same line. In the REPL, only the last statement returns its value.

If you expect the user to type an integer, you can try to convert the return value to `Int64`:

```julia
julia> println("What...is the airspeed velocity of an unladen swallow?"); speed = readline()
What...is the airspeed velocity of an unladen swallow?
42
"42"
julia> parse(Int64, speed)
42
```

But if the user types something other than a string of digits, you get an error:

```julia
julia> println("What...is the airspeed velocity of an unladen swallow? "); speed = readline();
What...is the airspeed velocity of an unladen swallow?
What do you mean, an African or a European swallow?
julia> parse(Int64, speed)
ERROR: ArgumentError: invalid base 10 digit 'W' in "What do you mean, an African or a European swallow?"
[...]
```

We will see how to handle this kind of error later.

!!! info
    `readline` does not function in a Pluto notebook. However, a variable can be bound directly to a text input field:
    
    ```julia
    @bind x html"<input type=text>"
    ```
   
    Entering text in the text field will update the `x` variable and all top level statement using `x` will be reexecuted.
    
    All html input type are available.
"""

# ╔═╡ 96c3d1d8-6be3-11eb-1a7a-51786b2935ee
md"""## Debugging

When a syntax or runtime error occurs, the error message contains a lot of information. This can be overwhelming. The most useful parts are usually:

* What kind of error it was
* Where it occurred

Syntax errors are usually easy to find, but there are a few gotchas. In general, error messages indicate where the problem was discovered, but the actual error might be earlier in the code, sometimes on a previous line.

The same is true of runtime errors. Suppose you are trying to compute a signal-to- noise ratio in decibels. The formula is:

```math
\textit{SNR}_\mathrm{db} = 10 \log_{10} \frac{P_\mathrm{signal}}{P_\mathrm{noise}}
```

In Julia, you might write something like this:

```julia
signal_power = 9
noise_power = 10
ratio = signal_power ÷ noise_power
decibels = 10 * log10(ratio)
print(decibels)
```

And you’d get:

```julia
-Inf
```

This is not the result you expected.

To find the error, it might be useful to print the value of `ratio`, which turns out to be `0`. The problem is in line 3, which uses floor division instead of floatingpoint division.

!!! warning
    You should take the time to read error messages carefully, but don’t assume that everything they say is correct.
"""

# ╔═╡ acd667ba-6be3-11eb-00a0-55632ca86594
md"""## Glossary

*floor division*:
An operator, denoted `÷`, that divides two numbers and rounds down (toward negative infinity) to an integer.

*modulus operator*:
An operator, denoted with a percent sign (`%`), that works on integers and returns the remainder when one number is divided by another.

*Boolean expression*:
An expression whose value is either `true` or `false`.

*relational operator*:
One of the operators that compares its operands: `==`, `≠` (`!=`), `>`, `<`, `≥` (`>=`), and `≤` (`<=`).

*logical operator*:
One of the operators that combines Boolean expressions: `&&` (and), `||` (or), and `!` (not).

*conditional statement*:
A statement that controls the flow of execution depending on some condition.

*condition*:
The Boolean expression in a conditional statement that determines which branch runs.

*compound statement*:
A statement that consists of a header and a body. The body is terminated with the keyword `end`.

*branch*:
One of the alternative sequences of statements in a conditional statement.

*chained conditional*:
A conditional statement with a series of alternative branches.

*nested conditional*:
A conditional statement that appears in one of the branches of another conditional statement.

*recursive function*:
A function that calls itself.

*recursion*:
The process of calling the function that is currently executing.

*return statement*:
A statement that causes a function to end immediately and return to the caller.

*base case*:
A conditional branch in a recursive function that does not make a recursive call.

*infinite recursion*:
A recursion that doesn’t have a base case, or never reaches it. Eventually, an infinite recursion causes a runtime error.
"""

# ╔═╡ 81e8c81e-6be7-11eb-1052-434aee7931cf
md"""## Exercises 

#### Exercise 5-2

The function `time` returns the current Greenwich Mean Time in seconds since “the epoch,” which is an arbitrary time used as a reference point. On Unix systems, the epoch is 1 January 1970:

```julia
julia> time() 
1.612992834821836e9
```

Write a script that reads the current time and converts it to a time of day in hours, minutes, and seconds, plus the number of days since the epoch.
"""

# ╔═╡ bdd9c6c0-6be7-11eb-1cf0-65fbaf11abd0
md"""#### Exercise 5-3

Fermat’s Last Theorem says that there are no positive integers ``a``, ``b``, and ``c`` such that: 

```math
a^n + b^n = c^n
```

for any value of ``n`` greater than ``2``.

1. Write a function named `checkfermat` that takes four parameters—`a`, `b`, `c`, and `n`—and checks to see if Fermat’s theorem holds. If `n` is greater than `2` and `a^n + b^n == c^n` the program should print, “Holy smokes, Fermat was wrong!” Otherwise, the program should print, “No, that doesn’t work.”

2. Write a function that prompts the user to input values for `a`, `b`, `c`, and `n`, converts them to integers, and uses `checkfermat` to check whether they violate Fermat’s theorem.
"""

# ╔═╡ 3a3ae2be-6be8-11eb-1fdc-db6aadd33a76
md"""#### Exercise 5-4

If you are given three sticks, you may or may not be able to arrange them in a triangle. For example, if one of the sticks is 12 inches long and the other two are 1 inch long, you will not be able to get the short sticks to meet in the middle. For any three lengths, there is a simple test to see if it is possible to form a triangle:

*If any of the three lengths is greater than the sum of the other two, then you cannot form a triangle. Otherwise, you can. (If the sum of two lengths equals the third, they form what is called a “degenerate” triangle.)*

1. Write a function named `istriangle` that takes three integers as arguments and prints either “Yes” or “No,” depending on whether you can or cannot form a triangle from sticks with the given lengths.

2. Write a function that prompts the user to input three stick lengths, converts them to integers, and uses `istriangle` to check whether sticks with the given lengths can form a triangle.
"""

# ╔═╡ 894fdcfe-6be8-11eb-021a-df6b152e0a2d
md"""#### Exercise 5-5

What is the output of the following program? Draw a stack diagram that shows the state of the program when it prints the result.

```julia
function recurse(n, s) 
	if n == 0
		println(s) 
	else
		recurse(n-1, n+s) 
	end
end

recurse(3, 0)
```

1. What would happen if you called this function like this: `recurse(-1, 0)`?

2. Write a docstring that explains everything someone would need to know in order to use this function (and nothing else).
"""

# ╔═╡ 052ec49c-6bea-11eb-325f-d924ddacca6f
md"""
!!! info
    The following exercises use the `NativeSVG` module, described in Chapter 4.

#### Exercise 5-6

Read the following function and see if you can figure out what it does. Then run it and see if you got it right.

```julia
function draw(t, length, n) 
	if n == 0
		return 
	end
	angle = 50
	forward(t, length*n)
	turn(t, -angle)
	draw(t, length, n-1)
	turn(t, 2*angle)
	draw(t, length, n-1)
	turn(t, -angle)
	forward(t, -length*n)
end
```
"""

# ╔═╡ 5609252e-6bea-11eb-073c-0db3c1ab2da7
md"""#### Exercise 5-7

The Koch curve is a fractal that looks something like Figure 5-2.
"""

# ╔═╡ a70a425e-6beb-11eb-08e3-5d02826766e1
md"*Figure 5-2. A Koch curve.*"

# ╔═╡ b7655da0-6beb-11eb-21e4-a3372fe53c50
md"""To draw a Koch curve with length ``x``, all you have to do is:

1. Draw a Koch curve with length ``\frac{x}{3}``.
2. Turn left ``60`` degrees.
3. Draw a Koch curve with length ``\frac{x}{3}``.
4. Turn right ``120`` degrees.
5. Draw a Koch curve with length ``\frac{x}{3}``.
6. Turn left ``60`` degrees.
7. Draw a Koch curve with length ``\frac{x}{3}``.

The exception is if ``x`` is less than ``3``: in that case, you can just draw a straight line with length ``x``.

1. Write a function called `koch` that takes a turtle and a length as parameters, and that uses the turtle to draw a Koch curve with the given length.

2. Write a function called `snowflake` that draws three Koch curves to make the out‐ line of a snowflake.

3. The Koch curve can be generalized in several ways. See [https://en.wikipedia.org/ wiki/Koch_snowflake](https://en.wikipedia.org/ wiki/Koch_snowflake) for examples and implement your favorite.
"""

# ╔═╡ Cell order:
# ╟─867b290c-6bd9-11eb-1afb-47757ee13936
# ╟─4cc6b8ac-6bd9-11eb-1d23-f5d9caf02cd3
# ╟─81ea78c0-6bd9-11eb-1d3b-5f67fdf090f4
# ╟─fa7e737c-6bd9-11eb-3cd0-d5b1d2ae7af1
# ╟─01a13616-6bdb-11eb-1b8b-8bdda36e623f
# ╟─7478967a-6bdb-11eb-03f7-81f894751f6d
# ╟─e75638d2-6bdb-11eb-0a7e-93446ea41c2d
# ╟─482d8390-6bdc-11eb-3e3c-33b9f4f244b9
# ╟─9a3080ec-6be4-11eb-32eb-f162987e0fd6
# ╟─c0f31858-6bdc-11eb-00f8-9b4fb5bebb3e
# ╟─81410cd0-6bdd-11eb-3ac7-21c132df1a56
# ╟─481f2708-6bde-11eb-2e2f-059722a2e288
# ╟─e7bc0384-6bdf-11eb-23d5-1f8454e713f2
# ╟─85d66ec4-6be0-11eb-32c2-f7068bc06a62
# ╟─0658bd3c-6be0-11eb-21bd-d753ae791777
# ╟─c7a395b0-6be1-11eb-2d6c-8d15b718faa9
# ╟─f94724b0-6be1-11eb-2183-1d97bab81764
# ╟─b5bbb0ac-6be2-11eb-33fd-7971aa3a4c24
# ╟─96c3d1d8-6be3-11eb-1a7a-51786b2935ee
# ╟─acd667ba-6be3-11eb-00a0-55632ca86594
# ╟─81e8c81e-6be7-11eb-1052-434aee7931cf
# ╟─bdd9c6c0-6be7-11eb-1cf0-65fbaf11abd0
# ╟─3a3ae2be-6be8-11eb-1fdc-db6aadd33a76
# ╟─894fdcfe-6be8-11eb-021a-df6b152e0a2d
# ╟─052ec49c-6bea-11eb-325f-d924ddacca6f
# ╟─5609252e-6bea-11eb-073c-0db3c1ab2da7
# ╟─66ddc134-6bea-11eb-3bde-0fea30c863af
# ╟─a70a425e-6beb-11eb-08e3-5d02826766e1
# ╟─b7655da0-6beb-11eb-21e4-a3372fe53c50
