using CSV, Query, DataFrames
include("util.jl")

df = CSV.read("2_FindMatchesBoth.csv")
df[:simLinked] = map( x -> parseStrEntry(x), df[:simLinked])
df[:simSymba] = map( x -> parseStrEntry(x), df[:simSymba])



hopeless =  @from row in df begin
                @where row.simLinked[1][2] < 0.9 && row.simSymba[1][2] < 0.9
                @select {row.skillName, row.simLinked, row.simSymba}
                @collect DataFrame
            end
