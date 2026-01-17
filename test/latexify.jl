@testset "latexify" begin
    @testset "Constants" begin
        @test desmos_latexify(:(a = 2)) == "a=2"
        @test desmos_latexify(:(b = 3)) == "b=3"
        @test desmos_latexify(:(c = 5)) == "c=5"
        @test desmos_latexify(:(u = [0, 1, 2, 3, 4, 5, 6, 7])) == "u=\\left[0,1,2,3,4,5,6,7\\right]"
        @test desmos_latexify(:(v = [1, 1, 2, 3, 5, 8, 13, 21])) == "v=\\left[1,1,2,3,5,8,13,21\\right]"
    end

    @testset "TRIG FUNCTIONS" begin
        @test desmos_latexify(:(sin(x))) == "\\sin\\left(x\\right)"
        @test desmos_latexify(:(cos(x))) == "\\cos\\left(x\\right)"
        @test desmos_latexify(:(tan(x))) == "\\tan\\left(x\\right)"
        @test desmos_latexify(:(cot(x))) == "\\cot\\left(x\\right)"
        @test desmos_latexify(:(sec(x))) == "\\sec\\left(x\\right)"
        @test desmos_latexify(:(csc(x))) == "\\csc\\left(x\\right)"
    end

    @testset "INVERSE TRIG FUNCTIONS" begin
        @test desmos_latexify(:(asin(x))) == "\\arcsin\\left(x\\right)"
        @test desmos_latexify(:(acos(x))) == "\\arccos\\left(x\\right)"
        @test desmos_latexify(:(atan(x))) == "\\arctan\\left(x\\right)"
        @test desmos_latexify(:(acot(x))) == "\\arccot\\left(x\\right)"
        @test desmos_latexify(:(asec(x))) == "\\arcsec\\left(x\\right)"
        @test desmos_latexify(:(acsc(x))) == "\\arccsc\\left(x\\right)"
    end

    @testset "STATISTICS" begin
        @test desmos_latexify(:(mean(v))) == "\\operatorname{mean}\\left(v\\right)"
        @test desmos_latexify(:(median(v))) == "\\operatorname{median}\\left(v\\right)"
        @test desmos_latexify(:(minimum(v))) == "\\min\\left(v\\right)"
        @test desmos_latexify(:(maximum(v))) == "\\max\\left(v\\right)"
        @test_broken desmos_latexify(:(quartile(v, 2))) == "\\operatorname{quartile}\\left(v,2\\right)"
        @test desmos_latexify(:(quantile(v, 0.5))) == "\\operatorname{quantile}\\left(v,0.5\\right)"
        @test_broken desmos_latexify(:(stdev(v))) == "\\operatorname{stdev}\\left(v\\right)"
        @test_broken desmos_latexify(:(stdevp(v))) == "\\operatorname{stdevp}\\left(v\\right)"
        @test desmos_latexify(:(var(v))) == "\\operatorname{var}\\left(v\\right)"
        @test_broken desmos_latexify(:(varp(v))) == "\\operatorname{varp}\\left(v\\right)"
        @test desmos_latexify(:(cov(u, v))) == "\\operatorname{cov}\\left(u,v\\right)"
        @test_broken desmos_latexify(:(covp(u, v))) == "\\operatorname{covp}\\left(u,v\\right)"
        @test_broken desmos_latexify(:(mad(v))) == "\\operatorname{mad}\\left(v\\right)"
        @test desmos_latexify(:(cor(u, v))) == "\\operatorname{corr}\\left(u,v\\right)"
        @test_broken desmos_latexify(:(spearman(u, v))) == "\\operatorname{spearman}\\left(u,v\\right)"
        @test_broken desmos_latexify(:(stats(v))) == "\\operatorname{stats}\\left(v\\right)"
        @test desmos_latexify(:(length(v))) == "\\operatorname{count}\\left(v\\right)"
    end

    @testset "LIST OPERATIONS" begin
        @test desmos_latexify(:(fill(a, 5))) == "\\operatorname{repeat}\\left(a,5\\right)"
        @test desmos_latexify(:(vcat(u, v))) == "\\operatorname{join}\\left(u,v\\right)"
        @test desmos_latexify(:(sort(v))) == "\\operatorname{sort}\\left(v\\right)"
        @test desmos_latexify(:(shuffle(v))) == "\\operatorname{shuffle}\\left(v\\right)"
        @test desmos_latexify(:(unique(v))) == "\\operatorname{unique}\\left(v\\right)"
    end

    @testset "VISUALIZATIONS" begin
        @test desmos_latexify(:(histogram(v))) == "\\operatorname{histogram}\\left(v\\right)"
        @test_broken desmos_latexify(:(dotplot(v))) == "\\operatorname{dotplot}\\left(v\\right)"
        @test_broken desmos_latexify(:(boxplot(v))) == "\\operatorname{boxplot}\\left(v\\right)"
    end

    @testset "PROBABILITY DISTRIBUTIONS" begin
        @test desmos_latexify(:(Normal(μ))) == "\\operatorname{normaldist}\\left(\\mu\\right)"
        @test desmos_latexify(:(Normal(μ, σ))) == "\\operatorname{normaldist}\\left(\\mu,\\sigma\\right)"
        @test desmos_latexify(:(TDist(ν))) == "\\operatorname{tdist}\\left(\\nu\\right)"
        @test desmos_latexify(:(Chi(ν))) == "\\operatorname{chisqdist}\\left(\\nu\\right)"
        @test desmos_latexify(:(Uniform(a, b))) == "\\operatorname{uniformdist}\\left(a,b\\right)"
        @test desmos_latexify(:(Binomial(n, p))) == "\\operatorname{binomialdist}\\left(n,p\\right)"
        @test desmos_latexify(:(Poisson(λ))) == "\\operatorname{poissondist}\\left(\\lambda\\right)"
        @test desmos_latexify(:(Geometric(p))) == "\\operatorname{geodist}\\left(p\\right)"
        @test_broken desmos_latexify(:(pdf(x))) == "\\operatorname{pdf}\\left(x\\right)"
        @test_broken desmos_latexify(:(cdf(x))) == "\\operatorname{cdf}\\left(x\\right)"
        @test_broken desmos_latexify(:(inversecdf(x))) == "\\operatorname{inversecdf}\\left(x\\right)"
        @test_broken desmos_latexify(:(random(x))) == "\\operatorname{random}\\left(x\\right)"
    end

    @testset "INFERENCE" begin
        @test_broken desmos_latexify(:(ztest(x))) == "\\operatorname{ztest}\\left(x\\right)"
        @test_broken desmos_latexify(:(ttest(x))) == "\\operatorname{ttest}\\left(x\\right)"
        @test_broken desmos_latexify(:(zproptest(x))) == "\\operatorname{zproptest}\\left(x\\right)"
        @test_broken desmos_latexify(:(chisqtest(x))) == "\\operatorname{chisqtest}\\left(x\\right)"
        @test_broken desmos_latexify(:(chisqgof(x))) == "\\operatorname{chisqgof}\\left(x\\right)"
        @test_broken desmos_latexify(:(pleft(x))) == "\\operatorname{pleft}\\left(x\\right)"
        @test_broken desmos_latexify(:(pright(x))) == "\\operatorname{pright}\\left(x\\right)"
        @test_broken desmos_latexify(:(score(x))) == "\\operatorname{score}\\left(x\\right)"
        @test_broken desmos_latexify(:(dof(x))) == "\\operatorname{dof}\\left(x\\right)"
        @test_broken desmos_latexify(:(stderr(x))) == "\\operatorname{stderr}\\left(x\\right)"
        @test_broken desmos_latexify(:(conf(x))) == "\\operatorname{conf}\\left(x\\right)"
        @test_broken desmos_latexify(:(lower(x))) == "\\operatorname{lower}\\left(x\\right)"
        @test_broken desmos_latexify(:(upper(x))) == "\\operatorname{upper}\\left(x\\right)"
        @test_broken desmos_latexify(:(estimate(x))) == "\\operatorname{estimate}\\left(x\\right)"
    end

    @testset "CALCULUS" begin
        @test desmos_latexify(:(exp(x))) == "\\exp\\left(x\\right)"
    end

    @testset "HYPERBOLIC TRIG FUNCTIONS" begin
        @test desmos_latexify(:(sinh(x))) == "\\sinh\\left(x\\right)"
        @test desmos_latexify(:(cosh(x))) == "\\cosh\\left(x\\right)"
        @test desmos_latexify(:(tanh(x))) == "\\tanh\\left(x\\right)"
        @test desmos_latexify(:(coth(x))) == "\\coth\\left(x\\right)"
        @test desmos_latexify(:(sech(x))) == "\\sech\\left(x\\right)"
        @test desmos_latexify(:(csch(x))) == "\\csch\\left(x\\right)"
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
        @test desmos_latexify(:(lcm(x))) == "\\operatorname{lcm}\\left(x\\right)"
        @test desmos_latexify(:(gcd(x))) == "\\operatorname{gcd}\\left(x\\right)"
        @test desmos_latexify(:(mod(x))) == "\\operatorname{mod}\\left(x\\right)"
        @test desmos_latexify(:(ceil(x))) == "\\operatorname{ceil}\\left(x\\right)"
        @test desmos_latexify(:(floor(x))) == "\\operatorname{floor}\\left(x\\right)"
        @test desmos_latexify(:(round(x))) == "\\operatorname{round}\\left(x\\right)"
        @test desmos_latexify(:(sign(x))) == "\\operatorname{sign}\\left(x\\right)"
        # @test desmos_latexify(:(nPr(x))) == "\\operatorname{nPr}\\left(x\\right)"
        @test desmos_latexify(:(binomial(x))) == "\\operatorname{nCr}\\left(x\\right)"
        @test desmos_latexify(:(sqrt(x))) == "\\sqrt{x}"
        @test desmos_latexify(:(cbrt(x))) == "\\sqrt[3]{x}"
    end

    @testset "ADVANCED" begin
        # No functions added yet
    end

    @testset "OTHERS" begin
        @test desmos_latexify(:(abs(x))) == "\\operatorname{abs}\\left(x\\right)"
        @test desmos_latexify(:(factorial(x))) == "\\left(x\\right)!"
        @test desmos_latexify(:(ifelse(x > 0, x, 0))) == "\\left\\{x>0:x,0\\right\\}"
    end

    @testset "Arithmetic" begin
        @test desmos_latexify(:(1 + 1)) == "1+1"
        @test desmos_latexify(:(x - y)) == "x-y"
        @test desmos_latexify(:(a * b)) == "ab"
        @test desmos_latexify(:(x / y)) == "\\frac{x}{y}"
        @test desmos_latexify(:(x^2)) == "x^{2}"
        @test desmos_latexify(:(x^y)) == "x^{y}"
        @test desmos_latexify(:(-x)) == "-x"
        @test desmos_latexify(:(a + b - c)) == "a+b-c"
        @test desmos_latexify(:(2 * x + 3)) == "2x+3"
    end

    @testset "Arithmetic (oneterm)" begin
        @test desmos_latexify(:(1 + 1), true) == "\\left(1+1\\right)"
        @test desmos_latexify(:(x - y), true) == "\\left(x-y\\right)"
        @test desmos_latexify(:(a * b), true) == "ab"
        @test desmos_latexify(:(x / y), true) == "\\frac{x}{y}"
        @test desmos_latexify(:(x^2), true) == "x^{2}"
        @test desmos_latexify(:(x^y), true) == "x^{y}"
        @test desmos_latexify(:(-x), true) == "-x"
        @test desmos_latexify(:(a + b - c), true) == "\\left(a+b-c\\right)"
        @test desmos_latexify(:(2 * x + 3), true) == "\\left(2x+3\\right)"
    end

    @testset "Logarithms" begin
        # ln is not supported, and is parsed as standard function
        @test desmos_latexify(:(ln(x))) == "l_{n}\\left(x\\right)"
        # log functions
        @test desmos_latexify(:(log(x))) == "\\ln\\left(x\\right)"
        @test desmos_latexify(:(log(2, x))) == "\\log_{2}\\left(x\\right)"
        @test desmos_latexify(:(log(a, b))) == "\\log_{a}\\left(b\\right)"
        @test desmos_latexify(:(log10(x))) == "\\log\\left(x\\right)"
        @test desmos_latexify(:(log10(100))) == "\\log\\left(100\\right)"
        @test desmos_latexify(:(log1p(x))) == "\\ln\\left(1+x\\right)"
        @test desmos_latexify(:(log1p(a + b))) == "\\ln\\left(1+a+b\\right)"
    end

    @testset "Comparison operators" begin
        @test desmos_latexify(:(x > 0)) == "x>0"
        @test desmos_latexify(:(x < 0)) == "x<0"
        @test desmos_latexify(:(x == y)) == "x=y"
        @test desmos_latexify(:(x >= 1)) == "x\\ge 1"
        @test desmos_latexify(:(x <= 1)) == "x\\le 1"
        # != and ≠ are not supported by Desmos
        @test_throws ArgumentError desmos_latexify(:(a != b))
        # Unicode operators
        @test desmos_latexify(:(x ≥ 1)) == "x\\ge 1"
        @test desmos_latexify(:(x ≤ 1)) == "x\\le 1"
        @test_throws ArgumentError desmos_latexify(:(a ≠ b))
    end

    @testset "Multi-argument functions" begin
        @test desmos_latexify(:(f(x, y))) == "f\\left(x,y\\right)"
        @test desmos_latexify(:(g(a, b, c))) == "g\\left(a,b,c\\right)"
        @test desmos_latexify(:(max(x, y))) == "\\max\\left(x,y\\right)"
    end

    @testset "Symbols" begin
        @test desmos_latexify(:(x)) == "x"
        @test desmos_latexify(:(x1)) == "x_{1}"
        @test desmos_latexify(:(x_1)) == "x_{1}"
        @test desmos_latexify(:(x_1___ₐbc)) == "x_{1abc}"
        @test desmos_latexify(:(x_y)) == "x_{y}"
        @test desmos_latexify(:(x_abc)) == "x_{abc}"
        @test desmos_latexify(:(tan(x_y))) == "\\tan\\left(x_{y}\\right)"
        @test desmos_latexify(:(a₁)) == "a_{1}"
        @test desmos_latexify(:(x₀)) == "x_{0}"
        @test desmos_latexify(:(n₁₂₃)) == "n_{123}"

        # Latin subscript letters
        @test desmos_latexify(:(hₐ)) == "h_{a}"
        @test desmos_latexify(:(xₑ)) == "x_{e}"
        @test desmos_latexify(:(aᵢ)) == "a_{i}"
        @test desmos_latexify(:(aᵢⱼ)) == "a_{ij}"
        @test desmos_latexify(:(xₖₗ)) == "x_{kl}"
        @test desmos_latexify(:(x₁₂4ₐ)) == "x_{124a}"
        @test desmos_latexify(:(xₐₑᵢₒᵤ)) == "x_{aeiou}"

        # Test with regular strings
        @test desmos_latexify("foo") == "f_{oo}"
        @test desmos_latexify("h₁") == "h_{1}"
        @test desmos_latexify("hₐ") == "h_{a}"

        # Error cases: Greek letters in subscripts are not allowed
        @test_throws ArgumentError desmos_latexify(:(xα))
        @test_throws ArgumentError desmos_latexify(:(x_α))
        @test_throws ArgumentError desmos_latexify(:(xᵦ))
        @test_throws ArgumentError desmos_latexify(:(aβ))
        @test_throws ArgumentError desmos_latexify(:(nθ))
        @test_throws ArgumentError desmos_latexify("hα")
        @test_throws ArgumentError desmos_latexify("xπ")

        # Error cases: Invalid special characters in subscripts
        @test_throws ArgumentError desmos_latexify("x!")
        @test_throws ArgumentError desmos_latexify("a#")
        @test_throws ArgumentError desmos_latexify("h@")
    end

    @testset "Superscripts (via ^ operator only)" begin
        # Superscript Unicode characters are no longer supported
        # Use the ^ operator for exponentiation instead
        @test desmos_latexify(:(x^0)) == "x^{0}"
        @test desmos_latexify(:(x^1)) == "x^{1}"
        @test desmos_latexify(:(x^2)) == "x^{2}"
        @test desmos_latexify(:(x^5)) == "x^{5}"
    end

    @testset "Special values" begin
        @test desmos_latexify(:(Inf)) == "\\infty"
        @test desmos_latexify(:(NaN)) == "\\frac{0}{0}"
        @test desmos_latexify(:(1.5)) == "1.5"
        @test desmos_latexify(:(42)) == "42"
        @test desmos_latexify(:(-3.14)) == "-3.14"
    end

    @testset "Number types (Real, Integer, AbstractFloat, Rational)" begin
        # Integer
        @test desmos_latexify(42) == "42"
        @test desmos_latexify(-10) == "-10"
        @test desmos_latexify(0) == "0"

        # AbstractFloat - regular notation
        @test desmos_latexify(1.5) == "1.5"
        @test desmos_latexify(-3.14) == "-3.14"
        @test desmos_latexify(0.001) == "0.001"
        @test desmos_latexify(123.456) == "123.456"
        @test desmos_latexify(0.0) == "0.0"
        @test desmos_latexify(-0.0) == "-0.0"

        # AbstractFloat - scientific notation
        @test desmos_latexify(1.5e10) == "1.5\\times10^{10}"
        @test desmos_latexify(2.0e-5) == "2.0\\times10^{-5}"
        @test desmos_latexify(-3.14e20) == "-3.14\\times10^{20}"
        @test desmos_latexify(5.0e-100) == "5.0\\times10^{-100}"
        @test desmos_latexify(1.23e8) == "1.23\\times10^{8}"

        # AbstractFloat - non-finite
        @test desmos_latexify(Inf) == "\\infty"
        @test desmos_latexify(-Inf) == "-\\infty"
        @test desmos_latexify(NaN) == "\\frac{0}{0}"

        # Rational
        @test desmos_latexify(1 // 2) == "\\frac{1}{2}"
        @test desmos_latexify(3 // 4) == "\\frac{3}{4}"
        @test desmos_latexify(-5 // 7) == "\\frac{-5}{7}"

        # Irrational numbers
        @test desmos_latexify(π) == "\\pi"
        @test desmos_latexify(pi) == "\\pi"
        @test desmos_latexify(ℯ) == "e"
        # Irrational numbers in expressions
        @test desmos_latexify(:(1 + π)) == "1+\\pi"
        @test desmos_latexify(:(1 + pi)) == "1+\\pi"
        @test desmos_latexify(:(ℯ^x)) == "e^{x}"
    end

    @testset "Tuples and arrays" begin
        @test desmos_latexify(:((a, b))) == "\\left(a,b\\right)"
        @test desmos_latexify(:((x, y, z))) == "\\left(x,y,z\\right)"
        @test desmos_latexify(:([1, 2, 3])) == "\\left[1,2,3\\right]"
        @test desmos_latexify(:([a, b])) == "\\left[a,b\\right]"
        @test desmos_latexify(:([x + 1, y - 2])) == "\\left[x+1,y-2\\right]"
        @test desmos_latexify(collect(1:2:9)) == "\\left[1,3,5,7,9\\right]"
        @test desmos_latexify(1:2:9) == "\\left[1,3,...,9\\right]"
        @test desmos_latexify(1:9) == "\\left[1,...,9\\right]"
        @test desmos_latexify(Base.OneTo(8)) == "\\left[1,...,8\\right]"
    end

    @testset "Array indexing" begin
        @test desmos_latexify(:(v[1])) == "v\\left[1\\right]"
        @test desmos_latexify(:(v[1 + i])) == "v\\left[1+i\\right]"
        @test desmos_latexify(:(v[1:5])) == "v\\left[\\left[1,...,5\\right]\\right]"
        @test desmos_latexify(:(v[1:2:5])) == "v\\left[\\left[1,1+2,...,5\\right]\\right]"
        @test desmos_latexify(:(v[[1, 3, 5]])) == "v\\left[\\left[1,3,5\\right]\\right]"
        @test desmos_latexify(:(getindex(v, 1))) == "v\\left[1\\right]"
        @test desmos_latexify(:(getindex(v, 1 + i))) == "v\\left[1+i\\right]"
        @test desmos_latexify(:(getindex(v, 1:5))) == "v\\left[\\left[1,...,5\\right]\\right]"
        @test desmos_latexify(:(getindex(v, 1:2:5))) == "v\\left[\\left[1,1+2,...,5\\right]\\right]"
        @test desmos_latexify(:(getindex(v, [1, 3, 5]))) == "v\\left[\\left[1,3,5\\right]\\right]"
    end

    @testset "Assignments" begin
        @test desmos_latexify(:(x = 5)) == "x=5"
        @test desmos_latexify(:(y = x + 1)) == "y=x+1"
        @test desmos_latexify(:(f(x) = x^2)) == "f\\left(x\\right)=x^{2}"
        @test desmos_latexify(:(g(x, y) = x + y)) == "g\\left(x,y\\right)=x+y"
    end

    @testset "Tilde operator" begin
        @test desmos_latexify(:(y_1 ~ a * x_1 + b)) == "y_{1}\\sim ax_{1}+b"
        @test desmos_latexify(:(y ~ x)) == "y\\sim x"
        @test desmos_latexify(:(f(x) ~ g(x))) == "f\\left(x\\right)\\sim g\\left(x\\right)"
    end

    @testset "Multi-term expressions" begin
        @test desmos_latexify(:(x^2 + y^2)) == "x^{2}+y^{2}"
        @test desmos_latexify(:(sin(x) + cos(x))) == "\\sin\\left(x\\right)+\\cos\\left(x\\right)"
        @test desmos_latexify(:((x + y)^2)) == "\\left(x+y\\right)^{2}"
        @test desmos_latexify(:(x / (y + z))) == "\\frac{x}{y+z}"
        @test desmos_latexify(:((a * b) / (c + d))) == "\\frac{ab}{c+d}"
    end

    @testset "For comprehension notations" begin
        # Basic list comprehensions
        @test desmos_latexify(:([sin(x) for x in xs])) == "\\left[\\sin\\left(x\\right)\\ \\operatorname{for}\\ x=x_{s}\\right]"
        @test desmos_latexify(:([x^2 for x in A])) == "\\left[x^{2}\\ \\operatorname{for}\\ x=A\\right]"
        @test desmos_latexify(:([cos(θ) for θ in angles])) == "\\left[\\cos\\left(\\theta\\right)\\ \\operatorname{for}\\ \\theta=a_{ngles}\\right]"
        @test desmos_latexify(:([a * b for a in A])) == "\\left[ab\\ \\operatorname{for}\\ a=A\\right]"
        @test desmos_latexify(:([i + 1 for i in nums])) == "\\left[i+1\\ \\operatorname{for}\\ i=n_{ums}\\right]"
    end


    @testset "Sum and integral" begin
        @test desmos_latexify(:(sum(n^2 for n in 1:5))) == "\\sum_{n=1}^{5}n^{2}"
        @test desmos_latexify(:(sum(i for i in 0:10))) == "\\sum_{i=0}^{10}i"
        @test desmos_latexify(:(sum(x_i for i in 1:n))) == "\\sum_{i=1}^{n}x_{i}"
        # Test sum with multi-term expressions (should add parentheses)
        @test desmos_latexify(:(sum(x^2 + y^2 for i in 1:5))) == "\\sum_{i=1}^{5}\\left(x^{2}+y^{2}\\right)"
        @test desmos_latexify(:(sum(x + y for i in 1:3))) == "\\sum_{i=1}^{3}\\left(x+y\\right)"
        @test desmos_latexify(:(prod(n^2 for n in 1:5))) == "\\prod_{n=1}^{5}n^{2}"
        @test desmos_latexify(:(prod(i for i in 0:10))) == "\\prod_{i=0}^{10}i"
        @test desmos_latexify(:(prod(x_i for i in 1:n))) == "\\prod_{i=1}^{n}x_{i}"
        # Test prod with multi-term expressions (should add parentheses)
        @test desmos_latexify(:(prod(x + y for i in 1:3))) == "\\prod_{i=1}^{3}\\left(x+y\\right)"
        # Test prod with single-term expressions (no parentheses)
        @test desmos_latexify(:(prod(x * y for i in 1:3))) == "\\prod_{i=1}^{3}xy"
        @test desmos_latexify(:(integrate(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test desmos_latexify(:(integrate(y for y in -5 .. -2))) == "\\int_{-5}^{-2}ydy"
    end

    @testset "Integral" begin
        @test desmos_latexify(:(integrate(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test desmos_latexify(:(integrate(sin(t) for t in 0 .. π))) == "\\int_{0}^{\\pi}\\sin\\left(t\\right)dt"
        # Deprecated: int() still works for backward compatibility
        @test desmos_latexify(:(int(x^2 for x in 1 .. 5))) == "\\int_{1}^{5}x^{2}dx"
        @test desmos_latexify(:(int(sin(t) for t in 0 .. π))) == "\\int_{0}^{\\pi}\\sin\\left(t\\right)dt"
    end

    @testset "Gradient" begin
        @test desmos_latexify(:(gradient(f, x))) == "\\frac{d}{dx}f"
        @test desmos_latexify(:(gradient(g, t))) == "\\frac{d}{dt}g"
        # Test gradient with multi-term expressions (should add parentheses)
        @test desmos_latexify(:(gradient(x^2 + y^2, y))) == "\\frac{d}{dy}\\left(x^{2}+y^{2}\\right)"
        @test desmos_latexify(:(gradient(x - y, y))) == "\\frac{d}{dy}\\left(x-y\\right)"
        # Test gradient with single-term expressions (no parentheses needed)
        @test desmos_latexify(:(gradient(x^2, y))) == "\\frac{d}{dy}x^{2}"
        @test desmos_latexify(:(gradient(x * y, y))) == "\\frac{d}{dy}xy"
    end

    @testset "Sum normal function calls" begin
        @test desmos_latexify(:(sum(v))) == "\\operatorname{total}\\left(v\\right)"
        @test desmos_latexify(:(sum([1, 2, 3]))) == "\\operatorname{total}\\left(\\left[1,2,3\\right]\\right)"
        @test desmos_latexify(:(sum(n^2 for n in 1:5))) == "\\sum_{n=1}^{5}n^{2}"
        @test desmos_latexify(:(sum([n^2 for n in 1:5]))) == "\\operatorname{total}\\left(\\left[n^{2}\\ \\operatorname{for}\\ n=\\left[1,...,5\\right]\\right]\\right)"
    end

    @testset "LaTeXString input" begin
        @test desmos_latexify(L"\sin(x)") == "\\sin(x)"
        @test desmos_latexify(L"$\alpha + \beta$") == "\\alpha + \\beta"
        @test desmos_latexify(L"\frac{1}{2}") == "\\frac{1}{2}"
    end

    @testset "Multi-character variables (auto-subscript)" begin
        # 2nd+ characters are automatically converted to subscripts
        @test desmos_latexify(:(xy)) == "x_{y}"
        @test desmos_latexify(:(abc)) == "a_{bc}"
        @test desmos_latexify(:(dx)) == "d_{x}"
        @test desmos_latexify(:(dy)) == "d_{y}"
        @test desmos_latexify(:(dt)) == "d_{t}"
        @test desmos_latexify(:(x1)) == "x_{1}"
        @test desmos_latexify(:(x12)) == "x_{12}"
    end

    @testset "Mixed operations" begin
        @test desmos_latexify(:(2x + 3y)) == "2x+3y"
        @test desmos_latexify(:(a * b + c / d)) == "ab+\\frac{c}{d}"
        @test desmos_latexify(:(x^2 - 2x + 1)) == "x^{2}-2x+1"
    end

    @testset "Edge cases: Parentheses and precedence" begin
        @test desmos_latexify(:((a + b)^(c + d))) == "\\left(a+b\\right)^{c+d}"
        @test desmos_latexify(:((x * y)^z)) == "\\left(xy\\right)^{z}"
        @test desmos_latexify(:((a - b) * (c + d))) == "\\left(a-b\\right)\\left(c+d\\right)"
        @test desmos_latexify(:(a + b * c)) == "a+bc"
        @test desmos_latexify(:((a + b) * c)) == "\\left(a+b\\right)c"
    end

    @testset "Edge cases: Negative numbers and signs" begin
        @test desmos_latexify(:(-1)) == "-1"
        @test desmos_latexify(:(-x - a)) == "-x-a"
        @test desmos_latexify(:(x + - a)) == "x+-a"
        @test desmos_latexify(:(a * -b)) == "a\\left(-b\\right)"
        @test desmos_latexify(:(-(-x))) == "--x"
    end

    @testset "Edge cases: Empty and single elements" begin
        @test desmos_latexify(:((a,))) == "\\left(a\\right)"
        @test desmos_latexify(:([x])) == "\\left[x\\right]"
        @test desmos_latexify(:(f())) == "f"
    end

    @testset "Edge cases: Nested structures" begin
        @test desmos_latexify(:((a, (b, c)))) == "\\left(a,\\left(b,c\\right)\\right)"
        @test desmos_latexify(:([1, [2, 3]])) == "\\left[1,\\left[2,3\\right]\\right]"
        @test desmos_latexify(:(sin(cos(x)))) == "\\sin\\left(\\cos\\left(x\\right)\\right)"
        @test desmos_latexify(:(f(g(h(x))))) == "f\\left(g\\left(h\\left(x\\right)\\right)\\right)"
        @test desmos_latexify(:(((a^b)^c)^d)) == "\\left(\\left(a^{b}\\right)^{c}\\right)^{d}"
    end

    @testset "Edge cases: Fractions and divisions" begin
        @test desmos_latexify(:(a / b / c)) == "\\frac{\\frac{a}{b}}{c}"
        @test desmos_latexify(:((a / b) / (c / d))) == "\\frac{\\frac{a}{b}}{\\frac{c}{d}}"
        @test desmos_latexify(:((a + b + c) / (x + y + z))) == "\\frac{a+b+c}{x+y+z}"
        @test desmos_latexify(:(1 / (1 / x))) == "\\frac{1}{\\frac{1}{x}}"
    end

    @testset "Edge cases: Mixed Greek and Latin" begin
        # Multi-character identifiers with Greek letters are not supported
        # Greek letters can only appear in subscripts via explicit underscore
        @test_throws ArgumentError desmos_latexify(:(aα))
        @test_throws ArgumentError desmos_latexify(:(Γθ))
    end

    @testset "Edge cases: Subscripts and superscripts combinations" begin
        @test desmos_latexify(:(x_a_b)) == "x_{ab}"
        # Greek letters not allowed in subscripts (use explicit underscore instead)
        @test_throws ArgumentError desmos_latexify(:(α_β))
        @test desmos_latexify(:(x₁₂₃₄₅)) == "x_{12345}"
        # Superscript Unicode no longer supported - use ^ operator
        @test desmos_latexify(:(a^2)) == "a^{2}"
    end

    @testset "Edge cases: Sum and integral variations" begin
        @test desmos_latexify(:(sum(1 for i in 1:10))) == "\\sum_{i=1}^{10}1"
        @test desmos_latexify(:(sum(i * j for i in 1:n))) == "\\sum_{i=1}^{n}ij"
        @test desmos_latexify(:(prod(1 for i in 1:10))) == "\\prod_{i=1}^{10}1"
        @test desmos_latexify(:(prod(i * j for i in 1:n))) == "\\prod_{i=1}^{n}ij"
        @test desmos_latexify(:(integrate(1 for x in 0 .. 1))) == "\\int_{0}^{1}1dx"
        @test desmos_latexify(:(integrate(x * y for x in a .. b))) == "\\int_{a}^{b}xydx"
        # Deprecated: int() still works
        @test desmos_latexify(:(int(1 for x in 0 .. 1))) == "\\int_{0}^{1}1dx"
    end

    @testset "Edge cases: Function assignments" begin
        @test desmos_latexify(:(f(x, y, z) = x + y + z)) == "f\\left(x,y,z\\right)=x+y+z"
        @test desmos_latexify(:(h(t) = sin(t)^2 + cos(t)^2)) == "h\\left(t\\right)=\\left(\\sin\\left(t\\right)\\right)^{2}+\\left(\\cos\\left(t\\right)\\right)^{2}"
    end

    @testset "Edge cases: All Greek letters" begin
        # Lowercase
        @test desmos_latexify(:(α)) == "\\alpha"
        @test desmos_latexify(:(β)) == "\\beta"
        @test desmos_latexify(:(γ)) == "\\gamma"
        @test desmos_latexify(:(δ)) == "\\delta"
        @test desmos_latexify(:(ε)) == "\\epsilon"
        @test desmos_latexify(:(ζ)) == "\\zeta"
        @test desmos_latexify(:(η)) == "\\eta"
        @test desmos_latexify(:(θ)) == "\\theta"
        @test desmos_latexify(:(ι)) == "\\iota"
        @test desmos_latexify(:(κ)) == "\\kappa"
        @test desmos_latexify(:(λ)) == "\\lambda"
        @test desmos_latexify(:(μ)) == "\\mu"
        @test desmos_latexify(:(ν)) == "\\nu"
        @test desmos_latexify(:(ξ)) == "\\xi"
        @test desmos_latexify(:(π)) == "\\pi"
        @test desmos_latexify(:(ρ)) == "\\rho"
        @test desmos_latexify(:(σ)) == "\\sigma"
        @test desmos_latexify(:(τ)) == "\\tau"
        @test desmos_latexify(:(υ)) == "\\upsilon"
        @test desmos_latexify(:(φ)) == "\\phi"
        @test desmos_latexify(:(χ)) == "\\chi"
        @test desmos_latexify(:(ψ)) == "\\psi"
        @test desmos_latexify(:(ω)) == "\\omega"
        # Uppercase
        # Greek letters that look like Latin letters are not supported by Desmos
        @test_throws ArgumentError desmos_latexify(:(Α))
        @test_throws ArgumentError desmos_latexify(:(Β))
        @test desmos_latexify(:(Γ)) == "\\Gamma"
        @test desmos_latexify(:(Δ)) == "\\Delta"
        @test_throws ArgumentError desmos_latexify(:(Ε))
        @test_throws ArgumentError desmos_latexify(:(Ζ))
        @test_throws ArgumentError desmos_latexify(:(Η))
        @test desmos_latexify(:(Θ)) == "\\Theta"
        @test_throws ArgumentError desmos_latexify(:(Ι))
        @test_throws ArgumentError desmos_latexify(:(Κ))
        @test desmos_latexify(:(Λ)) == "\\Lambda"
        @test_throws ArgumentError desmos_latexify(:(Μ))
        @test_throws ArgumentError desmos_latexify(:(Ν))
        @test desmos_latexify(:(Ξ)) == "\\Xi"
        @test desmos_latexify(:(Π)) == "\\Pi"
        @test_throws ArgumentError desmos_latexify(:(Ρ))
        @test desmos_latexify(:(Σ)) == "\\Sigma"
        @test_throws ArgumentError desmos_latexify(:(Τ))
        @test desmos_latexify(:(Υ)) == "\\Upsilon"
        @test desmos_latexify(:(Φ)) == "\\Phi"
        @test_throws ArgumentError desmos_latexify(:(Χ))
        @test desmos_latexify(:(Ψ)) == "\\Psi"
        @test desmos_latexify(:(Ω)) == "\\Omega"
    end

    @testset "Edge cases: Multiple Unicode subscripts/superscripts" begin
        @test desmos_latexify(:(x₀₁₂₃₄₅₆₇₈₉)) == "x_{0123456789}"
        # Superscript Unicode characters now cause errors
        @test_throws ArgumentError desmos_latexify(:(y⁰¹²³⁴⁵⁶⁷⁸⁹))
        @test_throws ArgumentError desmos_latexify(:(α₁²))
    end

    @testset "Edge cases: Arrays with complex elements" begin
        @test desmos_latexify(:([x^2, y^2, z^2])) == "\\left[x^{2},y^{2},z^{2}\\right]"
        @test desmos_latexify(:([sin(x), cos(x), tan(x)])) == "\\left[\\sin\\left(x\\right),\\cos\\left(x\\right),\\tan\\left(x\\right)\\right]"
        @test desmos_latexify(:([a / b, c / d])) == "\\left[\\frac{a}{b},\\frac{c}{d}\\right]"
    end

    @testset "QuadraticOptimizer extension" begin
        q1 = Quadratic{1}([2.0], [3.0], 1.0)
        @test desmos_latexify(q1) == "\\frac{1}{2}\\left(2.0\\right)x^2+3.0x+1.0"
        @test desmos_latexify(q1, false) == "\\frac{1}{2}\\left(2.0\\right)x^2+3.0x+1.0"
        @test desmos_latexify(q1, true) == "\\left(\\frac{1}{2}\\left(2.0\\right)x^2+3.0x+1.0\\right)"

        q2 = Quadratic{2}([1.0, 2.0, 3.0], [4.0, 5.0], 6.0)
        @test desmos_latexify(q2) == "\\frac{1}{2}\\left(\\left(1.0\\right)x^2+2\\left(2.0\\right)xy+\\left(3.0\\right)y^2\\right)+4.0x+5.0y+6.0"
        @test desmos_latexify(q2, false) == "\\frac{1}{2}\\left(\\left(1.0\\right)x^2+2\\left(2.0\\right)xy+\\left(3.0\\right)y^2\\right)+4.0x+5.0y+6.0"
        @test desmos_latexify(q2, true) == "\\left(\\frac{1}{2}\\left(\\left(1.0\\right)x^2+2\\left(2.0\\right)xy+\\left(3.0\\right)y^2\\right)+4.0x+5.0y+6.0\\right)"
    end

    @testset "Symbolics.jl integration" begin
        @variables x y z
        @syms a::Real b::Real c::Real

        # Basic operations
        @test desmos_latexify(x) == "x"
        @test desmos_latexify(-x) == "-x"
        @test desmos_latexify(x + y) == "x+y"
        @test desmos_latexify(x - y) == "x-y"
        @test desmos_latexify(-x - y) == "-x-y"
        @test desmos_latexify(x * y) == "xy"
        @test desmos_latexify(-x * y) == "-xy"
        @test desmos_latexify(x^2) == "x^{2}"
        @test desmos_latexify(x / y) == "\\frac{x}{y}"
        @test desmos_latexify((x + y) / (x - y)) == "\\frac{x+y}{x-y}"
        @test desmos_latexify(-x * y) == "-xy"
        @test desmos_latexify(-x + y) == "-x+y"
        @test desmos_latexify(x - 2y + z) == "x-2y+z"
        @test desmos_latexify(x + y + 1) == "x+y+1"
        @test desmos_latexify(x + 2y - 1) == "x+2y-1"
        @test desmos_latexify(x + y * 1) == "x+y"
        @test desmos_latexify(x + y^1) == "x+y"

        # Basic operations with `oneterm=true`
        @test desmos_latexify(x, true) == "x"
        @test desmos_latexify(-x, true) == "-x"
        @test desmos_latexify(x + y, true) == "\\left(x+y\\right)"
        @test desmos_latexify(x - y, true) == "\\left(x-y\\right)"
        @test desmos_latexify(-x - y, true) == "\\left(-x-y\\right)"
        @test desmos_latexify(x * y, true) == "xy"
        @test desmos_latexify(-x * y, true) == "-xy"
        @test desmos_latexify(x^2, true) == "x^{2}"
        @test desmos_latexify(x / y, true) == "\\frac{x}{y}"
        @test desmos_latexify((x + y) / (x - y), true) == "\\frac{x+y}{x-y}"
        @test desmos_latexify(-x * y, true) == "-xy"
        @test desmos_latexify(-x + y, true) == "\\left(-x+y\\right)"
        @test desmos_latexify(x - 2y + z, true) == "\\left(x-2y+z\\right)"
        @test desmos_latexify(x + y + 1, true) == "\\left(x+y+1\\right)"
        @test desmos_latexify(x + 2y - 1, true) == "\\left(x+2y-1\\right)"
        @test desmos_latexify(x + y * 1, true) == "\\left(x+y\\right)"
        @test desmos_latexify(x + y^1, true) == "\\left(x+y\\right)"

        # SymbolicUtils @syms
        @test desmos_latexify(a) == "a"
        @test desmos_latexify(a + b) == "a+b"
        @test desmos_latexify(a * b) == "ab"

        # Basic functions
        @test desmos_latexify(sin(x)) == "\\sin\\left(x\\right)"
        @test desmos_latexify(cos(x)) == "\\cos\\left(x\\right)"
        @test desmos_latexify(tan(x)) == "\\tan\\left(x\\right)"
        @test desmos_latexify(exp(x)) == "\\exp\\left(x\\right)"
        @test desmos_latexify(log(x)) == "\\ln\\left(x\\right)"
        @test desmos_latexify(sqrt(x)) == "\\sqrt{x}"

        # Derivatives
        D = Differential(x)
        D2 = Differential(x, 2)
        @test desmos_latexify(D(x^2)) == "\\frac{d}{dx}x^{2}"
        @test desmos_latexify(D(x^3 - x + 1)) == "\\frac{d}{dx}\\left(-x+x^{3}+1\\right)"
        @test desmos_latexify(expand_derivatives(D(x^2))) == "2x"
        @test desmos_latexify(expand_derivatives(D(x^3 - x + 1))) == "3x^{2}-1"
        @test desmos_latexify(D2(x^2)) == "\\frac{d}{dx}\\frac{d}{dx}x^{2}"
        @test desmos_latexify(D2(x^3 - x + 1)) == "\\frac{d}{dx}\\frac{d}{dx}\\left(-x+x^{3}+1\\right)"
        @test desmos_latexify(expand_derivatives(D2(x^2))) == "2"
        @test desmos_latexify(expand_derivatives(D2(x^3 - x + 1))) == "6x"

        # Comparison operators
        @test desmos_latexify(x > 0) == "x>0"
        @test desmos_latexify(x < 0) == "x<0"
        @test desmos_latexify(x == y) == "x=y"
        @test desmos_latexify(x >= 1) == "x\\ge 1"
        @test desmos_latexify(x <= 1) == "x\\le 1"
        @test desmos_latexify(a + b > c) == "a+b>c"
        @test desmos_latexify(x^2 < y^2) == "x^{2}<y^{2}"

        # ifelse
        @test desmos_latexify(ifelse(x > 0, x, 0)) == "\\left\\{x>0:x,0\\right\\}"
        @test desmos_latexify(ifelse(x > y, x, y)) == "\\left\\{x>y:x,y\\right\\}"
        @test desmos_latexify(ifelse(a + b > 0, a + b, 0)) == "\\left\\{a+b>0:a+b,0\\right\\}"
    end
end
