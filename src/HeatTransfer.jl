# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/HeatTransfer.jl/blob/master/LICENSE

"""
    Heat transfer problems for JuliaFEM.

## Equation to solve

## Problem types

- `PlaneHeat` for academic problems
- `Heat` for 3d continuum

## Parameters
"""
module HeatTransfer

using FEMBase

import FEMBase: get_unknown_field_name,
                get_formulation_type,
                assemble_elements!

type PlaneHeat <: FieldProblem
end

function get_unknown_field_name(::Problem{PlaneHeat})
    return "temperature"
end

function assemble_elements!{B}(problem::Problem{PlaneHeat}, assembly::Assembly,
                               elements::Vector{Element{B}}, time::Float64)

    for element in elements
        info("Not doing anything useful right now.")
    end

end

export PlaneHeat

end
