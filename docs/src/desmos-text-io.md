# Working with Desmos Text I/O

[Desmos Text I/O](https://github.com/hyrodium/DesmosTextIO) is a browser extension that enables importing and exporting Desmos graphs as text/JSON. This extension works seamlessly with Desmos.jl, allowing you to transfer graphs between Julia and the Desmos web interface.

[![](https://raw.githubusercontent.com/hyrodium/desmos-text-io/main/logo.svg)](https://github.com/hyrodium/DesmosTextIO)

## Installation

The extension is available for multiple browsers:

* [Chrome Web Store](https://chrome.google.com/webstore/detail/desmos-text-io/ndjdcebpigpfidnilppdpcdkibidfmaa)
* [Firefox ADD-ONS](https://addons.mozilla.org/en-US/firefox/addon/desmos-text-i-o/)

## How It Works

Desmos Text I/O allows you to:

1. **Export from Desmos**: Copy the JSON state of any Desmos graph to your clipboard
2. **Import to Desmos**: Paste JSON state to recreate a graph in Desmos
3. **Share graphs as text**: Store and share complete graph configurations as JSON

This makes it easy to:
- Transfer graphs created in Julia to the Desmos web interface
- Import existing Desmos graphs into your Julia workflow
- Share reproducible graph configurations with collaborators

## Exporting from Julia to Desmos

1. Create a graph in Julia using Desmos.jl
2. Enable clipboard mode in the [display configuration](config.md):

```@example desmos-text-io
using Desmos

# Enable clipboard export button
set_desmos_display_config(width=600,height=400,clipboard=false,api_version=10,api_key="dcb31709b452b1cf9dc26972add0fda6") # hide
Desmos.set_desmos_display_config(clipboard=true)

# Create your graph
state = @desmos begin
    @text "My graph"
    @expression sin(x) + cos(2x)
    @expression y = x^2
end
```

3. Click the clipboard export button in the rendered plot pane
4. Open [Desmos Graphing Calculator](https://www.desmos.com/calculator)
5. Use the Desmos Text I/O extension to import the copied JSON

## Importing from Desmos to Julia

The easiest way to import a graph from Desmos is using the [`clipboard_desmos_state`](@ref) function:

1. Open a graph in [Desmos Graphing Calculator](https://www.desmos.com/calculator)
2. Use the Desmos Text I/O extension to export the graph as JSON to your clipboard
3. In Julia, import the graph directly:

```julia
using Desmos

# Import the graph state from clipboard
state = Desmos.clipboard_desmos_state()
```

The function reads JSON data from the system clipboard and parses it into a [`DesmosState`](@ref) object.

## Working with the Clipboard

The [`clipboard_desmos_state`](@ref) function works both ways:

### Exporting to Clipboard

```@example desmos-text-io
using Desmos

state = @desmos begin
    y = sin(x) * cos(2x)
    y = x^2 - 3
end
```

```julia
# Copy the state to clipboard as JSON
Desmos.clipboard_desmos_state(state)
# Now you can paste it into Desmos using the Text I/O extension
```

### Round-trip Example

```julia
# 1. Create and export a graph
state = @desmos begin
    f(x) = x^2
end
Desmos.clipboard_desmos_state(state)

# 2. Edit in Desmos web interface, then export using Text I/O extension

# 3. Import the modified graph back to Julia
modified_state = Desmos.clipboard_desmos_state()
```

## Saving and Loading Graphs

You can save graph configurations as JSON files for reproducibility:

```@example desmos-text-io
using Desmos, JSON

state = @desmos begin
    @expression f(x) = sin(x) * exp(-x/10)
end

# Save to file
open("my_graph.json", "w") do io
    JSON.print(io, state, 2)
end

# Load later
loaded_state = JSON.parsefile("my_graph.json")
```

## Related Configuration

See the [Display Configuration](config.md) page for details on enabling clipboard mode and other display options that enhance the Desmos Text I/O workflow.
