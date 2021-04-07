mydata <- read.table("TCGA-LUADImmuneCpG.txt",header=T,sep='\t',row.names=1,check.names=F)
Index <- matrix(c(-1.294262184,3.635904251,-8.292024134,-2.91174055,3.531247878,3.140560799,-2.197098862,2.749402652,-0.372025813),9,1)
rownames(Index) <- c("Intercept","cg01996116","cg02774935","cg05468843","cg10120555","cg11164145","cg18604939","cg19475870","cg27315958")
if (length(intersect(rownames(mydata),rownames(Index)[2:9]))!=8){
  print("Missing key CpG site!");
}else{
score <- colSums(mydata[rownames(Index)[2:9],]*as.numeric(Index[2:9,1]))+Index [1,1]
MeImmS <- as.matrix(score)
}
write.table(MeImmS,"MethyScore.txt",quote=F,sep='\t')