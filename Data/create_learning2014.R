# Johanna Koskivuori, 02112020, R script for data wrangling in RStudio excercise 2.
# More information about the data you can find : https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt 

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
str(learning2014) #183 obs. of  60 variables
dim(learning2014) # rows 183, columns 60

install.packages("dplyr")
library(dplyr) # useful library for data wrangling

keep_columns <- c("gender","Age","Attitude", "deep", "Stra", "Surf", "Points") #variables gender, age, attitude, deep, stra, surf and points
analysis_dataset <- select(learning2014, one_of(keep_columns)) # don´t know what to do: Warning message:
# Unknown columns: `deep`, `Stra`, `Surf` 

