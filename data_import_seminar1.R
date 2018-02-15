lop <- c('data.table', 'ggplot2')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

lapply(lop, library, character.only = T)

ifelse(!dir.exists('data'), dir.create('data'), FALSE)

id <- fread('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/')[1,9]

if(length(list.files('data/')) == 0) download.file(paste0('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/', id), paste0('data/',id), method = 'auto', quiet = T)

dta.raw <- read.csv(paste0('data/', id), stringsAsFactors = F)

dta <- as.data.frame(t(apply(dta.raw, MARGIN = 1, FUN = function(x) as.numeric(substring(x, c(1,5,7,seq(9, nchar(x), 10)), c(4,6,8,seq(18, nchar(x), 10)))))))

names(dta) <- c('Y','M','D','P','E','Q','Tmax','Tmin')

dta <- data.table(DTM = as.Date(paste(dta$Y, dta$M, dta$D, sep = '-'),
                                format = '%Y-%m-%d'),
                  dta[, c('P','E','Q','Tmax','Tmin')])

head(dta)

ggplot(dta) +
  geom_line(aes(x = DTM, y = Q), colour = 'steelblue4') +
  theme_bw() +
  labs(x = 'Time', y = 'Discharge', title = id)

dta.subset <- dta[Q >= 0,]

which(diff(dta.subset$DTM) > 1)



