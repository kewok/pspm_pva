#ifndef CAIMAN_H
#define CAIMAN_H

#include <cmath>
#include <species/inds_stochastic.h>
#include "Caiman_Habitat.h"
#include "Caiman_Parents.h"
#include <species/add_kids/neonates_class.h>

class Caiman : public inds_stochastic
	{
	public:
		Caiman(int size_val, int maxsize_val, int seed_val, int ndemes, int species_ID_val);
		
		using inds_stochastic::addKids;
		void addKids(environment *habitat);

		using inds_stochastic::update;
		void update(inds_stochastic **species, environment *habitat);

	protected:
		void get_deme_data_vector(const char *parameter_name);

		void initialize_demes();

		void setPhenotype(int index, int n);
		void assignSex(int index, int n, environment *habitat);
	};

struct temperature_dependent_sex_determination_functor
	{
	float *average_temperature;
	float *max_temperature;
	float *st_dev;

	temperature_dependent_sex_determination_functor(float *average_temperature_ptr, float *max_temperature_ptr, float *st_dev_ptr): average_temperature(average_temperature_ptr), max_temperature(max_temperature_ptr), st_dev(st_dev_ptr)
	{};

	/*
		Elements in the tuple.
		----------------------
		0: probability
		1: deme
	*/
	template <typename tuple>
	__host__ __device__
	void operator()(tuple t) {
		float temperature = average_temperature[thrust::get<1>(t)];
		float max_temp = max_temperature[thrust::get<1>(t)];
		float sd = st_dev[thrust::get<1>(t)];

		thrust::get<0>(t) = 0.95*exp(-pow((temperature-max_temp)/sd,2));
		}
	};

#endif

