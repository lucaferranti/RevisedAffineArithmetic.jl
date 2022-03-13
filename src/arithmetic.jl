#####################
# AFFINE OPERATIONS #
#####################

+(x::RevisedAffineForm) = x
-(x::RevisedAffineForm) = RevisedAffineForm(-x.c, -x.ϵ, x.Δ)

for op in (:+, :-)
    @eval function $op(x::RevisedAffineForm{N}, y::RevisedAffineForm{N}) where {N}
        c = $op(Interval(x.c), Interval(y.c))
        ϵ = $op(Interval.(x.ϵ), Interval.(y.ϵ))
        Δ = x.Δ ⊕₊ y.Δ
        return RevisedAffineForm(c, ϵ, Δ)
    end

    @eval function $op(x::RevisedAffineForm, a::Real)
        c = $op(Interval(x.c), Interval(a))
        Δ = x.Δ ⊕₊ radius(c)
        return RevisedAffineForm(mid(c), x.ϵ, Δ)
    end
end

+(a::Real, x::RevisedAffineForm) = x + a
-(a::Real, x::RevisedAffineForm) = -x + a

#########################
# NON-AFFINE OPERATIONS #
#########################
for (op, op_up) in ((:*, :mul_round), (:/, :div_round))
    @eval function $op(x::RevisedAffineForm, a::Real)
        c = $op(Interval(x.c), Interval(a))
        ϵ = $op(Interval.(x.ϵ), Interval(a))
        Δ = $op_up(x.Δ, float(abs(a)), RoundUp)
        return RevisedAffineForm(c, ϵ, Δ)
    end
end

*(a::Real, x::RevisedAffineForm) = *(x, a)

"""
Standard multiplication, see eq. (2.2) of section 2.2 of
*Iwona Skalna, Parametric Interval Algebraic Systems, Springer, 2018*
"""
function *(x::RevisedAffineForm{N}, y::RevisedAffineForm{N}) where {N}
    c = Interval(x.c) * Interval(y.c) + 0.5 * dot(Interval.(x.ϵ), Interval.(y.ϵ))
    ϵ = Interval(x.c) * Interval.(y.ϵ) + Interval(y.c) * Interval.(x.ϵ)
    Δ =
        abs(x.c) ⊗₊ y.Δ ⊕₊ abs(y.c) ⊗₊ x.Δ ⊕₊
        (_sum_up(abs, x.ϵ) ⊕₊ x.Δ) ⊗₊ (_sum_up(abs, y.ϵ) ⊕₊ y.Δ) ⊖₊
        0.5 ⊗₋ _dot_down(abs, x.ϵ, y.ϵ)
    return RevisedAffineForm(c, ϵ, Δ)
end

###########
# HELPERS #
###########

_sum_up(a) = reduce(⊕₊, a)
_sum_up(f, a) = mapreduce(f, ⊕₊, a)
_dot_up(a, b) = reduce(⊕₊, aᵢ ⊗₊ bᵢ for (aᵢ, bᵢ) in zip(a, b))
_dot_up(f, a, b) = reduce(⊕₊, f(aᵢ) ⊗₊ f(bᵢ) for (aᵢ, bᵢ) in zip(a, b))

_sum_down(a) = reduce(⊕₋, a)
_sum_down(f, a) = mapreduce(f, ⊕₋, a)
_dot_down(a, b) = reduce(⊕₋, aᵢ ⊗₋ bᵢ for (aᵢ, bᵢ) in zip(a, b))
_dot_down(f, a, b) = reduce(⊕₋, f(aᵢ) ⊗₋ f(bᵢ) for (aᵢ, bᵢ) in zip(a, b))
