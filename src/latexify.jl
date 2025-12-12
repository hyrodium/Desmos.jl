function desmos_latexify(ex)
    return LaTeXString(removedollar(_latexify(ex)))
end

function desmos_latexify(s::LaTeXString)
    return removedollar(s)
end

function _latexify(ex::Number)
    return latexify(ex)
end

function _latexify(ex::Symbol)
    return latexify(ex)
end

function _latexify(ex)
    lstr = latexify(ex)
    if ex.head === :(tuple)
        lstr = removedollar(lstr)
        lstr = LaTeXString("\$(" * lstr * ")\$")
    end
    return remove_mathrm(lstr)
end

function removedollar(s::LaTeXString)
    return LaTeXString(chopsuffix(chopprefix(s, "\$"), "\$"))
end

function remove_mathrm(s::Union{LaTeXString, SubString{LaTeXStrings.LaTeXString}})
    return LaTeXString(replace(s, "\\mathrm" => ""))
end
