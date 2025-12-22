# Display Configuration

Desmos.jl provides configuration options to customize how graphs are displayed in plot panes.

## Configuration Overview

The display behavior is controlled through a global configuration object that you can modify using [`set_desmos_display_config`](@ref).

## Configuration Options

The following options are available:

- **`width::Int`**: Width of the Desmos container in pixels (default: `600`)
- **`height::Int`**: Height of the Desmos container in pixels (default: `400`)
- **`clipboard::Bool`**: Enable clipboard export button (default: `false`)
- **`api_version::Int`**: Desmos API v1 minor version (default: `10` for v1.10)
- **`api_key::String`**: Desmos API key (default: `"dcb31709b452b1cf9dc26972add0fda6"`[^1])

## Examples

### Setting Display Size

```@example config
using Desmos

# Set custom width and height
Desmos.set_desmos_display_config(width=800, height=600)

# Now all Desmos graphs will be displayed with these dimensions
state = @desmos begin
    @expression sin(x)
end
```

### Enabling Clipboard Export

The clipboard option adds an export button to copy the graph state to your clipboard. This is particularly useful when working with [Desmos Text I/O](desmos-text-io.md) to transfer graphs between Julia and the Desmos web interface:

```@example config
# Enable clipboard export button
Desmos.set_desmos_display_config(clipboard=true)

state = @desmos begin
    @expression cos(x)
end
```

### Using a Different API Version

If you need to use a specific version of the Desmos API:

```@example config
# Use Desmos API v1.11
Desmos.set_desmos_display_config(api_version=11)
```

For more information about Desmos API versions, see the [Desmos API documentation](https://www.desmos.com/api/v1.10/docs/index.html).

### Setting a Custom API Key

```julia
# Use your own Desmos API key, which can be obtained from https://www.desmos.com/api/v1.10/docs/index.html
Desmos.set_desmos_display_config(api_key="your-api-key-here")
```

### Combining Multiple Options

```@example config
# Set multiple options at once
Desmos.set_desmos_display_config(
    width=1000,
    height=800,
    clipboard=true,
    api_version=10
)
```

## Getting Current Configuration

You can check the current display configuration with [`get_desmos_display_config`](@ref):

```@example config
config = Desmos.get_desmos_display_config()
println("Current width: ", config.width)
println("Current height: ", config.height)
println("Clipboard enabled: ", config.clipboard)
```

[^1]: This default API key is from the [Desmos API documentation](https://www.desmos.com/api/v1.10/docs/index.html).
