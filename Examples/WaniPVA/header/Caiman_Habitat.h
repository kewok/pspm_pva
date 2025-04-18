#ifndef CAIMAN_HABITAT_H
#define CAIMAN_HABITAT_H

#include <species/inds.h>
#include <environ/environment.h>
#include "prey_class.h"

class Caiman_Habitat : public environment
	{
	public:
		Caiman_Habitat(int seed_val, int num_biotic_variables, int num_abiotic_variables, int num_demes, int num_time_steps);
		void update();

		prey **prey_array; // An array of prey classes
		void update_prey();	
		int intra_annual_time_steps;
		int current_time_step;
	protected:
		void initialize_abiotic_variables(const char *filename);
	};

struct temperature_update
	{
	/*
		Elements in the tuple.
                ----------------------
                0: temperature
		1: max_temperature
                2: temperature_change_rate
	*/
	 template <typename tuple>
        __host__ __device__
        void operator()(tuple t) {

                thrust::get<0>(t) = thrust::get<2>(t)*thrust::get<0>(t)*(1 - thrust::get<0>(t) / thrust::get<1>(t)) + thrust::get<0>(t);
		}
	};

struct nesting_update
	{
	/*
		Elements in the tuple.
		----------------------
		0: nesting
		1: nesting_change_rate
	*/
	template <typename tuple>
	__host__ __device__
	void operator()(tuple t) {
		if (thrust::get<0>(t) > 0)
			{
			thrust::get<0>(t) = thrust::get<0>(t) + thrust::get<1>(t);
			}
		}
	};


#endif
