macro expression(ex, kwargs...)
    id = "0"
    color = desmos_color(RGB(0, 0, 0))
    slider = nothing
    lines = nothing
    hidden = nothing
    domain = nothing
    parametric_domain = nothing
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :id
                id = string(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :color
                color = desmos_color(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :slider
                slider = desmos_slider(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :lines
                lines = eval(kwarg.args[2])
            elseif kwarg.args[1] == :hidden
                hidden = eval(kwarg.args[2])
            elseif kwarg.args[1] == :domain
                domain = desmos_domain(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :parametric_domain
                parametric_domain = desmos_parametric_domain(eval(kwarg.args[2]))
            end
        end
    end
    if ex.head === :macrocall
        if ex.args[1] === Symbol("@L_str")
            latex = removedollar(eval(ex))
        else
            error("Unsupported expression $(ex)")
        end
    else
        latex = removedollar(_latexify(ex))
    end
    return DesmosExpression(; latex, id, color, slider, lines, hidden, domain, parametric_domain)
end

macro image(kwargs...)
    id = "0"
    image_url = ""
    hidden = nothing
    name = nothing
    width = nothing
    height = nothing
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :id
                id = string(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :image_url
                image_url = eval(kwarg.args[2])
            elseif kwarg.args[1] == :hidden
                hidden = eval(kwarg.args[2])
            elseif kwarg.args[1] == :name
                name = eval(kwarg.args[2])
            elseif kwarg.args[1] == :width
                width = LaTeXString(string(eval(kwarg.args[2])))
            elseif kwarg.args[1] == :height
                height = LaTeXString(string(eval(kwarg.args[2])))
            end
        end
    end
    return DesmosImage(; id, image_url, hidden, name, width, height)
end

macro text(ex, kwargs...)
    id = "0"
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :id
                id = string(eval(kwarg.args[2]))
            end
        end
    end
    return DesmosText(text = ex; id)
end

macro desmos(ex)
    eval_dollar!(__module__, ex)
    expressions = DesmosExpressions(list = AbstractDesmosExpression[])
    id = 1
    for e in ex.args
        if e isa LineNumberNode
            continue
        end
        expression = generate_expression(e, id)
        push!(expressions.list, expression)
        id = id + 1
    end
    state = DesmosState(expressions = expressions)
    return state
end
