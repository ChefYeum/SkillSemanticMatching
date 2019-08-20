using CSV
include("util.jl")

# Load data
sampleSkillArr = linesToArr("./data/original/sampleSkills")
allLinkedinSkillArr = linesToArr("./data/original/allLinkedinSkills")

# Filter data
filteredSample = filter((skillName) -> (skillName in allLinkedinSkillArr), sampleSkillArr) 

# Write file as CSV
outputDf = DataFrame()
outputDf.text = filteredSample 
CSV.write("./data/processedData/1_SampleInLinkedin.csv",outputDf)
