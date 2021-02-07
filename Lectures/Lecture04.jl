### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 2ade0260-68da-11eb-3c47-51af562ca746
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ dc4299ea-68d9-11eb-273b-a597294ef196
md"""# Case Study: Interface Design

This chapter presents a case study that demonstrates a process for designing functions that work together.

It introduces turtle graphics, a way to create programmatic drawings. Turtle graphics are not included in the standard library, so to use them you’ll have to add the `NativeSVG` package to your Julia setup.


The examples in this chapter can be executed in a graphical web-based notebook using the `Pluto` package, which combines code, formatted text, math, and multimedia in a single document (see Appendix B).
"""

# ╔═╡ 3dcb939c-68da-11eb-2546-85b34837f29c
md"""## Turtles

A *module* is a file that contains a collection of related functions. Julia provides some modules in its standard library. Additional functionality can be added from a growing collection of *packages*.

Packages can be installed in the REPL:

```julia
julia> using Pkg

julia> pkg.add("https://github.com/BenLauwens/NativeSVG.jl.git")
```

This can take some time.

Before we can use the functions in a module, we have to import it with a using state‐ ment:

```julia
using NativeSVG
🐢 = Turtle()
```

The NativeSVG module provides a function called `Turtle` that creates a turtle object, which we assign to a variable named `🐢` (**`\:turtle: TAB`**).

Once you create a turtle, you can call a function to move it around. For example, to move the turtle forward:

```julia
forward(🐢, 100)
Drawing(🐢, 720, 10)
```

The `Drawing` function creates an SVG picture (Figure 4-1). Its first argument is the turtle object, the second the width of the drawing and the third the height.
"""

# ╔═╡ 319c52f2-68dd-11eb-130c-f3672af50055
let
	🐢 = Turtle()
	forward(🐢, 100)
	Drawing(🐢, 720, 10)
end

# ╔═╡ b1f3a4cc-68de-11eb-3de9-87b14a76490e
md"*Figure 4-1. Moving the turtle forward.*"

# ╔═╡ 09d4cbb2-68df-11eb-2eec-bbe39ef9880d
md"""The arguments of `forward` are the turtle and a distance in pixels, so the actual size of the line that’s drawn depends on your display.

!!! into
    Each turtle is holding a pen, which is either down or up; if the pen is down (the default), the turtle leaves a trail when it moves. Figure 4-1 shows the trail left behind by the turtle. To move the turtle without drawing a line, first call the function `penup`. To start drawing again, call `pendown`.

Another function you can call with a turtle as an argument is `turn` for turning. The second argument for turn is an angle in degrees.

To draw a right angle:

```julia
let
	🐢 = Turtle()
	forward(🐢, 100)
	turn(🐢, -90) 
	forward(🐢, 100)
	Drawing(🐢, 720, 210)
end
```

The keyword `let` is used to group and isolate the statements. The result of the last statement in the let block is visualized in a Pluto notebook.
"""

# ╔═╡ c64b81dc-68df-11eb-1086-d57b61651791
md"""#### Exercise 4-1

Now modify the macro to draw a square. Don’t go on until you’ve got it working!
"""

# ╔═╡ d81174f8-68df-11eb-36b1-3bf0e6915823
let
	🐢 = Turtle()
	forward(🐢, 100)
	turn(🐢, -90) 
	forward(🐢, 100)
	Drawing(🐢, 720, 210)
end

# ╔═╡ Cell order:
# ╟─2ade0260-68da-11eb-3c47-51af562ca746
# ╟─dc4299ea-68d9-11eb-273b-a597294ef196
# ╟─3dcb939c-68da-11eb-2546-85b34837f29c
# ╟─319c52f2-68dd-11eb-130c-f3672af50055
# ╟─b1f3a4cc-68de-11eb-3de9-87b14a76490e
# ╟─09d4cbb2-68df-11eb-2eec-bbe39ef9880d
# ╟─c64b81dc-68df-11eb-1086-d57b61651791
# ╠═d81174f8-68df-11eb-36b1-3bf0e6915823
