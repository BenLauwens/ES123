### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ d6bc6cde-7686-11eb-0a34-f1e7c9841275
begin
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

# ╔═╡ Cell order:
# ╟─d6bc6cde-7686-11eb-0a34-f1e7c9841275
# ╟─f030f70c-7686-11eb-3c72-c59f85af6c83
# ╟─b464d026-7687-11eb-2e68-99bb4a60f392
# ╟─f001d996-7687-11eb-1215-5940f40d3fed
# ╟─55c7f344-768d-11eb-2f35-e52d557f4c61
# ╟─67411830-768d-11eb-1cf0-f9011222c68d
# ╟─13602200-768e-11eb-389b-fb726834e96f
