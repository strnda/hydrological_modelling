source('R/1_data_import.R')

install.packages('https://tinyurl.com/y2fvb5uj', type = 'source', repo = NULL)

library(bilan)

?bilan

dta <- DTA[.id %in% c(2),]
dta[,T := mean(c(Tmax, Tmin)), by = DTM]
names(dta)[which(names(dta) == 'Q')] <- 'R'

bil <- bil.new('d')
bil.set.values(bil, dta)
bil.pet(bil,'latit', latitude = 50)
bil.set.params.init(bil, list(Spa = 115, Grd = .095))
bil.set.params.lower(bil, list(Grd = .055))
bil.set.params.upper(bil, list(Grd = .25))
bil.set.optim(bil, method = 'DE', crit = 'MSE', weight_BF = 0, max_iter = 500, init_GS = 0)
model <- bil.optimize(bil)

bil.get.values(bil)$params

model.plot(model$R, model$RM, h = 0)

ggplot(data = model) +
  geom_line(aes(x = DTM, y = R, colour = factor(1))) +
  geom_line(aes(x = DTM, y = RM, colour = factor(2))) +
  geom_line(aes(x = DTM, y = BF, colour = factor(3))) +
  scale_color_manual(values = c('steelblue', 'red4', 'limegreen'),
                     labels = c('R', 'RM', 'BF'),
                     name = '') +
  theme_bw()
