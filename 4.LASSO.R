library(glmnet)
mydata <- read.table("diffCpGMatrix.txt",header=T,sep='\t',row.names=1,check.names=F)
mygroup <- read.table("allsamplegroup.txt",header=T,sep='\t',row.names=1,check.names=F)
data2 <- data.frame(t(mydata),group=mygroup[colnames(mydata),3])
dataX <- as.matrix(data2[,1:129])
dataY <- data2[,130]
cv.fit = cv.glmnet(dataX,dataY, family = "binomial",nfolds=10,type.measure="class",alpha=1)
fit <- glmnet(dataX,dataY, family = "binomial",alpha=1)

coefficients<-coef(fit,s=cv.fit$lambda.min)
Active.Index<-which(as.numeric(coefficients)!=0)
Active.coefficients<-coefficients[Active.Index]
length(Active.Index)

write.table(coefficients[Active.Index,],"CpGindex.txt",quote=F,sep='\t')
