using RevisedAffineArithmetic
using Documenter

DocMeta.setdocmeta!(
    RevisedAffineArithmetic, :DocTestSetup, :(using RevisedAffineArithmetic); recursive=true
)

makedocs(;
    modules=[RevisedAffineArithmetic],
    authors="Luca Ferranti",
    repo="https://github.com/lucaferranti/RevisedAffineArithmetic.jl/blob/{commit}{path}#{line}",
    sitename="RevisedAffineArithmetic.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://lucaferranti.github.io/RevisedAffineArithmetic.jl",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/lucaferranti/RevisedAffineArithmetic.jl", devbranch="main")
