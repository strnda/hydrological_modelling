Gamma <- function(Q, N, h) {
  
  Nh <- N - h
  
  mQ <- mean(Q)
  Q1 <- Q[1:Nh]
  Q2 <- Q[(1 + h):N]
  
  1/Nh*sum((Q1 - mQ)*(Q2 - mQ))
}

AR <- function(Q, h = 3) {
  
  N <- length(Q)
  
  dta.Q <- matrix(NA, nrow = N - h, ncol = h)
  for (i in 1:h){
    dta.Q[,i] <- Q[(h + 1 - i):(N - i)]
  }
  
  g <- mapply(Gamma, h = 0:h, MoreArgs = list(Q = Q, N = N))
  
  gVector <- g[2:(h + 1)]
  
  gMatrix <- matrix(NA, h, h)
  for (i in 1:h) {
    gMatrix[i, i:h] <- g[1:(h - i + 1)]
    gMatrix[i, 1:i] <- g[i:1]
  }
  
  Beta <- solve(gMatrix, gVector)
  
  dta.Q %*% Beta
}