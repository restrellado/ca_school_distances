library(tidyverse)
library(readxl) 
library(here)

#------------------------------------------------------------------------------

raw_data <- read_excel(here("data", "pubschls.xlsx"))

#------------------------------------------------------------------------------

schools <- raw_data %>% 
  # Remove all but Active 
  # Merged records are missing location data 
  filter(StatusType %in% c("Active")) %>% 
  select(SOC, County, District, School, Longitude, Latitude)
schools

#------------------------------------------------------------------------------

# Check for NAs 
schools %>% map(~mean(is.na(.))) 

#------------------------------------------------------------------------------

# Look at missing long and lat 
schools %>% 
  filter(is.na(Longitude)) 