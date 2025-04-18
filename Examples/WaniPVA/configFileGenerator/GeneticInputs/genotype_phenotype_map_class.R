as.genotype_phenotype_map <- function(x)
	{
	class(x) <- "genotype_phenotype_map"
	return(x)
	}

create_genotype_phenotype_map <- function(parameters, deme_specific_genotype_phenotype_map_parameters_matrix)
	{
	genotype_phenotype_map <- list(parameters, deme_specific_genotype_phenotype_map_parameters_matrix)
	names(genotype_phenotype_map) <- c("parameters", "deme_specific_genotype_phenotype_map_parameters_matrix")

	return(genotype_phenotype_map)
	}

# to use this:
if (FALSE)
	{
	Ndemes <- 4

	P <- create_genotype_phenotype_map(c("A","B","C"),matrix(rnorm(Ndemes*3),nrow=Ndemes,ncol=3)) # phenotype 1

	B <- create_genotype_phenotype_map(c("D"),matrix(rnorm(Ndemes*1),nrow=Ndemes,ncol=1)) # phenotype 2

	R <- create_genotype_phenotype_map(0,NULL) # phenotype 3

	genoPhenoMap <- list(P, B, R)
	}


