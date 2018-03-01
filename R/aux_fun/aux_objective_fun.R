ME <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res <- vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    res <- Qmer - Qsim
    me <- sum(res)/N
    return(me)
  }
}

MAE <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res <- vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    res <- abs(Qmer - Qsim)
    mae <- sum(res)/N
    return(mae)
  }
}

MSE <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res <- vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    res <- (Qmer - Qsim)^2
    mse <- sum(res)/N
    return(mse)
  }
}

MSDE <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res1 <- vector(mode = 'numeric', length = length(Qmer-1))
    res2 <- vector(mode = 'numeric', length = length(Qmer-1))
    N <- pocet_mer_dat
    res1 <- Qmer[1:N-1]-Qmer[2:N]
    res2 <- Qsim[1:N-1]-Qsim[2:N]
    msde <- (sum(res1-res2)^2)/N
    return(msde)
  }
}

MSLE <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res <- vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    ind <- Qmer>0 & Qsim>0
    qmer <- Qmer[ind]
    qsim <- Qsim[ind]
    res <- (log(Qmer) - log(Qsim))^2
    msle <- sum(res)/N
    return(msle)
  }
}

RMSE <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res <- vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    res <- (Qmer - Qsim)^2
    rmse <- (sum(res)/N)^.5
    return(rmse)
  }
}

R4MS4E <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res <- vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    res <- (Qmer - Qsim)^4
    r4ms4e <- (sum(res)/N)^.25
    return(r4ms4e)
  }
}

R2 <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    res<-vector(mode = 'numeric', length = length(Qmer))
    N <- pocet_mer_dat
    res <- (Qmer - Qsim)^2
    Qp <- (sum(Qmer))/N
    r2 <- 1-(sum(res)/(sum((Qmer-Qp)^2)))
    return(r2)
  }
}

PLC <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    N <- pocet_mer_dat
    Ql <- quantile(Qmer,0.25)
    indl <- Qmer<Ql
    qmerl <- Qmer[indl]
    qsiml <- Qsim[indl]
    Qp <- quantile(Qmer,0.75)
    indp <- Qmer>Qp
    qmerp <- Qmer[indp]
    qsimp <- Qsim[indp]
    pk <- (sum((qmerp-qsimp)^2*qmerp^2)^0.25)/((sum(qmerp^2))^(1/2))
    pl <- (sum((qmerl-qsiml)^2*qmerl^2)^0.25)/((sum(qmerl^2))^(1/2))
    plc <- pk*pl
    return(plc)
  }
}

PI1 <- function(Qmer,Qsim) {
  pocet_mer_dat <- length(Qmer)
  pocet_sim_dat <- length(Qsim)
  
  if (pocet_mer_dat != pocet_sim_dat) return('length(Qmer) != length(Qsim)')
  else{
    N <- pocet_mer_dat
    qmer <- Qmer[2:N]
    qsim <- Qsim[2:N]
    qlag <- Qmer[1:N-1]
    res1 <- (qmer-qsim)^2
    res2 <- (qmer-qlag)^2
    pi1 <- 1-((sum (res1))/(sum(res2)))
    return(pi1)
  }
}