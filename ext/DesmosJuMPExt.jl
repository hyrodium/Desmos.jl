module DesmosJuMPExt

using Desmos, IntervalSets
import JuMP

const SUPPORTED_FUNCS{T} = Union{
    JuMP.GenericVariableRef{T},
    JuMP.GenericAffExpr{T,JuMP.GenericVariableRef{T}},
    JuMP.GenericQuadExpr{T,JuMP.GenericVariableRef{T}},
    JuMP.GenericNonlinearExpr{JuMP.GenericVariableRef{T}},
}

const SUPPORTED_SETS{T} = Union{
    JuMP.MOI.LessThan{T},
    JuMP.MOI.GreaterThan{T},
    JuMP.MOI.EqualTo{T},
    JuMP.MOI.Parameter{T},
}

const DESMOS_MIME = MIME("text/desmos")

function Desmos.DesmosState(model::JuMP.GenericModel{T};
    parameter_ranges=Dict(), parametric_solution=Dict()
) where T

    expressions = []

    variables = []
    for vp in JuMP.all_variables(model)
        if JuMP.is_parameter(vp)
            idx = JuMP.index(vp).value
            val = JuMP.parameter_value(vp)
            name = JuMP.name(vp)
            name == "c" && error("The parameter name `c` is reserved.")
            push!(expressions, Desmos.DesmosExpression(;
                latex=desmos_latexify(Meta.parse(
                    "$(name) = $(val)"
                )),
                id="parameter $(idx)",
                slider=Desmos.desmos_slider(get(parameter_ranges, vp, -10..10))
            ))
        else
            push!(variables, vp)
        end
    end
    length(variables) == 2 || error("JuMP model must have exactly two variables.")
    x, y = variables[1], variables[2]

    # 1. build domain restriction string

    domain = ""
    con_strings = []
    for con in JuMP.all_constraints(model, include_variable_in_set_constraints=true)
        co = JuMP.constraint_object(con)
        co.func isa SUPPORTED_FUNCS{T} || error("Got unsupported function $(co.func) of type $(typeof(co.func))")
        co.set isa SUPPORTED_SETS{T} || error("Got unsupported set $(co.set) of type $(typeof(co.set))")
        co.set isa JuMP.MOI.Parameter && continue  # already handled above
        s = desmos_latexify(Meta.parse(
            JuMP.constraint_string(DESMOS_MIME, "", co)  # ignore constraint names
        ))
        co.func isa JuMP.GenericVariableRef || push!(con_strings, s)  # skip bounds for expressions
        domain *= wrap_for_domain(s)  # keep bounds for domain
    end

    # 2. build each constraint expression, restricted to domain

    for (i, con_s) in enumerate(con_strings)
        push!(expressions, Desmos.DesmosExpression(;
            # exclude con from domain to get outlines
            latex=con_s * replace(domain, wrap_for_domain(con_s) => ""),
            id="constraint $i",
        ))
    end

    # 3. build objective level curve expression

    obj = JuMP.objective_function(model)
    if obj != JuMP.GenericAffExpr{T,JuMP.GenericVariableRef{T}}(0)
        push!(expressions, Desmos.DesmosExpression(;
            latex=desmos_latexify(Meta.parse(
                JuMP.function_string(DESMOS_MIME, obj)
            )) * " = c",  # NOTE: no domain restriction for objective level curve
            id="objective function",
            color="green",
        ))
    end

    # 4. build solution and objective expressions

    if !isempty(parametric_solution)
        push!(expressions, Desmos.DesmosExpression(;
            latex="o_{x$(JuMP.index(x).value)} = " * desmos_latexify(Meta.parse(
                "$(JuMP.function_string(DESMOS_MIME, parametric_solution[x]))"
            )),
            id="solution x"
        ))
        push!(expressions, Desmos.DesmosExpression(;
            latex="o_{x$(JuMP.index(y).value)} = " * desmos_latexify(Meta.parse(
                "$(JuMP.function_string(DESMOS_MIME, parametric_solution[y]))"
            )),
            id="solution y"
        ))
        push!(expressions, Desmos.DesmosExpression(;
            latex="(o_{x$(JuMP.index(x).value)}, o_{x$(JuMP.index(y).value)})",
            id="parametric solution",
            color="red",
        ))
        push!(expressions, Desmos.DesmosExpression(;
            latex="c = " * desmos_latexify(Meta.parse(
                JuMP.function_string(MIME("text/desmos_o"), obj)
            )),
            id="objective level",
        ))
    else
        has_result = JuMP.result_count(model) > 0
        val = has_result ? JuMP.objective_value(model) : 0
        push!(expressions, Desmos.DesmosExpression(;
            latex=desmos_latexify(
                :(c = $val)
            ),
            id="objective level",
        ))
        if has_result
            push!(expressions, Desmos.DesmosExpression(;
                latex=desmos_latexify(
                    :($(JuMP.value(x)), $(JuMP.value(y)))
                ),
                id="solution",
                color="red",
            ))
        end
    end

    push!(expressions, Desmos.DesmosExpression(;
        latex="x_$(JuMP.index(x).value) = x",
        id="xmap",
        hidden=true,
    ))
    push!(expressions, Desmos.DesmosExpression(;
        latex="x_$(JuMP.index(y).value) = y",
        id="ymap",
        hidden=true,
    ))


    return Desmos.DesmosState(
        expressions = Desmos.DesmosExpressions(
            list = expressions
        )
    )
end

# FIXME: support this in Desmos.jl?
wrap_for_domain(s) = "\\left\\{$s\\right\\}"

# JuMP patches for MIME("text/desmos")
function JuMP._math_symbol(::typeof(DESMOS_MIME), name::Symbol)
    if name == :leq
        return Sys.iswindows() ? "<=" : "≤"
    elseif name == :geq
        return Sys.iswindows() ? ">=" : "≥"
    elseif name == :eq
        return Sys.iswindows() ? "==" : "="
    elseif name == :sq
        # desmos: x² -> x^2
        return "^2"
    else
        @assert name == :in
        return Sys.iswindows() ? "in" : "∈"
    end
end
function JuMP._term_string(mode::typeof(DESMOS_MIME), coef, factor)
    if JuMP._is_one_for_printing(coef)
        return factor
    elseif JuMP._is_im_for_printing(coef)
        # desmos: `4 x` -> `4*x`
        return string(factor, "*", JuMP._string_round(mode, abs, coef))
    else
        # desmos: `4 x` -> `4*x`
        return string(JuMP._string_round(mode, abs, coef), "*", factor)
    end
end
function JuMP.function_string(::typeof(DESMOS_MIME), v::JuMP.AbstractVariableRef)
    if !JuMP.is_valid(JuMP.owner_model(v), v)
        return "InvalidVariableRef"
    end
    # desmos: use x/y instead of JuMP.name
    idx = JuMP.index(v).value

    if JuMP.is_parameter(v)
        return JuMP.name(v)
    else
        return "x_$idx"
    end
end
function JuMP.in_set_string(m::typeof(DESMOS_MIME), s::JuMP.MOI.Parameter{T}) where T
    return "= $(JuMP._string_round(m, abs, s.value))"
end

# to substitute x_1 -> o_x1, x_2 -> o_x2 when a solution expression is available
JuMP._math_symbol(::MIME"text/desmos_o", name::Symbol) = JuMP._math_symbol(DESMOS_MIME, name)
JuMP._term_string(::MIME"text/desmos_o", coef, factor) = JuMP._term_string(DESMOS_MIME, coef, factor)
JuMP.in_set_string(::MIME"text/desmos_o", s::JuMP.MOI.Parameter{T}) where T = JuMP.in_set_string(DESMOS_MIME, s)
JuMP.function_string(::MIME"text/desmos_o", v::JuMP.AbstractVariableRef) = (JuMP.is_parameter(v) ? "" : "o_") * JuMP.function_string(DESMOS_MIME, v)

end # module
