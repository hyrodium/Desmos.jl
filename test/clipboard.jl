@testset "clipboard_desmos_state function" begin
    @testset "Round-trip clipboard operations" begin
        state1 = @desmos begin
            @expression sin(x)
            @expression cos(x) color = RGB(1, 0, 0)
            @text "Test graph"
        end

        # Copy state to clipboard
        Desmos.clipboard_desmos_state(state1)

        # Read state from clipboard
        state2 = Desmos.clipboard_desmos_state()

        # Compare states
        @test state1 == state2
    end

    @testset "Multiple expressions round-trip" begin
        state1 = @desmos begin
            @expression y = x^2
            @expression a = 2 slider = 1 .. 5
            @expression b = 3 slider = 1:10
            # @folder "Functions" begin
            #     @expression f(x) = a * x + b
            #     @expression g(x) = x^2 - 4
            # end
        end

        # Copy state to clipboard
        Desmos.clipboard_desmos_state(state1)

        # Read state from clipboard
        state2 = Desmos.clipboard_desmos_state()

        # Compare states
        @test state1 == state2
    end

    @testset "Empty state round-trip" begin
        state1 = @desmos begin
        end

        # Copy state to clipboard
        Desmos.clipboard_desmos_state(state1)

        # Read state from clipboard
        state2 = Desmos.clipboard_desmos_state()

        # Compare states
        @test state1 == state2
    end
end
