##############
# CONVERSION #
##############

function convert(::Type{RevisedAffineForm{N}}, x::T) where {N,T<:Real}
    TS = float(T)
    return RevisedAffineForm(x, SVector{N,TS}(zeros(TS, N)), zero(TS))
end

function convert(::Type{RevisedAffineForm{N}}, x::Interval{T}) where {N,T<:AbstractFloat}
    c, r = midpoint_radius(x)
    return RevisedAffineForm(c, SVector{N,T}(zeros(T, N)), r)
end

function convert(::Type{RevisedAffineForm{N,T}}, x::Real) where {N,T<:AbstractFloat}
    return RevisedAffineForm(convert(T, x), SVector{N,T}(zeros(T, N)), zero(T))
end

function convert(::Type{RevisedAffineForm{N,T}}, x::Interval) where {N,T<:AbstractFloat}
    c, r = midpoint_radius(x)
    return RevisedAffineForm(convert(T, c), SVector{N,T}(zeros(T, N)), convert(T, r))
end

#############
# PROMOTION #
#############

function promote_rule(
    ::Type{RevisedAffineForm{N,T}}, ::Type{Interval{S}}
) where {N,T<:AbstractFloat,S<:Real}
    return RevisedAffineForm{N,promote_type(T, S)}
end

function promote_rule(
    ::Type{RevisedAffineForm{N,T}}, ::Type{S}
) where {N,T<:AbstractFloat,S<:Real}
    return RevisedAffineForm{N,promote_type(T, S)}
end

function promote_rule(
    ::Type{RevisedAffineForm{N,T}}, ::Type{RevisedAffineForm{N,S}}
) where {N,T<:AbstractFloat,S<:AbstractFloat}
    return RevisedAffineForm{N,promote_type(T, S)}
end
