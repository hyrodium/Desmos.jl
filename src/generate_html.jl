"""
    generate_desmos_html(state::DesmosState; config::DesmosDisplayConfig=get_desmos_display_config(), full_html::Bool=true)

Generate HTML content for displaying a Desmos graph.

# Arguments
- `state`: The DesmosState object to visualize
- `config`: Optional DesmosDisplayConfig for customizing the display (width, height, API settings)
- `full_html`: If `true`, generates a complete HTML document with `<html>`, `<head>`, and `<body>` tags.
              If `false`, generates only the calculator div and script tags (for embedding).

# Returns
A string containing the generated HTML.

# Examples
```julia
# Generate complete HTML document
state = @desmos begin
    @expression sin(x)
end
html = generate_desmos_html(state)
write("output.html", html)

# Generate embeddable HTML fragment
html_fragment = generate_desmos_html(state; full_html=false)
```
"""
function generate_desmos_html(state::DesmosState; config::DesmosDisplayConfig = get_desmos_display_config(), full_html::Bool = true)
    obj_id = objectid(state)

    width_style = config.width == 0 ? "width:100%;max-width:100%;min-width:400px;" : "width:$(config.width)px;"
    html = """
        <div class="desmos-container" id="desmos-$(obj_id)" style="$(width_style)height:$(config.height)px;"></div>
    """

    if config.clipboard
        html *= """
        <div style="margin-top:10px;">
            <button id="export-btn-$(obj_id)" style="padding:4px 12px;font-size:14px;cursor:pointer;border:1px solid #ccc;border-radius:4px;background-color:#f8f9fa;">Export State to Clipboard</button>
            <span id="export-status-$(obj_id)" style="margin-left:10px;font-size:14px;font-weight:bold;"></span>
        </div>
        """
    end

    html *= """
        <script src="https://www.desmos.com/api/v1.$(config.api_version)/calculator.js?apiKey=$(config.api_key)"></script>
        <script>
            (function() {
                var elt = document.getElementById("desmos-$(obj_id)");
                var calculator = Desmos.GraphingCalculator(elt);
                calculator.setState($(JSON.json(state)));

                // Prevent VSCode Plot Pane from capturing arrow key events
                // Strategy: Always stop propagation and let Desmos handle it
                // This prevents VSCode from intercepting before Desmos can process
                elt.addEventListener('keydown', function(e) {
                    if (['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(e.key)) {
                        // Stop event from reaching VSCode Plot Pane
                        e.stopPropagation();
                        // Let the event continue to Desmos's internal handlers
                        // by NOT calling preventDefault()
                    }
                }, false); // Use bubble phase, not capture
    """

    if config.clipboard
        html *= """

                var exportBtn = document.getElementById("export-btn-$(obj_id)");
                var exportStatus = document.getElementById("export-status-$(obj_id)");
                exportBtn.addEventListener('click', function() {
                    var currentState = calculator.getState();
                    var stateJson = JSON.stringify(currentState, null, 2);
                    navigator.clipboard.writeText(stateJson).then(function() {
                        exportStatus.textContent = 'Exported!';
                        exportStatus.style.color = '#4CAF50';
                        setTimeout(function() {
                            exportStatus.textContent = '';
                        }, 2000);
                    }).catch(function(err) {
                        console.error('Failed to copy:', err);
                        exportStatus.textContent = 'Export failed!';
                        exportStatus.style.color = '#f44336';
                        setTimeout(function() {
                            exportStatus.textContent = '';
                        }, 2000);
                    });
                });
        """
    end

    html *= """
            })();
        </script>
    """

    if full_html
        html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Desmos.jl</title>
        </head>
        <body>
        $(html)
        </body>
        </html>
        """
    end
    return html
end

function Base.show(io::IO, ::MIME"text/html", state::DesmosState)
    config = get_desmos_display_config()
    html = generate_desmos_html(state; config = config, full_html = false)
    return write(io, html)
end

function Base.show(io::IO, ::MIME"juliavscode/html", state::DesmosState)
    return show(io, MIME("text/html"), state)
end
