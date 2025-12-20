module Desmos

using JSON
# https://github.com/JuliaIO/JSON.jl/pull/418
using JSON.StructUtils: @kwarg
using Colors
using LaTeXStrings
using IntervalSets
using ImageIO
using FileIO
using Base64
using FixedPointNumbers
using InteractiveUtils
using DataFrames

export @desmos
export DesmosState
export set_desmos_display_config
export get_desmos_display_config
export clipboard_desmos_state

include("json_types.jl")
include("config.jl")
include("show.jl")
include("utils.jl")
include("latexify_symbols.jl")
include("latexify.jl")
include("macro.jl")
include("clipboard.jl")

end # module
