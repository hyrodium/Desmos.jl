module DesmosSymbolicsExt

using Desmos
using Symbolics

function Desmos.desmos_latexify(ex::Symbolics.Num, oneterm::Bool = false)
    # Unwrap Num to get the underlying BasicSymbolic
    return desmos_latexify(Symbolics.SymbolicUtils.unwrap(ex), oneterm)
end

function Desmos.desmos_latexify(ex::Symbolics.SymbolicUtils.BasicSymbolic, oneterm::Bool = false)
    if hasproperty(ex, :name)
        # if `ex` is a variable
        return desmos_latexify(string(ex.name))
    elseif hasproperty(ex, :val)
        # if `ex` is a value
        return desmos_latexify(ex.val)
    elseif hasproperty(ex, :coeff)
        # if `ex` is a polynomial
        _dict = ex.dict
        _sortperm = sortperm(desmos_latexify.(keys(_dict)))
        _keys = desmos_latexify.(keys(_dict))[_sortperm]
        _values = desmos_latexify.(values(_dict))[_sortperm]
        _length = length(_keys)
        if Bool(ex.variant)
            if ex.coeff == 1
                # e.g. xyz
                return join(_keys)
            elseif ex.coeff == -1
                # e.g. -xy
                return '-' * join(_keys)
            else
                # e.g. -3x
                return desmos_latexify(ex.coeff) * join(_keys)
            end
        else
            # e.g. x - 2y + z
            if _values[1] == "1"
                coeff = ""
            elseif _values[1] == "-1"
                coeff = "-"
            else
                coeff = _values[1]
            end
            str = coeff * _keys[1]
            for i in 2:_length
                if _values[i] == "1"
                    coeff = "+"
                elseif _values[i] == "-1"
                    coeff = "-"
                elseif startswith(_values[i], '-')
                    coeff = _values[i]
                else
                    coeff = '+' * _values[i]
                end
                str *= coeff * _keys[i]
            end
            intercept = desmos_latexify(ex.coeff)
            if startswith(intercept, '-')
                str *= intercept
            elseif intercept != "0"
                str *= "+$intercept"
            end
            if oneterm
                str = "\\left($str\\right)"
            end
            return str
        end
    elseif hasproperty(ex, :num) && hasproperty(ex, :den)
        num = desmos_latexify(ex.num)
        den = desmos_latexify(ex.den)
        return "\\frac{$num}{$den}"
    elseif hasproperty(ex, :f)
        if ex.f === Base.:^
            _arg1 = desmos_latexify(ex.args[1], true)
            _arg2 = desmos_latexify(ex.args[2])
            return "$(_arg1)^{$(_arg2)}"
        elseif ex.f === Base.:sin
            _args = desmos_latexify.(ex.args)
            return "\\sin\\left($(_args[1])\\right)"
        elseif ex.f === Base.:cos
            _args = desmos_latexify.(ex.args)
            return "\\cos\\left($(_args[1])\\right)"
        elseif ex.f === Base.:tan
            _args = desmos_latexify.(ex.args)
            return "\\tan\\left($(_args[1])\\right)"
        elseif ex.f === Base.:sqrt
            _args = desmos_latexify.(ex.args)
            return "\\sqrt{$(_args[1])}"
        elseif ex.f === Base.:exp
            _args = desmos_latexify.(ex.args)
            return "\\exp\\left($(_args[1])\\right)"
        elseif ex.f === Base.:log
            _args = desmos_latexify.(ex.args)
            return "\\ln\\left($(_args[1])\\right)"
        elseif ex.f === Base.:ifelse
            _cond = desmos_latexify(ex.args[1])
            _true_val = desmos_latexify(ex.args[2])
            _false_val = desmos_latexify(ex.args[3])
            return "\\left\\{$(_cond):$(_true_val),$(_false_val)\\right\\}"
        elseif ex.f === Base.:(>)
            _arg1 = desmos_latexify(ex.args[1])
            _arg2 = desmos_latexify(ex.args[2])
            return "$(_arg1)>$(_arg2)"
        elseif ex.f === Base.:(<)
            _arg1 = desmos_latexify(ex.args[1])
            _arg2 = desmos_latexify(ex.args[2])
            return "$(_arg1)<$(_arg2)"
        elseif ex.f === Base.:(>=)
            _arg1 = desmos_latexify(ex.args[1])
            _arg2 = desmos_latexify(ex.args[2])
            return "$(_arg1)\\ge $(_arg2)"
        elseif ex.f === Base.:(<=)
            _arg1 = desmos_latexify(ex.args[1])
            _arg2 = desmos_latexify(ex.args[2])
            return "$(_arg1)\\le $(_arg2)"
        elseif ex.f === Base.:(==)
            _arg1 = desmos_latexify(ex.args[1])
            _arg2 = desmos_latexify(ex.args[2])
            return "$(_arg1)=$(_arg2)"
        elseif ex.f isa Differential
            D = desmos_latexify(ex.f)
            arg1 = desmos_latexify(ex.args[1], true)
            return "$D$arg1"
        else
            # TODO: add more functions
            error("$(ex.f) is not supported yet!")
        end
    end
    error("Unsupported Symbolics expression type. Properties: $(propertynames(ex))")
end

function Desmos.desmos_latexify(D::Differential)
    return "\\frac{d}{d$(desmos_latexify(D.x))}"^D.order
end

end # module
