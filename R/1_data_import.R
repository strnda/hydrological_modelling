source('R/aux_fun/imports.R')

lop <- c('data.table', 'ggplot2')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

lapply(lop, library, character.only = T)

id <- '01048000'

dta <- as.data.table(read.fwf(sprintf('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/%s.dly', id), widths = c(8,10,10,10,10,10)))

names(dta) <- c('DTM', 'P', 'E', 'Q', 'Tmax', 'Tmin')

dta[, DTM := as.Date(gsub(' ','0', DTM), format = '%Y%m%d')]

ggplot(dta) +
  geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = id)

DTA <- periods(dta)

cal.q <- DTA[.id == 1, Q]

h <- 2
N <- length(Q)

dta.Q <- matrix(NA, nrow = N - h + 1, ncol = h)
for (i in 1:h){
  dta.Q[,i] <- Q[(h + 1 - i):(N - i + 1)]
}

Gamma <- function(Q, h) {
  
  N <- length(Q)
  Nh <- N - h
  
  mQ <- mean(Q)
  Q1 <- Q[1:Nh]
  Q2 <- Q[(1 + h):N]
  
  1/Nh*sum((Q1 - mQ)*(Q2 - mQ))
}

g <- mapply(Gamma, h = 0:h, MoreArgs = list(Q = Q))

gVector <- g[2:(h + 1)]

gMatrix <- matrix(NA, h, h)
for (i in 1:h) {
  gMatrix[i, i:h] <- g[1:(h - i + 1)]
  gMatrix[i, 1:i] <- g[i:1]
}

Beta <- solve(gMatrix, gVector)

simQ <- dta.Q %*% Beta

ggplot() +
  geom_line(aes(x = seq_along(Q), y = Q), colour = 'steelblue4') +
  geom_line(aes(x = seq_along(simQ), y = simQ), colour = 'red4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = 'AR model')
