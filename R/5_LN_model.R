LN <- function(dta, h = rev(seq_along(dta)), Q = NULL) {
  
  dta <- as.data.frame(dta)

  N <- dim(dta)[1]
  
  A <- list() 
  
  for (j in 1:dim(dta)[2]) {
    
    h.act <- h[j]
    dta.matrix <- matrix(NA, nrow = N - max(h), ncol = h.act)
    
    for (i in 1:h.act){
      dta.matrix[,i] <- dta[(max(h) + 1 - i):(N - i), j]
    }
    
    A[[j]] <- dta.matrix
  }
  matrix.A <- do.call(cbind, A)
  
  if(is.null(Q)) {
    vector.Q <- dta[max(h + 1):N, 'Q']
  } else {
    vector.Q <- Q[max(h + 1):N]
  }
  
  Beta <- solve(t(matrix.A) %*% matrix.A) %*% (t(matrix.A) %*% vector.Q)
  
  matrix.A %*% Beta
}
