### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ d7cb8fd0-8ff7-11eb-3acf-c960087ff109
begin
	import Pkg
    Pkg.activate()

    using PlutoUI
	using NativeSVG
end

# ╔═╡ 0bb21f1a-8ff8-11eb-3385-718fb337b749
md"""# Multiple Dispatch

In Julia you have the ability to write code that can operate on different types. This is called “generic programming.”
In this chapter I will discuss the use of type declarations in Julia, and I will introduce methods that offer ways to implement different behavior for a function depending on the types of their arguments. This is called “multiple dispatch.”
"""

# ╔═╡ 1f325d60-8ff8-11eb-1ebe-1f0a41b7149a
md"""## Type Declarations

The `::` operator attaches *type annotations* to expressions and variables, indicating what types they should have:

```julia
julia> (1 + 2) :: Float64
ERROR: TypeError: in typeassert, expected Float64, got Int64 
julia> (1 + 2) :: Int64
3
```

This helps to confirm that your program works the way you expect.

The `::` operator can also be appended to the lefthand side of an assignment, or included as part of a declaration:

```julia
julia> function returnfloat() 
	       x::Float64 = 100
	       x
       end
returnfloat (generic function with 1 method) 
julia> x = returnfloat()
100.0
julia> typeof(x)
Float64
```

The variable `x` is always of type `Float64` and the value is converted to a floating point if needed.

A type annotation can also be attached to the header of a function definition:

```julia
function sinc(x)::Float64 
	if x === 0
		return 1 
	end
	sin(x)/(x) 
end
```

The return value of `sinc` is always converted to type `Float64`.
The default behavior in Julia when types are omitted is to allow values to be of any
type (`Any`).
"""

# ╔═╡ 82ea73c4-8ff8-11eb-2e25-bde15dc079ad
md"""# Methods

In “Time”, we defined a struct named `MyTime` and you wrote a function named `printtime`:

```julia
using Printf

struct MyTime 
	hour :: Int64
	minute :: Int64
	second :: Int64 
end

function printtime(time)
	@printf("%02d:%02d:%02d", time.hour, time.minute, time.second)
end
```

As you can see, type declarations can (and should, for performance reasons) be added to the fields in a struct definition.

To call this function, we have to pass a `MyTime` object as an argument:

```julia
julia> start = MyTime(9, 45, 0) 
MyTime(9, 45, 0)
julia> printtime(start) 
09:45:00
```

To add a *method* to the function `printtime` that only accepts a `MyTime` object as an argument, all we have to do is append `::` followed by `MyTime` to the argument time in the function definition:

```julia
function printtime(time::MyTime)
	@printf("%02d:%02d:%02d", time.hour, time.minute, time.second)
end
```

A method is a function definition with a specific signature: `printtime` has one argument of type `MyTime`.

Calling the function `printtime` with a `MyTime` object yields the same result as before: 

```julia
julia> printtime(start)
09:45:00
```

We can now redefine the first method without the :: type annotation, allowing an argument of any type:

```julia
function printtime(time)
	println("I don't know how to print the argument time.")
end
```

If you call the function `printtime` with an object that isn’t a `MyTime` object, you now get:

```julia
julia> printtime(150)
I don't know how to print the argument time.
```
"""

# ╔═╡ f34a98f4-8ff8-11eb-3cd3-f170eae0c30d
md"""#### Exercise 17-1

Rewrite `timetoint` and `inttotime` (from “Prototyping Versus Planning”) to specify their arguments.
"""

# ╔═╡ 0aa3ccbe-8ff9-11eb-3ac1-e343e9bb813b
md"""## Additional Examples

Here’s a version of `increment` (from “Modifiers”) rewritten to specify its arguments:

```julia
function increment(time::MyTime, seconds::Int64) 
	seconds += timetoint(time) 
	inttotime(seconds)
end
```

Note that now it is a pure function, not a modifier. Here’s how you would invoke `increment`:

```julia
julia> start = MyTime(9, 45, 0) 
MyTime(9, 45, 0)
julia> increment(start, 1337) 
MyTime(10, 7, 17)
```

If you put the arguments in the wrong order, you get an error:

```julia
julia> increment(1337, start)
ERROR: MethodError: no method matching increment(::Int64, ::MyTime)
```

The signature of the method is `increment(time::MyTime, seconds::Int64)`, not `increment(seconds::Int64, time::MyTime)`.

Rewriting `isafter` to act only on `MyTime` objects is as easy:

```julia
function isafter(t1::MyTime, t2::MyTime)
	(t1.hour, t1.minute, t1.second) > (t2.hour, t2.minute, t2.second)
end
```

By the way, optional arguments are implemented as syntax for multiple method definitions. For example, this definition:

```julia
function f(a=1, b=2) 
	a + 2b
end
```

translates to the following three methods:

```julia
f(a,b) = a + 2b 
f(a) = f(a, 2) 
f() = f(1, 2)
```

These expressions are valid Julia method definitions. This is shorthand notation for defining functions/methods.
"""

# ╔═╡ a2e88438-8ff9-11eb-02b8-3f084a3f441d
md"""## Constructors

A constructor is a special function that is called to create an object. The *default constructor* methods of `MyTime`, which take all fields as parameters, have the following signatures:

```julia
MyTime(hour, minute, second)
MyTime(hour::Int64, minute::Int64, second::Int64)
```

We can also add our own *outer constructor* methods:

```julia
function MyTime(time::MyTime) 
	MyTime(time.hour, time.minute, time.second)
end
```

This method is called a *copy constructor* because the new `MyTim` object is a copy of its argument.

To enforce invariants, we need *inner constructor* methods:

```julia
struct MyTime 
	hour :: Int64
	minute :: Int64
	second :: Int64
	function MyTime(hour::Int64=0, minute::Int64=0, second::Int64=0)
		@assert(0 ≤ minute < 60, "Minute is not between 0 and 60.")
		@assert(0 ≤ second < 60, "Second is not between 0 and 60.")
		new(hour, minute, second)
	end 
end
```

The struct `MyTime` now has four inner constructor methods:

```julia
MyTime()
MyTime(hour::Int64)
MyTime(hour::Int64, minute::Int64) 
MyTime(hour::Int64, minute::Int64, second::Int64)
```

An inner constructor method is always defined inside the block of a type declaration, and it has access to a special function called new that creates objects of the newly declared type.

!!! danger
    The default constructor is not available if any inner constructor is defined. You have to write explicitly all the inner constructors you need.

A second method without arguments of the local function new exists:

```julia
struct MyTime 
	hour :: Int
	minute :: Int
	second :: Int
	function MyTime(hour::Int64=0, minute::Int64=0, second::Int64=0)
		@assert(0 ≤ minute < 60, "Minute is between 0 and 60.")
		@assert(0 ≤ second < 60, "Second is between 0 and 60.")
		time = new()
		time.hour = hour
		time.minute = minute
		time.second = second
		time
	end 
end
```

This allows us to construct recursive data structures—i.e., structs where one of the fields is the struct itself. In this case the struct has to be mutable because its fields are modified after instantiation.
"""

# ╔═╡ 286fca94-8ffa-11eb-1b9b-4d36482bd021
md"""## `show`

`show` is a special function that returns a string representation of an object. For exam‐ ple, here is a `show` method for `MyTime` objects:

```julia
using Printf

function Base.show(io::IO, time::MyTime)
	@printf(io, "%02d:%02d:%02d", time.hour, time.minute, time.second)
end
```

The prefix `Base` is needed because we want to add a new method to the `Base.show` function.

When you print an object, Julia invokes the `show` function: 

```julia
julia> time = MyTime(9, 45)
09:45:00
```

When I write a new composite type, I almost always start by writing an outer constructor, which makes it easier to instantiate objects, and a show method, which is useful for debugging.
"""

# ╔═╡ 6021d5b0-8ffa-11eb-053a-85008d0a7f1a
md"""#### Exercise 17-2

Write an outer constructor method for the `Point` class that takes `x` and `y` as optional parameters and assigns them to the corresponding fields.
"""

# ╔═╡ 757c2abc-8ffa-11eb-1b8c-edb1f8938d82
md"""## Operator Overloading

By defining operator methods, you can specify the behavior of operators on programmer-defined types. For example, if you define a method named `+` with two `MyTime` arguments, you can use the `+` operator on `MyTime` objects.

Here is what the definition might look like:

```julia
import Base.+

function +(t1::MyTime, t2::MyTime)
	seconds = timetoint(t1) + timetoint(t2) 
	inttotime(seconds)
end
```

The import statement adds the `+` operator to the local scope so that methods can be added.


And here is how you could use it:

```julia
julia> start = MyTime(9, 45) 
09:45:00
julia> duration = MyTime(1, 35, 0) 
01:35:00
julia> start + duration 
11:20:00
```

When you apply the `+` operator to `MyTime` objects, Julia invokes the newly added method. When the REPL shows the result, Julia invokes show. So, there is a lot happening behind the scenes!

Adding to the behavior of an operator so that it works with programmer-defined types is called *operator overloading*.
"""

# ╔═╡ d92ea206-8ffa-11eb-1b9a-5ba6198ccb5f
md"""## Multiple Dispatch

In the previous section we added two `MyTime` objects, but you also might want to add an integer to a `MyTime` object:

```julia
function +(time::MyTime, seconds::Int64) 
	increment(time, seconds)
end
```

Here is an example that uses the `+` operator with a `MyTime` object and an integer:

```julia
julia> start = MyTime(9, 45) 
09:45:00
julia> start + 1337 
10:07:17
```

Addition is a commutative operator, so we have to add another method:

```julia
function +(seconds::Int64, time::MyTime) 
	time + seconds
end
```

And we get the same result:

```julia
julia> 1337 + start 
10:07:17
```

The *dispatch* mechanism determines which method to execute when a function is called. Julia allows the dispatch process to choose which of a function’s methods to call based on the number of arguments given, and on the types of all of the function’s arguments. Using all of a function’s arguments to choose which method should be invoked is known as *multiple dispatch*.
"""

# ╔═╡ 20fdca9e-8ffb-11eb-3066-59f9a3689bf8
md"""#### Exercise 17-3

Write `+` methods for Point objects:

* If both operands are `Point` objects, the method should return a new `Point` object whose `x` coordinate is the sum of the `x` coordinates of the operands, and likewise for the `y` coordinates.
* If the first or the second operand is a tuple, the method should add the first ele‐ ment of the tuple to the `x` coordinate and the second element to the `y` coordinate, and return a new `Point` object with the result.
"""

# ╔═╡ 5c319622-8ffb-11eb-1f0f-3d222d4b7408
md"""## Generic Programming

Multiple dispatch is useful when it is necessary, but (fortunately) it is not always necessary. Often you can avoid it by writing functions that work correctly for arguments with different types. This is known as *generic programming*.

Many of the functions we wrote for strings also work for other sequence types. For example, in “Dictionaries as Collections of Counters” we used `histogram` to count the number of times each letter appears in a word:

```julia
function histogram(s) 
	d = Dict()
	for c in s
		if c ∉ keys(d)
			d[c] = 1 
		else
			d[c] += 1 
		end
	end
	d
end
```

This function also works for lists, tuples, and even dictionaries, as long as the elements of `s` are hashable so they can be used as keys in `d`:

```julia
julia> t = ("spam", "egg", "spam", "spam", "bacon", "spam") 
("spam", "egg", "spam", "spam", "bacon", "spam")
julia> histogram(t)
Dict{Any,Any} with 3 entries:
  "bacon" => 1
  "spam"  => 4
  "egg"   => 1
```

Functions that work with several types are called *polymorphic*. Polymorphism can facilitate code reuse.

For example, the built-in function sum, which adds the elements of a sequence, works as long as the elements of the sequence support addition.

Since a `+` method is provided for `MyTime` objects, they work with `sum`:

```julia
julia> t1 = MyTime(1, 7, 2) 
01:07:02
julia> t2 = MyTime(1, 5, 8) 
01:05:08
julia> t3 = MyTime(1, 5, 0) 
01:05:00
julia> sum((t1, t2, t3)) 
03:17:10
```

In general, if all of the operations inside a function work with a given type, the function works with that type.

The best kind of polymorphism is the unintentional kind, where you discover that a function you already wrote can be applied to a type you never planned for.
"""

# ╔═╡ d1255e32-8ffb-11eb-336f-17da44827693
md"""## Interface and Implementation

One of the goals of multiple dispatch is to make software more maintainable, which means that you can keep the program working when other parts of the system change, and modify the program to meet new requirements.

A design principle that helps achieve that goal is to keep interfaces separate from implementations. This means that the methods having an argument annotated with a type should not depend on how the fields of that type are represented.

For example, in this chapter we developed a struct that represents a time of day. Methods having an argument annotated with this type include `timetoint`, `isafter`, and `+`.

We could implement those methods in several ways. The details of the implementation depend on how we represent `MyTime`. In this chapter, the fields of a `MyTime` object are `hour`, `minute`, and `second`.

As an alternative, we could replace these fields with a single integer representing the number of seconds since midnight. This implementation would make some functions, like `isafter`, easier to write, but other functions harder.

After you deploy a new type, you might discover a better implementation. If other parts of the program are using your type, it might be time-consuming and errorprone to change the interface.

But if you designed the interface carefully, you can change the implementation without changing the interface, which means that other parts of the program don’t have to change.
"""

# ╔═╡ a563a33e-8ffc-11eb-1bba-23967190b2a7
md"""## Debugging

Calling a function with the correct arguments can be difficult when more than one method for the function is specified. To help with this, Julia allows us to introspect the signatures of the methods of a function.

To know what methods are available for a given function, you can use the function `methods`:

```julia
julia> methods(printtime)
# 2 methods for generic function "printtime": 
[1] printtime(time::MyTime) in Main at REPL[3]:2 
[2] printtime(time) in Main at REPL[4]:2
```

In this example, the function `printtime` has two methods: one with a `MyTime` argument and one with an `Any` argument.
"""

# ╔═╡ d187fbf4-8ffc-11eb-2b76-75fa897f44e7
md"""## Glossary

*type annotation*:
The operator `::` followed by a type, indicating that an expression or a variable is of that type.

*method*:
A definition of a possible behavior for a function.

*signature*:
The number and type of the arguments of a method, allowing the dispatch to select the most specific method of a function during the function call.

*constructor*:
A special function called to create an object.

*default constructor*:
An inner constructor that is available when no programmer-defined inner constructors are provided.

*outer constructor*:
A constructor defined outside the type definition to define convenience methods for creating an object.

*copy constructor*:
An outer constructor method of a type with as its only argument an object of the type. It creates a new object that is a copy of the argument.

*inner constructor*:
A constructor defined inside the type definition to enforce invariants or to construct self-referential objects.

*operator overloading*:
Adding to the behavior of an operator like + so it works with a programmer-defined type.

*dispatch*:
The choice of which method to execute when a function is executed.

*multiple dispatch*:
Dispatch based on all of a function’s arguments.

*generic programming*:
Writing code that can work with more than one type.

*polymorphic function*:
A function whose argument(s) can be of several types.
"""

# ╔═╡ 2250f414-8ffd-11eb-3cd1-db7908b3544f
md"""## Exercises 

#### Exercise 17-4
Change the fields of `MyTime` to be a single integer representing seconds since midnight. Then modify the methods defined in this chapter to work with the new implementation.
"""

# ╔═╡ 5ce1e624-8ffd-11eb-0ca8-63ad122f224d
md"""#### Exercise 17-5

Write a definition for a type named `Kangaroo` with a field named `pouchcontents` of type `Array` and the following methods:

* A constructor that initializes `pouchcontents` to an empty array
* A method named `putinpouch` that takes a `Kangaroo` object and an object of any
type and adds it to `pouchcontents`
* A `show` method that returns a string representation of the `Kangaroo` object and
the contents of the pouch

Test your code by creating two `Kangaroo` objects, assigning them to variables named `kanga` and `roo`, and then adding `roo` to the contents of `kanga`’s pouch.
"""

# ╔═╡ Cell order:
# ╟─d7cb8fd0-8ff7-11eb-3acf-c960087ff109
# ╟─0bb21f1a-8ff8-11eb-3385-718fb337b749
# ╟─1f325d60-8ff8-11eb-1ebe-1f0a41b7149a
# ╟─82ea73c4-8ff8-11eb-2e25-bde15dc079ad
# ╟─f34a98f4-8ff8-11eb-3cd3-f170eae0c30d
# ╟─0aa3ccbe-8ff9-11eb-3ac1-e343e9bb813b
# ╟─a2e88438-8ff9-11eb-02b8-3f084a3f441d
# ╟─286fca94-8ffa-11eb-1b9b-4d36482bd021
# ╟─6021d5b0-8ffa-11eb-053a-85008d0a7f1a
# ╟─757c2abc-8ffa-11eb-1b8c-edb1f8938d82
# ╟─d92ea206-8ffa-11eb-1b9a-5ba6198ccb5f
# ╟─20fdca9e-8ffb-11eb-3066-59f9a3689bf8
# ╟─5c319622-8ffb-11eb-1f0f-3d222d4b7408
# ╟─d1255e32-8ffb-11eb-336f-17da44827693
# ╟─a563a33e-8ffc-11eb-1bba-23967190b2a7
# ╟─d187fbf4-8ffc-11eb-2b76-75fa897f44e7
# ╟─2250f414-8ffd-11eb-3cd1-db7908b3544f
# ╟─5ce1e624-8ffd-11eb-0ca8-63ad122f224d
