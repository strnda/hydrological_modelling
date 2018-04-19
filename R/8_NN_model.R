source('R/1_data_import.R')

library(AMORE)

dta.matrix <- function(dta, h = rev(seq_along(dta))) {
  
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
  
  do.call(cbind, A)
}

dta.cal <- DTA[.id %in% 2,]

NN.dta <- dta.matrix(dta.cal[,.(Q, P)])

net.start <- newff(n.neurons = c(dim(NN.dta)[2], 10, 5, 3, 1),      
                   learning.rate.global = 1e-5,        
                   momentum.global = 0.09,              
                   error.criterium = 'LMS',           
                   Stao = NA,
                   hidden.layer = 'tansig',   
                   output.layer = 'purelin',           
                   method = 'ADAPTgdwm') 

NN.train <- train(net.start, NN.dta, dta.cal[-(1:(dim(dta.cal)[1] - dim(NN.dta)[1])), Q], error.criterium = 'LMS', report = TRUE, show.step = 100, n.shows = 5)

NN.sim <- as.vector(sim(NN.train$net, NN.dta))

model.plot(dta.cal[-(1:(dim(dta.cal)[1] - dim(NN.dta)[1])), Q], NN.sim, h = dim(dta.cal)[1] - dim(NN.dta)[1])
