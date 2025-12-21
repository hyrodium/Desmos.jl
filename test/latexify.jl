@testset "latexify" begin
    @testset "Arithmetic" begin
        @test Desmos.desmos_latexify(:(1 + 1)) == "1+1"
        @test Desmos.desmos_latexify(:(x - y)) == "x-y"
        @test Desmos.desmos_latexify(:(a * b)) == "a\\cdot b"
        @test Desmos.desmos_latexify(:(x / y)) == "\\frac{x}{y}"
        @test Desmos.desmos_latexify(:(x^2)) == "x^{2}"
        @test Desmos.desmos_latexify(:(x^y)) == "x^{y}"
        @test Desmos.desmos_latexify(:(-x)) == "-x"
        @test Desmos.desmos_latexify(:(a + b - c)) == "a+b-c"
        @test Desmos.desmos_latexify(:(2 * x + 3)) == "2\\cdot x+3"
    end

    @testset "Functions" begin
        @test Desmos.desmos_latexify(:(sin(x))) == "\\sin\\left(x\\right)"
        @test Desmos.desmos_latexify(:(cos(θ))) == "\\cos\\left(\\theta\\right)"
        @test Desmos.desmos_latexify(:(tan(x))) == "\\tan\\left(x\\right)"
        @test Desmos.desmos_latexify(:(exp(x))) == "\\exp\\left(x\\right)"
        @test Desmos.desmos_latexify(:(sqrt(x))) == "\\sqrt\\left(x\\right)"
        @test Desmos.desmos_latexify(:(abs(x))) == "\\abs\\left(x\\right)"
        @test Desmos.desmos_latexify(:(sinh(x))) == "\\sinh\\left(x\\right)"
        @test Desmos.desmos_latexify(:(cosh(x))) == "\\cosh\\left(x\\right)"
        @test Desmos.desmos_latexify(:(tanh(x))) == "\\tanh\\left(x\\right)"
        # Inverse trig functions (Julia asin -> Desmos arcsin)
        @test Desmos.desmos_latexify(:(asin(x))) == "\\arcsin\\left(x\\right)"
        @test Desmos.desmos_latexify(:(acos(x))) == "\\arccos\\left(x\\right)"
        @test Desmos.desmos_latexify(:(atan(x))) == "\\arctan\\left(x\\right)"
    end

    @testset "Logarithms" begin
        # ln is not supported, and is parsed as standard function
        @test Desmos.desmos_latexify(:(ln(x))) == "ln\\left(x\\right)"
        # log functions
        @test Desmos.desmos_latexify(:(log(x))) == "\\ln\\left(x\\right)"
        @test Desmos.desmos_latexify(:(log(2, x))) == "\\log_{2}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(log(a, b))) == "\\log_{a}\\left(b\\right)"
        @test Desmos.desmos_latexify(:(log10(x))) == "\\log\\left(x\\right)"
        @test Desmos.desmos_latexify(:(log10(100))) == "\\log\\left(100\\right)"
        @test Desmos.desmos_latexify(:(log1p(x))) == "\\ln\\left(1+x\\right)"
        @test Desmos.desmos_latexify(:(log1p(a + b))) == "\\ln\\left(1+a+b\\right)"
    end

    @testset "Comparison operators" begin
        @test Desmos.desmos_latexify(:(x > 0)) == "x>0"
        @test Desmos.desmos_latexify(:(x < 0)) == "x<0"
        @test Desmos.desmos_latexify(:(a == b)) == "a=b"
        @test Desmos.desmos_latexify(:(x >= 1)) == "x\\ge 1"
        @test Desmos.desmos_latexify(:(x <= 1)) == "x\\le 1"
        @test Desmos.desmos_latexify(:(a != b)) == "a\\ne b"
        # Unicode operators
        @test Desmos.desmos_latexify(:(x ≥ 1)) == "x\\ge 1"
        @test Desmos.desmos_latexify(:(x ≤ 1)) == "x\\le 1"
        @test Desmos.desmos_latexify(:(a ≠ b)) == "a\\ne b"
    end

    @testset "Piecewise functions (ifelse)" begin
        @test Desmos.desmos_latexify(:(ifelse(x > 0, x, 0))) == "\\left\\{x>0:x,0\\right\\}"
        @test Desmos.desmos_latexify(:(ifelse(x < 0, -x, x))) == "\\left\\{x<0:-x,x\\right\\}"
        @test Desmos.desmos_latexify(:(ifelse(a == b, 1, 0))) == "\\left\\{a=b:1,0\\right\\}"
    end

    @testset "Operatorname functions" begin
        @test Desmos.desmos_latexify(:(sort([5, 4, 88]))) == "\\operatorname{sort}\\left(\\left[5,4,88\\right]\\right)"
        @test Desmos.desmos_latexify(:(sort(x))) == "\\operatorname{sort}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(floor(x))) == "\\operatorname{floor}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(ceil(x))) == "\\operatorname{ceil}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(round(x))) == "\\operatorname{round}\\left(x\\right)"
    end

    @testset "Multi-argument functions" begin
        @test Desmos.desmos_latexify(:(f(x, y))) == "f\\left(x,y\\right)"
        @test Desmos.desmos_latexify(:(g(a, b, c))) == "g\\left(a,b,c\\right)"
        @test Desmos.desmos_latexify(:(max(x, y))) == "\\max\\left(x,y\\right)"
    end

    @testset "Symbols" begin
        @test Desmos.desmos_latexify(:(x)) == "x"
        @test Desmos.desmos_latexify(:(x_1)) == "x_{1}"
        @test Desmos.desmos_latexify(:(x_y)) == "x_{y}"
        @test Desmos.desmos_latexify(:(x_abc)) == "x_{abc}"
        @test Desmos.desmos_latexify(:(tan(x_y))) == "\\tan\\left(x_{y}\\right)"
        @test Desmos.desmos_latexify(:(a₁)) == "a_{1}"
        @test Desmos.desmos_latexify(:(x₀)) == "x_{0}"
        @test Desmos.desmos_latexify(:(n₁₂₃)) == "n_{123}"
    end

    @testset "Greek letters" begin
        @test Desmos.desmos_latexify(:(α)) == "\\alpha"
        @test Desmos.desmos_latexify(:(β)) == "\\beta"
        @test Desmos.desmos_latexify(:(γ)) == "\\gamma"
        @test Desmos.desmos_latexify(:(θ)) == "\\theta"
        @test Desmos.desmos_latexify(:(π)) == "\\pi"
        @test Desmos.desmos_latexify(:(Γ)) == "\\Gamma"
        @test Desmos.desmos_latexify(:(Δ)) == "\\Delta"
        @test Desmos.desmos_latexify(:(Ω)) == "\\Omega"
        @test Desmos.desmos_latexify(:(α_5)) == "\\alpha_{5}"
        @test Desmos.desmos_latexify(:(β_n)) == "\\beta_{n}"
    end

    @testset "Superscripts" begin
        @test Desmos.desmos_latexify(:(x⁰)) == "x^{0}"
        @test Desmos.desmos_latexify(:(x¹)) == "x^{1}"
        @test Desmos.desmos_latexify(:(x²)) == "x^{2}"
        @test Desmos.desmos_latexify(:(x⁵)) == "x^{5}"
        @test Desmos.desmos_latexify(:(Β⁵)) == "\\Beta^{5}"
        @test Desmos.desmos_latexify(:(α_5 - Β⁵)) == "\\alpha_{5}-\\Beta^{5}"
    end

    @testset "Special values" begin
        @test Desmos.desmos_latexify(:(Inf)) == "\\infty"
        @test Desmos.desmos_latexify(:(1.5)) == "1.5"
        @test Desmos.desmos_latexify(:(42)) == "42"
        @test Desmos.desmos_latexify(:(-3.14)) == "-3.14"
    end

    @testset "Tuples and arrays" begin
        @test Desmos.desmos_latexify(:((a, b))) == "\\left(a,b\\right)"
        @test Desmos.desmos_latexify(:((x, y, z))) == "\\left(x,y,z\\right)"
        @test Desmos.desmos_latexify(:([1, 2, 3])) == "\\left[1,2,3\\right]"
        @test Desmos.desmos_latexify(:([a, b])) == "\\left[a,b\\right]"
        @test Desmos.desmos_latexify(:([x + 1, y - 2])) == "\\left[x+1,y-2\\right]"
    end

    @testset "Assignments" begin
        @test Desmos.desmos_latexify(:(x = 5)) == "x=5"
        @test Desmos.desmos_latexify(:(y = x + 1)) == "y=x+1"
        @test Desmos.desmos_latexify(:(f(x) = x^2)) == "f\\left(x\\right)=x^{2}"
        @test Desmos.desmos_latexify(:(g(x, y) = x + y)) == "g\\left(x,y\\right)=x+y"
    end

    @testset "Tilde operator" begin
        @test Desmos.desmos_latexify(:(y_1 ~ a * x_1 + b)) == "y_{1}\\sim a\\cdot x_{1}+b"
        @test Desmos.desmos_latexify(:(y ~ x)) == "y\\sim x"
        @test Desmos.desmos_latexify(:(f(x) ~ g(x))) == "f\\left(x\\right)\\sim g\\left(x\\right)"
    end

    @testset "Complex expressions" begin
        @test Desmos.desmos_latexify(:(x^2 + y^2)) == "x^{2}+y^{2}"
        @test Desmos.desmos_latexify(:(sin(x) + cos(x))) == "\\sin\\left(x\\right)+\\cos\\left(x\\right)"
        @test Desmos.desmos_latexify(:((x + y)^2)) == "\\left(x+y\\right)^{2}"
        @test Desmos.desmos_latexify(:(x / (y + z))) == "\\frac{x}{y+z}"
        @test Desmos.desmos_latexify(:((a * b) / (c + d))) == "\\frac{a\\cdot b}{c+d}"
    end

    @testset "Sum and integral" begin
        @test Desmos.desmos_latexify(:(sum(n^2 for n in 1:5))) == "\\sum_{n=1}^{5}n^{2}"
        @test Desmos.desmos_latexify(:(sum(i for i in 0:10))) == "\\sum_{i=0}^{10}i"
        @test Desmos.desmos_latexify(:(sum(x_i for i in 1:n))) == "\\sum_{i=1}^{n}x_{i}"
        @test Desmos.desmos_latexify(:(prod(n^2 for n in 1:5))) == "\\prod_{n=1}^{5}n^{2}"
        @test Desmos.desmos_latexify(:(prod(i for i in 0:10))) == "\\prod_{i=0}^{10}i"
        @test Desmos.desmos_latexify(:(prod(x_i for i in 1:n))) == "\\prod_{i=1}^{n}x_{i}"
        @test Desmos.desmos_latexify(:(int(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test Desmos.desmos_latexify(:(int(y for y in -5 .. -2))) == "\\int_{-5}^{-2}ydy"
    end

    @testset "Integral" begin
        @test Desmos.desmos_latexify(:(int(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test Desmos.desmos_latexify(:(int(sin(t) for t in 0 .. π))) == "\\int_{0}^{\\pi}\\sin\\left(t\\right)dt"
    end

    @testset "Gradient" begin
        @test Desmos.desmos_latexify(:(gradient(f, x))) == "\\frac{d}{dx}f"
        @test Desmos.desmos_latexify(:(gradient(g, t))) == "\\frac{d}{dt}g"
    end

    @testset "LaTeXString input" begin
        @test Desmos.desmos_latexify(L"\sin(x)") == "\\sin(x)"
        @test Desmos.desmos_latexify(L"$\alpha + \beta$") == "\\alpha + \\beta"
        @test Desmos.desmos_latexify(L"\frac{1}{2}") == "\\frac{1}{2}"
    end

    @testset "Composed functions" begin
        @test Desmos.desmos_latexify(:((d / dx)(f(x)))) == "\\left(\\frac{d}{dx}\\right)\\left(f\\left(x\\right)\\right)"
    end

    @testset "Multi-character variables" begin
        @test Desmos.desmos_latexify(:(xy)) == "xy"
        @test Desmos.desmos_latexify(:(abc)) == "abc"
        @test Desmos.desmos_latexify(:(dx)) == "dx"
        @test Desmos.desmos_latexify(:(dy)) == "dy"
        @test Desmos.desmos_latexify(:(dt)) == "dt"
    end

    @testset "Mixed operations" begin
        @test Desmos.desmos_latexify(:(2x + 3y)) == "2\\cdot x+3\\cdot y"
        @test Desmos.desmos_latexify(:(a * b + c / d)) == "a\\cdot b+\\frac{c}{d}"
        @test Desmos.desmos_latexify(:(x^2 - 2x + 1)) == "x^{2}-2\\cdot x+1"
    end

    @testset "Edge cases: Parentheses and precedence" begin
        @test Desmos.desmos_latexify(:((a + b)^(c + d))) == "\\left(a+b\\right)^{c+d}"
        @test Desmos.desmos_latexify(:((x * y)^z)) == "\\left(x\\cdot y\\right)^{z}"
        @test Desmos.desmos_latexify(:((a - b) * (c + d))) == "\\left(a-b\\right)\\cdot \\left(c+d\\right)"
        @test Desmos.desmos_latexify(:(a + b * c)) == "a+b\\cdot c"
        @test Desmos.desmos_latexify(:((a + b) * c)) == "\\left(a+b\\right)\\cdot c"
    end

    @testset "Edge cases: Negative numbers and signs" begin
        @test Desmos.desmos_latexify(:(-1)) == "-1"
        @test Desmos.desmos_latexify(:(-x - y)) == "-x-y"
        @test Desmos.desmos_latexify(:(x + -y)) == "x-y"
        @test Desmos.desmos_latexify(:(a * -b)) == "a\\cdot \\left(-b\\right)"
        @test Desmos.desmos_latexify(:(-(-x))) == "--x"
    end

    @testset "Edge cases: Empty and single elements" begin
        @test Desmos.desmos_latexify(:((a,))) == "\\left(a\\right)"
        @test Desmos.desmos_latexify(:([x])) == "\\left[x\\right]"
        @test Desmos.desmos_latexify(:(f())) == "f"
    end

    @testset "Edge cases: Nested structures" begin
        @test Desmos.desmos_latexify(:((a, (b, c)))) == "\\left(a,\\left(b,c\\right)\\right)"
        @test Desmos.desmos_latexify(:([1, [2, 3]])) == "\\left[1,\\left[2,3\\right]\\right]"
        @test Desmos.desmos_latexify(:(sin(cos(x)))) == "\\sin\\left(\\cos\\left(x\\right)\\right)"
        @test Desmos.desmos_latexify(:(f(g(h(x))))) == "f\\left(g\\left(h\\left(x\\right)\\right)\\right)"
        @test Desmos.desmos_latexify(:(((a^b)^c)^d)) == "\\left(\\left(a^{b}\\right)^{c}\\right)^{d}"
    end

    @testset "Edge cases: Fractions and divisions" begin
        @test Desmos.desmos_latexify(:(a / b / c)) == "\\frac{\\frac{a}{b}}{c}"
        @test Desmos.desmos_latexify(:((a / b) / (c / d))) == "\\frac{\\frac{a}{b}}{\\frac{c}{d}}"
        @test Desmos.desmos_latexify(:((a + b + c) / (x + y + z))) == "\\frac{a+b+c}{x+y+z}"
        @test Desmos.desmos_latexify(:(1 / (1 / x))) == "\\frac{1}{\\frac{1}{x}}"
    end

    @testset "Edge cases: Mixed Greek and Latin" begin
        @test Desmos.desmos_latexify(:(aα + bβ)) == "a\\alpha+b\\beta"
        @test Desmos.desmos_latexify(:(xα_5)) == "x\\alpha_{5}"
        @test Desmos.desmos_latexify(:(Γθ)) == "\\Gamma\\theta"
    end

    @testset "Edge cases: Subscripts and superscripts combinations" begin
        @test Desmos.desmos_latexify(:(x_a_b)) == "x_{a_{b}}"
        @test Desmos.desmos_latexify(:(α_β)) == "\\alpha_{\\beta}"
        @test Desmos.desmos_latexify(:(x₁₂₃₄₅)) == "x_{12345}"
        @test Desmos.desmos_latexify(:(y⁰¹²³⁴⁵)) == "y^{012345}"
        @test Desmos.desmos_latexify(:(a²_3)) == "a^{2}_{3}"
    end

    @testset "Edge cases: Special number values" begin
        @test Desmos.desmos_latexify(:(0)) == "0"
        @test Desmos.desmos_latexify(:(1)) == "1"
        @test Desmos.desmos_latexify(:(-1)) == "-1"
        @test Desmos.desmos_latexify(:(0.0)) == "0.0"
        @test Desmos.desmos_latexify(:(1.0e10)) == "1.0e10"
    end

    @testset "Edge cases: Very long variable names" begin
        @test Desmos.desmos_latexify(:(verylongvariablename)) == "verylongvariablename"
        @test Desmos.desmos_latexify(:(x_verylongsubscript)) == "x_{verylongsubscript}"
        @test Desmos.desmos_latexify(:(longname_1)) == "longname_{1}"
    end

    @testset "Edge cases: Sum and integral variations" begin
        @test Desmos.desmos_latexify(:(sum(1 for i in 1:10))) == "\\sum_{i=1}^{10}1"
        @test Desmos.desmos_latexify(:(sum(i * j for i in 1:n))) == "\\sum_{i=1}^{n}i\\cdot j"
        @test Desmos.desmos_latexify(:(prod(1 for i in 1:10))) == "\\prod_{i=1}^{10}1"
        @test Desmos.desmos_latexify(:(prod(i * j for i in 1:n))) == "\\prod_{i=1}^{n}i\\cdot j"
        @test Desmos.desmos_latexify(:(int(1 for x in 0 .. 1))) == "\\int_{0}^{1}1dx"
        @test Desmos.desmos_latexify(:(int(x * y for x in a .. b))) == "\\int_{a}^{b}x\\cdot ydx"
    end

    @testset "Edge cases: Function assignments" begin
        @test Desmos.desmos_latexify(:(f(x, y, z) = x + y + z)) == "f\\left(x,y,z\\right)=x+y+z"
        @test Desmos.desmos_latexify(:(h(t) = sin(t)^2 + cos(t)^2)) == "h\\left(t\\right)=\\left(\\sin\\left(t\\right)\\right)^{2}+\\left(\\cos\\left(t\\right)\\right)^{2}"
    end

    @testset "Edge cases: All Greek letters" begin
        # Lowercase
        @test Desmos.desmos_latexify(:(α)) == "\\alpha"
        @test Desmos.desmos_latexify(:(β)) == "\\beta"
        @test Desmos.desmos_latexify(:(γ)) == "\\gamma"
        @test Desmos.desmos_latexify(:(δ)) == "\\delta"
        @test Desmos.desmos_latexify(:(ε)) == "\\epsilon"
        @test Desmos.desmos_latexify(:(ζ)) == "\\zeta"
        @test Desmos.desmos_latexify(:(η)) == "\\eta"
        @test Desmos.desmos_latexify(:(θ)) == "\\theta"
        @test Desmos.desmos_latexify(:(ι)) == "\\iota"
        @test Desmos.desmos_latexify(:(κ)) == "\\kappa"
        @test Desmos.desmos_latexify(:(λ)) == "\\lambda"
        @test Desmos.desmos_latexify(:(μ)) == "\\mu"
        @test Desmos.desmos_latexify(:(ν)) == "\\nu"
        @test Desmos.desmos_latexify(:(ξ)) == "\\xi"
        @test Desmos.desmos_latexify(:(π)) == "\\pi"
        @test Desmos.desmos_latexify(:(ρ)) == "\\rho"
        @test Desmos.desmos_latexify(:(σ)) == "\\sigma"
        @test Desmos.desmos_latexify(:(τ)) == "\\tau"
        @test Desmos.desmos_latexify(:(υ)) == "\\upsilon"
        @test Desmos.desmos_latexify(:(φ)) == "\\phi"
        @test Desmos.desmos_latexify(:(χ)) == "\\chi"
        @test Desmos.desmos_latexify(:(ψ)) == "\\psi"
        @test Desmos.desmos_latexify(:(ω)) == "\\omega"
        # Uppercase
        @test Desmos.desmos_latexify(:(Α)) == "\\Alpha"
        @test Desmos.desmos_latexify(:(Β)) == "\\Beta"
        @test Desmos.desmos_latexify(:(Γ)) == "\\Gamma"
        @test Desmos.desmos_latexify(:(Δ)) == "\\Delta"
        @test Desmos.desmos_latexify(:(Ε)) == "\\Epsilon"
        @test Desmos.desmos_latexify(:(Ζ)) == "\\Zeta"
        @test Desmos.desmos_latexify(:(Η)) == "\\Eta"
        @test Desmos.desmos_latexify(:(Θ)) == "\\Theta"
        @test Desmos.desmos_latexify(:(Ι)) == "\\Iota"
        @test Desmos.desmos_latexify(:(Κ)) == "\\Kappa"
        @test Desmos.desmos_latexify(:(Λ)) == "\\Lambda"
        @test Desmos.desmos_latexify(:(Μ)) == "\\Mu"
        @test Desmos.desmos_latexify(:(Ν)) == "\\Nu"
        @test Desmos.desmos_latexify(:(Ξ)) == "\\Xi"
        @test Desmos.desmos_latexify(:(Π)) == "\\Pi"
        @test Desmos.desmos_latexify(:(Ρ)) == "\\Rho"
        @test Desmos.desmos_latexify(:(Σ)) == "\\Sigma"
        @test Desmos.desmos_latexify(:(Τ)) == "\\Tau"
        @test Desmos.desmos_latexify(:(Υ)) == "\\Upsilon"
        @test Desmos.desmos_latexify(:(Φ)) == "\\Phi"
        @test Desmos.desmos_latexify(:(Χ)) == "\\Chi"
        @test Desmos.desmos_latexify(:(Ψ)) == "\\Psi"
        @test Desmos.desmos_latexify(:(Ω)) == "\\Omega"
    end

    @testset "Edge cases: Multiple Unicode subscripts/superscripts" begin
        @test Desmos.desmos_latexify(:(x₀₁₂₃₄₅₆₇₈₉)) == "x_{0123456789}"
        @test Desmos.desmos_latexify(:(y⁰¹²³⁴⁵⁶⁷⁸⁹)) == "y^{0123456789}"
        @test Desmos.desmos_latexify(:(α₁²)) == "\\alpha_{1}^{2}"
    end

    @testset "Edge cases: Arrays with complex elements" begin
        @test Desmos.desmos_latexify(:([x^2, y^2, z^2])) == "\\left[x^{2},y^{2},z^{2}\\right]"
        @test Desmos.desmos_latexify(:([sin(x), cos(x), tan(x)])) == "\\left[\\sin\\left(x\\right),\\cos\\left(x\\right),\\tan\\left(x\\right)\\right]"
        @test Desmos.desmos_latexify(:([a / b, c / d])) == "\\left[\\frac{a}{b},\\frac{c}{d}\\right]"
    end
end
