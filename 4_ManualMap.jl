using CSV, Query, DataFrames

linkedMatch = CSV.read("data/processed/3_linkedMatch.csv") 
linkedMatch.simSymba = map(x -> eval(Meta.parse(x)), linkedMatch.simSymba)
linkedMatch.simLinked = map(x -> eval(Meta.parse(x)), linkedMatch.simLinked)


