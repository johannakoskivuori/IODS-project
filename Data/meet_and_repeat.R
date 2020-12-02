# Johanna Koskivuori, 26112020, Exercise 6 data wrangling 


#reading the data

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = TRUE)

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = '\t', header = TRUE)

#Looking at the BPRS data
View(BPRS)
colnames(BPRS)
#[1] "treatment" "subject"   "week0"     "week1"     "week2"     "week3"     "week4"     "week5"     "week6"    
#[10] "week7"     "week8" 

str(BPRS) #40 observations of  11 variables
summary(BPRS)

#accessing libraries

library(dplyr)
library(tidyr)

#changing treatment and subject to factors

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
str(BPRS)

#Converting BPRS to long form

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extracting the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

#Looking at the table now
View(BPRSL)
glimpse(BPRSL) #Rows: 360, Columns: 5



#Looking at the RATS data
View(RATS)
colnames(RATS)#[1] "ID"    "Group" "WD1"   "WD8"   "WD15"  "WD22"  "WD29"  "WD36"  "WD43"  "WD44"  "WD50"  "WD57"  "WD64" 
str(RATS) #16 observations of  13 variables
summary(RATS)


#changing ID and Group to factors
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

glimpse(RATS)

#Converting RATS to long form

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

View(RATSL)
glimpse(RATSL) #Rows: 176, Columns: 5

# In wide form all the different measurements of different individuals are shown horizontally in a one row. 
# But in a long form, measurement one is shown first for all the individuals, all in their own rows and next is the second measurements for all individuals and so on. 
# So in the long form, the number of rows increases and the results are assigned based on the measurements/time points
# which in  these data sets are variables week and time.

# Setting the working directory of R session the iods project folder and saving the files to folder Data

setwd("~/R/IODS-course/IODS-project/Data")

# Saving the analysis datasets

write.table(BPRSL, file = "BPRSL.txt", sep = " ", col.names = TRUE, row.names = FALSE)
BPRSL_created <- read.table("BPRSL.txt", sep = " ", header = TRUE) 
View(BPRSL_created) # works fine

write.table(RATSL, file = "RATSL.txt", sep = " ", col.names = TRUE, row.names = FALSE)
RATSL_created <- read.table("RATSL.txt", sep = " ", header = TRUE) 
View(RATSL_created) # works fine



