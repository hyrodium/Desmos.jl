# Run this script with `julia --project=. replay.jl`
using Replay
using Desmos
using JSON

instructions = [
    "using Desmos, JSON",
    """
    state = @desmos begin
        @expression cos(x) color=RGB(1,0,0)
        @expression sin(x) color=RGB(0,0,1)
        tan(x)
    end
    """,
    "",
    "clipboard(JSON.json(state, 4))",
]

replay(instructions, use_ghostwriter = true)
