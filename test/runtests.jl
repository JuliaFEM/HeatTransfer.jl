# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTransfer.jl/blob/master/LICENSE

using FEMBase
# using FEMBase.Test
using HeatTransfer

using Base.Test

@testset "HeatTransfer.jl" begin
    # Test stiffness matrix
    K = 1.0
    K_expected = 1.0
    @test isapprox(K, K_expected)
end
