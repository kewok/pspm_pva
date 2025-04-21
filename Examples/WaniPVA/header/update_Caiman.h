#ifndef UPDATE_CAIMAN_H
#define UPDATE_CAIMAN_H

#include <species/update/updatebehavior.h>
#include "Caiman_Habitat.h"

#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/transform.h>

class update_Caiman : public UpdateBehavior
	{
	inds_stochastic *species;
	Caiman_Habitat *habitat;

	// Constructor
	public:
	update_Caiman(inds_stochastic *species, environment *habitat) 
	 	{
		this->species = species;

		this->MORTALITY_PHENOTYPE = species->demeParameters->species_specific_values["MORTALITY_PHENOTYPE"];
		this->FECUNDITY_PHENOTYPE = species->demeParameters->species_specific_values["FECUNDITY_PHENOTYPE"];
		this->IRREVERSIBLE_MASS_PHENOTYPE = species->demeParameters->species_specific_values["IRREVERSIBLE_MASS_PHENOTYPE"];
		this->REVERSIBLE_MASS_PHENOTYPE = species->demeParameters->species_specific_values["REVERSIBLE_MASS_PHENOTYPE"];
		this->RESOURCE_LIMITATION_PHENOTYPE = species->demeParameters->species_specific_values["RESOURCE_LIMITATION_PHENOTYPE"];
		this->EGGSIZE_PHENOTYPE =  species->demeParameters->species_specific_values["EGGSIZE_PHENOTYPE"];

		// Copy the constants 
		this->size = species->size;
		this->Number_of_Demes = species->Num_Demes;

		// Nifty hack: Downcast your generic habitat object to a pointer to fish class to access its members
		this->habitat = static_cast<Caiman_Habitat*> (habitat);
		this->intra_annual_time_steps = this->habitat->intra_annual_time_steps;
		// Prepare pointers to thrust vectors:
		prepare_growth_constants_pointers();
		prepare_survivorship_constants_pointers();
		}

	void update();

	protected:
		// variable names
		int MORTALITY_PHENOTYPE;
		int FECUNDITY_PHENOTYPE;
		int IRREVERSIBLE_MASS_PHENOTYPE;
		int REVERSIBLE_MASS_PHENOTYPE;
		int RESOURCE_LIMITATION_PHENOTYPE;
		int EGGSIZE_PHENOTYPE;

		int size;
		int Number_of_Demes;
		int intra_annual_time_steps;
		void consume();
		void survive();
		void update_vital_rates();
		void update_fecundity();

		void prepare_growth_constants_pointers();
		void prepare_survivorship_constants_pointers();

		// Pointers to thrust vectors used in survivorship calculation:
		float *effect_of_starvation_coefficient_ptr;
		float *effect_of_starvation_constant_ptr;
		float *size_dependent_mortality_constant_ptr;
		float *size_dependent_mortality_coefficient_ptr;
		float *maximum_survivorship_ptr;

		// Pointers to thrust vectors used in somatic growth calculation:
		float *consumption_allometric_scalar;
		float *consumption_allometric_exponent;
		float *metabolism_allometric_scalar;
		float *metabolism_allometric_exponent;

		float *ontogenetic_niche_shift_constant;
		float *ontogenetic_niche_shift_coefficient;

		float *resource_1_maximum;
		float *resource_2_maximum;
		float *resource_3_maximum;


		float *handling_time;

		float *functional_response_scalar;

		float *mature_maximum_condition;
		float *juvenile_maximum_condition;

		float *M_sizes_at_maturity;
		float *F_sizes_at_maturity;
	};


/* Functors related to updating */

struct grand_consumption_functor
{
	float *consumption_allometric_scalar;
	float *consumption_allometric_exponent;
	float *metabolism_allometric_scalar;
	float *metabolism_allometric_exponent;

	float *ontogenetic_niche_shift_constant;
	float *ontogenetic_niche_shift_coefficient;
	
	float *resource_1;
	float *resource_1_maximum;
	float *resource_2;
	float *resource_2_maximum;
	float *resource_3;
	float *resource_3_maximum;

	float *handling_time;

	float *functional_response_scalar;

	float *energetic_cost;

	float *mature_maximum_condition;
	float *juvenile_maximum_condition;

	float *M_sizes_at_maturity;
	float *F_sizes_at_maturity;

	
	grand_consumption_functor(float *eCoef, float *gammaG, float *burnCoef, float *burnExp, float *ONS_constant, float *ONS_coef, float *r1, float *r1_K, float *r2, float *r2_K, float *r3, float *r3_K, float *handling, float *fnl_scalar, float *mature_kappa, float *juv_kappa, float *M_size_mat, float *F_size_mat) : consumption_allometric_scalar(eCoef), consumption_allometric_exponent(gammaG), metabolism_allometric_scalar(burnCoef), metabolism_allometric_exponent(burnExp), ontogenetic_niche_shift_constant(ONS_constant), ontogenetic_niche_shift_coefficient(ONS_coef), resource_1(r1), resource_2(r2), resource_3(r3), resource_1_maximum(r1_K), resource_2_maximum(r2_K), resource_3_maximum(r3_K), handling_time(handling),  functional_response_scalar (fnl_scalar), mature_maximum_condition(mature_kappa), juvenile_maximum_condition(juv_kappa), M_sizes_at_maturity(M_size_mat), F_sizes_at_maturity(F_size_mat)
	{};

	/* 
		Elements in the tuple.
		----------------------
		0: irreversible_mass
		1: reversible_mass
		2: pop
		3: proportion of adult resource consumed (currently dummy variable)
		4: sex
		5: status
		6: piscivory occurs (1 or 0)
		7: resource 1 consumed
		8: resource 2 consumed
		9: resource 3 consumed
	*/ 
	template <typename tuple>
	__device__
	void operator()(tuple t) {
		int individuals_pop = thrust::get<2>(t);
		
		if (thrust::get<5>(t) > 0)
			{
			// If resources were at maximum abundance that month, and the individual specialized exclusively on this prey type, then the intake rate is integrate_0_30 b W^gamma which comes out to, in Hiyama and Kitahara's notation, the integrated weight increase with no metabolic costs :

			float available_resources_1 = resource_1[individuals_pop]/resource_1_maximum[individuals_pop];
			float satiation_resource_1 = (functional_response_scalar[individuals_pop]*available_resources_1)/(1 + functional_response_scalar[individuals_pop]*handling_time[individuals_pop] * available_resources_1); 

			float available_resources_2 = resource_2[individuals_pop]/resource_2_maximum[individuals_pop];
			float satiation_resource_2 = (functional_response_scalar[individuals_pop]*available_resources_2)/(1 + functional_response_scalar[individuals_pop]*handling_time[individuals_pop] * available_resources_2);

			float available_resources_3 = resource_3[individuals_pop]/resource_3_maximum[individuals_pop];
			float satiation_resource_3 = (functional_response_scalar[individuals_pop]*available_resources_3)/(1 + functional_response_scalar[individuals_pop]*handling_time[individuals_pop] * available_resources_3);  

			float xt0 = thrust::get<0>(t);
			float yt0 = thrust::get<1>(t);

			float xt1 = 0;
			float yt1 = 0;

			float kappa = 0;
			float gamma_val = consumption_allometric_exponent[individuals_pop];

			float maturity_threshold = 0;

			if (thrust::get<4>(t) == 0)
				maturity_threshold = F_sizes_at_maturity[individuals_pop];
			else
				maturity_threshold = M_sizes_at_maturity[individuals_pop];

			// Set the initial kappa value. 
			// NB: Be very careful with this: "if (x) do_this if(!x) do_that" seems to give different instructions from "if (x) do_this else do_that"
			if (xt0 >= maturity_threshold)
				kappa = 1/((1+mature_maximum_condition[individuals_pop])*mature_maximum_condition[individuals_pop]);
			else
				kappa = 1/((1+juvenile_maximum_condition[individuals_pop])*juvenile_maximum_condition[individuals_pop]);

			float maximum_consumption = 0;
			float percent_adult_resource_eaten = 0.0;
			float percent_juvenile_resource = 0.0;
			float Eg = 0;

			float ons_constant = ontogenetic_niche_shift_constant[individuals_pop];
			float ons_coefficient = ontogenetic_niche_shift_coefficient[individuals_pop];
			float conversion_efficiency = consumption_allometric_scalar[individuals_pop];

			float metabolic_coef = metabolism_allometric_scalar[individuals_pop];
			float metabolic_expo = metabolism_allometric_exponent[individuals_pop];

			// Do the dynamic energy budgeting
			maximum_consumption = conversion_efficiency*pow(xt0+yt0, gamma_val);

	// Energy growth is therefore
				
			percent_adult_resource_eaten = 1/(1.0+exp(ons_constant + ons_coefficient*(xt0)));

			if (isinf(exp(ons_constant + ons_coefficient*(xt0))))
				{
				percent_adult_resource_eaten = 1.0;
				}

			percent_juvenile_resource = 1.0-percent_adult_resource_eaten;
			
			float prey_eaten_1 = satiation_resource_1*percent_juvenile_resource*maximum_consumption; /* Invertebrates */
			float fish_eaten = (float) thrust::get<6>(t);
			float prey_eaten_2 = fish_eaten *satiation_resource_2*percent_adult_resource_eaten*maximum_consumption; /* Fish */
			float prey_eaten_3 = (1.0-fish_eaten) *satiation_resource_3*percent_adult_resource_eaten*maximum_consumption; /* Tetrapods */ 

			// printf("Prey eaten juv. v. adult: %f %f ONS juv v. ad.: %f %f Resource avail: %f %f Size: %f\n", prey_eaten_1, prey_eaten_2, percent_juvenile_resource, percent_adult_resource_eaten, available_resources_1, available_resources_2, xt0);

			// Subtract metabolic costs
			Eg = (prey_eaten_1 + prey_eaten_2 + prey_eaten_3) - metabolic_coef*pow(xt0+yt0, metabolic_expo);

			if (Eg >= 0)
				{
				xt1 = (yt0/xt0)*kappa*Eg + xt0;
				yt1 = (1-(yt0/xt0)*kappa)*Eg + yt0;
				}
			else
				{
				yt1 = yt0 + Eg;
				if (yt1 < 0)
					{
					yt1 = 0;
					}
				xt1 = xt0;
				}

/*			printf("Max food: %f Irrev: %f ONS: %f Juvenile Prey available: %f %f %f Fish: %f %f Tetrapods: %f %f ONS: %f Parms: %f %f %f %f Energy gained: %f Original size: %f %f Final size: %f %f\n", maximum_consumption, xt0, percent_juvenile_resource, satiation_resource_1, available_resources_1, prey_eaten_1, available_resources_2, prey_eaten_2, available_resources_3, prey_eaten_3, percent_adult_resource_eaten, conversion_efficiency, gamma_val, metabolic_coef,  metabolic_expo, Eg, xt0, yt0, xt1, yt1);*/

			thrust::get<0>(t) = xt1;
			thrust::get<1>(t) = yt1;
					
			thrust::get<7>(t) = prey_eaten_1;
			thrust::get<8>(t) = prey_eaten_2;
			thrust::get<9>(t) = prey_eaten_3;
			}
		}
};


struct calculate_mortality
{
	float *effect_of_starvation_constant;
	float *effect_of_starvation_coefficient;

	float *size_dependent_mortality_constant;
	float *size_dependent_mortality_coefficient;

	float *maximum_survivorship;

	calculate_mortality(float *bSTV_0, float *bSTV, float *max_surv, float *bMort0, float *bMort1) : effect_of_starvation_constant(bSTV_0), effect_of_starvation_coefficient(bSTV), maximum_survivorship(max_surv), size_dependent_mortality_constant(bMort0), size_dependent_mortality_coefficient(bMort1)
	{};

	/* 
		Elements in the tuple.


		----------------------
		0: irreversible mass
		1: reversible mass
		2: probability of survivorship
		3: individual's subpopulation
		4: individual's age
		5: individual's dead/alive status
		6: uniform random variable

	*/ 
	template <typename tuple>
	__host__ __device__
	void operator()(tuple t) {
		int individuals_pop = thrust::get<3>(t);

		float condition = log(thrust::get<1>(t)/thrust::get<0>(t));

		if (thrust::get<5>(t)==1) /* If the individual is alive */
			{
			if (thrust::get<4>(t) >= 0) // If individual is not an egg
				{
				thrust::get<2>(t) =  maximum_survivorship[individuals_pop]*(1-(exp(effect_of_starvation_coefficient[individuals_pop]*condition + effect_of_starvation_constant[individuals_pop]))) * (1/(1+exp(-(size_dependent_mortality_coefficient[individuals_pop]*thrust::get<0>(t) + size_dependent_mortality_constant[individuals_pop]))));
				}

			if (thrust::get<2>(t) < 0)	
				{
				thrust::get<2>(t)=0;
				}

			// Actually kill them -> possibly have a different functor?
			if (thrust::get<6>(t) < thrust::get<2>(t))
				{
				thrust::get<5>(t) = 1;
				}
			if (thrust::get<6>(t) >= thrust::get<2>(t))
				{
				thrust::get<5>(t) = 0;
				}
			}
		}	
};


// Update fecundity according to (reversible-irreversible*max_cond)/(max_cond*eggsize + egg_size)

struct update_female_fecundity_functor
{
	float *maximum_condition;
	
	update_female_fecundity_functor(float *maximum_conditions_ptr) : maximum_condition(maximum_conditions_ptr)
	{};

	/* 
		Elements in the tuple.

		----------------------
		0: sex of the individual
		1: the individual's subpopulation
		2: the individual's irreversible mass
		3: the individual's reversible mass
		4: the genetically determined average offspring size
		5: the individual's final fecundity score
		6: the individual's index
	*/ 

	template <typename tuple>
	__host__ __device__
	void operator()(tuple t) {
		float eggsize = thrust::get<4>(t);

		thrust::get<5>(t) = 0; // make sure there is no carry-over from the previous time step.
		thrust::get<5>(t) = (1-thrust::get<0>(t)) * (thrust::get<3>(t) - thrust::get<2>(t)*maximum_condition[thrust::get<1>(t)])/(eggsize);
		// because we are dealing with the number of kids, convert to integers
		int tempVal = (int) thrust::get<5>(t);
		thrust::get<5>(t) = (float) tempVal;

		float surplus_mass_used_in_reproduction = (1-thrust::get<0>(t)) *(thrust::get<3>(t) - thrust::get<2>(t)*maximum_condition[thrust::get<1>(t)]);

		float finalfecund = thrust::get<5>(t);
		float irrevmass = thrust::get<2>(t);
		float revmass = thrust::get<3>(t);
		float offsize = thrust::get<4>(t);
		
/*		if (finalfecund > 0)
			printf("%f %f %f %f %f\n",finalfecund, irrevmass, revmass, surplus_mass_used_in_reproduction, offsize);
*/		
		/* make sure that you deduct the amount used from reproductive females */
		if (thrust::get<5>(t) > 0)
			{
			thrust::get<3>(t) -= surplus_mass_used_in_reproduction;
			}
		if (thrust::get<5>(t) <= 0)
			{
			thrust::get<5>(t) = 0 ;
			}
		}
};

#endif
