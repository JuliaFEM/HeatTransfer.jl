# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTransfer.jl/blob/master/LICENSE

using Documenter, HeatTransfer

makedocs(modules=[HeatTransfer],
         format = :html,
         checkdocs = :all,
         sitename = "HeatTransfer.jl",
         pages = ["index.md"]
        )
