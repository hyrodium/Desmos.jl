using Desmos
using Test
using JSON
using Aqua
using Colors
using LaTeXStrings

Aqua.test_all(Desmos; ambiguities = false)

b = 3
image_url = "https://raw.githubusercontent.com/hyrodium/Visualize2dimNewtonMethod/b3fcb1f935439d671e3ddb3eb3b19fd261f6b067/example1a.png"

function write_html(path, title, state)
    open(path, "w") do io
        write(io, """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>$(title)</title>
        </head>
        <body>
        <h1>$(title)</h1>
        """)
        show(io, MIME("text/html"), state)
        write(io, """
        </body>
        </html>
        """)
    end
end

@testset "Export HTML" begin
    mkpath(joinpath(@__DIR__, "out"))

    @testset "basic" begin
        path = joinpath(@__DIR__, "out", "basic.html")

        # Remove existing file
        rm(path, force = true)
        @test !isfile(path)

        state = @desmos begin
            @text "Trigonometric functions"
            @expression cos(x) color = $(RGB(1, 0, 0))
            @expression sin(x) color = RGB(0, 0, 1)
            tan(x)
            @expression cot(x) hidden = true
            @expression (cosh(t), sinh(t)) parametric_domain = -2 .. 3
        end

        write_html(path, "BasicFunctions", state)

        @test isfile(path)
    end

    @testset "variables" begin
        path = joinpath(@__DIR__, "out", "variables.html")

        # Remove existing file
        rm(path, force = true)
        @test !isfile(path)

        state = @desmos begin
            a = 4
            @expression b = 5 slider = 2 .. 6
            @expression c = 5 slider = 1:8
            @expression d = 7
            $(2 + 2)
            sin($(2b) * a - cx)
        end

        write_html(path, "VariableDefinitions", state)

        @test isfile(path)
    end

    @testset "Newton's method" begin
        path = joinpath(@__DIR__, "out", "newton.html")

        # Remove existing file
        rm(path, force = true)
        @test !isfile(path)

        state = @desmos begin
            f(x, y) = x^2 + y^2 - 3.9 - x / 2
            g(x, y) = x^2 - y^2 - 2
            @expression 0 = f(x, y) color = Gray(0.3)
            @expression 0 = g(x, y) color = Gray(0.6)
            f_x(x, y) = (d / dx)(f(x, y))
            f_y(x, y) = (d / dy)(f(x, y))
            g_x(x, y) = (d / dx)(g(x, y))
            g_y(x, y) = (d / dy)(g(x, y))
            d(x, y) = f_x(x, y) * g_y(x, y) - f_y(x, y) * g_x(x, y)
            A(x, y) = x - (g_y(x, y) * f(x, y) - f_y(x, y) * g(x, y)) / d(x, y)
            B(x, y) = y - (-g_x(x, y) * f(x, y) + f_x(x, y) * g(x, y)) / d(x, y)
            a₀ = 1
            b₀ = 1
            a(0) = a₀
            b(0) = b₀
            a(i) = A(a(i - 1), b(i - 1))
            b(i) = B(a(i - 1), b(i - 1))
            @expression L"I = [0,...,10]"
            (a₀, b₀)
            @expression (a(I), b(I)) lines = true
            @image image_url = $image_url width = 20 height = 20 name = "regions"
        end

        write_html(path, "NewtonMethod", state)

        @test isfile(path)
    end
end

include("json_types.jl")
include("show.jl")
include("latexify.jl")
include("clipboard.jl")
