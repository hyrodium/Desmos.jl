abstract type AbstractDesmosExpression end

@omit_null @kwarg struct DesmosColumn
    id::String
    color::String = "#000000"
    values::Union{Vector{String}, Nothing} = nothing
    latex::Union{LaTeXString, Nothing} = nothing
    hidden::Union{Bool, Nothing} = nothing
end

@omit_null @kwarg struct DesmosSlider
    hard_min::Bool & (json = (name = "hardMin",),)
    hard_max::Bool & (json = (name = "hardMax",),)
    animation_period::Union{Float64, Nothing} = nothing & (json = (name = "animationPeriod",),)
    loop_mode::Union{String, Nothing} = nothing & (json = (name = "loopMode",),)
    min::String
    max::String
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
end

@omit_null @kwarg struct DesmosExpression <: AbstractDesmosExpression
    type::String = "expression"
    id::String
    color::String = "#000000"
    show_label::Union{Bool, Nothing} = nothing & (json = (name = "showLabel",),)
    lines::Union{Bool, Nothing} = nothing
    line_style::Union{String, Nothing} = nothing & (json = (name = "lineStyle",),)
    point_style::Union{String, Nothing} = nothing & (json = (name = "pointStyle",),)
    point_outline::Union{Bool, Nothing} = nothing & (json = (name = "pointOutline",),)
    line_opacity::Union{LaTeXString, Nothing} = nothing & (json = (name = "lineOpacity",),)
    line_width::Union{LaTeXString, Nothing} = nothing & (json = (name = "lineWidth",),)
    clickable_info::Union{DesmosClickableInfo, Nothing} = nothing & (json = (name = "clickableInfo",),)
    hidden::Union{Bool, Nothing} = nothing
    latex::Union{LaTeXString, Nothing} = nothing
    slider::Union{DesmosSlider, Nothing} = nothing
    domain::Union{DesmosDomain, Nothing} = nothing
    parametric_domain::Union{DesmosParametricDomain, Nothing} = nothing & (json = (name = "parametricDomain",),)
    folder_id::Union{String, Nothing} = nothing & (json = (name = "folderId",),)
end

@omit_null @kwarg struct DesmosTable <: AbstractDesmosExpression
    type::String = "table"
    id::String
    columns::Vector{DesmosColumn}
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
end

@omit_null @kwarg struct DesmosExpressions
    list::Vector{AbstractDesmosExpression}
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
end

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
