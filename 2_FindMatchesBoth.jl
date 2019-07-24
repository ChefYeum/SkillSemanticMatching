using CSV, DataFrames
include("util.jl")

function compareSets(sampleSet::Array{String},targetSet::Array{String}; printLog=false, threshold=0.7)::Array{Array{Tuple{String,Float32}}}
    n = length(sampleSet)
    output::Array{Array{Tuple{String,Float32}}} = []
    for (i, skill) in enumerate(sampleSet)
        if printLog
            println("$i/$n: Comparing $skill with all target skills")
        end 
        mapSim = map(target -> (target,similarity(skill,target)), targetSet)
        
        push!(output, filter(x -> (x[2] > threshold), sort(mapSim, by= t -> t[2], rev=true)))
    end 
    return output
end 

function main()
    symbaSkills = linesToArr("data/SymbaSyncSkills",asciiOnly=true)
    sampleSkills = linesToArr("data/sampleSkills", asciiOnly=true)
    linkedinSkills = linesToArr("data/all_linked_skills.txt", asciiOnly=true)

    dfSkills = DataFrame(skillName = sampleSkills)
    dfSkills[:simLinked] = compareSets(sampleSkills,linkedinSkills, printLog=true)  
    dfSkills[:simSymba] = compareSets(sampleSkills,linkedinSkills, printLog=true) 

    CSV.write("2_FindMatchesBoth.csv", dfSkills)
end 
