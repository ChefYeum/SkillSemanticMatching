using CSV, Query, DataFrames
include("util.jl")

df = CSV.read("data/processed/2_FindMatchesBoth.csv")
df.simLinked = map( x -> parseStrEntry(x), df.simLinked)
df.simSymba = map( x -> parseStrEntry(x), df.simSymba)

# 267 elements: match with SSS (20 of them which are not exact matches
symbaDirectMatch =  @from row in df begin
                        @where length(row.simSymba) > 0 && row.simSymba[1][2] >= 0.9
                        @select {row.skillName,row.simSymba}
                        @collect DataFrame
                    end
symbaDirectMatch.bestSimSymba = map( row -> length(row.simSymba) > 0 ? row.simSymba[1][2] : 0.0, eachrow(symbaDirectMatch))

# 1578 elements: match with LCL but not directly matched with SSS
linkedMatch =   @from row in df begin
                    @where  !(row.skillName in symbaDirectMatch.skillName) &&
                            length(row.simLinked) > 0 &&
                            row.simLinked[1][2] > 0.9
                    @select { row.skillName, row.simLinked, row.simSymba} 
                    @collect DataFrame
                end 

# 462 elements: none of the above 
noMatch  =  @from row in df begin
                @where  !(row.skillName in symbaDirectMatch.skillName) &&
                        !(row.skillName in linkedMatch.skillName)
                @select { row.skillName }
                @collect DataFrame
            end
sort!(linkedMatch, (order(:simSymba, by=ts-> length(ts) > 0 ? ts[1][2] : 0)))
