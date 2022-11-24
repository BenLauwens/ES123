### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ 32be2dac-7618-11eb-2ea5-9f165c3c91e1
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

# ╔═╡ 334f2774-7610-11eb-197e-eb4c20530a0c
md"""# Fruitful Functions

Many of the Julia functions we have used, such as the math functions, produce return values. But the functions we’ve written are all void: they have an effect, like printing a value or moving a turtle, but they return nothing. In this chapter you will learn to write fruitful functions."""

# ╔═╡ b1a8c332-7610-11eb-1b18-f7bf7f28ea27
md"""## Return Values

Calling a function generates a return value, which we usually assign to a variable or use as part of an expression:

```julia
e = exp(1.0)
height = radius * sin(radians)
```

!!! tip
    Julia provides the Euler's number ``\mathcal e`` by the symbol `ℯ` (**`\euler TAB`**).

The functions we have written so far are void. Speaking casually, they have no return value; more precisely, their return value is nothing. In this chapter, we are (finally) going to write fruitful functions. The first example is area, which returns the area of a circle with the given radius:
"""

# ╔═╡ fbb22aac-ed8a-4e25-8fb7-515798a7f72d
function area(radius) 
	a = π * radius^2
	return a 
end

# ╔═╡ b96ba715-ddda-47af-9dac-407923b6d03a
md"""We have seen the return statement before, but in a fruitful function the return statement includes an expression. This statement means: “Return immediately from this function and use the following expression as a return value.” The expression can be arbitrarily complicated, so we could have written this function more concisely:

```julia
function area(radius) 
	π * radius^2
end
```

where the last expression is automatically returned; or

```julia
area(radius) = π * radius^2
```

but this is only usefull for a function consisting of a oneline expression.

However, *temporary variables* like `a` and explicit return statements can make debugging easier.

The value returned by a function is the value of the last expression evaluated, which, by default, is the last expression in the body of the function definition.

Sometimes it is useful to have multiple return statements, one in each branch of a conditional:
"""

# ╔═╡ 6887201f-1ebb-4201-8cd4-6f592aa12efd
function absvalue(x) 
	if x < 0
		return -x 
	else
		return x 
	end
end

# ╔═╡ c9767a6b-ce21-4843-9bcb-330af6444fd8
md"""or

```julia
function absvalue(x) 
	if x < 0
		-x 
	else
		x 
	end
end
```

because the last expression evaluated is automatically returned.

Since these return statements are in an alternative conditional, only one runs.

As soon as a return statement runs, the function terminates without executing any subsequent statements. Code that appears after a return statement, or any other place the flow of execution can never reach, is called *dead code*.

In a fruitful function, it is a good idea to ensure that every possible path through the program hits a return statement. Consider this example:
"""

# ╔═╡ 129075a2-a215-4905-8d6e-d04da70fe69a
function absvalue_err(x) 
	if x < 0
		return -x 
	end
	if x > 0 
		return x
	end 
end

# ╔═╡ 4e7abb20-5521-436e-a9fa-9bfd0fbdf47e
md"""This function is incorrect because if `x` happens to be `0`, neither condition is true, and the function ends without hitting a return statement. If the flow of execution gets to the end of a function, the return value is `nothing`, which is not the absolute value of `0`.
"""

# ╔═╡ 131480f6-71d7-42a3-a7b0-a2112ef2abfe
show(absvalue_err(0)) 

# ╔═╡ 1a73c7ad-bc08-415a-b37f-ebe7acc8a8a9
md"""!!! tip
    Julia provides a built-in function called `abs` that computes absolute values.
"""

# ╔═╡ 4219f3ac-7612-11eb-3167-f55e643f9235
md"""#### Exercise 6-1

Write a compare function that takes two values, `x` and `y`, and returns `1` if `x > y`, `0` if `x == y`, and `-1` if `x < y`.
"""

# ╔═╡ 8b79bba4-7682-11eb-2ea1-0986a9911b40
md"""!!! languages
    In Python and the C programming language, `return` cannot be omitted, neither is the last evaluated expression returned automatically.
    
    ```python
    def absvalue(x):
        if x < 0:
            return -x
        else:
            return x
    
    ```
    
    The return type has to be provided in C:
    
    ```c
    double absvalue(double x) {
        if (x < 0) {
            return -x;
        } else {
            return x;
        }
    }
    ```
    
    MATLAB uses a `return` statement without argument. A function stops after this statements and returns the values specified in the header:

    ```matlab
    function [ret] = absvalue(x)
        if x < 0
            ret = -x;
        else
            ret = x;
        end
    end
    ```
"""

# ╔═╡ bfecb80e-7612-11eb-0633-035cbcd3e426
md"""## Incremental Development

As you write larger functions, you might find yourself spending more time debugging.

To deal with increasingly complex programs, you might want to try a process called *incremental development*. The goal of incremental development is to avoid long debugging sessions by adding and testing only a small amount of code at a time.

As an example, suppose you want to find the distance between two points, given by the coordinates ``(x_1, y_1)`` and ``(x_2, y_2)``. By the Pythagorean theorem, the distance is:

```math
d=\sqrt{(x_2−x_1)^2+(y_2−y_1)^2}
```

The first step is to consider what a distance function should look like in Julia. In other words, what are the inputs (parameters) and what is the output (return value)?

In this case, the inputs are two points, which you can represent using four numbers. The return value is the distance represented by a floating-point value.

Immediately you can write an outline of the function and call it with sample arguments:
"""

# ╔═╡ e4dc510b-c45a-45ad-8f36-c173c3fd587e
let
	function distance(x₁, y₁, x₂, y₂) 
		return 0.0
	end

	distance(1.0, 2.0, 4.0, 6.0)
end

# ╔═╡ bb192f6d-32bc-4a78-8360-eba58e73b5ca
md"""Obviously, this version doesn’t compute distances; it always returns zero. But it is syntactically correct, and it runs, which means that you can test it before you make it more complicated. The subscript numbers are available in the Unicode character encoding (**`\_1 TAB`**, **`\_2 TAB`**, etc.).

I chose the sample arguments so that the horizontal distance is ``3`` and the vertical distance is ``4``; that way, the result is ``5``, the hypotenuse of a 3-4-5 triangle. When testing a function, it is useful to know the right answer.

At this point we have confirmed that the function is syntactically correct, and we can start adding code to the body. A reasonable next step is to find the differences ``x_2 − x_1`` and ``y_2 − y_1``. The next version stores those values in temporary variables and prints them with the `@show` macro:
"""

# ╔═╡ 54c72011-910e-45e9-a597-ccdc4dff6743
let
	function distance(x₁, y₁, x₂, y₂)
		dx = x₂ - x₁
		dy = y₂ - y₁
		@show dx dy 
		return 0.0
	end
	
	distance(1.0, 2.0, 4.0, 6.0)
end

# ╔═╡ e787ee70-f4d0-4e0b-a9ab-88411565eb85
md"""If the function is working, it should display `dx = 3` and `dy = 4`. If so, we know that the function is getting the right arguments and performing the first computation correctly. If not, there are only a few lines to check.

Next, we compute the sum of squares of `dx` and `dy`:
"""

# ╔═╡ 58a165a4-942b-4cf0-aabe-bc68aee3c34c
let
	function distance(x₁, y₁, x₂, y₂)
		dx = x₂ - x₁
		dy = y₂ - y₁
		d² = dx^2 + dy^2
		@show d² 
		return 0.0
	end

	distance(1.0, 2.0, 4.0, 6.0)
end

# ╔═╡ 4374af23-b021-4ac9-8bb1-5fe7fd896cf3
md"""Again, you would run the program at this stage and check the output (which should be `25`). Superscript numbers are also available (**`\^2 TAB`**). Finally, you can use `sqrt` or `√` (**`\sqrt TAB`**) to compute and return the result:
"""

# ╔═╡ 4c5f679a-0a37-4279-be37-2c53fe0d925c
function distance(x₁, y₁, x₂, y₂)
	dx = x₂ - x₁
	dy = y₂ - y₁
	d² = dx^2 + dy^2
	return √d² 
end

# ╔═╡ bb9f9b67-d76a-4956-9fbe-6b0a934eeb0e
distance(1.0, 2.0, 4.0, 6.0)

# ╔═╡ f9f26b03-0cde-4428-aac5-236fb7164b34
md"""If that works correctly, you are done. Otherwise, you might want to print the value of `√d²` before the return statement.

The final version of the function doesn’t display anything when it runs; it only returns a value. The print statements we wrote are useful for debugging, but once you get the function working, you should remove them. Code like that is called *scaffolding* because it is helpful for building the program but is not part of the final product.

When you start out, you should add only a line or two of code at a time. As you gain more experience, you might find yourself writing and debugging bigger chunks. Either way, incremental development can save you a lot of debugging time.

The key aspects of the process are:

1. Start with a working program and make small, incremental changes. At any point, if there is an error, you should have a good idea where it is.
2. Use variables to hold intermediate values so you can display and check them.
3. Once the program is working, you might want to remove some of the scaffolding or consolidate multiple statements into compound expressions, but only if it does not make the program difficult to read.
"""

# ╔═╡ 8d9ff285-6907-4071-b208-7d8fc702a59b
md"""We used `let` blocks to create new local definitions of the `distance` function to illustrate the different steps. Normally, you modify the code in the cell during the development process. As a best practice, you create the function call with default parameters before the function definition. In the notebook interface it will be automatically executed every time you modify the function definition."""

# ╔═╡ f5edc4c2-7613-11eb-0765-cba4f0286212
md"""#### Exercise 6-2

Use incremental development to write a function called hypotenuse that returns the length of the hypotenuse of a right triangle given the lengths of the other two legs as arguments. Record each stage of the development process as you go."""

# ╔═╡ 47e45c90-7615-11eb-0fe7-358b9d219497
md""" ## Composition

As you should expect by now, you can call one function from within another. As an example, we’ll write a function that takes two points, the center of the circle and a point on the perimeter, and computes the area of the circle.

Assume that the center point is stored in the variables `xc` and `yc`, and the perimeter point is in `xp` and `yp`. The first step is to find the radius of the circle, which is the distance between the two points. We just wrote a function, distance, that does that:

```julia
radius = distance(xc, yc, xp, yp)
```

The next step is to find the area of a circle with that radius; we just wrote that, too:

```julia
result = area(radius)
```

Encapsulating these steps in a function, we get:

```julia
function circlearea(xc, yc, xp, yp) 
	radius = distance(xc, yc, xp, yp) 
	result = area(radius)
	return result
end
```

The temporary variables `radius` and `result` are useful for development and debugging, but once the program is working, we can make it more concise by composing the function calls:
"""

# ╔═╡ 80890607-b4be-4541-bea0-11744cabbadb
begin
	circlearea(xc, yc, xp, yp) = area(distance(xc, yc, xp, yp))
	circlearea(1.0, 2.0, 4.0, 6.0)
end

# ╔═╡ a74ddcba-7615-11eb-1ba0-c1d9a4eacfb5
md"""## Boolean Functions

Functions can return Booleans, which is often convenient for hiding complicated tests inside functions. For example:
"""

# ╔═╡ aa7f4b2d-a6c9-4c61-ae18-9c929ecd117e
function isdivisible(x, y) 
	if x % y == 0
		return true
	else
		return false
	end
end

# ╔═╡ 67568605-8fc5-4f8a-8f87-387d7663cb70
md"""It is common to give Boolean functions names that sound like yes/no questions; `isdivisible` returns either `true` or `false` to indicate whether `x` is divisible by `y`.

Here is an example:
"""

# ╔═╡ 5fa7bb83-b035-4ddf-9447-7eecfa09e952
isdivisible(6, 4) 

# ╔═╡ 69a47f53-bc26-4603-a1fd-47f0ccecfffe
isdivisible(6, 3) 

# ╔═╡ cf96bc1e-a42f-42fd-a3b1-e6318da2daf0
md"""The result of the `==` operator is a Boolean, so we can write the function more concisely by returning it directly:

```julia
isdivisible(x, y) =  x % y == 0
```

Boolean functions are often used in conditional statements:
"""

# ╔═╡ b292289e-4cda-4725-be1f-0b7dfc49e31d
if isdivisible(6, 3)
	println("6 is divisible by 3")
end

# ╔═╡ ef5158e3-65b4-4979-9843-1f7c8ef757bb
md"""It might be tempting to write something like:

```julia
if isdivisible(x, y) == true 
	println("x is divisible by y")
end
```

But the extra comparison with `true` is unnecessary.
"""

# ╔═╡ 3a20604e-7616-11eb-20c6-1fb57dbbb3c8
md"""#### Exercise 6-3
Write a function `isbetween(x, y, z)` that returns `true` if `x ≤ y ≤ z` or `false` otherwise.
"""

# ╔═╡ 53822bd0-7616-11eb-08df-0b6ef72120a8
md"""## More Recursion

We have only covered a small subset of Julia, but you might be interested to know that this subset is a *complete* programming language, which means that anything that can be computed can be expressed in this language. Any program ever written could be rewritten using only the language features you have learned so far (actually, you would need a few commands to control devices like the mouse, disks, etc., but that’s all).

Proving that claim is a nontrivial exercise first accomplished by Alan Turing, one of the first computer scientists (some would argue that he was a mathematician, but a lot of early computer scientists started as mathematicians). Accordingly, it is known as the Turing thesis. For a more complete (and accurate) discussion of the Turing thesis, I recommend Michael Sipser’s book *Introduction to the Theory of Computation* (Cengage).

To give you an idea of what you can do with the tools you have learned so far, we’ll evaluate a few recursively defined mathematical functions. A recursive definition is similar to a circular definition, in the sense that the definition contains a reference to the thing being defined. A truly circular definition is not very useful:

*vorpal*:
An adjective used to describe something that is vorpal.

If you saw that definition in the dictionary, you might be annoyed. On the other hand, if you looked up the definition of the factorial function, denoted with the symbol ``!``, you might get something like this:

```math
n!=\begin{cases}
1 & \textrm{if }n=0\\
n(n-1)! & \textrm{if }n>0
\end{cases}
```

This definition says that the factorial of ``0`` is ``1``, and the factorial of any other value, ``n``, is ``n`` multiplied by the factorial of ``n − 1``.

So, ``3!`` is ``3`` times ``2!``, which is ``2`` times ``1!``, which is ``1`` times ``0!``. Putting it all together, ``3!`` equals ``3`` times ``2`` times ``1`` times ``1``, which is ``6``.

If you can write a recursive definition of something, you can write a Julia program to evaluate it. The first step is to decide what the parameters should be. In this case it should be clear that factorial takes an integer:
"""

# ╔═╡ fe51d5b9-30ae-4b09-b4d0-6bd312e18df2
let
	function fact(n)
		return 0
	end
	@show fact(0)
	@show fact(5)
end;

# ╔═╡ aba2610e-6673-42cd-9db8-1bb14adc3c6a
md"""We have created an outline of the function `fact` and two calls with default parameters. The `@show` macro displays the function evaluations. The semi-colon after the `end` keyword of the `let` block suppresses the output.

If the argument happens to be `0` all we have to do is return `1`:
"""

# ╔═╡ 0091c836-cb15-4ecf-b001-0bafb5143c31
let
	function fact(n)
		if n == 0
			return 1
		end
		return 0
	end
	@show fact(0)
	@show fact(5)
end;

# ╔═╡ dc3e37f9-d686-4e72-9b46-5fcbba041f5b
md"""Otherwise, and this is the interesting part, we have to make a recursive call to find the factorial of `n-1` and then multiply it by `n`:
"""

# ╔═╡ c665c76f-1b7f-4b61-976f-c134a670fccf
begin
	function fact(n)
		if n == 0
			return 1
		end
		recurse = fact(n-1) 
		result = n * recurse 
		return result
	end
	@show fact(0)
	@show fact(5)
end;

# ╔═╡ dc241e23-e6d5-4997-b7fa-1e44d66226c0
md"""The flow of execution for this program is similar to the flow of `countdown` in “Recursion”. If we call fact with the value `3`:

* Since `3` is not `0`, we take the second branch and calculate the factorial of `n-1`... 
  * Since `2` is not `0`, we take the second branch and calculate the factorial of `n-1`...
    * Since `1` is not `0`, we take the second branch and calculate the factorial of `n-1`... 
      * Since `0` equals `0`, we take the first branch and return `1` without making an more recursive calls.
    * The return value, `1`, is multiplied by `n`, which is `1`, and the result is returned.
  * The return value, `1`, is multiplied by `n`, which is `2`, and the result is returned.
* The return value `2` is multiplied by `n`, which is `3`, and the result, `6`, becomes the return value of the function call that started the whole process.

Figure 6-1 shows what the stack diagram looks like for this sequence of function calls.
"""

# ╔═╡ 2e8091da-7618-11eb-3181-a5801b7aaacb
Drawing(width=720, height=200) do
	@info "Stack diagram."
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=140, y=30, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("Main") 
	end
    rect(x=170, y=10, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=140, y=70, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("fact") 
	end
    rect(x=170, y=50, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=190, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=210, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=240, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3") 
	end
	text(x=300, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("recurse") 
	end
	text(x=370, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=400, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	text(x=460, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("result") 
	end
	text(x=520, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=550, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("6") 
	end
	text(x=140, y=110, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("fact") 
	end
    rect(x=170, y=90, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=190, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=210, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=240, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	text(x=300, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("recurse") 
	end
	text(x=370, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=400, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=460, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("result") 
	end
	text(x=520, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=550, y=110, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	text(x=140, y=150, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("fact") 
	end
    rect(x=170, y=130, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=190, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=210, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=240, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=300, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("recurse") 
	end
	text(x=370, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=400, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=460, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("result") 
	end
	text(x=520, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=550, y=150, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	text(x=140, y=190, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("fact") 
	end
    rect(x=170, y=170, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=190, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=210, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=240, y=190, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("0") 
	end
	path(d="M 570 50 C 595 50 595 40 580 40", stroke="black", fill="transparent", marker_end="url(#arrow)")
	text(x=600, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("6") 
	end
	path(d="M 570 90 C 595 90 595 80 580 80", stroke="black", fill="transparent", marker_end="url(#arrow)")
	text(x=600, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("2") 
	end
	path(d="M 570 130 C 595 130 595 120 580 120", stroke="black", fill="transparent", marker_end="url(#arrow)")
	text(x=600, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
	path(d="M 570 170 C 595 170 595 160 580 160", stroke="black", fill="transparent", marker_end="url(#arrow)")
	text(x=600, y=170, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("1") 
	end
end

# ╔═╡ 885ca14c-761f-11eb-072c-c9a4a2421f8f
md"""The return values are shown being passed back up the stack. In each frame, the return value is the value of result, which is the product of n and recurse.

In the last frame, the local variables recurse and result do not exist, because the branch that creates them does not run.

!!! tip
    Julia provides the function `factorial` to calculate the factorial of an integer number."""

# ╔═╡ a4c4b8a8-761f-11eb-345c-572d653d9b0b
md"""## Leap of Faith

Following the flow of execution is one way to read programs, but it can quickly become overwhelming. An alternative is what I call the “leap of faith.” When you come to a function call, instead of following the flow of execution, you *assume* that the function works correctly and returns the right result.

In fact, you are already practicing this leap of faith when you use built-in functions. When you call `cos` or `exp`, you don’t examine the bodies of those functions. You just assume that they work because the people who wrote the built-in functions were good programmers.

The same is true when you call one of your own functions. For example, in “Boolean Functions”, we wrote a function called `isdivisible` that determines whether one number is divisible by another. Once we have convinced ourselves that this function is correct—by examining the code and testing it—we can use the function without looking at the body again.

The same is true of recursive programs. In our example, when you get to the recursive call, instead of following the flow of execution, you should assume that the recursive call works (returns the correct result) and then ask yourself, “Assuming that I can find the factorial of `n-1`, can I compute the factorial of n?” It is clear that you can, by multiplying by `n`.

Of course, it’s a bit strange to assume that the function works correctly when you haven’t finished writing it, but that’s why it’s called a leap of faith!"""

# ╔═╡ d9ce6ae4-761f-11eb-346a-df17c8a60871
md"""## One More Example

After factorial, the most common example of a recursively defined mathematical function is Fibonacci:

```math
\textit{fib}(n)=\begin{cases}
0&\textrm{if }n=0\\
1&\textrm{if }n=1\\
\textit{fib}(n-1)+\textit{fib}(n-2)&\textrm{if }n>1
\end{cases}
```

Translated into Julia, it looks like this:
"""

# ╔═╡ 98385d53-9adf-483e-befd-497996c4c80c
function fib(n)
	if n == 0
		return 0
	elseif n == 1
		return 1
	else
		return fib(n-1) + fib(n-2)
	end
end

# ╔═╡ ba23ee63-ffbb-46b8-b9df-42b6f0120418
md"""If you try to follow the flow of execution here, even for fairly small values of `n`, your head explodes. But if you take the leap of faith and you assume that the two recursive calls work correctly, then it is clear that you get the right result by adding them together.
"""

# ╔═╡ 8e7878f2-7620-11eb-058a-7346748f29b0
md"""## Checking Types

What happens if we call `fact` and give it `1.5` as an argument?
"""

# ╔═╡ 72f36258-495e-472f-9f0f-f1119b265359
fact(1.5)

# ╔═╡ f4bfd186-923b-40e7-b14d-3ccc5b3f597c
md"""It looks like an infinite recursion. How can that be? The function has a base case— when `n == 0`. But if `n` is not an integer, we can *miss* the base case and recurse forever.

In the first recursive call, the value of `n` is `0.5`. In the next, it is `-0.5`. From there, it gets smaller (more negative), but it will never be `0`.

We have two choices. We can try to generalize the factorial function to work with floating-point numbers, or we can make `fact` check the type of its argument. The first option is called the gamma function, and it’s a little beyond the scope of this book. So we’ll go for the second.

We can use the built-in operator `isa` to verify the type of the argument. While we’re at it, we can also make sure the argument is positive:
"""

# ╔═╡ 9f7ddc22-6e1d-40da-b5bc-076a7844daa0
function fact_guard(n)
	if !(n isa Int64)
		error("Factorial is only defined for integers.") 
	elseif n < 0
		error("Factorial is not defined for negative integers.") 
	elseif n == 0
		return 1 
	else
		return n * fact_guard(n-1) 
	end
end

# ╔═╡ 355fd1d9-8939-4266-b3c1-78bb0f08ebfc
md"""The first base case handles nonintegers; the second handles negative integers. In both cases, the program prints an error message and returns nothing to indicate that something went wrong:
"""

# ╔═╡ bed7468e-b2c4-46fb-9cde-e5cdeab2a798
fact_guard("fred")

# ╔═╡ 28b64d6d-2664-4a0e-9045-0c7c2e66a7aa
fact_guard(-2)

# ╔═╡ d2efe1f2-681e-4002-9611-6b58552971fe
md"""If we get past both checks, we know that `n` is positive or `0`, so we can prove that the recursion terminates.

This program demonstrates a pattern sometimes called a guardian. The first two conditionals act as guardians, protecting the code that follows from values that might cause an error. The guardians make it possible to prove the correctness of the code.

In “Catching Exceptions” we will see a more flexible alternative to printing an error message: raising an exception.

Preferably, the first guardian should be omitted by specifying the type of the argument in the header of the function definition, see “Methods”.
"""

# ╔═╡ 431b4dc0-7621-11eb-1eb8-59d8c7c61a48
md"""## Debugging

Breaking a large program into smaller functions creates natural checkpoints for debugging. If a function is not working, there are three possibilities to consider:

* There is something wrong with the arguments the function is getting; a precondition is violated.
* There is something wrong with the function; a postcondition is violated.
* There is something wrong with the return value or the way it is being used.

To rule out the first possibility, you can add a print statement at the beginning of the function and display the values of the parameters (and maybe their types). Or you can write code that checks the preconditions explicitly.

If the parameters look good, add a print statement before each return statement and display the return value. If possible, check the result by hand. Consider calling the function with values that make it easy to check the result (as in “Incremental Development”).

If the function seems to be working, look at the function call to make sure the return value is being used correctly (or used at all!).

Adding print statements at the beginning and end of a function can help make the flow of execution more visible. For example, here is a version of `fact` with print statements:
"""

# ╔═╡ 2b4f7fdf-ecd8-4c06-a86e-0eafd215be68
function fact_debug(n)
	space = "_" ^ (4 * n) 
	println(space, "factorial ", n) 
	if n == 0
		println(space, "returning 1")
		return 1 
	end
	recurse = fact_debug(n-1)
	result = n * recurse
	println(space, "returning ", result) 
	return result
end

# ╔═╡ 2ac4a181-fc31-4b5d-8533-0c9275eebf9d
md"""`space` is a string of underscore characters that controls the indentation of the output:
"""

# ╔═╡ a238ab4e-4f33-4d05-b931-a4fd1d74eaec
fact_debug(4)

# ╔═╡ 1e77e67d-dd11-41f3-ac73-da3db8dd13f2
md"""If you are confused about the flow of execution, this kind of output can be helpful. It takes some time to develop effective scaffolding, but a little bit of scaffolding can save a lot of debugging.
"""

# ╔═╡ b23efabc-7621-11eb-1d20-9959e0cda861
md"""## Glossary

*temporary variable*:
A variable used to store an intermediate value in a complex calculation.

*dead code*:
Part of a program that can never run, often because it appears after a return statement.

*incremental development*:
A program development plan intended to avoid debugging by adding and testing only a small amount of code at a time.

*scaffolding*:
Code that is used during program development but is not part of the final version.

*guardian*:
A programming pattern that uses a conditional statement to check for and handle circumstances that might cause an error."""

# ╔═╡ e30a3db6-7621-11eb-0dbd-b962759a4c5a
md"""## Exercises

#### Exercise 6-4

Draw a stack diagram for the following program. What does the program print?

```julia
function b(z) 
	prod = a(z, z)
    println(z, " ", prod)
	prod
end

function a(x, y) 
	x=x+1
	x*y 
end

function c(x, y, z) 
	total=x+y+z 
	square = b(total)^2 
	square
end

x=1
y=x+1
println(c(x, y+3, x+y))
```
"""

# ╔═╡ 1269fe6e-7622-11eb-3da2-df0623082981
md"""#### Exercise 6-5

The Ackermann function, ``A(m, n)``, is defined as:

```math
A(m,n)=\begin{cases}
n+1&\textrm{if }m=0\\
A(m-1,1)&\textrm{if }m>0\textrm{ and }n=0\\
A(m-1,A(m,n-1))&\textrm{if }m>0\textrm{ and }n>0
\end{cases}
```

Write a function named `ack` that evaluates the Ackermann function. Use your function to evaluate `ack(3, 4)`, which should be `125`. What happens for larger values of `m` and `n`?
"""

# ╔═╡ 80d44aee-7622-11eb-0555-e3f485a65fe9
md"""#### Exercise 6-6

A palindrome is a word that is spelled the same backward and forward, like “noon” or “redivider.” Recursively, a word is a palindrome if the first and last letters are the same and the middle is a palindrome.

The following are functions that take a string argument and return the first, last, and middle letters:

```julia
function first(word)
	first = firstindex(word) 
	word[first]
end

function last(word)
	last = lastindex(word)
	word[last] 
end

function middle(word)
	first = firstindex(word)
	last = lastindex(word)
	word[nextind(word, first) : prevind(word, last)]
end
```

We’ll see how they work in Chapter 8.

1. Test these functions out. What happens if you call `middle` with a string with two letters? One letter? What about the empty string, which is written "" and contains no letters?
2. Write a function called `ispalindrome` that takes a string argument and returns `true` if it is a palindrome and `false` otherwise. Remember that you can use the built-in function length to check the length of a string."""

# ╔═╡ cc009a36-7622-11eb-1c86-1fbb98e9fdb3
md"""#### Exercise 6-7

A number, ``a``, is a power of ``b`` if it isdivisible by ``b`` and ``\frac{a}{b}`` is a power of ``b``. Write a function called `ispower` that takes parameters `a` and `b` and returns `true` if `a` is a power of `b`.

!!! tip
    You will have to think about the base case.
"""

# ╔═╡ 260955f6-7623-11eb-332f-dbba32b4a3d9
md"""#### Exercise 6-8

The greatest common divisor (GCD) of ``a`` and ``b`` is the largest number that divides both of them with no remainder.

One way to find the GCD of two numbers is based on the observation that if ``r`` is the remainder when ``a`` is divided by ``b``, then `gcd(a, b) = gcd(b, r)`. As a base case, we can use `gcd(a, 0) = a`.

Write a function called `gcd` that takes parameters `a` and `b` and returns their greatest common divisor.

*Credit*: This exercise is based on an example from Hal Abelson and Gerald Jay Sussman’s *Structure and Interpretation of Computer Programs* (MIT Press)."""

# ╔═╡ Cell order:
# ╟─32be2dac-7618-11eb-2ea5-9f165c3c91e1
# ╟─334f2774-7610-11eb-197e-eb4c20530a0c
# ╟─b1a8c332-7610-11eb-1b18-f7bf7f28ea27
# ╠═fbb22aac-ed8a-4e25-8fb7-515798a7f72d
# ╟─b96ba715-ddda-47af-9dac-407923b6d03a
# ╠═6887201f-1ebb-4201-8cd4-6f592aa12efd
# ╟─c9767a6b-ce21-4843-9bcb-330af6444fd8
# ╠═129075a2-a215-4905-8d6e-d04da70fe69a
# ╟─4e7abb20-5521-436e-a9fa-9bfd0fbdf47e
# ╠═131480f6-71d7-42a3-a7b0-a2112ef2abfe
# ╟─1a73c7ad-bc08-415a-b37f-ebe7acc8a8a9
# ╟─4219f3ac-7612-11eb-3167-f55e643f9235
# ╟─8b79bba4-7682-11eb-2ea1-0986a9911b40
# ╟─bfecb80e-7612-11eb-0633-035cbcd3e426
# ╠═e4dc510b-c45a-45ad-8f36-c173c3fd587e
# ╟─bb192f6d-32bc-4a78-8360-eba58e73b5ca
# ╠═54c72011-910e-45e9-a597-ccdc4dff6743
# ╟─e787ee70-f4d0-4e0b-a9ab-88411565eb85
# ╠═58a165a4-942b-4cf0-aabe-bc68aee3c34c
# ╟─4374af23-b021-4ac9-8bb1-5fe7fd896cf3
# ╠═bb9f9b67-d76a-4956-9fbe-6b0a934eeb0e
# ╠═4c5f679a-0a37-4279-be37-2c53fe0d925c
# ╟─f9f26b03-0cde-4428-aac5-236fb7164b34
# ╟─8d9ff285-6907-4071-b208-7d8fc702a59b
# ╟─f5edc4c2-7613-11eb-0765-cba4f0286212
# ╟─47e45c90-7615-11eb-0fe7-358b9d219497
# ╠═80890607-b4be-4541-bea0-11744cabbadb
# ╟─a74ddcba-7615-11eb-1ba0-c1d9a4eacfb5
# ╠═aa7f4b2d-a6c9-4c61-ae18-9c929ecd117e
# ╟─67568605-8fc5-4f8a-8f87-387d7663cb70
# ╠═5fa7bb83-b035-4ddf-9447-7eecfa09e952
# ╠═69a47f53-bc26-4603-a1fd-47f0ccecfffe
# ╟─cf96bc1e-a42f-42fd-a3b1-e6318da2daf0
# ╠═b292289e-4cda-4725-be1f-0b7dfc49e31d
# ╟─ef5158e3-65b4-4979-9843-1f7c8ef757bb
# ╟─3a20604e-7616-11eb-20c6-1fb57dbbb3c8
# ╟─53822bd0-7616-11eb-08df-0b6ef72120a8
# ╠═fe51d5b9-30ae-4b09-b4d0-6bd312e18df2
# ╟─aba2610e-6673-42cd-9db8-1bb14adc3c6a
# ╠═0091c836-cb15-4ecf-b001-0bafb5143c31
# ╟─dc3e37f9-d686-4e72-9b46-5fcbba041f5b
# ╠═c665c76f-1b7f-4b61-976f-c134a670fccf
# ╟─dc241e23-e6d5-4997-b7fa-1e44d66226c0
# ╟─2e8091da-7618-11eb-3181-a5801b7aaacb
# ╟─885ca14c-761f-11eb-072c-c9a4a2421f8f
# ╟─a4c4b8a8-761f-11eb-345c-572d653d9b0b
# ╟─d9ce6ae4-761f-11eb-346a-df17c8a60871
# ╠═98385d53-9adf-483e-befd-497996c4c80c
# ╟─ba23ee63-ffbb-46b8-b9df-42b6f0120418
# ╟─8e7878f2-7620-11eb-058a-7346748f29b0
# ╠═72f36258-495e-472f-9f0f-f1119b265359
# ╟─f4bfd186-923b-40e7-b14d-3ccc5b3f597c
# ╠═9f7ddc22-6e1d-40da-b5bc-076a7844daa0
# ╟─355fd1d9-8939-4266-b3c1-78bb0f08ebfc
# ╠═bed7468e-b2c4-46fb-9cde-e5cdeab2a798
# ╠═28b64d6d-2664-4a0e-9045-0c7c2e66a7aa
# ╟─d2efe1f2-681e-4002-9611-6b58552971fe
# ╟─431b4dc0-7621-11eb-1eb8-59d8c7c61a48
# ╠═2b4f7fdf-ecd8-4c06-a86e-0eafd215be68
# ╟─2ac4a181-fc31-4b5d-8533-0c9275eebf9d
# ╠═a238ab4e-4f33-4d05-b931-a4fd1d74eaec
# ╟─1e77e67d-dd11-41f3-ac73-da3db8dd13f2
# ╟─b23efabc-7621-11eb-1d20-9959e0cda861
# ╟─e30a3db6-7621-11eb-0dbd-b962759a4c5a
# ╟─1269fe6e-7622-11eb-3da2-df0623082981
# ╟─80d44aee-7622-11eb-0555-e3f485a65fe9
# ╟─cc009a36-7622-11eb-1c86-1fbb98e9fdb3
# ╟─260955f6-7623-11eb-332f-dbba32b4a3d9
