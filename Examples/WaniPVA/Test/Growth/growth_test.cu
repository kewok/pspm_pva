#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <ConfigFile.h>
#include <iomanip>
#include "Caiman.h"
#include "Caiman_Habitat.h"

class Test_Mass_Growth : public ::testing::Test{
	protected:
		virtual void setup() {
		}
		virtual void TearDown() {
		}
};

TEST_F(Test_Mass_Growth, update_caiman) 
	{
	ConfigFile config("Simulation.conf");
	int demes = config.read<int>( "ndemes" );
	int intra_step_time_steps = config.read<int>( "intra_step_time_steps" );

	int seed = config.read<int>("random_seed");

	int num_biotic_variables = config.read<int>( "num_biotic_variables" );
	int num_abiotic_variables = config.read<int>( "num_abiotic_variables" );

	inds_stochastic **TEST_Caiman;
	TEST_Caiman = new inds_stochastic *[0];
	Caiman_Habitat *habitat;

	int initpop = 10*demes;
	int maxpop = 10*demes;
	int species_ID = 0;

	habitat = new Caiman_Habitat(seed, num_biotic_variables, num_abiotic_variables, demes, intra_step_time_steps);
	TEST_Caiman[0] = new Caiman(initpop, maxpop, seed, demes, species_ID);
	cudaThreadSynchronize();

//	Prey Abundance
/*	habitat->prey_array[0]->prey_abundance[0] = 175000;
	habitat->prey_array[0]->prey_abundance[1] = 17500000;

	habitat->prey_array[1]->prey_abundance[0] = 20000;
	habitat->prey_array[1]->prey_abundance[1] = 2000000;

	habitat->prey_array[2]->prey_abundance[0] = 10070;
	habitat->prey_array[2]->prey_abundance[1] = 1007000;
*/

	TEST_Caiman[0]->phenotype[3][0] = 38.2;
	TEST_Caiman[0]->phenotype[4][0] = 76.4;
	TEST_Caiman[0]->phenotype[3][1] = 5832;
	TEST_Caiman[0]->phenotype[4][1] = 11664;
	TEST_Caiman[0]->phenotype[3][2] = 9664;
	TEST_Caiman[0]->phenotype[4][2] = 19328;
	TEST_Caiman[0]->phenotype[3][3] = 5832;
	TEST_Caiman[0]->phenotype[4][3] = 16329;
	TEST_Caiman[0]->phenotype[3][4] = 9664;
	TEST_Caiman[0]->phenotype[4][4] = 27059;
	TEST_Caiman[0]->phenotype[3][5] = 38.2;
	TEST_Caiman[0]->phenotype[4][5] = 76.4;
	TEST_Caiman[0]->phenotype[3][6] = 5832;
	TEST_Caiman[0]->phenotype[4][6] = 11664;
	TEST_Caiman[0]->phenotype[3][7] = 9664;
	TEST_Caiman[0]->phenotype[4][7] = 19328;
	TEST_Caiman[0]->phenotype[3][8] = 5832;
	TEST_Caiman[0]->phenotype[4][8] = 16329;
	TEST_Caiman[0]->phenotype[3][9] = 9664;
	TEST_Caiman[0]->phenotype[4][9] = 27059;
	TEST_Caiman[0]->phenotype[3][10] = 38.2;
	TEST_Caiman[0]->phenotype[4][10] = 76.4;
	TEST_Caiman[0]->phenotype[3][11] = 5832;
	TEST_Caiman[0]->phenotype[4][11] = 11664;
	TEST_Caiman[0]->phenotype[3][12] = 9664;
	TEST_Caiman[0]->phenotype[4][12] = 19328;
	TEST_Caiman[0]->phenotype[3][13] = 5832;
	TEST_Caiman[0]->phenotype[4][13] = 16329;
	TEST_Caiman[0]->phenotype[3][14] = 9664;
	TEST_Caiman[0]->phenotype[4][14] = 27059;
	TEST_Caiman[0]->phenotype[3][15] = 38.2;
	TEST_Caiman[0]->phenotype[4][15] = 76.4;
	TEST_Caiman[0]->phenotype[3][16] = 5832;
	TEST_Caiman[0]->phenotype[4][16] = 11664;
	TEST_Caiman[0]->phenotype[3][17] = 9664;
	TEST_Caiman[0]->phenotype[4][17] = 19328;
	TEST_Caiman[0]->phenotype[3][18] = 5832;
	TEST_Caiman[0]->phenotype[4][18] = 16329;
	TEST_Caiman[0]->phenotype[3][19] = 9664;
	TEST_Caiman[0]->phenotype[4][19] = 27059;


	TEST_Caiman[0] -> update(TEST_Caiman, habitat);
	TEST_Caiman[0] -> addKids();

/*	habitat->update();

	for (int i=0; i < habitat->nbiotic_vars; i++)
		{
		for (int j=0; j < demes; j++)
			{
			std::cout<< "Prey type " << i << " count deme " << j << " " << habitat->prey_array[i]->prey_abundance[j] <<std::endl;
			}
		}
*/
//	Define vector
	thrust::host_vector<float> expected_answer_rev_mas(maxpop);
	thrust::host_vector<float> expected_answer_irrev_mas(maxpop);
	thrust::host_vector<float> expected_answer_fecund(maxpop);
	thrust::host_vector<float> expected_resource1_levels(demes);
	thrust::host_vector<float> expected_resource2_levels(demes);
	thrust::host_vector<float> expected_resource3_levels(demes);


//	Manually Add Values.
	expected_answer_rev_mas[0]=74.3035781035;
	expected_answer_rev_mas[1]=11551.43467;
	expected_answer_rev_mas[2]=19161.5235706;
	expected_answer_rev_mas[3]=16193.7933693;
	expected_answer_rev_mas[4]=19328;
	expected_answer_rev_mas[5]=74.3035781035;
	expected_answer_rev_mas[6]=11551.43467;
	expected_answer_rev_mas[7]=19161.5235706;
	expected_answer_rev_mas[8]=11664;
	expected_answer_rev_mas[9]=26859.1334045;
	expected_answer_rev_mas[10]=81.0144017632;
	expected_answer_rev_mas[11]=11715.5393843;
	expected_answer_rev_mas[12]=19371.8564762;
	expected_answer_rev_mas[13]=16373.7527234;
	expected_answer_rev_mas[14]=19393.6477187;
	expected_answer_rev_mas[15]=81.0144017632;
	expected_answer_rev_mas[16]=11701.1013816;
	expected_answer_rev_mas[17]=19397.4565977;
	expected_answer_rev_mas[18]=11720.3739486;
	expected_answer_rev_mas[19]=27123.8852862;


	expected_answer_irrev_mas[0]=38.2;
	expected_answer_irrev_mas[1]=5832;
	expected_answer_irrev_mas[2]=9664;
	expected_answer_irrev_mas[3]=5832;
	expected_answer_irrev_mas[4]=9664;
	expected_answer_irrev_mas[5]=38.2;
	expected_answer_irrev_mas[6]=5832;
	expected_answer_irrev_mas[7]=9664;
	expected_answer_irrev_mas[8]=5832;
	expected_answer_irrev_mas[9]=9664;
	expected_answer_irrev_mas[10]=40.5072008816;
	expected_answer_irrev_mas[11]=5857.76969213;
	expected_answer_irrev_mas[12]=9685.92823808;
	expected_answer_irrev_mas[13]=5871.15593533;
	expected_answer_irrev_mas[14]=9696.82385937;
	expected_answer_irrev_mas[15]=40.5072008816;
	expected_answer_irrev_mas[16]=5850.5506908;
	expected_answer_irrev_mas[17]=9685.92823808;
	expected_answer_irrev_mas[18]=5860.18697429;
	expected_answer_irrev_mas[19]=9696.82385937;

	expected_answer_fecund[0]=0;
	expected_answer_fecund[1]=0;
	expected_answer_fecund[2]=0;
	expected_answer_fecund[3]=0;
	expected_answer_fecund[4]=65;
	expected_answer_fecund[5]=0;
	expected_answer_fecund[6]=0;
	expected_answer_fecund[7]=0;
	expected_answer_fecund[8]=39;
	expected_answer_fecund[9]=0;
	expected_answer_fecund[10]=0;
	expected_answer_fecund[11]=0;
	expected_answer_fecund[12]=0;
	expected_answer_fecund[13]=0;
	expected_answer_fecund[14]=67;
	expected_answer_fecund[15]=0;
	expected_answer_fecund[16]=0;
	expected_answer_fecund[17]=0;
	expected_answer_fecund[18]=40;
	expected_answer_fecund[19]=0;

	expected_resource1_levels[0]=760664.898231621
;	expected_resource1_levels[1]=17497875.4037023
;

	expected_resource2_levels[0]=58822.0923797183
;	expected_resource2_levels[1]=1999985.0825332
;

	expected_resource3_levels[0]=11898.8507923049
;	expected_resource3_levels[1]=993659.115866533
;

	thrust::host_vector<float> host_answer_irrev_mas = TEST_Caiman[0]->phenotype[3];
	thrust::host_vector<float> host_answer_rev_mas = TEST_Caiman[0]->phenotype[4];
	thrust::host_vector<float> host_resource1_levels = habitat->prey_array[0]->prey_abundance;
	thrust::host_vector<float> host_resource2_levels = habitat->prey_array[1]->prey_abundance;
	thrust::host_vector<float> host_resource3_levels = habitat->prey_array[2]->prey_abundance;
	thrust::host_vector<float> host_answer_fecund = TEST_Caiman[0]->phenotype[0];

	EXPECT_THAT(host_answer_rev_mas, ::testing::ContainerEq(expected_answer_rev_mas));
	EXPECT_THAT(host_answer_irrev_mas, ::testing::ContainerEq(expected_answer_irrev_mas));
	EXPECT_THAT(host_answer_fecund, ::testing::ContainerEq(expected_answer_fecund));
	for (int i=0; i < host_resource1_levels.size(); i++)
		{
		EXPECT_FLOAT_EQ(host_resource1_levels[i], expected_resource1_levels[i]); //::testing::ContainerEq(expected_resource1_levels));
		EXPECT_FLOAT_EQ(host_resource2_levels[i], expected_resource2_levels[i]); //::testing::ContainerEq(expected_resource2_levels));
		EXPECT_FLOAT_EQ(host_resource3_levels[i], expected_resource3_levels[i]); //::testing::ContainerEq(expected_resource3_levels));
		}
	}

