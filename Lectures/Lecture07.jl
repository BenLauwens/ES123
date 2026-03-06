### A Pluto.jl notebook ###
# v0.20.23

using Markdown
using InteractiveUtils

# ╔═╡ d6bc6cde-7686-11eb-0a34-f1e7c9841275
begin
	include("../src/chap07.jl")
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

# ╔═╡ f030f70c-7686-11eb-3c72-c59f85af6c83
md"""# Iteration

This chapter is about iteration, which is the ability to run a block of statements repeatedly. We saw a kind of iteration, using recursion, in “Recursion”. We saw another kind, using a `for` loop, in “Simple Repetition”. In this chapter we’ll see yet another kind, using a `while` statement. But first I want to say a little more about variable assignment.
"""

# ╔═╡ b464d026-7687-11eb-2e68-99bb4a60f392
md"""## Reassignment

As you may have discovered, it is legal to make more than one assignment to the same variable. A new assignment makes an existing variable refer to a new value (and stop referring to the old value):
"""

# ╔═╡ 1c2fd536-e0f9-409d-a036-7e7b24735938
let
	x = 5
	@show x
	x = 7
	@show x
end;

# ╔═╡ 54be42ba-8181-47ec-b4f6-5195cf012eab
md"""The first time we display `x`, its value is `5`; the second time, its value is `7`.

Figure 7-1 shows what *reassignment* looks like in a state diagram.
"""

# ╔═╡ f001d996-7687-11eb-1215-5940f40d3fed
Drawing(width=500, height=50) do
	@info "State diagram."
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
    rect(x=210, y=10, width=100, height=40, fill="rgb(242, 242, 242)", stroke="black")
	text(x=230, y=35, font_family="JuliaMono, monospace", text_anchor="end", font_size="9pt", font_weight=600) do
		str("x")
	end
	text(x=290, y=25, font_family="JuliaMono, monospace", text_anchor="end", font_size="9pt", font_weight=600) do
		str("5")
	end
	text(x=290, y=45, font_family="JuliaMono, monospace", text_anchor="end", font_size="9pt", font_weight=600) do
		str("7")
	end
	line(x1=235, y1=30, x2=270, y2=23, stroke="black", stroke_dasharray="5,5", marker_end="url(#arrow)")
	line(x1=235, y1=32, x2=270, y2=37, stroke="black", marker_end="url(#arrow)")
end

# ╔═╡ 67411830-768d-11eb-1cf0-f9011222c68d
md"""At this point I want to address a common source of confusion. Because Julia uses the equals sign (`=`) for assignment, it is tempting to interpret a statement like `a = b` as a mathematical proposition of equality; that is, the claim that `a` and `b` are equal. But this interpretation is wrong.

First, equality is a symmetric relationship and assignment is not. For example, in mathematics, if ``a = 7`` then ``7 = a``. But in Julia, the statement `a = 7` is legal and `7 = a` is not.

Also, in mathematics, a proposition of equality is either true or false for all time. If ``a = b`` now, then ``a`` will always equal ``b``. In Julia, an assignment statement can make two variables equal, but they don’t have to stay that way:
"""

# ╔═╡ 6bbbd8e7-cc25-4634-9dd8-312daf606a5f
let
	a = 5
	b = a
	@show a b
	a = 3
	@show a b
end;

# ╔═╡ d9daf308-96df-4a1a-acd1-a0a4ed3b099f
md"""The third line changes the value of `a `but does not change the value of `b`, so they are no longer equal.

!!! danger
    Reassigning variables is often useful, but you should use it with caution. If the values of variables change frequently, it can make the code difficult to read and debug.

    It is illegal to define a function that has the same name as a previously defined variable.
"""

# ╔═╡ 13602200-768e-11eb-389b-fb726834e96f
md"""## Updating Variables

A common kind of reassignment is an update, where the new value of the variable depends on the old:
"""

# ╔═╡ f4cad654-1469-4d31-8a0b-481980337d15
let
	x = 7
	@show x
	x = x + 1
	@show x
end;

# ╔═╡ e821fa5c-2ba0-4534-bacc-b525e02731ab
md"or"

# ╔═╡ a91d900d-ab22-4168-85ee-696c8edeafb3
let
	x = 7
	@show x
	x += 1
	@show x
end;

# ╔═╡ f1d4c343-4c3d-460f-90d7-42d79c40ccc5
md"""This means “get the current value of `x`, add 1, and then update `x` with the new value.”

If you try to update a variable that doesn’t exist, you get an error, because Julia evaluates the right side before it assigns a value to x:
"""

# ╔═╡ 227d3fbf-0752-4c8d-b904-490e0558af9d
y = y + 1

# ╔═╡ bd739229-1cf5-42bb-b329-1224a69912f1
md"""Before you can update a variable, you have to initialize it, usually with a simple assignment:
"""

# ╔═╡ 4207cc0f-547f-4800-a7aa-4c9eebdaf17b
let
	y = 0
	y = y + 1
	@show y
end;

# ╔═╡ 6bf44532-2c65-45ec-bcc1-a496119c44ba
md"""Updating a variable by adding 1 is called an *increment*; subtracting 1 is called a *decrement*.
"""

# ╔═╡ 658792ba-768f-11eb-0e59-6d3a8c392c59
md"""## The `while` Statement

Computers are often used to automate repetitive tasks. Repeating identical or similar tasks without making errors is something that computers do well and people do poorly. In a computer program, repetition is also called *iteration*.

We have already seen two functions, `countdown` and `printn`, that iterate using recursion. Because iteration is so common, Julia provides language features to make it easier. One is the `for` statement we saw in “Simple Repetition”. We’ll get back to that later.

Another is the *`while` statement*. Here is a version of `countdown` that uses a `while` statement:
"""

# ╔═╡ afded099-5415-46bb-abd5-6357835f3e83
function countdown(n)
	while n > 0
		print(n, " ")
		n -= 1
	end
	println("Blastoff!")
end

# ╔═╡ 8fe33b17-8288-4a51-8cc4-680eb5960b9a
md"""You can almost read the `while` statement as if it were English. It means, “While `n` is greater than `0`, display the value of `n` and then decrement `n`. When you get to `0`, display the word `"Blastoff!"`”

More formally, here is the flow of execution for a `while` statement:


1. Determine whether the condition is true or false.
2. If false, exit the `while` statement and continue execution at the next statement.
3. If the condition is true, run the body and then go back to step 1.


This type of flow is called a loop because the third step loops back around to the top.

The body of the loop should change the value of one or more variables so that the condition becomes false eventually and the loop terminates. Otherwise, the loop will repeat forever, which is called an *infinite loop*. An endless source of amusement for computer scientists is the observation that the directions on shampoo bottles, “Lather, rinse, repeat,” are an infinite loop.

In the case of `countdown`, we can prove that the loop terminates: if `n` is `0` or negative, the loop never runs. Otherwise, `n` gets smaller each time through the loop, so eventually we have to get to `0`.

For some other loops, it is not so easy to tell. For example:
"""

# ╔═╡ b45aaed5-4436-491d-825f-7df9d98458f9
function seq(n)
	while n ≠ 1
		println(n)
		if n % 2 == 0   # n is even
			n /= 2
		else
			n = 3n + 1  # n is odd
		end
	end
end

# ╔═╡ b54af953-a3a2-4f7c-b798-114773f5f2bb
md"""The condition for this loop is `n != 1`, so the loop will continue until `n` is `1`, which makes the condition false.

Each time through the loop, the program outputs the value of `n` and then checks whether it is even or odd. If it is even, `n` is divided by 2. If it is odd, the value ofnis replaced with `3n + 1`. For example, if the argument passed to `seq` is `3`, the resulting values of `n` are `3`, `10`, `5.0`, `16.0`, `8.0`, `4.0`, `2.0`, `1.0`.

Since `n` sometimes increases and sometimes decreases, there is no obvious proof that `n` will ever reach `1`, or that the program terminates. For some particular values of `n`, we can prove termination. For example, if the starting value is a power of two, `n` will be even every time through the loop until it reaches `1`. The previous example ends with such a sequence, starting with `16`.

The hard question is whether we can prove that this program terminates for all positive values of `n`. So far, no one has been able to prove it or disprove it!
"""

# ╔═╡ f51d8d5c-7690-11eb-3eea-e5a92768f7e6
md"""### Exercise 7-1

Rewrite the function `printn` from “Recursion” using iteration instead of recursion.
"""

# ╔═╡ 87bc44b0-76a4-11eb-3e5a-13df6d96717d
md"""!!! python
    Python, MATLAB and the C programming language have a `while` statement:
    ```python
    def countdown(n):
        while n > 0:
            print(n, end=' ')
            n = n - 1

        print('Blastoff!')
    ```

!!! matlab
    The `while` loop in MATLAB is identical to the `while` statement in Julia:
    ```matlab
    function countdown(n)
        while n > 0
            printf('%i ', n)
            n -= 1;
        end
        printf('Blastoff!\n')
    end
    ```

!!! c
    The C syntax is similar:
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
"""

# ╔═╡ f0c5a9f7-6f32-4287-a6d1-7fa1f69df66e
print("""while true
    print("> ")
    line = readline()
    if line == "done"
		break
	end
	println(line)
end
println("Done!")""")

# ╔═╡ b082d8b5-5204-41e6-a8c5-269a534a8d88
md"""The loop condition is `true`, which is always true, so the loop runs until it hits the
`break` statement.

Each time through, it prompts the user with an angle bracket. If the user types **`done`**, the `break` statement exits the loop. Otherwise, the program echoes whatever the user types and goes back to the top of the loop. Here’s a sample run:
"""

# ╔═╡ 957c311f-540a-4903-a881-d39ccb859353
print("""> not done
not done
> done
Done!""")

# ╔═╡ 8982e2ac-3d9d-469f-871c-405fa1498064
md"""This way of writing `while` loops is common because you can check the condition anywhere in the loop (not just at the top) and you can express the stop condition affirmatively (“stop when this happens”) rather than negatively (“keep going until that happens”).
"""

# ╔═╡ 0aa7430a-76a7-11eb-1626-05ef9338e919
md"""## `continue`

The `break` statement exits the loop. When a *`continue` statement* is encountered inside a loop, control jumps to the beginning of the loop for the next iteration, skipping the execution of statements inside the body of the loop for the current iteration. For example,
"""

# ╔═╡ 1f074f6d-b562-485a-aebc-a081d9af65fa
for i in 1:10
	if i % 3 == 0
		continue
	end
	print(i, " ")
end

# ╔═╡ b3ec7984-37d0-4dbb-bf89-fdd02fa77720
md"""If `i` is divisible by `3`, the continue statement stops the current iteration and the nex iteration starts. Only the numbers in the range 1 to 10 not divisible by 3 are printed.
"""

# ╔═╡ c6aaba90-76a8-11eb-1e6f-495fb7759e5d
md"""!!! languages
    Python, MATLAB and the C programming language have also `break` and `continue` statements.
"""

# ╔═╡ e74d8976-76a8-11eb-199d-c33a925a4d7f
md"""## Square Roots

Loops are often used in programs that compute numerical results by starting with an approximate answer and iteratively improving it.

For example, one way of computing square roots is Newton’s method. Suppose that you want to know the square root of a. If you start with almost any estimate, ``x_0``, you can compute a better estimate with the following formula:

```math
x_1=\frac{1}{2}\left(x_0+\frac{a}{x_0}\right)
```

For example, if ``a`` is ``4`` and ``x_0`` is ``3``:
"""

# ╔═╡ 9fe2f34e-6aa6-4727-b5fd-1dbd8191edd8
a = 4

# ╔═╡ 840028c4-9913-4216-8a05-40c097adf945
x₀ = 3

# ╔═╡ 9c2e7346-c22f-4cee-8efb-0d39b20abe7c
x₁ = let x = x₀
	0.5(x + a/x)
end

# ╔═╡ 08188917-f1b1-444c-9556-adba29fb1420
md"""The result is closer to the correct answer (``\sqrt 4 = 2``). If we repeat the process with the new estimate, it gets even closer:
"""

# ╔═╡ 6c2361c6-e168-42cd-a208-6b56895068cb
x₂ = let x = x₁
	0.5(x + a/x)
end

# ╔═╡ 3b3e81a2-492f-46b3-8fb1-299f95ecdd93
md"""After a few more updates, the estimate is almost exact:
"""

# ╔═╡ 0e05362a-7de3-4549-b0ec-41924bf40998
x₃ = let x = x₂
	0.5(x + a/x)
end

# ╔═╡ 53a097d1-9d85-4bcb-8a56-eaea04fcf3ca
x₄ = let x = x₃
	0.5(x + a/x)
end

# ╔═╡ 74e45886-2e05-41f2-a766-f227c9f980c8
x₅ = let x = x₄
	0.5(x + a/x)
end

# ╔═╡ 12b90faa-c974-45b3-9923-980b0a4f1021
md"""When `y == x`, we can stop. Here is a loop that starts with an initial estimate, `x`, and improves it until it stops changing:
"""

# ╔═╡ 2e5d1c7c-d803-43ca-8a37-51f7414b815c
begin
	x = x₀
	while true
		@show x
		y = 0.5(x + a/x)
		if y == x
			break
		end
		x = y
	end
end

# ╔═╡ 631b265f-83e9-4b99-92e0-07303f4944e5
md"""For most values of a this works fine, but in general it is dangerous to test float equality. Floating-point values are only approximately right: most rational numbers, like ``\frac{1}{3}``, and irrational numbers, like ``\sqrt 2``, can’t be represented exactly with a `Float64`.

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

If the midpoint check is incorrect, there must be a problem in the first half of the program. If it is correct, the problem is in the second half.

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

### Exercise 7-2

Copy the loop from “Square Roots” and encapsulate it in a function called `mysqrt` that takes `a` as a parameter, chooses a reasonable value of `x`, and returns an estimate of the square root of `a`.

To test it, write a function named `testsquareroot` that prints a table like this:
"""

# ╔═╡ e437c749-0469-473b-a9af-6946786d6d9b
testsquareroot()

# ╔═╡ e884a527-ff85-4d00-a4cf-990e25bc0d7e
md"""The first column is a number, `a`; the second column is the square root of a computed with `mysqrt`; the third column is the square root computed by `sqrt`; and the fourth column is the absolute value of the difference between the two estimates.
"""

# ╔═╡ f24e401a-76b0-11eb-1530-930c3df061fc
md"""### Exercise 7-3

The built-in function `Meta.parse` takes a string and transforms it into an expression. This expression can be evaluated in Julia with the function `Core.eval`. For example:
"""

# ╔═╡ 8c9dbc04-3ee6-490b-a689-1783e70b1bc0
expr = Meta.parse("1+2*3")

# ╔═╡ 12e215f8-1f46-48bd-9869-3871a2c8da04
eval(expr)

# ╔═╡ f65bc050-1562-416c-a267-c9d8744cdf1b
eval(Meta.parse("sqrt(π)"))

# ╔═╡ 83947812-6799-42a8-866b-f2e594f53663
md"""Write a function called `evalloop` that iteratively prompts the user, takes the resulting input and evaluates it using `eval`, and prints the result. It should continue until the user enters **`done`**, and then return the value of the last expression it evaluated.
"""

# ╔═╡ 2c14de1c-76b1-11eb-03f7-b73b33ae0d24
md"""### Exercise 7-4

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
# ╠═1c2fd536-e0f9-409d-a036-7e7b24735938
# ╟─54be42ba-8181-47ec-b4f6-5195cf012eab
# ╟─f001d996-7687-11eb-1215-5940f40d3fed
# ╟─67411830-768d-11eb-1cf0-f9011222c68d
# ╠═6bbbd8e7-cc25-4634-9dd8-312daf606a5f
# ╟─d9daf308-96df-4a1a-acd1-a0a4ed3b099f
# ╟─13602200-768e-11eb-389b-fb726834e96f
# ╠═f4cad654-1469-4d31-8a0b-481980337d15
# ╟─e821fa5c-2ba0-4534-bacc-b525e02731ab
# ╠═a91d900d-ab22-4168-85ee-696c8edeafb3
# ╟─f1d4c343-4c3d-460f-90d7-42d79c40ccc5
# ╠═227d3fbf-0752-4c8d-b904-490e0558af9d
# ╟─bd739229-1cf5-42bb-b329-1224a69912f1
# ╠═4207cc0f-547f-4800-a7aa-4c9eebdaf17b
# ╟─6bf44532-2c65-45ec-bcc1-a496119c44ba
# ╟─658792ba-768f-11eb-0e59-6d3a8c392c59
# ╠═afded099-5415-46bb-abd5-6357835f3e83
# ╟─8fe33b17-8288-4a51-8cc4-680eb5960b9a
# ╠═b45aaed5-4436-491d-825f-7df9d98458f9
# ╟─b54af953-a3a2-4f7c-b798-114773f5f2bb
# ╟─f51d8d5c-7690-11eb-3eea-e5a92768f7e6
# ╟─87bc44b0-76a4-11eb-3e5a-13df6d96717d
# ╟─5adbadaa-76a6-11eb-34b0-0b02b1cd9f95
# ╟─f0c5a9f7-6f32-4287-a6d1-7fa1f69df66e
# ╟─b082d8b5-5204-41e6-a8c5-269a534a8d88
# ╟─957c311f-540a-4903-a881-d39ccb859353
# ╟─8982e2ac-3d9d-469f-871c-405fa1498064
# ╟─0aa7430a-76a7-11eb-1626-05ef9338e919
# ╠═1f074f6d-b562-485a-aebc-a081d9af65fa
# ╟─b3ec7984-37d0-4dbb-bf89-fdd02fa77720
# ╟─c6aaba90-76a8-11eb-1e6f-495fb7759e5d
# ╟─e74d8976-76a8-11eb-199d-c33a925a4d7f
# ╠═9fe2f34e-6aa6-4727-b5fd-1dbd8191edd8
# ╠═840028c4-9913-4216-8a05-40c097adf945
# ╠═9c2e7346-c22f-4cee-8efb-0d39b20abe7c
# ╟─08188917-f1b1-444c-9556-adba29fb1420
# ╠═6c2361c6-e168-42cd-a208-6b56895068cb
# ╟─3b3e81a2-492f-46b3-8fb1-299f95ecdd93
# ╠═0e05362a-7de3-4549-b0ec-41924bf40998
# ╠═53a097d1-9d85-4bcb-8a56-eaea04fcf3ca
# ╠═74e45886-2e05-41f2-a766-f227c9f980c8
# ╟─12b90faa-c974-45b3-9923-980b0a4f1021
# ╠═2e5d1c7c-d803-43ca-8a37-51f7414b815c
# ╟─631b265f-83e9-4b99-92e0-07303f4944e5
# ╟─c5327386-76af-11eb-1311-0f0f5cd2c507
# ╟─0c60279e-76b0-11eb-0687-bf8d44d9cd47
# ╟─2b84de3a-76b0-11eb-184e-fbf49560e122
# ╟─7e6a42ea-76b0-11eb-0587-0b2e3932b601
# ╟─e437c749-0469-473b-a9af-6946786d6d9b
# ╟─e884a527-ff85-4d00-a4cf-990e25bc0d7e
# ╟─f24e401a-76b0-11eb-1530-930c3df061fc
# ╠═8c9dbc04-3ee6-490b-a689-1783e70b1bc0
# ╠═12e215f8-1f46-48bd-9869-3871a2c8da04
# ╠═f65bc050-1562-416c-a267-c9d8744cdf1b
# ╟─83947812-6799-42a8-866b-f2e594f53663
# ╟─2c14de1c-76b1-11eb-03f7-b73b33ae0d24
