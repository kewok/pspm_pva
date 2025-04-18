prelim <- function(num_demes)
	{
	ans <- paste("number_of_demes =", num_demes, "\n")
	}


reformulate_parameter_names <- function(x)
	{
	paste("\"",x,"\",",sep="")
	}

create_vector_list <- function(x, vector_list_name)
	{
	ans <- ""
	if (length(x) > 0)
		{
		if (length(x) > 1)
			{
			setup_answer <- sapply(x[1:(length(x)-1)], reformulate_parameter_names, USE.NAMES=F)
			
			ans <- c(ans, paste("\t\t",vector_list_name," = [",sep=""), setup_answer, paste("\"", x[length(x)], "\"",sep=""),"]\n\n")
			}
		else
			{
			ans <- c(paste("\t\t",vector_list_name," = [",sep=""),paste("\"", x[1],"\"",sep=""), "]\n\n")
			}
		}
	return(ans)
	}

create_vector_list_numeric <- function(x, vector_list_name)
	{
	ans <- ""
	if (length(x) > 0)
		{
		if (length(x) > 1)
			{
			setup_answer <- paste(x[1:(length(x)-1)],",",sep="")
			
			ans <- c(ans, paste("\t\t",vector_list_name," = [",sep=""), setup_answer, x[length(x)],"]\n\n")
			}
		else
			{
			ans <- c(paste("\t\t",vector_list_name," = [",sep=""),x[1], "]\n\n")

			}
		}
	return(ans)
	}

order_equations <- function(index, param_names, parameter_matrix)
	{
	ans <- character()
	num_params <- length(param_names)

	if (is.matrix(parameter_matrix)) # I'm not sure how to do function overloading in R
		{
		param_values <- parameter_matrix[index,]

		for (i in 1:num_params)
			{
			ans[i] <- paste("\t\t", param_names[i], "= ",sprintf("%f", param_values[i]), "\n")
			}
		}

	if (!is.matrix(parameter_matrix))
		{
		for (i in 1:num_params)
			{
			param_values <- parameter_matrix[[i]]
			if (is.matrix(param_values)==FALSE)
				{
				ans[i] <- paste("\t\t", param_names[i], "= ",sprintf("%f", param_values[index]), "\n")
				}

			# when matrices are used, the parameter values are represented as arrays

			if (is.matrix(param_values)==TRUE)
				{
				ansTemp <- character()
				ansTemp[1] <- paste("\t\t", param_names[i], "= [")

				for (j in 1:ncol(param_values))
					{
					if (j < ncol(param_values))
						{
						ansTemp[j+1] <- sprintf("%f,", param_values[index,j])
						}
					else
						{
						ansTemp[j+1] <- sprintf("%f", param_values[index,j])
						}
					}
				ansTemp[ncol(param_values) + 2] <- paste("]\n")
				ans[i] <- paste(ansTemp,collapse="")
				}
			}
		}
	return(paste(ans,collapse=""))
	}


