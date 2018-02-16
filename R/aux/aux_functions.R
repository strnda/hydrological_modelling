periods <- function(dta, n = 3, period = 10, start.year = NULL, safety.net = 10) {
  
  dta.subset <- dta[Q >= 0,]
  year <- start.year
  if(is.null(year)) year <- as.numeric(dta.subset[1,format(DTM, '%Y')])
  
  i <- 1
  x <- 0
  
  dec <- list()
  
  while (x < safety.net) {
    
    dec[[i]] <- dta.subset[DTM %between% c(as.Date(paste(year + 1, '11-1', sep = '-')), as.Date(paste(year + 11, '10-31', sep = '-')))]
    
    if(i == n) break
    if(!dim(dec[[i]])[1] < period*365) i <- i + 1
    
    x <- x + 1
    year <- year + period
  }
  
  names(dec) <- paste('period', 1:n, sep = '_')
  rbindlist(dec, idcol = T)
}