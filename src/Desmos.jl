module Desmos

using JSON
using StructUtils
using Colors
using LaTeXStrings
using Latexify
using IntervalSets
using ImageIO
using FileIO
using Base64
using FixedPointNumbers

export @desmos

include("json_types.jl")
include("show.jl")
include("utils.jl")
include("latexify.jl")
include("macro.jl")

end # module
