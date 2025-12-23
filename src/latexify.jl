"""
    desmos_latexify(ex) -> LaTeXString

Convert Julia expressions to LaTeX strings suitable for Desmos.
This is a simpler, Desmos-focused alternative to `Latexify.latexify`.
"""
function desmos_latexify(ex)
    return LaTeXString(desmos_latexify(ex))
end

function desmos_latexify(s::LaTeXString)
    return LaTeXString(chopsuffix(chopprefix(s, "\$"), "\$"))
end

function desmos_latexify(c::RGB)
    r = red(c)*255
    g = green(c)*255
    b = blue(c)*255
    str = "\\operatorname{rgb}\\left($r,$g,$b\\right)"
    return LaTeXString(str)
end

"""
    desmos_latexify(ex) -> String

Convert a Julia expression to LaTeX string.
Main dispatcher for different expression types.
"""
function _latexify end

function desmos_latexify(ex::Expr)
    if ex.head == :call
        return _latexify_call(ex)
    elseif ex.head == :tuple
        return _latexify_tuple(ex)
    elseif ex.head == :vect
        return _latexify_vect(ex)
    elseif ex.head == :comprehension
        return _latexify_comprehension(ex)
    elseif ex.head == :block
        return _latexify_block(ex)
    elseif ex.head == :(=)
        return _latexify_assignment(ex)
    else
        throw(UnsupportedDesmosSyntaxError("Unsupported expression head: $(ex.head)"))
    end
end

function desmos_latexify(n::Number)
    if n == Inf
        return "\\infty"
    elseif n == -Inf
        return "-\\infty"
    else
        return string(n)
    end
end

function desmos_latexify(s::Symbol)
    str = string(s)
    return desmos_latexify(str)
end

function desmos_latexify(str::AbstractString)
    # Special case: Inf
    if str == "Inf"
        return "\\infty"
    end

    chars = collect(str)

    # Handle first character
    first_char = chars[1]
    if first_char in UNSUPPORTED_GREEK_LETTERS
        throw(UnsupportedDesmosSyntaxError("The Greek letter '$first_char' is not supported by Desmos."))
    elseif haskey(GREEK_LETTERS, first_char)
        result = GREEK_LETTERS[first_char]
    elseif isletter(first_char) || isdigit(first_char)
        result = string(first_char)
    else
        throw(UnsupportedDesmosSyntaxError("Invalid identifier character: '$first_char'"))
    end

    # If there's only one character, return it
    if length(chars) == 1
        return result
    end

    # Process remaining characters as subscript
    subscript = ""
    for c in chars[2:end]
        if c == '_'
            # Underscore is ignored (skip it)
            continue
        elseif c in UNSUPPORTED_GREEK_LETTERS
            throw(UnsupportedDesmosSyntaxError("The Greek letter '$c' is not supported by Desmos."))
        elseif haskey(SUBSCRIPT_MAP, c)
            # Unicode subscript: ₄ → 4
            subscript *= SUBSCRIPT_MAP[c]
        elseif haskey(GREEK_LETTERS, c)
            # Greek letters not allowed in subscripts
            throw(UnsupportedDesmosSyntaxError("Greek letters are not allowed in subscripts. Use Latin letters or digits only."))
        elseif isletter(c) || isdigit(c)
            # Only Latin letters (a-z, A-Z) and digits (0-9) are allowed
            subscript *= string(c)
        else
            # Any other character is not allowed
            throw(UnsupportedDesmosSyntaxError("Invalid subscript character: '$c'. Only Latin letters, digits, and underscore are allowed."))
        end
    end

    return result * "_{$subscript}"
end

function _latexify_tuple(ex::Expr)
    elements = [desmos_latexify(arg) for arg in ex.args]
    return "\\left($(join(elements, ","))\\right)"
end

function _latexify_vect(ex::Expr)
    elements = [desmos_latexify(arg) for arg in ex.args]
    return "\\left[$(join(elements, ","))\\right]"
end

function _latexify_comprehension(ex::Expr)
    # [sin(x) for x in xs] -> \left[\sin\left(x\right)\operatorname{for}x=x_{s}\right]
    # The comprehension has a generator expression as its only argument
    gen = ex.args[1]
    if gen.head != :generator
        throw(UnsupportedDesmosSyntaxError("Expected generator expression in comprehension"))
    end

    # Extract the term and iterator
    term = desmos_latexify(gen.args[1])
    iter = gen.args[2]

    if iter.head == :(=)
        var = desmos_latexify(iter.args[1])
        collection = desmos_latexify(iter.args[2])
        return "\\left[$term\\ \\operatorname{for}\\ $var=$collection\\right]"
    else
        throw(UnsupportedDesmosSyntaxError("Unsupported iterator syntax in comprehension"))
    end
end

function _latexify_assignment(ex::Expr)
    lhs = desmos_latexify(ex.args[1])
    rhs = desmos_latexify(ex.args[2])
    return "$lhs=$rhs"
end

function _latexify_block(ex::Expr)
    # Block expressions often contain LineNumberNode entries
    # Filter them out and process only the actual expressions
    filtered_args = filter(arg -> !(arg isa LineNumberNode), ex.args)

    # If there's only one expression in the block, return its LaTeX
    if length(filtered_args) == 1
        return desmos_latexify(filtered_args[1])
    elseif length(filtered_args) == 0
        return ""
    else
        # Multiple expressions in a block - join them (though this is rare)
        return join([desmos_latexify(arg) for arg in filtered_args], "; ")
    end
end

function _latexify_call(ex::Expr)
    func = ex.args[1]

    # If func is a Symbol, dispatch based on its value
    if func isa Symbol
        # Check for unsupported operators first
        if func in UNSUPPORTED_OPERATORS
            throw(UnsupportedDesmosSyntaxError("The inequality operator '$func' (\\ne) is not supported by Desmos. Use other comparison operators instead."))
        end

        # Binary operators
        if func == :*
            return _latexify_multiply(ex)
        elseif func == :^
            return _latexify_power(ex)
        end

        # Special functions
        if func == :sum
            # Check if it's a generator expression (sum(... for ...))
            if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
                return _latexify_sum(ex)
            end
            # Otherwise, treat as normal function
        elseif func == :prod
            # Check if it's a generator expression (prod(... for ...))
            if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
                return _latexify_prod(ex)
            end
            # Otherwise, treat as normal function
        elseif func == :integrate
            if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
                return _latexify_integrate(ex)
            end
        elseif func == :int
            # Deprecated: use `integrate` instead
            if length(ex.args) ≥ 2 && ex.args[2] isa Expr && ex.args[2].head == :generator
                return _latexify_integrate(ex)
            end
        end

        # Check if function is in DESMOS_FUNCTIONS dictionaries
        nargs = length(ex.args) - 1  # Number of arguments (excluding function name)

        if nargs == 1 && haskey(DESMOS_FUNCTIONS_1ARG, func)
            # Single-argument function
            arg = desmos_latexify(ex.args[2])
            template = DESMOS_FUNCTIONS_1ARG[func]
            return replace(template, "ARG1" => arg)
        elseif nargs == 2 && haskey(DESMOS_FUNCTIONS_2ARG, func)
            # Two-argument function
            arg1 = desmos_latexify(ex.args[2])
            arg2 = desmos_latexify(ex.args[3])
            template = DESMOS_FUNCTIONS_2ARG[func]
            return replace(template, "ARG1" => arg1, "ARG2" => arg2)
        elseif nargs == 3 && haskey(DESMOS_FUNCTIONS_3ARG, func)
            # Three-argument function
            arg1 = desmos_latexify(ex.args[2])
            arg2 = desmos_latexify(ex.args[3])
            arg3 = desmos_latexify(ex.args[4])
            template = DESMOS_FUNCTIONS_3ARG[func]
            return replace(template, "ARG1" => arg1, "ARG2" => arg2, "ARG3" => arg3)
        elseif haskey(DESMOS_FUNCTIONS_nARG, func)
            # Variable-argument function
            # Special case for addition: join with "+" instead of ","
            separator = (func == :+) ? "+" : ","
            args_str = join([desmos_latexify(arg) for arg in ex.args[2:end]], separator)
            template = DESMOS_FUNCTIONS_nARG[func]
            return replace(template, "ARGS" => args_str)
        end

        # General function call
        return _latexify_general_function(func, ex.args[2:end])
    elseif func isa Expr
        # The function itself is an expression, e.g., (d/dx)(f(x,y))
        # Convert function part to LaTeX and apply to arguments
        func_str = desmos_latexify(func)
        if isempty(ex.args[2:end])
            return func_str
        else
            args_str = join([desmos_latexify(arg) for arg in ex.args[2:end]], ",")
            return "\\left($func_str\\right)\\left($args_str\\right)"
        end
    end

    throw(UnsupportedDesmosSyntaxError("Unsupported function type in call expression: $(typeof(func))"))
end

function _latexify_multiply(ex::Expr)
    # Add parentheses around addition/subtraction expressions to preserve precedence
    factors = []
    for arg in ex.args[2:end]
        latex_arg = desmos_latexify(arg)
        # Add parentheses if the argument is an addition or subtraction expression
        if arg isa Expr && arg.head == :call && (arg.args[1] == :+ || arg.args[1] == :-)
            latex_arg = "\\left($latex_arg\\right)"
        end
        push!(factors, latex_arg)
    end
    return join(factors)
end

function _latexify_power(ex::Expr)
    base = desmos_latexify(ex.args[2])
    exponent = desmos_latexify(ex.args[3])

    # Add parentheses to base if it's an expression
    if ex.args[2] isa Expr
        base = "\\left($base\\right)"
    end

    return "$base^{$exponent}"
end

function _latexify_general_function(func::Symbol, args)
    func_str = desmos_latexify(func)
    if isempty(args)
        return func_str
    else
        args_str = join([desmos_latexify(arg) for arg in args], ",")
        return "$func_str\\left($args_str\\right)"
    end
end

function _latexify_sum(ex::Expr)
    # sum(n^2 for n in 1:5) -> \sum_{n=1}^{5}n^{2}
    gen = ex.args[2]
    term = desmos_latexify(gen.args[1])

    # Parse the iterator
    iter = gen.args[2]
    if iter.head == :(=) && iter.args[2] isa Expr && iter.args[2].head == :call && iter.args[2].args[1] == :(:)
        var = desmos_latexify(iter.args[1])
        start = desmos_latexify(iter.args[2].args[2])
        stop = desmos_latexify(iter.args[2].args[3])
        return "\\sum_{$var=$start}^{$stop}$term"
    end
end

function _latexify_prod(ex::Expr)
    # prod(n^2 for n in 1:5) -> \prod_{n=1}^{5}n^{2}
    gen = ex.args[2]
    term = desmos_latexify(gen.args[1])

    # Parse the iterator
    iter = gen.args[2]
    if iter.head == :(=) && iter.args[2] isa Expr && iter.args[2].head == :call && iter.args[2].args[1] == :(:)
        var = desmos_latexify(iter.args[1])
        start = desmos_latexify(iter.args[2].args[2])
        stop = desmos_latexify(iter.args[2].args[3])
        return "\\prod_{$var=$start}^{$stop}$term"
    end

    throw(UnsupportedDesmosSyntaxError("Unsupported prod syntax"))
end

function _latexify_integrate(ex::Expr)
    # integrate(x^2 for x in 1 .. 5) -> \int_{1}^{5}x^{2}dx
    gen = ex.args[2]
    term = desmos_latexify(gen.args[1])

    # Parse the iterator
    iter = gen.args[2]
    if iter.head == :(=)
        var = desmos_latexify(iter.args[1])
        # Check for interval syntax (1 .. 5)
        range_ex = iter.args[2]
        if range_ex isa Expr && range_ex.head == :call && range_ex.args[1] == :(..)
            start = desmos_latexify(range_ex.args[2])
            stop = desmos_latexify(range_ex.args[3])
            return "\\int_{$start}^{$stop}$(term)d$var"
        end
    end

    throw(UnsupportedDesmosSyntaxError("Unsupported integrate syntax"))
end
