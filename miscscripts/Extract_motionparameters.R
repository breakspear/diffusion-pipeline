#!/usr/bin/env Rscript

args = commandArgs(TRUE)


DATADIR=as.character(args[1])
OUTDIR=as.character(args[2])
OUTprefix=as.character(args[3])

#nvols<-102

#Find subjects to extract movement parameters
subjIDs<-list.dirs(path = DATADIR, full.names = FALSE, recursive = FALSE)
subjIDs<-t(subjIDs)
subjIDs<-as.character(subjIDs)


FDall=NULL
meanFDall=NULL

#Loop through subjects
for(i in 1:length(subjIDs))
{
  subjDATADir<-paste(DATADIR,subjIDs[i],"preproc",sep="/")
 
  eddyfoldmatch<-list.files(path = subjDATADir, pattern="preproc", include.dirs = TRUE)
  
  #Use RMS version
  FDfile=paste(subjDATADir, eddyfoldmatch, "dwi_post_eddy.eddy_movement_rms", sep="/")
  
  
  #Check that file does exist!
  if (file.exists(FDfile)) {
  
  FD=read.table(FDfile,header=FALSE)
    
  FDvals<-FD$V2

  #Calculate mean
  meanFDval<-mean(FDvals)
    
  
  #Cobmine all individuals together
  meanFDout=c(subjIDs[i],meanFDval)
  meanFDall=rbind(meanFDall,meanFDout)
  
  }
}

meanFDall=data.frame(meanFDall,stringsAsFactors=F)
names(meanFDall)=c("BAR","meanRMS")


#Write output
meanFDfname.out=paste(OUTDIR,paste("subjs_",OUTprefix,"_wRMS.dat",sep=""),sep="/")
write.table(meanFDall,file=meanFDfname.out,row.names=F,col.names=T,sep="\t",quote=F)

#Done
