source("Util/conf_file_base.R") # for the function prelim()
source("SpeciesInputs/prepare_deme_text.R")
source("GeneticInputs/prepare_genetic_text.R") 


prepare_deme_conf <- function(num_demes, num_params, num_species, param_names, deme_specific_matrix,  species_specific_values_names, species_values_matrix, phenotype_names, loci_names, loci_properties, genotype_Phenotype_map, recombination_rates)
	{
	ans = prelim(num_demes)
	
	ans = c(ans, prepare_deme_text(num_demes, num_species, param_names, deme_specific_matrix, species_specific_values_names, species_values_matrix))

	ans = c(ans, "\n\n", c("\n###########################\n#\n#\n#Genetics stuff\n#\n#\n############################\n"))


	ans = c(ans, prepare_genetic_text(num_species, phenotype_names, loci_names, recombination_rates, loci_properties, genotype_Phenotype_map))
	
	return(as.deme_conf(paste(ans,collapse="")))
	}


