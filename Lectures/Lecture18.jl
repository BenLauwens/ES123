### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ a4fd1d7c-91f4-11eb-04b9-ef70a90ddf23
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

# ╔═╡ f3b2865d-fe88-4a0c-a0db-4ce1e364cf12
using Test

# ╔═╡ 3987106e-12e0-453f-ae8d-b34bfb15c563
using Random

# ╔═╡ 50e6776a-91f4-11eb-11c9-f7dd1bfb308b
md"""# Subtyping

In the previous chapter we introduced the multiple dispatch mechanism and polymorphic methods. Not specifying the types of the arguments results in a method that can be called with arguments of any type. Specifying a subset of allowed types in the signature of a method is a logical next step.

In this chapter I demonstrate subtyping using types that represent playing cards, decks of cards, and poker hands.

If you don’t play poker, you can [read about it](https://en.wikipedia.org/wiki/Poker), but you don’t have to; I’ll tell you what you need to know for the exercises.
"""

# ╔═╡ b225017a-91f4-11eb-24c2-758f1579bae0
md"""## Cards

There are 52 cards in a deck, each of which belongs to one of 4 suits and one of 13 ranks. The suits are Spades (♠), Hearts (♥), Diamonds (♦), and Clubs (♣). The ranks are Ace (A), 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack (J), Queen (Q), and King (K). Depending on the game that you are playing, an Ace may be higher than a King or lower than a 2.

If we want to define a new object to represent a playing card, it is obvious what the attributes should be: rank and suit. It is not as obvious what type the attributes should be. One possibility is to use strings containing words like "Spade" for suits and "Queen" for ranks. One problem with this implementation is that it would not be easy to compare cards to see which had a higher rank or suit.

An alternative is to use integers to *encode* the ranks and suits. In this context, “encode” means that we are going to define a mapping between numbers and suits, or between numbers and ranks. This kind of encoding is not meant to be a secret (that would be “encryption”).

For example, we might map the suits to integer codes as follows:

* ♠ ⟼ 4
* ♥ ⟼ 3
* ♦ ⟼ 2
* ♣ ⟼ 1

This makes it easy to compare cards; because higher suits map to higher numbers, we can compare suits by comparing their codes.

I am using the symbol to make it clear that these mappings are not part of the Julia program. They are part of the program design, but they don’t appear explicitly in the code.

The struct definition for `Card` looks like this:
"""

# ╔═╡ 8898b179-95c7-4675-9bea-7c63affc10ca
struct Card
	suit :: Int64
	rank :: Int64
	function Card(suit::Int64, rank::Int64)
		@assert(1 ≤ suit ≤ 4, "suit is not between 1 and 4")
		@assert(1 ≤ rank ≤ 13, "rank is not between 1 and 13")
		return new(suit, rank)
	end
end

# ╔═╡ b297712b-e3c8-408a-a850-6d981d09cef4
md"""To create a `Card`, you call `Card` with the suit and rank of the card you want:
"""

# ╔═╡ e9851e1e-e7dc-4b84-894c-bb0fca48f0dc
queen_of_diamonds = Card(2, 12)

# ╔═╡ d4ab94e7-0ac4-4803-835a-6269fba7af54
abstract type CardSet end;

# ╔═╡ 3a19ed60-91f5-11eb-0614-a550fdd98d4b
md"""## Global Variables

In order to print `Card` objects in a way that people can easily read, we need a mapping from the integer codes to the corresponding ranks and suits. A natural way to do that is with arrays of strings:
"""

# ╔═╡ c227a86d-77ce-491f-b445-d80495065eab
begin
	const suit_names = ["♣", "♦", "♥", "♠"]
	const rank_names = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J",
	                    "Q", "K"]
end;

# ╔═╡ 3e593907-a861-4e9d-b251-02bcc0dda1ec
begin
	function Base.show(io::IO, cs::CardSet)
		for card in cs.cards
			print(io, card, " ")
		end
	end
	
	function Base.show(io::IO, card::Card)
		print(io, rank_names[card.rank], suit_names[card.suit])
	end
end;

# ╔═╡ b213bda1-6c05-4fe7-81fe-6bdc5f2095db
md"""The variables `suit_names` and `rank_names` are global variables. The `const` declaration means that the variable can only be assigned once. This solves the performance problem of global variables.

Now we can implement an appropriate show method:

```julia
function Base.show(io::IO, card::Card)
	print(io, rank_names[card.rank], suit_names[card.suit])
end
```

The expression `rank_names[card.rank]` means “use the field rank from the object card as an index into the array `rank_names`, and select the appropriate string.”

With the methods we have so far, we can create and print `Card`:
"""

# ╔═╡ bd6b88f3-2637-4244-a612-f9809336724c
Card(2, 12)

# ╔═╡ a9f58e82-91f5-11eb-3863-53f39944a784
md"""## Comparing Cards

For built-in types, there are relational operators (`<`, `>`, `==`, etc.) that compare values and determine when one is greater than, less than, or equal to another. For programmer-defined types, we can override the behavior of the built-in operators by providing a method named `<`.

The correct ordering for cards is not obvious. For example, which is better, the 3 of Clubs or the 2 of Diamonds? One has a higher rank, but the other has a higher suit. In order to compare cards, you have to decide whether rank or suit is more important.

The answer might depend on what game you are playing, but to keep things simple, we’ll make the arbitrary choice that suit is more important, so all of the Spades outrank all of the Diamonds and so on.

With that decided, we can write `<`:
"""

# ╔═╡ eee2eab3-6dc2-4819-9bf9-a94a07964a7d
Base.isless(c1::Card, c2::Card) = (c1.suit, c1.rank) < (c2.suit, c2.rank)

# ╔═╡ eb053c18-91f5-11eb-0fae-c762d9d17018
md"""### Exercise 18-1

Write a `<` method for `MyTime` objects. You can use tuple comparison, but you also might consider comparing integers.
"""

# ╔═╡ 0261965c-91f6-11eb-384c-d77046f0e6ab
md"""## Unit Testing

*Unit testing* allows you to verify the correctness of your code by comparing the results of your code to what you expect. This can be useful to be sure that your code is still correct after modifications, and it is also a way to predefine the correct behavior of your code during development.

Simple unit testing can be performed with the `@test` macro:
"""

# ╔═╡ 4ece55df-1f45-4ca5-b5f2-96850ff31078
@test Card(1, 4) < Card(2, 4)

# ╔═╡ 43d90cf6-e44a-4050-90f8-b0bfb5cd0e80
@test Card(1, 3) < Card(1, 4)

# ╔═╡ e59a0f1f-160f-410a-acbb-96fa1164eba5
md"""`@test` returns a "Test Passed" if the expression following it is `true`, a "Test Failed" if it is `false`, and an "Error Result" if it could not be evaluated.
"""

# ╔═╡ 3c0aeeaa-91f6-11eb-2fdf-77ec7c2b14fa
md"""## Decks

Now that we have `Cards`, the next step is to define Decks. Since a deck is made up of cards, it is natural for each `Deck` to contain an array of `Card`s as an attribute.
The following is a struct definition for `Deck`. The constructor creates the field `cards` and generates the standard set of 52 `Card`s:

```julia
begin
	struct Deck
		cards :: Array{Card, 1}
	end
	
	function Deck()
		deck = Deck(Card[])
		for suit in 1:4
			for rank in 1:13
				push!(deck.cards, Card(suit, rank))
			end
		end
		return deck
	end
end
```

The easiest way to populate the deck is with a nested loop. The outer loop enumerates the suits from 1 to 4. The inner loop enumerates the ranks from 1 to 13. Each iteration creates a new `Card` with the current suit and rank, and pushes it to `deck.cards`.

Here is a `show` method for `Deck`:

```julia
function Base.show(io::IO, deck::Deck)
	for card in deck.cards
		print(io, card, " ")
	end
	println()
end
```

Here’s what the result looks like:
"""

# ╔═╡ 7f423f9a-9212-11eb-21f7-23211e7383ca
md"""## Add, Remove, Shuffle, and Sort

To deal cards, we would like a function that removes a `Card` from the `Deck` and returns it. The function `pop!` provides a convenient way to do that:

```julia
Base.pop!(deck::Deck) = pop!(deck.cards)
```

Since `pop!` removes the last `Card` in the array, we are dealing from the bottom of the `Deck`.

To add a `Card`, we can use the function `push!`:

```julia
function Base.push!(deck::Deck, card::Card)
	push!(deck.cards, card)
	return deck
end
```

A method like this that uses another method without doing much work is sometimes called a *veneer*. The metaphor comes from woodworking, where a veneer is a thin layer of good-quality wood glued to the surface of a cheaper piece of wood to improve the appearance.

In this case `push!` is a “thin” method that expresses an array operation in terms appropriate for decks. It improves the appearance, or interface, of the implementation.

As another example, we can write a method named `shuffle!` using the function `Random.shuffle!`:
"""

# ╔═╡ 7c970f54-9213-11eb-3d29-c38b10f3cf1c
md"""### Exercise 18-2

Write a function named `sort!` that uses the function `sort!` to sort the `cards` in a `Deck`. `sort!` uses the `<` method we defined to determine the order.
"""

# ╔═╡ a40c70e4-9213-11eb-3054-d381a4db08ec
md"""## Abstract Types and Subtyping

We want a type to represent a “hand”; that is, the cards held by one player. A hand is similar to a deck: both are made up of a collection of cards, and both require operations like adding and removing cards.

A hand is also different from a deck; there are operations we want for hands that don’t make sense for a deck. For example, in poker we might compare two hands to see which one wins. In bridge, we might compute a score for a hand in order to make a bid.

So, we need a way to group related *concrete types*. In Julia this is done by defining an *abstract type* that serves as a parent for both `Deck` and `Hand`. This is called *subtyping*.

Let’s call this abstract type `CardSet`:

```julia
abstract type CardSet end
```

A new abstract type is created with the `abstract type` keyword. An optional “par‐ ent” type can be specified by putting `<:` after the name, followed by the name of an already existing abstract type.


When no *supertype* is given, the default supertype is `Any`—a predefined abstract type that all objects are instances of and all types are subtypes of.
We can now express that `Deck` is a descendant of `CardSet`:
"""

# ╔═╡ f0b6c191-93cb-447b-9b94-4567be26ae81
md"""The operator `isa` checks whether an object is of a given type:
"""

# ╔═╡ 377b5a1f-c9f4-44c8-b425-a6e19531ee15
md"""A `Hand` is also a kind of `CardSet`:"""

# ╔═╡ d7449874-fe2d-49c5-88dc-cdeda9d73eb4
begin
	struct Hand <: CardSet cards :: Array{Card, 1}
		label :: String
	end
	
	Hand(label::String="") = Hand(Card[], label)
end

# ╔═╡ 15b1c886-0be1-4393-a4da-f38d6a2f0eb4
md"""Instead of populating the hand with 52 new Cards, the constructor for `Hand` initializes cards with an empty array. An optional argument can be passed to the constructor giving a label to the `Hand`:
"""

# ╔═╡ c1c8c7c6-e1b5-4b1e-bbeb-67bbef778703
hand = Hand("new hand")

# ╔═╡ 902972b6-9216-11eb-3bc2-0b6c29094443
md"""## Abstract Types and Functions

We can now express the common operations between `Deck` and `Hand` as functions having a `CardSet` as an argument:

```julia
function Base.show(io::IO, cs::CardSet)
	for card in cs.cards
		print(io, card, " ")
	end
end
```
"""

# ╔═╡ bb06bc09-496a-403c-ba9f-527f3cfffd64
Base.pop!(cs::CardSet) = pop!(cs.cards)

# ╔═╡ b81687f1-4396-4136-899a-b59725f901a5
function Base.push!(cs::CardSet, card::Card)
	push!(cs.cards, card)
	nothing
end

# ╔═╡ 11dd683e-2b37-43cd-a0ce-92cb1d5c322c
begin
	struct Deck <: CardSet
		cards :: Array{Card, 1}
	end
	
	function Deck()
		deck = Deck(Card[])
		for suit in 1:4
			for rank in 1:13
				push!(deck.cards, Card(suit, rank))
			end
		end
		return deck
	end
end

# ╔═╡ 96b1d818-66e7-457f-a36a-d7001278b75b
deck = Deck()

# ╔═╡ fa2f884f-56a1-43c8-af47-999b4b6bf5b4
deck isa CardSet

# ╔═╡ c6f58360-0d12-497b-bd5a-263ac494dcad
function Random.shuffle!(deck::Deck)
	shuffle!(deck.cards)
	return deck
end

# ╔═╡ 1daa2cc4-b387-407d-8611-532b569eb3ca
md"""We can use `pop!` and `push!` to deal a card:
"""

# ╔═╡ 16af4ba8-f73c-4497-b509-9f1e72d1c5e5
shuffle!(deck)

# ╔═╡ 6c6c2dd4-3135-4ed5-b037-f736031ee282
card = pop!(deck)

# ╔═╡ 8c96ff8d-7631-4429-95ad-47db18d832d4
push!(hand, card)

# ╔═╡ 657c858e-82a9-4359-87bf-f8aaff50996b
md"""A natural next step is to encapsulate this code in a function called `move!`:
"""

# ╔═╡ d161d84a-91cc-4993-9ccd-af67a68e7b13
function move!(cs1::CardSet, cs2::CardSet, n::Int)
	@assert 1 ≤ n ≤ length(cs1.cards)
	for _ in 1:n
		card = pop!(cs1)
		push!(cs2, card)
	end
	return nothing
end

# ╔═╡ 2b5d0c63-6ce3-4be9-abac-a120902178be
md"""`move!` takes three arguments, two `CardSet` objects and the number of cards to deal. It modifies both `CardSet` objects, and returns `nothing`.

In some games, cards are moved from one hand to another, or from a hand back to the deck. You can use `move!` for any of these operations: `cs1` and `cs2` can be either a `Deck` or a `Hand`.
"""

# ╔═╡ eb991f36-925a-11eb-2507-9548f77fe360
md"""## Type Diagrams

So far we have seen stack diagrams, which show the state of a program, and object diagrams, which show the attributes of an object and their values. These diagrams represent a snapshot of the execution of a program, so they change as the program runs.

They are also highly detailed—for some purposes, too detailed. A *type diagram* is a more abstract representation of the structure of a program. Instead of showing individual objects, it shows types and the relationships between them.

There are several kinds of relationships between types:

* Objects of a concrete type might contain references to objects of another type. For example, each `Rectangle` contains a reference to a `Point`, and each `Deck` contains references to an array of `Card`s. This kind of relationship is called *has-a*, as in, “a `Rectangle` has a `Point`.”

* A concrete type can have an abstract type as a supertype. This relationship is called *is-a*, as in, “a `Hand` is a kind of a `CardSet`.”

* One type might depend on another, in the sense that objects of one type take objects of the second type as parameters, or use objects of the second type as part of a computation. This kind of relationship is called a *dependency*.
"""

# ╔═╡ 3a94d66e-925b-11eb-385b-79e764664fad
Drawing(width=720, height=150) do
	@info "Type diagram."
	defs() do
        marker(id="arrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="black")
		end
		marker(id="hollowarrow", markerWidth="10", markerHeight="10", refX="0", refY="3", orient="auto", markerUnits="strokeWidth") do
      		path(d="M0,0 L0,6 L9,3 z", fill="none", stroke="black")
		end
	end
	rect(x=310, y=10, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=335, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("CardSet")
	end
	rect(x=150, y=60, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=185, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Deck")
	end
	line(x1=250, y1=60, x2=301, y2=43, stroke="black", marker_end="url(#hollowarrow)")
	rect(x=470, y=60, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=505, y=80, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Hand")
	end
	line(x1=470, y1=60, x2=419, y2=43, stroke="black", marker_end="url(#hollowarrow)")
	rect(x=310, y=110, width=100, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=345, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("Card")
	end
	line(x1=250, y1=90, x2=301, y2=107, stroke="black", marker_end="url(#arrow)")
	line(x1=470, y1=90, x2=419, y2=107, stroke="black", marker_end="url(#arrow)")
	text(x=305, y=105, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("*")
	end
	text(x=405, y=105, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do
		str("*")
	end
end

# ╔═╡ f5385824-925d-11eb-2879-1f88fbd6b330
md"""The arrow with a hollow triangle head represents an is-a relationship; in this case it indicates that `Hand` has `CardSet` as a supertype.

The standard arrowhead represents a has-a relationship; in this case a `Deck` has references to `Card` objects.

The star (`*`) near the arrowhead is a multiplicity; it indicates how many `Card`s a `Deck` has. A multiplicity can be a simple number, like `52`; a range, like `5:7`; or a star, which indicates that a `Deck` can have any number of `Card`s.

There are no dependencies in this diagram. They would normally be shown with a dashed arrow. Or if there are a lot of dependencies, they are sometimes omitted.

A more detailed diagram might show that a `Deck` actually contains an array of `Card`s, but built-in types like array and dictionaries are usually not included in type diagrams.
"""

# ╔═╡ 39794bee-925e-11eb-1617-195f9c786a02
md"""## Debugging

Subtyping can make debugging difficult because when you call a function with an object as an argument, it might be hard to figure out which method will be invoked.

Suppose you are writing a function that works with `Hand` objects. You would like it to work with all kinds of `Hand`s, like `PokerHand`s, `BridgeHand`s, etc. If you invoke a method like `sort!`, you might get the version defined for an abstract type `Hand`, but if a method `sort!` with any of the subtypes as an argument exists, you’ll get that version instead. This behavior is usually a good thing, but it can be confusing:
"""

# ╔═╡ f67b28df-ea11-4231-8562-3094390691ff
Base.sort!(hand::Hand) = sort!(hand.cards)

# ╔═╡ de62de0b-a837-4f62-81d4-81acdaf06de0
md"""Any time you are unsure about the flow of execution through your program, the simplest solution is to add print statements at the beginning of the relevant methods. If `shuffle!` prints a message that says something like `"Running shuffle! Deck"`, then as the program runs it traces the flow of execution.

As a better alternative, you can use the `@which` macro:
"""

# ╔═╡ 0034f34d-d8be-45ad-9f47-c77a0bd9e5ba
@which sort!(hand)

# ╔═╡ 16162c88-0e03-42a4-906a-0d94f7d68015
md"""This tells us that the `sort!` method for `hand` is the one having as an argument an object of type `Hand`.

Here’s a design suggestion: when you override a method, the interface of the new method should be the same as the old one. It should take the same parameters, return the same type, and obey the same preconditions and postconditions. If you follow this rule, you will find that any function designed to work with an instance of a supertype, like a `CardSet`, will also work with instances of its subtypes (`Deck` and `Hand`).

If you violate this rule, which is called the “Liskov substitution principle,” your code will collapse like (sorry) a house of cards.

The function `supertype` can be used to find the direct supertype of a type:
"""

# ╔═╡ 5f0d1480-5613-4dbf-b0fc-269706e8c271
supertype(Deck)

# ╔═╡ b790e4a4-925e-11eb-3497-3f0389e2767f
md"""## Data Encapsulation

The previous chapters demonstrated a development plan we might call “type-oriented design.” We identified objects we needed—like `Point`, `Rectangle`, and `MyTime`—and defined structs to represent them. In each case there was an obvious correspondence between the object and some entity in the real world (or at least a mathematical world).

But sometimes it is less obvious what objects you need and how they should interact. In that case you need a different development plan. In the same way that we discovered function interfaces by encapsulation and generalization, we can discover type interfaces by *data encapsulation*.

Markov analysis, described in “Markov Analysis”, provides a good example. If you look at my solution to “Exercise 13-8”, you’ll see that it uses two global variables—`suffixes` and `prefix`—that are read and written from several functions:

```julia
const suffixes = Dict()
const prefix = []
```

Because these variables are global, we can only run one analysis at a time. If we read two texts, their prefixes and suffixes would be added to the same data structures (which makes for some interesting generated text).

To run multiple analyses, and keep them separate, we can encapsulate the state of each analysis in an object. Here’s what that looks like:

```julia
struct Markov
	order :: Int64
	suffixes :: Dict{Tuple{String,Vararg{String}}, Array{String, 1}}
	prefix :: Array{String, 1}
	Markov(order::Int64=2) = new(order, Dict{Tuple{String,Vararg{String}}, 				Array{String, 1}}(), Array{String, 1}())
	end
end
```

Next, we transform the functions into methods. For example, here’s `processword`:

```julia
function processword(markov::Markov, word::String)
	if length(markov.prefix) < markov.order
		push!(markov.prefix, word)
		return nothing
	end
	get!(markov.suffixes, (markov.prefix...,), Array{String, 1}())
	push!(markov.suffixes[(markov.prefix...,)], word)
	popfirst!(markov.prefix)
	push!(markov.prefix, word)
	return nothing
end
```

Transforming a program like this—changing the design without changing the behavior—is another example of refactoring (see “Refactoring”).

This example suggests a development plan for designing types:

* Start by writing functions that read and write global variables (when necessary).
* Once you get the program working, look for associations between global variables and the functions that use them.
* Encapsulate related variables as fields of a struct.
* Transform the associated functions into methods with as argument objects of the new type.
"""

# ╔═╡ ccb90fe0-925f-11eb-3786-15147a772503
md"""### Exercise 18-3

Download my Markov code from GitHub, and follow the steps described here to encapsulate the global variables as attributes of a new struct called `Markov`.
"""

# ╔═╡ dd89d250-925f-11eb-18ba-35b060cddaa3
md"""## Glossary

*encode*:
To represent one set of values using another set of values by constructing a mapping between them.

*unit testing*:
A standardized way to test the correctness of code.

*veneer*:
A method or function that provides a different interface to another function without doing much computation.

*concrete type*:
A type that can be constructed.

*abstract type*:
A type that can act as a parent for another type.

*subtyping*:
The ability to define a hierarchy of related types.

*supertype*:
An abstract type that is the parent of another type.

*subtype*:
A type that has as its parent an abstract type.

*type diagram*:
A diagram that shows the types in a program and the relationships between them.

*has-a relationship*:
A relationship between two types where instances of one type contain references to instances of the other.

*is-a relationship*:
A relationship between a subtype and its supertype.

*dependency*:
A relationship between two types where instances of one type use instances of the other type, but do not store them as fields.

*multiplicity*:
A notation in a type diagram that shows, for a has-a relationship, how many references there are to instances of another class.

*data encapsulation*:
A program development plan that involves a prototype using global variables and a final version that makes the global variables into instance fields.
"""

# ╔═╡ 266416f4-9260-11eb-226b-4b8e377b7e18
md"""## Exercises

### Exercise 18-4

For the following program, draw a type diagram that shows these types and the relationships among them.
"""

# ╔═╡ 094375fa-e5b0-4eb9-a931-a06b001f3352
abstract type PingPongParent end

# ╔═╡ 4071488d-5278-4150-a81d-745825eab484
struct Ping <: PingPongParent
	pong :: PingPongParent
end

# ╔═╡ 605c2691-1584-4364-9c25-1369cc665b24
struct Pong <: PingPongParent
	pings :: Array{Ping, 1}
	function Pong(pings=Array{Ping, 1}())
		return new(pings)
	end
end

# ╔═╡ 8a91684a-4c14-488f-a526-0da1ed019389
function addping(pong::Pong, ping::Ping)
	push!(pong.pings, ping)
	return nothing
end

# ╔═╡ e2ea0b75-05ee-4c57-ba18-ab0915b49878
let
	pong = Pong()
	ping = Ping(pong)
	addping(pong, ping)
end

# ╔═╡ 5f0e371c-9260-11eb-2edf-9b5dd31992d8
md"""### Exercise 18-5

Write a method called `deal!` that takes three parameters: a `Deck`, the number of `Hand`s, and the number of `Card`s per `Hand`. It should create the appropriate number of `Hand` objects, deal the appropriate number of `Card`s per `Hand`, and return an array of `Hand`s.
"""

# ╔═╡ 950c43d4-9260-11eb-0c8e-fdf5c93d8eae
md"""### Exercise 18-6

The following are the possible hands in poker, in increasing order of value and decreasing order of probability:

*Pair*:
Two cards with the same rank

*Two pair*:
Two pairs of cards with the same rank

*Three of a kind*:
Three cards with the same rank

*Straight*:
Five cards with ranks in sequence (Aces can be high or low, so Ace-2-3-4-5 is a straight and so is 10-Jack-Queen-King-Ace, but Queen-King-Ace-2-3 is not)

*Flush*:
Five cards with the same suit

*Full house*:
Three cards with one rank, two cards with another

*Four of a kind*:
Four cards with the same rank

*Straight flush*:
Five cards in sequence (as defined previously) and with the same suit

The goal of this exercise is to estimate the probability of drawing these various hands.

1. Add methods named `haspair`, `hastwopair`, etc., that return `true` or `false` according to whether or not the hand meets the relevant criteria. Your code should work correctly for hands that contain any number of cards (although five and seven are the most common sizes).
2. Write a method named `classify` that figures out the highest-value classification for a hand and sets the label field accordingly. For example, a seven-card hand might contain a flush and a pair; it should be labeled flush.
3. When you are convinced that your classification methods are working, the next step is to estimate the probabilities of the various hands. Write a function that shuffles a deck of cards, divides it into hands, classifies the hands, and counts the number of times various classifications appear.
4. Print a table of the classifications and their probabilities. Run your program with larger and larger numbers of hands until the output values converge to a reason‐ able degree of accuracy. Compare your results to [these hand ranks](http://www.codethrowdown.com/5CardSingleDeckHands.txt).
"""

# ╔═╡ Cell order:
# ╟─a4fd1d7c-91f4-11eb-04b9-ef70a90ddf23
# ╟─50e6776a-91f4-11eb-11c9-f7dd1bfb308b
# ╟─b225017a-91f4-11eb-24c2-758f1579bae0
# ╠═8898b179-95c7-4675-9bea-7c63affc10ca
# ╟─b297712b-e3c8-408a-a850-6d981d09cef4
# ╠═e9851e1e-e7dc-4b84-894c-bb0fca48f0dc
# ╟─d4ab94e7-0ac4-4803-835a-6269fba7af54
# ╟─3e593907-a861-4e9d-b251-02bcc0dda1ec
# ╟─3a19ed60-91f5-11eb-0614-a550fdd98d4b
# ╠═c227a86d-77ce-491f-b445-d80495065eab
# ╟─b213bda1-6c05-4fe7-81fe-6bdc5f2095db
# ╠═bd6b88f3-2637-4244-a612-f9809336724c
# ╟─a9f58e82-91f5-11eb-3863-53f39944a784
# ╠═eee2eab3-6dc2-4819-9bf9-a94a07964a7d
# ╟─eb053c18-91f5-11eb-0fae-c762d9d17018
# ╟─0261965c-91f6-11eb-384c-d77046f0e6ab
# ╠═f3b2865d-fe88-4a0c-a0db-4ce1e364cf12
# ╠═4ece55df-1f45-4ca5-b5f2-96850ff31078
# ╠═43d90cf6-e44a-4050-90f8-b0bfb5cd0e80
# ╟─e59a0f1f-160f-410a-acbb-96fa1164eba5
# ╟─3c0aeeaa-91f6-11eb-2fdf-77ec7c2b14fa
# ╠═96b1d818-66e7-457f-a36a-d7001278b75b
# ╟─7f423f9a-9212-11eb-21f7-23211e7383ca
# ╠═3987106e-12e0-453f-ae8d-b34bfb15c563
# ╠═c6f58360-0d12-497b-bd5a-263ac494dcad
# ╟─7c970f54-9213-11eb-3d29-c38b10f3cf1c
# ╟─a40c70e4-9213-11eb-3054-d381a4db08ec
# ╠═11dd683e-2b37-43cd-a0ce-92cb1d5c322c
# ╟─f0b6c191-93cb-447b-9b94-4567be26ae81
# ╠═fa2f884f-56a1-43c8-af47-999b4b6bf5b4
# ╟─377b5a1f-c9f4-44c8-b425-a6e19531ee15
# ╠═d7449874-fe2d-49c5-88dc-cdeda9d73eb4
# ╟─15b1c886-0be1-4393-a4da-f38d6a2f0eb4
# ╠═c1c8c7c6-e1b5-4b1e-bbeb-67bbef778703
# ╟─902972b6-9216-11eb-3bc2-0b6c29094443
# ╠═bb06bc09-496a-403c-ba9f-527f3cfffd64
# ╠═b81687f1-4396-4136-899a-b59725f901a5
# ╟─1daa2cc4-b387-407d-8611-532b569eb3ca
# ╠═16af4ba8-f73c-4497-b509-9f1e72d1c5e5
# ╠═6c6c2dd4-3135-4ed5-b037-f736031ee282
# ╠═8c96ff8d-7631-4429-95ad-47db18d832d4
# ╟─657c858e-82a9-4359-87bf-f8aaff50996b
# ╠═d161d84a-91cc-4993-9ccd-af67a68e7b13
# ╟─2b5d0c63-6ce3-4be9-abac-a120902178be
# ╟─eb991f36-925a-11eb-2507-9548f77fe360
# ╟─3a94d66e-925b-11eb-385b-79e764664fad
# ╟─f5385824-925d-11eb-2879-1f88fbd6b330
# ╟─39794bee-925e-11eb-1617-195f9c786a02
# ╠═f67b28df-ea11-4231-8562-3094390691ff
# ╟─de62de0b-a837-4f62-81d4-81acdaf06de0
# ╠═0034f34d-d8be-45ad-9f47-c77a0bd9e5ba
# ╟─16162c88-0e03-42a4-906a-0d94f7d68015
# ╠═5f0d1480-5613-4dbf-b0fc-269706e8c271
# ╟─b790e4a4-925e-11eb-3497-3f0389e2767f
# ╟─ccb90fe0-925f-11eb-3786-15147a772503
# ╟─dd89d250-925f-11eb-18ba-35b060cddaa3
# ╟─266416f4-9260-11eb-226b-4b8e377b7e18
# ╠═094375fa-e5b0-4eb9-a931-a06b001f3352
# ╠═4071488d-5278-4150-a81d-745825eab484
# ╠═605c2691-1584-4364-9c25-1369cc665b24
# ╠═8a91684a-4c14-488f-a526-0da1ed019389
# ╠═e2ea0b75-05ee-4c57-ba18-ab0915b49878
# ╟─5f0e371c-9260-11eb-2edf-9b5dd31992d8
# ╟─950c43d4-9260-11eb-0c8e-fdf5c93d8eae
