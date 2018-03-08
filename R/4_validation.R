source('R/3_calibration.R')

head(dta.cal, 4)

dta.val <- DTA[.id %in% c(1,3),]

best_h <- 22 # second best lag

Q.cal <- AR(dta.cal[,Q], best_h)
Q.val <- AR(dta.val[,Q], best_h)

ggplot() +
  geom_line(aes(x = seq_along(dta.cal[best_h:.N,Q]), y = dta.cal[best_h:.N,Q]), colour = 'steelblue4') +
  geom_line(aes(x = seq_along(Q.cal), y = Q.cal), colour = 'red4') +  
  geom_line(aes(x = seq_along(dta.cal[best_h:.N,Q] - Q.cal), y = dta.cal[best_h:.N,Q] - Q.cal), colour = 'orange') +
  theme_bw() +
  labs(x = 'Time',
       y = 'Discharge', 
       title = 'AR-model calibration', 
       subtitle = paste('Residuals min =', 
                        round(min(dta.cal[best_h:.N,Q] - Q.cal), 3),
                        '\nResiduals mean =',
                        round(mean(dta.cal[best_h:.N,Q] - Q.cal), 3),
                        '\nResiduals max =',
                        round(max(dta.cal[best_h:.N,Q] - Q.cal), 3)))

ggplot() +
  geom_line(aes(x = seq_along(dta.val[best_h:.N,Q]), y = dta.val[best_h:.N,Q]), colour = 'steelblue4') +
  geom_line(aes(x = seq_along(Q.val), y = Q.val), colour = 'red4') +
  geom_line(aes(x = seq_along(dta.val[best_h:.N,Q] - Q.val), y = dta.val[best_h:.N,Q] - Q.val), colour = 'orange') +
  theme_bw() +
  labs(x = 'Time',
       y = 'Discharge', 
       title = 'AR-model validation', 
       subtitle = paste('Residuals min =', 
                        round(min(dta.val[best_h:.N,Q] - Q.val), 3),
                        '\nResiduals mean =',
                        round(mean(dta.val[best_h:.N,Q] - Q.val), 3),
                        '\nResiduals max =',
                        round(max(dta.val[best_h:.N,Q] - Q.val), 3)))


obj <- lsf.str('NULL')
val <- data.frame(cal = sapply(obj, function(x) {do.call(x, list(Qmer = dta.cal[best_h:.N,Q], Qsim = Q.cal))}),
                  val = sapply(obj, function(x) {do.call(x, list(Qmer = dta.val[best_h:.N,Q], Qsim = Q.val))}))

round(val, digits = 10)

