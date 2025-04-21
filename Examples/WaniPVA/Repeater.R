setwd('configFileGenerator')
source('sim_config.R')
setwd('..')

# Perform the following for a given scenario analyzed, modifying the random number seed as needed
setwd('Results')
for (i in 1:100)
	{
	system(paste('mkdir replicate_',i,sep=''))
	setwd(paste('replicate_',i,sep=''))
	system('cp ../../a.out .')
	system('cp ../../*_config.txt .')
	Nyears <- 1100
	NDemes <- 2028
	Nloci <- 2
	intra_annual_time_steps <- 90
	num_biotic_variables <- 3
	num_abiotic_variables <- 6

	create_simulation_config_file(Nyears, NDemes, intra_annual_time_steps, num_biotic_variables, num_abiotic_variables, 228632 + i)
	system('./a.out')
	setwd('..')
	}


