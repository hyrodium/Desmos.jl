module Desmos

using JSON
# https://github.com/JuliaIO/JSON.jl/pull/418
using JSON.StructUtils: @kwarg
using Colors
using LaTeXStrings
using Latexify
using IntervalSets
using ImageIO
using FileIO
using Base64
using FixedPointNumbers

export @desmos
export DesmosState

include("json_types.jl")
include("show.jl")
include("utils.jl")
include("latexify.jl")
include("macro.jl")

end # module
