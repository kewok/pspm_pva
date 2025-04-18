as.loci_properties <- function(x)
	{
	class(x) <- "loci_properties"
	return(x)
	}

create_loci_properties <- function(nLoci, mutation_parameters)
	{
	loci_properties <- list(nLoci, mutation_parameters)
	names(loci_properties) <- c("number_of_loci", "mutation_parameters")

	return(loci_properties)
	}

# to use this:
if (FALSE)
	{
	nloci <- 2
	ndemes <- 3

	locus_0_mutation_properties <- matrix(c(0.001,0.001,0.001,0.1,0.2,0.3),ncol=2,dimnames=list(1:ndemes,c("MUTATION_RATE","MUTATION_MAGNITUDE")))

	locus_1_mutation_properties <- matrix(c(0.001,0.001,0.001,0.4,0.5,0.6),ncol=2,dimnames=list(1:ndemes,c("MUTATION_RATE","MUTATION_MAGNITUDE")))

	example_mutation_parameters = list(locus_0_mutation_properties, locus_1_mutation_properties)

	example_loci_properties <- create_loci_properties(nloci, example_mutation_parameters)
	}


