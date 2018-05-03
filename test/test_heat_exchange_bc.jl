# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTransfer.jl/blob/master/LICENSE

using HeatTransfer
using FEMBase
using FEMBase.Test

X = Dict(
    1 => [0.0,0.0],
    2 => [1.0,0.0])

T = Dict(
    1 => 0.0,
    2 => 0.0)

element = Element(Seg2, [1, 2])
update!(element, "geometry", X)
update!(element, "temperature", 0.0 => T)
update!(element, "heat transfer coefficient", 6.0)
update!(element, "external temperature", 1.0)
problem = Problem(PlaneHeat, "test problem", 1)
add_elements!(problem, [element])
assemble!(problem, 0.0)
K = full(problem.assembly.K)
f = full(problem.assembly.f)
@test isapprox(K, [2.0 1.0; 1.0 2.0])
@test isapprox(f, [3.0; 3.0])
