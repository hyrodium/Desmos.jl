function Base.show(io::IO, ::MIME"text/html", state::DesmosState)
    # Desmos Calculator APIを使ったHTMLを生成
    # TODO: update version
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://www.desmos.com/api/v1.7/calculator.js?apiKey=dcb31709b452b1cf9dc26972add0fda6"></script>
    </head>
    <body>
        <div id="NAME" style="width: 800px; height: 400px;"></div>
        <script>
            var elt = document.getElementById('NAME');
            var calculator = Desmos.GraphingCalculator(elt);
            state = $(JSON.json(state))
            calculator.setState(state)
        </script>
    </body>
    </html>
    """
    write(io, html)
end

function Base.show(io::IO, ::MIME"juliavscode/html", agif::DesmosState)
    show(io, MIME("text/html"), agif)
end
