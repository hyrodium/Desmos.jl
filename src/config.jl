"""
    DesmosDisplayConfig

Configuration for Desmos graph display in plot panes.

# Fields
- `width::Int`: Width of the Desmos container in pixels (default: 600)
- `height::Int`: Height of the Desmos container in pixels (default: 400)
- `clipboard::Bool`: Enable clipboard export button (default: false)
"""
Base.@kwdef mutable struct DesmosDisplayConfig
    width::Int = 600
    height::Int = 400
    clipboard::Bool = false
end

"""
Global display configuration for Desmos graphs.
"""
const DESMOS_DISPLAY_CONFIG = DesmosDisplayConfig()

"""
    desmos_display_config(; width=nothing, height=nothing, clipboard=nothing)

Set display options for Desmos graphs.

# Arguments
- `width::Int`: Width of the Desmos container in pixels
- `height::Int`: Height of the Desmos container in pixels
- `clipboard::Bool`: Enable clipboard export button

# Examples
```julia
# Set clipboard mode with custom size
Desmos.desmos_display_config(width=800, height=600, clipboard=true)

# Enable only clipboard mode
Desmos.desmos_display_config(clipboard=true)
```
"""
function desmos_display_config(; kwargs...)
    for (key, value) in kwargs
        if hasproperty(DESMOS_DISPLAY_CONFIG, key)
            setproperty!(DESMOS_DISPLAY_CONFIG, key, value)
        else
            throw(ArgumentError("Unknown display option: $key"))
        end
    end
    return DESMOS_DISPLAY_CONFIG
end

"""
    desmos_display_config()

Get current display options for Desmos graphs.

# Examples
```julia
Desmos.desmos_display_config()
```
"""
function desmos_display_config()
    return DESMOS_DISPLAY_CONFIG
end
