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
# but according to the instructions there should be 19.

# Setting the working directory of R session the iods project folder and saving the file to folder Data

setwd("~/R/IODS-course/IODS-project/Data")

# Saving the analysis dataset

write.table(human, file = "human.txt", sep = ",", col.names = TRUE, row.names = FALSE)
human_created <- read.table("human.txt", sep = ",", header = TRUE) 
str(human_created) # 195 obs. of  17 variables, works fine
 







# Johanna Koskivuori, 18112020, Exercise 5 data wrangling continues

# More information about the data is in: http://hdr.undp.org/en/content/human-development-index-hdi

human1 <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep=",", header=TRUE)

str(human1) #195 obs. of  19 variables
dim(human1)#195 rows and 19 columns
colnames(human1)
#[1] "HDI.Rank"       "Country"        "HDI"            "Life.Exp"       "Edu.Exp"        "Edu.Mean"      
#[7] "GNI"            "GNI.Minus.Rank" "GII.Rank"       "GII"            "Mat.Mor"        "Ado.Birth"     
#[13] "Parli.F"        "Edu2.F"         "Edu2.M"         "Labo.F"         "Labo.M"         "Edu2.FM"       
#[19] "Labo.FM"

#Here are the explanations for variable names which have been shortened:

#"Country" = Country name

# Health and knowledge

#"GNI" = Gross National Income per capita
#"Life.Exp" = Life expectancy at birth
#"Edu.Exp" = Expected years of schooling 
#"Mat.Mor" = Maternal mortality ratio
#"Ado.Birth" = Adolescent birth rate

# Empowerment

#"Parli.F" = Percetange of female representatives in parliament
#"Edu2.F" = Proportion of females with at least secondary education
#"Edu2.M" = Proportion of males with at least secondary education
#"Labo.F" = Proportion of females in the labour force
#"Labo.M" " Proportion of males in the labour force

#"Edu2.FM" = Edu2.F / Edu2.M
#"Labo.FM" = Labo2.F / Labo2.M


library(stringr)

# removing the commas from GNI and create a numeric version of it
human1 <- mutate(human1, GNI=str_replace(GNI, pattern=",", replace =""))
str(human1)
human1$GNI <- as.numeric(human1$GNI)

# Excluding unneeded variables, columns to keep are:
keep <- c("Country", "Edu2.FM", "Labo.FM",  "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# selecting the 'keep' columns
human1 <- select(human1, one_of(keep))

# printing out a completeness indicator of the 'human1' data
complete.cases(human1)

# printing out the data along with a completeness indicator as the last column
data.frame(human1[-1], comp = complete.cases(human1))

# filtering out all rows with missing (NA) values
human2 <- filter(human1, complete.cases(human1) == TRUE)
str(human2)#162 obs. of  9 variables

#Removing the observations which relate to regions instead of countries

# looking at the last 10 observations of human2
tail(human2, 10) #7 regions in the end

# defining the last indice we want to keep
last <- nrow(human2) - 7

# choosing everything until the last 7 observations
human3 <- human2[1:155, ]

# adding countries as rownames
rownames(human3) <- human3$Country
tail(human3)

# removing the Country variable from the data
human3 <- select(human3, -Country)
colnames(human3)
str(human3)#155 obs. of  8 variables

setwd("~/R/IODS-course/IODS-project/Data")

# Saving the analysis dataset with rownames

write.table(human3, file = "human.txt", sep = ",", col.names = TRUE, row.names = TRUE)
human_created2 <- read.table("human.txt", sep = ",", header = TRUE) 
str(human_created2) # 155 obs. of  8 variables, works fine


