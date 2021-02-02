### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 41b66620-64d0-11eb-24a9-4f77cf2d6280
using Pkg

# ╔═╡ 7b921bd0-64a0-11eb-1683-998ca0325d4d
md"""# Introduction"""

# ╔═╡ 0d5727e0-64a1-11eb-2f03-ebae9b5bb6e6
md"""## Who are we?

* Lecturer: LCL IMM Ben Lauwens / D30.20 / [ben.lauwens@mil.be](ben.lauwens@mil.be)

* Assistant: CDT IMM François Dossogne / D30.25 / [francois.dossogne@mil.be](francois.dossogne@mil.be)"""

# ╔═╡ 4bfff530-64a1-11eb-2baa-270ad32c69f9
md"""## Programming Algorithms and Project

* Theory: 18 Hr 	→ 54 Hr (preparation of exercises)
* Exercises: 18 Hr 	→ 36 Hr (preparation of project)
* Project: 14 Hr 	→ 42 Hr (implementation of project)"""

# ╔═╡ ba22b0c2-64a1-11eb-2849-3d2d7f279e81
md"""## Documentation

* All notebooks can be found on github: [https://github.com/BenLauwens/ES123](https://github.com/BenLauwens/ES123)

* Complete book is available online: [https://benlauwens.github.io/ThinkJulia.jl/latest/book.html](https://benlauwens.github.io/ThinkJulia.jl/latest/book.html)."""

# ╔═╡ 1650e820-64a3-11eb-2e13-7b4fcebcdbc1
md"""## Schedule

### Theory

* 08/02: Ch 1 and Ch 2
* 11/02: Ch 3
* 18/02: Ch 4 and Ch 5
* 25/02: Ch 6 and Ch 7
* 04/03: Ch 8 and Ch 9
* 11/03: Ch 10
* 18/03: Ch 11 and Ch 12
* 25/03: Ch 13 and Ch 14
* 01/04: Ch 15, Ch 16 and Ch 17

### Exercises

* 22/02: Ch 1 and Ch 2
* 01/03: Ch 3
* 08/03: Ch 4 and Ch 5
* 15/03: Ch 6 and Ch 7
* 22/03: Ch 8 and Ch 9
* 29/03: Ch 10
* 12/04: Ch 11 and Ch 12
* 19/04: Ch 13 and Ch 14
* 22/04: Ch 15, Ch 16 and Ch 17

### Project

* 19/04: Project list available
* 22/04: Choice of project (groups of 2)
* 29/04: First contact: Understanding of the problem

We are always available during contact hours"""

# ╔═╡ b227f7b0-64a4-11eb-384b-8ba98563d161
md"""## Evaluation

Tests: 
* 18/03 - 2Hr: Exercises
* 06-10/05: Intermediate evaluation of project (group of 2)

Exam: final evaluation of project (individual)"""

# ╔═╡ 325b6010-64a6-11eb-06bb-dd521b29756f
md"""## Julia

* Install Julia on CDN laptop
* Install Notepad++ on CDN laptop with the [Julia plugin](https://github.com/JuliaEditorSupport/julia-NotepadPlusPlus)
* Start Julia REPL and install Pluto:

```julia
julia> using Pkg

julia> pkg"add Pluto"
```

* Start Pluto:

```julia
julia> using Pluto

julia> Pluto.run()
```

* Open [https://localhost:1234]()

* Extra packages you will need:
"""

# ╔═╡ 4b982750-64d0-11eb-04ef-bdf336df89ad
pkg"add PlutoUI"

# ╔═╡ 56a63380-64d0-11eb-33e1-09c879da551c
pkg"add https://github.com/BenLauwens/NativeSVG.jl.git"

# ╔═╡ Cell order:
# ╟─7b921bd0-64a0-11eb-1683-998ca0325d4d
# ╟─0d5727e0-64a1-11eb-2f03-ebae9b5bb6e6
# ╟─4bfff530-64a1-11eb-2baa-270ad32c69f9
# ╟─ba22b0c2-64a1-11eb-2849-3d2d7f279e81
# ╟─1650e820-64a3-11eb-2e13-7b4fcebcdbc1
# ╟─b227f7b0-64a4-11eb-384b-8ba98563d161
# ╟─325b6010-64a6-11eb-06bb-dd521b29756f
# ╠═41b66620-64d0-11eb-24a9-4f77cf2d6280
# ╠═4b982750-64d0-11eb-04ef-bdf336df89ad
# ╠═56a63380-64d0-11eb-33e1-09c879da551c
