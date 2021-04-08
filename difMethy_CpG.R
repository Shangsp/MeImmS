setwd("F:\\Data")
mydata <- read.table("beta.txt",header=T,sep='\t',check.names=F,row.names=1)
mygroup <- read.table("allsamplegroup.txt",header=T,sep='\t',check.names=F,row.names=1)

result <- matrix(,dim(mydata)[1],6)

case <- rownames(mygroup)[which(mygroup[,3]=="responder")]
control <- rownames(mygroup)[which(mygroup[,3]=="nonresponder")]

for (i in 1:dim(mydata)[1]){
  result[i,2] <- mean(as.numeric(mydata[i,case]))
  result[i,3] <- mean(as.numeric(mydata[i,control]))
  result[i,5] <- t.test(mydata[i,case],mydata[i,control])$p.value
}
result[,4] <- result[,3]-result[,2]
result[,6] <- p.adjust(result[,5],method="fdr")

#length(which(abs(result[,4])>0.15 & result[,6]<0.05))
result[,1] <- rownames(mydata)
colnames(result) <- c("CpG","Case","Control","diffMethy","pvalue","FDR")
write.table(result,"TtestResult.txt",sep=""),sep='\t',quote=F,row.names=F)
