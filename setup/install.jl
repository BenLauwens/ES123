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
catch exc
    @warn "Something went wrong, check one of the following:\n  - .gitignore file location\n  - destination folder already is a git repository"
end