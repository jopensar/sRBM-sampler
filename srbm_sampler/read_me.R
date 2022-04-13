#-------------------------------------------------------------------------
#
# Step-by-step instructions on how to sample a binary pairwise Markov 
# network using the function srbm_sampler().
#
#-------------------------------------------------------------------------

# Load Matrix package for sparse matrix format
library(Matrix)
  
### Step 1 
# Create adjacency matrix of a 100-by-100 grid network (=> 10,000 nodes).

n_rows <- 100
n_cols <- 100
d <- n_rows*n_cols
amat <- create_grid_network(n_rows,n_cols) # function included in the repo.

### Step 2
# Generate a d-by-d coupling matrix 'A' (sparse format) and d-by-1 bias 
# parameter vector 'b'.

# Sample coupling parameters from Uniform(-2,2). 
edges <- which(amat, arr.ind=TRUE)
edges <- edges[edges[,1]<edges[,2],]
temp <- (runif(nrow(edges))-0.5)*4
A <- sparseMatrix(i=c(edges[,1],edges[,2]),
                  j=c(edges[,2],edges[,1]),
                  x=c(temp,temp),
                  dims=c(d,d))

# Sample bias parameters from Uniform(-1,1).
b <- 2*(runif(d)-0.5)

### Step 3
# Generate 1000 observations from the specified model using a burn-in of 
# 5000 samples and a thinning of 100 samples.

# Specify the input parameters.
n_obs <- 1000
n_burnin <- 5000
n_thinning <- 100

# Run the sampler, should take around 8-9 minutes on a standard computer.
# NOTE: for smaller networks (100 nodes and smaller), try setting sparse=FALSE
tic <- Sys.time()
data <- srbm_sampler(A,b,n_obs,n_burnin,n_thinning,sparse=TRUE) 
toc <- Sys.time()
toc-tic