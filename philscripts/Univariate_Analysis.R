#!/usr/bin/env Rscript

fname.in="/working/lab_michaebr/alistaiP/Park/analysis/Patients_trackconnectivity.dat"
Baseoutput="CONvars"
OUTDIR="/working/lab_michaebr/alistaiP/Park/analysis"
dat=read.table(fname.in,header=T,stringsAsFactors=F,sep="\t")

indvars=cbind("Age","Sex","Clinical_Subtype","Tremor.Akinesia_Subtype","Hoehn_._Yahr_Stage","Years_Since_Diagnosis","Side_of_Onset","Pre_LEDD","Pre_BIS_Total","Pre_EQ_Total","Pre_ICD_Total","Pre_QUIP.Total","Pre_CarerBIS_Total","Pre_CarerEQ_Total","LN_HaylingCatAErrors","LN_HaylingCatBErrors","LN_HaylingABErrorScore","LN_ELF_RuleViolations","LN_DelayDiscount_K")
tracksint=cbind("RSTNtoHCPRSMA","LSTNtoHCPLSMA")

DVs=NULL
for(i in 1:length(tracksint))
{
DVmatch<-grep(tracksint[i], names(Patients_trackconnectivity), value=TRUE)
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

for(i in seq(1,length(cvars)))
{
for(j in seq(1,length(DVs)))
{
id=which(allvars==DVs[j]))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)
}
}

regvars=c("Inter",attr(out$terms,"term.labels"))

outall=data.frame(outall,stringsAsFactors=F)
names(outall)=c("Var","Mean","SD",paste("beta",regvars,sep="."),paste("SE",regvars,sep="."),paste("Pvals",regvars,sep="."))

write.table(outall,file=paste(OUTDIR,Baseoutput,"_",mprms[,j],".csv",sep=""),row.names=F,col.names=T,sep=",",quote=F)
}