# SkillSemanticMatching
Matching some skill names with LinkedIn skills (and a good excuse to use Julia)

No feature vectors involved, purely by comparing strings of skill name using Levenshtein distance.


## Dependencies
The following Julia packages are required to process all scripts
 - JSON.jl
 - DataFrames.jl
 - Query.jl
 - CSV.jl


# File Descriptions
## data
 - ./data/original/..
  - ...
 - ./data/processedData/1_SampleInLinkedin.csv
  - Sample filtered from 1_FindSampleInLinkedin.jl

## Scripts
 - 1_FindSampleInLinkedin.jl
  - Filter user sample for those exists in Linkedin
