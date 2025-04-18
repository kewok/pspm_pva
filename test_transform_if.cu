#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/device_vector.h>
#include <iostream>
//thrust::transform_if(species->status.begin(), species->status.begin() + size, species->age.begin(), add_one, is_not_zero());


int main(void)
	{
	const int N=10;
	thrust::device_vector<int> increment(N);
	thrust::device_vector<int> status(N);

	for (int i=0; i < 10; i++)
		{
		if ((i % 2)==0)
			status[i] = 1;
		else
			status[i] = 0;
		}

	thrust::fill(increment.begin(), increment.end(), 1);
	
	thrust::device_vector<int> age(N);
	thrust::sequence(age.begin(), age.end(), 1);

	for (int i=0; i < 10; i++)
		{
		std::cout << status[i] << " " << increment[i] << " " << age[i] << std::endl;
		}
	thrust::identity<int> identity;

	thrust::transform_if(age.begin(), age.begin()+N, increment.begin(), status.begin(), age.begin(), thrust::plus<int>(), identity);

	for (int i=0; i < 10; i++)
		{
		std::cout << status[i] << " " << increment[i] << " " << age[i] << std::endl;
		}
	}
