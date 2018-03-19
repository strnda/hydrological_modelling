source('R/3_AR_calibration.R')

# head(dta.cal, 4)

dta.val <- DTA[!(.id %in% unique(dta.cal[,.id])),]

Q.cal <- AR(dta.cal[,Q], best_h)
Q.val <- AR(dta.val[,Q], best_h)

model.plot(Qobs = dta.cal[, Q], Qsim = Q.cal, h = best_h, title = 'AR-model calibration')
model.plot(Qobs = dta.val[, Q], Qsim = Q.val, h = best_h, title = 'AR-model validation')

# obj <- lsf.str('NULL')
val <- data.frame(cal = sapply(obj, function(x) {do.call(x, list(Qmer = dta.cal[(best_h + 1):.N, Q], Qsim = Q.cal))}),
                  val = sapply(obj, function(x) {do.call(x, list(Qmer = dta.val[(best_h + 1):.N, Q], Qsim = Q.val))}))

round(val, digits = 10)
