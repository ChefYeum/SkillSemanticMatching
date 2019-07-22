using CSV
using DataFrames
include("util.jl")

linkedinSkills = linesToArr("data/all_linked_skills.txt")

function mostSimilar(skillName::String)::Array{Tuple{String,Float32}}
    output = Tuple{String,Float32}[] 
    for s in linkedinSkills
        println("$skillName compared with $s")
        getSimilarity::Float32 = similarity(skillName,s) 
        if getSimilarity > 0.5
            push!(output,(s, getSimilarity))
        end
    end 
    return output
end 

# Read all skills and filter non-ASCII strings
symbaSkills = filterAsciiStrings(linesToArr("data/SymbaSyncSkills"))
sampleSkills = filterAsciiStrings(linesToArr("data/sampleSkills"))
linkedinSkills = filterAsciiStrings(linesToArr("data/all_linked_skills.txt"))

function constructDataFrame()
    dfSkills = DataFrame(skillName = sampleSkills)
    dfSkills[:exactMatch] = map((skillName) -> (skillName in symbaSkills ? true : false), sampleSkills)
    dfSkills[:matches] = Array{Tuple{String,Float32}}
    dfSkills[:matches] = map((exactMatch, skillName) -> (exactMatch ? skillName : mostSimilar(skillName)), dfSkills[:exactMatch], dfSkills[:skillName])

    #Save processed data
    CSV.write("matches.csv", dfSkills)
end 
