@testset "variables macro" begin
    @rafvars x
    @test x == RevisedAffineForm(0, [1], 0)
    @test 1 + x ± 0.1 == RevisedAffineForm(1.0, @SVector([1.0]), 0.1)

    @rafvars x y z
    @test 1 + x + y + z ± 1 == RevisedAffineForm(1.0, @SVector([1.0, 1.0, 1.0]), 1.0)

    @rafvars x[1:4]
    p2 = 1 + x[1] + x[2] ± 2
    @test p2 == RevisedAffineForm(1.0, [1, 1, 0, 0], 2)
    @test string(p2) == "1.0 + 1.0x₁ + 1.0x₂ ± 2.0"
end
