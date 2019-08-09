# TODO: Find all duplicates in tree
# TODO: Count all non-leaf matches

using CSV, JSON

tree = open("./data/processed/json/skillTree.json") do file
    read(file, String)
end 

parsed = JSON.parse(tree)

println(parsed)

isLeaf = (x::Dict) -> x["children"] == [] 
