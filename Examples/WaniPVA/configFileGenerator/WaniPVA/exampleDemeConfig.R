source("prepare_deme_conf.R")
source("specify_conf_files.R")
source("WaniPVA/exampleLociProperties.R")

# TODO: Break this up into two functions, one handling the genetics and one handling the other parameters, then have a third function that glues them back together

N_species <- 1

create_deme_config <- function(N_demes, N_loci, genotype_Phenotype_map,intra_annual_time_steps)
	{
	example_param_names <- c("ontogenetic_niche_shift_constant","ontogenetic_niche_shift_coefficient","piscivory_probability","length_weight_conversion_coefficient","length_weight_conversion_exponent","handling_time","F_sizes_at_maturity","M_sizes_at_maturity","M_reproductive_advantage","F_reproductive_advantage","proportion_prey_variance","proportion_adult_resources_variance","satiation_noise","functional_response_numerator","allometric_metabolic_coefficient","allometric_metabolic_exponent","allometric_maximum_consumption_coefficient","allometric_maximum_consumption_exponent","juvenile_maximum_condition","mature_maximum_condition","egg_survivorship","effect_of_starvation_constant","effect_of_starvation_coefficient","size_dependent_mortality_constant","size_dependent_mortality_coefficient","maximum_survivorship","cannibalism_constant","mean_number_of_others_sampled","sex_maximum_temperature","sex_deviation_temperature")

	map <- function(x)
		{
		which(example_param_names==x)
		}

	N_parms <- length(example_param_names)

	deme_specific_matrix <- matrix(nrow=N_demes, ncol=N_parms)

	# For derivation of these values, see the Table1_PVA_parameters.R script

	deme_specific_matrix[,map("allometric_maximum_consumption_coefficient")] <- rep(1.7140, N_demes)
	deme_specific_matrix[,map("allometric_maximum_consumption_exponent")] <- rep(0.6062, N_demes)
	deme_specific_matrix[,map("allometric_metabolic_coefficient")] <- rep(0.3541, N_demes) 
	deme_specific_matrix[,map("allometric_metabolic_exponent")] <- rep(0.75,N_demes)

	deme_specific_matrix[,map("length_weight_conversion_coefficient")] <- rep(0.128,N_demes) 
	deme_specific_matrix[,map("length_weight_conversion_exponent")] <- rep(0.3333,N_demes)
	deme_specific_matrix[,map("functional_response_numerator")] <- rep(3.208, N_demes) 
	deme_specific_matrix[,map("handling_time")] <- rep(0.7567,N_demes) 

	deme_specific_matrix[,map("ontogenetic_niche_shift_constant")] <- rep(1.265,N_demes) 
	deme_specific_matrix[,map("ontogenetic_niche_shift_coefficient")] <- rep(-0.002154,N_demes) 
	deme_specific_matrix[,map("piscivory_probability")] <- rep(0.7826,N_demes)

	deme_specific_matrix[,map("juvenile_maximum_condition")] <- rep(0.7377, N_demes) 
	deme_specific_matrix[,map("mature_maximum_condition")] <- rep(1.044, N_demes) 

	deme_specific_matrix[,map("F_sizes_at_maturity")] <- rep(3622.0,N_demes)
	deme_specific_matrix[,map("M_sizes_at_maturity")] <- rep(6002.0,N_demes)

	deme_specific_matrix[,map("egg_survivorship")] <- rep(0.225, N_demes)
	deme_specific_matrix[,map("size_dependent_mortality_constant")] <- rep(3.179, N_demes) 
	deme_specific_matrix[,map("size_dependent_mortality_coefficient")] <- rep(0.02537, N_demes)
	deme_specific_matrix[,map("maximum_survivorship")] <- rep(1-1/(40*intra_annual_time_steps), N_demes)
	deme_specific_matrix[,map("effect_of_starvation_constant")] <- rep(-29.78, N_demes) 
	deme_specific_matrix[,map("effect_of_starvation_coefficient")] <- rep(-22.21, N_demes) 

	deme_specific_matrix[,map("M_reproductive_advantage")] <- rep(1.0,N_demes) # Guess; probably available for A. miss.?
	deme_specific_matrix[,map("F_reproductive_advantage")] <- rep(1.0,N_demes)

	deme_specific_matrix[,map("proportion_prey_variance")] <- rep(0.,N_demes)
	deme_specific_matrix[,map("proportion_adult_resources_variance")] <- rep(0, N_demes)
	deme_specific_matrix[,map("satiation_noise")] <- rep(0, N_demes)

	deme_specific_matrix[,map("cannibalism_constant")] <- rep(0.0, N_demes)
	deme_specific_matrix[,map("mean_number_of_others_sampled")] <- rep(10, N_demes)
	deme_specific_matrix[,map("sex_maximum_temperature")] <- rep(32.75, N_demes)
	deme_specific_matrix[,map("sex_deviation_temperature")] <- rep(1.455, N_demes)

	example_loci_names <- paste("locus",1:N_loci,sep="")
	example_loci_properties <- example_loci_properties(N_demes)

	# TODO: deme_specific_matrix, deme_specific_genetic_matrix need to be lists of matrices

	recombination_rates <- rep(0.5, N_loci)

	species_specific_parameter_names = c("mate_sampling_scheme", "mating_scheme","FECUNDITY_PHENOTYPE","MORTALITY_PHENOTYPE","INBREEDING_PHENOTYPE", "IRREVERSIBLE_MASS_PHENOTYPE", "REVERSIBLE_MASS_PHENOTYPE","EGGSIZE_PHENOTYPE")
	
	species_specific_parameter_values = matrix(nrow=N_species, ncol=length(species_specific_parameter_names))

	species_specific_parameter_values[,which(species_specific_parameter_names=="mate_sampling_scheme")] = rep(1, N_species)
	species_specific_parameter_values[,which(species_specific_parameter_names=="mating_scheme")] = rep(0, N_species)	
	species_specific_parameter_values[,which(species_specific_parameter_names=="FECUNDITY_PHENOTYPE")] = rep(0, N_species)
	species_specific_parameter_values[,which(species_specific_parameter_names=="MORTALITY_PHENOTYPE")] = rep(1, N_species)
	species_specific_parameter_values[,which(species_specific_parameter_names=="INBREEDING_PHENOTYPE")] = rep(2, N_species)
	species_specific_parameter_values[,which(species_specific_parameter_names=="IRREVERSIBLE_MASS_PHENOTYPE")] = rep(3, N_species)
	species_specific_parameter_values[,which(species_specific_parameter_names=="REVERSIBLE_MASS_PHENOTYPE")] = rep(4, N_species)	
	species_specific_parameter_values[,which(species_specific_parameter_names=="EGGSIZE_PHENOTYPE")] = rep(5, N_species)	

	phenotype_names <- c("FECUNDITY_PHENOTYPE","MORTALITY_PHENOTYPE","INBREEDING_PHENOTYPE","IRREVERSIBLE_MASS_PHENOTYPE", "REVERSIBLE_MASS_PHENOTYPE","EGGSIZE_PHENOTYPE")

################
##
##
## End input
##
##
##
################

	#### Actual construction ######

	output <- prepare_deme_conf(N_demes, N_parms, N_species, example_param_names,deme_specific_matrix, species_specific_parameter_names, species_specific_parameter_values, phenotype_names, example_loci_names, example_loci_properties,  genotype_Phenotype_map, recombination_rates)

	generate_conf_file(output)
	}
