source('R/aux/imports.R')

lop <- c('data.table', 'ggplot2')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

lapply(lop, library, character.only = T)

id <- '01048000'

dta <- as.data.table(read.fwf(sprintf('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/%s.dly', id), widths = c(8,10,10,10,10,10)))

names(dta) <- c('DTM', 'P', 'E', 'Q', 'Tmax', 'Tmin')

dta[, DTM := as.Date(gsub(' ','0', DTM), format = '%Y%m%d')]

# head(dta)

ggplot(dta) +
  geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = id)

# dta.test <- periods(dta, n = 3, length = 5)
# 
# ggplot(dta.test) +
#   geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
#   theme_bw() +
#   labs(x = 'Time', y = 'Discharge', title = id) +
#   facet_wrap(~.id, scales = 'free', ncol = 1)

DTA <- periods(dta)

cal.q <- DTA[.id == 1, Q]

h <- 5

# g <- mapply(Gamma, h = 0:h, MoreArgs = list(Q = cal.q))
# 
# g.vector <- g[1:h]
# 
# g.matrix <- 