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

macro affinize(block)
    if block.head == :tuple
        nvars = length(block.args)
        names = Vector{Symbol}(undef, nvars)
        ex = quote end
        for (i, var) in enumerate(block.args)
            name, rhs = _affinize(var, nvars, i)
            push!(ex.args, :($(esc(name)) = $rhs))
            names[i] = name
        end
        config[:names] = names
        return ex
    elseif block.head == :(=)
        name, rhs = _affinize(block, 1, 1)
        config[:names] = [name]
        return :($(esc(name)) = $rhs)
    else
        throw(ArgumentError("Invalid Statement"))
    end
end


function _affinize(ex::Expr, n::Int, i::Int)
    if ex.head == :(=)
        name = ex.args[1]
        p = eval(ex.args[2])
        c, r = midpoint_radius(p)
        coeffs = zeros(typeof(r), n)
        coeffs[i] = r
        return name, RevisedAffineForm(c, coeffs, 0)
    else
        throw(ArgumentError("Invalid Statement $ex"))
    end
end
