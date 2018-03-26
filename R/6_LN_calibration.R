source('R/1_data_import.R')
source('R/5_LN_model.R')
source('R/aux_fun/aux_objective_fun.R')

fit.LN <- function(dta,
                   crit = function(x, y) 1 - R2(x, y),
                   control = DEoptim.control(itermax = 50),
                   lower = rep(1, dim(dta)[2]),
                   upper = rep(15, dim(dta)[2]),
                   fnMap = function(z) round(z)){
  
  dta <- as.data.frame(dta)
  
  sim <- function(w){
    
    res.sim <- LN(dta = dta, h = w)
    res.obs <- dta[-(1:max(w)),'Q']
    
    crit(res.obs, res.sim)
  }
  
  DEoptim(sim, lower = lower, upper = upper, control = control, fnMap = fnMap)							
  
}

dta.cal <- DTA[.id %in% c(2), .(Q, P, Tmax)]

para <- fit.LN(dta.cal, crit = function(x, y) 1 - PLC(x, y))

ggplot(melt(para$member$bestmemit)) +
  geom_line(aes(x = Var1, y = value, colour = Var2)) +
  scale_color_manual(values = c('red4','steelblue4','green4'), labels = paste('Lag', 1:3),name = '') +
  labs(x = 'Iteration', y = 'Value', title = 'Parameter values') +
  theme_classic()

ggplot() +
  geom_line(aes(x = seq_along(para$member$bestvalit), y = para$member$bestvalit), colour = 'red4') +
  labs(x = 'Iteration', y = 'Value', title = 'Objective function values') +
  theme_classic()

Q.cal <- LN(dta.cal, para$optim$bestmem)

model.plot(Qobs = dta.cal[, Q], Qsim = Q.cal, h = max(para$optim$bestmem))

