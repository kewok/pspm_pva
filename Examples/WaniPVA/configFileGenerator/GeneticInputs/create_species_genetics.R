source("Util/conf_file_base.R") # needed for create_vector_list, create_vector_list_numeric
source("GeneticInputs/specify_loci_properties.R")
source("GeneticInputs/specify_genotype_phenotype_map.R")

create_species_genetics <- function(species_number, phenotype_names, loci_names, recombination_rates, loci_properties, genotype_phenotype_map)
	{
	ans <-  paste("\t{#species",species_number, "\n",sep="")

	num_loci = loci_properties$number_of_loci

	ans <- c(ans,paste("\tnumber_of_loci =", num_loci, "\n"))
	
	ans <- c(ans,paste("\tnumber_of_phenotypes =", length(phenotype_names), "\n"))
	
	ans <- c(ans, create_vector_list(phenotype_names, "phenotype_names"))

	ans <- c(ans, create_vector_list_numeric(recombination_rates, "recombination_rates"))		

# To retain functionality of changing recombination rates by deme, take the recombination rate specifier our of prelim_genetics and use this instead:

#	ans = c(ans, "recombination_rates= (\n", create_demes(loci_names, deme_specific_recombination_rates),")")

	ans <- c(ans, create_vector_list(loci_names, "loci_names"))

	ans <- c(ans, specify_loci_properties(loci_properties))

	ans <- c(ans, specify_genotype_phenotype_map(genotype_phenotype_map), "\t}\n\n")
	return(paste(ans,collaps=""))
	}
