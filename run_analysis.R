library(dplyr)
#read acceleration files
test<-read.table("./UCI HAR Dataset/test/X_test.txt")
train<-read.table("./UCI HAR Dataset/train/X_train.txt")
#read label files
testlabel<-read.table("./UCI HAR Dataset/test/y_test.txt")
trainlabel<-read.table("./UCI HAR Dataset/train/y_train.txt")
#read subject files
testsubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
trainsubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
#read variable names
varname<-read.table("./UCI HAR Dataset/features.txt")
#attaching label and subject to both files
test<-mutate(test,subject=testsubject$V1,label=testlabel$V1)
train<-mutate(train,subject=trainsubject$V1,label=trainlabel$V1)
#combining both dataframes
overall<-rbind(test,train)
#rename all the variables
names(overall)<-varname$V2
names(overall)[562:563]<-c("subject","label")
#extracting mean and std columns
indx<-grep(c("mean","std"),varname$V2)
#putting subject and label in the first two columns
indx<-append(c(562,563),indx)
#filtering out mean and std values
meanstd<-overall[indx]
#sorting it by subject number and activity
meanstd<-arrange(meanstd,subject,label)
#rename the activity labels
meanstd<-mutate(meanstd,label=replace(label,label==1,"Walking"))
meanstd<-mutate(meanstd,label=replace(label,label==2,"Walking Upstairs"))
meanstd<-mutate(meanstd,label=replace(label,label==3,"Walking Downstairs"))
meanstd<-mutate(meanstd,label=replace(label,label==4,"Sitting"))
meanstd<-mutate(meanstd,label=replace(label,label==5,"Standing"))
meanstd<-mutate(meanstd,label=replace(label,label==6,"Laying"))
#establishing groups
meanstd<-group_by(meanstd,subject,label)
#creating mean values
avg<-summarise_all(meanstd,funs(mean))