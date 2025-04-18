source("Util/conf_file_base.R") # used for function reformulate_parameter_names() and create_vector_list()

# specify_species() creates the preamble for each species

specify_species <- function(param_names, species_specific_values_names, species_specific_values)
	{
	ans <- character()

	num_params = length(param_names)

	ans <- c(ans, paste("\t\tnumber_of_parameters =", length(param_names), "\n"))

	ans <- c(ans, paste("\t\tnumber_of_species_specific_values =", length(species_specific_values_names), "\n"))

	ans <- c(ans, create_vector_list(species_specific_values_names, "species_specific_values_names"))	


	ans <- c(ans, create_vector_list(param_names, "parameter_names"))

	temp <- character()

	for (i in 1:length(species_specific_values_names))
		{
		temp[i] <- paste("\t\t", species_specific_values_names[i], " = ",sprintf("%f", species_specific_values[i]), "\n")
		}
	ans <- c(ans, temp)
	return(paste(ans,collapse=""))
	}

# create_species_demes() glues together preamble with the deme specific specifications of the parameter values

create_species_demes <- function(species_number, parameter_names, species_specific_values_names, deme_wise_data, species_specific_values)
	{
	ans <- ""
		
	start <-  paste("\t{#species",species_number, "\n",sep="")
	end <- "\t}\n\n"
	ans <- c(ans, start, specify_species(parameter_names, species_specific_values_names, species_specific_values), deme_wise_data, end)

	return(paste(ans,collapse=""))
	}
