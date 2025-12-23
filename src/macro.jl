@doc raw"""
    @expression expr [options...]

Create a `DesmosExpression` with additional styling and behavior options.

This macro is used within a `@desmos` block to create expressions with customization
options such as color, sliders, domains, and visibility settings.

# Options

- `color`: Set the color using `RGB(r,g,b)` or hex string like `"#ff0000"`
- `slider`: Create a slider from a range (e.g., `1..10` or `1:2:10`)
- `domain`: Restrict the domain using an interval (e.g., `-5..5`)
- `parametric_domain`: Set domain for parametric curves (e.g., `0..2π`)
- `lines`: Boolean to show/hide connecting lines
- `hidden`: Boolean to hide the expression initially
- `id`: Custom ID string for the expression

# Examples

```jldoctest
julia> Desmos.@expression sin(x) color=RGB(1, 0, 0)
(Desmos.DesmosExpression("expression", "0", "#FF0000", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"\sin\left(x\right)", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression cos(x) color="#0000ff"
(Desmos.DesmosExpression("expression", "0", "#0000ff", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"\cos\left(x\right)", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression a = 3 slider=1..10
(Desmos.DesmosExpression("expression", "0", "#000000", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"a=3", Desmos.DesmosSlider(true, true, nothing, nothing, nothing, "1", "10", nothing), nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression b = 5 slider=1:0.5:10
(Desmos.DesmosExpression("expression", "0", "#000000", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"b=5", Desmos.DesmosSlider(true, true, nothing, nothing, nothing, "1.0", "10.0", "0.5"), nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression (cos(t), sin(t)) parametric_domain=0..2π
(Desmos.DesmosExpression("expression", "0", "#000000", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"\left(\cos\left(t\right),\sin\left(t\right)\right)", nothing, nothing, Desmos.DesmosParametricDomain("0.0", "6.283185307179586"), nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression x^2 domain=-5..5
(Desmos.DesmosExpression("expression", "0", "#000000", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"x^{2}", nothing, Desmos.DesmosDomain(L"-5", L"5"), nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression f(x) = x^3 hidden=true
(Desmos.DesmosExpression("expression", "0", "#000000", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, true, L"f\left(x\right)=x^{3}", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)

julia> Desmos.@expression L"\\frac{x^2}{4} + \\frac{y^2}{9} = 1" color=RGB(0, 0.5, 1)
(Desmos.DesmosExpression("expression", "0", "#0080FF", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, L"\\frac{x^2}{4} + \\frac{y^2}{9} = 1", nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing, nothing), 1)
```

# See also
- [`@desmos`](@ref): Main macro for creating Desmos graphs
- [`@text`](@ref): Add text annotations
- [`@image`](@ref): Add images to the graph
"""
macro expression(ex, kwargs...)
    id = 0
    color = desmos_color(RGB(0, 0, 0))
    slider = nothing
    lines = nothing
    hidden = nothing
    domain = nothing
    parametric_domain = nothing
    for kwarg in kwargs
        if kwarg.head == :(=)
            key = kwarg.args[1]
            value = kwarg.args[2]
            if key == :id
                id = eval(value)
            elseif key == :color
                color = desmos_color(eval(value))
            elseif key == :slider
                slider = desmos_slider(eval(value))
            elseif key == :lines
                lines = eval(value)
            elseif key == :hidden
                hidden = eval(value)
            elseif key == :domain
                domain = desmos_domain(eval(value))
            elseif key == :parametric_domain
                parametric_domain = desmos_parametric_domain(eval(value))
            end
        end
    end
    if isa(ex, Expr)
        if ex.head === :macrocall
            if ex.args[1] === Symbol("@L_str")
                latex = desmos_latexify(eval(ex))
            else
                error("Unsupported expression $(ex)")
            end
        else
            latex = desmos_latexify(ex)
        end
    else
        # Handle LaTeXString or other literal values directly
        latex = desmos_latexify(eval(ex))
    end
    return generate_expression(; latex, id, color, slider, lines, hidden, domain, parametric_domain)
end

@doc raw"""
    @image options...

Add an image to the Desmos graph.

This macro creates a `DesmosImage` object that can be positioned and sized on the graph.
Images are specified via URL and can be customized with various display options.

# Options

- `image_url`: URL of the image (required)
- `width`: Width of the image in graph units
- `height`: Height of the image in graph units
- `name`: Display name for the image
- `hidden`: Boolean to hide the image initially
- `id`: Custom ID string for the image

# Examples

```julia
julia> Desmos.@image image_url="https://example.com/plot.png" name="Background" width=20 height=15
Desmos.DesmosImage("image", "0", "https://example.com/plot.png", nothing, "Background", "20", "15", nothing, nothing, nothing, nothing, nothing)
```

# See also
- [`@desmos`](@ref): Main macro for creating Desmos graphs
- [`@expression`](@ref): Add mathematical expressions
- [`@text`](@ref): Add text annotations
"""
macro image(kwargs...)
    id = 0
    image_url = ""
    hidden = nothing
    name = nothing
    width = nothing
    height = nothing
    for kwarg in kwargs
        if kwarg.head == :(=)
            key = kwarg.args[1]
            value = kwarg.args[2]
            if key == :id
                id = eval(value)
            elseif key == :image_url
                image_url = eval(value)
            elseif key == :hidden
                hidden = eval(value)
            elseif key == :name
                name = eval(value)
            elseif key == :width
                width = desmos_latexify(eval(value))
            elseif key == :height
                height = desmos_latexify(eval(value))
            end
        end
    end
    return generate_image(; id, image_url, hidden, name, width, height)
end

"""
    @text "text" [options...]

Add a text annotation to the Desmos graph.

This macro creates a `DesmosText` object for displaying textual information on the graph,
such as titles, labels, or descriptions.

# Options

- `id`: Custom ID string for the text element

# Examples

```jldoctest
julia> Desmos.@text "Sample text"
(Desmos.DesmosText("text", "0", "Sample text", nothing), 1)
```

# See also
- [`@desmos`](@ref): Main macro for creating Desmos graphs
- [`@expression`](@ref): Add mathematical expressions
- [`@image`](@ref): Add images to the graph
"""
macro text(text, kwargs...)
    id = 0
    for kwarg in kwargs
        if kwarg.head == :(=)
            key = kwarg.args[1]
            value = kwarg.args[2]
            if key == :id
                id = eval(value)
            end
        end
    end
    return generate_text(; text, id)
end

@doc raw"""
    @table data [kwargs...]

Add a table to the Desmos graph.

This macro creates a `DesmosTable` object for displaying tabular data.
The first argument specifies the data (DataFrame or column tuple), and remaining
arguments are keyword arguments for table attributes.

# Arguments

- `data`: Table data - either a DataFrame/NamedTuple/table object or a tuple of column specifications
  - DataFrame: `$df`
  - NamedTuple: `$nt`
  - Column tuple: `(x_1=[1,2,3], y_1=[4,5,6])` or `(x_1=[1,2,3], y_2)` for symbol-only columns

# Keyword Arguments (must come after data)

- `id`: Custom ID string for the table element
- `color`: Set the color using `RGB(r,g,b)` or hex string like `"#ff0000"`

# Examples

```julia
# Using a DataFrame
using DataFrames
df = DataFrame(x_1=[1,2,3], y_1=[3,4,4])
@desmos begin
    @table $df
    @table $df color=RGB(1,0,0)
end

# Using a NamedTuple
nt = (x_1=[1,2,3], y_1=[3,4,4])
@desmos begin
    @table $nt
    @table $nt color=RGB(1,0,0)
end

# Using column tuple
@desmos begin
    @table (x_1=[1,2,5], y_1=[4,7,4])
    @table (x_1=[1,2,5], y_1=[4,7,4]) color="#FF0000"
end

# Using symbols in tuple (for columns without values)
@desmos begin
    y_2 = [5,4,8]
    @table (x_1=[1,2,5], y_1=[4,7,4], y_2)
end
```

# See also
- [`@desmos`](@ref): Main macro for creating Desmos graphs
- [`@expression`](@ref): Add mathematical expressions
- [`@text`](@ref): Add text annotations
"""
macro table(data, kwargs...)
    # Parse keyword arguments
    id = 0
    color = desmos_color(RGB(0, 0, 0))

    for kwarg in kwargs
        if kwarg isa Expr && kwarg.head == :(=)
            key = kwarg.args[1]
            value = kwarg.args[2]
            if key == :id
                id = eval(value)
            elseif key == :color
                color = desmos_color(eval(value))
            else
                error("Unknown keyword argument: $key")
            end
        else
            error("Expected keyword argument, got: $kwarg")
        end
    end

    # Parse data argument
    if data isa Expr && data.head == :tuple
        # Tuple of column specifications: (x_1=[1,2,3], y_1=[4,5,6]) or (x_2=[1,2,3], y_2)
        column_names = Symbol[]
        column_values = []

        for arg in data.args
            if arg isa Expr && arg.head == :(=)
                # Column with values: x_1=[1,2,3]
                key = arg.args[1]
                value = arg.args[2]
                push!(column_names, key)
                push!(column_values, esc(value))
            elseif arg isa Symbol
                # Symbol-only column (no values): y_2
                push!(column_names, arg)
                push!(column_values, nothing)
            else
                error("Invalid column specification in tuple: $arg")
            end
        end

        # Build vectors for names and values
        names_vec = [QuoteNode(name) for name in column_names]
        values_vec = column_values

        return :(generate_table([$(names_vec...)], [$(values_vec...)]; id = $id, color = $color))
    else
        # Single argument: DataFrame or other table-like object
        return :(generate_table($(esc(data)); id = $id, color = $color))
    end
end

"""
    @desmos begin ... end

Create a `DesmosState` object from a block of mathematical expressions.

The `@desmos` macro provides a convenient DSL for creating Desmos graphs programmatically.
Each line in the block is converted to a Desmos expression, and the macro returns a
`DesmosState` object that can be serialized to JSON or displayed in Jupyter/VSCode.

# Supported syntax

- **Mathematical expressions**: `sin(x)`, `x^2 + y^2`, etc.
- **Text annotations**: `@text "Description"`
- **Styled expressions**: `@expression cos(x) color=RGB(1,0,0)`
- **Parametric curves**: `@expression (cos(t), sin(t)) parametric_domain=0..2π`
- **Variable assignments**: `a = 5`
- **Sliders**: `@expression b = 3 slider=1..10`
- **Domain restrictions**: `@expression f(x) domain=-5..5`
- **Images**: `@image image_url="..." width=10 height=10`
- **Dollar interpolation**: Use `\$(expr)` to evaluate Julia expressions at macro expansion time

# Examples

```julia
# Basic trigonometric functions
state = @desmos begin
    @text "Trigonometric functions"
    sin(x)
    cos(x)
    tan(x)
end

# With colors and styling
state = @desmos begin
    @expression sin(x) color=RGB(1, 0, 0)
    @expression cos(x) color="#0000ff"
end

# Parametric curve
state = @desmos begin
    @expression (cosh(t), sinh(t)) parametric_domain=-2..3
end

# Variables and sliders
b = 3
state = @desmos begin
    a = 4
    @expression c = 5 slider=2..6
    sin(\$(2b) * a - c * x)
end

# With domain restrictions
state = @desmos begin
    @expression x^2 domain=-5..5
end
```

# See also
- [`DesmosState`](@ref): The state object returned by this macro
- [`@expression`](@ref): Macro for creating expressions with options
- [`@text`](@ref): Macro for adding text annotations
- [`@image`](@ref): Macro for adding images
"""
macro desmos(ex)
    eval_dollar!(__module__, ex)
    expressions = DesmosExpressions(list = AbstractDesmosExpression[])
    id = 1
    for e in ex.args
        if e isa LineNumberNode
            continue
        end
        expression, id = generate_abstractexpression(e, id)
        push!(expressions.list, expression)
    end
    state = DesmosState(expressions = expressions)
    return state
end
