library(dplyr)
## Load the data sets
file <- 'C:/Users/Sukumar/Documents/New folder/Getting-and-Cleaning-Data/UCI HAR Dataset'
Train_X <- read.table(paste(file,"/train/X_train.txt",sep = ""))
Test_X <- read.table(paste(file,"/test/X_test.txt",sep = ""))
Train_y <- read.table(paste(file,"/train/y_train.txt",sep = ""))
Test_y <- read.table(paste(file,"/test/y_test.txt",sep = ""))
Subject_train <- read.table(paste(file,"/train/subject_train.txt",sep = ""))
Subject_test <-  read.table(paste(file,"/test/subject_test.txt",sep = ""))
Features <- read.table(paste(file,"/features.txt", sep = ""))
Activity_lables <- read.table(paste(file,"/activity_labels.txt", sep = ""))

# Assigning Names
names(Train_X) <- Features[,2]
names(Test_X) <- Features[,2]
names(Activity_lables) <- c('ActivityNo.','ActivityLabels')
names(Train_y) <- c('ActivityNo.')
names(Test_y) <- c('ActivityNo.')
names(Subject_train) <-  c('Subject')
names(Subject_test) <-  c('Subject')

#
Train_X <- select(Train_X, ends_with('mean()'), ends_with('std()'))
Train_X <- select(Train_X, sort(names(Train_X)))
Test_X <- select(Test_X, ends_with('mean()'), ends_with('std()'))
Test_X <- select(Test_X, sort(names(Test_X)))
Train <- cbind(Train_y, Train_X)
Train <- cbind(Subject_train, Train)
Test <- cbind(Test_y, Test_X)
Test <- cbind(Subject_test, Test)

complete_DF <- rbind(Train,Test) %>% merge(Activity_lables,by = 'ActivityNo.') %>%
  select(Subject, ActivityLabels, everything(),-c('ActivityNo.'))

newDF <- complete_DF %>% group_by(Subject, ActivityLabels) %>% summarize_all(mean)

if ( file.exists("means.cs") ) {
  file.remove("means.csv")
  file.remove("maens.txt")
}

write.csv(newDF, file="means.csv")
write.table(newDF, file="means.txt",row.names=FALSE)
