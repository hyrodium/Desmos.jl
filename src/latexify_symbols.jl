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

const STANDARD_FUNCTIONS = [
    :sin, :cos, :tan, :cot, :sec, :csc,
    :sinh, :cosh, :tanh, :coth,
    :arcsin, :arccos, :arctan,
    :exp,
    :sqrt, :abs,
    :max, :min,
]
