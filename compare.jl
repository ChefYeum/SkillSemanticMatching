=
using CSV
using DataFrames

# Function to read 
function linesToArr(path)
    f = open(path, "r")
    arr = readlines(f)
    arr = map( (w) -> lowercase(w), arr)
    close(f)
    return arr
end

# Read all skills
symbaSkills = linesToArr("SymbaSyncSkills")
sampleSkills = linesToArr("sampleSkills")
linkedinSkills =  linesToArr("all_linked_skills.txt")

# Construct DataFrame 
dfSkills = DataFrame(skillName = sampleSkills)
dfSkills[:exactMatch] = map((skillName) -> (skillName in symbaSkills ? true : false), sampleSkills)
dfSkills[:matches] = map((exactMatch, skillName) -> (exactMatch ? skillName : "findClosest"), dfSkills[:exactMatch], dfSkills[:skillName])

CSV.write("test.csv")

#=
function levendist(s::AbstractString, t::AbstractString)
    ls, lt = length.((s, t))
    ls == 0 && return lt
    lt == 0 && return ls
 
    s₁, t₁ = s[2:end], t[2:end]
    ld₁ = levendist(s₁, t₁)
    s[1] == t[1] ? ld₁ : 1 + min(ld₁, levendist(s, t₁), levendist(s₁, t))
end
=#
