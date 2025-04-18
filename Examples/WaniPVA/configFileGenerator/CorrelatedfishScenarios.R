source("ChangeNDemes.R")

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

invertebrates <- list(PreyGrow=U[,'rInv'], PreyDensDep=U[,'betaInv'], PreyFluct=U[,'sigInv'], PreyDensDepChange=U[,'betaInvChange'])
ichthyofauna <- list(PreyDensDep=U[,'betaFish'], PreyFluct=U[,'sigFish'], PreyDensDepChange=U[,'betaFishChange'])
abiotics <- list(init_temp=U[,'init_temp'], nest_ceiling=U[,'nest_ceiling'], nest_change=U[,'nest_change'], temp_change=U[,'temp_change'], PreyFluct=U[,'sigFish'], PreyDensDepChange=U[,'betaFishChange'])

NDemes <- nrow(U)

nTimeSteps <- 1100

newConfigs(NDemes, nTimeSteps, abiotics, invertebrates, ichthyofauna)