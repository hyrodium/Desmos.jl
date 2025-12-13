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
