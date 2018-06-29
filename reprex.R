library(reprex)

#------------------------------------------------------------------------------

reprex({
  library(tidyverse)
  library(geosphere)
  
  # School location data
  schools <- tibble(
    school = c("Roosevelt", "Lincoln", "Washington"), 
    long = c(-117.1873, -117.1821, -117.1454), 
    lat = c(32.69640, 32.69391, 32.64398)
  )
  
  # Create distance matrix 
  mat <- distm(schools[, c(2, 3)], schools[, c(2,3)]) %>% 
    as.tibble() %>% 
    # Convert meters to miles
    mutate_all(funs(. * 0.000621371))
  
  # Summarize by finding the mean of each row
  # then taking the mean of that value
  mean(mat %>% map_dbl(mean))  
})