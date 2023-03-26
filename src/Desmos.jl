module Desmos

using Colors
using LaTeXStrings
using Latexify
using IntervalSets
using JSON
using ImageIO
using FileIO
using Base64

export @desmos

abstract type DesmosElement end

struct DesmosExpression <: DesmosElement
    color::Color
    latex::LaTeXString
end

struct DesmosDiscreteVariable <: DesmosElement
    latex::LaTeXString
    range::AbstractRange
end

struct DesmosContinuousVariable <: DesmosElement
    latex::LaTeXString
    range::ClosedInterval
end

struct DesmosImage <: DesmosElement
    url::String
    width::LaTeXString
    height::LaTeXString
    center::LaTeXString
end

struct DesmosTable <: DesmosElement
    column::Vector{LaTeXString}
end

struct DesmosState
    expressions::Vector{DesmosElement}
end

macro variable(ex1, ex2)
    ex1.head === :(=) || error("invalid variable definition")
    if ex2.args[1] === :(..)
        return DesmosContinuousVariable(_latexify(ex1), eval(ex2))
    else
        return DesmosDiscreteVariable(_latexify(ex1), eval(ex2))
    end
end

macro variable(ex1)
    ex1.head === :(=) || error("invalid variable definition")
    v = ex1.args[2]
    return DesmosContinuousVariable(_latexify(ex1), v..v)
end

macro expression(ex, kwargs...)
    color = :(RGB(0,0,0))
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :color
                color = kwarg.args[2]
            end
        end
    end
    return DesmosExpression(eval(color), _latexify(ex))
end

macro color(ex1, ex2)
    return DesmosExpression(eval(ex2), _latexify(ex1))
end

macro raw_expression(ex)
    return DesmosExpression(RGB(0,0,0), eval(ex))
end

macro image(ex, kwargs...)
    width = :(2)
    height = :(2)
    center = :((0,0))
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :width
                width = kwarg.args[2]
            elseif kwarg.args[1] == :height
                height = kwarg.args[2]
            elseif kwarg.args[1] == :center
                center = kwarg.args[2]
            end
        end
    end
    return DesmosImage(create_url(ex), _latexify(width), _latexify(height), _latexify(center))
end

macro table(args...)
    return DesmosTable([_latexify.(args)...])
end

function _latexify(ex::Number)
    return latexify(ex)
end

function _latexify(ex::Symbol)
    return latexify(ex)
end

function _latexify(ex)
    lstr = latexify(ex)
    if ex.head === :(tuple)
        lstr = removedollar(lstr)
        lstr = LaTeXString("\$("*lstr*")\$")
    end
    lstr = remove_mathrm(lstr)
end

function create_url(url::AbstractString)
    return url
end

function create_url(img::AbstractMatrix{<:Colorant})
    img_buf = IOBuffer()
    save(Stream{format"PNG"}(img_buf), img)
    url = "data:image/png;base64, $(base64encode(take!(img_buf)))"
    return url
end

eval_dollar!(::Module, ex) = ex
function eval_dollar!(target_module::Module, ex::Expr)
    if ex.head === :($)
        return Core.eval(target_module, Expr(:quote, ex))
    elseif ex.head !== :quote
        for i in 1:length(ex.args)
            ex.args[i] = eval_dollar!(target_module, ex.args[i])
        end
    end
    return ex
end

macro desmos(ex)
    eval_dollar!(__module__, ex)
    v = DesmosElement[]
    for e in ex.args
        if e isa Expr
            if e.head === :macrocall
                push!(v, eval(e))
            elseif e.head === :(=)
                push!(v, DesmosExpression(RGB(0,0,0), _latexify(e)))
            elseif e.head === :(tuple)
                push!(v, DesmosExpression(RGB(0,0,0), _latexify(e)))
            elseif e.head === :call
                push!(v, DesmosExpression(RGB(0,0,0), _latexify(e)))
            else
                @warn "unsupported element"
                dump(e)
            end
        elseif e isa Integer
            push!(v, DesmosExpression(RGB(0,0,0), _latexify(e)))
        elseif e isa Symbol
            push!(v, DesmosExpression(RGB(0,0,0), _latexify(e)))
        end
    end
    return DesmosState(v)
end

function removedollar(s::LaTeXString)
    return chopsuffix(chopprefix(s, "\$"), "\$")
end

function remove_mathrm(s::Union{LaTeXString, SubString{LaTeXStrings.LaTeXString}})
    return replace(s, "\\mathrm"=>"")
end

function convert_dict(i::Integer, e::DesmosExpression)
    return Dict([
        "type" => "expression",
        "id" => string(i),
        "color" => "#$(hex(e.color))",
        "latex" => removedollar(e.latex)
    ]), i+1
end

function convert_dict(i::Integer, e::DesmosContinuousVariable)
    return Dict([
        "type" => "expression",
        "id" => string(i),
        "latex" => removedollar(e.latex),
        "slider" => Dict([
            "hardMin" => true,
            "hardMax" => true,
            "min" => minimum(e.range),
            "max" => maximum(e.range),
        ])
    ]), i+1
end

function convert_dict(i::Integer, e::DesmosDiscreteVariable)
    return Dict([
        "type" => "expression",
        "id" => string(i),
        "latex" => removedollar(e.latex),
        "slider" => Dict([
            "hardMin" => true,
            "hardMax" => true,
            "min" => minimum(e.range),
            "max" => maximum(e.range),
            "step" => step(e.range),
        ])
    ]), i+1
end

function convert_dict(i::Integer, e::DesmosImage)
    return Dict([
        "type" => "image",
        "id" => string(i),
        "image_url" => e.url,
        "name" => "image from Desmos.jl",
        "center"=> removedollar(e.center),
        "width" => removedollar(e.width),
        "height" => removedollar(e.height),
    ]), i+1
end

function convert_dict(i::Integer, e::DesmosTable)
    return Dict([
        "type" => "table",
        "id" => string(i+length(e.column)),
        "columns" => [
            Dict([
                "latex" => removedollar(e.column[j]),
                "id" => string(i+j),
                "lines" => true,
                "color" => "#000000",
            ])
            for j in eachindex(e.column)
        ]
    ]), i+length(e.column)+1
end

function JSON.lower(state::DesmosState)
    v = state.expressions
    list = Dict[]
    i = 1
    for e in v
        dict, i = convert_dict(i, e)
        push!(list, dict)
    end
    Dict([
        "version" => 10,
        "expressions" => Dict(["list" => list])
    ])
end

end # module
