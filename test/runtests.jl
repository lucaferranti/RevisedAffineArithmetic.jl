using IntervalArithmetic
using RevisedAffineArithmetic
using StaticArrays
using Test

const RAA = RevisedAffineArithmetic

@testset "test constructor" begin
    c = 1.0
    e = @SVector [1.0, 2.0, 3.0]
    r = 0.1

    x1 = RevisedAffineForm(c, e, r)
    @test x1.c == c
    @test x1.ϵ == e
    @test x1.Δ == r

    @test RevisedAffineForm(1.0, e, big(0.1)) isa RevisedAffineForm{3,BigFloat}

    x2 = RevisedAffineForm(1, [1, 2, 3], 0.1)
    @test x1 == x2

    x3 = RevisedAffineForm(1, 3)
    @test x3.c === 1.0
    @test iszero(x3.ϵ)
    @test iszero(x3.Δ)

    c1 = Interval(0.1, 0.3)
    x4 = RevisedAffineForm(c1, 3)
    @test x4.c == mid(c1)
    @test iszero(x4.ϵ)
    @test x4.Δ == radius(c1)

    c2 = 0.1 .. 0.1
    e2 = [0.2 .. 0.2, 0.3 .. 0.3, 0.4 .. 0.4]
    x5 = RevisedAffineForm(c2, e2, 0)
    @test x5.Δ == sup(sum(Interval.(radius.(e2))) + radius(c2))

    x6 = x1 ± 1
    @test x6.c == x1.c
    @test x6.ϵ == x1.ϵ
    @test x6.Δ == 1.1

    @test string(x1) == "1.0 + 1.0ϵ₁ + 2.0ϵ₂ + 3.0ϵ₃ ± 0.1"
end

@testset "correcty rounded sum and dot product" begin
    a = [Interval(0.1), Interval(0.2), Interval(0.3)]
    b = [Interval(0.4), Interval(0.6), Interval(0.7)]
    am = mid.(a)
    bm = mid.(b)

    si = sum(a)
    di = dot(a, b)
    @test RAA._sum_up(am) == sup(si)
    @test RAA._sum_down(am) == inf(si)
    @test RAA._dot_up(am, bm) == sup(di)
    @test RAA._dot_down(am, bm) == inf(di)

    @test RAA._sum_up(abs, -am) == sup(si)
    @test RAA._sum_down(abs, -am) == inf(si)
    @test RAA._dot_up(abs, -am, -bm) == sup(di)
    @test RAA._dot_down(abs, -am, -bm) == inf(di)
end

@testset "conversion and promotion" begin
    x1 = convert(RevisedAffineForm{3}, 1)
    @test x1 isa RevisedAffineForm{3,Float64}
    @test x1.c == 1
    @test iszero(x1.ϵ)
    @test iszero(x1.Δ)

    @test convert(RevisedAffineForm{3}, big(1)) isa RevisedAffineForm{3,BigFloat}

    x1 = convert(RevisedAffineForm{3,Float32}, big(1))
    @test x1 isa RevisedAffineForm{3,Float32}
    @test x1.c == 1
    @test iszero(x1.ϵ)
    @test iszero(x1.Δ)

    x1 = convert(RevisedAffineForm{3}, 1 .. 2)
    @test x1 isa RevisedAffineForm{3,Float64}
    @test x1.c == mid(1 .. 2)
    @test iszero(x1.ϵ)
    @test x1.Δ == radius(1 .. 2)

    @test convert(RevisedAffineForm{3}, big(1 .. 2)) isa RevisedAffineForm{3,BigFloat}

    x1 = convert(RevisedAffineForm{3,Float32}, big(1 .. 2))
    @test x1 isa RevisedAffineForm{3,Float32}
    @test x1.c == 1.5
    @test iszero(x1.ϵ)
    @test x1.Δ == 0.5

    @test promote_type(RevisedAffineForm{2,Float64}, RevisedAffineForm{2,BigFloat}) ==
        RevisedAffineForm{2,BigFloat}

    @test promote_type(RevisedAffineForm{2,Float64}, BigInt) ==
        RevisedAffineForm{2,BigFloat}

    @test promote_type(RevisedAffineForm{2,Float64}, Interval{Rational{Int}}) ==
        RevisedAffineForm{2,Float64}
end

@testset "arithmetic operations" begin
    x = RevisedAffineForm(1, [1, 2, 3], 1)
    y = RevisedAffineForm(2, [3, 4, 5], 0.1)

    @test +x == x
    @test -x == RevisedAffineForm(-1, [-1, -2, -3], 1)

    @test x + y == RevisedAffineForm(3, [4, 6, 8], 1.1)
    @test x - y == RevisedAffineForm(-1, [-2, -2, -2], 1.1)

    @test x + 1 == RevisedAffineForm(2, [1, 2, 3], 1)
    @test x - 1 == RevisedAffineForm(0, [1, 2, 3], 1)
    @test 1 + x == RevisedAffineForm(2, [1, 2, 3], 1)
    @test 1 - x == RevisedAffineForm(0, [-1, -2, -3], 1)
    @test -2 * x == RevisedAffineForm(-2, [-2, -4, -6], 2)
    @test x * 2 == RevisedAffineForm(2, [2, 4, 6], 2)
    @test x / 2 == RevisedAffineForm(0.5, [0.5, 1, 1.5], 0.5)
end
