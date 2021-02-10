### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 2ade0260-68da-11eb-3c47-51af562ca746
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ 02c52b84-6991-11eb-1dbd-93af9a7ca7f1
let
	include("../src/chap04.jl")
	🐢 = Turtle()
	penup(🐢)
	forward(🐢, -200)
	pendown(🐢)
	flower(🐢, 7, 110.0, 60.0)
	penup(🐢)
	forward(🐢, 200)
	pendown(🐢)
	flower(🐢, 10, 80.0, 80.0)
	penup(🐢)
	forward(🐢, 200)
	pendown(🐢)
	flower(🐢, 20, 280.0, 20.0)
	Drawing(🐢, 720, 220)
end

# ╔═╡ 7933043e-6992-11eb-27b6-c10f5cb6dd29
let
	include("../src/chap04.jl")
	🐢 = Turtle()
	penup(🐢)
	forward(🐢, -280)
	pendown(🐢)
	size = 80
	drawpie(🐢, 5, size)
	drawpie(🐢, 6, size)
	drawpie(🐢, 7, size)
	drawpie(🐢, 8, size)
	Drawing(🐢, 720, 160)
end

# ╔═╡ 31bc6732-6993-11eb-295e-eb9f409a95fa
let
	include("../src/chap04.jl")
	🐢 = Turtle()
	penup(🐢)
	turn(🐢, 90)
	forward(🐢, 25)
	turn(🐢, -90)
	pendown(🐢)
  	spiral(🐢, 230, 6, 0.1, 0.0002)
	Drawing(🐢, 720, 220)
end

# ╔═╡ dc4299ea-68d9-11eb-273b-a597294ef196
md"""# Case Study: Interface Design

This chapter presents a case study that demonstrates a process for designing functions that work together.

It introduces turtle graphics, a way to create programmatic drawings. Turtle graphics are not included in the standard library, so to use them you’ll have to add the `NativeSVG` package to your Julia setup.


The examples in this chapter can be executed in a graphical web-based notebook using the `Pluto` package, which combines code, formatted text, math, and multimedia in a single document (see Appendix B).
"""

# ╔═╡ 3dcb939c-68da-11eb-2546-85b34837f29c
md"""## Turtles

A *module* contains a collection of related functions. Julia provides some modules in its standard library. Additional functionality can be added from a growing collection of *packages*.

Packages can be installed in the REPL:

```julia
julia> using Pkg

julia> pkg.add("https://github.com/BenLauwens/NativeSVG.jl.git")
```

This can take some time.

Before we can use the functions in a module, we have to import it with a using statement:

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

!!! info
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

# ╔═╡ 717ad810-6975-11eb-262d-7bc4027d58b6
md"""## Simple Repetition

Chances are you wrote something like this:

```julia
let 
	🐢 = Turtle()
	forward(🐢, 100)
	turn(🐢, -90)
	forward(🐢, 100) 
	turn(🐢, -90) 
	forward(🐢, 100) 
	turn(🐢, -90) 
	forward(🐢, 100)
	Drawing(🐢, 720, 210)
end
```

We can do the same thing more concisely with a `for` statement:

```julia
julia> for i in 1:4
           println("Hello!")
       end
Hello!
Hello!
Hello!
Hello!
```

This is the simplest use of the `for` statement; we will see more later. But that should be enough to let you rewrite your square-drawing program. Don’t go on until you do.


Here is a `for` statement that draws a square:


```julia
let
	🐢 = Turtle()
	for i in 1:4 
		forward(🐢, 100) 
		turn(🐢, -90)
	end
	Drawing(🐢, 720, 210)
end
```

The syntax of a `for` statement is similar to a function definition. It has a header and a body that ends with the keyword `end`. The body can contain any number of state‐ ments.


A `for` statement is also called a *loop* because the flow of execution runs through the body and then loops back to the top. In this case, it runs the body four times.


This version is actually a little different from the previous square-drawing code because it makes another turn after drawing the last side of the square. The extra turn takes more time, but it simplifies the code if we do the same thing every time through the loop. This version also has the effect of leaving the turtle back in the starting position, facing in the starting direction.
"""

# ╔═╡ 81fd8b28-6976-11eb-2737-69f3b0b4624c
md"""
!!! languages
    In Python the `for` statement is very similar:
    
    ```python
    >>> for i in range(4):
    ...     print('Hello!')
    ...
    ```
    
    As in Julia the `for` statement ressembles the function definition with a header that ends with a colon and an indented body. An empty line closes the loop.
    
    The `for` statement is the C programming language is less trivial:
    
    ```c
    for (int i=0; i<4; i++) {
        printf("Hello!\n");
    }
    ```
    
    The header has three arguments: initial value, end condition and increment. The body is enclosed in brackets. 
"""

# ╔═╡ dd37018e-6978-11eb-2885-29267aaac26a
md"""## Exercises

The following is a series of exercises using turtles. They are meant to be fun, but they have a point, too. While you are working on them, think about what the point is.

!!! tip
    The following sections contain solutions to the exercises, so don’t look until you have finished (or at least tried them).

#### Exercise 4-2

Write a function called `square` that takes a parameter named `t`, which is a turtle. It should use the turtle to draw a square.

Write a function call that passes `t` as an argument to `square`, and then call `Drawing`.

#### Exercise 4-3

Add another parameter, named `len`, to `square`. Modify the body so the length of the sides is `len`, and then modify the function call to provide a second argument. Call `Drawing again`. Test with a range of values for `len`.

#### Exercise 4-4

Make a copy of `square` and change the name to `polygon`. Add another parameter named `n` and modify the body so it draws an ``n``-sided regular polygon.

!!! tip
    The exterior angles of an ``n``-sided regular polygon are ``\frac{360}{n}`` degrees.

#### Exercise 4-5

Write a function called `circle` that takes a turtle, `t`, and radius, `r`, as parameters and that draws an approximate circle by calling polygon with an appropriate length and number of sides. Test your function with a range of values of `r`.

!!! tip
    Figure out the circumference of the circle and make sure that `len * n == circumference`.

#### Exercise 4-6

Make a more general version of circle called `arc` that takes an additional parameter `angle`, which determines what fraction of a circle to draw. `angle` is in units of degrees, so when `angle = 360`, `arc` should draw a complete circle.
"""

# ╔═╡ 25a280d6-697b-11eb-3279-95bb0e4d8229
md"""## Encapsulation

The first exercise asks you to put your square-drawing code into a function definition and then call the function, passing the turtle as a parameter. Here is a solution:

```julia
function square(t)
	for i in 1:4
		forward(t, 100)
		turn(t, -90)
	end
end
```

To draw the square, a call to `Drawing` is needed:

```julia
let
	🐢 = Turtle()
	square(🐢) 
	Drawing(🐢, 720, 210)
end
```

The innermost statements, `forward` and `turn`, are indented twice to show that they are inside the for loop, which is inside the function definition.


Inside the function, `t` refers to the same turtle `🐢`, so `turn(t, -90)` has the same effect as `turn(🐢, -90)`. In that case, why not call the parameter `🐢`? The idea is that `t` can be any turtle, not just `🐢` so you could create a second turtle and pass it as an argument to `square`:

```julia
let
	🐫 = Turtle()
	square(🐫) 
	Drawing(🐫, 720, 210)
end
```

Wrapping a piece of code up in a function is called *encapsulation*. One of the benefits of encapsulation is that it attaches a name to the code, which serves as a kind of documentation. Another advantage is that if you reuse the code, it is more concise to call a function twice than to copy and paste the body!
"""

# ╔═╡ c9fa13ec-697b-11eb-1a40-4b899f07dde7
md"""## Generalization

The next step is to add a `len` parameter to `square`. Here is a solution:

```julia
function square(t, len) 
	for i in 1:4
    	forward(t, len)
	turn(t, -90)
end
```

Adding a parameter to a function is called *generalization* because it makes the function more general. In the previous version, the square is always the same size; in this version it can be any size.

The next step is also a generalization. Instead of drawing squares, polygon draws regular polygons with any number of sides. Here is a solution:

```julia
function polygon(t, n, len) 
	angle = 360 / n
	for i in 1:n 
		forward(t, len)
		turn(t, -angle)
	end
end
```

To draw a 7-sided polygon with side length 70:

```julia
let
	🐢 = Turtle()
	polygon(🐢, 7, 70) 
	Drawing(🐢, 720, 320)
end
```
"""

# ╔═╡ 372310ae-697f-11eb-3217-f1afed271f4a
md"""## Interface Design

The next step is to write `circle`, which takes a radius, `r`, as a parameter. Here is a simple solution that uses `polygon` to draw a 50-sided polygon:

```julia
function circle(t, r) 
	circumference = 2π * r 
	n=50
	len = circumference / n 
	polygon(t, n, len)
end
```

The first line computes the circumference of a circle with radius ``r`` using the formula ``2πr``. `n` is the number of line segments in our approximation of a circle, so len is the length of each segment. Thus, polygon draws a 50-sided polygon that approximates a circle with radius ``r``.

One limitation of this solution is that `n` is a constant, which means that for very big circles, the line segments are too long, and for small circles, we waste time drawing very small segments. One solution would be to generalize the function by taking `n` as a parameter. This would give the user (whoever calls `circle`) more control, but the interface would be less clean.

The *interface* of a function is a summary of how it is used: What are the parameters? What does the function do? And what is the return value? An interface is “clean” if it allows the caller to do what he wants without dealing with unnecessary details.

In this example, `r` belongs in the interface because it specifies the circle to be drawn. `n` is less appropriate because it pertains to the details of how the circle should be rendered.

Rather than cluttering up the interface, it is better to choose an appropriate value of `n` depending on circumference:

```julia
function circle(t, r)
	circumference = 2π * r
	n = trunc(circumference / 3) + 3 
	len = circumference / n 
	polygon(t, n, len)
end
```

Now the number of segments is an integer near `circumference/3`, so the length of each segment is approximately ``3``, which is small enough that the circles look good but big enough to be efficient, and acceptable for any size circle.

Adding `3` to `n` guarantees that the polygon has at least three sides.
"""

# ╔═╡ 1b946992-6980-11eb-14ee-a11b07a08c75
md"""## Refactoring

When I wrote `circle`, I was able to reuse `polygon` because a many-sided polygon is a good approximation of a circle. But `arc` is not as cooperative; we can’t use `polygon` or `circle` to draw an arc.

One alternative is to start with a copy of `polygon` and transform it into `arc`. The result might look like this:


```julia
function arc(t, r, angle) 
	arc_len = 2π * r * angle / 360 
	n = trunc(arc_len / 3) + 1 
	step_len = arc_len / n 
	step_angle = angle / n 
	for i in 1:n
    	forward(t, step_len)
		turn(t, -step_angle) 
	end
end
```

The second half of this function looks like `polygon`, but we can’t reuse `polygon` without changing the interface. We could generalize `polygon` to take an `angle` as a third argument, but then `polygon` would no longer be an appropriate name! Instead, let’s call the more general function `polyline`:

```julia
function polyline(t, n, len, angle) 
	for i in 1:n
    	forward(t, len)
		turn(t, -angle)
	end
end
```

Now we can rewrite `polygon` and `arc` to use `polyline`:

```julia
function polygon(t, n, len) 
	angle = 360 / n
	polyline(t, n, len, angle) 
end

function arc(t, r, angle) 
	arc_len = 2π * r * angle / 360
	n = trunc(arc_len / 3) + 1
	step_len = arc_len / n
	step_angle = angle / n
	polyline(t, n, step_len, step_angle)
end
```

Finally, we can rewrite `circle` to use `arc`:


```julia
function circle(t, r) 
	arc(t, r, 360)
end
```

This process—rearranging a program to improve interfaces and facilitate code reuse —is called *refactoring*. In this case, we noticed that there was similar code in `arc` and `polygon`, so we “factored it out” into `polyline`.

If we had planned ahead, we might have written `polyline` first and avoided refactoring, but often you don’t know enough at the beginning of a project to design all the interfaces. Once you start coding, you understand the problem better. Sometimes refactoring is a sign that you have learned something.
"""

# ╔═╡ 090f60d4-6981-11eb-1c3d-df12052e6c4f
md"""## A Development Plan

A *development plan* is a process for writing programs. The process we used in this case study is “encapsulation and generalization.” The steps of this process are:

1. Start by writing a small program with no function definitions.
2. Once you get the program working, identify a coherent piece of it, encapsulate the piece in a function, and give it a name.
3. Generalize the function by adding appropriate parameters.
4. Repeat steps 1–3 until you have a set of working functions. Copy and paste working code to avoid retyping (and redebugging).
5. Look for opportunities to improve the program by refactoring. For example, if you have similar code in several places, consider factoring it into an appropriately general function.

This process has some drawbacks—we will see alternatives later—but it can be useful if you don’t know ahead of time how to divide the program into functions. This approach lets you design as you go along.
"""

# ╔═╡ 31ff7108-6981-11eb-1fb7-2ff7384538ab
md"""## Docstring

A *docstring* is a string before a function that explains the interface (“doc” is short for “documentation”). Here is an example:

```julia
\"\"\"
polyline(t, n, len, angle)

Draws n line segments with the given length and angle (in degrees) between them. t is a turtle. 
\"\"\"
function polyline(t, n, len, angle)
	for i in 1:n 
		forward(t, len)
		turn(t, -angle) 
	end
end
```

Documentation can be accessed in the REPL or in a notebook by typing `?` followed by the name of a function, and pressing Enter:

```julia
help?> polyline
search: polyline

  polyline(t, n, len, angle)

  Draws n line segments with the given length and angle (in degrees) between them. t is a turtle.
```

Docstrings are often triple-quoted strings, also known as “multiline” strings because the triple quotes allow the string to span more than one line.

A docstring contains the essential information someone would need to use the function. It explains concisely what the function does (without getting into the details of how it does it). It explains what effect each parameter has on the behavior of the function and what type each parameter should be (if it is not obvious).


!!! tip
    Writing this kind of documentation is an important part of interface design. A well-designed interface should be simple to explain; if you have a hard time explaining one of your functions, maybe the interface could be improved.
"""

# ╔═╡ d24c63c8-6981-11eb-3be3-2f258a4436c5
md"""## Debugging

An interface is like a contract between a function and a caller. The caller agrees to provide certain parameters and the function agrees to do certain work.

For example, `polyline` requires four arguments: `t` has to be a turtle; `n` has to be an integer; `len` should be a positive number; and `angle` has to be a number, which is understood to be in degrees.

These requirements are called *preconditions* because they are supposed to be true before the function starts executing. Conversely, conditions at the end of the function are *postconditions*. Postconditions include the intended effect of the function (like drawing line segments) and any side effects (like moving the turtle or making other changes).

Preconditions are the responsibility of the caller. If the caller violates a (properly documented!) precondition and the function doesn’t work correctly, the bug is in the caller, not the function.

If the preconditions are satisfied and the postconditions are not, the bug is in the function. If your pre- and postconditions are clear, they can help with debugging.
"""

# ╔═╡ 4f879090-698e-11eb-2aa6-37a98c300038
md"""## Glossary

*module*:
A collection of related functions and other definitions.

*package*:
An external library with additional functionality.

*using statement*:
A statement that reads a module file and creates a module object.

*loop*:
A part of a program that can run repeatedly.

*encapsulation*:
The process of transforming a sequence of statements into a function definition.

*generalization*:
The process of replacing something unnecessarily specific (like a number) with something appropriately general (like a variable or parameter).

*interface*:
A description of how to use a function, including the name and descriptions of the arguments and return value.

*refactoring*:
The process of modifying a working program to improve function interfaces and other qualities of the code.

*development plan*:
A process for writing programs.

*docstring*:
A string that appears at the top of a function definition to document the func‐ tion’s 

*precondition*:
A requirement that should be satisfied by the caller before a function starts.

*postcondition*:
A requirement that should be satisfied by the function before it ends.
"""

# ╔═╡ d2baf7ea-698e-11eb-1261-db00582907a3
md"## Exercises"

# ╔═╡ e3fd2546-698e-11eb-3031-c1cde742aa22
md"""#### Exercise 4-7

Enter the code in this chapter in a Pluto notebook.

1. Draw a stack diagram that shows the state of the program while executing `circle(🐢, radius)`. You can do the arithmetic by hand or add print statements to the code.

2. The version of `arc` in “Refactoring” is not very accurate because the linear approximation of the circle is always outside the true circle. As a result, the turtle ends up a few pixels away from the correct destination. The solution shown here illustrates a way to reduce the effect of this error. Read the code and see if it makes sense to you. If you draw a diagram, you might see how it works.
   
   ```julia
   \"\"\"
   arc(t, r, angle)
   
   Draws an arc with the given radius and angle:
   
       t: turtle
       r: radius
       angle: angle subtended by the arc, in degrees
   \"\"\"
   function arc(t, r, angle) 
       arc_len = 2π * r * abs(angle) / 360 
       n = trunc(arc_len / 4) + 3
       step_len = arc_len / n
       step_angle = angle / n
       
       # making a slight left turn before starting reduces
       # the error caused by the linear approximation of the arc 
       turn(t, -step_angle/2)
       polyline(t, n, step_len, step_angle)
       turn(t, step_angle/2)
   end
   ```
"""

# ╔═╡ 9beec042-698f-11eb-3808-058f5e8e3bab
md"""#### Exercise 4-8
Write an appropriately general set of functions that can draw flowers as in Figure 4-2.
"""

# ╔═╡ 6168b66a-6991-11eb-1721-37fcb97a3b8b
md"*Figure 4-2. Turtle flowers.*"

# ╔═╡ 68fa7d90-6992-11eb-06f8-01089d2b49b9
md"""#### Exercise 4-9

Write an appropriately general set of functions that can draw shapes as in Figure 4-3.
"""

# ╔═╡ c791f734-6992-11eb-2187-8b79c9ae0e61
md"*Figure 4-3. Turtle pies.*"

# ╔═╡ 9e8cecc2-6992-11eb-39e9-fd8b983a88f7
md"""#### Exercise 4-10

The letters of the alphabet can be constructed from a moderate number of basic elements, like vertical and horizontal lines and a few curves. Design an alphabet that can be drawn with a minimal number of basic elements and then write functions that draw the letters.

You should write one function for each letter, with names `draw_a`, `draw_b`, etc., and put your functions in a file named *letters.jl*.
"""

# ╔═╡ 0e943bec-6993-11eb-39d4-b3350f7b238c
md"""#### Exercise 4-11

Read about spirals at [https://en.wikipedia.org/wiki/Spiral](https://en.wikipedia.org/wiki/Spiral); then write a program that draws an Archimedean spiral as in Figure 4-4.
"""

# ╔═╡ 03c84024-6994-11eb-1619-6b1d19725997
md"*Figure 4-4. Archimedean spiral.*"

# ╔═╡ Cell order:
# ╟─2ade0260-68da-11eb-3c47-51af562ca746
# ╟─dc4299ea-68d9-11eb-273b-a597294ef196
# ╟─3dcb939c-68da-11eb-2546-85b34837f29c
# ╟─319c52f2-68dd-11eb-130c-f3672af50055
# ╟─b1f3a4cc-68de-11eb-3de9-87b14a76490e
# ╟─09d4cbb2-68df-11eb-2eec-bbe39ef9880d
# ╟─c64b81dc-68df-11eb-1086-d57b61651791
# ╟─717ad810-6975-11eb-262d-7bc4027d58b6
# ╟─81fd8b28-6976-11eb-2737-69f3b0b4624c
# ╟─dd37018e-6978-11eb-2885-29267aaac26a
# ╟─25a280d6-697b-11eb-3279-95bb0e4d8229
# ╟─c9fa13ec-697b-11eb-1a40-4b899f07dde7
# ╟─372310ae-697f-11eb-3217-f1afed271f4a
# ╟─1b946992-6980-11eb-14ee-a11b07a08c75
# ╟─090f60d4-6981-11eb-1c3d-df12052e6c4f
# ╟─31ff7108-6981-11eb-1fb7-2ff7384538ab
# ╟─d24c63c8-6981-11eb-3be3-2f258a4436c5
# ╟─4f879090-698e-11eb-2aa6-37a98c300038
# ╟─d2baf7ea-698e-11eb-1261-db00582907a3
# ╟─e3fd2546-698e-11eb-3031-c1cde742aa22
# ╟─9beec042-698f-11eb-3808-058f5e8e3bab
# ╠═02c52b84-6991-11eb-1dbd-93af9a7ca7f1
# ╟─6168b66a-6991-11eb-1721-37fcb97a3b8b
# ╟─68fa7d90-6992-11eb-06f8-01089d2b49b9
# ╟─7933043e-6992-11eb-27b6-c10f5cb6dd29
# ╟─c791f734-6992-11eb-2187-8b79c9ae0e61
# ╟─9e8cecc2-6992-11eb-39e9-fd8b983a88f7
# ╟─0e943bec-6993-11eb-39d4-b3350f7b238c
# ╟─31bc6732-6993-11eb-295e-eb9f409a95fa
# ╟─03c84024-6994-11eb-1619-6b1d19725997
