# In addition to these header files, you will need to add the header file for the species you are simulating, e.g., 
# -I/.header/species/my_species
HEADERS = -I./../../header/ -I./header 

CFLAGS = -Xcompiler
CFLAGS += -O3

SRC = ./src

OBJDIR_SPEGG = ./../../objdir
OBJDIR = objdir

all: $(OBJDIR) a.out

export LD_LIBRARY_PATH=/usr/local/lib /usr/local/cuda/lib

a.out : $(OBJDIR_SPEGG)/*.o $(OBJDIR)/main.o $(OBJDIR)/genotype_phenotype_map.o $(OBJDIR)/UpdateBehavior.o $(OBJDIR)/Caiman_Habitat.o $(OBJDIR)/Caiman_genotype_phenotype_maps.o $(OBJDIR)/Caiman_Simulator.o $(OBJDIR)/Caiman.o $(OBJDIR)/prey_class.o $(OBJDIR)/prey_deme_specific_data.o $(OBJDIR)/update_Caiman.o $(OBJDIR)/Caiman_Parents.o
	nvcc -Xcompiler -O3 -lcurand -lrt -lcuda -lconfig++ $(OBJDIR_SPEGG)/*.o $(OBJDIR)/main.o $(OBJDIR)/genotype_phenotype_map.o $(OBJDIR)/UpdateBehavior.o $(OBJDIR)/Caiman_Habitat.o $(OBJDIR)/Caiman_genotype_phenotype_maps.o $(OBJDIR)/Caiman_Simulator.o $(OBJDIR)/Caiman.o $(OBJDIR)/prey_class.o $(OBJDIR)/prey_deme_specific_data.o $(OBJDIR)/update_Caiman.o $(OBJDIR)/Caiman_Parents.o

$(OBJDIR):
	mkdir $(OBJDIR)

# Compilation instructions:

$(OBJDIR)/main.o : main.cpp 
	nvcc -c $(CFLAGS) ${HEADERS} main.cpp -o $(OBJDIR)/main.o

$(OBJDIR)/UpdateBehavior.o : ${SRC}/UpdateBehavior.cu
	nvcc -c $(CFLAGS) ${HEADERS}  ${SRC}/UpdateBehavior.cu -o $(OBJDIR)/UpdateBehavior.o

$(OBJDIR)/genotype_phenotype_map.o : ${SRC}/genotype_phenotype_map.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/genotype_phenotype_map.cu -o $(OBJDIR)/genotype_phenotype_map.o

$(OBJDIR)/Caiman_Habitat.o : ${SRC}/Caiman_Habitat.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/Caiman_Habitat.cu -o $(OBJDIR)/Caiman_Habitat.o

$(OBJDIR)/prey_deme_specific_data.o : ${SRC}/prey_deme_specific_data.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/prey_deme_specific_data.cu -o $(OBJDIR)/prey_deme_specific_data.o

$(OBJDIR)/prey_class.o : ${SRC}/prey_class.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/prey_class.cu -o $(OBJDIR)/prey_class.o

$(OBJDIR)/Caiman_genotype_phenotype_maps.o : ${SRC}/Caiman_genotype_phenotype_maps.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/Caiman_genotype_phenotype_maps.cu -o $(OBJDIR)/Caiman_genotype_phenotype_maps.o

$(OBJDIR)/Caiman.o : ${SRC}/Caiman.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/Caiman.cu -o $(OBJDIR)/Caiman.o

$(OBJDIR)/update_Caiman.o : ${SRC}/update_Caiman.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/update_Caiman.cu -o $(OBJDIR)/update_Caiman.o

$(OBJDIR)/Caiman_Parents.o : ${SRC}/Caiman_Parents.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/Caiman_Parents.cu -o $(OBJDIR)/Caiman_Parents.o

$(OBJDIR)/Caiman_Simulator.o : ${SRC}/Caiman_Simulator.cu
	nvcc -c $(CFLAGS) ${HEADERS} ${SRC}/Caiman_Simulator.cu -o $(OBJDIR)/Caiman_Simulator.o

# Code related to the clean command.
.PHONY : all clean
clean :
	@rm -rf $(OBJDIR) a.out
