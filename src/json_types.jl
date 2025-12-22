abstract type AbstractDesmosExpression end

@omit_null @kwarg struct DesmosColumn
    id::String
    color::String = "#000000"
    values::Union{Vector{String}, Nothing} = nothing
    latex::Union{LaTeXString, Nothing} = nothing
    hidden::Union{Bool, Nothing} = nothing
    lines::Union{Bool, Nothing} = nothing
    point_outline::Union{Bool, Nothing} = nothing & (json = (name = "pointOutline",),)
    # Note: __stashed_V12PointStyle is an internal field used by Desmos v12+ and is intentionally ignored
end

@omit_null @kwarg struct DesmosRegressionColumnIds
    x::String
    y::String
end

@omit_null @kwarg struct DesmosRegression
    type::String
    column_ids::DesmosRegressionColumnIds & (json = (name = "columnIds",),)
    id::String
    color::String = "#000000"
    line_style::Union{String, Nothing} = nothing & (json = (name = "lineStyle",),)
    hidden::Union{Bool, Nothing} = nothing
    is_log_mode::Union{Bool, Nothing} = nothing & (json = (name = "isLogMode",),)
    residual_variable::Union{String, Nothing} = nothing & (json = (name = "residualVariable",),)
end

@omit_null @kwarg struct DesmosInferenceSignificance
    tails::Union{String, Nothing} = nothing
    hypothesis::Union{String, Nothing} = nothing
    show::Union{Bool, Nothing} = nothing
end

@omit_null @kwarg struct DesmosInferenceConfidence
    confidence_level::Union{String, Nothing} = nothing & (json = (name = "confidenceLevel",),)
    show::Union{Bool, Nothing} = nothing
end

@omit_null @kwarg struct DesmosInference
    significance::Union{DesmosInferenceSignificance, Nothing} = nothing
    confidence::Union{DesmosInferenceConfidence, Nothing} = nothing
end

@omit_null @kwarg struct DesmosSlider
    hard_min::Union{Bool, Nothing} = nothing & (json = (name = "hardMin",),)
    hard_max::Union{Bool, Nothing} = nothing & (json = (name = "hardMax",),)
    animation_period::Union{Float64, Nothing} = nothing & (json = (name = "animationPeriod",),)
    loop_mode::Union{String, Nothing} = nothing & (json = (name = "loopMode",),)
    play_direction::Union{Int, Nothing} = nothing & (json = (name = "playDirection",),)
    min::Union{String, Nothing} = nothing
    max::Union{String, Nothing} = nothing
    step::Union{String, Nothing} = nothing
end

@omit_null @kwarg struct DesmosParametricDomain
    min::String
    max::String
end

@omit_null @kwarg struct DesmosDomain
    min::LaTeXString
    max::LaTeXString
end

@omit_null @kwarg struct DesmosClickableInfo
    enabled::Bool
    latex::Union{LaTeXString, Nothing} = nothing
end

@omit_null @kwarg struct DesmosExpression <: AbstractDesmosExpression
    type::String = "expression"
    id::String
    color::String = "#000000"
    show_label::Union{Bool, Nothing} = nothing & (json = (name = "showLabel",),)
    label_size::Union{String, Nothing} = nothing & (json = (name = "labelSize",),)
    lines::Union{Bool, Nothing} = nothing
    line_style::Union{String, Nothing} = nothing & (json = (name = "lineStyle",),)
    point_style::Union{String, Nothing} = nothing & (json = (name = "pointStyle",),)
    point_outline::Union{Bool, Nothing} = nothing & (json = (name = "pointOutline",),)
    line_opacity::Union{LaTeXString, Nothing} = nothing & (json = (name = "lineOpacity",),)
    line_width::Union{LaTeXString, Nothing} = nothing & (json = (name = "lineWidth",),)
    fill_opacity::Union{LaTeXString, Nothing} = nothing & (json = (name = "fillOpacity",),)
    clickable_info::Union{DesmosClickableInfo, Nothing} = nothing & (json = (name = "clickableInfo",),)
    hidden::Union{Bool, Nothing} = nothing
    latex::Union{LaTeXString, Nothing} = nothing
    slider::Union{DesmosSlider, Nothing} = nothing
    domain::Union{DesmosDomain, Nothing} = nothing
    parametric_domain::Union{DesmosParametricDomain, Nothing} = nothing & (json = (name = "parametricDomain",),)
    folder_id::Union{String, Nothing} = nothing & (json = (name = "folderId",),)
    color_latex::Union{LaTeXString, Nothing} = nothing & (json = (name = "colorLatex",),)
    display_evaluation_as_fraction::Union{Bool, Nothing} = nothing & (json = (name = "displayEvaluationAsFraction",),)
    residual_variable::Union{String, Nothing} = nothing & (json = (name = "residualVariable",),)
    regression_parameters::Union{Dict{String, Float64}, Nothing} = nothing & (json = (name = "regressionParameters",),)
    inference::Union{DesmosInference, Nothing} = nothing
end

@omit_null @kwarg struct DesmosTable <: AbstractDesmosExpression
    type::String = "table"
    id::String
    columns::Vector{DesmosColumn}
    regression::Union{DesmosRegression, Nothing} = nothing
    folder_id::Union{String, Nothing} = nothing & (json = (name = "folderId",),)
end

@omit_null @kwarg struct DesmosImage <: AbstractDesmosExpression
    type::String = "image"
    id::String
    image_url::String
    hidden::Union{Bool, Nothing} = nothing
    name::Union{String, Nothing} = nothing
    width::Union{String, Nothing} = nothing
    height::Union{String, Nothing} = nothing
    center::Union{LaTeXString, Nothing} = nothing
    angle::Union{String, Nothing} = nothing
    opacity::Union{String, Nothing} = nothing
    forground::Union{Bool, Nothing} = nothing
    draggable::Union{Bool, Nothing} = nothing
    description::Union{String, Nothing} = nothing
    folder_id::Union{String, Nothing} = nothing & (json = (name = "folderId",),)
end

@omit_null @kwarg struct DesmosText <: AbstractDesmosExpression
    type::String = "text"
    id::String
    text::Union{String, Nothing} = nothing
    folder_id::Union{String, Nothing} = nothing & (json = (name = "folderId",),)
end

@omit_null @kwarg struct DesmosFolder <: AbstractDesmosExpression
    type::String = "folder"
    id::String
    title::Union{String, Nothing} = nothing
    hidden::Union{Bool, Nothing} = nothing
    collapsed::Union{Bool, Nothing} = nothing
end

@omit_null @kwarg struct DesmosTicker
    handler_latex::Union{String, Nothing} = nothing & (json = (name = "handlerLatex",),)
    min_step_latex::Union{String, Nothing} = nothing & (json = (name = "minStepLatex",),)
    open::Union{Bool, Nothing} = nothing
end

@omit_null @kwarg struct DesmosExpressions
    list::Vector{AbstractDesmosExpression}
    ticker::Union{DesmosTicker, Nothing} = nothing
end

@omit_null @kwarg struct DesmosViewport
    xmin::Float64
    ymin::Float64
    xmax::Float64
    ymax::Float64
end

@omit_null @kwarg struct DesmosGraph
    viewport::Union{DesmosViewport, Nothing} = nothing
    user_locked_viewport::Union{Bool, Nothing} = nothing & (json = (name = "userLockedViewport",),)
    complex::Union{Bool, Nothing} = nothing
    square_axes::Union{Bool, Nothing} = nothing & (json = (name = "squareAxes",),)
    # Note: __v12ViewportLatexStash is an internal field used by Desmos v12+ and is intentionally ignored
end

"""
    DesmosState

Represents the complete state of a Desmos graph, including all expressions, viewport settings, and configuration options.

`DesmosState` is typically created using the [`@desmos`](@ref) macro rather than constructed directly.
The state object can be serialized to JSON format compatible with the Desmos API, and can be displayed directly in Jupyter notebooks or VSCode.

# Fields

- `version::Int`: Desmos API version (default: `11`)
- `random_seed::String`: Random seed for reproducibility (default: `"00000000000000000000000000000000"`)
- `graph::DesmosGraph`: Graph configuration including viewport settings
- `expressions::DesmosExpressions`: Collection of all expressions, text, images, etc.

# Examples

```julia
using Desmos

# Create using @desmos macro (recommended)
state = @desmos begin
    @text "Example graph"
    sin(x)
    cos(x)
end

# Serialize to JSON
using JSON
json_string = JSON.json(state)

# Display in Jupyter/VSCode
display(state)  # Shows interactive Desmos graph
```

# JSON I/O

`DesmosState` can be parsed from JSON files exported from Desmos:

```julia
using JSON

# Read from file
json_data = read("graph.json", String)
state = JSON.parse(json_data, DesmosState)

# Write to file
write("graph.json", JSON.json(state, 4))
```

# See also
- [`@desmos`](@ref): Macro for creating `DesmosState` objects
"""
@omit_null @kwarg struct DesmosState
    version::Int = 11
    random_seed::String = "00000000000000000000000000000000" & (json = (name = "randomSeed",),)
    graph::DesmosGraph = DesmosGraph()
    expressions::DesmosExpressions
    include_function_parameters_in_random_seed::Bool = true & (json = (name = "includeFunctionParametersInRandomSeed",),)
    do_not_migrate_movable_point_style::Bool = true & (json = (name = "doNotMigrateMovablePointStyle",),)
end

JSON.@choosetype AbstractDesmosExpression x -> if x.type[] == "expression"
    DesmosExpression
elseif x.type[] == "table"
    DesmosTable
elseif x.type[] == "image"
    DesmosImage
elseif x.type[] == "text"
    DesmosText
elseif x.type[] == "folder"
    DesmosFolder
end
