@testset "latexify" begin
    @testset "Constants" begin
        @test Desmos.desmos_latexify(:(a = 2)) == "a=2"
        @test Desmos.desmos_latexify(:(b = 3)) == "b=3"
        @test Desmos.desmos_latexify(:(c = 5)) == "c=5"
        @test Desmos.desmos_latexify(:(u = [0, 1, 2, 3, 4, 5, 6, 7])) == "u=\\left[0,1,2,3,4,5,6,7\\right]"
        @test Desmos.desmos_latexify(:(v = [1, 1, 2, 3, 5, 8, 13, 21])) == "v=\\left[1,1,2,3,5,8,13,21\\right]"
    end

    @testset "TRIG FUNCTIONS" begin
        @test Desmos.desmos_latexify(:(sin(x))) == "\\sin\\left(x\\right)"
        @test Desmos.desmos_latexify(:(cos(x))) == "\\cos\\left(x\\right)"
        @test Desmos.desmos_latexify(:(tan(x))) == "\\tan\\left(x\\right)"
        @test Desmos.desmos_latexify(:(cot(x))) == "\\cot\\left(x\\right)"
        @test Desmos.desmos_latexify(:(sec(x))) == "\\sec\\left(x\\right)"
        @test Desmos.desmos_latexify(:(csc(x))) == "\\csc\\left(x\\right)"
    end

    @testset "INVERSE TRIG FUNCTIONS" begin
        @test Desmos.desmos_latexify(:(asin(x))) == "\\arcsin\\left(x\\right)"
        @test Desmos.desmos_latexify(:(acos(x))) == "\\arccos\\left(x\\right)"
        @test Desmos.desmos_latexify(:(atan(x))) == "\\arctan\\left(x\\right)"
        @test Desmos.desmos_latexify(:(acot(x))) == "\\arccot\\left(x\\right)"
        @test Desmos.desmos_latexify(:(asec(x))) == "\\arcsec\\left(x\\right)"
        @test Desmos.desmos_latexify(:(acsc(x))) == "\\arccsc\\left(x\\right)"
    end

    @testset "STATISTICS" begin
        @test Desmos.desmos_latexify(:(mean(v))) == "\\operatorname{mean}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(median(v))) == "\\operatorname{median}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(minimum(v))) == "\\min\\left(v\\right)"
        @test Desmos.desmos_latexify(:(maximum(v))) == "\\max\\left(v\\right)"
        @test_broken Desmos.desmos_latexify(:(quartile(v, 2))) == "\\operatorname{quartile}\\left(v,2\\right)"
        @test Desmos.desmos_latexify(:(quantile(v, 0.5))) == "\\operatorname{quantile}\\left(v,0.5\\right)"
        @test_broken Desmos.desmos_latexify(:(stdev(v))) == "\\operatorname{stdev}\\left(v\\right)"
        @test_broken Desmos.desmos_latexify(:(stdevp(v))) == "\\operatorname{stdevp}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(var(v))) == "\\operatorname{var}\\left(v\\right)"
        @test_broken Desmos.desmos_latexify(:(varp(v))) == "\\operatorname{varp}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(cov(u, v))) == "\\operatorname{cov}\\left(u,v\\right)"
        @test_broken Desmos.desmos_latexify(:(covp(u, v))) == "\\operatorname{covp}\\left(u,v\\right)"
        @test_broken Desmos.desmos_latexify(:(mad(v))) == "\\operatorname{mad}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(cor(u, v))) == "\\operatorname{corr}\\left(u,v\\right)"
        @test_broken Desmos.desmos_latexify(:(spearman(u, v))) == "\\operatorname{spearman}\\left(u,v\\right)"
        @test_broken Desmos.desmos_latexify(:(stats(v))) == "\\operatorname{stats}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(length(v))) == "\\operatorname{count}\\left(v\\right)"
    end

    @testset "LIST OPERATIONS" begin
        @test Desmos.desmos_latexify(:(fill(a, 5))) == "\\operatorname{repeat}\\left(a,5\\right)"
        @test Desmos.desmos_latexify(:(hcat(u, v))) == "\\operatorname{join}\\left(u,v\\right)"
        @test Desmos.desmos_latexify(:(sort(v))) == "\\operatorname{sort}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(shuffle(v))) == "\\operatorname{shuffle}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(unique(v))) == "\\operatorname{unique}\\left(v\\right)"
    end

    @testset "VISUALIZATIONS" begin
        @test Desmos.desmos_latexify(:(histogram(v))) == "\\operatorname{histogram}\\left(v\\right)"
        @test_broken Desmos.desmos_latexify(:(dotplot(v))) == "\\operatorname{dotplot}\\left(v\\right)"
        @test_broken Desmos.desmos_latexify(:(boxplot(v))) == "\\operatorname{boxplot}\\left(v\\right)"
    end

    @testset "PROBABILITY DISTRIBUTIONS" begin
        @test Desmos.desmos_latexify(:(Normal(μ))) == "\\operatorname{normaldist}\\left(\\mu\\right)"
        @test Desmos.desmos_latexify(:(Normal(μ, σ))) == "\\operatorname{normaldist}\\left(\\mu,\\sigma\\right)"
        @test Desmos.desmos_latexify(:(TDist(ν))) == "\\operatorname{tdist}\\left(\\nu\\right)"
        @test Desmos.desmos_latexify(:(Chi(ν))) == "\\operatorname{chisqdist}\\left(\\nu\\right)"
        @test Desmos.desmos_latexify(:(Uniform(a, b))) == "\\operatorname{uniformdist}\\left(a,b\\right)"
        @test Desmos.desmos_latexify(:(Binomial(n, p))) == "\\operatorname{binomialdist}\\left(n,p\\right)"
        @test Desmos.desmos_latexify(:(Poisson(λ))) == "\\operatorname{poissondist}\\left(\\lambda\\right)"
        @test Desmos.desmos_latexify(:(Geometric(p))) == "\\operatorname{geodist}\\left(p\\right)"
        @test_broken Desmos.desmos_latexify(:(pdf(x))) == "\\operatorname{pdf}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(cdf(x))) == "\\operatorname{cdf}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(inversecdf(x))) == "\\operatorname{inversecdf}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(random(x))) == "\\operatorname{random}\\left(x\\right)"
    end

    @testset "INFERENCE" begin
        @test_broken Desmos.desmos_latexify(:(ztest(x))) == "\\operatorname{ztest}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(ttest(x))) == "\\operatorname{ttest}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(zproptest(x))) == "\\operatorname{zproptest}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(chisqtest(x))) == "\\operatorname{chisqtest}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(chisqgof(x))) == "\\operatorname{chisqgof}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(pleft(x))) == "\\operatorname{pleft}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(pright(x))) == "\\operatorname{pright}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(score(x))) == "\\operatorname{score}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(dof(x))) == "\\operatorname{dof}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(stderr(x))) == "\\operatorname{stderr}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(conf(x))) == "\\operatorname{conf}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(lower(x))) == "\\operatorname{lower}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(upper(x))) == "\\operatorname{upper}\\left(x\\right)"
        @test_broken Desmos.desmos_latexify(:(estimate(x))) == "\\operatorname{estimate}\\left(x\\right)"
    end

    @testset "CALCULUS" begin
        @test Desmos.desmos_latexify(:(exp(x))) == "\\exp\\left(x\\right)"
    end

    @testset "HYPERBOLIC TRIG FUNCTIONS" begin
        @test Desmos.desmos_latexify(:(sinh(x))) == "\\sinh\\left(x\\right)"
        @test Desmos.desmos_latexify(:(cosh(x))) == "\\cosh\\left(x\\right)"
        @test Desmos.desmos_latexify(:(tanh(x))) == "\\tanh\\left(x\\right)"
        @test Desmos.desmos_latexify(:(coth(x))) == "\\coth\\left(x\\right)"
        @test Desmos.desmos_latexify(:(sech(x))) == "\\sech\\left(x\\right)"
        @test Desmos.desmos_latexify(:(csch(x))) == "\\csch\\left(x\\right)"
    end

    @testset "GEOMETRY" begin
        # No functions added yet
    end

    @testset "CUSTOM COLORS" begin
        # No functions added yet
    end

    @testset "SOUND" begin
        # No functions added yet
    end

    @testset "NUMBER THEORY" begin
        @test Desmos.desmos_latexify(:(lcm(x))) == "\\operatorname{lcm}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(gcd(x))) == "\\operatorname{gcd}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(mod(x))) == "\\operatorname{mod}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(ceil(x))) == "\\operatorname{ceil}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(floor(x))) == "\\operatorname{floor}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(round(x))) == "\\operatorname{round}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(sign(x))) == "\\operatorname{sign}\\left(x\\right)"
        # @test Desmos.desmos_latexify(:(nPr(x))) == "\\operatorname{nPr}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(binomial(x))) == "\\operatorname{nCr}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(sqrt(x))) == "\\sqrt{x}"
        @test Desmos.desmos_latexify(:(cbrt(x))) == "\\sqrt[3]{x}"
    end

    @testset "ADVANCED" begin
        # No functions added yet
    end

    @testset "OTHERS" begin
        @test Desmos.desmos_latexify(:(abs(x))) == "\\operatorname{abs}\\left(x\\right)"
        @test Desmos.desmos_latexify(:(factorial(x))) == "\\left(x\\right)!"
        @test Desmos.desmos_latexify(:(ifelse(x > 0, x, 0))) == "\\left\\{x>0:x,0\\right\\}"
    end

    @testset "Arithmetic" begin
        @test Desmos.desmos_latexify(:(1 + 1)) == "1+1"
        @test Desmos.desmos_latexify(:(x - y)) == "x-y"
        @test Desmos.desmos_latexify(:(a * b)) == "ab"
        @test Desmos.desmos_latexify(:(x / y)) == "\\frac{x}{y}"
        @test Desmos.desmos_latexify(:(x^2)) == "x^{2}"
        @test Desmos.desmos_latexify(:(x^y)) == "x^{y}"
        @test Desmos.desmos_latexify(:(-x)) == "-x"
        @test Desmos.desmos_latexify(:(a + b - c)) == "a+b-c"
        @test Desmos.desmos_latexify(:(2 * x + 3)) == "2x+3"
    end

    @testset "Logarithms" begin
        # ln is not supported, and is parsed as standard function
        @test Desmos.desmos_latexify(:(ln(x))) == "l_{n}\\left(x\\right)"
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
        @test Desmos.desmos_latexify(:(x == y)) == "x=y"
        @test Desmos.desmos_latexify(:(x >= 1)) == "x\\ge 1"
        @test Desmos.desmos_latexify(:(x <= 1)) == "x\\le 1"
        # != and ≠ are not supported by Desmos
        @test_throws UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(a != b))
        # Unicode operators
        @test Desmos.desmos_latexify(:(x ≥ 1)) == "x\\ge 1"
        @test Desmos.desmos_latexify(:(x ≤ 1)) == "x\\le 1"
        @test_throws UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(a ≠ b))
    end

    @testset "Multi-argument functions" begin
        @test Desmos.desmos_latexify(:(f(x, y))) == "f\\left(x,y\\right)"
        @test Desmos.desmos_latexify(:(g(a, b, c))) == "g\\left(a,b,c\\right)"
        @test Desmos.desmos_latexify(:(max(x, y))) == "\\max\\left(x,y\\right)"
    end

    @testset "Symbols" begin
        @test Desmos.desmos_latexify(:(x)) == "x"
        @test Desmos.desmos_latexify(:(x1)) == "x_{1}"
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

    @testset "Superscripts (via ^ operator only)" begin
        # Superscript Unicode characters are no longer supported
        # Use the ^ operator for exponentiation instead
        @test Desmos.desmos_latexify(:(x^0)) == "x^{0}"
        @test Desmos.desmos_latexify(:(x^1)) == "x^{1}"
        @test Desmos.desmos_latexify(:(x^2)) == "x^{2}"
        @test Desmos.desmos_latexify(:(x^5)) == "x^{5}"
        # Β (Beta) is not supported by Desmos
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Β))
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
        @test Desmos.desmos_latexify(:(y_1 ~ a * x_1 + b)) == "y_{1}\\sim ax_{1}+b"
        @test Desmos.desmos_latexify(:(y ~ x)) == "y\\sim x"
        @test Desmos.desmos_latexify(:(f(x) ~ g(x))) == "f\\left(x\\right)\\sim g\\left(x\\right)"
    end

    @testset "Multi-term expressions" begin
        @test Desmos.desmos_latexify(:(x^2 + y^2)) == "x^{2}+y^{2}"
        @test Desmos.desmos_latexify(:(sin(x) + cos(x))) == "\\sin\\left(x\\right)+\\cos\\left(x\\right)"
        @test Desmos.desmos_latexify(:((x + y)^2)) == "\\left(x+y\\right)^{2}"
        @test Desmos.desmos_latexify(:(x / (y + z))) == "\\frac{x}{y+z}"
        @test Desmos.desmos_latexify(:((a * b) / (c + d))) == "\\frac{ab}{c+d}"
    end

    @testset "For comprehension notations" begin
        # Basic list comprehensions
        @test Desmos.desmos_latexify(:([sin(x) for x in xs])) == "\\left[\\sin\\left(x\\right)\\ \\operatorname{for}\\ x=x_{s}\\right]"
        @test Desmos.desmos_latexify(:([x^2 for x in A])) == "\\left[x^{2}\\ \\operatorname{for}\\ x=A\\right]"
        @test Desmos.desmos_latexify(:([cos(θ) for θ in angles])) == "\\left[\\cos\\left(\\theta\\right)\\ \\operatorname{for}\\ \\theta=a_{ngles}\\right]"
        @test Desmos.desmos_latexify(:([a * b for a in A])) == "\\left[ab\\ \\operatorname{for}\\ a=A\\right]"
        @test Desmos.desmos_latexify(:([i + 1 for i in nums])) == "\\left[i+1\\ \\operatorname{for}\\ i=n_{ums}\\right]"
    end


    @testset "Sum and integral" begin
        @test Desmos.desmos_latexify(:(sum(n^2 for n in 1:5))) == "\\sum_{n=1}^{5}n^{2}"
        @test Desmos.desmos_latexify(:(sum(i for i in 0:10))) == "\\sum_{i=0}^{10}i"
        @test Desmos.desmos_latexify(:(sum(x_i for i in 1:n))) == "\\sum_{i=1}^{n}x_{i}"
        @test Desmos.desmos_latexify(:(prod(n^2 for n in 1:5))) == "\\prod_{n=1}^{5}n^{2}"
        @test Desmos.desmos_latexify(:(prod(i for i in 0:10))) == "\\prod_{i=0}^{10}i"
        @test Desmos.desmos_latexify(:(prod(x_i for i in 1:n))) == "\\prod_{i=1}^{n}x_{i}"
        @test Desmos.desmos_latexify(:(integrate(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test Desmos.desmos_latexify(:(integrate(y for y in -5 .. -2))) == "\\int_{-5}^{-2}ydy"
    end

    @testset "Integral" begin
        @test Desmos.desmos_latexify(:(integrate(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test Desmos.desmos_latexify(:(integrate(sin(t) for t in 0 .. π))) == "\\int_{0}^{\\pi}\\sin\\left(t\\right)dt"
        # Deprecated: int() still works for backward compatibility
        @test Desmos.desmos_latexify(:(int(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test Desmos.desmos_latexify(:(int(sin(t) for t in 0 .. π))) == "\\int_{0}^{\\pi}\\sin\\left(t\\right)dt"
    end

    @testset "Gradient" begin
        @test Desmos.desmos_latexify(:(gradient(f, x))) == "\\frac{d}{dx}f"
        @test Desmos.desmos_latexify(:(gradient(g, t))) == "\\frac{d}{dt}g"
    end

    @testset "Sum normal function calls" begin
        @test Desmos.desmos_latexify(:(sum(v))) == "\\operatorname{total}\\left(v\\right)"
        @test Desmos.desmos_latexify(:(sum([1, 2, 3]))) == "\\operatorname{total}\\left(\\left[1,2,3\\right]\\right)"
    end

    @testset "LaTeXString input" begin
        @test Desmos.desmos_latexify(L"\sin(x)") == "\\sin(x)"
        @test Desmos.desmos_latexify(L"$\alpha + \beta$") == "\\alpha + \\beta"
        @test Desmos.desmos_latexify(L"\frac{1}{2}") == "\\frac{1}{2}"
    end

    @testset "Multi-character variables (auto-subscript)" begin
        # 2nd+ characters are automatically converted to subscripts
        @test Desmos.desmos_latexify(:(xy)) == "x_{y}"
        @test Desmos.desmos_latexify(:(abc)) == "a_{bc}"
        @test Desmos.desmos_latexify(:(dx)) == "d_{x}"
        @test Desmos.desmos_latexify(:(dy)) == "d_{y}"
        @test Desmos.desmos_latexify(:(dt)) == "d_{t}"
        @test Desmos.desmos_latexify(:(x1)) == "x_{1}"
        @test Desmos.desmos_latexify(:(x12)) == "x_{12}"
    end

    @testset "Mixed operations" begin
        @test Desmos.desmos_latexify(:(2x + 3y)) == "2x+3y"
        @test Desmos.desmos_latexify(:(a * b + c / d)) == "ab+\\frac{c}{d}"
        @test Desmos.desmos_latexify(:(x^2 - 2x + 1)) == "x^{2}-2x+1"
    end

    @testset "Edge cases: Parentheses and precedence" begin
        @test Desmos.desmos_latexify(:((a + b)^(c + d))) == "\\left(a+b\\right)^{c+d}"
        @test Desmos.desmos_latexify(:((x * y)^z)) == "\\left(xy\\right)^{z}"
        @test Desmos.desmos_latexify(:((a - b) * (c + d))) == "\\left(a-b\\right)\\left(c+d\\right)"
        @test Desmos.desmos_latexify(:(a + b * c)) == "a+bc"
        @test Desmos.desmos_latexify(:((a + b) * c)) == "\\left(a+b\\right)c"
    end

    @testset "Edge cases: Negative numbers and signs" begin
        @test Desmos.desmos_latexify(:(-1)) == "-1"
        @test Desmos.desmos_latexify(:(-x - a)) == "-x-a"
        @test Desmos.desmos_latexify(:(x + - a)) == "x+-a"
        @test Desmos.desmos_latexify(:(a * -b)) == "a\\left(-b\\right)"
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
        # Multi-character identifiers with Greek letters are not supported
        # Greek letters can only appear in subscripts via explicit underscore
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(aα))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Γθ))
    end

    @testset "Edge cases: Subscripts and superscripts combinations" begin
        @test Desmos.desmos_latexify(:(x_a_b)) == "x_{ab}"
        # Greek letters not allowed in subscripts (use explicit underscore instead)
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(α_β))
        @test Desmos.desmos_latexify(:(x₁₂₃₄₅)) == "x_{12345}"
        # Superscript Unicode no longer supported - use ^ operator
        @test Desmos.desmos_latexify(:(a^2)) == "a^{2}"
    end

    @testset "Edge cases: Special number values" begin
        @test Desmos.desmos_latexify(:(0)) == "0"
        @test Desmos.desmos_latexify(:(1)) == "1"
        @test Desmos.desmos_latexify(:(-1)) == "-1"
        @test Desmos.desmos_latexify(:(0.0)) == "0.0"
        @test Desmos.desmos_latexify(:(1.0e10)) == "1.0e10"
    end

    @testset "Edge cases: Very long variable names" begin
        # Multi-character identifiers automatically get subscripts
        @test Desmos.desmos_latexify(:(verylongvariablename)) == "v_{erylongvariablename}"
        @test Desmos.desmos_latexify(:(x_verylongsubscript)) == "x_{verylongsubscript}"
        @test Desmos.desmos_latexify(:(longname_1)) == "l_{ongname1}"
    end

    @testset "Edge cases: Sum and integral variations" begin
        @test Desmos.desmos_latexify(:(sum(1 for i in 1:10))) == "\\sum_{i=1}^{10}1"
        @test Desmos.desmos_latexify(:(sum(i * j for i in 1:n))) == "\\sum_{i=1}^{n}ij"
        @test Desmos.desmos_latexify(:(prod(1 for i in 1:10))) == "\\prod_{i=1}^{10}1"
        @test Desmos.desmos_latexify(:(prod(i * j for i in 1:n))) == "\\prod_{i=1}^{n}ij"
        @test Desmos.desmos_latexify(:(integrate(1 for x in 0 .. 1))) == "\\int_{0}^{1}1dx"
        @test Desmos.desmos_latexify(:(integrate(x * y for x in a .. b))) == "\\int_{a}^{b}xydx"
        # Deprecated: int() still works
        @test Desmos.desmos_latexify(:(int(1 for x in 0 .. 1))) == "\\int_{0}^{1}1dx"
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
        # Greek letters that look like Latin letters are not supported by Desmos
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Α))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Β))
        @test Desmos.desmos_latexify(:(Γ)) == "\\Gamma"
        @test Desmos.desmos_latexify(:(Δ)) == "\\Delta"
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Ε))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Ζ))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Η))
        @test Desmos.desmos_latexify(:(Θ)) == "\\Theta"
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Ι))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Κ))
        @test Desmos.desmos_latexify(:(Λ)) == "\\Lambda"
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Μ))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Ν))
        @test Desmos.desmos_latexify(:(Ξ)) == "\\Xi"
        @test Desmos.desmos_latexify(:(Π)) == "\\Pi"
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Ρ))
        @test Desmos.desmos_latexify(:(Σ)) == "\\Sigma"
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Τ))
        @test Desmos.desmos_latexify(:(Υ)) == "\\Upsilon"
        @test Desmos.desmos_latexify(:(Φ)) == "\\Phi"
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(Χ))
        @test Desmos.desmos_latexify(:(Ψ)) == "\\Psi"
        @test Desmos.desmos_latexify(:(Ω)) == "\\Omega"
    end

    @testset "Edge cases: Multiple Unicode subscripts/superscripts" begin
        @test Desmos.desmos_latexify(:(x₀₁₂₃₄₅₆₇₈₉)) == "x_{0123456789}"
        # Superscript Unicode characters now cause errors
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(y⁰¹²³⁴⁵⁶⁷⁸⁹))
        @test_throws Desmos.UnsupportedDesmosSyntaxError Desmos.desmos_latexify(:(α₁²))
    end

    @testset "Edge cases: Arrays with complex elements" begin
        @test Desmos.desmos_latexify(:([x^2, y^2, z^2])) == "\\left[x^{2},y^{2},z^{2}\\right]"
        @test Desmos.desmos_latexify(:([sin(x), cos(x), tan(x)])) == "\\left[\\sin\\left(x\\right),\\cos\\left(x\\right),\\tan\\left(x\\right)\\right]"
        @test Desmos.desmos_latexify(:([a / b, c / d])) == "\\left[\\frac{a}{b},\\frac{c}{d}\\right]"
    end
end
