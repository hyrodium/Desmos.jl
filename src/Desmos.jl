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
    width::Float64
    height::Float64
end

struct DesmosState
    expressions::Vector{DesmosElement}
end

macro variable(ex1, ex2)
    ex1.head === :(=) || error("invalid variable definition")
    if ex2.args[1] === :(..)
        return DesmosContinuousVariable(latexify(ex1), eval(ex2))
    else
        return DesmosDiscreteVariable(latexify(ex1), eval(ex2))
    end
end

macro variable(ex1)
    ex1.head === :(=) || error("invalid variable definition")
    v = ex1.args[2]
    return DesmosContinuousVariable(latexify(ex1), v..v)
end

macro color(ex1, ex2)
    return DesmosExpression(eval(ex2), latexify(ex1))
end

macro image(ex)
    return DesmosImage(create_url(ex), 2, 2)
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
                push!(v, DesmosExpression(RGB(0,0,0), latexify(e)))
            elseif e.head === :(tuple)
                push!(v, DesmosExpression(RGB(0,0,0), LaTeXString("\$("*removedollar(latexify(e))*")\$")))
            elseif e.head === :call
                push!(v, DesmosExpression(RGB(0,0,0), latexify(e)))
            else
                @warn "unsupported element"
                dump(e)
            end
        elseif e isa Integer
            push!(v, DesmosExpression(RGB(0,0,0), latexify(e)))
        elseif e isa Symbol
            push!(v, DesmosExpression(RGB(0,0,0), latexify(e)))
        end
    end
    return DesmosState(v)
end

function removedollar(s::LaTeXString)
    return chopsuffix(chopprefix(s, "\$"), "\$")
end

function convert_dict(i::Integer, e::DesmosExpression)
    return Dict([
        "type" => "expression",
        "id" => string(i),
        "color" => "#$(hex(e.color))",
        "latex" => removedollar(e.latex)
    ])
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
    ])
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
    ])
end

function convert_dict(i::Integer, e::DesmosImage)
    return Dict([
        "type" => "image",
        "id" => string(i),
        "image_url" => e.url,
        "name" => "image from Desmos.jl",
        "center"=> "\\left(0,0\\right)",
        "width" => "$(e.width)",
        "height" => "$(e.height)",
    ])
end

function JSON.lower(state::DesmosState)
    v = state.expressions
    Dict([
        "version" => 10,
        "expressions" => Dict(["list" => [
            convert_dict(i, e)
        for (i, e) in enumerate(v)]])
    ])
end

end # module
