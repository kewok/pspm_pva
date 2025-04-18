#include <species/update/updatebehavior.h>
#include "update_Caiman.h"

UpdateBehavior *UpdateBehavior::create_updateBehavior(inds_stochastic **species, environment *habitat, int species_ID)
	{
	if (species_ID==0)
		return new update_Caiman(species[0], habitat);
	}
