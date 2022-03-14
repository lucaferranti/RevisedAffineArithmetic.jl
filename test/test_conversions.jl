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
