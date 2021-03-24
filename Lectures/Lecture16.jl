### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 20dc3b14-8cdf-11eb-1398-310106abe33b
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ fc9cf982-8cde-11eb-04af-f9bf7f6b865d
md"""# Structs and Functions

Now that we know how to create new composite types, the next step is to write func‐ tions that take programmer-defined objects as parameters and return them as results. In this chapter I also present the “functional programming style” and two new program development plans.
"""

# ╔═╡ 341333b8-8cdf-11eb-37a3-35135729c9ac
md"""## Time

As another example of a composite type, we’ll define a struct called MyTime that records the time of day. The struct definition looks like this:

```julia
\"\"\"
Represents the time of day.
fields: hour, minute, second 
\"\"\"
struct MyTime
	hour
	minute
	second
end
```

The name `Time` is already used in Julia, so I’ve chosen this name to avoid a name clash. We can create a new `MyTime` object as follows:

```julia
julia> time = MyTime(11, 59, 30) 
MyTime(11, 59, 30)
```

The object diagram for the `MyTime` object looks like Figure 16-1.
"""

# ╔═╡ 6b6345ec-8cdf-11eb-24f0-0f0996d2f81b
Drawing(width=720, height=120) do
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
	end
	text(x=230, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("time ->") 
	end
	rect(x=290, y=30, width=200, height=70, fill="rgb(242, 242, 242)", stroke="black")
	text(x=300, y=20, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("MyTime") 
	end
	text(x=360, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do 
		str("hour") 
	end
	line(x1=370, y1=45, x2=410, y2=45, stroke="black", marker_end="url(#arrow)")
	text(x=430, y=50, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("11") 
	end
	text(x=360, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do 
		str("minute") 
	end
	line(x1=370, y1=65, x2=410, y2=65, stroke="black", marker_end="url(#arrow)")
	text(x=430, y=70, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("59") 
	end
	text(x=360, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600, text_anchor="end") do 
		str("second") 
	end
	line(x1=370, y1=85, x2=410, y2=85, stroke="black", marker_end="url(#arrow)")
	text(x=430, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("30") 
	end
end

# ╔═╡ 5544f0ac-8ce0-11eb-19b2-6150e4833112
md"*Figure 16-1. Object diagram.*"

# ╔═╡ 5b1d092c-8ce0-11eb-24e1-3f46146d7671
md"""#### Exercise 16-1

Write a function called `printtime` that takes a `MyTime` object and prints it in the form `hour:minute:second`. The `@printf` macro of the standard library module `Printf` prints an integer with the format sequence `"%02d"` using at least two digits, including a leading zero if necessary.

"""

# ╔═╡ 7c4db8b4-8ce0-11eb-0c61-e1720a80093f
md"""#### Exercise 16-2

Write a Boolean function called isafter that takes two `MyTime` objects, `t1` and `t2`, and returns `true` if `t1` follows `t2` chronologically and `false` otherwise. Challenge: don’t use an `if` statement.
"""

# ╔═╡ 9e07ce7a-8ce0-11eb-0d2c-614b707d5a30
md"""## Pure Functions

In the next few sections, we’ll write two functions that add time values. They demonstrate two kinds of functions: pure functions and modifiers. They also demonstrate a development plan I’ll call *prototype and patch*, which is a way of tackling a complex problem by starting with a simple prototype and incrementally dealing with the complications.

Here is a simple prototype of `addtime`:

```julia
function addtime(t1, t2)
	MyTime(t1.hour + t2.hour, t1.minute + t2.minute, t1.second + t2.second)
end
```

The function creates a new `MyTime` object, initializes its fields, and returns a reference to the new object. This is called a *pure function* because it does not modify any of the objects passed to it as arguments and it has no effect, like displaying a value or getting user input, other than returning a value.

To test this function, I’ll create two `MyTime` objects: start contains the start time of a movie, like *Monty Python and the Holy Grail*, and duration contains the running time of the movie, which in this case is 1 hour 35 minutes.

`addtime` figures out when the movie will be done:

```julia
julia> start = MyTime(9, 45, 0);

julia> duration = MyTime(1, 35, 0);

julia> done = addtime(start, duration);

julia> printtime(done)
10:80:00
```

The result, `10:80:00`, might not be what you were hoping for. The problem is that this function does not deal with cases where the number of seconds or minutes adds up to more than 60. When that happens, we have to “carry” the extra seconds into the minute column or the extra minutes into the hour column. Here’s an improved version:

```julia
function addtime(t1, t2)
	second = t1.second + t2.second 
	minute = t1.minute + t2.minute 
	hour = t1.hour + t2.hour
	if second >= 60
		second -= 60
		minute += 1 
	end
	if minute >= 60 
		minute -= 60
		hour += 1 
	end
	MyTime(hour, minute, second) 
end
```

Although this function is correct, it is starting to get big. We will see a shorter alternative later.
"""

# ╔═╡ 1a8c7798-8ce1-11eb-1b70-03289e5e2180
md"""## Modifiers

Sometimes it is useful for a function to modify the objects it gets as parameters. In that case, the changes are visible to the caller. Functions that work this way are called *modifiers*.

`increment!`, which adds a given number of seconds to a mutable `MyTime` object, can be written naturally as a modifier. Here is a rough draft:

```julia
function increment!(time, seconds) 
	time.second += seconds
	if time.second >= 60
		time.second -= 60
		time.minute += 1 
	end
	if time.minute >= 60 
		time.minute -= 60 
		time.hour += 1
	end 
end
```

The first line performs the basic operation; the remainder deals with the special cases we saw before.

Is this function correct? What happens if `seconds` is much greater than 60?


In that case, it is not enough to carry once; we have to keep doing it until `time.second` is less than 60. One solution is to replace the `if` statements with `while` statements. That would make the function correct, but not very efficient.
"""

# ╔═╡ 6b612e5e-8ce1-11eb-3f34-27e6a4589cd4
md"""#### Exercise 16-3

Write a correct version of `increment!` that doesn’t contain any loops.
"""

# ╔═╡ 82dc6d14-8ce1-11eb-3cdb-ab242222a29e
md"""Anything that can be done with modifiers can also be done with pure functions. In fact, some programming languages only allow pure functions. There is some evidence that programs that use pure functions are faster to develop and less error-prone than programs that use modifiers. But modifiers are convenient at times, and functional programs tend to be less efficient.

In general, I recommend that you write pure functions whenever it is reasonable and resort to modifiers only if there is a compelling advantage. This approach might be called a functional programming style.
"""

# ╔═╡ 8da363d8-8ce1-11eb-3953-011e42efaf71
md"""#### Exercise 16-4

Write a “pure” version, `increment`, that creates and returns a new `MyTime` object rather than modifying the parameter.
"""

# ╔═╡ 9ca5d4a6-8ce1-11eb-22d2-093575ac8faa
md"""## Prototyping Versus Planning

Recall that the development plan I am demonstrating here is called “prototype and patch.” For each function, I wrote a prototype that performed the basic calculation and then tested it, patching errors along the way.

This approach can be effective, especially if you don’t yet have a deep understanding of the problem. But incremental corrections can generate code that is unnecessarily complicated, since it deals with many special cases, and unreliable, since it is hard to know if you have found all the errors.

An alternative is *designed development*, in which high-level insight into the problem can make the programming much easier. In this case, the insight is that a `Time` object is really a 3-digit number in base 60. The second attribute is the “ones column,” the minute attribute is the “sixties column,” and the hour attribute is the “thirty-six hundreds column.”

When we wrote `addtime` and `increment!`, we were effectively doing addition in base 60, which is why we had to carry from one column to the next.


This observation suggests another approach to the whole problem—we can convert `MyTime` objects to integers and take advantage of the fact that the computer knows how to do integer arithmetic.

Here is a function that converts `MyTimes` to integers:

```julia
function timetoint(time)
	minutes = time.hour * 60 + time.minute 
	seconds = minutes * 60 + time.second
end
```

And here is a function that converts an integer to a `MyTime` (recall that `divrem` divides the first argument by the second and returns the quotient and remainder as a tuple):

```julia
function inttotime(seconds)
	minutes, second = divrem(seconds, 60) 
	hour, minute = divrem(minutes, 60) 
	MyTime(hour, minute, second)
end
```

You might have to think a bit, and run some tests, to convince yourself that these functions are correct. One way to test them is to check, for many values of `x`, that `timetoint(inttotime(x)) == x`. This is an example of a consistency check (see “Debugging”).

Once you are convinced they are correct, you can use them to rewrite `addtime`:

```julia
function addtime(t1, t2)
	seconds = timetoint(t1) + timetoint(t2) 
	inttotime(seconds)
end
```

This version is shorter than the original, and easier to verify.
"""

# ╔═╡ 5eecdd5c-8ce2-11eb-3a3d-598fd1fcab25
md"""#### Exercise 16-5

Rewrite `increment!` using `timetoint` and `inttotime`.
"""

# ╔═╡ 7802d76a-8ce2-11eb-0a88-fbb7edbef1ab
md"""In some ways, converting from base 60 to base 10 and back is harder than just dealing with times. Base conversion is more abstract; our intuition for dealing with time values is better.

But if we have the insight to treat times as base 60 numbers and make the investment of writing the conversion functions (`timetoint` and `inttotime`), we get a program that is shorter, easier to read and debug, and more reliable.

It is also easier to add features later. For example, imagine subtracting two `MyTimes` to find the duration between them. The naive approach would be to implement subtraction with borrowing. Using the conversion functions would be easier and more likely to be correct.

Ironically, sometimes making a problem harder (or more general) makes it easier (because there are fewer special cases and fewer opportunities for error).
"""

# ╔═╡ a42731b0-8ce2-11eb-3387-f7f5ff826896
md"""## Debugging

A `MyTime` object is well-formed if the values of minute and second are between `0` and `60` (including `0` but not `60`) and if `hour` is positive. `hour` and `minute` should be integral values, but we might allow second to have a fraction part.

Requirements like these are called *invariants* because they should always be true. To put it a different way, if they are not true, something has gone wrong.

Writing code to check invariants can help detect errors and find their causes. For example, you might have a function like `isvalidtime` that takes a `MyTime` object and returns `false` if it violates an invariant:

```julia
function isvalidtime(time)
	if time.hour < 0 || time.minute < 0 || time.second < 0
		return false
	end
	if time.minute >= 60 || time.second >= 60 
		return false
	end
	true 
end
```

At the beginning of each function you could check the arguments to make sure they are valid:

```julia
function addtime(t1, t2)
	if !isvalidtime(t1) || !isvalidtime(t2)
		error("invalid MyTime object in add_time") 
	end
	seconds = timetoint(t1) + timetoint(t2)
	inttotime(seconds) 
end
```

Or you could use an `@assert` macro, which checks a given invariant and throws an exception if it fails:

```julia
function addtime(t1, t2)
	@assert(isvalidtime(t1) && isvalidtime(t2), "invalid MyTime object in
    add_time")
	seconds = timetoint(t1) + timetoint(t2)
	inttotime(seconds)
end
```

`@assert` macros are useful because they distinguish code that deals with normal con‐ ditions from code that checks for errors.
"""

# ╔═╡ 2091cdf0-8ce3-11eb-1bfd-bfb9410a4011
md"""## Glossary

*prototype and patch*:
A development plan that involves writing a rough draft of a program, testing, and correcting errors as they are found.

*pure function*:
A function that does not modify any of the objects it receives as arguments. Most pure functions are fruitful.

*modifier*:
A function that changes one or more of the objects it receives as arguments. Most modifiers are void; that is, they return nothing.

*functional programming style*:
A style of program design in which the majority of functions are pure.

*designed development*:
A development plan that involves high-level insight into the problem and more planning than incremental development or prototype development.

*invariant*:
A condition that should never change during the execution of a program.
"""

# ╔═╡ 3a76ce46-8ce3-11eb-0dc8-574754990923
md"""## Exercises 

#### Exercise 16-6

Write a function called `multime` that takes a `MyTime` object and a number and returns a new `MyTime` object that contains the product of the original `MyTime` and the number.

Then use `multime` to write a function that takes a `MyTime` object that represents the finishing time in a race and a number that represents the distance, and returns a `MyTime` object that represents the average pace (time per mile).
"""

# ╔═╡ 62f55dd0-8ce3-11eb-399f-0168ee2e79b8
md"""#### Exercise 16-7

Julia provides `Time` objects that are similar to the `MyTime` objects in this chapter, but they provide a rich set of functions and operators.

1. Write a program that gets the current date and prints the day of the week.
2. Write a program that takes a birthday as input and prints the user’s age and the number of days, hours, minutes, and seconds until her next birthday.
3. For two people born on different days, there is a day when one is twice as old as the other. That’s their Double Day. Write a program that takes two birthdays and computes their Double Day.
4. For a little more challenge, write the more general version that computes the day when one person is n times older than the other.
"""

# ╔═╡ Cell order:
# ╟─20dc3b14-8cdf-11eb-1398-310106abe33b
# ╟─fc9cf982-8cde-11eb-04af-f9bf7f6b865d
# ╟─341333b8-8cdf-11eb-37a3-35135729c9ac
# ╟─6b6345ec-8cdf-11eb-24f0-0f0996d2f81b
# ╠═5544f0ac-8ce0-11eb-19b2-6150e4833112
# ╟─5b1d092c-8ce0-11eb-24e1-3f46146d7671
# ╟─7c4db8b4-8ce0-11eb-0c61-e1720a80093f
# ╟─9e07ce7a-8ce0-11eb-0d2c-614b707d5a30
# ╟─1a8c7798-8ce1-11eb-1b70-03289e5e2180
# ╟─6b612e5e-8ce1-11eb-3f34-27e6a4589cd4
# ╟─82dc6d14-8ce1-11eb-3cdb-ab242222a29e
# ╟─8da363d8-8ce1-11eb-3953-011e42efaf71
# ╟─9ca5d4a6-8ce1-11eb-22d2-093575ac8faa
# ╟─5eecdd5c-8ce2-11eb-3a3d-598fd1fcab25
# ╟─7802d76a-8ce2-11eb-0a88-fbb7edbef1ab
# ╟─a42731b0-8ce2-11eb-3387-f7f5ff826896
# ╟─2091cdf0-8ce3-11eb-1bfd-bfb9410a4011
# ╟─3a76ce46-8ce3-11eb-0dc8-574754990923
# ╟─62f55dd0-8ce3-11eb-399f-0168ee2e79b8
