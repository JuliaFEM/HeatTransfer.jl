# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/JuliaFEM.jl/blob/master/LICENSE.md

using JuliaFEM
using JuliaFEM.Testing

function get_model()
    X = Dict{Int, Vector{Float64}}(
        1 => [2.0, 3.0, 4.0],
        2 => [6.0, 3.0, 2.0],
        3 => [2.0, 5.0, 1.0],
        4 => [4.0, 3.0, 6.0])
    u = Dict{Int, Vector{Float64}}(
        1 => [0.0, 0.0, 0.0],
        2 => [0.0, 0.0, 0.0],
        3 => [0.0, 0.0, 0.0],
        4 => [0.25, 0.25, 0.25])
    e1 = Element(Tet4, [1, 2, 3, 4])
    e2 = Element(Tri3, [1, 2, 3])
    update!([e1, e2], "geometry", X)
    update!([e1, e2], "displacement", 0.0 => u)
    update!(e1, "youngs modulus", 96.0)
    update!(e1, "poissons ratio", 1.0/3.0)
    update!(e1, "density", 420.0)
    update!(e2, "displacement 1", 0.0)
    update!(e2, "displacement 2", 0.0)
    update!(e2, "displacement 3", 0.0)
    p1 = Problem(Elasticity, "test problem", 3)
    p1.properties.finite_strain = false
    p1.properties.geometric_stiffness = false
    p2 = Problem(Dirichlet, "boundary condition", 3, "displacement")
    push!(p1, e1)
    push!(p2, e2)
    solver = Solver(Modal)
    solver.properties.which = :LM
    push!(solver, p1, p2)
    return solver
end

@testset "test eigenvalues for single tet4 element" begin
    solver = get_model()
    solver()
    @test isapprox(solver.properties.eigvals, [4/3, 1/3])
end

@testset "test eigenvalues for single tet4 element, with geometric stiffness" begin
    solver = get_model()
    problem = first(solver.problems)
#   problem.properties.finite_strain = true
    problem.properties.geometric_stiffness = true
    solver.properties.geometric_stiffness = true
    solver()
    @test isapprox(solver.properties.eigvals, [5/3, 2/3])
end

@testset "test poisson problem modal analysis without tie" begin
    X = Dict{Int64, Vector{Float64}}(
        1 => [0.0, 0.0],
        2 => [1.0, 0.0],
        3 => [1.0, 3.0],
        4 => [0.0, 3.0],
        5 => [0.0, 3.0],
        6 => [1.0, 3.0],
        7 => [1.0, 9.0],
        8 => [0.0, 9.0])
    el1 = Element(Quad4, [1, 2, 3, 4])
    el2 = Element(Quad4, [4, 3, 7, 8])
    el3 = Element(Seg2, [1, 2])
    el4 = Element(Seg2, [7, 8])
    update!([el1, el2, el3, el4], "geometry", X)
    update!([el1, el2], "density", 6.0)
    update!([el1, el2], "temperature thermal conductivity", 36.0)
    update!([el3, el4], "temperature 1", 0.0)
    p1 = Problem(Heat, "combined body", 1)
    p1.properties.formulation = "2D"
    p2 = Problem(Dirichlet, "fixed ends", 1, "temperature")
    push!(p1, el1, el2)
    push!(p2, el3, el4)
    solver = Solver(Modal)
    push!(solver, p1, p2)
    solver()
    @test isapprox(solver.properties.eigvals[1], 1.0)
end

@testset "test poisson modal problem with mesh tie" begin
    X = Dict{Int64, Vector{Float64}}(
        1 => [0.0, 0.0],
        2 => [1.0, 0.0],
        3 => [1.0, 3.0],
        4 => [0.0, 3.0],
        5 => [0.0, 3.0],
        6 => [1.0, 3.0],
        7 => [1.0, 9.0],
        8 => [0.0, 9.0])
    el1 = Element(Quad4, [1, 2, 3, 4])
    el2 = Element(Quad4, [5, 6, 7, 8])
    el3 = Element(Seg2, [1, 2])
    el4 = Element(Seg2, [7, 8])
    el5 = Element(Seg2, [3, 4])
    el6 = Element(Seg2, [5, 6])
    update!([el1, el2, el3, el4, el5, el6], "geometry", X)
    update!([el1, el2], "density", 6.0)
    update!([el1, el2], "temperature thermal conductivity", 36.0)
    update!([el3, el4], "temperature 1", 0.0)
    update!(el5, "master elements", [el6])
    p1 = Problem(Heat, "body 1", 1)
    p2 = Problem(Heat, "body 2", 1)
    p1.properties.formulation = "2D"
    p2.properties.formulation = "2D"
    p3 = Problem(Dirichlet, "fixed ends", 1, "temperature")
    p4 = Problem(Mortar, "interface between bodies", 1, "temperature")
    p4.properties.dimension = 1
    push!(p1, el1)
    push!(p2, el2)
    push!(p3, el3, el4)
    push!(p4, el5, el6)
    solver = Solver(Modal)
    push!(solver, p1, p2, p3, p4)
    solver()
    @test isapprox(solver.properties.eigvals[1], 1.0)
end
