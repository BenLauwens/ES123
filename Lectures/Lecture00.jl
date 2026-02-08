### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 7b921bd0-64a0-11eb-1683-998ca0325d4d
md"""# Introduction"""

# ╔═╡ 0d5727e0-64a1-11eb-2f03-ebae9b5bb6e6
md"""## Who are we?

* Lecturer: COL IMM Ben Lauwens / D30.19 / [ben.lauwens@mil.be](mailto:ben.lauwens@mil.be)

* Responsable Projects: Mr Philippe Blondeel / D30.14 / [philippe.blondeel@mil.be](mailto:philippe.blondeel@mil.be)

* Assistant: MAJ Piet Van Der Paelt / D30.17 / [piet.vanderpaelt@mil.be](mailto:piet.vanderpaelt@mil.be)"""

# ╔═╡ 4bfff530-64a1-11eb-2baa-270ad32c69f9
md"""## Programming Algorithms and Project

* Theory: 16 Hr 	→ 48 Hr (preparation of exercises)
* Exercises: 16 Hr 	→ 32 Hr (preparation of project)
* Project: 28 Hr 	→ 56 Hr (implementation of project)"""

# ╔═╡ ba22b0c2-64a1-11eb-2849-3d2d7f279e81
md"""## Documentation

* All notebooks can be found on github: [https://github.com/BenLauwens/ES123/Lectures](https://github.com/BenLauwens/ES123/Lectures)

* Complete book from 2019 is available online (lecture notes are more recent and include supplementary information): [https://benlauwens.github.io/ThinkJulia.jl/latest/book.html](https://benlauwens.github.io/ThinkJulia.jl/latest/book.html)."""

# ╔═╡ 1650e820-64a3-11eb-2e13-7b4fcebcdbc1
md"""## Schedule

|Lectures|Theory|Exercises|Project|
|:-------|:-----|:--------|:------|
|1/2|09/02|20/02|       |
|3/4|13/02|27/02|       |
|5/6|16/02|06/03|       |
|7/8|02/03|13/03|      |
|9/10|09/03|20/03|      |
|11/12|16/03|27/03|      |
|13/14/15|23/03|17/04||
|16/17/18|30/03|24/04|      |
|Project|      |         |30/03-31/03|
|Project|      |         |13/04-14/04|
|Project|      |         |20/04-21/04|
|Project|      |         |27/04-28/04|
|Project|      |         |04/05-05/05|
|Project|      |         |08/05|


We are always available during contact hours"""

# ╔═╡ b227f7b0-64a4-11eb-384b-8ba98563d161
md"""## Evaluation

Test:
- 19/03 - 2Hr: Exercises
- 04-05-08/05: Presentation project common part (group)

Exam: 4Hr Exercises + written report project individual part"""

# ╔═╡ 325b6010-64a6-11eb-06bb-dd521b29756f
md"""## Julia

* Install Julia on CDN laptop
* Save following code to a file `start.jl` in the `Downloads` folder:
```julia
const downloadfolder = joinpath(homedir(),"Documents")
!ispath(downloadfolder) ? mkdir(downloadfolder) : nothing
cd(downloadfolder)

using Pkg
const deps = [pair.second for pair in Pkg.dependencies()]
const direct_deps = filter(p -> p.is_direct_dep, deps)
const pkgs = [x.name for x in direct_deps]
if "Git" ∉ pkgs
    @info "Installing Git tools for Julia $(VERSION)..."
    Pkg.add("Git")
end

@info "Downloading course material into $(downloadfolder)"
using Git
try
    run(`$(git()) clone https://github.com/BenLauwens/ES123.git`)
    @info "Download complete"
catch err
    @warn "Something went wrong, check one of the following:\n  - .gitignore file location\n  - destination folder already is a git repository"
    @info err
end
```
* Start Julia and enter following command in the REPL when your laptop is connected to a network without proxy, i.e. not to CDN:
```
julia> include(joinpath(homedir(),"Downloads","install.jl"))
```
"""

# ╔═╡ 12ec8511-9c21-4509-8ba8-b3141f7d5705
md"""## Pluto Notebook interface

The browser based interface can be started from the Julia REPL with the following command:
```
julia> include(joinpath(homedir(),"Documents","ES123","setup","start.jl"))
```
!!! tip
    Please copy the lectures files from `Lectures` to `work` and open the files in the `work` directory. 
"""

# ╔═╡ 780f0527-14a8-494f-9c08-3819dd06dc50
md"""## Updating the Lectures

Enter the following command in the Julia REPL when your laptop is connected to a network without proxy to update the lectures:
```
julia> include(joinpath(homedir(),"Downloads","update.jl"))
```
!!! warning
    Be warned, all local changes except those in the `work` directory will be deleted!
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.4"
manifest_format = "2.0"
project_hash = "71853c6197a6a7f222db0f1978c7cb232b87c5ee"

[deps]
"""

# ╔═╡ Cell order:
# ╟─7b921bd0-64a0-11eb-1683-998ca0325d4d
# ╟─0d5727e0-64a1-11eb-2f03-ebae9b5bb6e6
# ╟─4bfff530-64a1-11eb-2baa-270ad32c69f9
# ╟─ba22b0c2-64a1-11eb-2849-3d2d7f279e81
# ╟─1650e820-64a3-11eb-2e13-7b4fcebcdbc1
# ╟─b227f7b0-64a4-11eb-384b-8ba98563d161
# ╟─325b6010-64a6-11eb-06bb-dd521b29756f
# ╟─12ec8511-9c21-4509-8ba8-b3141f7d5705
# ╟─780f0527-14a8-494f-9c08-3819dd06dc50
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
