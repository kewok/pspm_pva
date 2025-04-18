#include "Caiman_Simulator.h"
#include <util/footimer2.h>

#define BURNIN_PERIOD 100

Caiman_Simulator::Caiman_Simulator() : Simulation()
	{
	initpop = 500*demes;
	maxpop = 50000*demes;
	
	nspecies = 1;
	initialize_classes();
	}

void Caiman_Simulator::initialize_classes()
	{
	cudaSetDevice(0);
	cudaThreadSynchronize();

	habitat = new Caiman_Habitat(seed, num_biotic_variables, num_abiotic_variables, demes, intra_step_time_steps);
	cudaThreadSynchronize();

	array = new inds_stochastic *[nspecies];
	cudaThreadSynchronize();
	int species_ID = 0;

	array[0] = new Caiman(initpop, maxpop, seed, demes, species_ID);

	stats_eggsize = new Statistics(demes, "summary_statistics_eggsize.txt", "useless_histograms.txt");
	stats_fecundity = new Statistics(demes, "summary_statistics_fecundity.txt", "useless_histograms2.txt");

	//array[0]-> exportCsv("initial_data.csv");

	demographics = new DemographicStatistics(demes, "demographic_statistics.txt", "age_distribution.txt");

	preyfile.open("prey_sizes.txt");
	}

void Caiman_Simulator::run()
	{
	footimer2 timer, timerAll;
	timerAll.start();

	for (int t=0; t < nsteps; t++)
		{
		for (int i=0; i < nspecies; i++)
			{
			array[i]->addKids(habitat);
			array[i]->update(array, habitat);
			array[i]->removeDead();

			cudaThreadSynchronize();

			demographics->calculate_deme_sizes(array[i]);
			demographics->record_deme_sizes();
			}

		if (t > BURNIN_PERIOD)
			{
			habitat->update();
			}

		for (int k=0; k < demes; k++)
			{
			preyfile << habitat->prey_array[0]->prey_abundance[k] << " " << habitat->prey_array[1]->prey_abundance[k] << " " << habitat->prey_array[2]->prey_abundance[k] << " ";
			}
		preyfile << std::endl;
		}
	timerAll.stop();
	std::cout << "Total "; 
	timerAll.printTime();
	}

Caiman_Simulator::~Caiman_Simulator()
	{
	/* cleanup */
	for (int i=0; i < nspecies; i++)
		{
		delete array[i];
		}

	delete[] array;
	delete habitat;

	delete stats_fecundity;
	delete stats_eggsize;
	delete demographics;
	}
