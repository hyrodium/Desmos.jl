"""
    desmos_latexify(ex) -> LaTeXString

Convert Julia expressions to LaTeX strings suitable for Desmos.
This is a simpler, Desmos-focused alternative to `Latexify.latexify`.
"""
function desmos_latexify(ex)
    return LaTeXString(_latexify(ex))
end

function desmos_latexify(s::LaTeXString)
    return LaTeXString(chopsuffix(chopprefix(s, "\$"), "\$"))
end

"""
    _latexify(ex) -> String

Convert a Julia expression to LaTeX string.
Main dispatcher for different expression types.
"""
function _latexify end

function _latexify(ex::Expr)
    if ex.head == :call
        return _latexify_call(ex)
    elseif ex.head == :tuple
        return _latexify_tuple(ex)
    elseif ex.head == :vect
        return _latexify_vect(ex)
    elseif ex.head == :block
        return _latexify_block(ex)
    elseif ex.head == :(=)
        return _latexify_assignment(ex)
    else
        error("Unsupported expression head: $(ex.head)")
    end
end

function _latexify(n::Number)
    if n == Inf
        return "\\infty"
    elseif n == -Inf
        return "-\\infty"
    else
        return string(n)
    end
end

function _latexify(s::Symbol)
    str = string(s)
    return _latexify(str)
end

function _latexify(str::AbstractString)
    # Special case: Inf
    if str == "Inf"
        return "\\infty"
    end

    result = ""
    i = 1
    while i ≤ ncodeunits(str)
        c = str[i]

        if c in UNSUPPORTED_GREEK_LETTERS
            # Check for unsupported Greek letters
            throw(UnsupportedDesmosSyntaxError("The Greek letter '$c' is not supported by Desmos."))
        elseif haskey(GREEK_LETTERS, c)
            # γ → \gamma
            result *= GREEK_LETTERS[c]
            i = nextind(str, i)

        elseif haskey(SUBSCRIPT_MAP, c)
            # a₄ → a_4
            subscript = ""
            while i ≤ ncodeunits(str) && isvalid(str, i) && haskey(SUBSCRIPT_MAP, str[i])
                subscript *= SUBSCRIPT_MAP[str[i]]
                i = nextind(str, i)
            end
            result *= "_{$subscript}"

        elseif haskey(SUPERSCRIPT_MAP, c)
            # a⁵ → a^5
            superscript = ""
            while i ≤ ncodeunits(str) && isvalid(str, i) && haskey(SUPERSCRIPT_MAP, str[i])
                superscript *= SUPERSCRIPT_MAP[str[i]]
                i = nextind(str, i)
            end
            result *= "^{$superscript}"

        elseif c == '_'
            # a_b_c → a_{b_{c}}
            next_i = nextind(str, i)
            if next_i ≤ ncodeunits(str) && isvalid(str, next_i)
                # Collect all consecutive alphanumeric characters (including underscores for nested subscripts)
                subscript = ""
                j = next_i
                while j ≤ ncodeunits(str) && isvalid(str, j)
                    next_c = str[j]
                    if isdigit(next_c) || isletter(next_c) || next_c == '_'
                        # Check for unsupported Greek letters in subscripts
                        if next_c in UNSUPPORTED_GREEK_LETTERS
                            throw(UnsupportedDesmosSyntaxError("The Greek letter '$next_c' is not supported by Desmos."))
                            # Convert Greek letters in subscripts
                        elseif haskey(GREEK_LETTERS, next_c)
                            subscript *= GREEK_LETTERS[next_c]
                        else
                            subscript *= string(next_c)
                        end
                        j = nextind(str, j)
                    else
                        break
                    end
                end
                if !isempty(subscript)
                    # Handle nested subscripts: convert "a_b" within subscript to "a_{b}"
                    subscript = replace(subscript, r"_(.+)" => s"_{\1}")
                    result *= "_{$subscript}"
                    i = j
                else
                    result *= "_"
                    i = next_i
                end
            else
                result *= "_"
                i = nextind(str, i)
            end
        else
            result *= string(c)
            i = nextind(str, i)
        end
    end

    return result
end

function _latexify_tuple(ex::Expr)
    elements = [_latexify(arg) for arg in ex.args]
    return "\\left($(join(elements, ","))\\right)"
end

function _latexify_vect(ex::Expr)
    elements = [_latexify(arg) for arg in ex.args]
    return "\\left[$(join(elements, ","))\\right]"
end

function _latexify_assignment(ex::Expr)
    lhs = _latexify(ex.args[1])
    rhs = _latexify(ex.args[2])
    return "$lhs=$rhs"
end

function _latexify_comparison(ex::Expr)
    # Comparison and relational operators: >, <, ==, >=, <=, !=, ≥, ≤, ≠, ~
    op = ex.args[1]
    lhs = _latexify(ex.args[2])
    rhs = _latexify(ex.args[3])

    # Check for unsupported operators
    if op in (:(!=), :≠)
        throw(UnsupportedDesmosSyntaxError("The inequality operator '$op' (\\ne) is not supported by Desmos. Use other comparison operators instead."))
    end

    # Map Julia operators to LaTeX
    op_map = Dict(
        :> => ">",
        :< => "<",
        :(==) => "=",
        :(>=) => "\\ge ",
        :(<=) => "\\le ",
        :≥ => "\\ge ",
        :≤ => "\\le ",
        :~ => "\\sim "
    )

    op_str = get(op_map, op, string(op))
    return "$lhs$op_str$rhs"
end

function _latexify_block(ex::Expr)
    # Block expressions often contain LineNumberNode entries
    # Filter them out and process only the actual expressions
    filtered_args = filter(arg -> !(arg isa LineNumberNode), ex.args)

    # If there's only one expression in the block, return its LaTeX
    if length(filtered_args) == 1
        return _latexify(filtered_args[1])
    elseif length(filtered_args) == 0
        return ""
    else
        # Multiple expressions in a block - join them (though this is rare)
        return join([_latexify(arg) for arg in filtered_args], "; ")
    end
end

function _latexify_call(ex::Expr)
    func = ex.args[1]

    # If func is a Symbol, dispatch based on its value
    if func isa Symbol
        # Binary operators
        if func == :+
            return _latexify_plus(ex)
        elseif func == :-
            return _latexify_minus(ex)
        elseif func == :*
            return _latexify_multiply(ex)
        elseif func == :/
            return _latexify_divide(ex)
        elseif func == :^
            return _latexify_power(ex)
        end

        # Comparison and relational operators
        if func in (:>, :<, :(==), :(>=), :(<=), :(!=), :≥, :≤, :≠, :~)
            return _latexify_comparison(ex)
        end

        # Special functions
        if func == :sum
            # Check if it's a generator expression (sum(... for ...))
            if length(ex.args) >= 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
                return _latexify_sum(ex)
            end
            # Otherwise, treat as normal function
        elseif func == :prod
            # Check if it's a generator expression (prod(... for ...))
            if length(ex.args) >= 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
                return _latexify_prod(ex)
            end
            # Otherwise, treat as normal function
        elseif func == :int
            return _latexify_int(ex)
        elseif func == :gradient
            return _latexify_gradient(ex)
        elseif func == :log
            return _latexify_log(ex)
        elseif func == :log10
            return _latexify_log10(ex)
        elseif func == :log1p
            return _latexify_log1p(ex)
        elseif func == :ifelse
            return _latexify_ifelse(ex)
        end

        # Check if function is in DESMOS_FUNCTIONS dictionaries
        nargs = length(ex.args) - 1  # Number of arguments (excluding function name)

        if nargs == 1 && haskey(DESMOS_FUNCTIONS_1ARG, func)
            # Single-argument function
            arg = _latexify(ex.args[2])
            template = DESMOS_FUNCTIONS_1ARG[func]
            return replace(template, "ARG1" => arg)
        elseif nargs == 2 && haskey(DESMOS_FUNCTIONS_2ARG, func)
            # Two-argument function
            arg1 = _latexify(ex.args[2])
            arg2 = _latexify(ex.args[3])
            template = DESMOS_FUNCTIONS_2ARG[func]
            return replace(template, "ARG1" => arg1, "ARG2" => arg2)
        elseif haskey(DESMOS_FUNCTIONS_nARG, func)
            # Variable-argument function
            args_str = join([_latexify(arg) for arg in ex.args[2:end]], ",")
            template = DESMOS_FUNCTIONS_nARG[func]
            return replace(template, "ARGS" => args_str)
        end

        # General function call
        return _latexify_general_function(func, ex.args[2:end])
    elseif func isa Expr
        # The function itself is an expression, e.g., (d/dx)(f(x,y))
        # Convert function part to LaTeX and apply to arguments
        func_str = _latexify(func)
        if isempty(ex.args[2:end])
            return func_str
        else
            args_str = join([_latexify(arg) for arg in ex.args[2:end]], ",")
            return "\\left($func_str\\right)\\left($args_str\\right)"
        end
    end

    error("Unsupported function type in call expression: $(typeof(func))")
end

function _latexify_plus(ex::Expr)
    terms = [_latexify(arg) for arg in ex.args[2:end]]
    result = join(terms, "+")
    # Handle negative signs: "+-x" -> "-x"
    result = replace(result, r"\+-" => "-")
    return result
end

function _latexify_minus(ex::Expr)
    if length(ex.args) == 2
        # Unary minus
        arg = _latexify(ex.args[2])
        return "-$arg"
    else
        # Binary minus
        lhs = _latexify(ex.args[2])
        rhs = _latexify(ex.args[3])
        return "$lhs-$rhs"
    end
end

function _latexify_multiply(ex::Expr)
    # Add parentheses around addition/subtraction expressions to preserve precedence
    factors = []
    for arg in ex.args[2:end]
        latex_arg = _latexify(arg)
        # Add parentheses if the argument is an addition or subtraction expression
        if arg isa Expr && arg.head == :call && (arg.args[1] == :+ || arg.args[1] == :-)
            latex_arg = "\\left($latex_arg\\right)"
        end
        push!(factors, latex_arg)
    end
    return join(factors, "\\cdot ")
end

function _latexify_divide(ex::Expr)
    numerator = _latexify(ex.args[2])
    denominator = _latexify(ex.args[3])
    return "\\frac{$numerator}{$denominator}"
end

function _latexify_power(ex::Expr)
    base = _latexify(ex.args[2])
    exponent = _latexify(ex.args[3])

    # Add parentheses to base if it's an expression
    if ex.args[2] isa Expr
        base = "\\left($base\\right)"
    end

    return "$base^{$exponent}"
end

function _latexify_general_function(func::Symbol, args)
    func_str = _latexify(func)
    if isempty(args)
        return func_str
    else
        args_str = join([_latexify(arg) for arg in args], ",")
        return "$func_str\\left($args_str\\right)"
    end
end

function _latexify_sum(ex::Expr)
    # sum(n^2 for n in 1:5) -> \sum_{n=1}^{5}n^{2}
    if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
        gen = ex.args[2]
        term = _latexify(gen.args[1])

        # Parse the iterator
        iter = gen.args[2]
        if iter.head == :(=) && iter.args[2] isa Expr && iter.args[2].head == :call && iter.args[2].args[1] == :(:)
            var = _latexify(iter.args[1])
            start = _latexify(iter.args[2].args[2])
            stop = _latexify(iter.args[2].args[3])
            return "\\sum_{$var=$start}^{$stop}$term"
        end
    end

    error("Unsupported sum syntax")
end

function _latexify_prod(ex::Expr)
    # prod(n^2 for n in 1:5) -> \prod_{n=1}^{5}n^{2}
    if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
        gen = ex.args[2]
        term = _latexify(gen.args[1])

        # Parse the iterator
        iter = gen.args[2]
        if iter.head == :(=) && iter.args[2] isa Expr && iter.args[2].head == :call && iter.args[2].args[1] == :(:)
            var = _latexify(iter.args[1])
            start = _latexify(iter.args[2].args[2])
            stop = _latexify(iter.args[2].args[3])
            return "\\prod_{$var=$start}^{$stop}$term"
        end
    end

    error("Unsupported prod syntax")
end

function _latexify_int(ex::Expr)
    # int(x^2 for x in 1 .. 5) -> \int_{1}^{5}x^{2}dx
    if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
        gen = ex.args[2]
        term = _latexify(gen.args[1])

        # Parse the iterator
        iter = gen.args[2]
        if iter.head == :(=)
            var = _latexify(iter.args[1])
            # Check for interval syntax (1 .. 5)
            range_ex = iter.args[2]
            if range_ex isa Expr && range_ex.head == :call && range_ex.args[1] == :(..)
                start = _latexify(range_ex.args[2])
                stop = _latexify(range_ex.args[3])
                return "\\int_{$start}^{$stop}$(term)d$var"
            end
        end
    end

    error("Unsupported int syntax")
end

function _latexify_gradient(ex::Expr)
    # gradient(f, x) -> \frac{d}{dx}f
    if length(ex.args) == 3
        f = _latexify(ex.args[2])
        x = _latexify(ex.args[3])
        return "\\frac{d}{d$x}$f"
    end

    error("gradient requires exactly 2 arguments")
end

function _latexify_log(ex::Expr)
    # log(x) -> \ln\left(x\right) (natural logarithm)
    # log(a, b) -> \log_{a}\left(b\right) (logarithm base a)
    if length(ex.args) == 2
        # log(x) -> \ln(x)
        arg = _latexify(ex.args[2])
        return "\\ln\\left($arg\\right)"
    elseif length(ex.args) == 3
        # log(a, b) -> \log_{a}(b)
        base = _latexify(ex.args[2])
        arg = _latexify(ex.args[3])
        return "\\log_{$base}\\left($arg\\right)"
    end

    error("log requires 1 or 2 arguments")
end

function _latexify_log10(ex::Expr)
    # log10(x) -> \log\left(x\right) (base-10 logarithm)
    if length(ex.args) == 2
        arg = _latexify(ex.args[2])
        return "\\log\\left($arg\\right)"
    end

    error("log10 requires exactly 1 argument")
end

function _latexify_log1p(ex::Expr)
    # log1p(p) -> \ln\left(1+p\right) (log(1+p))
    if length(ex.args) == 2
        arg = _latexify(ex.args[2])
        return "\\ln\\left(1+$arg\\right)"
    end

    error("log1p requires exactly 1 argument")
end

function _latexify_ifelse(ex::Expr)
    # ifelse(condition, true_value, false_value) -> \left\{condition:true_value,false_value\right\}
    if length(ex.args) == 4
        condition = _latexify(ex.args[2])
        true_value = _latexify(ex.args[3])
        false_value = _latexify(ex.args[4])
        return "\\left\\{$condition:$true_value,$false_value\\right\\}"
    end

    error("ifelse requires exactly 3 arguments")
end
