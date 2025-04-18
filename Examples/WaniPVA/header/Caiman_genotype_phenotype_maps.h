#include <species/add_kids/genotype_phenotype_map.h>
#include <species/inds_stochastic.h>

class fecundity_phenotype : public GenotypePhenotypeMap
	{
	public:
		fecundity_phenotype(inds *species, int phenotype_index, int index_case, int num_kids) : GenotypePhenotypeMap(species, phenotype_index, index_case, num_kids)
			{
			gen = (static_cast<inds_stochastic*> (species))->gen;
			}
	
		void calculate_phenotype(inds *species);
	};

class mortality_phenotype : public GenotypePhenotypeMap
	{
	public:
		mortality_phenotype(inds *species, int phenotype_index, int index_case, int num_kids) : GenotypePhenotypeMap(species, phenotype_index, index_case, num_kids)
			{
			gen = (static_cast<inds_stochastic*> (species))->gen;
			}
	
		void calculate_phenotype(inds *species);
	};

class irreversible_mass_at_birth : public GenotypePhenotypeMap
	{
	public:
		irreversible_mass_at_birth(inds *species, int phenotype_index, int index_case, int num_kids) : GenotypePhenotypeMap(species, phenotype_index, index_case, num_kids)
			{
			gen = (static_cast<inds_stochastic*> (species))->gen;
			}
	
		void calculate_phenotype(inds *species);
	};


class reversible_mass_at_birth : public GenotypePhenotypeMap
	{
	public:
		reversible_mass_at_birth(inds *species, int phenotype_index, int index_case, int num_kids) : GenotypePhenotypeMap(species, phenotype_index, index_case, num_kids)
			{
			gen = (static_cast<inds_stochastic*> (species))->gen;
			}
	
		void calculate_phenotype(inds *species);
	};

class egg_size : public GenotypePhenotypeMap
	{
	public:
		egg_size(inds *species, int phenotype_index, int index_case, int num_kids) : GenotypePhenotypeMap(species, phenotype_index, index_case, num_kids)
			{
			gen = (static_cast<inds_stochastic*> (species))->gen;
			}
	
		void calculate_phenotype(inds *species);
	};

class inbreeding_at_birth : public GenotypePhenotypeMap
	{
	public:
		inbreeding_at_birth(inds *species, int phenotype_index, int index_case, int num_kids) : GenotypePhenotypeMap(species, phenotype_index, index_case, num_kids)
			{
			gen = (static_cast<inds_stochastic*> (species))->gen;
			}
	
		void calculate_phenotype(inds *species);
	};
