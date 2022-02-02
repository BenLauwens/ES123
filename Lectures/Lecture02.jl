### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 62f36be0-64cf-11eb-0b86-9d4b55165cbf
begin
	using PlutoUI
	using NativeSVG
end

# ╔═╡ 46a00ea0-64cd-11eb-3e3f-b7cfa00d69ce
md"""# Variables, Expressions, and Statements

One of the most powerful features of a programming language is the ability to manipulate *variables*. A variable is a name that refers to a value."""

# ╔═╡ 63956320-64cd-11eb-30d5-b1f23c40108f
md"""## Assignment Statements

An assignment statement creates a new variable and gives it a value:

```julia
julia> message = "And now for something completely different"
"And now for something completely different"
julia> n = 17
17
julia> π_val = 3.141592653589793
3.141592653589793
```

This example makes three assignments. The first assigns a string to a new variable named `message`, the second assigns the integer `17` to `n`, and the third assigns the
(approximate) value of π to `π_val` (**`\pi TAB`**).

A common way to represent variables on paper is to write the name of each with an arrow pointing to its value. This kind of figure is called a *state diagram* because it shows what state each of the variables is in (think of it as the variable’s state of mind). Figure 2-1 shows the result of the previous example.
"""

# ╔═╡ 58ba9f20-64d1-11eb-30e7-71ec2290f593
Drawing(width=720, height=110) do
    rect(x=110, y=10, width=500, height=90, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=30, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("message") 
	end
	text(x=190, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=220, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"And now for something completely different\"") 
	end
	text(x=180, y=60, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("n") 
	end
	text(x=190, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=220, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("17") 
	end
	text(x=180, y=90, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do 
		str("π_val") 
	end
	text(x=190, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("->") 
	end
	text(x=220, y=90, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("3.141592653589793") 
	end
end

# ╔═╡ 7f908a10-64d6-11eb-1629-9179dc49bad7
md"""
*Figure 2-1. State diagram.*
"""

# ╔═╡ 5cb86662-64e1-11eb-0c04-41643ac1fc94
md"""
!!! languages
    Both the C programming language and Python use also the symbol `=` as assignment operator.

    In the C Programming Language, you have to specify the type as a *declaration* before the name of the variable:
    ```c
    char[] message = "And now for something completely different";
    int n = 17;
    double pi = 3.141592653589793;
    ```
    or you can separate declaration from assignment:
    ```c
    int n;
    n = 17;
    ```

    Python:
    ```python
    >>> message = 'And now for something completely different'
    >>> n = 17
    >>> pi = 3.141592653589793
    ```
"""

# ╔═╡ 60d71100-64ce-11eb-2a71-dd40eded5474
md"""## Variable Names

Programmers generally choose names for their variables that are meaningful—they document what the variable is used for.

Variable names can be as long as you like. They can contain almost all Unicode characters (see [“Characters”]()), but they can’t begin with a number. It is legal to use uppercase letters, but it is conventional to use only lowercase for variable names.

Unicode characters can be entered via tab completion of LaTeX-like abbreviations in
the Julia REPL.

The underscore character, `_`, can appear in a name. It is often used in names with multiple words, such as `your_name` or `airspeed_of_unladen_swallow`.

If you give a variable an illegal name, you get a syntax error:

```julia
julia> 76trombones = "big parade"
ERROR: syntax: "76" is not a valid function argument name
julia> more@ = 1000000
ERROR: syntax: extra token "@" after end of expression
julia> struct = "Advanced Theoretical Zymurgy"
ERROR: syntax: unexpected "="
```

`76trombones` is illegal because it begins with a number. `more@` is illegal because it contains an illegal character, `@`. But what’s wrong with `struct`?

It turns out that `struct` is one of Julia’s keywords. The REPL uses *keywords* to recognize the structure of the program, and they cannot be used as variable names.

Julia has these keywords:

```
abstract  type      baremodule  begin       break      catch
const     continue  do          else        elseif     end 
export    finally   for         false       function   global 
if        import    in          let         local      macro 
module    mutable   primitive   type        quote      return
true      try       using       struct      where      while
```

You don’t have to memorize this list. In most development environments, keywords are displayed in a different color; if you try to use one as a variable name, you’ll know."""

# ╔═╡ 14697060-64d8-11eb-105d-d39759df9d42
md"""## Expressions and Statements
An *expression* is a combination of values, variables, and operators. A value all by itself is considered an expression, and so is a variable, so the following are all legal expressions:

```julia
julia> 42
42
julia> n
17
julia> n + 25
42
```

When you type an expression at the prompt, the REPL *evaluates* it, which means that it finds the value of the expression. In this example, `n` has the value `17` and `n + 25` has the value `42`.

A *statement* is a unit of code that has an effect, like creating a variable or displaying a value:

```julia
julia> n = 17
17
julia> println(n)
17
```

The first line here is an assignment statement that gives a value to `n`. The second line is a print statement that displays the value of `n`.

When you type a statement, the REPL *executes* it, which means that it does whatever
the statement says.
"""

# ╔═╡ 567fc950-64dc-11eb-22e2-df958738bfff
md"""## Script Mode

So far we have run Julia in *interactive mode*, which means that you interact directly with the REPL. Interactive mode is a good way to get started, but if you are working with more than a few lines of code, it can be clumsy.

The alternative is to save code in a file called a *script* and then run Julia in *script mode* to execute the script. By convention, Julia scripts have names that end with *.jl*.

If you know how to create and run a script on your computer, you are ready to go. Otherwise I recommend installing Visual Studio Code. Open a text file, write the script, and save the file with a *.jl* extension. The script can be executed in a terminal with the command **`julia name_of_the_script.jl`**.

Because Julia provides both modes, you can test bits of code in interactive mode before you put them in a script. But there are differences between interactive mode and script mode that can be confusing.

For example, if you are using Julia as a calculator, you might type:

```julia
julia> miles = 26.2
26.2
julia> miles * 1.61
42.182
```

The first line assigns a value to `miles` and displays the value. The second line is an expression, so the REPL evaluates it and displays the result. It turns out that a mara thon is about 42 kilometers.

But if you type the same code into a script and run it, you get no output at all. In script mode an expression, all by itself, has no visible effect. Julia actually evaluates the expression, but it doesn’t display the value unless you tell it to:

```julia
miles = 26.2
println(miles * 1.61)
```

This behavior can be confusing at first.

A script usually contains a sequence of statements. If there is more than one statement, the results appear one at a time as the statements execute.

For example, the script:

```julia
println(1)
x = 2
println(x)
```

produces the output:

```
1
2
```

The assignment statement produces no output.
"""

# ╔═╡ ff42a18e-64e4-11eb-0d79-b139fff2bcfd
md"""
!!! languages
    The C programming language has no script mode. All statements have to be in a file:
    ```c
    #include <stdio.h>

    int main(void)
    {
        printf("%i\n", 1);
        int x = 2;
        printf("%i\n", x);
    }
    ```
"""

# ╔═╡ 9f56ada0-64dd-11eb-2689-89413775adb1
md"""#### Exercise 2-1

To check your understanding, type the following statements in the Julia REPL and see
what they do:

```julia
5
x = 5
x + 1
```

Now put the same statements in a script and run it. What is the output? Modify the script by transforming each expression into a print statement and then run it again.
"""

# ╔═╡ c95baab0-64dd-11eb-00c7-af9957ec1614
md"""## Operator Precedence

When an expression contains more than one operator, the order of evaluation depends on the *operator precedence*. For mathematical operators, Julia follows mathematical convention. The acronym *PEMDAS* is a useful way to remember the rules:

* *P*arentheses have the highest precedence and can be used to force an expression
to evaluate in the order you want. Since expressions in parentheses are evaluated
first, `2*(3-1)` is `4`, and `(1+1)^(5-2)` is `8`. You can also use parentheses to make an expression easier to read, as in `(minute * 100) / 60`, even if it doesn’t change the result.
* *E*xponentiation has the next highest precedence, so `1+2^3` is `9`, not `27`, and `2*3^2` is `18`, not `36`.
* *M*ultiplication and *D*ivision have higher precedence than *A*ddition and *S*ubtraction. So, `2*3-1` is `5`, not `4`, and `6+4/2` is `8`, not `5`.
* Operators with the same precedence are evaluated from left to right (except exponentiation). So in the expression `degrees / 2 * π`, the division happens first and the result is multiplied by π. To divide by 2π, you can use parentheses, or write `degrees / 2 / π` or `degrees / 2π`.

!!! tip
    I don’t work very hard to remember the precedence of operators. If I can’t tell by looking at the expression, I use parentheses to make it obvious.
"""

# ╔═╡ d619bb60-64de-11eb-3d7b-572676f08d00
md"""## String Operations

In general, you can’t perform mathematical operations on strings, even if the strings look like numbers, so the following are illegal:

```julia
"2" - "1" 
"eggs" / "easy" 
"third" + "a charm"
```

But there are two exceptions, `*` and `^`.

The `*` operator performs *string concatenation*, which means it joins the strings by linking them end-to-end. For example:

```julia
julia> first_str = "throat"
"throat"
julia> second_str = "warbler"
"warbler"
julia> first_str * second_str
"throatwarbler"
```

The `^` operator also works on strings; it performs repetition. For example, `"Spam"^3` is `"SpamSpamSpam"`. If one of the values is a string, the other has to be an integer.

This use of `*` and `^` makes sense by analogy with multiplication and exponentiation.
Just as ``4^3`` is equivalent to ``4\cdot4\cdot4``, we expect `"Spam"^3` to be the same as `"Spam"*"Spam"*"Spam"`, and it is.
"""

# ╔═╡ 0579eaa0-64e0-11eb-3fba-211e3857675f
md"""
!!! languages
    Python uses the `+` and the `*` operator to perform string concatenation and repetition:

    ```python
    >>> first_str = 'throat'
    >>> second_str = 'warbler'
    >>> first_str + second_str
    'throatwarbler'
    >>> 'spam'*3
    'spamspamspam'
    ```
"""

# ╔═╡ 68695430-64df-11eb-2c75-bd24a518cceb
md"""## Comments

As programs get bigger and more complicated, they get more difficult to read. Formal languages are dense, and it is often difficult to look at a piece of code and figure out what it is doing, or why.

For this reason, it is a good idea to add notes to your programs to explain in natural language what the program is doing. These notes are called *comments*, and they start with the `#` symbol:

```julia
# compute the percentage of the hour that has elapsed
percentage = (minute * 100) / 60
```

In this case, the comment appears on a line by itself. You can also put comments at the end of a line:

```julia
percentage = (minute * 100) / 60 # percentage of an hour
```

Everything from the `#` to the end of the line is ignored—it has no effect on the execution of the program.

Comments are most useful when they document nonobvious features of the code. It is reasonable to assume that the reader can figure out what the code does; it is more useful to explain why.

This comment is redundant with the code and useless:

```julia
v = 5 # assign 5 to v
```

This comment contains useful information that is not in the code:

```julia
v = 5 # velocity in meters/second
```

!!! warning
    Good variable names can reduce the need for comments, but long names can make complex expressions hard to read, so there is a trade-off.
"""

# ╔═╡ e11055b0-64e3-11eb-2bdd-6702d0a3fe84
md"""
!!! languages
    Comments in the C programming language start with `//`:
    ```c
    // compute the percentage of the hour that has elapsed
    double percentage = (minute * 100) / 60;
    percentage = (minute * 100) / 60; // percentage of an hour
    ```

    Python uses also the `#` symbol to start a comment:
    ```python
    # compute the percentage of the hour that has elapsed
    percentage = (minute * 100) / 60 # percentage of an hour
    ```
"""

# ╔═╡ d42b0690-64e5-11eb-16c8-e96f57c5dab8
md"""## Debugging

Three kinds of errors can occur in a program: syntax errors, runtime errors, and semantic errors. It is useful to distinguish between them in order to track them down more quickly:

* *Syntax error*:
  “Syntax” refers to the structure of a program and the rules about that structure. For example, parentheses have to come in matching pairs, so `(1 + 2)` is legal, but `8)` is a syntax error.

  If there is a syntax error anywhere in your program, Julia displays an error message and quits, and you will not be able to run the program. During the first few weeks of your programming career, you might spend a lot of time tracking down syntax errors. As you gain experience, you will make fewer errors and find them faster.

* *Runtime error*:
  The second type of error is a runtime error, so called because the error does not appear until after the program has started running. These errors are also called exceptions because they usually indicate that something exceptional (and bad) has happened.

  Runtime errors are rare in the simple programs you will see in the first few chapters, so it might be a while before you encounter one.

* *Semantic error*:
  The third type of error is “semantic,” which means related to meaning. If there is a semantic error in your program, it will run without generating error messages, but it will not do the right thing. It will do something else. Specifically, it will do what you told it to do.

  Identifying semantic errors can be tricky because it requires you to work backward by looking at the output of the program and trying to figure out what it is doing.
"""

# ╔═╡ c40b1b50-64e6-11eb-24ce-33b1cc5c6d0d
md"""## Glossary

*variable*:
A name that refers to a value.

*assignment*:
A statement that assigns a value to a variable.

*state diagram*:
A graphical representation of a set of variables and the values they refer to.

*keyword*:
A reserved word that is used to parse a program; you cannot use keywords like
`if`, `function`, and `while` as variable names.

*expression*:
A combination of variables, operators, and values that represents a single result.

*evaluate*:
To simplify an expression by performing the operations in order to yield a single value.

*statement*:
A section of code that represents a command or action. So far, the statements we have seen are assignments and print statements.

*execute*:
To run a statement and do what it says.

*interactive mode*:
A way of using the Julia REPL by typing code at the prompt.

*script mode*:
A way of using Julia to read code from a script and run it.

*script*:
A program stored in a file.

*operator precedence*:
Rules governing the order in which expressions involving multiple mathematical operators and operands are evaluated.

*concatenate*:
To join two strings end-to-end.

*comment*:
Information in a program that is meant for other programmers (or anyone reading the source code) and has no effect on the execution of the program.

*syntax error*:
An error in a program that makes it impossible to parse (and therefore impossible to interpret).

*runtime error* or *exception*:
An error that is detected while the program is running.

*semantics*:
The meaning of a program.

*semantic error*:
An error in a program that makes it do something other than what the programmer intended.
"""

# ╔═╡ 763c5320-64e7-11eb-16e0-1bdc148f2e24
md"""## Exercises

#### Exercise 2-2

Repeating my advice from the previous chapter, whenever you learn a new feature, you should try it out in interactive mode and make errors on purpose to see what goes wrong.

1. We’ve seen that `n = 42` is legal. What about `42 = n`?
2. How about `x = y = 1`?
3. In some languages every statement ends with a semicolon, `;`. What happens if you put a semicolon at the end of a Julia statement?
4. What if you put a period at the end of a statement?
5. In math notation you can multiply ``x`` and ``y`` like this: ``xy``. What happens if you try that in Julia? What about `5x`?
"""

# ╔═╡ c3de97a2-64e7-11eb-077e-a1692cd76929
md"""#### Exercise 2-3

Practice using the Julia REPL as a calculator:

1. The volume of a sphere with radius ``r`` is ``\frac{4}{3}\pi r^3``. What is the volume of a sphere with radius 5?
2. Suppose the cover price of a book is $24.95, but bookstores get a 40% discount. Shipping costs $3 for the first copy and 75 cents for each additional copy. What is the total wholesale cost for 60 copies?
3. If I leave my house at 6:52 a.m. and run 1 mile at an easy pace (8:15 per mile), then 3 miles at tempo (7:12 per mile) and 1 mile at easy pace again, what time do I get home for breakfast?
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.32"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0b5cfbb704034b5b4c1869e36634438a047df065"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "ae6145ca68947569058866e443df69587acc1806"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.32"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─62f36be0-64cf-11eb-0b86-9d4b55165cbf
# ╟─46a00ea0-64cd-11eb-3e3f-b7cfa00d69ce
# ╟─63956320-64cd-11eb-30d5-b1f23c40108f
# ╠═58ba9f20-64d1-11eb-30e7-71ec2290f593
# ╟─7f908a10-64d6-11eb-1629-9179dc49bad7
# ╟─5cb86662-64e1-11eb-0c04-41643ac1fc94
# ╟─60d71100-64ce-11eb-2a71-dd40eded5474
# ╟─14697060-64d8-11eb-105d-d39759df9d42
# ╟─567fc950-64dc-11eb-22e2-df958738bfff
# ╟─ff42a18e-64e4-11eb-0d79-b139fff2bcfd
# ╟─9f56ada0-64dd-11eb-2689-89413775adb1
# ╟─c95baab0-64dd-11eb-00c7-af9957ec1614
# ╟─d619bb60-64de-11eb-3d7b-572676f08d00
# ╟─0579eaa0-64e0-11eb-3fba-211e3857675f
# ╟─68695430-64df-11eb-2c75-bd24a518cceb
# ╟─e11055b0-64e3-11eb-2bdd-6702d0a3fe84
# ╟─d42b0690-64e5-11eb-16c8-e96f57c5dab8
# ╟─c40b1b50-64e6-11eb-24ce-33b1cc5c6d0d
# ╟─763c5320-64e7-11eb-16e0-1bdc148f2e24
# ╟─c3de97a2-64e7-11eb-077e-a1692cd76929
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
