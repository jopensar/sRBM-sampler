#-------------------------------------------------------------------------
# An sRBM based Gibbs sampler for generating observations from a pairwise
# Markov network over d binary variables (with outcomes 0,1). The
# parameters are defined such that outcome 0 is the baseline category. For
# more details, see
#
# Pensar et al (2020) "High-dimensional structure learning of  binary pairwise 
# Markov networks: A comparative numerical study". Computational Statistics &
# Data Analysis.
#
#   INPUT:  A: d-by-d symmetric coupling matrix.
#           b: d-by-1 bias parameter vector.
#           n_obs: number of observations to generate.
#           n_burnin: number of burn-in iterations.
#           n_thinning: number of thinning iterations between samples.
#           sparse: if TRUE, the W matrix is in sparse format (needed for large networks)
#
#   OUTPUT: data: n_obs-by-d data matrix.
#
# Copyright (C) 2022 Johan Pensar
#-------------------------------------------------------------------------

srbm_sampler <- function(A, b, n_obs, n_burnin, n_thinning, sparse=FALSE){
  d <- length(b)
  
  # Extract the edge potentials from coupling matrix
  edges <- which(A!=0, arr.ind=TRUE)
  edges <- edges[edges[,1]<edges[,2],]
  n_edges <- nrow(edges)
  cval <- A[edges]
  
  # Construct the W matrix containing the coupling parameters between the
  # binary variables X and the Gaussian auxiliary variables Y.
  if(sparse == TRUE){
  W <- sparseMatrix(i=c(1:n_edges,1:n_edges),
                    j=c(edges[,1],edges[,2]), 
                    x=c(sqrt(abs(cval)),sqrt(abs(cval))*sign(cval)),
                    dims=c(n_edges,d))
  } else {
    W <- matrix(0,n_edges,d)
    W[cbind(1:n_edges,edges[,1])] <- sqrt(abs(cval))
    W[cbind(1:n_edges,edges[,2])] <- sqrt(abs(cval))*sign(cval)
  }
  
  # Adjust b to get the correct node potentials.   
  b <- b-0.5*diag(t(W)%*%W)
  
  # Run the burn-in chain.
  x <- (runif(d)<0.5)*1 # Random initial configuration.
  for(i in 1:n_burnin){
    y <- W%*%x+rnorm(n=n_edges, mean=0, sd=1) # Sample y given x
    m <- exp(t(W)%*%y+b)
    x <- (m/(m+1)) > runif(d) # Sample x given y
  }

  # Run the main sampling chain
  data <- matrix(0,n_obs,d)
  pos <- 1
  skip <- 0
  while(pos <= n_obs){
    y <- W%*%x+rnorm(n=n_edges, mean=0, sd=1) # Sample y given x
    m <- exp(t(W)%*%y+b)
    x <- (m/(m+1)) > runif(d) # Sample x given y
    if(skip == n_thinning){
      print(paste("Sample ", pos," out of ",n_obs, ".", sep=""))
      data[pos,] <- as.matrix(x)
      pos <- pos+1
      skip <- 0
    } else {
      skip <- skip+1  
    }
  }
  return(data)
}