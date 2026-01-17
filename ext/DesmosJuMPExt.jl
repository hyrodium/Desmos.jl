module DesmosJuMPExt

using Desmos, IntervalSets
import JuMP

const SUPPORTED_FUNCS{T} = Union{
    JuMP.GenericVariableRef{T},
    JuMP.GenericAffExpr{T, JuMP.GenericVariableRef{T}},
    JuMP.GenericQuadExpr{T, JuMP.GenericVariableRef{T}},
    JuMP.GenericNonlinearExpr{JuMP.GenericVariableRef{T}},
}

const SUPPORTED_SETS{T} = Union{
    JuMP.MOI.LessThan{T},
    JuMP.MOI.GreaterThan{T},
    JuMP.MOI.EqualTo{T},
    JuMP.MOI.Parameter{T},
}

const DESMOS_MIME = MIME("text/desmos")
const OPREFIX_DESMOS_MIME = MIME("text/desmos_o")
const AnyDesmosMIME = Union{typeof(DESMOS_MIME), typeof(OPREFIX_DESMOS_MIME)}

function Desmos.DesmosState(
        model::JuMP.GenericModel{T};
        parameter_ranges = Dict(), parametric_solution = Dict(),
        objective_value_variable = "c",
        restrict_objective_domain = false,
        objective_level_multipliers = T[],
    ) where {T}

    expressions = []

    variables = []
    for vp in JuMP.all_variables(model)
        if JuMP.is_parameter(vp)
            idx = JuMP.index(vp).value
            val = JuMP.parameter_value(vp)
            name = JuMP.name(vp)
            name == "$objective_value_variable" && desmos_error("The parameter name `$objective_value_variable` is reserved. Rename the parameter or set `objective_value_variable`.")
            push!(
                expressions, Desmos.DesmosExpression(;
                    latex = desmos_latexify(:($name = $val)),
                    id = "parameter $idx",
                    slider = Desmos.desmos_slider(get(parameter_ranges, vp, -10 .. 10))
                )
            )
        else
            push!(variables, vp)
        end
    end
    length(variables) == 2 || desmos_error("JuMP model must have exactly two decision variables.")
    x, y = variables[1], variables[2]
    x_str = JuMP.function_string(DESMOS_MIME, x)
    y_str = JuMP.function_string(DESMOS_MIME, y)

    # 1. build domain restriction string

    domain = ""
    con_texs = []
    for con in JuMP.all_constraints(model, include_variable_in_set_constraints = true)
        co = JuMP.constraint_object(con)
        co.func isa SUPPORTED_FUNCS{T} || desmos_error("Got unsupported function $(co.func) of type $(typeof(co.func))")
        co.set isa SUPPORTED_SETS{T} || desmos_error("Got unsupported set $(co.set) of type $(typeof(co.set))")
        co.set isa JuMP.MOI.Parameter && continue  # already handled above
        con_str = JuMP.constraint_string(DESMOS_MIME, "", co)  # ignore constraint names
        con_tex = parse_desmos_latexify(con_str)
        co.func isa JuMP.GenericVariableRef || push!(con_texs, con_tex)  # skip bounds for expressions
        co.set isa JuMP.MOI.EqualTo || (domain *= wrap_for_domain(con_tex))  # skip equalities for domain
    end

    # 2. build each constraint expression, restricted to domain

    for (i, con_tex) in enumerate(con_texs)
        push!(
            expressions, Desmos.DesmosExpression(;
                # exclude con from domain to get outlines
                latex = con_tex * replace(domain, wrap_for_domain(con_tex) => ""),
                id = "constraint $i",
            )
        )
    end

    # 3. build objective level curve expression

    obj = JuMP.objective_function(model)
    if obj != JuMP.GenericAffExpr{T, JuMP.GenericVariableRef{T}}(0)
        obj_str = JuMP.function_string(DESMOS_MIME, obj)
        obj_mults = isempty(objective_level_multipliers) ? "" : string(objective_level_multipliers)
        obj_tex = parse_desmos_latexify("$obj_str = $obj_mults$objective_value_variable")
        restrict_objective_domain && (obj_tex *= domain)
        push!(
            expressions, Desmos.DesmosExpression(;
                latex = obj_tex,
                id = "objective function",
                color = "green",
            )
        )
    end

    # 4. build solution and objective expressions

    if !isempty(parametric_solution)
        haskey(parametric_solution, x) || desmos_error("Parametric solution is incomplete: key `$x` not found")
        haskey(parametric_solution, y) || desmos_error("Parametric solution is incomplete: key `$y` not found")
        x_ostr = JuMP.function_string(OPREFIX_DESMOS_MIME, x)
        y_ostr = JuMP.function_string(OPREFIX_DESMOS_MIME, y)
        obj_ostr = JuMP.function_string(OPREFIX_DESMOS_MIME, obj)
        x_solstr = JuMP.function_string(DESMOS_MIME, parametric_solution[x])
        y_solstr = JuMP.function_string(DESMOS_MIME, parametric_solution[y])
        push!(
            expressions, Desmos.DesmosExpression(;
                latex = parse_desmos_latexify("$x_ostr = $x_solstr"),
                id = "solution x"
            )
        )
        push!(
            expressions, Desmos.DesmosExpression(;
                latex = parse_desmos_latexify("$y_ostr = $y_solstr"),
                id = "solution y"
            )
        )
        push!(
            expressions, Desmos.DesmosExpression(;
                latex = parse_desmos_latexify("($x_ostr, $y_ostr)"),
                id = "parametric solution",
                color = "red",
            )
        )
        push!(
            expressions, Desmos.DesmosExpression(;
                latex = parse_desmos_latexify("$objective_value_variable = $obj_ostr"),
                id = "objective level",
            )
        )
    else
        has_result = JuMP.result_count(model) > 0
        val = has_result ? JuMP.objective_value(model) : 0
        push!(
            expressions, Desmos.DesmosExpression(;
                latex = parse_desmos_latexify("$objective_value_variable = $val"),
                id = "objective level",
            )
        )
        if has_result
            x_val = JuMP.value(x)
            y_val = JuMP.value(y)
            push!(
                expressions, Desmos.DesmosExpression(;
                    latex = parse_desmos_latexify("($x_val, $y_val)"),
                    id = "solution",
                    color = "red",
                )
            )
        end
    end

    push!(
        expressions, Desmos.DesmosExpression(;
            latex = parse_desmos_latexify("$x_str = x"),
            id = "xmap",
            hidden = true,
        )
    )
    push!(
        expressions, Desmos.DesmosExpression(;
            latex = parse_desmos_latexify("$y_str = y"),
            id = "ymap",
            hidden = true,
        )
    )


    return Desmos.DesmosState(
        expressions = Desmos.DesmosExpressions(
            list = expressions
        )
    )
end

# FIXME: support this in Desmos.jl?
wrap_for_domain(s) = "\\left\\{$s\\right\\}"
parse_desmos_latexify(s) = desmos_latexify(Meta.parse(s))
desmos_error(s) = throw(ArgumentError(s))

# JuMP printing patches
function JuMP._math_symbol(::AnyDesmosMIME, name::Symbol)
    if name == :leq
        return "<="
    elseif name == :geq
        return ">="
    elseif name == :eq
        return "=="
    else
        # desmos: x² -> x^2
        name == :sq || desmos_error("DesmosJuMP does not support the symbol $name.")
        return "^2"
    end
end
function JuMP._term_string(mode::AnyDesmosMIME, coef, factor)
    if JuMP._is_one_for_printing(coef)
        return factor
    else
        JuMP._is_im_for_printing(coef) && desmos_error("DesmosJuMP does not support complex numbers.")
        # desmos: `4 x` -> `4*x`
        return string(JuMP._string_round(mode, abs, coef), "*", factor)
    end
end
function JuMP.function_string(mode::AnyDesmosMIME, v::JuMP.AbstractVariableRef)
    JuMP.is_valid(JuMP.owner_model(v), v) || desmos_error("Invalid variable $v.")
    idx = JuMP.index(v).value
    if JuMP.is_parameter(v)
        return JuMP.name(v)
    else
        prefix = mode isa typeof(OPREFIX_DESMOS_MIME) ? "o_" : ""
        return prefix * "x_$idx"
    end
end

end # module
