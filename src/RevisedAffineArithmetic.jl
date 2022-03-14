module RevisedAffineArithmetic

using FastRounding, IntervalArithmetic, StaticArrays

import Base: +, -, *, /, ==, convert, promote_rule
import IntervalArithmetic: ±

export RevisedAffineForm, ±, @rafvars

include("affineform.jl")
include("arithmetic.jl")
include("conversions.jl")
include("vars.jl")
end
