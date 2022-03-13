struct RevisedAffineForm{N,T<:AbstractFloat}
    c::T
    ϵ::SVector{N,T}
    Δ::T
end

function RevisedAffineForm(
    c::T, ϵ::SVector{N,S}, Δ::R
) where {T<:AbstractFloat,N,S<:AbstractFloat,R<:AbstractFloat}
    Q = promote_type(T, S, R)
    return RevisedAffineForm(convert(Q, c), convert(SVector{N,Q}, ϵ), convert(Q, Δ))
end

function RevisedAffineForm(
    c::Interval{T}, ϵ::SVector{N,Interval{T}}, Δ::T
) where {N,T<:AbstractFloat}
    Δ = Δ ⊕₊ radius(c)
    @inbounds for ϵᵢ in ϵ
        Δ = Δ ⊕₊ radius(ϵᵢ)
    end
    return RevisedAffineForm(mid(c), mid.(ϵ), Δ)
end

RevisedAffineForm(c, ϵ, Δ) = RevisedAffineForm(float(c), SVector(float(ϵ)...), float(Δ))

function RevisedAffineForm(x::T, n::Int) where {T<:Real}
    TS = float(T)
    return RevisedAffineForm(convert(TS, x), SVector{n,TS}(zeros(TS, n)), zero(TS))
end

function RevisedAffineForm(x::Interval{T}, n::Int) where {T<:AbstractFloat}
    c, r = midpoint_radius(x)
    return RevisedAffineForm(c, SVector{n,T}(zeros(T, n)), r)
end

function ±(x::RevisedAffineForm, Δ::Real)
    Δ < 0 && throw(ArgumentError("cumulated error must be non-negative"))
    return RevisedAffineForm(x.c, x.ϵ, x.Δ ⊕₊ float(Δ))
end

############
# PRINTING #
############

function _lower(n::Int)
    idx = ('₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉')
    s = ""
    ds = reverse!(digits(n))
    for d in ds
        s *= idx[d + 1]
    end
    return s
end

function Base.show(io::IO, x::RevisedAffineForm{N}) where {N}
    print(io, x.c)
    names = isempty(config[:names]) ? ['ϵ' * _lower(i) for i in 1:N] : config[:names]
    @inbounds for (e, n) in zip(x.ϵ, names)
        iszero(e) && continue
        print(io, e > 0 ? " + " : " - ")
        print(io, abs(e), n)
    end
    x.Δ > 0 && print(io, " ± ", x.Δ)
    return nothing
end

############
# EQUALITY #
############
function ==(x::RevisedAffineForm{N}, y::RevisedAffineForm{N}) where {N}
    return x.c == y.c && x.ϵ == y.ϵ && x.Δ == y.Δ
end
