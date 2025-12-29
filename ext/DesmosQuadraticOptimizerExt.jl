module DesmosQuadraticOptimizerExt

using Desmos
using QuadraticOptimizer

function Desmos.desmos_latexify(q::Quadratic{1}, oneterm::Bool = false)
    a = desmos_latexify(q.a[1])
    b = desmos_latexify(q.b[1])
    c = desmos_latexify(q.c)
    str = "\\frac{1}{2}\\left($(a)\\right)x^2+$(b)x+$c"
    if oneterm
        str = "\\left($str\\right)"
    end
    return str
end

function Desmos.desmos_latexify(q::Quadratic{2}, oneterm::Bool = false)
    a1 = desmos_latexify(q.a[1])
    a2 = desmos_latexify(q.a[2])
    a3 = desmos_latexify(q.a[3])
    b1 = desmos_latexify(q.b[1])
    b2 = desmos_latexify(q.b[2])
    c = desmos_latexify(q.c)
    str = "\\frac{1}{2}\\left(\\left($(a1)\\right)x^2+2\\left($(a2)\\right)xy+\\left($(a3)\\right)y^2\\right)+$(b1)x+$(b2)y+$c"
    if oneterm
        str = "\\left($str\\right)"
    end
    return str
end

end # module
