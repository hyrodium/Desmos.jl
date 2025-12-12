"""
    clipboard_desmos_state()

Import a Desmos graph state from clipboard.

This function reads JSON data from the system clipboard and parses it into a `DesmosState` object.
Useful for importing graphs that were edited in the Desmos calculator and exported using the
"Export State to Clipboard" button (available when `clipboard=true`).

# Examples
```julia
# Enable clipboard mode
Desmos.set_display_options(clipboard=true)

# Display a graph
state = @desmos begin
    y = x^2
end

# Edit the graph in the plot pane and click "Export State to Clipboard"
# Then import the modified state
modified_state = Desmos.clipboard_desmos_state()
```

# Notes
- Requires clipboard access (uses `clipboard()` function)
- The clipboard must contain valid Desmos state JSON
- Throws an error if the JSON is invalid or cannot be parsed
"""
function clipboard_desmos_state()
    json_str = clipboard()
    return JSON.parse(json_str, DesmosState)
end

function clipboard_desmos_state(state::DesmosState)
    return clipboard(JSON.json(state, 4))
end
