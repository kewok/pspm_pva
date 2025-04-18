sig_inv_to_fish <- function(inv_val)
  {
  index <- which(sigInv==inv_val)	
  return(sigFish[index])
  }
dBeta_inv_to_fish <- function(inv_val)
  {
  index <- which(betaInvChange==inv_val)	
  return(betaFishChange[index])
  }

nest_ceiling <- c(500)
nest_change <- -nest_ceiling * c(0.1,0.5,0.9)/1000
init_temp <- 31
temp_change <- c(0,1.8/100)

rInv <-  c(1.026,1.026*2) # For beverton-holt like dynamics, you only get growth when rInv > 1 + betaInv * Resource
betaInv <- 5*10^12
sigInv <- 10^seq(log(0.05,10),log(0.25,10),length=13) # As a proportion of rInv; probably too high. 0.2 is likely better
betaInvChange <- -betaInv*seq(0.5,.9999,length=13)/1000

betaFish <- 5*10^11
sigFish <- 10^seq(log(0.0075,10),log(0.075,10),length=13)  # As a proportion of rFish
betaFishChange <- -betaFish*seq(0.2,.9,length=13)/1000

U <- expand.grid(nest_ceiling, nest_change, init_temp, temp_change, rInv, betaInv, sigInv, betaInvChange, betaFish)
colnames(U) <- c("nest_ceiling", "nest_change", "init_temp", "temp_change", "rInv", "betaInv", "sigInv", "betaInvChange", "betaFish")

sig_fish <- c()
dBeta_fish <- c()
for (i in 1:nrow(U))
  {
  sig_fish[i] <- sig_inv_to_fish(U[i,'sigInv'])
  dBeta_fish[i] <- dBeta_inv_to_fish(U[i,'betaInvChange'])
  }

U <- cbind(U, sig_fish, dBeta_fish)

colnames(U) <- c("nest_ceiling", "nest_change", "init_temp", "temp_change", "rInv", "betaInv", "sigInv", "betaInvChange", "betaFish", "sigFish", "betaFishChange")

ending_pops <- read.table("ending_pops_cor.txt")
times2ext <- read.table("times2ext_cor.txt")

fraction_zeros <- function(x) length(x[x==0])/length(x)
extinction_prob <- apply(ending_pops,2,fraction_zeros)

persist_time <- apply(times2ext,2,mean)
persist_time <- ifelse(persist_time==1100,NA,persist_time)

library(fields)

# Partition by nest type and rInv
cor1 <- which(U[,'nest_change']==nest_change[1] & U[,'temp_change']==temp_change[1] & U[,'rInv']==rInv[1])
cor2 <- which(U[,'nest_change']==nest_change[3] & U[,'temp_change']==temp_change[1] & U[,'rInv']==rInv[1])
cor3 <- which(U[,'nest_change']==nest_change[1] & U[,'temp_change']==temp_change[1] & U[,'rInv']==rInv[2])
cor4 <- which(U[,'nest_change']==nest_change[3] & U[,'temp_change']==temp_change[1] & U[,'rInv']==rInv[2])

pdf('Fig6.pdf')
par(mfrow=c(2,2),las=1,cex.axis=1.25,cex.lab=1.25,oma=c(0,6,1.5,0),mar=c(5, 5.75, 4, 1)-0.5)
image(z=matrix(persist_time[cor1],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(A)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)
image(z=matrix(persist_time[cor2],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(B)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)
image(z=matrix(persist_time[cor3],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(C)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)
image(z=matrix(persist_time[cor4],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(D)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)

mtext('10% Nest site loss',side=3,outer=T,line=-1,at=0.3,cex=1.2)
mtext('90% Nest site loss',side=3,outer=T,line=-1,at=0.8,cex=1.2)

mtext(expression(italic(r)['Inv']*'='*italic(r)['Fish']),side=2,outer=T,line=0.5,at=0.75,cex=1.3)
mtext(expression(italic(r)['Inv']*'='*'2'*italic(r)['Fish']),side=2,outer=T,line=0.5,at=0.25,cex=1.3)
dev.off()

pdf(file='Fig6_legend.pdf',width=8,height=2)
image.plot(z=matrix(persist_time),legend.only=T, col=tim.colors(64),horizontal=TRUE,legend.lab="Average years to extinction", axis.args=list(at=round(seq(min(persist_time,na.rm=T),max(persist_time,na.rm=T),length=5),digits=2)),legend.width=2,legend.mar=5,legend.cex=1.3,cex.lab=1.1,legend.shrink=1.0)
dev.off()

sd_persist_time <- apply(times2ext,2,sd)
sd_persist_time <- ifelse(extinction_prob==0,NA,sd_persist_time)

pdf('Fig7.pdf')
par(mfrow=c(2,2),las=1,cex.axis=1.25,cex.lab=1.25,oma=c(0,6,1.5,0),mar=c(5, 5.75, 4, 1)-0.5)
image(z=matrix(sd_persist_time[cor1],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(A)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)
image(z=matrix(sd_persist_time[cor2],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(B)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)
image(z=matrix(sd_persist_time[cor3],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(C)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)
image(z=matrix(sd_persist_time[cor4],ncol=length(sigFish)),xlab='',ylab='Scaled instability in\nresource recruitment',main='(D)',col=tim.colors(64))
title(xlab='Scaled reduction in resource\n carrying capacity',line=3.5)

mtext('10% Nest site loss',side=3,outer=T,line=-1,at=0.3,cex=1.2)
mtext('90% Nest site loss',side=3,outer=T,line=-1,at=0.8,cex=1.2)

mtext(expression(italic(r)['Inv']*'='*italic(r)['Fish']),side=2,outer=T,line=0.5,at=0.75,cex=1.3)
mtext(expression(italic(r)['Inv']*'='*'2'*italic(r)['Fish']),side=2,outer=T,line=0.5,at=0.25,cex=1.3)
dev.off()

pdf(file='Fig7_legend.pdf',width=8,height=2)
image.plot(z=matrix(sd_persist_time),legend.only=T, col=tim.colors(64),horizontal=TRUE,legend.lab="Standard error of years to extinction", axis.args=list(at=round(seq(min(sd_persist_time,na.rm=T),max(sd_persist_time,na.rm=T),length=5),digits=2)),legend.width=2,legend.mar=5,legend.cex=1.3,cex.lab=1.1,legend.shrink=1.0)
dev.off()

fraction_zeros <- function(x) length(x[x==0])/length(x)
extinction_prob <- apply(ending_pops,2,fraction_zeros)

# extinction plots:
par(mfrow=c(2,2),las=1)
image(z=matrix(extinction_prob[cor1],ncol=length(sigFish)),xlab='Scaled reduction in carrying capacity',ylab='Log scaled recruitment uncertainty',main='(A)',col=tim.colors(64))
image(z=matrix(extinction_prob[cor2],ncol=length(sigFish)),xlab='Scaled reduction in carrying capacity',ylab='Log scaled recruitment uncertainty',main='(B)',col=tim.colors(64))
image(z=matrix(extinction_prob[cor3],ncol=length(sigFish)),xlab='Scaled reduction in carrying capacity',ylab='Log scaled recruitment uncertainty',main='(C)',col=tim.colors(64))
image(z=matrix(extinction_prob[cor3],ncol=length(sigFish)),xlab='Scaled reduction in carrying capacity',ylab='Log scaled recruitment uncertainty',main='(D)',col=tim.colors(64))
