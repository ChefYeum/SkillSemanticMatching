#File depreciated; use 2_FindMatchesBoth.jl 
using CSV
using DataFrames
include("util.jl")

# Read all skills and filter non-ASCII strings
symbaSkills = filterAsciiStrings(linesToArr("data/SymbaSyncSkills"))
sampleSkills = filterAsciiStrings(linesToArr("data/sampleSkills"))
linkedinSkills = filterAsciiStrings(linesToArr("data/all_linked_skills.txt"))

global count
count = 0
noOfSample = length(sampleSkills)


function mostSimilar(skillName::String)::Array{Tuple{String,Float32}}
    global count += 1
    output = Tuple{String,Float32}[] 
    for s in linkedinSkills
        println("$count/$noOfSample : $skillName compared with $s")
        getSimilarity::Float32 = similarity(skillName,s) 
        if getSimilarity > 0.7
            push!(output,(s, getSimilarity))
        end
    end 
    return output
end 

dfSkills = DataFrame(skillName = sampleSkills)
dfSkills[:exactMatch] = map((skillName) -> (skillName in symbaSkills ? true : false), sampleSkills)
dfSkills[:matches] = Array{Tuple{String,Float32}}
dfSkills[:matches] = map((exactMatch, skillName) -> (exactMatch ? skillName : mostSimilar(skillName)), dfSkills[:exactMatch], dfSkills[:skillName])

#Sort the matches by similarity
dfSkills[:matches] = map( skill -> typeof(skill) == String ? skill : sort(skill, by=s-> s[2],rev=true), f[:matches])

#= Save processed data
CSV.write("matches_sorted.csv", dfSkills)
=#

