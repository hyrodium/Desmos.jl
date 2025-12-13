using Desmos
using Test
using JSON
using Aqua
using Colors
using LaTeXStrings

Aqua.test_all(Desmos; ambiguities = false)

b = 3
image_url = "https://raw.githubusercontent.com/hyrodium/Visualize2dimNewtonMethod/b3fcb1f935439d671e3ddb3eb3b19fd261f6b067/example1a.png"

path_base = joinpath(@__DIR__, "base.html")
path_result = joinpath(@__DIR__, "result.html")
cp(path_base, path_result, force = true)

function update_result(title, json)
    lines = readlines(path_result)
    i_begin = findfirst(line -> occursin("<!-- begin", line), lines)
    i_end = findfirst(line -> occursin("end -->", line), lines)
    block = replace(join(lines[(i_begin + 1):(i_end - 1)], "\n"), "state =" => "state = $(json)", "TITLE" => title)
    return write(joinpath(@__DIR__, "result.html"), join(vcat(lines[begin:(i_begin - 1)], split(block, "\n"), lines[i_begin:end]), "\n"))
end

@testset "Export HTML" begin

    @testset "basic" begin
        title = "BasicFunctions"
        state = @desmos begin
            @text "Trigonometric functions"
            @expression cos(x) color = $(RGB(1, 0, 0))
            @expression sin(x) color = RGB(0, 0, 1)
            tan(x)
            @expression cot(x) hidden = true
            @expression (cosh(t), sinh(t)) parametric_domain = -2 .. 3
        end
        json = JSON.json(state)
        update_result(title, json)
    end

    @testset "variables" begin
        title = "VariableDefinitions"
        state = @desmos begin
            a = 4
            @expression b = 5 slider = 2 .. 6
            @expression c = 5 slider = 1:8
            @expression d = 7
            $(2 + 2)
            sin($(2b) * a - cx)
        end
        json = JSON.json(state)
        update_result(title, json)
    end

    @testset "Newton's method" begin
        title = "NewtonMethod"
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
        json = JSON.json(state)
        update_result(title, json)
    end
end

@testset "JSON I/O" begin
    @testset "example$i.json" for i in 1:4
        path_json = joinpath(@__DIR__, "json_example", "example$i.json")
        state = JSON.parse(read(path_json, String), DesmosState)
        jo1 = JSON.parse(read(path_json, String))
        jo2 = JSON.parse(JSON.json(state, 4))
        delete!(jo1.graph, "__v12ViewportLatexStash")
        @test jo2 == jo1
    end
end

@testset "latexify" begin
    @test Desmos.desmos_latexify(:(1 + 1)) == "1 + 1"
    @test Desmos.desmos_latexify(:(sin(x))) == "\\sin\\left( x \\right)"
    @test Desmos.desmos_latexify(L"\sin(x)") == "\\sin(x)"
    @test Desmos.desmos_latexify(:(tan(xy))) == "\\tan\\left( x_{y} \\right)" broken = true
    @test Desmos.desmos_latexify(:((a, b))) == "(a, b)"
    @test Desmos.desmos_latexify(:(α_5 - Β⁵)) == "\\alpha_{5} - \\Beta^5"
    @test Desmos.desmos_latexify(:(Inf)) == "\\infty"
    @test Desmos.desmos_latexify(:(sum(n^2 for n in 1:5))) == "\\sum_{n = 1}^{5} n^{2}"
    @test Desmos.desmos_latexify(:(int(x^2 for x in 1 .. 5))) == "\\int_{1}^{5} x^{2} dx" broken = true
    @test Desmos.desmos_latexify(:(gradient(f, x))) == "\\frac{d}{dx} f" broken = true
    @test Desmos.desmos_latexify(:([1, 2, 3])) == "[1, 2, 3]" broken = true
end

@testset "HTML Display" begin
    # Create a simple test state
    state = @desmos begin
        @expression sin(x)
    end

    @testset "Default configuration" begin
        # Reset to defaults
        Desmos.set_desmos_display_config(
            width = 600,
            height = 400,
            clipboard = false,
            api_version = 10,
            api_key = "dcb31709b452b1cf9dc26972add0fda6"
        )

        io = IOBuffer()
        show(io, MIME("text/html"), state)
        html = String(take!(io))

        # Check default dimensions
        @test occursin("width:600px", html)
        @test occursin("height:400px", html)

        # Check default API settings
        @test occursin("api/v1.10/calculator.js", html)
        @test occursin("apiKey=dcb31709b452b1cf9dc26972add0fda6", html)

        # Check that clipboard button is not present
        @test !occursin("Export State to Clipboard", html)
    end

    @testset "Custom API configuration" begin
        # Set custom API version and key
        Desmos.set_desmos_display_config(
            api_version = 11,
            api_key = "custom-test-api-key"
        )

        io = IOBuffer()
        show(io, MIME("text/html"), state)
        html = String(take!(io))

        # Check custom API settings
        @test occursin("api/v1.11/calculator.js", html)
        @test occursin("apiKey=custom-test-api-key", html)
    end

    @testset "Custom dimensions and clipboard" begin
        # Set custom dimensions and enable clipboard
        Desmos.set_desmos_display_config(
            width = 800,
            height = 600,
            clipboard = true
        )

        io = IOBuffer()
        show(io, MIME("text/html"), state)
        html = String(take!(io))

        # Check custom dimensions
        @test occursin("width:800px", html)
        @test occursin("height:600px", html)

        # Check that clipboard button is present
        @test occursin("Export State to Clipboard", html)
    end

    # Reset to defaults after tests
    Desmos.set_desmos_display_config(
        width = 600,
        height = 400,
        clipboard = false,
        api_version = 10,
        api_key = "dcb31709b452b1cf9dc26972add0fda6"
    )
end
