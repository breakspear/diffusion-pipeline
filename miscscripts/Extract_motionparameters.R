#!/usr/bin/env Rscript


if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

args = commandArgs(trailingOnly=TRUE)
print(args)

#DATADIR="/mnt/lustre/working/lab_michaebr/alistaiP/Park/Diff"
WORKDIR=as.character(args[1])
DATADIR=paste(WORKDIR,"Diff",sep="/")
#OUTDIR="/working/lab_michaebr/alistaiP/Park/analysis"
OUTDIR=paste(WORKDIR,"QC",sep="/")
dir.create(OUTDIR)


SubjIDs<-list.dirs(path = DATADIR, full.names = FALSE, recursive = FALSE)
SubjIDs<-t(SubjIDs)
SubjIDs<-as.character(SubjIDs)
#IDs_nopre<-gsub("^.*?_","",SubjIDs)

FDall=NULL
meanFDall=NULL

for(i in 1:length(SubjIDs))
{
 
    SubjDatDir<-paste(DATADIR,SubjIDs[i],"preproc",sep="/")
 
    #eddyfoldmatch<-list.files(path = SubjDatDir, pattern="dwipreproc", include.dirs = TRUE)
    
    FDfile=paste(SubjDatDir, "dwipreproc", "eddy_movement_rms", sep="/")
    
    print(FDfile)
    FD=read.table(FDfile,header=FALSE)
    
    #determine # of files - can just do from 1st subject
    if (i==1){
    nvols<-length(FD[,1])
}
  
  if(length(FD)==0) {
     meanFDval<-"NaN"
     FDvals<-matrix(, nrow = nvols, ncol = 2)
     FDvals[,]<-"NaN"
     FDout=c(SubjIDs[i],FDvals)
     FDall=rbind(FDall,FDout)
           
} else {

    FDvals<-FD$V2
    meanFDval<-mean(FDvals)
  
    FDout=c(SubjIDs[i],FDvals)
    FDall=rbind(FDall,FDout)
  
    meanFDout=c(SubjIDs[i],meanFDval)
    meanFDall=rbind(meanFDall,meanFDout)
  
}
}

meanFDall=data.frame(meanFDall,stringsAsFactors=F)
names(meanFDall)=c("ID","meanFD")

FDall=data.frame(FDall,stringsAsFactors=F)
names(FDall)=c("ID",paste("VOL",seq(1,nvols),sep=""))

#check if motion parameters are to be integrated into existing data table

tmp<-meanFDall
meanFDfname.out=paste(OUTDIR,"Subjects_meanFD.dat",sep="/")

#write output
write.table(tmp,file=meanFDfname.out,row.names=F,col.names=T,sep="\t",quote=F)

FDallfname.out=paste(OUTDIR,"Subjects_FDall.dat",sep="/")
write.table(FDall,file=FDallfname.out,row.names=F,col.names=T,sep="\t",quote=F)
