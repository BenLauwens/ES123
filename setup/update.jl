const downloadfolder = joinpath(homedir(),"Documents","ES123")
ispath(downloadfolder) || error("Course is not installed.\nPlease run julia install.jl!")
cd(downloadfolder)

using Pkg
const deps = [pair.second for pair in Pkg.dependencies()]
const direct_deps = filter(p -> p.is_direct_dep, deps)
const pkgs = [x.name for x in direct_deps]
if "Git" ∉ pkgs
    @info "Installing Git tools for Julia $(VERSION)..."
    Pkg.add("Git")
end

@info "Updating course material in $(downloadfolder)"
using Git
Git.run(`$(git()) stash`)
Git.run(`$(git()) config pull.rebase false`)
Git.run(`$(git()) pull`)