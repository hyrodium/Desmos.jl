macro expression(ex, kwargs...)
    color = desmos_color(RGB(0,0,0))
    domain = nothing
    id = "0"
    hidden = nothing
    slider = nothing
    parametric_domain = nothing
    for kwarg in kwargs
        if kwarg.head == :(=)
            if kwarg.args[1] == :color
                color = desmos_color(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :domain
                domain = desmos_domain(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :id
                id = string(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :hidden
                hidden = eval(kwarg.args[2])
            elseif kwarg.args[1] == :slider
                slider = desmos_slider(eval(kwarg.args[2]))
            elseif kwarg.args[1] == :parametric_domain
                parametric_domain = desmos_parametric_domain(eval(kwarg.args[2]))
            end
        end
    end
    return DesmosExpression(latex=removedollar(_latexify(ex)); color, id, hidden, domain, slider, parametric_domain)
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
    return DesmosText(text=ex; id)
end

macro desmos(ex)
    eval_dollar!(__module__, ex)
    expressions = DesmosExpressions(list=AbstractDesmosExpression[])
    id = 1
    @show ex.args
    for e in ex.args
        if e isa LineNumberNode
            continue
        end
        expression = generate_expression(e, id)
        push!(expressions.list, expression)
        id = id + 1
    end
    state = DesmosState(expressions=expressions)
    return state
end
