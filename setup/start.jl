const downloadfolder = joinpath(homedir(),"Documents","ES123","Lectures")
ispath(downloadfolder) || error("Course is not installed.\nPlease run julia install.jl!")
cd(downloadfolder)

using Pkg
const deps = [pair.second for pair in Pkg.dependencies()]
const direct_deps = filter(p -> p.is_direct_dep, deps)
const pkgs = [x.name for x in direct_deps]
if "Pluto" ∉ pkgs
    @info "Installing Pluto for Julia $(VERSION)..."
    Pkg.add("Pluto")
end

@info "Start Pluto"
using Pluto
Pluto.run()