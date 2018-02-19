source('R/aux/imports.R')

lop <- c('data.table', 'ggplot2')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

lapply(lop, library, character.only = T)

if(!dir.exists('data')) dir.create('data')

id <- fread('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/')[1,9]

if(!file.exists(paste0('data/', id))) download.file(paste0('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/', id), paste0('data/',id), method = 'auto', quiet = T)

dta.raw <- read.csv(paste0('data/', id), stringsAsFactors = F)

dta <- as.data.frame(t(apply(dta.raw, MARGIN = 1, FUN = function(x) as.numeric(substring(x, c(1,5,7,seq(9, nchar(x), 10)), c(4,6,8,seq(18, nchar(x), 10)))))))

names(dta) <- c('Y','M','D','P','E','Q','Tmax','Tmin')

dta <- data.table(DTM = as.Date(paste(dta$Y, dta$M, dta$D, sep = '-'), format = '%Y-%m-%d'), dta[, c('P','E','Q','Tmax','Tmin')])

head(dta)

ggplot(dta) +
  geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = id)

dta.test <- periods(dta, n = 20, length = 5, safety.net = 20)

ggplot(dta.test) +
  geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = id) +
  facet_wrap(~.id, scales = 'free', ncol = 1)

DTA <- periods(dta)

cal_q <- DTA[.id == 1, Q]

h <- 3
N <- length(cal_q)

dta_Q <- matrix(NA, nrow = N - h, ncol = h) 

for (i in 1:h){
  dta_Q[,i] <- cal_q[(h + 1 - i):(N - i)]
}

matplot(dta_Q, type = 'l')
