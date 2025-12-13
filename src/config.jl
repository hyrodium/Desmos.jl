"""
    DesmosDisplayConfig

Configuration for Desmos graph display in plot panes.

# Fields
- `width::Int`: Width of the Desmos container in pixels (default: 600)
- `height::Int`: Height of the Desmos container in pixels (default: 400)
- `clipboard::Bool`: Enable clipboard export button (default: false)
- `api_version::String`: Desmos API version (default: "1.10")
- `api_key::String`: Desmos API key (default: "dcb31709b452b1cf9dc26972add0fda6")
"""
Base.@kwdef mutable struct DesmosDisplayConfig
    width::Int = 600
    height::Int = 400
    clipboard::Bool = false
    api_version::String = "1.10"
    api_key::String = "dcb31709b452b1cf9dc26972add0fda6"
end

"""
Global display configuration for Desmos graphs.
"""
const DESMOS_DISPLAY_CONFIG = DesmosDisplayConfig()

"""
    set_desmos_display_config(; width=nothing, height=nothing, clipboard=nothing, api_version=nothing, api_key=nothing)

Set display options for Desmos graphs.

# Arguments
- `width::Int`: Width of the Desmos container in pixels
- `height::Int`: Height of the Desmos container in pixels
- `clipboard::Bool`: Enable clipboard export button
- `api_version::String`: Desmos API version
- `api_key::String`: Desmos API key

# Examples
```julia
# Set clipboard mode with custom size
Desmos.set_desmos_display_config(width=800, height=600, clipboard=true)

# Enable only clipboard mode
Desmos.set_desmos_display_config(clipboard=true)

# Set custom API version and key
Desmos.set_desmos_display_config(api_version="1.11", api_key="your-api-key-here")
```
"""
function set_desmos_display_config(; kwargs...)
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
    get_desmos_display_config()

Get current display options for Desmos graphs.

# Examples
```julia
Desmos.get_desmos_display_config()
```
"""
function get_desmos_display_config()
    return DESMOS_DISPLAY_CONFIG
end
