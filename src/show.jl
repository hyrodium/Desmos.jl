function Base.show(io::IO, ::MIME"text/html", state::DesmosState)
    config = get_desmos_display_config()
    obj_id = objectid(state)

    html = """
        <div class="desmos-container" id="desmos-$(obj_id)" style="width:$(config.width)px;height:$(config.height)px;"></div>
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
        <script src="https://www.desmos.com/api/v1.10/calculator.js?apiKey=dcb31709b452b1cf9dc26972add0fda6"></script>
        <script>
            (function() {
                var elt = document.getElementById("desmos-$(obj_id)");
                var calculator = Desmos.GraphingCalculator(elt);
                calculator.setState($(JSON.json(state)));
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

    return write(io, html)
end

function Base.show(io::IO, ::MIME"juliavscode/html", agif::DesmosState)
    return show(io, MIME("text/html"), agif)
end
