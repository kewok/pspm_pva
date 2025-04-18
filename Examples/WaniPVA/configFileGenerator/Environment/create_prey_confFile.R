source("conf_file_base.R")
source("specify_conf_files.R")

prepare_prey_conf <- function(num_prey_types, num_demes, num_params, param_names, preys_deme_specific_matrix, num_time_steps, time_step_names, prey_fluctuation_matrix)
	{
	ans = prey_prelim(num_prey_types, num_demes, num_params, param_names)
	ans = c(ans, create_prey_demes(num_prey_types, num_demes, param_names, preys_deme_specific_matrix))

	ans = c(ans, prelim_fluctuations(num_time_steps, time_step_names))
	ans = c(ans, create_prey_fluctuations_by_deme(num_prey_types, num_demes, time_step_names, prey_fluctuation_matrix))
	return(as.prey_conf(paste(ans,collapse="")))
	}

prey_prelim <- function(num_prey_types, num_demes, num_params, param_names)
	{
	ans <- c("Number_of_Prey_Types = ", num_prey_types,"\n")
	ans <- c(ans, prelim(num_demes, num_params, param_names))
	return(paste(ans, collapse=""))
	}

#preys_deme_specific_matrix <- array(dim=c(num_prey, num_demes, num_param))
create_prey_demes <- function(num_prey_types, num_demes, param_names, prey_deme_specific_matrix)
	{
	
	ans <- paste("prey_initialization = \n(")
	
	for (i in 1:(num_prey_types-1))
		{
		ans <- c(ans, specify_prey(num_demes, param_names, prey_deme_specific_matrix[i,,], i), ",\n")
		}
	ans <- c(ans, specify_prey(num_demes, param_names, prey_deme_specific_matrix[num_prey_types,,], num_prey_types))
	ans <- c(ans, "\n)")
	return(paste(ans,collapse=""))
	}


#preys_deme_specific_matrix <- array(dim=c(num_prey, num_demes, num_param))
create_prey_fluctuations_by_deme <- function(num_prey_types, num_demes, time_step_names, prey_fluctuation_matrix)
	{
	ans <- paste("Temporal_Fluctuations = \n(")
	
	for (i in 1:(num_prey_types-1))
		{
		ans <- c(ans, specify_prey(num_demes, time_step_names, prey_fluctuation_matrix[i,,], i), ",\n")
		}
	ans <- c(ans, specify_prey(num_demes, time_step_names, prey_fluctuation_matrix[num_prey_types,,], num_prey_types))
	ans <- c(ans, "\n)")
	return(paste(ans,collapse=""))
	}

specify_prey <- function(num_demes, param_names, preys_deme_specific_matrix, prey_number)
	{
	ans <- paste("# prey", prey_number-1,"\n\t(\n")

	ans <- c(ans, create_demes(num_demes, param_names, preys_deme_specific_matrix))
	ans <- c(ans, "\t)")
	return(paste(ans, collapse=""))
	}


prelim_fluctuations <- function(num_time_steps, time_step_names)
	{
	if (num_time_steps != length(time_step_names))
		{
		print("time_step_names and number_of_time_steps do not match!")
		return("time_step_names and number_of_time_steps do not match!");
		}
	ans <- character()
	ans <- c("\n###########################\n#\n#\n#Temporal fluctuations\n#\n#\n############################\n")
	ans <- c(ans,paste("number_of_time_steps =", num_time_steps, "\n"))

	setup_time_step_names <- sapply(time_step_names[1:(length(time_step_names)-1)], reformulate_parameter_names, USE.NAMES=F)

	ans <- c(ans, "time_step_names = [", setup_time_step_names, "\"",time_step_names[length(time_step_names)],"\"","]\n\n")

	return(paste(ans,collapse=""))
	}



