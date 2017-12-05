#!/usr/bin/env Rscript


args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}
print(args)

#DATADIR="/mnt/lustre/working/lab_michaebr/alistaiP/Park/Diff"
DATADIR=as.character(args[1])

if (length(args)==2) {
preextdata<-as.character(args[2])
}

SubjIDs<-list.dirs(path = DATADIR, full.names = FALSE, recursive = FALSE)
SubjIDs<-t(SubjIDs)
SubjIDs<-as.character(SubjIDs)

egsubject<-SubjIDs[1]
convars=cbind("meanFA","meanMD","AFD")

convarstrings = NULL
for(i in 1:length(convars))
{
  varmatch<-list.files(path = paste(DATADIR,egsubject,sep="/"), pattern=paste(convars[i],".txt",sep=""))
  convarstrings=c(convarstrings,varmatch)
}

varnames<-gsub(pattern = "\\.txt$", "", convarstrings)

xall=NULL

for(i in 1:length(SubjIDs))
{

SubjDir<-paste(DATADIR,SubjIDs[i],sep="/")
  
xx=NULL
for(j in 1:length(convarstrings))
{
confile=paste(SubjDir, convarstrings[j], sep="/")
condata=scan(confile)
xx=c(xx,condata)
}

out=c(SubjIDs[i],xx)
xall=rbind(xall,out)

}

xall=data.frame(xall,stringsAsFactors=F)
names(xall)=c("ID",varnames)

if( exists("preextdata") {

fname.out=paste(DATADIR,"Subjs_seedconnectivity_wprexdata.dat",sep="/")
tmp=merge(preextdata,xall,by.x="ID",by.y="ID",sort=F)
write.table(tmp,file=fname.out,row.names=F,col.names=T,sep="\t",quote=F)

} else {

fname.out=paste(DATADIR,"Subjs_seedconnectivity.dat",sep="/")
write.table(xall,file=fname.out,row.names=F,col.names=T,sep="\t",quote=F)

}
