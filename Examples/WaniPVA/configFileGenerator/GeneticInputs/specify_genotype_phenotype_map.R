source("Util/create_demes.R")
source("Util/conf_file_base.R")

# specify_genotype_phenotype_map() returns an array of phenotype specifications to the conf file. For each phenotype, the constituent loci and an array of their allelic effects (which may vary by "deme") are specified. 

specify_genotype_phenotype_map <- function(genotype_phenotype_map)
	{
	num_phenotypes <- length(genotype_phenotype_map)

	ans <- character()
	ans <- "\tphenotype_specifications = (\n"

	for (i in 1:num_phenotypes)
		{
		ans <- c(ans, paste("\t\t{#phenotype", i-1, "\n", sep=""))

		ans <- c(ans, paste("\t\tnumber_of_genotype_phenotype_map_parameters =", length(genotype_phenotype_map[[i]]$parameters),"\n"))	

		if (length(genotype_phenotype_map[[i]]$parameters) > 0)
			{
			ans <- c(ans, paste(create_vector_list(genotype_phenotype_map[[i]]$parameters, "names_of_genotype_phenotype_map_parameters"),"\n\t\t"))

			genotype_phenotype_map_by_deme = c("\t\tgenotype_phenotype_map_parameters=(\n", create_demes(genotype_phenotype_map[[i]]$parameters, genotype_phenotype_map[[i]]$deme_specific_genotype_phenotype_map_parameters_matrix), "\t\t)\n\n")

			ans <- c(ans, genotype_phenotype_map_by_deme)
			}
		if (i < num_phenotypes)
			{
			ans <- c(ans,"\t\t},\n")
			}
		else
			{
			ans <- c(ans, "\t\t}\n")
			}
		}
	ans <- c(ans, "\t\t)\n")
	return(ans)
	}

# To see how this might work, consider the following example:
if (FALSE)
	{
	source("genotype_phenotype_map_class.R")
	nphenotypes=3
	ndemes=3

	phenotype_0_genotype_phenotype_map <- create_genotype_phenotype_map(c("GEN_PHEN_MAP_CONSTANT"), matrix(c(1,2,3),nrow=ndemes))
	phenotype_1_genotype_phenotype_map <- create_genotype_phenotype_map(c("GEN_PHEN_MAP_CONSTANT","GEN_PHEN_MAP_COEF0"), matrix(c(0.1,0.2,0.3,0.01,0.02,0.03),nrow=ndemes))
	phenotype_2_genotype_phenotype_map <- create_genotype_phenotype_map(c(),NULL)

	example_genotype_phenotype_map = list(phenotype_0_genotype_phenotype_map, phenotype_1_genotype_phenotype_map, phenotype_2_genotype_phenotype_map)

	cat(specify_genotype_phenotype_map(example_genotype_phenotype_map))
	}
