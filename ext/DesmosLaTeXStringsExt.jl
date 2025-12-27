module DesmosLaTeXStringsExt

using Desmos
using LaTeXStrings

function Desmos.desmos_latexify(s::LaTeXString, oneterm=false)
    return String(chopsuffix(chopprefix(s, "\$"), "\$"))
end

end # module
