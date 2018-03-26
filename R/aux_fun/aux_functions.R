periods <- function(dta, n = 3, length = 10, start = NULL, safety.net = 100) {
  
  dta.subset <- dta[Q >= 0,]

  if(is.null(start)) year <- as.numeric(dta.subset[1,format(DTM, '%Y')]) + 1 else year <- start
  if(safety.net < n) safety.net <- n
  
  i <- 1
  x <- 0
  
  dec <- list()
  
  while (x < safety.net) {
    
    dec[[i]] <- dta.subset[DTM %between% c(as.Date(paste(year, '11-1', sep = '-')), as.Date(paste(year + length, '10-31', sep = '-')))]
    
    if(i == n) break
    if(!dim(dec[[i]])[1] < length*365) {
      
      i <- i + 1
      year <- year + length
    } else year <- year + 1
    
    x <- x + 1
  }
  
  rbindlist(dec, idcol = TRUE)
}

model.plot <- function(Qobs, Qsim, h, title = 'Model') {
  
  gg <- ggplot() +
    geom_line(aes(x = seq_along(Qobs[-(1:h)]), y = Qobs[-(1:h)]), colour = 'steelblue4') +
    geom_line(aes(x = seq_along(Qsim), y = Qsim), colour = 'red4') +
    geom_line(aes(x = seq_along(Qobs[-(1:h)] - Qsim), y = Qobs[-(1:h)] - Qsim), colour = 'orange', alpha = .5) +
    theme_bw() +
    labs(x = 'Time',
         y = 'Discharge', 
         title = title, 
         subtitle = paste('Residuals min =', 
                          round(min(Qobs[-(1:h)] - Qsim), 3),
                          '\nResiduals mean =',
                          round(mean(Qobs[-(1:h)] - Qsim), 3),
                          '\nResiduals max =',
                          round(max(Qobs[-(1:h)] - Qsim), 3)))
  
  return(gg)
}
