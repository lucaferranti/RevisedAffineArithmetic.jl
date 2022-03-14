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
