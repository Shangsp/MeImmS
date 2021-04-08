###LASSO
setwd("D:\\model")
library(pROC)
library(randomForest)
library(caret)
output <- c()
for (i in 1:50){
  trainName <- createDataPartition(y=data2$group,p=0.9,list=FALSE)
  trainset <- data2[trainName,]
  testset <- data2[-trainName,]
  rf<-randomForest(group~.,trainset,ntree=1000,mtry=3)
  PredOut <- predict(rf,newdata=testset)
  output <- rbind(output,data.frame(pregroup=as.character(PredOut),group=data2[names(PredOut),130]))
}

out <- output[order(output$pregroup),]
modelroc <- roc(as.numeric(out$pregroup),as.numeric(out$group),smooth=T，grid=TRUE=F)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,auc.polygon.col="#4FC1E9",main="ROC curve")

setwd("D:\\5.ImmuneMethy\\3.model")
write.table(data2,"modelData.txt",quote=F,sep='\t')
write.table(out,"ROCData.txt",quote=F,sep='\t',row.names=F)
pdf("ROC.pdf",width=5,height=5)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,auc.polygon.col="#4FC1E9",main="ROC curve")
dev.off()

###randomForest
setwd("D:\\model")
library(pROC)
library(randomForest)
library(caret)
mydata <- read.table("modelData.txt",header=T,sep='\t',row.names=1,check.names=F)
output <- c()
for (i in 1:100){
for (j in 1:10){
  ind=sample(1:10,78,replace=TRUE,prob=rep(0.1,10))
  trainset <- mydata[which(ind!=j),]
  testset <- mydata[which(ind==j),]
  fit = randomForest(group~.,trainset,ntree=100,metry=5)
  PredOut <- predict(fit,testset)
  output <- rbind(output,data.frame(pregroup=as.character(PredOut),group=testset$group))
}
}
out <- output[order(output$pregroup),]
modelroc <- roc(as.numeric(out$pregroup),as.numeric(out$group))
plot(modelroc, print.auc=TRUE,main="ROC curve",col="#ED5565")

write.table(out,"randonForestROCData.txt",quote=F,sep='\t',row.names=F)
pdf("129CpGrandomforest_ROC.pdf",width=5,height=5)
plot(modelroc, print.auc=TRUE,main="ROC curve",col="#ED5565")
dev.off()

###SVM
output <- c()
for (i in 1:100){
for (j in 1:10){
  ind=sample(1:10,78,replace=TRUE,prob=rep(0.1,10))
  trainset <- mydata[which(ind!=j),]
  testset <- mydata[which(ind==j),]
  fit = svm(group~.,data = trainset,kernel = "linear")
  PredOut <- predict(fit,testset)
  output <- rbind(output,data.frame(pregroup=as.character(PredOut),group=testset$group))
}
}
out <- output[order(output$pregroup),]
modelroc <- roc(as.numeric(out$pregroup),as.numeric(out$group))
plot(modelroc, print.auc=TRUE,main="ROC curve",col="#ED5565")

write.table(out,"svmROCData.txt",quote=F,sep='\t',row.names=F)
pdf("129CpGsvm_ROC.pdf",width=5,height=5)
plot(modelroc, print.auc=TRUE,main="ROC curve",col="#ED5565")
dev.off()