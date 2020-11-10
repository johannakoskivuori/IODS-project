# Johanna Koskivuori, 09112020, Exercise 3 Logistic regression data wrangling 

#(two different ways of doing data wrangling)

# Data was loaded from https://archive.ics.uci.edu/ml/machine-learning-databases/00320/ (student.zip file)
# More information can be found from https://archive.ics.uci.edu/ml/datasets/Student+Performance 

#Data camp way of doing data wrangling

math <- read.csv("student-mat.csv",sep = ";", header = TRUE)
str(math) # 395 obs. of  33 variable
dim(math) # 395 rows and 33 columns

por <- read.csv("student-por.csv", sep = ";", header = TRUE)
str(por) # 649 obs. of  33 variables
dim(por) # 649 rows and 33 columns 

#Join the two data sets using the variables "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" as (student) identifiers. 
#Keep only the students present in both data sets. Explore the structure and dimensions of the joined data. (1 point)

library(dplyr) # Librarry for data wrangling

#Joining two datasets math and por together using the variables in join_by

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))
str(math_por) # 382 obs. of  53 variables
dim(math_por) # 382 rows and  53 columns

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining
for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name)) # select two columns from 'math_por' with the same original name
   first_column <- select(two_columns, 1)[[1]] # select the first column vector of those two columns
  
  # if that first column  vector is numeric
  if(is.numeric(first_column)) { # take a rounded average of each row of the two columns and
    alc[column_name] <- round(rowMeans(two_columns))  # add the resulting vector to the alc data frame
  } else { # else if it's not numeric
    alc[column_name] <- first_column # add the first column vector to the alc data frame
  }
}

# defining a new column alc_use by combining weekday and weekend alcohol use and creating high_use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

# glimpse at the new combined data
glimpse(alc) # Rows: 382 and Columns: 35

# Setting the working directory of R session the iods project folder and saving the file to folder Data

setwd("~/R/IODS-course/IODS-project/Data")

# Saving the analysis dataset

write.table(alc, file = "alc.txt", sep = ",", col.names = TRUE, row.names = FALSE)
alc_created <- read.table("alc.txt", sep = ",", header = TRUE) 
str(alc_created) # 382 obs. of  33 variables, works fine

#The other way of doing the data wrangling based on Reijo Sund´s example

# Defining own id for both datasets

por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combining datasets to one long data

#   NOTE! There are 370 students that belong to both datasets
#         Original joining/merging example is erroneous! (382 students)

pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Removing lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be successful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculating other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number() )

# Saving the analysis dataset

write.table(pormath, file = "pormath.txt", sep = ",", col.names = TRUE, row.names = FALSE)
pormath_created <- read.table("pormath.txt", sep = ",", header = TRUE) 
str(pormath_created) # 370 obs. of  51 variables, works fine



