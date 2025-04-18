#include "Caiman.h"

#include <species/add_kids/genotype_phenotype_map.h>
#include <species/update/updatebehavior.h>
#include <thrust/copy.h>
#include <thrust/sequence.h>
#include <thrust/fill.h>

Caiman::Caiman(int size_val, int maxsize_val, int seed_val, int ndemes, int species_ID_val) : inds_stochastic(size_val, maxsize_val, seed_val, ndemes, species_ID_val)
	{
	// Assume everyone starts at age = 0.
	thrust::fill(age.begin(), age.begin() + size, 0);
	
	initialize_demes();

	// Specify the genetics by assuming allelic values are gaussian-distributed
	
	for (int i=0; i < nloci; i++)
		{		
		draw_gaussian(size, 10.0, 5.0, fgenotype[i], gen);
		draw_gaussian(size, 10.0, 5.0, mgenotype[i], gen);

		// Just make the genotypes positive 
		thrust::for_each(thrust::make_zip_iterator(thrust::make_tuple(fgenotype[i].begin())),
				 thrust::make_zip_iterator(thrust::make_tuple(fgenotype[i].begin() + size)), 
				 fabs_functor());
		thrust::for_each(thrust::make_zip_iterator(thrust::make_tuple(mgenotype[i].begin())),
				 thrust::make_zip_iterator(thrust::make_tuple(mgenotype[i].begin() + size)), 
				 fabs_functor());
		}
	

	// To start, assign odd numbered individuals to be male, even numbered individuals to be female
	
	thrust::device_vector<int> twos(size);
	thrust::fill(twos.begin(), twos.end(), 2);
	thrust::transform(id.begin(), id.begin() + size, twos.begin(), sex.begin(), thrust::modulus<int>());
	
	//Set phenotype
	setPhenotype(0, size);
	}

void Caiman::addKids(environment *habitat)
	{
	demeCalculations();

	Caiman_Parents *exampleParents;
	exampleParents = new Caiman_Parents(this, habitat);
	exampleParents->setup_parents();

	if (exampleParents->Potential_Number_of_Kids > 0)
		{
		EggsNeonates *exampleNeonates;
		exampleNeonates = new EggsNeonates (this, exampleParents->kids_per_mom);
		exampleNeonates->inherit_genotypes(exampleParents->probability_individual_becomes_female_parent,  exampleParents->probability_individual_becomes_male_parent);
		setPhenotype(exampleNeonates->previous_pop_size, exampleNeonates->Total_Number_of_Neonates);
		assignSex(exampleNeonates->previous_pop_size, exampleNeonates->Total_Number_of_Neonates, habitat);
		delete exampleNeonates;     
		sortByDeme();
		}
	demeCalculations();
	delete exampleParents;
	}

void Caiman::setPhenotype(int index, int num_inds_to_calculate)
	{   
	for (int i=0; i < nphen; i++)
		{   
		GenotypePhenotypeMap *genotype_phenotype_map;
		genotype_phenotype_map = genotype_phenotype_map->create_genotype_phenotype_map(this, i, index, num_inds_to_calculate);
		genotype_phenotype_map->calculate_phenotype(this);
		delete genotype_phenotype_map;
		}
	}

void Caiman::assignSex(int index, int num_inds_to_calculate, environment *habitat)
	{
	thrust::device_vector<float> probability_vector(Num_Demes);
	thrust::device_vector<int> probability_deme(Num_Demes);
	thrust::sequence(probability_deme.begin(), probability_deme.begin() + Num_Demes, 0);
	float *average_temperature_ptr = raw_pointer_cast(habitat->get_abiotic_vector_ptr("initial_temperature"));
        float *max_temperature_ptr = raw_pointer_cast(demeParameters->get_vector_ptr("sex_maximum_temperature"));
        float *st_dev_ptr = raw_pointer_cast(demeParameters->get_vector_ptr("sex_deviation_temperature"));

	temperature_dependent_sex_determination_functor sex_determination(average_temperature_ptr, max_temperature_ptr, st_dev_ptr);
	thrust::for_each(thrust::make_zip_iterator(thrust::make_tuple(probability_vector.begin(), probability_deme.begin())), thrust::make_zip_iterator(thrust::make_tuple(probability_vector.begin() + Num_Demes, probability_deme.begin() + Num_Demes)), sex_determination);

	thrust::device_vector<int> neonates_sex (num_inds_to_calculate);
	thrust::device_vector<float> neonates_probability (num_inds_to_calculate);
	thrust::gather(deme.begin() + index, deme.begin() + index + num_inds_to_calculate, probability_vector.begin(), neonates_probability.begin());

	draw_bernoulli_different_parameters(num_inds_to_calculate, neonates_probability, neonates_sex, gen);
	thrust::copy(neonates_sex.begin(), neonates_sex.begin() + num_inds_to_calculate, sex.begin() + index);
	}

void Caiman::update(inds_stochastic **species, environment *habitat)
	{
	UpdateBehavior *updatebehavior;
	updatebehavior = updatebehavior->create_updateBehavior(species, habitat, 0);
	updatebehavior->update();
	}

void Caiman::initialize_demes()
	{
	thrust::fill(max_deme_sizes.begin(), max_deme_sizes.begin() + Num_Demes, maxsize/Num_Demes);

	for (int i=0; i < Num_Demes; i++)
		{
		float startsize = (float) (size/Num_Demes);
		int temp1 = (int) startsize * i;
		int temp2 = (int) startsize * (i+1);
		thrust::fill(deme.begin() + temp1, deme.begin() + temp2, i);
		}
	}


