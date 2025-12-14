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

    # Special case: Inf
    if str == "Inf"
        return "\\infty"
    end

    result = ""
    i = 1
    while i ≤ ncodeunits(str)
        c = str[i]

        if haskey(GREEK_LETTERS, c)
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
                        # Convert Greek letters in subscripts
                        if haskey(GREEK_LETTERS, next_c)
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

        # Special functions
        if func == :sum
            return _latexify_sum(ex)
        elseif func == :prod
            return _latexify_prod(ex)
        elseif func == :int
            return _latexify_int(ex)
        elseif func == :gradient
            return _latexify_gradient(ex)
        end

        # Standard LaTeX functions
        if func in LATEX_FUNCTIONS
            return _latexify_latex_function(func, ex.args[2:end])
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

    # Add parentheses to base
    if ex.args[2] isa Expr
        # Don't add parentheses for function calls (like sin(x), cos(x), etc.)
        if ex.args[2].head == :call
            # Check if it's a LaTeX function or general function
            func = ex.args[2].args[1]
            if func isa Symbol && func in LATEX_FUNCTIONS
                # Don't add parentheses for LaTeX functions like \sin, \cos
            else
                # Add parentheses for general functions
                base = "\\left($base\\right)"
            end
        else
            # Add parentheses for all other expressions (operators, etc.)
            base = "\\left($base\\right)"
        end
    end

    return "$base^{$exponent}"
end

function _latexify_latex_function(func::Symbol, args)
    args_str = join([_latexify(arg) for arg in args], ",")
    return "\\$func\\left($args_str\\right)"
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
