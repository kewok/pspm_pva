source("Util/create_demes.R")
source("GeneticInputs/loci_properties_class.R")

# specify_loci_properties() returns an array of specifications regarding each locus to the conf file. For each locus, the mutation rate and the magnitude of the mutation (assuming a continuum of alleles model) are simulated. Other parameters (e.g., whether a continuum of alleles model or a diallelic locus model are to be used) could also potentially be incorporated.


specify_loci_properties <- function(loci_properties)
	{
	num_loci <- loci_properties$number_of_loci

	ans <- character()
	ans <- "locus_specifications = (\n"

	for (i in 1:num_loci)
		{
		ans <- c(ans, paste("\t{#locus", i-1, "\n", sep=""))

		ans <- c(ans, paste("\tmutation_parameters = (\n", create_demes(c("MUTATION_RATE","MUTATION_MAGNITUDE"),loci_properties$mutation_parameters[[i]]),"\t\t)\n"))	

		if (i < num_loci)
			{
			ans <- c(ans,"\t},\n")
			}
		else
			{
			ans <- c(ans, "\t}\n")
			}
		}
	ans <- c(ans, "\t)\n")
	return(ans)
	}

# To see how this might work, consider the following example:
if (FALSE)
	{
	source("loci_properties_class.R")
	nloci <- 2
	ndemes <- 3

	locus_0_mutation_properties <- matrix(c(0.001,0.001,0.001,0.1,0.2,0.3),ncol=2,dimnames=list(1:ndemes,c("MUTATION_RATE","MUTATION_MAGNITUDE")))
	locus_1_mutation_properties <- matrix(c(0.001,0.001,0.001,0.4,0.5,0.6),ncol=2,dimnames=list(1:ndemes,c("MUTATION_RATE","MUTATION_MAGNITUDE")))

	example_mutation_parameters = list(locus_0_mutation_properties, locus_1_mutation_properties)

	example_loci_properties <- create_loci_properties(nloci, example_mutation_parameters)

	cat(specify_loci_properties(example_loci_properties))
	}
