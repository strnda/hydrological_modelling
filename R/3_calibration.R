source('R/1_data_import.R')
source('R/2_AR_model.R')

source('R/aux_fun/aux_objective_fun.R', local = attach(NULL))

dta.cal <- DTA[.id == 1,]

# basic R approach

ERR <- list()

for(h in 1:35) {
  
  q.sim <- AR(dta.cal[,Q], h)
  ERR[[h]] <- data.frame(lag = h, 
                         MAE = MAE(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         ME = ME(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         MSDE = MSDE(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         MSE = MSE(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         MSLE = MSLE(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         PI1 = PI1(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         PLC = PLC(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         R2 = R2(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         R4MS4E = R4MS4E(Qmer = dta.cal[h:.N,Q], Qsim = q.sim),
                         RMSE = RMSE(Qmer = dta.cal[h:.N,Q], Qsim = q.sim))
}

# advanced R approach

obj <- lsf.str('NULL')
ERR <- list()

for(h in 1:35) {
  
  q.sim <- AR(dta.cal[,Q], h)
  ERR[[h]] <- c(lag = h, sapply(obj, function(x) {do.call(x, list(Qmer = dta.cal[h:.N,Q], Qsim = q.sim))}))
}

# the rest

err <- do.call(rbind, ERR)

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
  geom_line(aes(x = seq_along(Q[-best_h]), y = Q[-best_h], colour = factor(1))) +
  geom_line(aes(x = seq_along(Q.sim), y = Q.sim, colour = factor(2))) +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = paste('Ideal AR-model lag =', best_h))  +
  scale_colour_manual(name = '', labels = c('Observed values', 'AR model'), values = c('steelblue4', 'red4')) +
  theme(legend.background = element_blank(), legend.position = 'top', plot.title = element_text(hjust = 0.5))
