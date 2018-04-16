source('R/6_LN_calibration.R')

source('R/aux_fun/aux_objective_fun.R', local = attach(NULL))

obj <- lsf.str('NULL')

dta.val <- DTA[!(.id %in% unique(dta.cal[,.id])),]

para <- para$optim$bestmem

Q.cal <- LN(dta.cal[,.(Q, P)], para)
Q.val <- LN(dta.val[,.(Q, P)], para)

model.plot(Qobs = dta.cal[, Q], Qsim = Q.cal, h = max(para), title = 'LN-model calibration')
model.plot(Qobs = dta.val[, Q], Qsim = Q.val, h = max(para), title = 'LN-model validation')

val <- data.frame(cal = sapply(obj, function(x) {do.call(x, list(Qmer = dta.cal[-(1:max(para)), Q], Qsim = Q.cal))}),
                  val = sapply(obj, function(x) {do.call(x, list(Qmer = dta.val[-(1:max(para)), Q], Qsim = Q.val))}))

round(val, digits = 10)
