source("GeneticInputs/create_species_genetics.R")

prepare_genetic_text <- function(num_species, phenotype_names, loci_names, recombination_rates, loci_properties, genotype_phenotype_map)
	{

	ans = "species_genetics = (\n"
	for (i in 1:num_species)
		{
		ans = c(ans, create_species_genetics(i-1, phenotype_names, loci_names, recombination_rates, loci_properties, genotype_phenotype_map))

		if (i!=num_species)
			ans = c(ans, ",\n")
		}
	ans = c(ans, "\t)\n")	

	return(ans)
	}
