# RevisedAffineArithmetic

<!--[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://lucaferranti.github.io/RevisedAffineArithmetic.jl/stable)-->
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://lucaferranti.github.io/RevisedAffineArithmetic.jl/dev)
[![Build Status](https://github.com/lucaferranti/RevisedAffineArithmetic.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lucaferranti/RevisedAffineArithmetic.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/lucaferranti/RevisedAffineArithmetic.jl/branch/main/graph/badge.svg?token=U3a8R1AoMY)](https://codecov.io/gh/lucaferranti/RevisedAffineArithmetic.jl)

Experimental package for revised affine arithmetic.

### Quickstart

```julia
julia> using RevisedAffineArithmetic

julia> @rafvars x y z
0.0 + 1.0z

julia> p1 = 0.1 + 0.1x + 0.1y + 0.1z ± 0.1
0.1 + 0.1x + 0.1y + 0.1z ± 0.1

julia> p2 = 0.2 + 0.2x + 0.2y ± 0.2
0.2 + 0.2x + 0.2y ± 0.2

julia> p1 + p2
0.30000000000000004 + 0.30000000000000004x + 0.30000000000000004y + 0.1z ± 0.3000000000000002
```

### Author

- [Luca Ferranti](https://github.com/lucaferranti)

### References

- I. Skalna, Parametric Interval Algebraic Systems, Springer, 2018, sec. 2.2