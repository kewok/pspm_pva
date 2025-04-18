#include "Caiman_genotype_phenotype_maps.h"
#include <math/random_variables_functions.h>
#include <thrust/gather.h>
#include <thrust/sequence.h>

void fecundity_phenotype::calculate_phenotype(inds *species)
	{
	thrust::fill(species->phenotype[phenotype_index].begin() + index_case, species->phenotype[phenotype_index].begin() + index_case + num_kids, 0.0);
	}


void mortality_phenotype::calculate_phenotype(inds *species)
	{	
	thrust::fill(species->phenotype[phenotype_index].begin() + index_case, species->phenotype[phenotype_index].begin() + index_case + num_kids, 0.0);
	}

void irreversible_mass_at_birth::calculate_phenotype(inds *species)
	{
	thrust::gather(species->deme.begin() + index_case, species->deme.begin() + index_case + num_kids, Parameters->get_vector_ptr("IRREVERSIBLE_MASS_AT_BIRTH_CONSTANT"),
species->phenotype[phenotype_index].begin() + index_case);
	}

void reversible_mass_at_birth::calculate_phenotype(inds *species)
	{
	thrust::gather(species->deme.begin() + index_case, species->deme.begin() + index_case + num_kids, Parameters->get_vector_ptr("REVERSIBLE_MASS_AT_BIRTH_CONSTANT"),
species->phenotype[phenotype_index].begin() + index_case);
	}

void inbreeding_at_birth::calculate_phenotype(inds *species)
	{
	thrust::gather(species->deme.begin() + index_case, species->deme.begin() + index_case + num_kids, Parameters->get_vector_ptr("INBREEDING_LEVEL"),
species->phenotype[phenotype_index].begin() + index_case);
	}

void egg_size::calculate_phenotype(inds *species)
	{
	thrust::gather(species->deme.begin() + index_case, species->deme.begin() + index_case + num_kids, Parameters->get_vector_ptr("EGGSIZE_CONSTANT"),
species->phenotype[phenotype_index].begin() + index_case);
	}

