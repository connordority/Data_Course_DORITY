# (4) List all .csv files in the Data/ directory (non-recursive)
csv_files <- list.files(
  path = "Data",
  pattern = "\\.csv$",
  full.names = TRUE
)

# (5) Count how many .csv files match
length(csv_files)

# (6) Read wingspan_vs_mass.csv into an object called df
df <- read.csv("Data/wingspan_vs_mass.csv")

getwd()
setwd(/Users/connordority/Desktop/Data_Course_DORITY)
setwd("/Users/connordority/Desktop/Data_Course_DORITY")
getwd()

list.files()
list.files("Data")

csv_files <- list.files("Data", pattern = "\\.csv$", full.names = TRUE)
length(csv_files)
df <- read.csv("Data/wingspan_vs_mass.csv")
head(df, 5)

b_files <- list.files("Data", pattern = "^b", recursive = TRUE, full.names = TRUE)
b_files

for (f in b_files) {
  cat("\n---", f, "---\n")
  cat(readLines(f, n = 1), "\n")
}

all_csv_recursive <- list.files("Data", pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)
for (f in all_csv_recursive) {
  cat("\n---", f, "---\n")
  cat(readLines(f, n = 1), "\n")
}
