source('R/1_data_import.R')
source('R/5_linear_model.R')
source('R/aux_fun/aux_objective_fun.R')

fit.lm <- function(dta,
                   crit = function(x, y) 1 - R2(x, y),
                   control = DEoptim.control(itermax = 50),
                   lower = rep(1, dim(dta)[2]),
                   upper = rep(15, dim(dta)[2]),
                   fnMap = function(z) round(z)){
  
  dta <- as.data.frame(dta)
  
  sim <- function(w){
    
    res.sim <- as.vector(LN(dta = dta, h = w))
    res.obs <- unlist(dta[-(1:max(w)),'Q'])
    
    crit(res.obs, res.sim)
  }
  
  DEoptim(sim, lower = lower, upper = upper, control = control, fnMap = fnMap)							
  
}

dta.cal <- DTA[.id %in% c(2), .(Q, P, E)]

best.para <- fit.lm(dta.cal)

para.history <- melt(best.para$member$bestmemit)

ggplot(para.history) +
  geom_line(aes(x = Var1, y = value, colour = Var2)) +
  scale_color_manual(values = c('red4','steelblue4','green4')) +
  theme_classic()

Q.cal <- LN(dta.cal, best.para$optim$bestmem)

model.plot(Qobs = dta.cal[, Q], Qsim = Q.cal, h = max(best.para$optim$bestmem))
