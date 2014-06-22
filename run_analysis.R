run_analysis <-function()
{
  #Read all relevant files into dataframes
  feat<-read.table("features.txt")
  actlabels<-read.table("activity_labels.txt")
  
  subtest<-read.table("test/subject_test.txt")
  ytest<-read.table("test/y_test.txt")
  xtest<-read.table("test/x_test.txt")
  
  subtrain<-read.table("train/subject_train.txt")
  ytrain<-read.table("train/y_train.txt")
  xtrain<-read.table("train/x_train.txt")
  
  #The feature frame has the column names so transpose the dataframe before assigning it as columnnames for the X dataset
  featt<-t(feat)
  colnames(xtest)<-featt[2,]
  colnames(xtrain)<-featt[2,]
  
  #Remove special chars. Leave () as is so it is easier to search for mean() and std() later
  colnames(xtest)<-gsub("\\-","",colnames(xtest))
  colnames(xtest)<-gsub("\\,","",colnames(xtest))
  
  colnames(xtrain)<-gsub("\\-","",colnames(xtrain))
  colnames(xtrain)<-gsub("\\,","",colnames(xtrain))
  
  # Trim the columns from the X dataset so only mean() and std() remain
  xtesttrim<-xtest[,grep("mean\\(\\)|std\\(\\)",names(xtest))]
  xtraintrim<-xtrain[,grep("mean\\(\\)|std\\(\\)",names(xtrain))]
  
  # Assign descriptive columnnames to the subject and activity datasets
  colnames(actlabels)<-c("ActivityNbr","ActivityName")
  colnames(ytest)<-c("ActivityNbr")
  colnames(subtest)<-c("Subject")
  colnames(ytrain)<-c("ActivityNbr")
  colnames(subtrain)<-c("Subject")
  
  #combine all rows of the datasets but first append the columns for subject and activity to the X datasets
  comb<-rbind(cbind(subtest,ytest,xtesttrim),cbind(subtrain,ytrain,xtraintrim))
  
  #Now replace the () in mean() and std() in the complete dataset
  colnames(comb)<-gsub("\\(","",colnames(comb))
  colnames(comb)<-gsub("\\)","",colnames(comb))
  
  #use sql to determine activity label for the activities
  comb1<-sqldf("select * from comb join actlabels using (ActivityNbr) order by comb.rowid")
  
  #since the label appends at the end,reorder the columns
  #comb2 is now the final complete dataset for part 1 of the project
  
  comb2<-comb1[c(1:2,69,3:68)]
  
  #Part 2 - Melt the complete dataset by subject and activity. This creates a long dataset
  cmelt<-melt(comb,id=c("Subject","ActivityNbr"))
  
  # Now apply the mean function and cast back to a wide dataset with the averages
  ccast<-dcast(cmelt,Subject+ActivityNbr~variable,mean,na.rm=TRUE)
  
  #final cleanup of the columnnames
  colnames(ccast)<-gsub("mean","MeanAvg",names(ccast))
  colnames(ccast)<-gsub("std","StdAvg",names(ccast))
  
  #generate the tidy dataset for part 2 of the project
  write.table(Tidyfile,"Tidyfile.txt",row.names=FALSE)
  
}
