module DesmosDataFramesExt

using Desmos
using DataFrames

"""
    generate_table(df::DataFrame, id, color)

Convert a DataFrame to a DesmosTable.

Each column in the DataFrame becomes a DesmosColumn with the column name as the LaTeX label.
This method works with any object that supports `names()` and column access via `getproperty()`.
"""
function Desmos.generate_table(df::DataFrame; id, color = "#000000")
    # Use getproperty to access DataFrame methods without importing
    # This works with DataFrames and other table-like objects
    columns = Desmos.DesmosColumn[]
    id_column = id + 1

    for colname in names(df)
        values = string.(getproperty(df, colname))
        latex = Desmos.desmos_latexify(colname)

        column = Desmos.DesmosColumn(
            id = string(id_column),
            color = color,
            values = values,
            latex = latex,
        )
        push!(columns, column)
        id_column += 1
    end

    return Desmos.DesmosTable(; id = string(id), columns), id_column
end

end # module
