periods <- function(dta, n = 3, length = 10, start = NULL, safety.net = 100) {
  
  dta.subset <- dta[Q >= 0,]

  if(is.null(start)) year <- as.numeric(dta.subset[1,format(DTM, '%Y')]) + 1 else year <- start
  if(safety.net < n) safety.net <- n
  
  i <- 1
  x <- 0
  
  dec <- list()
  
  while (x < safety.net) {
    
    dec[[i]] <- dta.subset[DTM %between% c(as.Date(paste(year, '11-1', sep = '-')), as.Date(paste(year + length, '10-31', sep = '-')))]
    
    if(i == n) break
    if(!dim(dec[[i]])[1] < length*365) {
      
      i <- i + 1
      year <- year + length
    } else year <- year + 1
    
    x <- x + 1
  }
  
  rbindlist(dec, idcol = T)
}

data.matrix <- function(Q, h) {
  
  N <- length(cal.q)
  
  dta.Q <- matrix(NA, nrow = N - h, ncol = h) 
  
  for (i in 1:h){
    dta.Q[,i] <- cal.q[(h + 1 - i):(N - i)]
  }
  
  dta.Q
}

Gamma <- function(Q, h) {
  
  N <- length(Q)
  Nh <- N - h
  
  mQ <- mean(Q)
  Q_1 <- Q[1:Nh]
  Q_2 <- Q[(1 + h):N]
  
  1/Nh*sum((Q_1 - mQ)*(Q_2 - mQ))
}