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
        lstr = LaTeXString("\$("*lstr*")\$")
    end
    lstr = remove_mathrm(lstr)
end

function removedollar(s::LaTeXString)
    return chopsuffix(chopprefix(s, "\$"), "\$")
end

function remove_mathrm(s::Union{LaTeXString, SubString{LaTeXStrings.LaTeXString}})
    return LaTeXString(replace(s, "\\mathrm"=>""))
end
