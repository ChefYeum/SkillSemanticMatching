function editDistance(s1::String, s2::String)
    s1 = lowercase(s1)
    s2 = lowercase(s2)
    dpMatrix = Array{Int64}(undef, length(s1)+1, length(s2)+1)

    dpMatrix[1, :] = collect(0:length(s2))
    dpMatrix[:, 1] = collect(0:length(s1))
    
    for i = 2:length(s1)+1, j = 2:length(s2)+1
        subtitutionCost = (s1[i-1] == s2[j-1] ? 0 : 1) 
        dpMatrix[i,j] = min(dpMatrix[i-1,j] + 1,
                            dpMatrix[i,j-1] + 1,
                            dpMatrix[i-1,j-1] + subtitutionCost)
    end 

    return dpMatrix[end,end]
end 

function similarity(s1::String, s2::String)::Float32
    short, long = sort([s1,s2], by=(x->length(x)))    
    if length(long) == 0
        return 1
    else
        return (length(long) - editDistance(long,short))/length(long) 
    end 
end

# Function to read line-separated strings and convert them all to lowercase 
function linesToArr(path)::Array
    f = open(path, "r")
    arr = readlines(f)
    arr = map( (w) -> lowercase(w), arr)
    close(f)
    return arr
end

function filterAsciiStrings(words::Array{String})::Array{String}
    return filter( (w) -> isascii(w), words)
end 

function parseStrEntry(entry::String)
    return eval(Meta.parse(entry))
end 
