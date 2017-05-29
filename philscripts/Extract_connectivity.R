#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

ph=read.table("/mnt/lustre/working/lab_michaebr/alistair/Park/Analysis/",header=T,stringsAsFactors=T,sep=",",colClasses="character")

DATADIR=as.character(args[1])
OUTDIR=as.character(args[2])

PatientIDs<-list.dirs(path = DATADIR, full.names = FALSE, recursive = FALSE)
PatientIDs<-t(PatientIDs)

convars=cbind("meanFA","meanMD","AFD")
egsubject<-PatientIDs[1,]

convarstrings = NULL
for(i in 1:length(convars))
{
  varmatch<-list.files(path = paste(DATADIR,egsubject,sep="/"), pattern=convars[i])
  convarstrings=c(convarstrings,varmatch)
}

convarstringsnoext<-basename(convarstrings)
varnames<-convarstringsnoext

xall=NULL

for(i in 1:length(PatientIDs))
{

PatDir<-paste(DATADIR,PatientIDs[,i],sep="/")
  
xx=NULL
for(j in 1:length(convarstrings))
{
confile=paste(PatDir, convarstrings, sep="/")
condata=read.table(confile,header=FALSE)
xx=c(xx,condata)
}

out=c(PatientIDs[i],xx)
xall=rbind(xall,out)

}

xall=data.frame(xall,stringsAsFactors=F)
names(xall)=c("ID",varnames)

tmp=merge(ph,xall,by.x="ID",by.y="ID",sort=F)
fname.out=paste(OUTDIR,"Patients_trackconnectivity.dat",sep="/")
write.table(tmp,file=fname.out,row.names=F,col.names=T,sep="\t",quote=F)