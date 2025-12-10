function Base.show(io::IO, ::MIME"text/html", state::DesmosState)
    return write(
        io, """
            <div class="desmos-container" id="desmos-$(objectid(state))" style="width:600px;height:400px;"></div>
            <script src="https://www.desmos.com/api/v1.10/calculator.js?apiKey=dcb31709b452b1cf9dc26972add0fda6"></script>
            <script>
                (function() {
                    var elt = document.getElementById("desmos-$(objectid(state))");
                    var calculator = Desmos.GraphingCalculator(elt);
                    calculator.setState($(JSON.json(state)));
                })();
            </script>
        """
    )
end

function Base.show(io::IO, ::MIME"juliavscode/html", agif::DesmosState)
    return show(io, MIME("text/html"), agif)
end
