### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ d6bc6cde-7686-11eb-0a34-f1e7c9841275
begin
	import Pkg
    Pkg.activate()

    using PlutoUI
	using NativeSVG
end

# ╔═╡ f030f70c-7686-11eb-3c72-c59f85af6c83
md"""# Iteration

This chapter is about iteration, which is the ability to run a block of statements repeatedly. We saw a kind of iteration, using recursion, in “Recursion”. We saw another kind, using a `for` loop, in “Simple Repetition”. In this chapter we’ll see yet another kind, using a `while` statement. But first I want to say a little more about variable assignment.
"""

# ╔═╡ b464d026-7687-11eb-2e68-99bb4a60f392
md"""## Reassignment

As you may have discovered, it is legal to make more than one assignment to the same variable. A new assignment makes an existing variable refer to a new value (and stop referring to the old value):

```julia
julia> x = 5 
5 
julia> x = 7 
7
```

The first time we display `x`, its value is `5`; the second time, its value is `7`. 

Figure 7-1 shows what *reassignment* looks like in a state diagram.
"""

# ╔═╡ f001d996-7687-11eb-1215-5940f40d3fed
Drawing(width=720, height=50) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
    rect(x=310, y=10, width=100, height=40, fill="rgb(242, 242, 242)", stroke="black")
	text(x=330, y=35, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("x") 
	end
	text(x=390, y=25, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("5") 
	end
	text(x=390, y=45, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("7") 
	end
	line(x1=335, y1=30, x2=370, y2=23, stroke="black", stroke_dasharray="5,5", marker_end="url(#arrow)")
	line(x1=335, y1=32, x2=370, y2=37, stroke="black", marker_end="url(#arrow)")
end

# ╔═╡ 55c7f344-768d-11eb-2f35-e52d557f4c61
md"*7-1. State diagram.*"

# ╔═╡ 67411830-768d-11eb-1cf0-f9011222c68d
md"""At this point I want to address a common source of confusion. Because Julia uses the equals sign (`=`) for assignment, it is tempting to interpret a statement like `a = b` as a mathematical proposition of equality; that is, the claim that `a` and `b` are equal. But this interpretation is wrong.

First, equality is a symmetric relationship and assignment is not. For example, in mathematics, if ``a = 7`` then ``7 = a``. But in Julia, the statement `a = 7` is legal and `7 = a` is not.

Also, in mathematics, a proposition of equality is either true or false for all time. If ``a = b`` now, then ``a`` will always equal ``b``. In Julia, an assignment statement can make two variables equal, but they don’t have to stay that way:

```julia
julia> a = 5 
5
julia> b = a # a and b are now equal
5
julia> a = 3 # a and b are no longer equal
3
julia> b
5
```

The third line changes the value of `a `but does not change the value of `b`, so they are no longer equal.

!!! danger
    Reassigning variables is often useful, but you should use it with caution. If the values of variables change frequently, it can make the code difficult to read and debug.
    
    It is illegal to define a function that has the same name as a previously defined variable.
"""

# ╔═╡ 13602200-768e-11eb-389b-fb726834e96f
md"""## Updating Variables

A common kind of reassignment is an update, where the new value of the variable depends on the old:

```julia
julia> x = x + 1
8
```

or

```julia
julia> x += 1
8
```

This means “get the current value of `x`, add 1, and then update `x` with the new value.” 

If you try to update a variable that doesn’t exist, you get an error, because Julia evaluates the right side before it assigns a value to x: 

```julia
julia> y = y + 1
ERROR: UndefVarError: y not defined
```

Before you can update a variable, you have to initialize it, usually with a simple assignment:

```julia
julia> y = 0 
0
julia> y = y + 1
1
```

Updating a variable by adding 1 is called an *increment*; subtracting 1 is called a *decrement*.
"""

# ╔═╡ 658792ba-768f-11eb-0e59-6d3a8c392c59
md"""## The `while` Statement

Computers are often used to automate repetitive tasks. Repeating identical or similar tasks without making errors is something that computers do well and people do poorly. In a computer program, repetition is also called *iteration*.

We have already seen two functions, `countdown` and `printn`, that iterate using recursion. Because iteration is so common, Julia provides language features to make it easier. One is the `for` statement we saw in “Simple Repetition”. We’ll get back to that later.

Another is the *`while` statement*. Here is a version of `countdown` that uses a `while` statement:

```julia
function countdown(n) 
	while n > 0
		print(n, " ")
		n -= 1
	end
	println("Blastoff!")
end
```

You can almost read the `while` statement as if it were English. It means, “While `n` is greater than `0`, display the value of `n` and then decrement `n`. When you get to `0`, display the word `"Blastoff!"`”

More formally, here is the flow of execution for a `while` statement:


1. Determine whether the condition is true or false.
2. If false, exit the `while` statement and continue execution at the next statement.
3. If the condition is true, run the body and then go back to step 1.


This type of flow is called a loop because the third step loops back around to the top.

The body of the loop should change the value of one or more variables so that the condition becomes false eventually and the loop terminates. Otherwise, the loop will repeat forever, which is called an *infinite loop*. An endless source of amusement for computer scientists is the observation that the directions on shampoo bottles, “Lather, rinse, repeat,” are an infinite loop.

In the case of `countdown`, we can prove that the loop terminates: if `n` is `0` or negative, the loop never runs. Otherwise, `n` gets smaller each time through the loop, so eventually we have to get to `0`.

For some other loops, it is not so easy to tell. For example:

```julia
function seq(n) 
	while n != 1
		println(n) 
		if n % 2 == 0   # n is even
			n /= 2
		else
			n = 3n + 1  # n is odd
		end
	end 
end
```

The condition for this loop is `n != 1`, so the loop will continue until `n` is `1`, which makes the condition false.

Each time through the loop, the program outputs the value of `n` and then checks whether it is even or odd. If it is even, `n` is divided by 2. If it is odd, the value ofnis replaced with `3n + 1`. For example, if the argument passed to `seq` is `3`, the resulting values of `n` are `3`, `10`, `5.0`, `16.0`, `8.0`, `4.0`, `2.0`, `1.0`.

Since `n` sometimes increases and sometimes decreases, there is no obvious proof that `n` will ever reach `1`, or that the program terminates. For some particular values of `n`, we can prove termination. For example, if the starting value is a power of two, `n` will be even every time through the loop until it reaches `1`. The previous example ends with such a sequence, starting with `16`.

The hard question is whether we can prove that this program terminates for all positive values of `n`. So far, no one has been able to prove it or disprove it!
"""

# ╔═╡ f51d8d5c-7690-11eb-3eea-e5a92768f7e6
md"""#### Exercise 7-1

Rewrite the function `printn` from “Recursion” using iteration instead of recursion.
"""

# ╔═╡ 87bc44b0-76a4-11eb-3e5a-13df6d96717d
md"""!!! languages
    Both Python and the C programming language have a `while` statement:
    
    ```python
    def countdown(n):
        while n > 0:
            print(n, end=' ')
            n = n - 1
        
        print('Blastoff!')
    ```
    
    The conventions for each language are always similar.
    
    ```c
    void countdown(int n) {
        while (n > 0) {
            printf("%i ", n);
            n -= 1;
        }
        printf("Blastoff!\n");
    }
    ```
"""

# ╔═╡ 5adbadaa-76a6-11eb-34b0-0b02b1cd9f95
md"""## `break`

Sometimes you don’t know it’s time to end a loop until you get halfway through the body. In that case you can use the *`break` statement* to jump out of the loop.

For example, suppose you want to take input from the user until they type **`done`**. You could write:

```julia
while true
    print("> ")
    line = readline()
    if line == "done"
		break
	end
	println(line)
end
println("Done!")
```

The loop condition is `true`, which is always true, so the loop runs until it hits the
`break` statement.

Each time through, it prompts the user with an angle bracket. If the user types **`done`**, the `break` statement exits the loop. Otherwise, the program echoes whatever the user types and goes back to the top of the loop. Here’s a sample run:

```
> not done 
not done 
> done 
Done!
```

This way of writing `while` loops is common because you can check the condition anywhere in the loop (not just at the top) and you can express the stop condition affirmatively (“stop when this happens”) rather than negatively (“keep going until that happens”).
"""

# ╔═╡ 0aa7430a-76a7-11eb-1626-05ef9338e919
md"""## `continue`

The `break` statement exits the loop. When a *`continue` statement* is encountered inside a loop, control jumps to the beginning of the loop for the next iteration, skipping the execution of statements inside the body of the loop for the current iteration. For example, this

```julia
for i in 1:10 
	if i % 3 == 0
		continue 
	end
	print(i, " ") 
end
```

outputs

```
1 2 4 5 7 8 10
```

If `i` is divisible by `3`, the continue statement stops the current iteration and the nex iteration starts. Only the numbers in the range 1 to 10 not divisible by 3 are printed.
"""

# ╔═╡ c6aaba90-76a8-11eb-1e6f-495fb7759e5d
md"""!!! languages
    Both Python and the C programming language have `break` and `continue` statements.
"""

# ╔═╡ e74d8976-76a8-11eb-199d-c33a925a4d7f
md"""## Square Roots

Loops are often used in programs that compute numerical results by starting with an approximate answer and iteratively improving it.

For example, one way of computing square roots is Newton’s method. Suppose that you want to know the square root of a. If you start with almost any estimate, x, you can compute a better estimate with the following formula:

```math
y=\frac{1}{2}\left(x+\frac{a}{x}\right)
```

For example, if ``a`` is ``4`` and ``x`` is ``3``:

```julia
julia> a = 4
4
julia> x = 3
3
julia> y = 0.5(x + a/x)
2.1666666666666665
```

The result is closer to the correct answer (``\sqrt 4 = 2``). If we repeat the process with the new estimate, it gets even closer:

```julia
julia> x = y
2.1666666666666665

julia> y = 0.5(x + a/x)
2.0064102564102564
```

After a few more updates, the estimate is almost exact:

```julia
julia> x = y
2.0064102564102564

julia> y = 0.5(x + a/x)
2.0000102400262145

julia> x = y
2.0000102400262145

julia> y = 0.5(x + a/x)
2.0000000000262146
```

In general we don’t know ahead of time how many steps it takes to get to the right answer, but we know when we get there because the estimate stops changing:

```julia
julia> x = y
2.0000000000262146

julia> y = 0.5(x + a/x)
2.0

julia> x = y
2.0

julia> y = 0.5(x + a/x)
2.0
```

When `y == x`, we can stop. Here is a loop that starts with an initial estimate, `x`, and improves it until it stops changing:

```julia
while true
	println(x)
	y = 0.5(x + a/x)
	if y == x
		break
	end
	x = y
end
```

For most values of a this works fine, but in general it is dangerous to test float equality. Floating-point values are only approximately right: most rational numbers, like ``\frac{1}{3}``, and irrational numbers, like ``\sqrt 2``, can’t be represented exactly with a `Float64`.

Rather than checking whether `x` and `y` are exactly equal, it is safer to use the built-in function `abs` to compute the absolute value, or magnitude, of the difference between them:

```julia
if abs(y - x) < ε
	break
end
```

where `ε` (**`\varepsilon TAB`**) has a value like `0.0000001` that determines how close is close enough.
"""

# ╔═╡ c5327386-76af-11eb-1311-0f0f5cd2c507
md"""## Algorithms

Newton’s method is an example of an *algorithm*: it is a mechanical process for solving a category of problems (in this case, computing square roots).

To understand what an algorithm is, it might help to start with something that is not an algorithm. When you learned to multiply single-digit numbers, you probably memorized the multiplication table. In effect, you memorized 100 specific solutions. That kind of knowledge is not algorithmic.

But if you were “lazy”, you might have learned a few tricks. For example, to find the product of ``n`` and ``9``, you can write ``n−1`` as the first digit and ``10−n`` as the second digit. This trick is a general solution for multiplying any single-digit number by ``9``. That’s an algorithm!

Similarly, the techniques you learned for addition with carrying, subtraction with borrowing, and long division are all algorithms. One of the characteristics of algo‐ rithms is that they do not require any intelligence to carry out. They are mechanical processes where each step follows from the last according to a simple set of rules.

Executing algorithms is boring, but designing them is interesting, intellectually challenging, and a central part of computer science.

Some of the things that people do naturally, without difficulty or conscious thought, are the hardest to express algorithmically. Understanding natural language is a good example. We all do it, but so far no one has been able to explain how we do it, at least not in the form of an algorithm.
"""

# ╔═╡ 0c60279e-76b0-11eb-0687-bf8d44d9cd47
md"""## Debugging
As you start writing bigger programs, you might find yourself spending more time debugging. More code means more chances to make an error and more places for bugs to hide.

One way to cut your debugging time is “debugging by bisection.” For example, if there are 100 lines in your program and you check them one at a time, it will take 100 steps.

Instead, try to break the problem in half. Look at the middle of the program, or near it, for an intermediate value you can check. Add a print statement (or something else that has a verifiable effect) and run the program.

If the midpoint check is incorrect, there must be a problem in the first half of the pro‐ gram. If it is correct, the problem is in the second half.

Every time you perform a check like this, you halve the number of lines you have to search. In theory, after six steps (which is significantly fewer than 100), you’ll be down to one or two lines of code.

In practice, it is not always clear what the “middle of the program” is and not always possible to check it. It doesn’t make sense to count lines and find the exact midpoint. Instead, think about places in the program where there might be errors and places where it is easy to put a check. Then choose a spot where you think the chances are about the same that the bug is before or after the check.
"""

# ╔═╡ 2b84de3a-76b0-11eb-184e-fbf49560e122
md"""## Glossary

*reassignment*:
Assigning a new value to a variable that already exists.

*update*:
An assignment where the new value of the variable depends on the old.

*initialization*:
An assignment that gives an initial value to a variable that will be updated.

*increment*:
An update that increases the value of a variable (often by 1).

*decrement*:
An update that decreases the value of a variable.

*iteration*:
Repeated execution of a set of statements using either a recursive function call or a loop.

*`while` statement*:
A statement that allows iterations controlled by a condition.

*infinite loop*:
A loop in which the terminating condition is never satisfied.

*`break` statement*:
A statement allowing you to jump out of a loop.

*`continue` statement*:
A statement inside a loop that jumps to the beginning of the loop for the next iteration.

*algorithm*:
A general process for solving a category of problems.
"""

# ╔═╡ 7e6a42ea-76b0-11eb-0587-0b2e3932b601
md"""## Exercises

#### Exercise 7-2

Copy the loop from “Square Roots” and encapsulate it in a function called `mysqrt` that takes `a` as a parameter, chooses a reasonable value of `x`, and returns an estimate of the square root of `a`.

To test it, write a function named `testsquareroot` that prints a table like this:

```
a   mysqrt             sqrt               diff
-   ------             ----               ----
1.0 1.0                1.0                0.0
2.0 1.414213562373095  1.4142135623730951 2.220446049250313e-16
3.0 1.7320508075688772 1.7320508075688772 0.0
4.0 2.0                2.0                0.0
5.0 2.23606797749979   2.23606797749979   0.0
6.0 2.449489742783178  2.449489742783178  0.0
7.0 2.6457513110645907 2.6457513110645907 0.0
8.0 2.82842712474619   2.8284271247       4.440892098500626e-16
9.0 3.0                3.0                0.0
```

The first column is a number, `a`; the second column is the square root of a computed with `mysqrt`; the third column is the square root computed by `sqrt`; and the fourth column is the absolute value of the difference between the two estimates.
"""

# ╔═╡ f24e401a-76b0-11eb-1530-930c3df061fc
md"""#### Exercise 7-3

The built-in function `Meta.parse` takes a string and transforms it into an expression. This expression can be evaluated in Julia with the function `Core.eval`. For example:

```julia
julia> expr = Meta.parse("1+2*3") 
:(1 + 2 * 3)
julia> eval(expr)
7
julia> expr = Meta.parse("sqrt(π)") 
:(sqrt(π))
julia> eval(expr) 
1.7724538509055159
```

Write a function called `evalloop` that iteratively prompts the user, takes the resulting input and evaluates it using `eval`, and prints the result. It should continue until the user enters **`done`**, and then return the value of the last expression it evaluated.
"""

# ╔═╡ 2c14de1c-76b1-11eb-03f7-b73b33ae0d24
md"""## Exercise 7-4

The mathematician Srinivasa Ramanujan found an infinite series that can be used to generate a numerical approximation of ``\frac{1}{π}``:

```math
\frac{1}{π}=\frac{2\sqrt 2}{9801}\sum_{k=0}^\infty\frac{(4k)!(1103+26390k)}{(k!)^4 396^{4k}}
```

Write a function called `estimatepi` that uses this formula to compute and return an estimate of ``π``. It should use a while loop to compute terms of the summation until the last term is smaller than `1e-15` (which is Julia notation for ``10^{−15}``). You can check the result by comparing it to `π`.
"""

# ╔═╡ Cell order:
# ╟─d6bc6cde-7686-11eb-0a34-f1e7c9841275
# ╟─f030f70c-7686-11eb-3c72-c59f85af6c83
# ╟─b464d026-7687-11eb-2e68-99bb4a60f392
# ╠═f001d996-7687-11eb-1215-5940f40d3fed
# ╟─55c7f344-768d-11eb-2f35-e52d557f4c61
# ╟─67411830-768d-11eb-1cf0-f9011222c68d
# ╟─13602200-768e-11eb-389b-fb726834e96f
# ╟─658792ba-768f-11eb-0e59-6d3a8c392c59
# ╟─f51d8d5c-7690-11eb-3eea-e5a92768f7e6
# ╟─87bc44b0-76a4-11eb-3e5a-13df6d96717d
# ╟─5adbadaa-76a6-11eb-34b0-0b02b1cd9f95
# ╟─0aa7430a-76a7-11eb-1626-05ef9338e919
# ╟─c6aaba90-76a8-11eb-1e6f-495fb7759e5d
# ╟─e74d8976-76a8-11eb-199d-c33a925a4d7f
# ╟─c5327386-76af-11eb-1311-0f0f5cd2c507
# ╟─0c60279e-76b0-11eb-0687-bf8d44d9cd47
# ╟─2b84de3a-76b0-11eb-184e-fbf49560e122
# ╟─7e6a42ea-76b0-11eb-0587-0b2e3932b601
# ╟─f24e401a-76b0-11eb-1530-930c3df061fc
# ╟─2c14de1c-76b1-11eb-03f7-b73b33ae0d24
