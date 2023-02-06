### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 14207048-d900-4d0c-966b-1dd3560c3c2e
begin
    import Pkg
	io = IOBuffer()
    Pkg.activate(io = io)
end

# ╔═╡ b40446e0-64a6-11eb-3652-85fdb1612e5e
md"""# The Way of the Program

The goal of this book is to teach you to think like a computer scientist. This way of thinking combines some of the best features of mathematics, engineering, and natural science. Like mathematicians, computer scientists use formal languages to denote ideas (specifically computations). Like engineers, they design things, assembling components into systems and evaluating trade-offs among alternatives. Like scientists, they observe the behavior of complex systems, form hypotheses, and test predictions.

The single most important skill for a computer scientist is problem solving. Problem solving means the ability to formulate problems, think creatively about solutions, and express a solution clearly and accurately. As it turns out, the process of learning to program is an excellent opportunity to practice problem-solving skills. That’s why this chapter is called “The Way of the Program.”

On one level, you will be learning to program, a useful skill by itself. On another level, you will use programming as a means to an end. As we go along, that end will become clearer."""

# ╔═╡ 6b1e8390-64a7-11eb-2249-adcf7f79fc61
md"""## What Is a Program?

A _program_ is a sequence of instructions that specifies how to perform a computation. The computation might be something mathematical, such as solving a system of equations or finding the roots of a polynomial, but it can also be a symbolic computation, such as searching for and replacing text in a document, or something graphical, like processing an image or playing a video.

The details look different in different languages, but a few basic instructions appear in just about every language:

* *Input*: Get data from the keyboard, a file, the network, or some other device.
* *Output*: Display data on the screen, save it in a file, send it over the network, etc.
* *Math*: Perform basic mathematical operations like addition and multiplication.
* *Conditional execution*: Check for certain conditions and run the appropriate code.
* *Repetition*: Perform some action repeatedly, usually with some variation.

Believe it or not, that’s pretty much all there is to it. Every program you’ve ever used, no matter how complicated, is made up of instructions that look pretty much like these. So you can think of programming as the process of breaking a large, complex task into smaller and smaller subtasks until the subtasks are simple enough to be performed with one of these basic instructions."""

# ╔═╡ b2560330-64bd-11eb-0a30-57ada26f6ad1
md"""## Running Julia

One of the challenges of getting started with Julia is that you might have to install it and related software on your computer. Fortunately, the installation of Julia is straightforward. Julia is available for various operating systems at the [Julia](https://julialang.org/downloads/) website.

We will start out running Julia in the terminal and in a browser. Later, when you are comfortable with Julia, I’ll make suggestions for installing a dedicated programming environment on your computer.

The Julia *REPL* (Read–Eval–Print Loop) is a program that reads and executes Julia code. You can start the REPL by opening a terminal on your computer and typing **`julia`** on the command line. When it starts, you should see output like this:
"""

# ╔═╡ efe28168-b88f-4e8c-a0f0-ec577b869ee5
let
	io = IOBuffer()
	Base.banner(io)
	banner = String(take!(io))
	Markdown.parse("""
	```jlcon
	$banner julia>
	```
	""")
end

# ╔═╡ 7015855e-3f88-4ca8-b6af-5c3ac289269a
md"""The first lines contain information about the REPL, so it might be different for you. But you should check that the version number is at least 1.6.5.

The last line is a *prompt* that indicates that the REPL is ready for you to enter code. If you type a line of code and hit Enter, the REPL displays the result:

```jlcon
julia> 1 + 1
2
```

Code snippets can be copied and pasted verbatim, including the `julia>` prompt and any output.

Now we can install the Pluto *notebook* interface:

```jlcon
julia> using Pkg

julia> pkg"add Pluto"
Resolving package versions...
   ...
Precompiling project...
```

Once installed the browser based environment can be started with:

```jlcon
julia> using Pluto

julia> Pluto.run()
[ Info: Loading...
[ Info: Listening on: 127.0.0.1:1234
┌ Info:
└ Opening http://localhost:1234/?secret=F3mXM9nq in your default browser... ~ have fun!
┌ Info:
│ Press Ctrl+C in this terminal to stop Pluto
└
```

Your default browser opens a tab with the “Welcome to Pluto.jl” page. From there you can create a new notebook or open an existing one.

A Pluto notebook is made up of cells containg arbitrary Julia code. After entering the code, cells are evaluated by hitting **`SHIFT ENTER`**. During the opening of an existing notebook all cells will be evaluated automatically. **`CTRL ENTER`** will also evaluate the active cell and will create a new cell having focus.

All chapters of this book are available as notebooks. The text you read, is the result of the evaluation of a Markdown string. The code is hidden to not disturb the reader but will be shown when you click on the barred eye icon on the left.

Now you’re ready to get started. From here on, I assume that you know how to start the Julia REPL, start the Pluto notebook environment and run code both in the REPL and in a browser.
"""

# ╔═╡ cdb192f0-64bf-11eb-0a21-2987e4b81296
md"""## The First Program
Traditionally, the first program you write in a new language is called “Hello, World!” because all it does is display the words “Hello, World!” In Julia, it looks like this:
"""

# ╔═╡ 6209d2a0-6494-43ac-9890-e89db0a5d33b
println("Hello, World!")

# ╔═╡ 758ae87d-5d83-4b08-b9d0-939996fcd968
md"""This is an example of a *print statement*, although it doesn’t actually print anything on paper. It displays a result on the screen. In the notebook interface the output is shown in a terminal alike box underneath the cell.

The quotation marks in the program mark the beginning and end of the text to be displayed; they don’t appear in the result.

The parentheses indicate that `println` is a function. We’ll get to functions in Chapter 3.
"""

# ╔═╡ 224a71b0-64e3-11eb-0f83-4d671426a415
md"""!!! languages
    Other programming languages have a similar first program.

!!! c 
    In the C programming language, the following lines have to be put in a file and compiled before the program can run:
    ```c
    #include <stdio.h>

    int main(void) {
        printf("Hello, world!\n");
    }
    ```

!!! python
    Python provides a REPL:
    ```python
    >>> print('Hello, World!')
    ```

!!! matlab
	MATLAB has also a REPL:
    ```matlab
    >> disp('Hello, world!')
    ```
"""

# ╔═╡ 5a40a0b0-64c2-11eb-00e4-6fb54d1a31bb
md"""## Arithmetic Operators

After “Hello, World!” the next step is arithmetic. Julia provides *operators*, which are symbols that represent computations like addition and multiplication.

The operators `+`, `-`, and `*` perform addition, subtraction, and multiplication, as in the following examples:
"""

# ╔═╡ f800ffc3-0b88-47e0-8e88-54f3b82b6f86
40 + 2

# ╔═╡ 9a9adf0b-2865-4461-8253-39c106385d79
43 - 1

# ╔═╡ 4238b1c2-484d-4de8-8b52-e07f06f29493
6 * 7

# ╔═╡ ad0a29fc-546d-49c5-8716-b36c9ca12ac6
md"""In the notebook interface the result is shown above the cell containing the operation.

The operator `/` performs division:"""

# ╔═╡ 14269dfd-e3c6-4f24-9a9a-cf5460efb6ef
84 / 2

# ╔═╡ 4d5d4811-e4b3-4b7f-87eb-002b5730ec52
md"""You might wonder why the result is `42.0` instead of `42`. I’ll explain in the next section.

Finally, the operator `^` performs exponentiation; that is, it raises a number to a power:
"""

# ╔═╡ be9b5ac0-65c7-4ea2-a3fa-6d98e7b4f41c
6^2 + 6

# ╔═╡ 97df5b90-64c3-11eb-1b21-31020fae745d
md"""## Values and Types

A `value` is one of the basic things a program works with, like a letter or a number. Some values we have seen so far are `2`, `42.0`, and `"Hello, World!"`.

These values belong to different types: `2` is an *integer*, `42.0` is a *floating-point number*, and `"Hello, World!"` is a *string*, so called because the letters it contains are strung together.

If you are not sure what type a value has, the REPL can tell you:
"""

# ╔═╡ 8f0eb0af-3555-406b-a5d9-dedd09eca867
typeof(2)

# ╔═╡ 0e7bf532-1cb6-49eb-9b44-056cfd002607
typeof(42.0)

# ╔═╡ 1efca602-00d5-4475-880d-e630425bd16b
typeof("Hello, World!")

# ╔═╡ 9125d76f-b931-4738-ad32-703a2e4bfa7c
md"""Integers belong to the type `Int64`, strings belong to `String`, and floating-point numbers belong to `Float64`.

What about values like `"2"` and `"42.0"`? They look like numbers, but they are in quotation marks like strings. These are strings too:
"""

# ╔═╡ bffc1a9b-db65-4cc0-b428-5e266188f7aa
typeof("2")

# ╔═╡ fb25a121-d2c9-41a2-bc24-c390d45b8f85
typeof("42.0")

# ╔═╡ ecfc2835-481f-41d4-adb9-ce9249330b16
md"""When you type a large integer, you might be tempted to use commas between groups of digits, as in `1,000,000`. This is not a legal integer in Julia, but it is legal:
"""

# ╔═╡ 6987b8dc-a353-4ff9-acb6-3a74758d5c60
1,000,000

# ╔═╡ 5357621c-fe9f-4458-a4f6-2437079fd67b
md"""That’s not what we expected at all! Julia parses `1,000,000` as a comma-separated sequence of integers. We’ll learn more about this kind of sequence later.

You can get the expected result using `1_000_000`, however.
"""

# ╔═╡ 437336b0-64e3-11eb-39de-3bec9939b989
md"""
!!! python
    Python has a similar feature:
    ```python
    >>> type(2)
    <class 'int'>
    >>> type(42.0)
    <class 'float'>
    >>> type('Hello, World!')
    <class 'str'>
    ```

!!! matlab
    And so has MATLAB:
    ```matlab
    >> class(2)
    ans =
        'double'
    >> class(42)
    ans =
        'double'
    >> class('Hello, World!')
    ans =
        'char'
    ```
"""

# ╔═╡ 92130620-64c4-11eb-1790-df61511ecf87
md"""## Formal and Natural Languages

*Natural languages* are the languages people speak, such as English, Spanish, and French. They were not designed by people (although people try to impose some order on them); they evolved naturally.

*Formal languages* are languages that are designed by people for specific applications. For example, the notation that mathematicians use is a formal language that is particularly good at denoting relationships among numbers and symbols. Chemists use a formal language to represent the chemical structure of molecules. And most importantly, **programming languages are formal languages that have been designed to express computations**.

Formal languages tend to have strict *syntax* rules that govern the structure of statements. For example, in mathematics the statement ``3 + 3 = 6`` has correct syntax, but ``3 + = 3\$6`` does not. In chemistry, ``H_2O`` is a syntactically correct formula, but ``_2Zz`` is not.

Syntax rules come in two flavors: tokens and structure. Tokens are the basic elements of the language, such as words, numbers, and chemical elements. One of the problems with ``3 + = 3\$6`` is that ``\$`` is not a legal token in mathematics (at least as far as I know). Similarly, ``\mathit{_2Zz}`` is not legal because there is no element with the abbreviation ``\mathit{Zz}``.

The second type of syntax rule pertains to the way tokens are combined. The equation ``3 + = 3`` is illegal because even though ``+`` and ``=`` are legal tokens, you can’t have one right after the other. Similarly, in a chemical formula the subscript comes after the element name, not before.

This is ``@`` well-structured ``\mathit{Engli\$h}`` sentence with invalid ``\mathit{t\textrm{*}kens}`` in it. This sentence all valid tokens has, but invalid structure with.

When you read a sentence in English or a statement in a formal language, you have to figure out the structure (although in a natural language you do this subconsciously). This process is called *parsing*.

Although formal and natural languages have many features in common—tokens, structure, and syntax—there are some differences:

* *Ambiguity*:
  Natural languages are full of ambiguity, which people deal with by using contex! tual clues and other information. Formal languages are designed to be nearly or completely unambiguous, which means that any statement has exactly one meaning, regardless of context.
* *Redundancy*:
  In order to make up for ambiguity and reduce misunderstandings, natural languages employ lots of redundancy. As a result, they are often verbose. Formal languages are less redundant and more concise.
* *Literalness*:
  Natural languages are full of idiom and metaphor. If I say, “The penny dropped,” there is probably no penny and nothing dropping (this idiom means that someone understood something after a period of confusion). Formal languages mean exactly what they say.

Because we all grow up speaking natural languages, it is sometimes hard to adjust to formal languages. The difference between formal and natural language is like the difference between poetry and prose, but more so:

* *Poetry*:
  Words are used for their sounds as well as for their meaning, and the whole poem together creates an effect or emotional response. Ambiguity is not only common but often deliberate.
* *Prose*:
  The literal meaning of words is more important, and the structure contributes more meaning. Prose is more amenable to analysis than poetry but still often ambiguous.
* *Programs*:
  The meaning of a computer program is unambiguous and literal, and can be understood entirely by analysis of the tokens and structure.

Formal languages are more dense than natural languages, so it takes longer to read them. Also, the structure is important, so it is not always best to read from top to bottom, left to right. Instead, you’ll learn to parse the program in your head, identifying the tokens and interpreting the structure. Finally, the details matter. Small errors in spelling and punctuation, which you can get away with in natural languages, can make a big difference in a formal language.
"""

# ╔═╡ 75792d30-64c6-11eb-2b86-b13f35f42768
md"""## Debugging

Programmers make mistakes. For whimsical reasons, programming errors are called *bugs* and the process of tracking them down is called *debugging*.

Programming, and especially debugging, sometimes brings out strong emotions. If you are struggling with a difficult bug, you might feel angry, despondent, or embarrassed.

There is evidence that people naturally respond to computers as if they were people. When they work well, we think of them as teammates, and when they are obstinate or rude, we respond to them the same way we respond to rude, obstinate people.[^1]

Preparing for these reactions might help you deal with them. One approach is to think of the computer as an employee with certain strengths, like speed and precision, and particular weaknesses, like lack of empathy and inability to grasp the big picture.

Your job is to be a good manager: find ways to take advantage of the strengths and mitigate the weaknesses. And find ways to use your emotions to engage with the problem, without letting your reactions interfere with your ability to work effectively.

Learning to debug can be frustrating, but it is a valuable skill that is useful for many activities beyond programming. At the end of each chapter there is a section, like this one, with my suggestions for debugging. I hope they help!

[^1]: Reeves, Byron, and Clifford Ivar Nass. 1996. “The Media Equation: How People Treat Computers, Television, and New Media Like Real People and Places.” Chicago, IL: Center for the Study of Language and Information; New York: Cambridge University Press.
"""

# ╔═╡ a7270080-64c8-11eb-175a-192fbae1322b
md"""## Glossary

*problem solving*:
The process of formulating a problem, finding a solution, and expressing it.

*program*:
A sequence of instructions that specifies a computation.

*REPL*:
A program that repeatedly reads input, executes it, and outputs results.

*prompt*:
Characters displayed by the REPL to indicate that it is ready to take input from the user.

*notebook*:
Browser based environment displaying cells that contain arbitrary code, executed automatically during the opening of the notebook, or manually by hitting **`SHIFT ENTER`**.

*print statement*:
An instruction that causes the Julia REPL to display a value on the screen.

*operator*:
A symbol that represents a simple computation like addition, multiplication, or string concatenation.

*value*:
A basic unit of data, like a number or string, that a program manipulates.

*type*:
A category of values. The types we have seen so far are integers (Int64), floatingpoint numbers (Float64), and strings (String).

*integer*:
A type that represents whole numbers.

*floating-point*:
A type that represents numbers with a decimal point.

*string*:
A type that represents sequences of characters.

*natural language*:
Any one of the languages that people speak that evolved naturally.

*formal language*:
Any one of the languages that people have designed for specific purposes, such as representing mathematical ideas or computer programs. All programming lan guages are formal languages.

*syntax*:
The rules that govern the structure of a program.

*token*:
One of the basic elements of the syntactic structure of a program, analogous to a word in a natural language.

*structure*:
The way tokens are combined.

*parse*:
To examine a program and analyze the syntactic structure.

*bug*:
An error in a program.

*debugging*:
The process of finding and correcting bugs.
"""

# ╔═╡ ce5393c0-64c9-11eb-25ec-c55227798aa8
md"""## Exercises

!!! tip
    It is a good idea to read this book in front of a computer or in your browser so you can try out the examples as you go.

### Exercise 1-1

Whenever you are experimenting with a new feature, you should try to make mistakes. For example, in the “Hello, World!” program, what happens if you leave out one of the quotation marks? What if you leave out both? What if you spell println wrong?

This kind of experiment helps you remember what you read; it also helps when you are programming, because you get to know what the error messages mean. It is better to make mistakes now and on purpose rather than later and accidentally.

1. In a print statement, what happens if you leave out one of the parentheses, or both?
2. If you are trying to print a string, what happens if you leave out one of the quotation marks, or both?
3. You can use a minus sign to make a negative number like ``-2``. What happens if you put a plus sign before a number? What about ``2++2``?
4. In math notation, leading zeros are okay, as in 02. What happens if you try this in Julia?
5. What happens if you have two values with no operator between them?
"""

# ╔═╡ 6472f940-64ca-11eb-0492-0953cf692c54
md"""### Exercise 1-2

Start the Julia REPL and use it as a calculator.

1. How many seconds are there in 42 minutes 42 seconds?
2. How many miles are there in 10 kilometers? Note that there are 1.61 kilometers in a mile.
3. If you run a 10-kilometer race in 37 minutes 48 seconds, what is your average pace (time per mile in minutes and seconds)? What is your average speed in miles per hour?
"""

# ╔═╡ Cell order:
# ╟─14207048-d900-4d0c-966b-1dd3560c3c2e
# ╟─b40446e0-64a6-11eb-3652-85fdb1612e5e
# ╟─6b1e8390-64a7-11eb-2249-adcf7f79fc61
# ╟─b2560330-64bd-11eb-0a30-57ada26f6ad1
# ╟─efe28168-b88f-4e8c-a0f0-ec577b869ee5
# ╟─7015855e-3f88-4ca8-b6af-5c3ac289269a
# ╟─cdb192f0-64bf-11eb-0a21-2987e4b81296
# ╠═6209d2a0-6494-43ac-9890-e89db0a5d33b
# ╟─758ae87d-5d83-4b08-b9d0-939996fcd968
# ╟─224a71b0-64e3-11eb-0f83-4d671426a415
# ╟─5a40a0b0-64c2-11eb-00e4-6fb54d1a31bb
# ╠═f800ffc3-0b88-47e0-8e88-54f3b82b6f86
# ╠═9a9adf0b-2865-4461-8253-39c106385d79
# ╠═4238b1c2-484d-4de8-8b52-e07f06f29493
# ╟─ad0a29fc-546d-49c5-8716-b36c9ca12ac6
# ╠═14269dfd-e3c6-4f24-9a9a-cf5460efb6ef
# ╟─4d5d4811-e4b3-4b7f-87eb-002b5730ec52
# ╠═be9b5ac0-65c7-4ea2-a3fa-6d98e7b4f41c
# ╟─97df5b90-64c3-11eb-1b21-31020fae745d
# ╠═8f0eb0af-3555-406b-a5d9-dedd09eca867
# ╠═0e7bf532-1cb6-49eb-9b44-056cfd002607
# ╠═1efca602-00d5-4475-880d-e630425bd16b
# ╟─9125d76f-b931-4738-ad32-703a2e4bfa7c
# ╠═bffc1a9b-db65-4cc0-b428-5e266188f7aa
# ╠═fb25a121-d2c9-41a2-bc24-c390d45b8f85
# ╟─ecfc2835-481f-41d4-adb9-ce9249330b16
# ╠═6987b8dc-a353-4ff9-acb6-3a74758d5c60
# ╟─5357621c-fe9f-4458-a4f6-2437079fd67b
# ╟─437336b0-64e3-11eb-39de-3bec9939b989
# ╟─92130620-64c4-11eb-1790-df61511ecf87
# ╟─75792d30-64c6-11eb-2b86-b13f35f42768
# ╟─a7270080-64c8-11eb-175a-192fbae1322b
# ╟─ce5393c0-64c9-11eb-25ec-c55227798aa8
# ╟─6472f940-64ca-11eb-0492-0953cf692c54
