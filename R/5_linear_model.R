source('R/1_data_import.R')

dta.lin <- as.data.frame(DTA[.id %in% c(2), .(Q, P, E)])

# h <- rev(seq_along(dta.lin))
h <- c(30, 15, 8)

N <- dim(dta.lin)[1]

A <- list() 

for (j in 1:dim(dta.lin)[2]) {
  
  h.act <- h[j]
  dta.matrix <- matrix(NA, nrow = N - max(h) + 1, ncol = h.act)
  
  for (i in 1:h.act){
    dta.matrix[,i] <- dta.lin[(max(h) + 1 - i):(N - i + 1), j]
  }
  
  A[[j]] <- dta.matrix
}
matrix.A <- do.call(cbind, A)

vector.Q <- dta.lin[max(h):N, 'Q']

Beta <- solve(t(matrix.A) %*% matrix.A) %*% (t(matrix.A) %*% vector.Q)

Q.sim <- matrix.A %*% Beta

plot(vector.Q, type = 'l', main = range(vector.Q - Q.sim))
lines(Q.sim, col = 'red4', lty = 2)
lines((vector.Q - Q.sim), col = 'orange')
