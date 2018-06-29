library(tidyverse)
library(readxl) 
library(here)
library(geosphere)

#------------------------------------------------------------------------------

# TODO: Resolve data related warnings 
raw_data <- read_excel(here("data", "pubschls.xlsx")) %>% 
  mutate_at(vars(Longitude, Latitude), funs(as.numeric))

#------------------------------------------------------------------------------

schools <- raw_data %>% 
  # Remove all but Active and remove district entries
  # Merged records are missing location data 
  filter(StatusType %in% c("Active"), !is.na(School)) %>% 
  select(SOC, County, District, School, Longitude, Latitude) %>% 
  split(.$District) 

#------------------------------------------------------------------------------

# Function 

calc_dist <- function(data) {
  # Summarizes distances between schools 
  #   Args
  #    data: a tibble of school locations from CDE 
  #   Returns 
  #    Mean of distance matrix rows 
  data <- data %>% 
    # Remove district row
    filter(!is.na(School)) %>% 
    select(School, longitude = Longitude, latitude = Latitude) 
  
  # Create distance matrix 
  mat <- distm(data[, c(2, 3)], data[, c(2,3)]) %>% 
    as.tibble() %>% 
    # Convert meters to miles
    mutate_all(funs(. * 0.000621371))
  
  # Take mean of the columns, then mean of result
  mean(mat %>% map_dbl(mean)) 
}

#------------------------------------------------------------------------------

# Map calc_dist across all districts 
# Output as dataframe
distances <- schools %>% map_dbl(calc_dist) %>% enframe()