abstract type AbstractDesmosExpression end

@kwarg struct DesmosColumn
    id::String
    color::String = "#000000"
    values::Union{Vector{String}, Nothing} = nothing
    latex::Union{LaTeXString, Nothing} = nothing
    hidden::Union{Bool,Nothing} = nothing
end
JSON.omit_null(::Type{DesmosColumn}) = true

@kwarg struct DesmosSlider
    hard_min::Bool &(json=(name="hardMin",),)
    hard_max::Bool &(json=(name="hardMax",),)
    animation_period::Float64 &(json=(name="animationPeriod",),)
    loop_mode::String &(json=(name="loopMode",),)
    min::String
    max::String
    step::String
end
JSON.omit_null(::Type{DesmosSlider}) = true

@kwarg struct DesmosParametricDomain
    min::String
    max::String
end
JSON.omit_null(::Type{DesmosParametricDomain}) = true

@kwarg struct DesmosDomain
    min::String
    max::String
end
JSON.omit_null(::Type{DesmosDomain}) = true

@kwarg struct DesmosExpression <: AbstractDesmosExpression
    type::String = "expression"
    id::String
    color::String = "#000000"
    latex::Union{LaTeXString, Nothing} = nothing
    slider::Union{DesmosSlider, Nothing} = nothing
    domain::Union{DesmosDomain, Nothing} = nothing
    parametric_domain::Union{DesmosParametricDomain, Nothing} = nothing &(json=(name="parametricDomain",),)
    folder_id::Union{String, Nothing} = nothing &(json=(name="folderId",),)
end
JSON.omit_null(::Type{DesmosExpression}) = true

@kwarg struct DesmosTable <: AbstractDesmosExpression
    type::String = "table"
    id::String
    columns::Vector{DesmosColumn}
end
JSON.omit_null(::Type{DesmosTable}) = true

@kwarg struct DesmosImage <: AbstractDesmosExpression
    type::String = "image"
    id::String
    image_url::String
    name::String
    height::String
    folder_id::Union{String, Nothing} = nothing &(json=(name="folderId",),)
end
JSON.omit_null(::Type{DesmosImage}) = true

@kwarg struct DesmosText <: AbstractDesmosExpression
    type::String = "text"
    id::String
    text::Union{String, Nothing} = nothing
    folder_id::Union{String, Nothing} = nothing &(json=(name="folderId",),)
end
JSON.omit_null(::Type{DesmosText}) = true

@kwarg struct DesmosFolder <: AbstractDesmosExpression
    type::String = "folder"
    id::String
    title::Union{String, Nothing} = nothing
end
JSON.omit_null(::Type{DesmosFolder}) = true

@kwarg struct DesmosExpressions
    list::Vector{AbstractDesmosExpression}
end

@kwarg struct DesmosViewport
    xmin::Float64
    ymin::Float64
    xmax::Float64
    ymax::Float64
end

@kwarg struct DesmosGraph
    viewport::Union{DesmosViewport, Nothing} = nothing
    user_locked_viewport::Union{Bool,Nothing} = nothing &(json=(name="userLockedViewport",),)
    complex::Union{Bool,Nothing} = nothing
end
JSON.omit_null(::Type{<:DesmosGraph}) = true

@kwarg struct DesmosState
    version::Int = 11
    random_seed::String = "00000000000000000000000000000000" &(json=(name="randomSeed",),)
    graph::DesmosGraph = DesmosGraph()
    expressions::DesmosExpressions
    include_function_parameters_in_random_seed::Bool = true &(json=(name="includeFunctionParametersInRandomSeed",),)
    do_not_migrate_movable_point_style::Bool = true &(json=(name="doNotMigrateMovablePointStyle",),)
end
JSON.omit_null(::Type{<:DesmosState}) = true

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
