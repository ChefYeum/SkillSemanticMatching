using CSV, Query, JSON
include("util.jl")

#Read and filter ASCII
# 1 element filtered
symbaSkills = CSV.read("./data/original/symbasyncSkills.csv")
symbaSkills = symbaSkills |> @filter(isascii(_.text)) |> DataFrame

# 3 elements filtered 
filteredSample = CSV.read("./data/processedData/1_SampleInLinkedin.csv")
filteredSample = filteredSample |> @filter(isascii(_.text)) |> DataFrame

open("./data/processedData/skillTree.json","r") do f
    global skillTree
    skillTree = JSON.parse(read(f, String))
end 

function addTreeTrace()
    count = 0
    total = size(symbaSkills)[1]

    function searchTrace(targetID::String, tree)::String
        function findNodeWithID(id::String, node)
            if node["_id"] == targetID 
                return node["text"]
            elseif node["children"] == []
                return ""
            else
                for child in node["children"]
                    result = findNodeWithID(targetID, child)
                    if result == ""
                        continue
                    else
                        return "$(node["text"]) > $result"  
                    end 
                end 
                # otherwise - No children matching the id
                return ""
            end 
        end 
        
        for root in tree["roots"]
            res = findNodeWithID(targetID, root) 
            if res == ""
                continue
            else
                return res 
            end
        end 
        
        # otherwise - no roots have the node with matching id 
        return ""
    end 

    symbaSkills[:, :treeTrace] = map( (id) -> searchTrace(id, skillTree), symbaSkills[:, 1])
    println("Done")
    
    # manually add last trace (but why)
    symbaSkills[1629,4] = searchTrace("58fbd6800de1ee000f1c6d59",skillTree)

    return true
end 


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
                                "measure"=> similarMeasure,
                                "treeTrace"=> symbaSkill.treeTrace))  
            end
        end
        return matches
    end

    filteredSample[!, :matches] = map( (name) -> findSimilarRank(name), filteredSample[:, :text] )
end

writejson("./data/processedData/2_FindSampleMatches.json", symbaSkills)
