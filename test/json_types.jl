@testset "JSON I/O" begin
    @testset "example$i.json" for i in 1:8
        path_json = joinpath(@__DIR__, "json_types", "example$i.json")
        state = JSON.parse(read(path_json, String), DesmosState)
        jo1 = JSON.parse(read(path_json, String))
        jo2 = JSON.parse(JSON.json(state, 4))
        delete!(jo1.graph, "__v12ViewportLatexStash")
        for expression in jo1.expressions.list
            if "columns" in keys(expression)
                for column in expression.columns
                    delete!(column, "__stashed_V12PointStyle")
                end
            end
        end
        @test jo2 == jo1
    end
end
