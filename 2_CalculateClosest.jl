# using CSV
#=
function levendist(s::AbstractString, t::AbstractString)
    ls, lt = length.((s, t))
    ls == 0 && return lt
    lt == 0 && return ls
 
    s₁, t₁ = s[2:end], t[2:end]
    ld₁ = levendist(s₁, t₁)
    s[1] == t[1] ? ld₁ : 1 + min(ld₁, levendist(s, t₁), levendist(s₁, t))
end

function lev(i::Int64, j::Int64)
    if min(i,j)== 0
        return max(i,j)
    else
        return min(lev(i-1,j)+1, lev(i,j-1)+1, lev(i-1, j-1)+(a==b ? 0 : 1)) 
    end 
end 
=#

function editDistance(s1::String, s2::String)
    dpMatrix = Array{Int64}(undef, length(s1)+1, length(s2)+1)
    

    dpMatrix[1, :] = collect(0:length(s2))
    dpMatrix[:, 1] = collect(0:length(s1))
    
    for i = 2:length(s1)+1, j = 2:length(s2)+1
        subtitutionCost = (s1[i-1] == s2[j-1] ? 0 : 1) 
        dpMatrix[i,j] = min(dpMatrix[i-1,j] + 1,
                            dpMatrix[i,j-1] + 1,
                            dpMatrix[i-1,j-1] + subtitutionCost)
                            
    end 
    display(dpMatrix)
    println()
    return dpMatrix[end,end]
end 

#Function test
println(editDistance("peter","potter"))

# f = CSV.read("1_FindExactMatch.csv")

