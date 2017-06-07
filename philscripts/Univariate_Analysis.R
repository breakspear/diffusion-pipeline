#!/usr/bin/env Rscript

fname.in="/beegfs/scratch/tnc_scratch/kfo_pd_connectome/PD_connectome/AFD2/analysis/Patients_trackconnectivity.dat"
Baseoutput="CONvars"
OUTDIR="/beegfs/scratch/tnc_scratch/kfo_pd_connectome/PD_connectome/AFD2/analysis"
dat=read.table(fname.in,header=T,stringsAsFactors=F,sep="\t")

indvars=cbind("age","geschlecht","disease_duration","age_onset","side_of_onset","T-Score","updrs_iii_on_gesamt","updrs_off_iii_gesamt","medication_response","disprogress","rs1800497")
tracksint=cbind("RSTNtoHCPRSMA","LSTNtoHCPLSMA","RSTNtoHCPRIFG")

DVs=NULL
for(i in 1:length(tracksint))
{
DVmatch<-grep(tracksint[i], names(dat), value=TRUE)
DVs=c(DVs,DVmatch)
}

allvars=c(indvars,DVs)
ph=subset(dat,select=allvars)

mreg=0

if(mreg==0) {
mprms=indvars
} else
{
for(i in seq(1,length(indvars)))
{
if(i==1) {
mprms=indvars[,i]
} else 
{
mprms=cbind(paste(mprms,indvars[,i],sep="+"))
}
}
}

for(j in seq(1,length(mprms)))
{

regmodel=paste('y~',mprms[,j],sep="")

outall=NULL

for(i in seq(1,length(DVs)))
{
id=which(allvars==DVs[i])
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)
}


regvars=c("Inter",attr(out$terms,"term.labels"))

outall=data.frame(outall,stringsAsFactors=F)
names(outall)=c("Var","Mean","SD",paste("beta",regvars,sep="."),paste("SE",regvars,sep="."),paste("Pvals",regvars,sep="."))

OUTBASE=paste(OUTDIR,Baseoutput,sep="/")
write.table(outall,file=paste(OUTBASE,"_",mprms[,j],".csv",sep=""),row.names=F,col.names=T,sep=",",quote=F)
}
