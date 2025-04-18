source("Util/conf_file_base.R")
source("Util/create_demes.R")
source("SpeciesInputs/create_species_demes.R")

prepare_deme_text <- function(num_demes, num_species, param_names, deme_specific_matrix, species_specific_values_names, species_values_matrix)
	{
	ans =  "species_data = (\n"
	for (i in 1:num_species)
		{
		# TODO: really, deme_specific_matrix should be a list that gets accessed as deme_specific_matrix[[spp_i]]

		deme_material = c("\n\tdemes_specifications = (\n",  create_demes(param_names, deme_specific_matrix, num_demes), "\t)\n")

		ans = c(ans, create_species_demes(i-1, param_names, species_specific_values_names, deme_material, species_values_matrix[i,]))

		if (i!=num_species)
			ans = c(ans, ",\n")
		}
	ans = c(ans, "\t)\n")
	return(ans)
	}

# For example, for a single species
if (FALSE)
	{
	ndemes <- 3
	nspecies <- 1
	param_names <- c("paramA","paramB","paramC")
	deme_specific_values <- t(matrix(1:9,nrow=3))
	species_specific_values <- c("FEC_INDEX","MORT_INDEX")
	species_specific_values_matrix <- matrix(11:12,nrow=1)

	cat(prepare_deme_text(ndemes, nspecies, param_names, deme_specific_values, species_specific_values, species_specific_values_matrix))
	}
