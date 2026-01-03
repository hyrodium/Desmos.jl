using Desmos
using JuMP, Ipopt
using IntervalSets

@testset "JuMP" begin
    @testset "Input validation" begin
        m = Model()
        @variable m x
        @variable m y
        @variable m z
        @test_throws UnsupportedDesmosSyntaxError Desmos.DesmosState(m)

        m = Model()
        @variable m c in Parameter(1)
        @variable m x
        @variable m y
        @test_throws UnsupportedDesmosSyntaxError Desmos.DesmosState(m)
        state = Desmos.DesmosState(m, objective_value_variable = "d")
        exprs = [expr.latex for expr in state.expressions.list]
        @test exprs == [
            "c=1.0",
            "d=0",
            "x_{2}=x",
            "x_{3}=y",
        ]
    end

    @testset "Basic model" begin
        m = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
        @variable   m             0 ≤ x ≤ 2
        @variable   m             0 ≤ y ≤ 2
        @constraint m        sin(x * y) ≥ 1 / 2
        @constraint m        x^2 + 5x * y ≤ 8
        @objective  m  Min   x^3 + y^3 + 4x

        optimize!(m)
        state = Desmos.DesmosState(m)

        exprs = [expr.latex for expr in state.expressions.list]
        obj_val = objective_value(m)
        x_val = value(x)
        y_val = value(y)
        @test exprs == [
            "\\sin\\left(x_{1}x_{2}\\right)-0.5\\ge 0\\left\\{x_{1}^{2}+5x_{2}x_{1}\\le 8\\right\\}\\left\\{x_{1}\\ge 0\\right\\}\\left\\{x_{2}\\ge 0\\right\\}\\left\\{x_{1}\\le 2\\right\\}\\left\\{x_{2}\\le 2\\right\\}",
            "x_{1}^{2}+5x_{2}x_{1}\\le 8\\left\\{\\sin\\left(x_{1}x_{2}\\right)-0.5\\ge 0\\right\\}\\left\\{x_{1}\\ge 0\\right\\}\\left\\{x_{2}\\ge 0\\right\\}\\left\\{x_{1}\\le 2\\right\\}\\left\\{x_{2}\\le 2\\right\\}",
            "x_{1}^{3.0}+4x_{1}+x_{2}^{3.0}=c",
            "c=$obj_val",
            "\\left($x_val,$y_val\\right)",
            "x_{1}=x",
            "x_{2}=y",
        ]

        @constraint m x + y == 2
        optimize!(m)
        state = Desmos.DesmosState(m)
        exprs = [expr.latex for expr in state.expressions.list]
        obj_val = objective_value(m)
        x_val = value(x)
        y_val = value(y)

        @test exprs == [
            "\\sin\\left(x_{1}x_{2}\\right)-0.5\\ge 0\\left\\{x_{1}^{2}+5x_{2}x_{1}\\le 8\\right\\}\\left\\{x_{1}\\ge 0\\right\\}\\left\\{x_{2}\\ge 0\\right\\}\\left\\{x_{1}\\le 2\\right\\}\\left\\{x_{2}\\le 2\\right\\}",
            "x_{1}+x_{2}=2\\left\\{\\sin\\left(x_{1}x_{2}\\right)-0.5\\ge 0\\right\\}\\left\\{x_{1}^{2}+5x_{2}x_{1}\\le 8\\right\\}\\left\\{x_{1}\\ge 0\\right\\}\\left\\{x_{2}\\ge 0\\right\\}\\left\\{x_{1}\\le 2\\right\\}\\left\\{x_{2}\\le 2\\right\\}",
            "x_{1}^{2}+5x_{2}x_{1}\\le 8\\left\\{\\sin\\left(x_{1}x_{2}\\right)-0.5\\ge 0\\right\\}\\left\\{x_{1}\\ge 0\\right\\}\\left\\{x_{2}\\ge 0\\right\\}\\left\\{x_{1}\\le 2\\right\\}\\left\\{x_{2}\\le 2\\right\\}",
            "x_{1}^{3.0}+4x_{1}+x_{2}^{3.0}=c",
            "c=$obj_val",
            "\\left($x_val,$y_val\\right)",
            "x_{1}=x",
            "x_{2}=y",
        ]
    end
    @testset "Parametric model" begin
        m = Model()

        @variable   m  -1 ≤ x₁ ≤ 1   start = 0.1
        @variable   m       x₂       start = 0.1
        @variable   m       p ∈ Parameter(5 / 4)
        @variable   m       a ∈ Parameter(1 / 2)
        @variable   m       b ∈ Parameter(3 / 2)
        @constraint m         abs(x₁)^p + abs(x₂)^p ≤ 1
        @objective  m Min          a * x₁ + b * x₂

        q = p / (p - 1)
        denom = (abs(a)^q + abs(b)^q)^(1 / q)
        solution = Dict(
            x₁ => -sign(a) * (abs(a) / denom)^(q - 1),
            x₂ => -sign(b) * (abs(b) / denom)^(q - 1),
        )

        state = Desmos.DesmosState(
            m,
            parameter_ranges = Dict(p => 1 .. 3),
            parametric_solution = solution,
        )

        exprs = [expr.latex for expr in state.expressions.list]
        @test exprs == [
            "p=1.25",
            "a=0.5",
            "b=1.5",
            "\\left(\\operatorname{abs}\\left(x_{1}\\right)\\right)^{p}+\\left(\\operatorname{abs}\\left(x_{2}\\right)\\right)^{p}-1.0\\le 0\\left\\{x_{1}\\ge -1\\right\\}\\left\\{x_{1}\\le 1\\right\\}",
            "ax_{1}+bx_{2}=c",
            "o_{x1}=\\left(-\\operatorname{sign}\\left(a\\right)\\right)\\left(\\frac{\\operatorname{abs}\\left(a\\right)}{\\left(\\left(\\operatorname{abs}\\left(a\\right)\\right)^{\\frac{p}{p-1}}+\\left(\\operatorname{abs}\\left(b\\right)\\right)^{\\frac{p}{p-1}}\\right)^{\\frac{1.0}{\\frac{p}{p-1}}}}\\right)^{\\frac{p}{p-1}-1.0}",
            "o_{x2}=\\left(-\\operatorname{sign}\\left(b\\right)\\right)\\left(\\frac{\\operatorname{abs}\\left(b\\right)}{\\left(\\left(\\operatorname{abs}\\left(a\\right)\\right)^{\\frac{p}{p-1}}+\\left(\\operatorname{abs}\\left(b\\right)\\right)^{\\frac{p}{p-1}}\\right)^{\\frac{1.0}{\\frac{p}{p-1}}}}\\right)^{\\frac{p}{p-1}-1.0}",
            "\\left(o_{x1},o_{x2}\\right)",
            "c=ao_{x1}+bo_{x2}",
            "x_{1}=x",
            "x_{2}=y",
        ]

        slider = state.expressions.list[1].slider
        @test slider.min == "1" && slider.max == "3" && isnothing(slider.step)

        set_optimizer(m, optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
        optimize!(m)
        obj_val = objective_value(m)
        x₁_val = value(x₁)
        x₂_val = value(x₂)
        state2 = Desmos.DesmosState(m)
        exprs2 = [expr.latex for expr in state2.expressions.list]
        @test exprs2 == [
            "p=1.25",
            "a=0.5",
            "b=1.5",
            "\\left(\\operatorname{abs}\\left(x_{1}\\right)\\right)^{p}+\\left(\\operatorname{abs}\\left(x_{2}\\right)\\right)^{p}-1.0\\le 0\\left\\{x_{1}\\ge -1\\right\\}\\left\\{x_{1}\\le 1\\right\\}",
            "ax_{1}+bx_{2}=c",
            "c=$obj_val",
            "\\left($x₁_val,$x₂_val\\right)",
            "x_{1}=x",
            "x_{2}=y",
        ]
    end
end
