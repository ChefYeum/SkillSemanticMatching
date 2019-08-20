# TODO: Find all duplicates in tree
# TODO: Count all non-leaf matches

using CSV, JSON

# Read Tree
tree = open("./data/processed/json/skillTree.json") do file
    read(file, String)
end 
parsedTree = JSON.parse(tree)

# Read directly matched skills
symbaDirectMatch = open("./data/processed/3_symbaDirectMatch.csv") do file
    CSV.read(file) 
end

# Read linkedMatch too
linkedMatch = open("./data/processed/3_linkedMatch.csv") do file
    CSV.read(file) 
end

# Get all leaves
leaves = []

function getLeaves(node)
    if node["children"] == []
        push!(leaves, node["text"])
    else
        map(getLeaves, node["children"])
    end
end  

parsedTree["children"] = parsedTree["roots"] 

getLeaves(parsedTree)


# Check if skills are leaves
count = 0
for skill in copy(linkedMatch[:,1])
    if skill in leaves 
        count += 1
    else
        println("nope")
    end
end

println("Count: $count")

