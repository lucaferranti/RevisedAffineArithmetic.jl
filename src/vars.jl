const config = Dict(:names => Symbol[])

function _var_expr(i, n)
    return RevisedAffineForm(0, [i == j for j in 1:n], 0)
end

macro rafvars(x...)
    return _rafvars(x...)
end

function _rafvars(x::Symbol)
    rhs = _var_expr(1, 1)
    config[:names] = [x]
    return :($(esc(x)) = $rhs)
end

function _rafvars(x::Expr)
    s = x.args[1]
    start = x.args[2].args[2]
    stop = x.args[2].args[3]
    n = stop - start + 1
    rhs = [_var_expr(i, n) for i in start:stop]
    varnames = [Symbol(s, _lower(i)) for i in start:stop]
    config[:names] = varnames
    return :($(esc(s)) = $rhs)
end

function _rafvars(x...)
    n = length(x)
    ex = quote end
    for (i, s) in enumerate(x)
        rhs = _var_expr(i, n)
        push!(ex.args, :($(esc(s)) = $rhs))
    end
    config[:names] = collect(x)
    return ex
end
