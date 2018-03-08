source('R/3_calibration.R')

head(dta.cal, 3)

dta.val.1 <- DTA[.id == 1,]
dta.val.2 <- DTA[.id == 3,]

Q.cal <- AR(dta.cal[,Q], best_h)
Q.val.1 <- AR(dta.val.1[,Q], best_h)
Q.val.2 <- AR(dta.val.2[,Q], best_h)

plot(dta.cal[best_h:.N,Q], type = 'l')
lines(Q.cal, col = 'red4')
plot(dta.val.1[best_h:.N,Q], type = 'l')
lines(Q.val.1, col = 'red4')
plot(dta.val.2[best_h:.N,Q], type = 'l')
lines(Q.val.2, col = 'red4')

ME(Q.cal, dta.cal[best_h:.N,Q])
ME(Q.val.1, dta.val.1[best_h:.N,Q])
ME(Q.val.2, dta.val.2[best_h:.N,Q])
