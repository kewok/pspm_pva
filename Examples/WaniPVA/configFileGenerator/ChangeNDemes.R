source("WaniPVA/exampleEnvConfig.R")
source("WaniPVA/exampleDemeConfig.R")
source("WaniPVA/exampleGenPhenMap.R")
source("sim_config.R")

Nloci <- 2
intra_annual_time_steps <- 90
num_biotic_variables <- 3

newConfigs <- function(NDemes, Nyears, abiotics, invertebrates, ichthyofauna)
	{
	num_abiotic_variables <- length(abiotics)
	genPhenMap <- create_genPhenMap(NDemes,Nloci)
	create_deme_config(NDemes, Nloci, genPhenMap, intra_annual_time_steps)
	create_env_config(NDemes, intra_annual_time_steps, invertebrates, ichthyofauna, abiotics)
	create_simulation_config_file(Nyears, NDemes, intra_annual_time_steps, num_biotic_variables, num_abiotic_variables, 128632)
	}

