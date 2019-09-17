# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTrasfer.jl/blob/master/LICENSE

using Documenter

deploydocs(
    repo = "github.com/JuliaFEM/HeatTransfer.jl.git",
    target = "build",
    deps = nothing,
    make = nothing)
