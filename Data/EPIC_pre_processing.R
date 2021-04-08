library("ChAMP")
#Load EPIC Data：
myLoad <- champ.import("F:/Methy/AllRAW",arraytype="EPIC")
myNorm <- champ.norm(beta=myLoad$beta,arraytype="EPIC",method="BMIQ",cores=5)
ann850k <- getAnnotation(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)
head(ann850k)

library(minfi)
targets <- read.metharray.sheet("F:/Methy/AllRAW",pattern="SampleSheet.csv")
rgSet<- read.metharray.exp(targets = targets,force = TRUE)
targets$ID <- paste(targets$Sample_Group,targets$Sample_Name,sep=".")
sampleNames(rgSet) <- targets$ID
rgSet

detP <- detectionP(rgSet)
head(detP)

detP <- detP[match(featureNames(mSetSq),rownames(detP)),] 
keep <- rowSums(detP < 0.01) == ncol(mSetSq) #Probes with a P value less than 0.01 are counted
table(keep) 
mSetSqFlt <- mSetSq[keep,] #Probes with P values less than 0.01 in all samples were retained
mSetSqFlt

keep <- !(featureNames(mSetSqFlt) %in% ann850k$Name[ann850k$chr %in% c("chrX","chrY")])
table(keep)
mSetSqFlt <- mSetSqFlt[keep,]

#SNP
mSetSqFlt <- dropLociWithSnps(mSetSqFlt)
mSetSqFlt

targets <- read.metharray.sheet("F:/Methy/AllRAW", pattern="SampleSheet.csv")
targets
mSetSqFlt <- dropLociWithSnps(mSetSqFlt)
mSetSqFlt

library(maxprobes)
xloci <- maxprobes::xreactive_probes(array_type = "EPIC")
mSetSqFlt <- maxprobes::dropXreactiveLoci(mSetSqFlt)

bVals <- getBeta(mSetSqFlt)
head(bVals[,1:5])
write.table(bVals,"beta.txt",quote=F,sep='\t')
