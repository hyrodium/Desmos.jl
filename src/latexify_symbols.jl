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
const DESMOS_FUNCTIONS_1ARG = Dict{Symbol, Function}(
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
    :mean => arg -> "\\operatorname{mean}\\left($arg\\right)",
    :median => arg -> "\\operatorname{median}\\left($arg\\right)",
    :min => arg -> "\\min\\left($arg\\right)",
    :max => arg -> "\\max\\left($arg\\right)",
    :quartile => arg -> "\\operatorname{quartile}\\left($arg\\right)",
    :quantile => arg -> "\\operatorname{quantile}\\left($arg\\right)",
    :stdev => arg -> "\\operatorname{stdev}\\left($arg\\right)",
    :stdevp => arg -> "\\operatorname{stdevp}\\left($arg\\right)",
    :var => arg -> "\\operatorname{var}\\left($arg\\right)",
    :varp => arg -> "\\operatorname{varp}\\left($arg\\right)",
    :cov => arg -> "\\operatorname{cov}\\left($arg\\right)",
    :covp => arg -> "\\operatorname{covp}\\left($arg\\right)",
    :mad => arg -> "\\operatorname{mad}\\left($arg\\right)",
    :corr => arg -> "\\operatorname{corr}\\left($arg\\right)",
    :spearman => arg -> "\\operatorname{spearman}\\left($arg\\right)",
    :stats => arg -> "\\operatorname{stats}\\left($arg\\right)",
    :count => arg -> "\\operatorname{count}\\left($arg\\right)",
    :total => arg -> "\\operatorname{total}\\left($arg\\right)",
    :sum => arg -> "\\operatorname{total}\\left($arg\\right)",

    # LIST OPERATIONS
    :repeat => arg -> "\\operatorname{repeat}\\left($arg\\right)",
    :join => arg -> "\\operatorname{join}\\left($arg\\right)",
    :sort => arg -> "\\operatorname{sort}\\left($arg\\right)",
    :shuffle => arg -> "\\operatorname{shuffle}\\left($arg\\right)",
    :unique => arg -> "\\operatorname{unique}\\left($arg\\right)",

    # VISUALIZATIONS
    :histogram => arg -> "\\operatorname{histogram}\\left($arg\\right)",
    :dotplot => arg -> "\\operatorname{dotplot}\\left($arg\\right)",
    :boxplot => arg -> "\\operatorname{boxplot}\\left($arg\\right)",

    # PROBABILITY DISTRIBUTIONS
    :normaldist => arg -> "\\operatorname{normaldist}\\left($arg\\right)",
    :tdist => arg -> "\\operatorname{tdist}\\left($arg\\right)",
    :chisqdist => arg -> "\\operatorname{chisqdist}\\left($arg\\right)",
    :uniformdist => arg -> "\\operatorname{uniformdist}\\left($arg\\right)",
    :binomialdist => arg -> "\\operatorname{binomialdist}\\left($arg\\right)",
    :poissondist => arg -> "\\operatorname{poissondist}\\left($arg\\right)",
    :geodist => arg -> "\\operatorname{geodist}\\left($arg\\right)",
    :pdf => arg -> "\\operatorname{pdf}\\left($arg\\right)",
    :cdf => arg -> "\\operatorname{cdf}\\left($arg\\right)",
    :inversecdf => arg -> "\\operatorname{inversecdf}\\left($arg\\right)",
    :random => arg -> "\\operatorname{random}\\left($arg\\right)",

    # INFERENCE
    :ztest => arg -> "\\operatorname{ztest}\\left($arg\\right)",
    :ttest => arg -> "\\operatorname{ttest}\\left($arg\\right)",
    :zproptest => arg -> "\\operatorname{zproptest}\\left($arg\\right)",
    :chisqtest => arg -> "\\operatorname{chisqtest}\\left($arg\\right)",
    :chisqgof => arg -> "\\operatorname{chisqgof}\\left($arg\\right)",
    :pleft => arg -> "\\operatorname{pleft}\\left($arg\\right)",
    :pright => arg -> "\\operatorname{pright}\\left($arg\\right)",
    :score => arg -> "\\operatorname{score}\\left($arg\\right)",
    :dof => arg -> "\\operatorname{dof}\\left($arg\\right)",
    :stderr => arg -> "\\operatorname{stderr}\\left($arg\\right)",
    :conf => arg -> "\\operatorname{conf}\\left($arg\\right)",
    :lower => arg -> "\\operatorname{lower}\\left($arg\\right)",
    :upper => arg -> "\\operatorname{upper}\\left($arg\\right)",
    :estimate => arg -> "\\operatorname{estimate}\\left($arg\\right)",

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
    :lcm => arg -> "\\operatorname{lcm}\\left($arg\\right)",
    :gcd => arg -> "\\operatorname{gcd}\\left($arg\\right)",
    :mod => arg -> "\\operatorname{mod}\\left($arg\\right)",
    :ceil => arg -> "\\operatorname{ceil}\\left($arg\\right)",
    :floor => arg -> "\\operatorname{floor}\\left($arg\\right)",
    :round => arg -> "\\operatorname{round}\\left($arg\\right)",
    :sign => arg -> "\\operatorname{sign}\\left($arg\\right)",
    :nPr => arg -> "\\operatorname{nPr}\\left($arg\\right)",
    :nCr => arg -> "\\operatorname{nCr}\\left($arg\\right)",
    :sqrt => arg -> "\\sqrt\\left($arg\\right)",
    :cbrt => arg -> "\\sqrt[3]\\left($arg\\right)",

    # ADVANCED

    # OTHERS
    :factorial => arg -> "\\left($arg\\right)!",
    :abs => arg -> "\\operatorname{abs}\\left($arg\\right)",
)
