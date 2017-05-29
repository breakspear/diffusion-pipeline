#!/usr/bin/env Rscript

#library(epicalc)
#invnorm=function(x){x=qnorm(rank(x)/(length(x)+1));return(x)}

fname.in="noSIFT_connectomedata_CATseg_n59_invlength.dat"
Baseoutput="Summary_noSIFT_DEGSTR_catseg_invlength"
dat=read.table(fname.in,header=T,stringsAsFactors=F,sep="\t")

varsSTR=paste("STR",seq(1,164),sep="")
varsDEG=paste("DEG",seq(1,164),sep="")
varsBETC=paste("BETC",seq(1,164),sep="")
varsEFF=paste("NodalEff",seq(1,164),sep="")

#varsRAWSTR=paste("RAWSTR",se`q(1,434),sep="")
#varsRAWDEG=paste("RAWDEG",seq(1,434),sep="")
#varsRAWMAD=paste("RAWMAD",seq(1,434),sep="")

cvars=cbind("geschlecht","disease_duration","age_onset","side_of_onset","updrs_iii_on_gesamt","updrs_off_iii_gesamt","medication_response","disprogress","rs1800497")
allvars=c(cvars,"numfibers","avgCCOEFF","MAD","CPL","EFF",varsSTR,varsDEG,varsBETC,varsEFF)
ph=subset(dat,select=allvars)

mreg=0

if(mreg==0) {
mprms=cvars
} else
{
for(i in seq(1,length(cvars)))
{
if(i==1) {
mprms=cvars[,i]
} else 
{
mprms=cbind(paste(mprms,cvars[,i],sep="+"))
}
}
}

for(j in seq(1,length(mprms)))
{

regmodel=paste('y~',mprms[,j],sep="")

outall=NULL

id=which(allvars==paste("numfibers"))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)

id=which(allvars==paste("avgCCOEFF"))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)

id=which(allvars==paste("MAD"))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)

id=which(allvars==paste("CPL"))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)

id=which(allvars==paste("EFF"))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)

for(i in seq(1,164))
{
id=which(allvars==paste("STR",i,sep=""))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)
}

for(i in seq(1,164))
{
id=which(allvars==paste("DEG",i,sep=""))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)
}

for(i in seq(1,164))
{
id=which(allvars==paste("BETC",i,sep=""))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)
}

for(i in seq(1,164))
{
id=which(allvars==paste("NodalEff",i,sep=""))
y=ph[,id]
out=summary(lm(regmodel,data=ph))
res=c(allvars[id],mean(y),sd(y),out$coefficients[,1],out$coefficients[,2],out$coefficients[,4])
outall=rbind(outall,res)
}

regvars=c("Inter",attr(out$terms,"term.labels"))

outall=data.frame(outall,stringsAsFactors=F)
names(outall)=c("Var","Mean","SD",paste("beta",regvars,sep="."),paste("SE",regvars,sep="."),paste("Pvals",regvars,sep="."))

write.table(outall,file=paste(Baseoutput,"_",mprms[,j],".csv",sep=""),row.names=F,col.names=T,sep=",",quote=F)
}
