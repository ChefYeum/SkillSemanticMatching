

import JSON

function parseJSONfile(path)
    f = open(path, "r")
    skills = map(JSON.parse, readlines(f))
    skills = map( x -> get(x,"text", 0), skills)
    close(f)
    return skills
end

function writeArrayAsLines(arr, path)
    f = open(path, "w")
    for item in arr
        write(f, item * "\n")
    end
end

arr = parseJSONfile("SymbaSyncSkills.txt")
writeArrayAsLines(arr,"SymbaSyncSkills")
