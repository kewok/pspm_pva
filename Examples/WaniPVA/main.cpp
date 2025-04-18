#include "Caiman_Simulator.h"

#include <sstream>
#include <fstream>
#include <iostream>
#include <stdio.h>

int main(void)
	{
	Caiman_Simulator *Caiman_model;
	Caiman_model = new Caiman_Simulator();
	Caiman_model->run();
	delete Caiman_model;
	}
