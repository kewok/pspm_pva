as.env_conf <- function(x)
	{
	class(x) <- "env_conf_text"
	return(x)
	}

as.sim_conf <- function(x)
	{
	class(x) <- "simulation_conf_text"
	return(x)
	}

as.deme_conf <- function(x)
	{
	class(x) <- "deme_conf_text"
	return(x)
	}

as.species_conf <- function(x)
	{
	class(x) <- "species_conf_text"
	return(x)
	}

generate_conf_file <- function(x, filename="deme_config.txt") UseMethod("generate_conf_file")

generate_conf_file.deme_conf_text <- function(x, filename="deme_config.txt"){
	sink(filename)	
	cat(x)
	sink()
	}

generate_conf_file.env_conf_text <- function(x, filename="environment_config.txt"){
	sink(filename)	
	cat(x)
	sink()	
	}


generate_conf_file.simulation_conf_text <- function(x, filename="deme_config.txt"){
	sink("Simulation.conf")	
	cat(x)
	sink()	
	}

generate_conf_file.species_conf_text <- function(x){
	sink("Species.conf")	
	cat(x)
	sink()	
	}
