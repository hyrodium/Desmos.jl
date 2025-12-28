b = 3
image_url = "https://raw.githubusercontent.com/hyrodium/Visualize2dimNewtonMethod/b3fcb1f935439d671e3ddb3eb3b19fd261f6b067/example1a.png"
df = DataFrame(x_1 = [1, 2, 3], y_1 = [2, 4, 9])
nt = (x_2 = [1, 2, 3, 4], y_2 = [1, 4, 9, 16])

@testset "Export HTML" begin
    mkpath(joinpath(@__DIR__, "generate_html"))

    @testset "BasicFunctions" begin
        name = "BasicFunctions"
        path = joinpath(@__DIR__, "generate_html", "$name.html")
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
        write(path, generate_desmos_html(state))
        @test isfile(path)
    end

    @testset "VariableDefinitions" begin
        name = "VariableDefinitions"
        path = joinpath(@__DIR__, "generate_html", "$name.html")
        rm(path, force = true)
        @test !isfile(path)

        state = @desmos begin
            a = 4
            @expression b = 5 slider = 2 .. 6
            @expression c = 5 slider = 1:8
            @expression d = 7
            $(2 + 2)
            sin($(2b) * a - c * x)
        end
        write(path, generate_desmos_html(state))
        @test isfile(path)
    end

    @testset "NewtonMethod" begin
        name = "NewtonMethod"
        path = joinpath(@__DIR__, "generate_html", "$name.html")
        rm(path, force = true)
        @test !isfile(path)
        state = @desmos begin
            f(x, y) = x^2 + y^2 - 3.9 - x / 2
            g(x, y) = x^2 - y^2 - 2
            @expression 0 = f(x, y) color = Gray(0.3)
            @expression 0 = g(x, y) color = Gray(0.6)
            f_x(x, y) = gradient(f(x, y), x)
            f_y(x, y) = gradient(f(x, y), y)
            g_x(x, y) = gradient(g(x, y), x)
            g_y(x, y) = gradient(g(x, y), y)
            d(x, y) = f_x(x, y) * g_y(x, y) - f_y(x, y) * g_x(x, y)
            A(x, y) = x - (g_y(x, y) * f(x, y) - f_y(x, y) * g(x, y)) / d(x, y)
            B(x, y) = y - (-g_x(x, y) * f(x, y) + f_x(x, y) * g(x, y)) / d(x, y)
            a₀ = 1
            b₀ = 1
            a(0) = a₀
            b(0) = b₀
            a(i) = A(a(i - 1), b(i - 1))
            b(i) = B(a(i - 1), b(i - 1))
            @expression $(L"I = [0,...,10]")
            (a₀, b₀)
            @expression (a(I), b(I)) lines = true
            @image image_url = $image_url width = 20 height = 20 name = "regions"
        end
        write(path, generate_desmos_html(state))
        @test isfile(path)
    end

    @testset "Tables" begin
        name = "Tables"
        path = joinpath(@__DIR__, "generate_html", "$name.html")
        rm(path, force = true)
        @test !isfile(path)
        state = @desmos begin
            @text "Table from column tuple"
            @table (x_3 = [1, 2, 3], y_3 = [3, 6, 9])
            @table (x_4 = [1, 2, 3, 4], y_4 = [2, 4, 6, 8]) color = RGB(1, 0, 0)
            @text "Table from NamedTuple"
            @table $nt
            @table $nt color = RGB(0, 1, 0)
            @text "Table from DataFrame"
            @table $df
            @table $df color = RGB(0, 0, 1)
            @text "Table with symbol reference"
            z_5 = [1, 8, 27]
            @table (x_5 = [1, 2, 3], z_5)
        end
        write(path, generate_desmos_html(state))
        @test isfile(path)
    end

    @testset "LatexifyTest" begin
        name = "LatexifyTest"
        path = joinpath(@__DIR__, "generate_html", "$name.html")
        rm(path, force = true)
        @test !isfile(path)

        # Read this file and extract expected LaTeX strings from @test lines
        # Also extract @testset names to use as section headers
        filepath = joinpath(@__DIR__, "latexify.jl")
        lines = readlines(filepath)

        # Patterns to match @testset and @test lines
        testset_pattern = r"^\s*@testset\s+\"([^\"]+)\"\s+begin"
        test_pattern = r"^\s*@test\s+Desmos\.desmos_latexify\(.+?\)\s*==\s*\"([^\"]+)\""

        # Extract LaTeX strings and their corresponding testset sections
        expression_list = Desmos.AbstractDesmosExpression[]
        current_folder_id = nothing

        for line in lines
            # Check if this line starts a new @testset
            testset_match = match(testset_pattern, line)
            if testset_match !== nothing
                # Create a folder for the section
                current_folder_id = string(length(expression_list) + 1)
                push!(
                    expression_list, Desmos.DesmosFolder(
                        title = testset_match.captures[1],
                        id = current_folder_id
                    )
                )
            end

            # Check if this line has a @test
            test_match = match(test_pattern, line)
            if test_match !== nothing
                # Unescape the captured string (convert \\ to \)
                latex_str = replace(test_match.captures[1], "\\\\" => "\\")
                push!(
                    expression_list, Desmos.DesmosExpression(
                        latex = latex_str,
                        id = string(length(expression_list) + 1),
                        folder_id = current_folder_id
                    )
                )
            end
        end

        # Create DesmosState
        state = Desmos.DesmosState(expressions = Desmos.DesmosExpressions(list = expression_list))
        write(path, generate_desmos_html(state))
        @test isfile(path)
    end
end
