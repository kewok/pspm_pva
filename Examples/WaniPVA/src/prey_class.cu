#include "prey_class.h"
#include <math/random_variables_functions.h>

#include <fstream>
#include <fstream>
#include <iostream>
#include <thrust/functional.h>


typedef thrust::device_vector<float>::iterator floatIter_t;
typedef thrust::device_vector<int>::iterator intIter_t;

prey::prey(int num_demes, int prey_index, int seed_val, int num_time_steps) : Num_Demes(num_demes), Prey_Index(prey_index), seed (seed_val),  Number_of_Timesteps (num_time_steps)
	{
	prey_abundance.resize(Num_Demes);
	prey_maximum_abundance.resize(Num_Demes);
	prey_assimilation_efficiency.resize(Num_Demes);

	prey_carrying_capacity.resize(Num_Demes);
	prey_unconstrained_growth_rates.resize(Num_Demes);

	prey_growth_rate_noise_stddev.resize(Num_Demes);

	//Initialize curand generator.
	curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT);
	curandSetPseudoRandomGeneratorSeed(gen, seed);

	prey_abundance.resize(Num_Demes);

	noise_updated = 0;

	//Read in deme-specific data for each prey type	
	preyParameters = new PreyDemeSpecificData("environment_config.txt", prey_index);
	}

void prey::specify_prey_properties_by_deme()
	{
	thrust::copy(preyParameters->get_vector_ptr("prey_density_dependence"), preyParameters->get_vector_ptr("prey_density_dependence") + Num_Demes, prey_carrying_capacity.begin());

	thrust::copy(preyParameters->get_vector_ptr("prey_unconstrained_growth_rates"), preyParameters->get_vector_ptr("prey_unconstrained_growth_rates") + Num_Demes, prey_unconstrained_growth_rates.begin());

	thrust::copy(preyParameters->get_vector_ptr("prey_assimilation_efficiency"), preyParameters->get_vector_ptr("prey_assimilation_efficiency") + Num_Demes, prey_assimilation_efficiency.begin());

	thrust::copy(preyParameters->get_vector_ptr("prey_maximum_abundance"), preyParameters->get_vector_ptr("prey_maximum_abundance") + Num_Demes, prey_maximum_abundance.begin());

	// initialize the prey abundances.
	thrust::copy(prey_maximum_abundance.begin(), prey_maximum_abundance.begin() + Num_Demes, prey_abundance.begin());

	// Initialize noise to zero
	thrust::fill(prey_growth_rate_noise_stddev.begin(), prey_growth_rate_noise_stddev.begin() + Num_Demes, 0.0);
	}

void prey::update_prey_abundance(thrust::device_vector<float> &effect_of_individuals_on_prey)
	{
	// Add random noise to the prey abundance
	thrust::device_vector<float> stochastic_component(Num_Demes);
	thrust::device_vector<float> stochastic_growth(Num_Demes);
	thrust::device_vector <float> zeros(Num_Demes);
	thrust::fill(zeros.begin(), zeros.begin() + Num_Demes, 0);

	draw_gaussian_different_parameters(Num_Demes, zeros, prey_growth_rate_noise_stddev, stochastic_component, gen);

	thrust::transform(prey_unconstrained_growth_rates.begin(), prey_unconstrained_growth_rates.begin() + Num_Demes, stochastic_component.begin(), stochastic_component.begin(), thrust::multiplies<float>());
	thrust::transform(prey_unconstrained_growth_rates.begin(), prey_unconstrained_growth_rates.begin() + Num_Demes, stochastic_component.begin(), stochastic_growth.begin(), thrust::plus<float>());	

	// typedef for clarity
	typedef thrust::tuple<floatIter_t, floatIter_t, floatIter_t, floatIter_t> tuple_t;
	typedef thrust::zip_iterator<tuple_t> zipIter_t;

	tuple_t start = thrust::make_tuple(stochastic_growth.begin(), prey_carrying_capacity.begin(), effect_of_individuals_on_prey.begin(), prey_abundance.begin());
	tuple_t end = thrust::make_tuple(stochastic_growth.begin()  + Num_Demes, prey_carrying_capacity.begin()  + Num_Demes, effect_of_individuals_on_prey.begin() + Num_Demes, prey_abundance.begin() + Num_Demes);

 	//Create zip iterators.
	zipIter_t zstart = thrust::make_zip_iterator(start);
	zipIter_t zend = thrust::make_zip_iterator(end);

	thrust::for_each(zstart, zend,  update_prey());

	cudaThreadSynchronize();
	// Make sure you have no negative prey
	thrust::replace_if(prey_abundance.begin(), prey_abundance.begin() + Num_Demes, is_less_than_zero_f(), 0.0);
	}

void prey::update_prey_density_dependence()
	{
	thrust::for_each(
		thrust::make_zip_iterator(thrust::make_tuple(prey_carrying_capacity.begin(), preyParameters->get_vector_ptr("prey_density_dependence_change"))),
		thrust::make_zip_iterator(thrust::make_tuple(prey_carrying_capacity.begin() + Num_Demes, preyParameters->get_vector_ptr("prey_density_dependence_change") + Num_Demes)),
		update_density_dependence());
	}

void prey::update_prey_growth_noise()
	{
	if (noise_updated == 0)
		{
		thrust::copy(preyParameters->get_vector_ptr("prey_growth_rate_noise_stddev"), preyParameters->get_vector_ptr("prey_growth_rate_noise_stddev") + Num_Demes, prey_growth_rate_noise_stddev.begin());
		noise_updated = 1;
		}
	}
