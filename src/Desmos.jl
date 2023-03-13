module Desmos

using Colors
using LaTeXStrings
using Latexify
using IntervalSets
using JSON

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

macro desmos(ex)
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
