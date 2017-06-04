#!/usr/bin/env Rscript

args = commandArgs(TRUE)

ph=read.table("/working/lab_michaebr/alistaiP/Park/analysis/Baseline_Data_Subjects_29-64_fixid.dat",header=T,stringsAsFactors=T,sep="\t",colClasses="character")

DATADIR=as.character("/working/lab_michaebr/alistaiP/Park/AFD/seedtracking")
#DATADIR=as.character(args[1])
OUTDIR=as.character("/working/lab_michaebr/alistaiP/Park/AFD/analysis-new")
#OUTDIR=as.character(args[2])

PatientIDs<-list.dirs(path = DATADIR, full.names = FALSE, recursive = FALSE)
PatientIDs<-t(PatientIDs)
PatientIDs<-as.character(PatientIDs)

IDs_nopre<-gsub("^.*?_","",PatientIDs)

convars=cbind("meanFA","meanMD","AFD")
egsubject<-PatientIDs[1]

convarstrings = NULL
for(i in 1:length(convars))
{
  varmatch<-list.files(path = paste(DATADIR,egsubject,sep="/"), pattern=paste(convars[i],".txt",sep=""))
  convarstrings=c(convarstrings,varmatch)
}

varnames<-gsub(pattern = "\\.txt$", "", convarstrings)

xall=NULL

for(i in 1:length(PatientIDs))
{

PatDir<-paste(DATADIR,PatientIDs[i],sep="/")
  
xx=NULL
for(j in 1:length(convarstrings))
{
confile=paste(PatDir, convarstrings[j], sep="/")
condata=scan(confile)
xx=c(xx,condata)
}

out=c(IDs_nopre[i],xx)
xall=rbind(xall,out)

}

xall=data.frame(xall,stringsAsFactors=F)
names(xall)=c("ID",varnames)

tmp=merge(ph,xall,by.x="ID",by.y="ID",sort=F)
fname.out=paste(OUTDIR,"Patients_trackconnectivity.dat",sep="/")
write.table(tmp,file=fname.out,row.names=F,col.names=T,sep="\t",quote=F)
