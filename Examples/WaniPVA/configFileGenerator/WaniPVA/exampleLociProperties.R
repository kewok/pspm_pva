source("GeneticInputs/specify_loci_properties.R")

example_loci_properties <- function(N_demes)
	{
	locus_0_mutation_properties <- matrix(rep(c(1e-5,0.1),N_demes), nrow=N_demes, dimnames=list(1:N_demes,c("MUTATION_RATE","MUTATION_MAGNITUDE")), byrow=T)	
	locus_1_mutation_properties <- matrix(rep(c(1e-5,0.1),N_demes), nrow=N_demes, dimnames=list(1:N_demes,c("MUTATION_RATE","MUTATION_MAGNITUDE")), byrow=T)

	example_mutation_parameters = list(locus_0_mutation_properties, locus_1_mutation_properties)
	example_loci_properties <- create_loci_properties(length(example_mutation_parameters), example_mutation_parameters)
	return(example_loci_properties)
	}
