const GREEK_LETTERS = Dict(
    'α' => "\\alpha", 'β' => "\\beta", 'γ' => "\\gamma", 'δ' => "\\delta",
    'ε' => "\\epsilon", 'ζ' => "\\zeta", 'η' => "\\eta", 'θ' => "\\theta",
    'ι' => "\\iota", 'κ' => "\\kappa", 'λ' => "\\lambda", 'μ' => "\\mu",
    'ν' => "\\nu", 'ξ' => "\\xi", 'π' => "\\pi", 'ρ' => "\\rho",
    'σ' => "\\sigma", 'τ' => "\\tau", 'υ' => "\\upsilon", 'φ' => "\\phi",
    'χ' => "\\chi", 'ψ' => "\\psi", 'ω' => "\\omega",
    'Α' => "\\Alpha", 'Β' => "\\Beta", 'Γ' => "\\Gamma", 'Δ' => "\\Delta",
    'Ε' => "\\Epsilon", 'Ζ' => "\\Zeta", 'Η' => "\\Eta", 'Θ' => "\\Theta",
    'Ι' => "\\Iota", 'Κ' => "\\Kappa", 'Λ' => "\\Lambda", 'Μ' => "\\Mu",
    'Ν' => "\\Nu", 'Ξ' => "\\Xi", 'Π' => "\\Pi", 'Ρ' => "\\Rho",
    'Σ' => "\\Sigma", 'Τ' => "\\Tau", 'Υ' => "\\Upsilon", 'Φ' => "\\Phi",
    'Χ' => "\\Chi", 'Ψ' => "\\Psi", 'Ω' => "\\Omega"
)

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
const DESMOS_FUNCTIONS = Dict{Symbol,Function}(
    # Standard trigonometric functions
    :sin => arg -> "\\sin\\left($arg\\right)",
    :cos => arg -> "\\cos\\left($arg\\right)",
    :tan => arg -> "\\tan\\left($arg\\right)",
    :cot => arg -> "\\cot\\left($arg\\right)",
    :sec => arg -> "\\sec\\left($arg\\right)",
    :csc => arg -> "\\csc\\left($arg\\right)",

    # Hyperbolic functions
    :sinh => arg -> "\\sinh\\left($arg\\right)",
    :cosh => arg -> "\\cosh\\left($arg\\right)",
    :tanh => arg -> "\\tanh\\left($arg\\right)",
    :coth => arg -> "\\coth\\left($arg\\right)",

    # Inverse trigonometric functions (Julia asin -> Desmos arcsin)
    :asin => arg -> "\\arcsin\\left($arg\\right)",
    :acos => arg -> "\\arccos\\left($arg\\right)",
    :atan => arg -> "\\arctan\\left($arg\\right)",

    # Inverse hyperbolic functions
    :asinh => arg -> "\\operatorname{arcsinh}\\left($arg\\right)",
    :acosh => arg -> "\\operatorname{arccosh}\\left($arg\\right)",
    :atanh => arg -> "\\operatorname{arctanh}\\left($arg\\right)",

    # Other standard functions
    :exp => arg -> "\\exp\\left($arg\\right)",
    :sqrt => arg -> "\\sqrt\\left($arg\\right)",
    :cbrt => arg -> "\\sqrt[3]\\left($arg\\right)",
    :abs => arg -> "\\abs\\left($arg\\right)",
    :max => arg -> "\\max\\left($arg\\right)",
    :min => arg -> "\\min\\left($arg\\right)",

    # Non-standard functions using operatorname
    :sort => arg -> "\\operatorname{sort}\\left($arg\\right)",
    :floor => arg -> "\\operatorname{floor}\\left($arg\\right)",
    :ceil => arg -> "\\operatorname{ceil}\\left($arg\\right)",
    :round => arg -> "\\operatorname{round}\\left($arg\\right)",
    :sum => arg -> "\\operatorname{total}\\left($arg\\right)",
)
