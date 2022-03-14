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
