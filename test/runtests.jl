using IntervalArithmetic
using RevisedAffineArithmetic
using StaticArrays
using Test

const RAA = RevisedAffineArithmetic

include("test_affineform.jl")
include("test_arithmetic.jl")
include("test_conversions.jl")
include("test_vars.jl")
