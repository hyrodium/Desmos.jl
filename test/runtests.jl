using Desmos
using Test
using JSON
using Aqua
using Colors
using LaTeXStrings
using DataFrames
using QuadraticOptimizer

Aqua.test_all(Desmos)

include("json_types.jl")
include("show.jl")
include("latexify.jl")
include("clipboard.jl")
include("generate_html.jl")
