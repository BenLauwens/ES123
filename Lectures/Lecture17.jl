### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ d7cb8fd0-8ff7-11eb-3acf-c960087ff109
begin
    import Pkg
    Pkg.activate(io = IOBuffer())
	deps = [pair.second for pair in Pkg.dependencies()]
	direct_deps = filter(p -> p.is_direct_dep, deps)
    pkgs = [x.name for x in direct_deps]
	if "NativeSVG" ∉ pkgs
		Pkg.add(url="https://github.com/BenLauwens/NativeSVG.jl.git")
	end
	using NativeSVG
end

# ╔═╡ 5f32474f-524b-4865-bc72-34771deaa586
using Printf

# ╔═╡ 0bb21f1a-8ff8-11eb-3385-718fb337b749
md"""# Multiple Dispatch

In Julia you have the ability to write code that can operate on different types. This is called “generic programming.”
In this chapter I will discuss the use of type declarations in Julia, and I will introduce methods that offer ways to implement different behavior for a function depending on the types of their arguments. This is called “multiple dispatch.”
"""

# ╔═╡ 1f325d60-8ff8-11eb-1ebe-1f0a41b7149a
md"""## Type Declarations

The `::` operator attaches *type annotations* to expressions and variables, indicating what types they should have:
"""

# ╔═╡ ed6a0194-a294-4a2c-88db-89347faf2d6a
md"""This helps to confirm that your program works the way you expect.

The `::` operator can also be appended to the lefthand side of an assignment, or included as part of a declaration:
"""

# ╔═╡ df07070b-ce3d-453c-8e29-2fb6cfca7ba6
function returnfloat()
   x::Float64 = 100
   return x
end

# ╔═╡ 7c01afb0-d539-46da-836f-dc526d7d5e12
let
	x = returnfloat()
	typeof(x)
end

# ╔═╡ 7afe0cb8-b094-465f-9153-71c4cb47ef97
md"""The variable `x` is always of type `Float64` and the value is converted to a floating point if needed.

A type annotation can also be attached to the header of a function definition:
"""

# ╔═╡ 7eeaeb0c-b0eb-469f-bdc8-22300dac11ee
function sinc(x)::Float64
	if x == zero(x)
		return 1
	end
	return sin(x) / (x)
end

# ╔═╡ de941531-794f-4169-84f9-dfe045594738
md"""The return value of `sinc` is always converted to type `Float64`.

The default behavior in Julia when types are omitted is to allow values to be of any
type (`Any`).
"""

# ╔═╡ 82ea73c4-8ff8-11eb-2e25-bde15dc079ad
md"""## Methods

In “Time”, we defined a struct named `MyTime` and you wrote a function named `printtime`:

```julia
struct MyTime
	hour :: Int64
	minute :: Int64
	second :: Int64
end
```
"""

# ╔═╡ ee3dbdb5-ebde-47cf-89a9-0a5ead134e86
md"""```julia
function printtime(time)
    @printf "%0.2u:%0.2u:%0.2u" time.hour time.minute time.second
end
```

As you can see, type declarations can (and should, for performance reasons) be added to the fields in a struct definition.

To call this function, we have to pass a `MyTime` object as an argument:
"""

# ╔═╡ f6a71978-0ba2-41e2-996a-5c9339cea3ce
md"""To add a *method* to the function `printtime` that only accepts a `MyTime` object as an argument, all we have to do is append `::` followed by `MyTime` to the argument time in the function definition:

```julia
function printtime(time::MyTime)
	@printf "%0.2u:%0.2u:%0.2u" time.hour time.minute time.second
end
```

A method is a function definition with a specific signature: `printtime` has one argument of type `MyTime`.

We can now redefine the first method without the :: type annotation, allowing an argument of any type:

```julia
function printtime(time)
	println("I don't know how to print the argument time.")
end
```

If you call the function `printtime` with an object that isn’t a `MyTime` object, you now get:
"""

# ╔═╡ e8f8c957-8f42-42d8-b4ef-d416243d7e94
md"""!!! warning

    In the notebook interface all methods with the same name have to be defined in the same cell.
"""

# ╔═╡ f34a98f4-8ff8-11eb-3cd3-f170eae0c30d
md"""### Exercise 17-1

Rewrite `timetoint` and `inttotime` (from “Prototyping Versus Planning”) to specify their arguments.
"""

# ╔═╡ 0aa3ccbe-8ff9-11eb-3ac1-e343e9bb813b
md"""## Additional Examples

Here’s a version of `increment` (from “Modifiers”) rewritten to specify its arguments:
"""

# ╔═╡ a4fbb32c-c341-44e8-b50e-9e02c2ad7d0a
md"""Note that now it is a pure function, not a modifier. Here’s how you would invoke `increment`:
"""

# ╔═╡ 741d0ffb-5b26-4f28-b277-e6a96c3ef126
md"""If you put the arguments in the wrong order, you get an error:
"""

# ╔═╡ bf6fce72-d3d9-4178-bff1-ee54047e598c
md"""The signature of the method is `increment(time::MyTime, seconds::Int64)`, not `increment(seconds::Int64, time::MyTime)`.

Rewriting `isafter` to act only on `MyTime` objects is as easy:
"""

# ╔═╡ fa7b1654-ca02-4169-b0ab-db3c7af76e98
md"""By the way, optional arguments are implemented as syntax for multiple method definitions. For example, this definition:
"""

# ╔═╡ 57305fa7-06e0-46b8-a3e6-1a8bb72babd2
md"""translates to the following three methods:

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
	return MyTime(time.hour, time.minute, time.second)
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
		return new(hour, minute, second)
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
mutable struct MyTime
	hour :: Int64
	minute :: Int64
	second :: Int64
	function MyTime(hour::Int64=0, minute::Int64=0, second::Int64=0)
		@assert(0 ≤ minute < 60, "Minute is between 0 and 60.")
		@assert(0 ≤ second < 60, "Second is between 0 and 60.")
		time = new()
		time.hour = hour
		time.minute = minute
		time.second = second
		return time
	end
end
```

This allows us to construct recursive data structures—i.e., structs where one of the fields is the struct itself. In this case the struct has to be mutable because its fields are modified after instantiation.

!!! warning

    In the notebook interface a struct definition and its constructors have to be defined in the same cell.
"""

# ╔═╡ bd89e39f-d163-454a-a67d-15a6a6589781
begin
	struct MyTime
		hour :: Int64
		minute :: Int64
		second :: Int64
		function MyTime(hour::Int64=0, minute::Int64=0, second::Int64=0)
			@assert(0 ≤ minute < 60, "Minute is not between 0 and 60.")
			@assert(0 ≤ second < 60, "Second is not between 0 and 60.")
			return new(hour, minute, second)
		end
	end

	function MyTime(time::MyTime)
		MyTime(time.hour, time.minute, time.second)
	end
end;

# ╔═╡ dcaa97d5-dc6a-4d97-be00-7630a60f1b88
begin
	function printtime(time::MyTime)
	    @printf "%0.2u:%0.2u:%0.2u" time.hour time.minute time.second
	end
	
	function printtime(time)
		println("I don't know how to print the argument time.")
	end
end;

# ╔═╡ 9da87b11-86d4-4352-9cc2-826e59c23cbb
begin
	start = MyTime(9, 45, 0)
	printtime(start)
end

# ╔═╡ ab80e6dd-dbb2-42c4-a868-3d33d4dde59f
printtime(150)

# ╔═╡ cd6a8aa1-cce1-4d8a-ab75-01ce60881349
function isafter(t1::MyTime, t2::MyTime)
	return (t1.hour, t1.minute, t1.second) > (t2.hour, t2.minute, t2.second)
end

# ╔═╡ 286fca94-8ffa-11eb-1b9b-4d36482bd021
md"""## `show`

`show` is a special function that returns a string representation of an object. For example, here is a `show` method for `MyTime` objects:
"""

# ╔═╡ 5261153d-4e03-4bdd-9a7c-d0a57b8ff180
function Base.show(io::IO, time::MyTime)
	@printf io "%0.2u:%0.2u:%0.2u" time.hour time.minute time.second
end

# ╔═╡ 85cf79d4-4ecc-4e41-bfa4-f5a2e3182ab4
md"""The prefix `Base` is needed because we want to add a new method to the `Base.show` function.

When you print an object, Julia invokes the `show` function:
"""

# ╔═╡ e4542003-2226-4844-96f1-97171f477924
start

# ╔═╡ 3698e10d-a5a4-4155-b26c-97c5bad28552
md"""When I write a new composite type, I almost always start by writing an outer constructor, which makes it easier to instantiate objects, and a show method, which is useful for debugging.
"""

# ╔═╡ 6021d5b0-8ffa-11eb-053a-85008d0a7f1a
md"""### Exercise 17-2

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
	return inttotime(seconds)
end
```

The import statement adds the `+` operator to the local scope so that methods can be added.


And here is how you could use it:
"""

# ╔═╡ a798f97e-0070-4b70-850f-3f3ed99a9902
md"""When you apply the `+` operator to `MyTime` objects, Julia invokes the newly added method. When the REPL shows the result, Julia invokes show. So, there is a lot happening behind the scenes!

Adding to the behavior of an operator so that it works with programmer-defined types is called *operator overloading*.
"""

# ╔═╡ d92ea206-8ffa-11eb-1b9a-5ba6198ccb5f
md"""## Multiple Dispatch

In the previous section we added two `MyTime` objects, but you also might want to add an integer to a `MyTime` object:

```julia
function +(time::MyTime, seconds::Int64)
	return increment(time, seconds)
end
```

Here is an example that uses the `+` operator with a `MyTime` object and an integer:
"""

# ╔═╡ 708cb48d-f105-4cde-9b86-7befc8fabe93
md"""Addition is a commutative operator, so we have to add another method:

```julia
function +(seconds::Int64, time::MyTime)
	return time + seconds
end
```

And we get the same result:
"""

# ╔═╡ 047703ca-4cff-4848-8d25-4512d3d32c36
md"""The *dispatch* mechanism determines which method to execute when a function is called. Julia allows the dispatch process to choose which of a function’s methods to call based on the number of arguments given, and on the types of all of the function’s arguments. Using all of a function’s arguments to choose which method should be invoked is known as *multiple dispatch*.

!!! warning

    As always in the notebook interface, all definitions with the same name have to be specified in the same cell.
"""

# ╔═╡ fdc82f93-9ef1-4248-8bb5-734f8a211851
begin
	import Base.+

	function +(t1::MyTime, t2::MyTime)
		seconds = timetoint(t1) + timetoint(t2)
		return inttotime(seconds)
	end
	
	function +(time::MyTime, seconds::Int64)
		return increment(time, seconds)
	end
	
	function +(seconds::Int64, time::MyTime)
		return time + seconds
	end
end;

# ╔═╡ 81d242df-d28f-403b-aa86-d2be94e110cf
(1 + 2) :: Float64

# ╔═╡ d0285d92-6929-4df5-9787-082f4aa43bb5
(1 + 2) :: Int64

# ╔═╡ a9780d4f-48cc-4604-b805-374896b90eb8
begin
	function timetoint(time::MyTime)
		minutes = time.hour * 60 + time.minute
		seconds = minutes * 60 + time.second
		return seconds
	end
	
	function inttotime(seconds::Int64)
		minutes, second = divrem(seconds, 60)
		hour, minute = divrem(minutes, 60)
		return MyTime(hour, minute, second)
	end
end;

# ╔═╡ 22aa3911-8d39-456b-b518-d7efbd7a3f91
function increment(time::MyTime, seconds::Int64)
	seconds += timetoint(time)
	return inttotime(seconds)
end

# ╔═╡ 4eece27b-1179-4594-ac9a-5d073c2730a9
increment(start, 1337)

# ╔═╡ ab8217d0-ea4b-421a-b737-ef1f2ea1e730
increment(1337, start)

# ╔═╡ ecd88abe-383a-40a8-ac02-d4ee9e2342c9
function f(a=1, b=2)
	return a + 2b
end

# ╔═╡ 55e3a954-5ad9-4cb6-9b31-6f55d6f0c8d4
begin
	duration = MyTime(1, 35, 0)
	start + duration
end

# ╔═╡ 42e5d517-d1d5-4036-b7ef-c0f8d87e31e3
start + 1337

# ╔═╡ 16d6c407-12cc-4f86-be9b-d739b3708266
1337 + start

# ╔═╡ 20fdca9e-8ffb-11eb-3066-59f9a3689bf8
md"""### Exercise 17-3

Write `+` methods for Point objects:

* If both operands are `Point` objects, the method should return a new `Point` object whose `x` coordinate is the sum of the `x` coordinates of the operands, and likewise for the `y` coordinates.
* If the first or the second operand is a tuple, the method should add the first ele‐ ment of the tuple to the `x` coordinate and the second element to the `y` coordinate, and return a new `Point` object with the result.
"""

# ╔═╡ 5c319622-8ffb-11eb-1f0f-3d222d4b7408
md"""## Generic Programming

Multiple dispatch is useful when it is necessary, but (fortunately) it is not always necessary. Often you can avoid it by writing functions that work correctly for arguments with different types. This is known as *generic programming*.

Many of the functions we wrote for strings also work for other sequence types. For example, in “Dictionaries as Collections of Counters” we used `histogram` to count the number of times each letter appears in a word:
"""

# ╔═╡ 062cda1d-19ae-4bb8-8519-05f4d5f9e47b
function histogram(s)
	d = Dict()
	for c in s
		if c ∉ keys(d)
			d[c] = 1
		else
			d[c] += 1
		end
	end
	return d
end

# ╔═╡ ca9bd51c-0b14-43e5-803a-c9bb8f00a620
md"""This function also works for lists, tuples, and even dictionaries, as long as the elements of `s` are hashable so they can be used as keys in `d`:
"""

# ╔═╡ 94a3dec3-66dd-4463-8524-f49bc75c1548
let
	t = ("spam", "egg", "spam", "spam", "bacon", "spam")
	histogram(t)
end

# ╔═╡ baa06090-72f4-4817-84aa-2d0e42caea78
md"""Functions that work with several types are called *polymorphic*. Polymorphism can facilitate code reuse.

For example, the built-in function sum, which adds the elements of a sequence, works as long as the elements of the sequence support addition.

Since a `+` method is provided for `MyTime` objects, they work with `sum`:
"""

# ╔═╡ f6b444e6-84d1-4496-9df4-e6b406eed72e
begin
	t1 = MyTime(1, 7, 2)
	t2 = MyTime(1, 5, 8)
	t3 = MyTime(1, 5, 0)
	sum((t1, t2, t3))
end

# ╔═╡ 2de1e5a8-491a-4ddc-8866-9f7cd458fb50
md"""In general, if all of the operations inside a function work with a given type, the function works with that type.

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
"""

# ╔═╡ 53a6bfad-833c-4ddb-a08c-c7ff788cb54a
methods(printtime)

# ╔═╡ 86924875-59e6-4b38-b518-a3ab0432ac88
md"""In this example, the function `printtime` has two methods: one with a `MyTime` argument and one with an `Any` argument.
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

### Exercise 17-4
Change the fields of `MyTime` to be a single integer representing seconds since midnight. Then modify the methods defined in this chapter to work with the new implementation.
"""

# ╔═╡ 5ce1e624-8ffd-11eb-0ca8-63ad122f224d
md"""### Exercise 17-5

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
# ╠═81d242df-d28f-403b-aa86-d2be94e110cf
# ╠═d0285d92-6929-4df5-9787-082f4aa43bb5
# ╟─ed6a0194-a294-4a2c-88db-89347faf2d6a
# ╠═df07070b-ce3d-453c-8e29-2fb6cfca7ba6
# ╠═7c01afb0-d539-46da-836f-dc526d7d5e12
# ╟─7afe0cb8-b094-465f-9153-71c4cb47ef97
# ╠═7eeaeb0c-b0eb-469f-bdc8-22300dac11ee
# ╟─de941531-794f-4169-84f9-dfe045594738
# ╟─82ea73c4-8ff8-11eb-2e25-bde15dc079ad
# ╠═5f32474f-524b-4865-bc72-34771deaa586
# ╟─ee3dbdb5-ebde-47cf-89a9-0a5ead134e86
# ╠═9da87b11-86d4-4352-9cc2-826e59c23cbb
# ╟─f6a71978-0ba2-41e2-996a-5c9339cea3ce
# ╠═ab80e6dd-dbb2-42c4-a868-3d33d4dde59f
# ╟─e8f8c957-8f42-42d8-b4ef-d416243d7e94
# ╟─dcaa97d5-dc6a-4d97-be00-7630a60f1b88
# ╟─f34a98f4-8ff8-11eb-3cd3-f170eae0c30d
# ╟─0aa3ccbe-8ff9-11eb-3ac1-e343e9bb813b
# ╟─a9780d4f-48cc-4604-b805-374896b90eb8
# ╠═22aa3911-8d39-456b-b518-d7efbd7a3f91
# ╟─a4fbb32c-c341-44e8-b50e-9e02c2ad7d0a
# ╠═4eece27b-1179-4594-ac9a-5d073c2730a9
# ╟─741d0ffb-5b26-4f28-b277-e6a96c3ef126
# ╠═ab8217d0-ea4b-421a-b737-ef1f2ea1e730
# ╟─bf6fce72-d3d9-4178-bff1-ee54047e598c
# ╠═cd6a8aa1-cce1-4d8a-ab75-01ce60881349
# ╟─fa7b1654-ca02-4169-b0ab-db3c7af76e98
# ╠═ecd88abe-383a-40a8-ac02-d4ee9e2342c9
# ╟─57305fa7-06e0-46b8-a3e6-1a8bb72babd2
# ╟─a2e88438-8ff9-11eb-02b8-3f084a3f441d
# ╟─bd89e39f-d163-454a-a67d-15a6a6589781
# ╟─286fca94-8ffa-11eb-1b9b-4d36482bd021
# ╠═5261153d-4e03-4bdd-9a7c-d0a57b8ff180
# ╟─85cf79d4-4ecc-4e41-bfa4-f5a2e3182ab4
# ╠═e4542003-2226-4844-96f1-97171f477924
# ╟─3698e10d-a5a4-4155-b26c-97c5bad28552
# ╟─6021d5b0-8ffa-11eb-053a-85008d0a7f1a
# ╟─757c2abc-8ffa-11eb-1b8c-edb1f8938d82
# ╠═55e3a954-5ad9-4cb6-9b31-6f55d6f0c8d4
# ╟─a798f97e-0070-4b70-850f-3f3ed99a9902
# ╟─d92ea206-8ffa-11eb-1b9a-5ba6198ccb5f
# ╠═42e5d517-d1d5-4036-b7ef-c0f8d87e31e3
# ╟─708cb48d-f105-4cde-9b86-7befc8fabe93
# ╠═16d6c407-12cc-4f86-be9b-d739b3708266
# ╟─047703ca-4cff-4848-8d25-4512d3d32c36
# ╟─fdc82f93-9ef1-4248-8bb5-734f8a211851
# ╟─20fdca9e-8ffb-11eb-3066-59f9a3689bf8
# ╟─5c319622-8ffb-11eb-1f0f-3d222d4b7408
# ╠═062cda1d-19ae-4bb8-8519-05f4d5f9e47b
# ╟─ca9bd51c-0b14-43e5-803a-c9bb8f00a620
# ╠═94a3dec3-66dd-4463-8524-f49bc75c1548
# ╟─baa06090-72f4-4817-84aa-2d0e42caea78
# ╠═f6b444e6-84d1-4496-9df4-e6b406eed72e
# ╟─2de1e5a8-491a-4ddc-8866-9f7cd458fb50
# ╟─d1255e32-8ffb-11eb-336f-17da44827693
# ╟─a563a33e-8ffc-11eb-1bba-23967190b2a7
# ╠═53a6bfad-833c-4ddb-a08c-c7ff788cb54a
# ╟─86924875-59e6-4b38-b518-a3ab0432ac88
# ╟─d187fbf4-8ffc-11eb-2b76-75fa897f44e7
# ╟─2250f414-8ffd-11eb-3cd1-db7908b3544f
# ╟─5ce1e624-8ffd-11eb-0ca8-63ad122f224d
