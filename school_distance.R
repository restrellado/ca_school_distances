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
  # Remove all but Active 
  # Merged records are missing location data 
  filter(StatusType %in% c("Active")) %>% 
  select(SOC, County, District, School, Longitude, Latitude)
schools

#------------------------------------------------------------------------------

# Check for NAs 
# NAs may be school district rows 
schools %>% map(~mean(is.na(.))) 

#------------------------------------------------------------------------------

# Look at missing long and lat 
schools %>% 
  filter(is.na(Longitude)) 

#------------------------------------------------------------------------------

# Coronado Dataset 
coro <- schools %>% 
  filter(District == "Coronado Unified") %>% 
  select(School, longitude = Longitude, latitude = Latitude) 
coro

#------------------------------------------------------------------------------

# Create distance matrix 
mat <- distm(coro[, c(2, 3)], coro[, c(2,3)]) %>% 
  as.tibble() %>% 
  # Convert meters to miles
  mutate_all(funs(. * 0.000621371))
mat

#------------------------------------------------------------------------------

# Take mean of the columns, then mean of result
mean(mat %>% map_dbl(mean))