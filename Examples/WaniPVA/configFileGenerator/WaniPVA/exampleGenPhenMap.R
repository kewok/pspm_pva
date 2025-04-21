source("GeneticInputs/genotype_phenotype_map_class.R")

irreversible_at_birth <- 22.0
qJ <- 0.738

create_genPhenMap <- function(NDemes, Nloci, Nspp=1)
	{
	# In this single-species example, only mortality and fecundity are under genetic control
	phen0 <- create_genotype_phenotype_map(NULL, NULL)
	phen1 <- create_genotype_phenotype_map(NULL, NULL)
	
	# Assume that allelic effects are given by a single locus measuring genomic similarity (for inbreeding depression calculation)
	phen2 <- create_genotype_phenotype_map(c("INBREEDING_LEVEL"),  matrix(rep(1,NDemes),nrow=NDemes, byrow=T))

	# Assume that irreversible mass at birth is fixed 
	phen3 <- create_genotype_phenotype_map(c("IRREVERSIBLE_MASS_AT_BIRTH_CONSTANT"),  matrix(rep(irreversible_at_birth,NDemes),nrow=NDemes, byrow=T)) # Perez-Talavera (2000)

	phen4 <- create_genotype_phenotype_map(c("REVERSIBLE_MASS_AT_BIRTH_CONSTANT"),  matrix(rep(irreversible_at_birth * qJ ,NDemes),nrow=NDemes, byrow=T)) # Juvenile maximum conditions * irreversible mass

	phen5 <- create_genotype_phenotype_map(c("EGGSIZE_CONSTANT"),  matrix(rep(irreversible_at_birth*qJ + irreversible_at_birth ,NDemes),nrow=NDemes, byrow=T)) # irreversible mass + Juvenile maximum conditions * irreversible mass

	genoPhenoMap <- list(phen0, phen1, phen2, phen3, phen4, phen5)
	return(genoPhenoMap)
	}

# Presumably you can create a list of the outputs of create_genPhenMap
