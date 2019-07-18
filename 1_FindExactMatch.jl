using CSV
using DataFrames

# Function to read line-separated strings and convert them all to lowercase 
function linesToArr(path)
    f = open(path, "r")
    arr = readlines(f)
    arr = map( (w) -> lowercase(w), arr)
    close(f)
    return arr
end

# Read all skills
symbaSkills = linesToArr("data/SymbaSyncSkills")
sampleSkills = linesToArr("data/sampleSkills")
linkedinSkills =  linesToArr("data/all_linked_skills.txt")

# Construct DataFrame 
dfSkills = DataFrame(skillName = sampleSkills)
dfSkills[:exactMatch] = map((skillName) -> (skillName in symbaSkills ? true : false), sampleSkills)
dfSkills[:matches] = map((exactMatch, skillName) -> (exactMatch ? skillName : Nothing), dfSkills[:exactMatch], dfSkills[:skillName])

#Save processed data
CSV.write("1_FindExactMatch.csv", dfSkills)
