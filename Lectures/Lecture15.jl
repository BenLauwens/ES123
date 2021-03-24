### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ cd305c42-8c85-11eb-0745-11ba4f9549f7
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ 764348e6-8c84-11eb-3487-23a16d28cc9b
md"""# Struct and Objects

At this point you know how to use functions to organize code and built-in types to organize data. The next step is to learn how to build your own types to organize both code and data. This is a big topic; it will take a few chapters to get there.
"""

# ╔═╡ dcbcdf34-8c85-11eb-178c-41b0cc73c257
md"""## Composite Types

We have used many of Julia’s built-in types; now we are going to define a new type. As an example, we will create a type called Point that represents a point in twodimensional space.

In mathematical notation, points are often written in parentheses with a comma sepa‐ rating the coordinates. For example, ``(0, 0)`` represents the origin, and ``(x, y)`` represents the point ``x`` units to the right and ``y`` units up from the origin.

There are several ways we might represent points in Julia:

• We could store the coordinates separately in two variables, `x` and `y`.
• We could store the coordinates as elements in an array or tuple.
• We could create a new type to represent points as objects.


Creating a new type is more complicated than the other options, but it has advantages that will be apparent soon.

A programmer-defined *composite type* is also called a *struct*. The `struct` definition for a point looks like this:

```julia
struct Point 
	x
	y
end
```

The header indicates that the new struct is called `Point`. The body defines the attributes or fields of the struct. The `Point` struct has two fields: `x` and `y`.


A struct is like a factory for creating objects. To create a point, you call `Point` as if it were a function having as arguments the values of the fields. When `Point` is used as a function, it is called a *constructor*:

```julia
julia> p = Point(3.0, 4.0) 
Point(3.0, 4.0)
```

The return value is a reference to a `Point` object, which we assign to `p`.


Creating a new object is called *instantiation*, and the object is an instance of the type.

When you print an instance, Julia tells you what type it belongs to and what the values of the attributes are.

Every object is an instance of some type, so “object” and “instance” are interchangea‐ ble. But in this chapter I use “instance” to indicate that I am talking about a programmer-defined type.

A state diagram that shows an object and its fields is called an *object diagram*; see Figure 15-1.
"""

# ╔═╡ 631d8fb6-8c86-11eb-3f26-333749163e46
Drawing(width=720, height=90) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=275, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("p ->") 
	end
	rect(x=325, y=30, width=130, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=335, y=20, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("Point") 
	end
	text(x=335, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("x") 
	end
	line(x1=355, y1=45, x2=395, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=415, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3.0") 
	end
	text(x=335, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("y") 
	end
	line(x1=355, y1=65, x2=395, y2=65, stroke="black", marker_end="url(#arrow)")
	text(x=415, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("4.0") 
	end
end

# ╔═╡ 42ef9f9a-8c88-11eb-1cfc-a92de41ca588
md"*Figure 15-1. Object diagram.*"

# ╔═╡ 4cd9060e-8c88-11eb-31a9-ef66b3a0364a
md"""## Structs Are Immutable

You can get the values of the fields using `.` notation:

```julia
julia> x = p.x 
3.0
julia> p.y 
4.0
```

The expression `p.x` means, “Go to the object `p` refers to and get the value of `x`.” In the example, we assign that value to a variable named `x`. There is no conflict between the variable `x` and the field `x`.

You can use dot notation as part of any expression. For example:

```julia
julia> distance = sqrt(p.x^2 + p.y^2) 
5.0
```

Structs are, however, by default immutable; after construction the fields cannot change value:

```julia
julia> p.y = 1.0
ERROR: setfield! immutable struct of type Point cannot be changed
```

This may seem odd at first, but it has several advantages:

* It can be more efficient.
* It is not possible to violate the invariants provided by the type’s constructors (see “Constructors”).
* Code using immutable objects can be easier to reason about.
"""

# ╔═╡ 9afc564c-8c88-11eb-369a-e768ee84d8da
md"""## Mutable Structs

Where required, mutable composite types can be declared with the keyword `mutable struct`. Here is the definition of a mutable point:

```julia
mutable struct MPoint 
	x
	y
end
```

You can assign values to an instance of a mutable struct using dot notation:

```julia
julia> blank = MPoint(0.0, 0.0) 
MPoint(0.0, 0.0)
julia> blank.x = 3.0
3.0
julia> blank.y = 4.0 
4.0
```
"""

# ╔═╡ bd8086c0-8c88-11eb-3960-c355a4ac636c
md"""## Rectangles

Sometimes it is obvious what the fields of an object should be, but other times you have to make decisions. For example, imagine you are designing a type to represent rectangles. What fields would you use to specify the location and size of a rectangle? You can ignore angle; to keep things simple, assume that the rectangle is either vertical or horizontal.

There are at least two possibilities:

* You could specify one corner of the rectangle (or the center), the width, and the height.
* You could specify two opposing corners.

At this point it is hard to say whether one is better than the other, so we’ll implement the first one, just as an example:

```julia
\"\"\"
Represents a rectangle.
fields: width, height, corner 
\"\"\"
struct Rectangle
	width
	height
	corner
end
```

The docstring lists the fields: `width` and `height` are numbers; corner is a `Point` object that specifies the lower-left corner.


To represent a rectangle, you have to instantiate a `Rectangle` object:

```julia
julia> origin = MPoint(0.0, 0.0) 
MPoint(0.0, 0.0)
julia> box = Rectangle(100.0, 200.0, origin) 
Rectangle(100.0, 200.0, MPoint(0.0, 0.0))
```

Figure 15-2 shows the state of this object. An object that is a field of another object is embedded. Because the corner attribute refers to a mutable object, the latter is drawn outside the `Rectangle` object.
"""

# ╔═╡ 1d636f6e-8c89-11eb-2762-9b68204ed3eb
Drawing(width=720, height=120) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=140, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("box ->") 
	end
	rect(x=200, y=30, width=200, height=70, fill="rgb(242, 242, 242)", stroke="black")
	text(x=210, y=20, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("Rectangle") 
	end
	text(x=270, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do 
		str("width") 
	end
	line(x1=280, y1=45, x2=320, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=340, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("100.0") 
	end
	text(x=270, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do 
		str("height") 
	end
	line(x1=280, y1=65, x2=320, y2=65, stroke="black", marker_end="url(#arrow)")
	text(x=340, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("200.0") 
	end
	text(x=270, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do 
		str("corner") 
	end
	line(x1=280, y1=85, x2=440, y2=85, stroke="black", marker_end="url(#arrow)")
	rect(x=450, y=60, width=130, height=50, fill="rgb(242, 242, 242)", stroke="black")
	text(x=460, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("MPoint") 
	end
	text(x=460, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("x") 
	end
	line(x1=480, y1=75, x2=520, y2=75, stroke="black", marker_end="url(#arrow)")
	text(x=540, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("0.0") 
	end
	text(x=460, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("y") 
	end
	line(x1=480, y1=95, x2=520, y2=95, stroke="black", marker_end="url(#arrow)")
	text(x=540, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("0.0") 
	end
end

# ╔═╡ 8b59f764-8c8b-11eb-0a18-fd33f5539326
md"*Figure 15-2. Object diagram.*"

# ╔═╡ 938ee1a6-8c8b-11eb-2c51-690096526be0
md"""## Instances as Arguments

You can pass an instance as an argument in the usual way. For example:

```julia
function printpoint(p) 
	println("($(p.x), $(p.y))")
end
```

`printpoint` takes a `Point` as an argument and displays it in mathematical notation. To invoke it, you can pass `p` as an argument:

```julia
julia> printpoint(blank) 
(3.0, 4.0)
```
"""

# ╔═╡ c0d707c4-8c8b-11eb-2784-7b62508b0a19
md"""#### Exercise 15-1
Write a function called `distancebetweenpoints` that takes two points as arguments and returns the distance between them.
"""

# ╔═╡ d55b88b6-8c8b-11eb-27f3-aba322cb7c63
md"""If a mutable struct object is passed to a function as an argument, the function can modify the fields of the object. For example, `movepoint!` takes a mutable `Point` object and two numbers, `dx` and `dy`, and adds the numbers to, respectively, the `x` and the ``y attribute of the `Point`:

```julia
function movepoint!(p, dx, dy) 
	p.x += dx
	p.y += dy
	nothing
end
```

Here is an example that demonstrates the effect:

```julia
julia> origin = MPoint(0.0, 0.0) 
MPoint(0.0, 0.0)
julia> movepoint!(origin, 1.0, 2.0)

julia> origin 
MPoint(1.0, 2.0)
```

Inside the function, `p` is an alias for `origin`, so when the function modifies `p`, `origin` changes.

Passing an immutable Point object to movepoint! causes an error: 

```julia
julia> movepoint!(p, 1.0, 2.0)
ERROR: setfield! immutable struct of type Point cannot be changed
```

You can, however, modify the value of a mutable attribute of an immutable object. For example, moverectangle! has as arguments a `Rectangle` object and two numbers, `dx` and `dy`, and uses `movepoint!` to move the corner of the rectangle:

```julia
function moverectangle!(rect, dx, dy) 
	movepoint!(rect.corner, dx, dy)
end
```

Now `p` in `movepoint!` is an alias for `rect.corner`, so when `p` is modified, `rect.corner` changes also:

```julia
julia> box
Rectangle(100.0, 200.0, MPoint(0.0, 0.0)) 
julia> moverectangle!(box, 1.0, 2.0)

julia> box
Rectangle(100.0, 200.0, MPoint(1.0, 2.0))
```

!!! danger
    You cannot reassign a mutable attribute of an immutable object:
    
    ```julia
    julia> box.corner = MPoint(1.0, 2.0)
    ERROR: setfield! immutable struct of type Rectangle cannot be changed
    ```
"""

# ╔═╡ 711693b6-8c8c-11eb-2d09-7b64f34fac84
md"""## Instances as Return Values

Functions can return instances. For example, `findcenter` takes a `Rectangle` as an argument and returns a `Point` that contains the coordinates of the center of the rectangle:

```julia
function findcenter(rect)
	Point(rect.corner.x + rect.width / 2, rect.corner.y + rect.height / 2)
end
```

The expression `rect.corner.x` means, “Go to the object `rect` refers to and select the field named `corner`; then go to that object and select the field named `x`.”


Here is an example that passes `box` as an argument and assigns the resulting `Point` to center:

```julia
julia> center = findcenter(box) 
Point(51.0, 102.0)
```
"""

# ╔═╡ b3197742-8c8c-11eb-146a-2594cc0932d4
md"""## Copying

Aliasing can make a program difficult to read because changes in one place might have unexpected effects in another place. It is hard to keep track of all the variables that might refer to a given object.

Copying an object is often an alternative to aliasing. Julia provides a function called `deepcopy` that performs a *deep copy* and can duplicate any object, including the contents of any embedded objects:

```julia
julia> p1 = MPoint(3.0, 4.0) 
MPoint(3.0, 4.0)
julia> p2 = deepcopy(p1) 
MPoint(3.0, 4.0)
julia> p1 ≡ p2 
false
julia> p1 == p2 
false
```

The `≡` operator indicates that `p1` and `p2` are not the same object, which is what we expected. But you might have expected `==` to yield `true` because these points contain the same data. In that case, you will be disappointed to learn that for mutable objects, the default behavior of the `==` operator is the same as the `=== operator; it checks object identity, not object equivalence (see “Objects and Values”). That’s because for mutable composite types, Julia doesn’t know what should be considered equivalent—at least, not yet.
"""

# ╔═╡ 2762ab0a-8c8d-11eb-280d-bb3cc9a654ed
md"""#### Exercise 15-2

Create a `Point` instance, make a copy of it, and check the equivalence and the egality of the two objects. The result may surprise you, but it explains why aliasing is a non-issue for an immutable object.
"""

# ╔═╡ 567d07fa-8c8d-11eb-3912-a1ae98ba7085
md"""## Debugging

When you start working with objects, you are likely to encounter some new exceptions. If you try to access a field that doesn’t exist, you get:

```julia
julia> p = Point(3.0, 4.0) 
Point(3.0, 4.0)
julia> p.z = 1.0
ERROR: type Point has no field z Stacktrace:
     [1] setproperty!(::Point, ::Symbol, ::Float64) at ./sysimg.jl:19
     [2] top-level scope at none:0
```

If you are not sure what type an object is, you can ask:

```julia
julia> typeof(p) 
Point
```

You can also use `isa` to check whether an object is an instance of a type: 

```julia
julia> p isa Point
true
```

If you are not sure whether an object has a particular attribute, you can use the built-in function `fieldnames`:

```julia
julia> fieldnames(Point) 
(:x, :y)
```

or the function `isdefined`:

```julia
julia> isdefined(p, :x) 
true
julia> isdefined(p, :z) 
false
```

The first argument can be any object; the second argument is a symbol, `:`, followed by the name of the field.
"""

# ╔═╡ ae9d5610-8c8d-11eb-1d78-2d02e842a857
md"""## Glossary

*struct*:
A user-defined type consisting of a collection of named fields. Also called a composite type.

*attribute*:
One of the named values associated with an object. Also called a field.

*constructor*:
A function with the same name as a type that creates instances of the type.

*instantiate*:
To create a new object.

*instance*:
An object that belongs to a certain type.

*object diagram*:
A diagram that shows objects, their fields, and the values of the fields.

*embedded object*:
An object that is stored as a field of another object.

*deep copy*:
To copy the contents of an object as well as any embedded objects, and any objects embedded in them, and so on; implemented by the deepcopy function.
"""

# ╔═╡ 28c26714-8c8e-11eb-2966-a9f47946b1d0
md"""## Exercises 

#### Exercise 15-3

1. Write a definition for a type named `Circle` with fields `center` and `radius`, where center is a `Point` object and `radius` is a number.
2. Instantiate a `Circle` object that represents a circle with its center at ``(150, 100)`` and radius ``75``.
3. Write a function named `pointincircle` that takes a `Circle` object and a `Point` object and returns `true` if the point lies in or on the boundary of the circle.
4. Write a function named `rectincircle` that takes a `Circle` object and a `Rectangle` object and returns `true` if the rectangle lies entirely in or on the boundary of the circle.
5. Write a function named `rectcircleoverlap` that takes a `Circle` object and a `Rectangle` object and returns `true` if any of the corners of the rectangle fall inside the circle. Or, as a more challenging version, return `true` if any part of the rectangle falls inside the circle.
"""

# ╔═╡ 8d10564a-8c8e-11eb-159f-63a1fbcb3aef
md"""#### Exercise 15-4

1. Write a function called `drawrect` that takes a `Turtle` object and a `Rectangle` object and uses the turtle to draw the rectangle. See Chapter 4 for examples using `Turtle` objects.
2. Write a function called `drawcircle` that takes a `Turtle` object and a `Circle` object and draws the circle.
"""

# ╔═╡ Cell order:
# ╟─cd305c42-8c85-11eb-0745-11ba4f9549f7
# ╟─764348e6-8c84-11eb-3487-23a16d28cc9b
# ╟─dcbcdf34-8c85-11eb-178c-41b0cc73c257
# ╟─631d8fb6-8c86-11eb-3f26-333749163e46
# ╟─42ef9f9a-8c88-11eb-1cfc-a92de41ca588
# ╟─4cd9060e-8c88-11eb-31a9-ef66b3a0364a
# ╟─9afc564c-8c88-11eb-369a-e768ee84d8da
# ╟─bd8086c0-8c88-11eb-3960-c355a4ac636c
# ╟─1d636f6e-8c89-11eb-2762-9b68204ed3eb
# ╟─8b59f764-8c8b-11eb-0a18-fd33f5539326
# ╟─938ee1a6-8c8b-11eb-2c51-690096526be0
# ╟─c0d707c4-8c8b-11eb-2784-7b62508b0a19
# ╟─d55b88b6-8c8b-11eb-27f3-aba322cb7c63
# ╟─711693b6-8c8c-11eb-2d09-7b64f34fac84
# ╟─b3197742-8c8c-11eb-146a-2594cc0932d4
# ╟─2762ab0a-8c8d-11eb-280d-bb3cc9a654ed
# ╟─567d07fa-8c8d-11eb-3912-a1ae98ba7085
# ╟─ae9d5610-8c8d-11eb-1d78-2d02e842a857
# ╟─28c26714-8c8e-11eb-2966-a9f47946b1d0
# ╟─8d10564a-8c8e-11eb-159f-63a1fbcb3aef
