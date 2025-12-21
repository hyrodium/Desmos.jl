const GREEK_LETTERS = Dict(
    'α' => "\\alpha", 'β' => "\\beta", 'γ' => "\\gamma", 'δ' => "\\delta",
    'ε' => "\\epsilon", 'ζ' => "\\zeta", 'η' => "\\eta", 'θ' => "\\theta",
    'ι' => "\\iota", 'κ' => "\\kappa", 'λ' => "\\lambda", 'μ' => "\\mu",
    'ν' => "\\nu", 'ξ' => "\\xi", 'π' => "\\pi", 'ρ' => "\\rho",
    'σ' => "\\sigma", 'τ' => "\\tau", 'υ' => "\\upsilon", 'φ' => "\\phi",
    'χ' => "\\chi", 'ψ' => "\\psi", 'ω' => "\\omega",
    'Γ' => "\\Gamma", 'Δ' => "\\Delta", 'Θ' => "\\Theta",
    'Λ' => "\\Lambda", 'Ξ' => "\\Xi", 'Π' => "\\Pi",
    'Σ' => "\\Sigma", 'Υ' => "\\Upsilon", 'Φ' => "\\Phi",
    'Ψ' => "\\Psi", 'Ω' => "\\Omega"
)

# Greek letters that are not supported by Desmos (look like Latin letters)
const UNSUPPORTED_GREEK_LETTERS = Set(['Α', 'Β', 'Ε', 'Ζ', 'Η', 'Ι', 'Κ', 'Μ', 'Ν', 'Ρ', 'Τ', 'Χ'])

const SUPERSCRIPT_MAP = Dict(
    '⁰' => "0", '¹' => "1", '²' => "2", '³' => "3", '⁴' => "4",
    '⁵' => "5", '⁶' => "6", '⁷' => "7", '⁸' => "8", '⁹' => "9"
)

const SUBSCRIPT_MAP = Dict(
    '₀' => "0", '₁' => "1", '₂' => "2", '₃' => "3", '₄' => "4",
    '₅' => "5", '₆' => "6", '₇' => "7", '₈' => "8", '₉' => "9"
)

# Map Julia function names to LaTeX string generators
# Each function takes a LaTeX string (single argument) and returns a LaTeX string
const DESMOS_FUNCTIONS = Dict{Symbol, Function}(
    # TRIG FUNCTIONS
    :sin => arg -> "\\sin\\left($arg\\right)",
    :cos => arg -> "\\cos\\left($arg\\right)",
    :tan => arg -> "\\tan\\left($arg\\right)",
    :cot => arg -> "\\cot\\left($arg\\right)",
    :sec => arg -> "\\sec\\left($arg\\right)",
    :csc => arg -> "\\csc\\left($arg\\right)",

    # INVERSE TRIG FUNCTIONS
    :asin => arg -> "\\arcsin\\left($arg\\right)",
    :acos => arg -> "\\arccos\\left($arg\\right)",
    :atan => arg -> "\\arctan\\left($arg\\right)",
    :acot => arg -> "\\arccot\\left($arg\\right)",
    :asec => arg -> "\\arcsec\\left($arg\\right)",
    :acsc => arg -> "\\arccsc\\left($arg\\right)",

    # STATISTICS
    :min => arg -> "\\min\\left($arg\\right)",
    :max => arg -> "\\max\\left($arg\\right)",
    :sum => arg -> "\\operatorname{total}\\left($arg\\right)",

    # LIST OPERATIONS
    :sort => arg -> "\\operatorname{sort}\\left($arg\\right)",

    # VISUALIZATIONS

    # PROBABILITY DISTRIBUTIONS

    # INFERENCE

    # CALCULUS
    :exp => arg -> "\\exp\\left($arg\\right)",

    # HYPERBOLIC TRIG FUNCTIONS
    :sinh => arg -> "\\sinh\\left($arg\\right)",
    :cosh => arg -> "\\cosh\\left($arg\\right)",
    :tanh => arg -> "\\tanh\\left($arg\\right)",
    :coth => arg -> "\\coth\\left($arg\\right)",
    :sech => arg -> "\\sech\\left($arg\\right)",
    :csch => arg -> "\\csch\\left($arg\\right)",
    :asinh => arg -> "\\operatoorname{arcsinh}\\left($arg\\right)",
    :acosh => arg -> "\\operatoorname{arccosh}\\left($arg\\right)",
    :atanh => arg -> "\\operatoorname{arctanh}\\left($arg\\right)",
    :acoth => arg -> "\\operatoorname{arccoth}\\left($arg\\right)",
    :asech => arg -> "\\operatoorname{arcsech}\\left($arg\\right)",
    :acsch => arg -> "\\operatoorname{arccsch}\\left($arg\\right)",

    # GEOMETRY

    # CUSTOM COLORS

    # SOUND

    # NUMBER THEORY
    :sqrt => arg -> "\\sqrt\\left($arg\\right)",
    :cbrt => arg -> "\\sqrt[3]\\left($arg\\right)",
    :ceil => arg -> "\\operatorname{ceil}\\left($arg\\right)",
    :floor => arg -> "\\operatorname{floor}\\left($arg\\right)",
    :round => arg -> "\\operatorname{round}\\left($arg\\right)",

    # ADVANCED

    # OTHERS
    :factorial => arg -> "\\left($arg\\right)!",
    :abs => arg -> "\\operatorname{abs}\\left($arg\\right)",
)
