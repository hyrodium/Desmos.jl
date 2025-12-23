using Documenter
using Desmos
using JSON

# Setup for doctests in docstrings
DocMeta.setdocmeta!(Desmos, :DocTestSetup, :(using Desmos))

makedocs(;
    modules = [Desmos],
    format = Documenter.HTML(
        ansicolor = true,
        canonical = "https://hyrodium.github.io/Desmos.jl/stable/",
        assets = ["assets/favicon.ico", "assets/custom.css"],
        edit_link = "main",
        repolink = "https://github.com/hyrodium/Desmos.jl",
    ),
    pages = [
        "Home" => "index.md",
        "Working with Desmos Text I/O" => "desmos-text-io.md",
        "Display Configuration" => "config.md",
        "Function Compatibility" => "function-compatibility.md",
        "Examples" => "examples.md",
        "Desmos.jl API" => "api.md",
        "License" => "license.md",
    ],
    repo = "https://github.com/hyrodium/Desmos.jl/blob/{commit}{path}#L{line}",
    sitename = "Desmos.jl",
    authors = "hyrodium <hyrodium@gmail.com>",
)

deploydocs(
    repo = "github.com/hyrodium/Desmos.jl",
    push_preview = true,
    devbranch = "main",
)
