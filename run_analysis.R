run_analysis <- function(){
    #The dplyr library is needed for the execution of the function, first we load it.
    library(dplyr)
    
    #Load TRAIN files
    
    x_train <- "UCI HAR Dataset/train/X_train.txt"
    data_train <- read.csv(x_train, header = FALSE, sep = "",dec = ".")
    
    y_train <- "UCI HAR Dataset/train/y_train.txt"
    activity <- read.csv(y_train, header = FALSE, sep = "",dec = ".")
    
    subject_train <- "UCI HAR Dataset/train/subject_train.txt"
    Subject <- read.csv(subject_train, header = FALSE, sep = "",dec = ".")
    
    #Load features names file
    
    features_file <- "UCI HAR Dataset/features.txt"
    Features <- read.csv(features_file, header = FALSE, sep = "",dec = ".")
    
    #Asign the name of the feature to the column of the data frame
    columnames <- t(Features[2])
    colnames(data_train) <- columnames
    
    #Delete problematic columns thas has duplicate names
    data_train <- data_train %>% subset(select = unique(names(.)))
    
    #Select the mean and std columns from the original file
    data_train <- select(data_train, contains("-mean()"),contains("-std()"))
    
    #Transform the activity from numbers to descriptions
    
    ActivityNames<-NULL
    for(i in 1:nrow(activity)){
        if (activity[i,1] == 1){
            ActivityNames[i] <- "WALKING"   
        }else if (activity[i,1] == 2){
            ActivityNames[i] <- "WALKING_UPSTAIRS" 
        }else if (activity[i,1] == 3){
            ActivityNames[i] <- "WALKING_DOWNSTAIRS" 
        }else if (activity[i,1] == 4){
            ActivityNames[i] <- "SITTING" 
        }else if (activity[i,1] == 5){
            ActivityNames[i] <- "STANDING" 
        }else if (activity[i,1] == 6){
            ActivityNames[i] <- "LAYING" 
        }
    } 
    
    #Add columns Subject and Activity
    colnames(Subject) <- c("Subject")
    data_train <-cbind(data_train,ActivityNames)
    data_train <-cbind(data_train,Subject)
    
    #Load TEST files
    x_test <- "UCI HAR Dataset/test/X_test.txt"
    data_test <- read.csv(x_test, header = FALSE, sep = "",dec = ".")
    
    y_test <- "UCI HAR Dataset/test/y_test.txt"
    activity <- read.csv(y_test, header = FALSE, sep = "",dec = ".")
    
    subject_test <- "UCI HAR Dataset/test/subject_test.txt"
    Subject <- read.csv(subject_test, header = FALSE, sep = "",dec = ".")
    
    #Asign the name of the feature to the column of the data frame
    colnames(data_test) <- columnames
    
    #Delete problematic columns thas has duplicate names
    data_test <- data_test %>% subset(select = unique(names(.)))
    
    #Select the mean and std columns from the original file
    data_test <- select(data_test, contains("-mean()"),contains("-std()"))
    
    #Transform the activity from numbers to descriptions
    ActivityNames<-NULL
    for(i in 1:nrow(activity)){
        if (activity[i,1] == 1){
            ActivityNames[i] <- "WALKING"   
        }else if (activity[i,1] == 2){
            ActivityNames[i] <- "WALKING_UPSTAIRS" 
        }else if (activity[i,1] == 3){
            ActivityNames[i] <- "WALKING_DOWNSTAIRS" 
        }else if (activity[i,1] == 4){
            ActivityNames[i] <- "SITTING" 
        }else if (activity[i,1] == 5){
            ActivityNames[i] <- "STANDING" 
        }else if (activity[i,1] == 6){
            ActivityNames[i] <- "LAYING" 
        }
    } 
    
    #Add columns Subject and Activity
    colnames(Subject) <- c("Subject")
    data_test <-cbind(data_test,ActivityNames)
    data_test <-cbind(data_test,Subject)
    
    
    #Merge training/test files
    
    DataAll <-rbind(data_train,data_test)
    
    
    #Aggregate the dataset with the average of each variable for each activity and each subject.
    AggData <- aggregate(DataAll[,1:66],by=list(DataAll$ActivityNames,DataAll$Subject), FUN = mean,na.rm=TRUE)
    AggDataColnames <-colnames(AggData)
    AggDataColnames[1]="Activity"
    AggDataColnames[2]="Subject"
    colnames(AggData) <- AggDataColnames
    #Sorting information by Activity/Subject
    AggData<-AggData[order(AggData$Activity,AggData$Subject),]
    #Return AggData

}



