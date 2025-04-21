#ifndef CAIMAN_SIMULATOR_H
#define CAIMAN_SIMULATOR_H

#include <Simulation_Class.h>
#include "Caiman.h"
#include "Caiman_Habitat.h"
#include <math/statistics_class.h>
#include <math/demographic_statistics_class.h>

class Caiman_Simulator : public Simulation
	{
	public:
		Caiman_Simulator();
		~Caiman_Simulator();
		void run();
	private:
		inds_stochastic **array;
		Statistics *stats_eggsize;
		Statistics *stats_fecundity;
		DemographicStatistics *demographics;
		Caiman_Habitat *habitat;
		std::ofstream preyfile;

		void initialize_classes();

		int nspecies;
	};

#endif
