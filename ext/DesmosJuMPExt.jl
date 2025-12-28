module DesmosJuMPExt

using Desmos
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
}

function Desmos.DesmosState(model::JuMP.GenericModel{T}) where T
    mode = MIME("text/desmos")  # custom MIME to override some JuMP printing logic

    variables = JuMP.all_variables(model)
    length(variables) == 2 || error("JuMP model must have exactly two variables.")
    x, y = variables[1], variables[2]

    # 1. build domain restriction string

    domain = ""
    con_strings = []
    for con in JuMP.all_constraints(model, include_variable_in_set_constraints=true)
        co = JuMP.constraint_object(con)
        co.func isa SUPPORTED_FUNCS{T} || error("Got unsupported function $(co.func) of type $(typeof(co.func))")
        co.set isa SUPPORTED_SETS{T} || error("Got unsupported set $(co.set) of type $(typeof(co.set))")
        s = desmos_latexify(Meta.parse(
            JuMP.constraint_string(mode, "", co)  # ignore constraint names
        ))
        co.func isa JuMP.GenericVariableRef || push!(con_strings, s)  # skip bounds for expressions
        domain *= wrap_for_domain(s)  # keep bounds for domain
    end

    # 2. build each constraint expression, restricted to domain

    expressions = []
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
                JuMP.function_string(mode, obj)
            )) * " = c",  # NOTE: no domain restriction for objective level curve
            id="objective function",
            color="green",
        ))
    end

    # 4. build objective level value expression, set to optimal value or zero

    val = JuMP.result_count(model) > 0 ? JuMP.objective_value(model) : 0
    push!(expressions, Desmos.DesmosExpression(;
        latex=desmos_latexify(
            :(c = $val)
        ),
        id="objective level",
    ))

    # 5. build solution point expression

    if JuMP.result_count(model) > 0
        push!(expressions, Desmos.DesmosExpression(;
            latex=desmos_latexify(
                :($(JuMP.value(x)), $(JuMP.value(y)))
            ),
            id="solution",
            color="red",
        ))
    end

    return Desmos.DesmosState(
        expressions = Desmos.DesmosExpressions(
            list = expressions
        )
    )
end

# FIXME: support this in Desmos.jl?
wrap_for_domain(s) = "\\left\\{$s\\right\\}"

# JuMP patches for MIME("text/desmos")
function JuMP._math_symbol(::MIME"text/desmos", name::Symbol)
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
function JuMP._term_string(mode::MIME"text/desmos", coef, factor)
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
function JuMP.function_string(::MIME"text/desmos", v::JuMP.AbstractVariableRef)
    if !JuMP.is_valid(JuMP.owner_model(v), v)
        return "InvalidVariableRef"
    end
    # desmos: use x/y instead of JuMP.name
    idx = JuMP.index(v).value
    if idx == 1
        return "x"
    else
        @assert idx == 2
        return "y"
    end
end

end # module
