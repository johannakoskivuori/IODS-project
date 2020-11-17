# Johanna Koskivuori, 17112020, Exercise 4 data wrangling for the next week’s data 

#More information regarding the data can be found from the links: http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf)
#http://hdr.undp.org/en/content/human-development-index-hdi

#reading the data

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Exploring the datasets

str(hd)#195 obs. of  8 variables
dim(hd)#195 rows and 8 columns
summary(hd)
colnames(hd)#"HDI.Rank"                               "Country"                               
           # "Human.Development.Index..HDI."          "Life.Expectancy.at.Birth"              
           # "Expected.Years.of.Education"            "Mean.Years.of.Education"               
           # "Gross.National.Income..GNI..per.Capita" "GNI.per.Capita.Rank.Minus.HDI.Rank"    

str(gii)#195 obs. of  10 variables
dim(gii)#195 rows and 10 columns
summary(gii)
colnames(gii)# "GII.Rank"                                     "Country"                                     
            # "Gender.Inequality.Index..GII."                "Maternal.Mortality.Ratio"                    
            # "Adolescent.Birth.Rate"                        "Percent.Representation.in.Parliament"        
            # "Population.with.Secondary.Education..Female." "Population.with.Secondary.Education..Male."  
            # "Labour.Force.Participation.Rate..Female."     "Labour.Force.Participation.Rate..Male."  

#Renaming the variables with shorter and descriptive names

colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[6] <- "Edu.Mean"
colnames(hd)[7] <- "GNI"
colnames(hd)[8] <- "GNI-HDI"


colnames(gii)[3] <- "GII"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.Rep"
colnames(gii)[7] <- "Edu2.F"
colnames(gii)[8] <- "Edu2.M"
colnames(gii)[9] <- "Labo.F"
colnames(gii)[10] <- "Labo.M"

colnames(hd) #checking the chenges
colnames(gii)

#Mutate the “Gender inequality” data and create two new variables. 

# defining a new column Edu2.FM by dividing Edu2.F / Edu2.M 
Edu2.FM <- mutate(gii, Edu2.FM = (Edu2.F / Edu2.M))

# defining a new column Labo.FM by dividing Labo2.F / Labo2.M 
Labo.FM <- mutate(gii, Labo.FM = (Labo.F / Labo.M))

#Joining together the two datasets using the variable Country as the identifier. 

# Country used as identifier
join_by <- c("Country")

# joining the two datasets by the selected identifier
human <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii"))

colnames(human)
glimpse(human) # 195 rows of observations and 17 columns of variables, for some reason I get only 17 variables 
# but according to the instructions there should be 19, what went wrong? Am I missing those variables that I created?

# Setting the working directory of R session the iods project folder and saving the file to folder Data

setwd("~/R/IODS-course/IODS-project/Data")

# Saving the analysis dataset

write.table(human, file = "human.txt", sep = ",", col.names = TRUE, row.names = FALSE)
human_created <- read.table("human.txt", sep = ",", header = TRUE) 
str(human_created) # 195 obs. of  17 variables, works fine
 
