# Home Path
getwd()
path<-getwd()

#Config for the number of packages used for analysis
packages_used<-c("knitr","ggplot2","dplyr","naniar","stringr","ggrepel","htmlwidgets","leaflet","shiny",
                 "ggrepel")

# File names
file_airbnb <- "listings.csv"
file_zillow <- "Zip_Zhvi_2bedroom.csv"

# Scale the number of bedrooms assumption (Change to check for apartments with different bedrooms)
num_bed <- c(2)

# Scale the city to be analysed (Change to analyse a different city)
zillow_city<-c("New York")

# Change the occupancy rate assumption (Change to simulate different conditions)
n_occ <- 0.75

# Change the availability assumption 
n_avail <- 365

# change the number of years after which you need to analyse the profit per zipcode with ranking
n_year <- 25

# Needed for loading reusable values for Shiny app
if (!require("base")) install.packages("base")
if(file.exists(paste(path,"Growth_Final.RData",sep="/"))) {
   load(paste(path,"Growth_Final.RData",sep="/"))}
if(file.exists(paste(path,"plot_Price.RData",sep = "/"))) {
  load(paste(path,"plot_Price.RData",sep = "/"))}
if(file.exists(paste(path,"plot_Neighbourhood.RData",sep = "/"))) {
  load(paste(path,"plot_Neighbourhood.RData",sep = "/"))}
if(file.exists(paste(path,"plot_Cost.RData",sep = "/"))) {
  load(paste(path,"plot_Cost.RData",sep = "/"))}
if(file.exists(paste(path,"plot_Profit.RData",sep = "/"))) {
  load(paste(path,"plot_Profit.RData",sep = "/"))}
if(file.exists(paste(path,"plot_Growth_Based.RData",sep = "/"))) {
  load(paste(path,"plot_Growth_Based.RData",sep = "/"))}
if(file.exists(paste(path,"plot_Price_Breakeven_Based.RData",sep = "/"))) {
  load(paste(path,"plot_Price_Breakeven_Based.RData",sep = "/"))}
if(file.exists(paste(path,"plot_profit_in_years.RData",sep = "/"))) {
  load(paste(path,"plot_profit_in_years.RData",sep = "/"))}