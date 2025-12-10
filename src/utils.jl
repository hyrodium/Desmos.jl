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

function generate_expression(e::Expr, id)
    if e.head === :call
        # sin(x)
        return DesmosExpression(latex = removedollar(_latexify(e)), id = string(id))
    elseif e.head === :(=)
        # sin(x)
        return DesmosExpression(latex = removedollar(_latexify(e)), id = string(id))
    elseif e.head === :(tuple)
        # (a, b)
        return DesmosExpression(latex = removedollar(_latexify(e)), id = string(id))
    elseif e.head === :(vect)
        # [1,2,3]
        return DesmosExpression(latex = removedollar(_latexify(e)), id = string(id))
    elseif e.head === :macrocall
        # @expression sin(x) color=RGB(1,0,0)
        push!(e.args, :(id = $id))
        return eval(e)
    end
    dump(e)
    error("unsupported expression: $e")
end

function generate_expression(e::String, id)
    # comment
    return DesmosText(text = e, id = string(id))
end

function generate_expression(a::Union{Integer, AbstractFloat}, id)
    # 42
    return DesmosExpression(latex = LaTeXString(string(a)), id = string(id))
end

function desmos_color(color::String)
    return color
end

function desmos_color(color::Colorant)
    return "#$(hex(color))"
end

function desmos_domain(interval::AbstractInterval)
    return DesmosDomain(
        min = LaTeXString(string(minimum(interval))),
        max = LaTeXString(string(maximum(interval))),
    )
end

function desmos_parametric_domain(interval::AbstractInterval)
    return DesmosParametricDomain(
        min = LaTeXString(string(minimum(interval))),
        max = LaTeXString(string(maximum(interval))),
    )
end

function desmos_slider(interval::AbstractInterval)
    return DesmosSlider(
        hard_min = true,
        hard_max = true,
        min = LaTeXString(string(minimum(interval))),
        max = LaTeXString(string(maximum(interval))),
    )
end

function desmos_slider(range::AbstractRange)
    return DesmosSlider(
        hard_min = true,
        hard_max = true,
        min = LaTeXString(string(minimum(range))),
        max = LaTeXString(string(maximum(range))),
        step = LaTeXString(string(step(range))),
    )
end
