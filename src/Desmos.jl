module Desmos

using Colors
using LaTeXStrings
using Latexify
using IntervalSets
using JSON
using ImageIO
using FileIO
using Base64
using FixedPointNumbers

export @desmos

abstract type DesmosElement end

struct DesmosExpression <: DesmosElement
    color::RGB{N0f8}
    latex::LaTeXString
    lines::Bool
    domain::Union{Nothing, ClosedInterval{Float64}}
end

struct DesmosDiscreteVariable <: DesmosElement
    latex::LaTeXString
    range::AbstractRange
end

struct DesmosContinuousVariable <: DesmosElement
    latex::LaTeXString
    range::ClosedInterval{Float64}
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

struct DesmosNote <: DesmosElement
    note::String
end

struct DesmosFolder <: DesmosElement
    title::String
    expressions::Vector{DesmosElement}
end

struct DesmosState
    expressions::Vector{DesmosElement}
end

@doc raw"""
    @variable expr

Define Desmos variable

# Examples
```jldoctest
julia> Desmos.@variable a=3
Desmos.DesmosContinuousVariable(L"$a = 3$", 3.0 .. 3.0)

julia> Desmos.@variable a=3 domain=-2:3
Desmos.DesmosDiscreteVariable(L"$a = 3$", -2:3)

julia> Desmos.@variable a=3 domain=-2..3
Desmos.DesmosContinuousVariable(L"$a = 3$", -2.0 .. 3.0)
```
"""
macro variable end

macro variable(ex1, kwarg)
    ex1.head === :(=) || error("invalid variable definition")
    if kwarg.head == :(=)
        if kwarg.args[1] == :domain
            domain = kwarg.args[2]
        end
    end
    if domain.args[1] === :(..)
        return DesmosContinuousVariable(_latexify(ex1), eval(domain))
    else
        return DesmosDiscreteVariable(_latexify(ex1), eval(domain))
    end
end

macro variable(ex1)
    ex1.head === :(=) || error("invalid variable definition")
    v = ex1.args[2]
    return DesmosContinuousVariable(_latexify(ex1), v..v)
end

@doc raw"""
    @expression expr

Define Desmos variable

# Examples
```jldoctest
julia> Desmos.@expression tan(x) color=RGB(1,1,0)
Desmos.DesmosExpression(RGB{N0f8}(1.0,1.0,0.0), L"$\tan\left( x \right)$", true, nothing)

julia> Desmos.@expression (cos(t), sin(t)) domain=-2..3
Desmos.DesmosExpression(RGB{N0f8}(0.0,0.0,0.0), L"$(\cos\left( t \right), \sin\left( t \right))$", true, -2.0 .. 3.0)
```
"""
macro expression(ex, kwargs...)
    color = :(RGB(0,0,0))
    line = :(true)
    domain = :(nothing)
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :color
                color = kwarg.args[2]
            elseif kwarg.args[1] == :lines
                line = kwarg.args[2]
            elseif kwarg.args[1] == :domain
                domain = kwarg.args[2]
            end
        end
    end
    if ex.head === :macrocall
        if ex.args[1] === Symbol("@L_str")
            DesmosExpression(eval(color), eval(ex), line, eval(domain))
        else
            error("Unsupported expression $(ex)")
        end
    else
        return DesmosExpression(eval(color), _latexify(ex), line, eval(domain))
    end
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

macro folder(title, ex)
    v = DesmosElement[]
    for e in ex.args
        add_elem!(v, e)
    end
    return DesmosFolder(title, v)
end

macro folder(ex)
    v = DesmosElement[]
    for e in ex.args
        add_elem!(v, e)
    end
    return DesmosFolder("", v)
end

macro note(ex)
    return DesmosNote(string(ex))
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

@doc raw"""
    @desmos expr

Define Desmos expressions from Julia expressions

# Example
```julia-repl
julia> using Desmos, JSON

julia> state = @desmos begin
           @note "Trigonometric functions"
           @expression cos(x) color=RGB(1,0,0)
           @expression sin(x) color=RGB(0,0,1)
           tan(x)
           @expression cot(x) lines=false
           @expression (cosh(t), sinh(t)) domain=-2..3
       end;

julia> json = JSON.json(state);
```

"""
macro desmos(ex)
    eval_dollar!(__module__, ex)
    v = DesmosElement[]
    for e in ex.args
        add_elem!(v, e)
    end
    return DesmosState(v)
end

function add_elem!(v, ::LineNumberNode)
    return v
end
function add_elem!(v, ex::Expr)
    if ex.head === :macrocall
        push!(v, eval(ex))
    elseif ex.head === :(=)
        push!(v, DesmosExpression(RGB(0,0,0), _latexify(ex), true, nothing))
    elseif ex.head === :(tuple)
        push!(v, DesmosExpression(RGB(0,0,0), _latexify(ex), true, nothing))
    elseif ex.head === :call
        push!(v, DesmosExpression(RGB(0,0,0), _latexify(ex), true, nothing))
    else
        @warn "unsupported element"
        dump(ex)
    end
end
function add_elem!(v, ex::Integer)
    push!(v, DesmosExpression(RGB(0,0,0), _latexify(ex), true, nothing))
end
function add_elem!(v, ex::Symbol)
    push!(v, DesmosExpression(RGB(0,0,0), _latexify(ex), true, nothing))
end

function removedollar(s::LaTeXString)
    return chopsuffix(chopprefix(s, "\$"), "\$")
end

function remove_mathrm(s::Union{LaTeXString, SubString{LaTeXStrings.LaTeXString}})
    return replace(s, "\\mathrm"=>"")
end

function convert_dict(i::Integer, e::DesmosExpression)
    dict = Dict([
        "type" => "expression",
        "id" => string(i),
        "color" => "#$(hex(e.color))",
        "lines" => e.lines,
        "latex" => removedollar(e.latex)
    ])
    if !isnothing(e.domain)
        dict["parametricDomain"] = Dict([
            "min"=>string(minimum(e.domain)),
            "max"=>string(maximum(e.domain)),
        ])
    end
    return dict, i+1
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

function convert_dict(i::Integer, e::DesmosNote)
    return Dict([
        "type" => "text",
        "id" => string(i),
        "text" => e.note,
    ]), i+1
end

function add_elem_dict!(list, i, e::DesmosElement; i_folder=nothing)
    dict, i = convert_dict(i, e)
    if !isnothing(i_folder)
        dict["folderId"] = string(i_folder)
    end
    push!(list, dict)
    return i
end

function add_elem_dict!(list, i, folder::DesmosFolder)
    i_folder = i
    list_in_folder = [Dict([
        "type" => "folder",
        "title" => folder.title,
        "id" => i_folder,
    ])]
    i = i_folder + 1
    for e in folder.expressions
        i = add_elem_dict!(list_in_folder, i ,e, i_folder=i_folder)
    end
    append!(list, list_in_folder)
    return i
end

function JSON.lower(state::DesmosState)
    list = Dict[]
    i = 1
    for e in state.expressions
        i = add_elem_dict!(list, i ,e)
    end
    Dict([
        "version" => 10,
        "expressions" => Dict(["list" => list])
    ])
end

end # module
