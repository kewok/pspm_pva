#ifndef CAIMAN_PARENTS_CLASS_H
#define CAIMAN_PARENTS_CLASS_H

#include <species/add_kids/parents_class.h>
#include "Caiman_mating_kernel_functors.h"
#include "Caiman_Habitat.h"

class Caiman_Parents : public Parents
	{
	class Caiman *species;
	public:
		Caiman_Parents(Caiman *species, environment *habitat);
		
	protected:
		environment *habitat;

		int IRREVERSIBLE_MASS_PHENOTYPE;
		int FECUNDITY_PHENOTYPE;
		int REVERSIBLE_MASS_PHENOTYPE;

		void determine_female_parent_eligibility();
		void determine_male_parent_eligibility();
		void female_fecundity();

		void determine_probability_individual_becomes_female_parent();
		void determine_probability_individual_becomes_male_parent();
		void female_nesting_success();		
	};

#endif 
