source("Util/conf_file_base.R") # used to get order_equations

# Setup the deme_wise classification

create_demes <- function(param_names, deme_specific_matrix, num_demes=0)
	{
	if (num_demes==0)
		{
		num_demes <- nrow(deme_specific_matrix)
		}
	ans <- ""
	
	for (i in 1:(num_demes-1))
		{
		start <-  paste("\t\t{#deme",i-1, "\n",sep="")
		end <- "\t\t},\n\n"
		ans <- c(ans, start, order_equations(i, param_names, deme_specific_matrix), end)
		}

	# for the last deme
	i <- num_demes
	start <-  paste("\t\t{#deme",i-1, "\n",sep="")
	end <- "\t\t}\n"
	ans <- c(ans, start, order_equations(i, param_names, deme_specific_matrix), end)

	return(paste(ans,collapse=""))
	}

# cat(create_demes(c("Variable_1","Variable_2"),matrix(1:4,nrow=2)))

