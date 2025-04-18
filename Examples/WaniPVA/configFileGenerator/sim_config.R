source("specify_conf_files.R")

create_simulation_config_file <- function(n_timesteps, ndemes, intra_step_time_steps, num_biotic_variabls, num_abiotic_variables, random_seed)
	{
	output <- paste("n_timesteps = ", n_timesteps, "\n",
			"ndemes = ", ndemes, "\n",
			"intra_step_time_steps = ", intra_step_time_steps, "\n",
			"num_biotic_variables = ", num_biotic_variabls, "\n",
			"num_abiotic_variables = ", num_abiotic_variables, "\n",
			"random_seed = ", random_seed, 
			sep="",collapse="")
		
	generate_conf_file(as.sim_conf(output))
	}

# unit test:
# create_simulation_config_file(120, 3, 12, 3, 0, round(runif(1,0,1e5)))
