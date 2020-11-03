# Johanna Koskivuori, 02112020, R script for data wrangling in RStudio excercise 2.
# More information about the data you can find : https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt 

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
str(learning2014) #183 obs. of  60 variables
dim(learning2014) # rows 183, columns 60

install.packages("dplyr")
library(dplyr) # useful library for data wrangling


#creating variables deep, stra, surf

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)
learning2014$deep 

strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)
learning2014$stra

surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)
learning2014$surf

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points") #creating new data frame
analysis_dataset <- select(learning2014, one_of(keep_columns)) 
str(analysis_dataset)

# Renaming Age, Attitude and Points

colnames(analysis_dataset)
colnames(analysis_dataset)[2] <- "age"
colnames(analysis_dataset)[3] <- "attitude"
colnames(analysis_dataset)[7] <- "points"
colnames(analysis_dataset) # see if everything looks good

#Scaling variable attitude
analysis_dataset$attitude / 10
analysis_dataset$attitude <- c(analysis_dataset$attitude)/10
analysis_dataset$attitude

# Exclude observations where the exam points variable is zero

analysis_dataset <- filter(analysis_dataset, points > 0)
analysis_dataset$points # no zeros 

str(analysis_dataset) #166 obs. of  7 variables


# Setting the working directory of R session the iods project folder and saving the file to folder Data

setwd("~/R/IODS-course/IODS-project/Data")

# Saving the analysis dataset

write.table(analysis_dataset, file = "learning2014.txt", sep = ",", col.names = TRUE, row.names = FALSE)
lrn2014 <- read.table("learning2014.txt", sep = ",", header = TRUE) 
str(lrn2014) # works fine, 166 obs. of  7 variables
head(lrn2014) # gender age attitude     deep  stra     surf points
