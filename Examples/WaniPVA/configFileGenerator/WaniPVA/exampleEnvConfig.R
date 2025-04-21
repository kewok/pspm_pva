source("Environment/prepare_env_conf.R")
source("specify_conf_files.R")

#abiotics <- list(init_temp=25:30, temp_change=seq(1,3,length=5), sex_max_temp=32, sex_deviation_temp=.78, nest_ceiling=seq(100,10000,length=5), nest_change=seq(5,10,length=5))

create_env_config <- function(N_demes, Nsteps, inv, fish, abiotics)
	{
	example_param_names <- c("prey_density_dependence","prey_unconstrained_growth_rates","prey_assimilation_efficiency", "prey_growth_rate_noise_stddev","prey_maximum_abundance","prey_density_dependence_change")

	map <- function(x)
		{
		which(example_param_names==x)
		}

	N_prey <- 3
	N_parms <- length(example_param_names)

	example_time_steps <- paste("Step",1:Nsteps,sep="")
	map_fluctuations <- function(x)
		{
		which(example_time_steps==x)
		}

	Num_Within_Generation_Time_Steps <- length(example_time_steps)

	prey_deme_specific_matrix <- array(dim=c(N_prey, N_demes, N_parms))

	# Modify these codes to account for decrease in density-dependence
	# for invertebrates
	prey_deme_specific_matrix[1,,map("prey_density_dependence")] <- inv$PreyDensDep
	prey_deme_specific_matrix[1,,map("prey_unconstrained_growth_rates")] <- inv$PreyGrow
	prey_deme_specific_matrix[1,,map("prey_assimilation_efficiency")] <- rep(1., N_demes)
	prey_deme_specific_matrix[1,,map("prey_growth_rate_noise_stddev")] <- inv$PreyFluct
	prey_deme_specific_matrix[1,,map("prey_maximum_abundance")] <- (inv$PreyGrow-1)*(inv$PreyDensDep)
	prey_deme_specific_matrix[1,,map("prey_density_dependence_change")] <- inv$PreyDensDepChange

	# for fish
	prey_deme_specific_matrix[2,,map("prey_density_dependence")] <- fish$PreyDensDep
	prey_deme_specific_matrix[2,,map("prey_unconstrained_growth_rates")] <- 1.026 # Median (scaled for time) value from Myers et al. Can. J. Fish. Aq. Sci. 1999 (10.1139/f99-201) "the maximum annual reproductive rate, is relatively constant within species and that there is relatively little variation among species."
	prey_deme_specific_matrix[2,,map("prey_assimilation_efficiency")] <- rep(1., N_demes)
	prey_deme_specific_matrix[2,,map("prey_growth_rate_noise_stddev")] <- fish$PreyFluct
	prey_deme_specific_matrix[2,,map("prey_maximum_abundance")] <- (1.026-1)*(fish$PreyDensDep)
	prey_deme_specific_matrix[2,,map("prey_density_dependence_change")] <- fish$PreyDensDepChange

	# for tetrapods: this is quite complicated, but the basic idea is that from Casagranda and Boudouresque 2009 (10.1007/s10750-009-9986-3) we know the ratio of tetrapod to fish biomass in a brackish lagoon to be pT=(1.3/(6.4+13.8)). This is the only known study comparing the relative biomasses of these two taxa in the same area. This means that the maximum tetrapod biomass (R_tetrapod-1)*M_tetrapod = (Rfish-1)*Mfish * (1.3/(6.4+13.8)) so M_tetrapod = (Rfish-1)*Mfish * (1.3/(6.4+13.8))/(R_tetrapod-1)
	prey_deme_specific_matrix[3,,map("prey_density_dependence")] <- ( 1.026-1)*fish$PreyDensDep *0.06436/( 1.005-1)
	prey_deme_specific_matrix[3,,map("prey_unconstrained_growth_rates")] <- 1.005 
	prey_deme_specific_matrix[3,,map("prey_assimilation_efficiency")] <- rep(1., N_demes)
	prey_deme_specific_matrix[3,,map("prey_growth_rate_noise_stddev")] <- fish$PreyFluct
	prey_deme_specific_matrix[3,,map("prey_maximum_abundance")] <- ( 1.005-1)*(( 1.026-1)*fish$PreyDensDep *0.06436/( 1.005-1))
	prey_deme_specific_matrix[3,,map("prey_density_dependence_change")] <- fish$PreyDensDepChange* 0.06436

	prey_fluctuation_matrix <- array(dim=c(N_prey, N_demes, Num_Within_Generation_Time_Steps))

	for (j in 1:Num_Within_Generation_Time_Steps)
		{
	# for juvenile resource
		prey_fluctuation_matrix[1,,j] <- rep(0, N_demes)

	# for fish
		prey_fluctuation_matrix[2,,j] <- rep(0, N_demes)

	# for fish
		prey_fluctuation_matrix[3,,j] <- rep(0, N_demes)
		}

	# Abiotic stuff
	abiotic_variable_names <- c("external_forcing","initial_temperature","maximum_temperature","temperature_change","nest_ceiling","nest_change")
	map_abiotics <- function(x)
		{
		which(abiotic_variable_names==x)
		}

	abiotic_variable_matrix <- matrix(nrow=N_demes, ncol=length(abiotic_variable_names))

# Modify this code to generate abiotic variables:
	abiotic_variable_matrix[,map_abiotics("external_forcing")] <- round(rnorm(N_demes, mean=0, sd=0),2)
	abiotic_variable_matrix[,map_abiotics("initial_temperature")] <- abiotics$init_temp
	abiotic_variable_matrix[,map_abiotics("temperature_change")] <- abiotics$temp_change
	abiotic_variable_matrix[,map_abiotics("nest_ceiling")] <- abiotics$nest_ceiling
	abiotic_variable_matrix[,map_abiotics("nest_change")] <- abiotics$nest_change

	for (i in 1:nrow(abiotic_variable_matrix))
		{
		abiotic_variable_matrix[i,map_abiotics("maximum_temperature")] <- abiotic_variable_matrix[i,map_abiotics("initial_temperature")] + abiotic_variable_matrix[i,map_abiotics("temperature_change")]*200
		}

	# Output the config entity

	output <- prepare_env_conf(N_prey, N_demes, abiotic_variable_names, abiotic_variable_matrix, N_parms, example_param_names, prey_deme_specific_matrix, Num_Within_Generation_Time_Steps, example_time_steps, prey_fluctuation_matrix)

	generate_conf_file(output)
	}
