source('R/1_data_import.R')
source('R/2_AR_model.R')

source('R/aux_fun/aux_objective_fun.R', local = attach(NULL))

dta.cal <- DTA[.id %in% c(2),]

# basic R approach

system.time({ # eval time
  
  ERR <- list()
  
  for(h in 1:35) {
    
    q.sim <- AR(Q = dta.cal[,Q],
                h = h)
    
    ERR[[h]] <- data.frame(
      lag = h, 
      MAE = MAE(Qmer = dta.cal[(h + 1):.N, Q],
                Qsim = q.sim),
      ME = ME(Qmer = dta.cal[(h + 1):.N, Q],
              Qsim = q.sim),
      MSDE = MSDE(Qmer = dta.cal[(h + 1):.N, Q], 
                  Qsim = q.sim),
      MSE = MSE(Qmer = dta.cal[(h + 1):.N, Q], 
                Qsim = q.sim),
      MSLE = MSLE(Qmer = dta.cal[(h + 1):.N, Q],
                  Qsim = q.sim),
      PI1 = PI1(Qmer = dta.cal[(h + 1):.N, Q],
                Qsim = q.sim),
      PLC = PLC(Qmer = dta.cal[(h + 1):.N, Q],
                Qsim = q.sim),
      R2 = R2(Qmer = dta.cal[(h + 1):.N, Q],
              Qsim = q.sim),
      R4MS4E = R4MS4E(Qmer = dta.cal[(h + 1):.N, Q],
                      Qsim = q.sim),
      RMSE = RMSE(Qmer = dta.cal[(h + 1):.N, Q],
                  Qsim = q.sim)
    )
  }
  
  err <- do.call(what = rbind, 
                 args = ERR)
})


# advanced R approach

system.time({ # eval time
  
  obj <- lsf.str('NULL')
  
  sims <- mapply(FUN = AR, 
                 h = 1:35, 
                 MoreArgs = list(dta.cal[,Q]))
  
  err <- t(sapply(X = seq_along(sims), 
                  FUN = function(X, ...) {
                    c(lag = X, 
                      sapply(obj, function(x) {
                        do.call(what = x,
                                args = list(Qmer = dta.cal[(X + 1):.N,Q], 
                                            Qsim = sims[[X]]))
                        }))
                    }))
})

# the rest

winner <- c()
for(i in 2:dim(err)[2]) {
  
  if (!(dimnames(err)[[2]][i] %in% c('R2', 'PLC', 'PI1'))) {
    number <- 0
  } else { 
    number <- 1
  }
  
  winner[i - 1] <- err[which(abs(err[,i][is.finite(err[,i])] - number) == min(abs(err[,i][is.finite(err[,i])] - number))), 1]
}

best_h <- as.numeric(names(which.max(table(winner))))

Q <- dta.cal[ ,Q]
Q.sim <- AR(Q, best_h)

ggplot() +
  geom_line(aes(x = seq_along(Q[-(1:best_h)]), y = Q[-(1:best_h)], colour = factor(1))) +
  geom_line(aes(x = seq_along(Q.sim), y = Q.sim, colour = factor(2))) +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = paste('Ideal AR-model lag =', best_h))  +
  scale_colour_manual(name = '', labels = c('Observed values', 'AR model'), values = c('steelblue4', 'red4')) +
  theme(legend.background = element_blank(), legend.position = 'top', plot.title = element_text(hjust = 0.5))
