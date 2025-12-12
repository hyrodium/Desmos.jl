function Base.show(io::IO, ::MIME"text/html", state::DesmosState)
    config = get_display_options()
    obj_id = objectid(state)

    html = """
        <div class="desmos-container" id="desmos-$(obj_id)" style="width:$(config.width)px;height:$(config.height)px;"></div>
    """

    if config.clipboard
        html *= """
        <button id="export-btn-$(obj_id)" style="margin-top:10px;padding:8px 16px;cursor:pointer;">Export State to Clipboard</button>
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
                exportBtn.addEventListener('click', function() {
                    var currentState = calculator.getState();
                    var stateJson = JSON.stringify(currentState, null, 2);
                    navigator.clipboard.writeText(stateJson).then(function() {
                        exportBtn.textContent = 'Exported!';
                        exportBtn.style.backgroundColor = '#4CAF50';
                        exportBtn.style.color = 'white';
                        setTimeout(function() {
                            exportBtn.textContent = 'Export State to Clipboard';
                            exportBtn.style.backgroundColor = '';
                            exportBtn.style.color = '';
                        }, 2000);
                    }).catch(function(err) {
                        console.error('Failed to copy:', err);
                        exportBtn.textContent = 'Export failed!';
                        exportBtn.style.backgroundColor = '#f44336';
                        exportBtn.style.color = 'white';
                        setTimeout(function() {
                            exportBtn.textContent = 'Export State to Clipboard';
                            exportBtn.style.backgroundColor = '';
                            exportBtn.style.color = '';
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
