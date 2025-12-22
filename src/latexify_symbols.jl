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
const UNSUPPORTED_GREEK_LETTERS = ['Α', 'Β', 'Ε', 'Ζ', 'Η', 'Ι', 'Κ', 'Μ', 'Ν', 'Ρ', 'Τ', 'Χ']

const SUPERSCRIPT_MAP = Dict(
    '⁰' => "0", '¹' => "1", '²' => "2", '³' => "3", '⁴' => "4",
    '⁵' => "5", '⁶' => "6", '⁷' => "7", '⁸' => "8", '⁹' => "9"
)

const SUBSCRIPT_MAP = Dict(
    '₀' => "0", '₁' => "1", '₂' => "2", '₃' => "3", '₄' => "4",
    '₅' => "5", '₆' => "6", '₇' => "7", '₈' => "8", '₉' => "9"
)

# Unsupported operators that should throw errors
const UNSUPPORTED_OPERATORS = [:(!=), :≠]

# Map Julia function names to LaTeX string templates
# Each template uses ARG1 as a placeholder for the argument
const DESMOS_FUNCTIONS_1ARG = Dict{Symbol, String}(
    # ARITHMETIC OPERATORS
    :- => "-ARG1",  # Unary minus

    # TRIG FUNCTIONS
    :sin => "\\sin\\left(ARG1\\right)",
    :cos => "\\cos\\left(ARG1\\right)",
    :tan => "\\tan\\left(ARG1\\right)",
    :cot => "\\cot\\left(ARG1\\right)",
    :sec => "\\sec\\left(ARG1\\right)",
    :csc => "\\csc\\left(ARG1\\right)",

    # INVERSE TRIG FUNCTIONS
    :asin => "\\arcsin\\left(ARG1\\right)",
    :acos => "\\arccos\\left(ARG1\\right)",
    :atan => "\\arctan\\left(ARG1\\right)",
    :acot => "\\arccot\\left(ARG1\\right)",
    :asec => "\\arcsec\\left(ARG1\\right)",
    :acsc => "\\arccsc\\left(ARG1\\right)",

    # STATISTICS
    :mean => "\\operatorname{mean}\\left(ARG1\\right)",
    :median => "\\operatorname{median}\\left(ARG1\\right)",
    :minimum => "\\min\\left(ARG1\\right)",
    :maximum => "\\max\\left(ARG1\\right)",
    :stdev => "\\operatorname{stdev}\\left(ARG1\\right)",
    :stdevp => "\\operatorname{stdevp}\\left(ARG1\\right)",
    :var => "\\operatorname{var}\\left(ARG1\\right)",
    :varp => "\\operatorname{varp}\\left(ARG1\\right)",
    :mad => "\\operatorname{mad}\\left(ARG1\\right)",
    # :spearman => "\\operatorname{spearman}\\left(ARG1\\right)",
    :stats => "\\operatorname{stats}\\left(ARG1\\right)",
    :length => "\\operatorname{count}\\left(ARG1\\right)",
    :total => "\\operatorname{total}\\left(ARG1\\right)",
    :sum => "\\operatorname{total}\\left(ARG1\\right)",

    # LIST OPERATIONS
    :sort => "\\operatorname{sort}\\left(ARG1\\right)",
    :shuffle => "\\operatorname{shuffle}\\left(ARG1\\right)",
    :unique => "\\operatorname{unique}\\left(ARG1\\right)",

    # VISUALIZATIONS
    :histogram => "\\operatorname{histogram}\\left(ARG1\\right)",
    :dotplot => "\\operatorname{dotplot}\\left(ARG1\\right)",
    :boxplot => "\\operatorname{boxplot}\\left(ARG1\\right)",

    # PROBABILITY DISTRIBUTIONS
    :normaldist => "\\operatorname{normaldist}\\left(ARG1\\right)",
    :tdist => "\\operatorname{tdist}\\left(ARG1\\right)",
    :chisqdist => "\\operatorname{chisqdist}\\left(ARG1\\right)",
    :uniformdist => "\\operatorname{uniformdist}\\left(ARG1\\right)",
    :binomialdist => "\\operatorname{binomialdist}\\left(ARG1\\right)",
    :poissondist => "\\operatorname{poissondist}\\left(ARG1\\right)",
    :geodist => "\\operatorname{geodist}\\left(ARG1\\right)",
    :pdf => "\\operatorname{pdf}\\left(ARG1\\right)",
    :cdf => "\\operatorname{cdf}\\left(ARG1\\right)",
    :inversecdf => "\\operatorname{inversecdf}\\left(ARG1\\right)",
    :random => "\\operatorname{random}\\left(ARG1\\right)",

    # INFERENCE
    :ztest => "\\operatorname{ztest}\\left(ARG1\\right)",
    :ttest => "\\operatorname{ttest}\\left(ARG1\\right)",
    :zproptest => "\\operatorname{zproptest}\\left(ARG1\\right)",
    :chisqtest => "\\operatorname{chisqtest}\\left(ARG1\\right)",
    :chisqgof => "\\operatorname{chisqgof}\\left(ARG1\\right)",
    :pleft => "\\operatorname{pleft}\\left(ARG1\\right)",
    :pright => "\\operatorname{pright}\\left(ARG1\\right)",
    :score => "\\operatorname{score}\\left(ARG1\\right)",
    :dof => "\\operatorname{dof}\\left(ARG1\\right)",
    :stderr => "\\operatorname{stderr}\\left(ARG1\\right)",
    :conf => "\\operatorname{conf}\\left(ARG1\\right)",
    :lower => "\\operatorname{lower}\\left(ARG1\\right)",
    :upper => "\\operatorname{upper}\\left(ARG1\\right)",
    :estimate => "\\operatorname{estimate}\\left(ARG1\\right)",

    # CALCULUS
    :exp => "\\exp\\left(ARG1\\right)",
    :log => "\\ln\\left(ARG1\\right)",  # 1-arg: natural logarithm
    :log10 => "\\log\\left(ARG1\\right)",
    :log1p => "\\ln\\left(1+ARG1\\right)",  # log(1+p)

    # HYPERBOLIC TRIG FUNCTIONS
    :sinh => "\\sinh\\left(ARG1\\right)",
    :cosh => "\\cosh\\left(ARG1\\right)",
    :tanh => "\\tanh\\left(ARG1\\right)",
    :coth => "\\coth\\left(ARG1\\right)",
    :sech => "\\sech\\left(ARG1\\right)",
    :csch => "\\csch\\left(ARG1\\right)",
    :asinh => "\\operatorname{arcsinh}\\left(ARG1\\right)",
    :acosh => "\\operatorname{arccosh}\\left(ARG1\\right)",
    :atanh => "\\operatorname{arctanh}\\left(ARG1\\right)",
    :acoth => "\\operatorname{arccoth}\\left(ARG1\\right)",
    :asech => "\\operatorname{arcsech}\\left(ARG1\\right)",
    :acsch => "\\operatorname{arccsch}\\left(ARG1\\right)",

    # GEOMETRY

    # CUSTOM COLORS

    # SOUND

    # NUMBER THEORY
    :lcm => "\\operatorname{lcm}\\left(ARG1\\right)",
    :gcd => "\\operatorname{gcd}\\left(ARG1\\right)",
    :mod => "\\operatorname{mod}\\left(ARG1\\right)",
    :ceil => "\\operatorname{ceil}\\left(ARG1\\right)",
    :floor => "\\operatorname{floor}\\left(ARG1\\right)",
    :round => "\\operatorname{round}\\left(ARG1\\right)",
    :sign => "\\operatorname{sign}\\left(ARG1\\right)",
    :nPr => "\\operatorname{nPr}\\left(ARG1\\right)",
    :binomial => "\\operatorname{nCr}\\left(ARG1\\right)",
    :sqrt => "\\sqrt\\left(ARG1\\right)",
    :cbrt => "\\sqrt[3]\\left(ARG1\\right)",

    # ADVANCED

    # OTHERS
    :factorial => "\\left(ARG1\\right)!",
    :abs => "\\operatorname{abs}\\left(ARG1\\right)",
)

# Map Julia function names to LaTeX string templates (2 arguments)
# Each template uses ARG1 and ARG2 as placeholders
const DESMOS_FUNCTIONS_2ARG = Dict{Symbol, String}(
    # ARITHMETIC OPERATORS
    :- => "ARG1-ARG2",  # Binary minus
    :/ => "\\frac{ARG1}{ARG2}",  # Division

    # STATISTICS
    :cov => "\\operatorname{cov}\\left(ARG1,ARG2\\right)",
    :covp => "\\operatorname{covp}\\left(ARG1,ARG2\\right)",
    :corr => "\\operatorname{corr}\\left(ARG1,ARG2\\right)",
    # :quartile => "\\operatorname{quartile}\\left(ARG1,ARG2\\right)",
    :quantile => "\\operatorname{quantile}\\left(ARG1,ARG2\\right)",

    # CALCULUS
    :log => "\\log_{ARG1}\\left(ARG2\\right)",  # 2-arg: logarithm with custom base
    :gradient => "\\frac{d}{dARG2}ARG1",  # gradient(f, x) -> d/dx f

    # LIST OPERATIONS
    :fill => "\\operatorname{repeat}\\left(ARG1,ARG2\\right)",

    # OHTERS
    :> => "ARG1>ARG2",
    :< => "ARG1<ARG2",
    :(==) => "ARG1=ARG2",
    :(>=) => "ARG1\\ge ARG2",
    :(<=) => "ARG1\\le ARG2",
    :≥ => "ARG1\\ge ARG2",
    :≤ => "ARG1\\le ARG2",
    :~ => "ARG1\\sim ARG2",
)

# Map Julia function names to LaTeX string templates (3 arguments)
# Each template uses ARG1, ARG2, and ARG3 as placeholders
const DESMOS_FUNCTIONS_3ARG = Dict{Symbol, String}(
    # OTHERS
    :ifelse => "\\left\\{ARG1:ARG2,ARG3\\right\\}",
)

# Map Julia function names to LaTeX string templates (n arguments)
# Each template uses ARGS as a placeholder for comma-separated arguments
const DESMOS_FUNCTIONS_nARG = Dict{Symbol, String}(
    # ARITHMETIC OPERATORS
    :+ => "ARGS",  # Addition (note: args are joined with + in latexify.jl)

    # STATISTICS
    :min => "\\min\\left(ARGS\\right)",
    :max => "\\max\\left(ARGS\\right)",

    # LIST OPERATIONS
    :hcat => "\\operatorname{join}\\left(ARGS\\right)",
)
