eval_dollar!(::Module, ex) = ex
function eval_dollar!(target_module::Module, ex::Expr)
    if ex.head === :($)
        return Core.eval(target_module, Expr(:quote, ex))
    elseif ex.head !== :quote
        for i in 1:length(ex.args)
            ex.args[i] = eval_dollar!(target_module, ex.args[i])
        end
    end
    return ex
end

function generate_abstractexpression(e::Expr, id)
    if e.head === :call
        # sin(x)
        return DesmosExpression(latex = desmos_latexify(e), id = string(id)), id + 1
    elseif e.head === :(=)
        # a = 5
        return DesmosExpression(latex = desmos_latexify(e), id = string(id)), id + 1
    elseif e.head === :(tuple)
        # (a, b)
        return DesmosExpression(latex = desmos_latexify(e), id = string(id)), id + 1
    elseif e.head === :(vect)
        # [1,2,3]
        return DesmosExpression(latex = desmos_latexify(e), id = string(id)), id + 1
    elseif e.head === :macrocall
        # @expression sin(x) color=RGB(1,0,0)
        push!(e.args, :(id = $id))
        return eval(e)
    end
    dump(e)
    error("unsupported expression: $e")
end

function generate_abstractexpression(e::String, id)
    # e == "comment"
    return DesmosText(text = e, id = string(id)), id + 1
end

function generate_abstractexpression(a::Union{Integer, AbstractFloat}, id)
    # a == "42"
    return DesmosExpression(latex = desmos_latexify(a), id = string(id)), id + 1
end

function desmos_color(color::String)
    return color
end

function desmos_color(color::Colorant)
    return "#$(hex(color))"
end

function desmos_domain(interval::AbstractInterval)
    return DesmosDomain(
        min = LaTeXString(string(minimum(interval))),
        max = LaTeXString(string(maximum(interval))),
    )
end

function desmos_parametric_domain(interval::AbstractInterval)
    return DesmosParametricDomain(
        min = LaTeXString(string(minimum(interval))),
        max = LaTeXString(string(maximum(interval))),
    )
end

function desmos_slider(interval::AbstractInterval)
    return DesmosSlider(
        hard_min = true,
        hard_max = true,
        min = LaTeXString(string(minimum(interval))),
        max = LaTeXString(string(maximum(interval))),
    )
end

function desmos_slider(range::AbstractRange)
    return DesmosSlider(
        hard_min = true,
        hard_max = true,
        min = LaTeXString(string(minimum(range))),
        max = LaTeXString(string(maximum(range))),
        step = LaTeXString(string(step(range))),
    )
end


function generate_expression(; latex, id::Int, color, slider, lines, hidden, domain, parametric_domain)
    return DesmosExpression(; latex, id = string(id), color, slider, lines, hidden, domain, parametric_domain), id + 1
end

function generate_image(; id, image_url, hidden, name, width, height)
    return DesmosImage(; id = string(id), image_url, hidden, name, width, height), id + 1
end

function generate_text(; text, id)
    return DesmosText(; text, id = string(id)), id + 1
end

"""
    generate_table(data, id, color)

Convert table data to a DesmosTable using multiple dispatch.

This is the main entry point for table generation. Different methods handle:
- Dict{Symbol, Any}: Column specifications from `@table x=[1,2,3] y=[4,5,6]`
- DataFrame: Tables from DataFrames.jl (via package extension)
- Other table-like objects can add their own methods

# Arguments
- `data`: Table data (Dict, DataFrame, or other table-like object)
- `id`: ID string for the table
- `color`: Color string for the table columns (default: "#000000")
"""
function generate_table end

"""
    generate_table(column_names::Vector{Symbol}, column_values::Vector, id, color)

Convert column names and values to a DesmosTable.

# Arguments
- `column_names`: Vector of column name symbols
- `column_values`: Vector of column value arrays (or `nothing` for columns without values)
- `id`: Table ID
- `color`: Color for the table columns

# Example
```julia
generate_table([:x_1, :y_1], [[1,2,3], [4,5,6]]; id="1", color="#FF0000")
generate_table([:x_1, :y_2], [[1,2,3], nothing]; id="1", color="#000000")
```
"""
function generate_table(
        column_names::Vector{Symbol},
        column_values::Vector;
        id::Int,
        color = "#000000",
    )
    @assert length(column_names) == length(column_values) "Column names and values must have same length"

    columns = DesmosColumn[]
    id_column = id + 1

    for (colname, values) in zip(column_names, column_values)
        latex = desmos_latexify(colname)

        if values !== nothing
            # Column with values
            column = DesmosColumn(
                id = string(id_column),
                color = color,
                values = string.(values),
                latex = latex,
            )
        else
            # Column without values (symbol-only)
            column = DesmosColumn(id = string(id_column), color = color, latex = latex)
        end

        push!(columns, column)
        id_column = id_column + 1
    end

    return DesmosTable(id = id, columns = columns), id_column
end

"""
    generate_table(df::DataFrame, id, color)

Convert a DataFrame to a DesmosTable.

Each column in the DataFrame becomes a DesmosColumn with the column name as the LaTeX label.
This method works with any object that supports `names()` and column access via `getproperty()`.
"""
function generate_table(df::DataFrame; id, color = "#000000")
    # Use getproperty to access DataFrame methods without importing
    # This works with DataFrames and other table-like objects
    columns = DesmosColumn[]
    id_column = id + 1

    for colname in names(df)
        values = string.(getproperty(df, colname))
        latex = LaTeXString(string(colname))

        column = DesmosColumn(
            id = string(id_column),
            color = color,
            values = values,
            latex = latex,
        )
        push!(columns, column)
        id_column += 1
    end

    return DesmosTable(id = id, columns = columns), id_column
end
