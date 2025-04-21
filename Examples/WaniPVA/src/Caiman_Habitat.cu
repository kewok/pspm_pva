#include "Caiman_Habitat.h"

Caiman_Habitat::Caiman_Habitat(int seed_val, int num_biotic_variables, int num_abiotic_variables, int num_demes, int num_time_steps) : environment(seed_val,  num_biotic_variables, num_abiotic_variables, num_demes)
	{
	prey_array = new prey *[nbiotic_vars];

	for (int prey_type = 0; prey_type < nbiotic_vars; prey_type++)
		{
		prey_array[prey_type] = new prey(num_demes, prey_type, seed_val + prey_type, num_time_steps);
		prey_array[prey_type]->specify_prey_properties_by_deme();
		thrust::copy(prey_array[prey_type]->prey_abundance.begin(), prey_array[prey_type]->prey_abundance.begin() + num_demes, biotic_variables[prey_type].begin());
		}

	intra_annual_time_steps = num_time_steps;
	current_time_step = 0;
	initialize_abiotic_variables("environment_config.txt");
	}

void Caiman_Habitat::update_prey()
	{
	for (int prey_type = 0; prey_type < nbiotic_vars; prey_type++)
		{
		prey_array[prey_type]->update_prey_abundance(effect_of_inds_on_biotic_variable[prey_type]);
		
		// Prepare interface
		thrust::copy(prey_array[prey_type]->prey_abundance.begin(), prey_array[prey_type]->prey_abundance.begin() + ndemes, biotic_variables[prey_type].begin());

		// Flush predator effects
		thrust::fill(effect_of_inds_on_biotic_variable[prey_type].begin(), effect_of_inds_on_biotic_variable[prey_type].end(), 0);
		}
	current_time_step++;
	}

void Caiman_Habitat::update()
	{
	int init_temp_index = abiotic_variable_indices["initial_temperature"];
	int max_temp_index = abiotic_variable_indices["maximum_temperature"];
	int temp_change_index = abiotic_variable_indices["temperature_change"];
	thrust::for_each(
			thrust::make_zip_iterator(thrust::make_tuple(abiotic_variables[init_temp_index].begin(), abiotic_variables[max_temp_index].begin(), abiotic_variables[temp_change_index].begin())),
			thrust::make_zip_iterator(thrust::make_tuple(abiotic_variables[init_temp_index].begin() + ndemes, abiotic_variables[max_temp_index].begin() + ndemes, abiotic_variables[temp_change_index].begin() + ndemes)),
			temperature_update());
	
	thrust::for_each(
			thrust::make_zip_iterator(thrust::make_tuple(get_abiotic_vector_ptr("nest_ceiling"),
get_abiotic_vector_ptr("nest_change"))), 							
			thrust::make_zip_iterator(thrust::make_tuple(get_abiotic_vector_ptr("nest_ceiling") + ndemes,
get_abiotic_vector_ptr("nest_change") + ndemes)), 
			nesting_update());

	for (int prey_type=0; prey_type < nbiotic_vars; prey_type++)
		{
		prey_array[prey_type]->update_prey_density_dependence();
		prey_array[prey_type]->update_prey_growth_noise();
		}
	}

void Caiman_Habitat::initialize_abiotic_variables(const char *filename)
	{
	Config cfg;

	try
		{
		cfg.readFile(filename);	
		}
	catch(const FileIOException &fioex)
		{
		std::cerr << "No environment config file." << std::endl;
		}
	
	const Setting& root = cfg.getRoot();
	// Read in abiotic input from environmental config file

	const Setting &abiotic_variable_specification = root["abiotic_variable_names"];

	// TODO: add a check for whether lenVal = nabiotic_vars

	int lenVal = abiotic_variable_specification.getLength();

	abiotic_variable_names.resize(lenVal);
	
	for (int i=0; i < abiotic_variable_specification.getLength(); i++)
		{
		abiotic_variable_names[i] = abiotic_variable_specification[i].c_str();
		}

	// Read in the abiotic values

	const Setting &abiotic_variable_values = root["abiotic_variable_initialization"];

	abiotic_variables = new thrust::device_vector<float>[nabiotic_vars];

	for (int i=0; i < nabiotic_vars; i++)
		{
		abiotic_variables[i].resize(ndemes);
		}

	
	for (int i=0; i < abiotic_variable_names.size(); i++)
		{
		for (int j=0; j < ndemes; j++)
			{
			const Setting &deme_values = abiotic_variable_values[j];
			float val = 0;
			deme_values.lookupValue(abiotic_variable_names[i], val);
			abiotic_variables[i][j] = val;
			}
		}


	// Specify the abiotic variable indices
	for (int i=0; i < nabiotic_vars; i++)
		{
		abiotic_variable_indices[abiotic_variable_names[i]] = i;
		}
	}
