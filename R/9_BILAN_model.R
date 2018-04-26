source('R/1_data_import.R')

install.packages('https://tinyurl.com/y96ujbbd', type = 'source', repo = NULL)

library(bilan)

?bilan

bil <- bil.new('d')
bil.set.values(bil, DTA[.id %in% c(2),])
bil.pet(bil,'latit', latitude = 50)
bil.set.params.init(bil, list(Spa = 115, Grd = .095))
bil.set.params.lower(bil, list(Grd = .055))
bil.set.params.upper(bil, list(Grd = .25))
bil.set.optim(bil, method = 'DE', crit = 'MSE', weight_BF = 0, max_iter = 500, init_GS = 50)
model <- bil.optimize(bil)

bil.get.values(bil)$params

ggplot(data = model) +
  geom_line(aes(x = DTM, y = R, colour = factor(1))) +
  geom_line(aes(x = DTM, y = RM, colour = factor(2))) +
  geom_line(aes(x = DTM, y = BF, colour = factor(3))) +
  scale_color_manual(values = c('steelblue', 'red4', 'limegreen'),
                     labels = c('R', 'RM', 'BF'),
                     name = '') +
  theme_bw()
