source('R/aux_fun/aux_functions.R')

# zmena je zivot

lop <- c('data.table', 'ggplot2', 'DEoptim', 'AMORE')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

temp <- lapply(lop, library, character.only = T)
rm(temp)

id <- '04201500'

dta <- as.data.table(read.fwf(sprintf('ftp://nero.hwr.arizona.edu/mopex/MOPEX_daily/%s.dly', id), 
                              widths = c(8, 10, 10, 10, 10, 10)))

names(dta) <- c('DTM', 'P', 'E', 'Q', 'Tmax', 'Tmin')

dta[, DTM := as.Date(gsub(' ','0', DTM), format = '%Y%m%d')]

ggplot(dta) +
  geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = id)

DTA <- periods(dta)
