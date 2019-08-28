using CSV, Query
include("util.jl")

#Read and filter ASCII
    # 1 element filtered
    symbaSkills = CSV.read("./data/original/symbasyncSkills.csv")
    symbaSkills = symbaSkills |> @filter(isascii(_.text)) |> DataFrame
    
    # 3 elements filtered 
    filteredSample = CSV.read("./data/processedData/1_SampleInLinkedin.csv")
    filteredSample = filteredSample |> @filter(isascii(_.text)) |> DataFrame


function addMatches()
    n = size(filteredSample)[1]
    count = 0
    function findSimilarRank(skillName::String, boundary=0.7)::Array{Dict{String,Any}}

        matches = []
        count += 1
        for symbaSkill in eachrow(symbaSkills)
            println("$count/$n  comparing $skillName with $(symbaSkill.text)")
            similarMeasure = similarity(skillName, symbaSkill.text);
            if similarMeasure >= boundary
                push!(matches,Dict("_id"=> symbaSkill._id,
                                "text"=> symbaSkill.text,
                                "measure"=> similarMeasure))  
            end
        end
        return matches
    end

    filteredSample[!, :matches] = map( (name) -> findSimilarRank(name), filteredSample[:, :text] )
end
