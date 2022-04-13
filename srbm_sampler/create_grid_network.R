#-------------------------------------------------------------------------
# Creates a nrows-by-ncols four-neighbour grid graph (aka lattice graph).
#
#   INPUT:  nrows: number of rows.
#           ncols: number of columns.
#
#   OUTPUT: amat: d-by-d adjacency matrix in sparse format, where 
#                 d = nrows*ncols.
#
# Copyright (C) 2022 Johan Pensar
#-------------------------------------------------------------------------

create_grid_network <- function(n_rows, n_cols){
  
  if(min(n_rows,n_cols)<2){
    error("The minimum number of rows/columns is 2.")
  }
  d <- n_rows*n_cols
  k1 <- max(n_rows-2,0)
  k2 <- max(n_cols-2,0)
  n_edges <- (8+(k1+k2)*6+k1*k2*4)/2    
  edges <- matrix(0,n_edges,2)
  ind <- 1
  for(i in 2:n_cols){
    edges[ind,] <- c(i,i-1)
    ind <- ind+1
  }
  for(i in 1:(n_rows-1)){
    for(pos in (i*n_cols+1):((i+1)*n_cols)){
      if(pos == (i*n_cols+1)){
        edges[ind,] = c(pos,pos-n_cols)
        ind <- ind+1
      } else {
        edges[ind,] <- c(pos,pos-n_cols)
        edges[ind+1,] <- c(pos,pos-1)
        ind <- ind+2
      }
    }  
  }
  amat <- sparseMatrix(i=c(edges[,1],edges[,2]),
                       j=c(edges[,2],edges[,1]),
                       dims=c(d,d))
  return(amat) 
}