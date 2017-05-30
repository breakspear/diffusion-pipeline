#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

#ph<-{} 
ph=read.table("/working/lab_michaebr/alistaiP/Park/analysis/Patients_trackconnectivity.dat",header=T,stringsAsFactors=T,sep="\t",colClasses="character")

DATADIR=as.character(args[1])
OUTDIR=as.character(args[2])

PatientIDs<-list.dirs(path = DATADIR, full.names = FALSE, recursive = FALSE)
PatientIDs<-t(PatientIDs)
IDs_nopre<-gsub("^.*?_","",PatientIDs)

FDall=NULL
meanFDall=NULL

for(i in 1:length(PatientIDs))
{
  PatDATDir<-paste(DATADIR,PatientIDs[,i],"preproc",sep="/")
  
  if (file.exists(paste(PatDATDir,"FD.txt",sep="/"))) {
      meanFDfile=paste(PatDATDir, "meanFD.txt", sep="/")
      meanFDval=read.table(meanFDfile,header=FALSE)

      FDfile=paste(PatDATDir, "FD.txt", sep="/")
      FDvals=read.table(FDfile,header=FALSE)
    
  } else {
    eddyfoldmatch<-list.files(path = PatDATDir, pattern="preproc", include.dirs = TRUE)
    
    FDfile=paste(PatDATDir, eddyfoldmatch, dwi_post_eddy.eddy_movement_rms, sep="/")
    FD=read.table(FDfile,header=FALSE)
    
    FDvals<-FD$V2
    meanFDval<-mean(FDvals)
    
  }
  
  FDout=c(IDs_nopre[i],FDvals)
  FDall=rbind(FDall,FDout)
  
  meanFDout=c(IDs_nopre[i],meanFDval)
  meanFDall=rbind(meanFDall,meanFDout)
  
}

meanFDall=data.frame(meanFDall,stringsAsFactors=F)
names(meanFDall)=c("ID","meanFD")

FDall=data.frame(FDall,stringsAsFactors=F)
names(FDall)=c("ID",seq(1,length(FDvals)))

#check if motion parameters are to be integrated into existing data table

if(length(ph~=0)) {
tmp=merge(ph,meanFDall,by.x="ID",by.y="ID",sort=F)
datatablebase<-gsub("^.*?_","",datatablefile)
meanFDfname.out=paste(OUTDIR,paste(datatablebase,"_wFD.dat",sep=""),sep="/")
} else {
  tmp<-meanFDall
  meanFDfname.out=paste(OUTDIR,"Patients_meanFD.dat",sep="/")
}

#write output
write.table(tmp,file=meanFDfname.out,row.names=F,col.names=T,sep="\t",quote=F)

FDallfname.out=paste(OUTDIR,"Patients_FDall.dat",sep="/")
write.table(FDall,file=FDallfname.out,row.names=F,col.names=T,sep="\t",quote=F)