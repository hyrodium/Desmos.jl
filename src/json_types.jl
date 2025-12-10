abstract type AbstractDesmosExpression end

@defaults struct DesmosColumn
    id::String
    color::String
    values::Union{Vector{String}, Nothing} = nothing
    latex::Union{LaTeXString, Nothing} = nothing
    hidden::Union{Bool,Nothing} = nothing
end
JSON.omit_null(::Type{DesmosColumn}) = true

@defaults struct DesmosSlider
    hard_min::Bool &(json=(name="hardMin",),)
    hard_max::Bool &(json=(name="hardMax",),)
    animation_period::Float64 &(json=(name="animationPeriod",),)
    loop_mode::String &(json=(name="loopMode",),)
    min::String
    max::String
    step::String
end
JSON.omit_null(::Type{DesmosSlider}) = true

@defaults struct DesmosParametricDomain
    min::String
    max::String
end
JSON.omit_null(::Type{DesmosParametricDomain}) = true

@defaults struct DesmosDomain
    min::String
    max::String
end
JSON.omit_null(::Type{DesmosDomain}) = true

@defaults struct DesmosExpression <: AbstractDesmosExpression
    type::String
    id::String
    color::String
    latex::Union{LaTeXString, Nothing} = nothing
    slider::Union{DesmosSlider, Nothing} = nothing
    domain::Union{DesmosDomain, Nothing} = nothing
    parametric_domain::Union{DesmosParametricDomain, Nothing} = nothing &(json=(name="parametricDomain",),)
    folder_id::Union{String, Nothing} = nothing &(json=(name="folderId",),)
end
JSON.omit_null(::Type{DesmosExpression}) = true

@defaults struct DesmosTable <: AbstractDesmosExpression
    type::String
    id::String
    columns::Vector{DesmosColumn}
end
JSON.omit_null(::Type{DesmosTable}) = true

@defaults struct DesmosImage <: AbstractDesmosExpression
    type::String
    id::String
    image_url::String
    name::String
    height::String
    folder_id::Union{String, Nothing} = nothing &(json=(name="folderId",),)
end
JSON.omit_null(::Type{DesmosImage}) = true

@defaults struct DesmosText <: AbstractDesmosExpression
    type::String
    id::String
    text::Union{String, Nothing} = nothing
    folder_id::Union{String, Nothing} = nothing &(json=(name="folderId",),)
end
JSON.omit_null(::Type{DesmosText}) = true

@defaults struct DesmosFolder <: AbstractDesmosExpression
    type::String
    id::String
    title::Union{String, Nothing} = nothing
end
JSON.omit_null(::Type{DesmosFolder}) = true

@defaults struct DesmosExpressions
    list::Vector{AbstractDesmosExpression}
end

@defaults struct DesmosViewport
    xmin::Float64
    ymin::Float64
    xmax::Float64
    ymax::Float64
end

@defaults struct DesmosGraph
    viewport::DesmosViewport
    user_locked_viewport::Union{Bool,Nothing} = nothing &(json=(name="userLockedViewport",),)
    complex::Union{Bool,Nothing} = nothing
end
JSON.omit_null(::Type{<:DesmosGraph}) = true

@defaults struct DesmosState
    graph::DesmosGraph
    random_seed::String &(json=(name="randomSeed",),)
    expressions::DesmosExpressions
    version::Int = 11
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
