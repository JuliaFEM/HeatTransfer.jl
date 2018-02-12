# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTransfer.jl/blob/master/LICENSE

using FEMBase
using FEMBase.Test
using HeatTransfer

@testset "HeatTransfer.jl" begin

@testset "stiffness matrix and heat source" begin

    X = Dict(1 => [0.0,0.0], 2 => [1.0,0.0], 3 => [1.0,1.0], 4 => [0.0,1.0])
    el1 = Element(Quad4, [1, 2, 3, 4])
    update!(el1, "geometry", X)
    update!(el1, "thermal conductivity", 6.0)
    update!(el1, "heat source", 4.0)
    assembly = Assembly()
    problem = Problem(PlaneHeat, "test problem", 1)
    time = 0.0
    assemble_elements!(problem, assembly, [el1], time)
    K = full(assembly.K)
    f = full(assembly.f)
    K_expected = [
                   4.0 -1.0 -2.0 -1.0
                  -1.0  4.0 -1.0 -2.0
                  -2.0 -1.0  4.0 -1.0
                  -1.0 -2.0 -1.0  4.0
                 ]
    f_expected = [1.0; 1.0; 1.0; 1.0]
    @test isapprox(K, K_expected)
    @test isapprox(f, f_expected)
    @test get_unknown_field_name(problem) == "temperature"
end

@testset "heat flux, plane heat" begin
    X = Dict(1 => [0.0,0.0], 2 => [1.0,0.0])
    el2 = Element(Seg2, [1, 2])
    update!(el2, "geometry", X)
    update!(el2, "heat flux", 2.0)
    assembly = Assembly()
    problem = Problem(PlaneHeat, "test problem", 1)
    time = 0.0
    assemble_elements!(problem, assembly, [el2], time)
    f = full(assembly.f)
    f_expected = [1.0; 1.0]
    @test isapprox(f, f_expected)
end

@testset "heat flux, 3d heat" begin
    X = Dict(1 => [0.0,0.0,0.0], 2 => [1.0,0.0,0.0], 3 => [0.0,1.0,0.0])
    el = Element(Tri3, [1, 2, 3])
    update!(el, "geometry", X)
    update!(el, "heat flux", 6.0)
    assembly = Assembly()
    problem = Problem(Heat, "test problem", 1)
    time = 0.0
    assemble_elements!(problem, assembly, [el], time)
    f = full(assembly.f)
    f_expected = [1.0; 1.0; 1.0]
    @test isapprox(f, f_expected)
end

end
