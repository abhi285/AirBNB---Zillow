source("UsConfig.R")
# Load missing packages
load_install <- packages_used %in% installed.packages()
if(length(packages_used[!load_install]) > 0) install.packages(packages_used[!load_install],repos = "http://cran.us.r-project.org")
lapply(packages_used, require, character.only=TRUE)

# creating a dummy dataframe to facilitate the shiny Applicatiojn creation
growth_final_shiny<-growth_final %>% group_by(zipcode,neighbourhood_group_cleansed) %>%
  summarize(price=median(price),latitude=max(latitude),longitude=min(longitude),
            growth=mean(avg_growth),cost_2019=median(cost_2019))
# Setting the color factors for representation in the final app.
qpal <- colorFactor(c("firebrick1","chartreuse3","turquoise3","purple"), 
                    c("Brooklyn","Manhattan","Queens","Staten Island"))
# Defining the UI part of shiny application
ui = fluidPage(
  titlePanel("Airbnb New York Listings App"),
  sidebarPanel(
    selectInput("Select", "Plots", choices =c("Cost_Based","Neighbourhood",
                "Price_Based","Profit_Based","Price_Breakeven_Based","Growth_Based","Profit_in_15_Years",
                "Profit_in_20_Years","Profit_in_25_Years","Profit_in_30_Years"))
                ,leafletOutput("map"),width="4",height="10"),
                mainPanel( column (6,plotOutput("myPlot",width="650",height="600")))
)
# defining the server part of the application
server = function(input, output,session) {
  output$myPlot <- renderPlot ({
    selecttype<-input$Select
    if (selecttype=="Neighbourhood"){
      plot_Neighbourhood() }
    else if (selecttype=="Price_Based"){
      plot_Price() }
    else if (selecttype=="Cost_Based") {
      plot_Cost()}
    else if (selecttype=="Profit_Based") {
      plot_Profit(n_occ,n_avail) }
    else if (selecttype=="Price_Breakeven_Based") {
      plot_Price_Breakeven_Based(n_occ,n_avail) }
    else if (selecttype=="Growth_Based") {
      plot_Growth_Based(n_occ,n_avail) }
    else if (selecttype=="Profit_in_15_Years") {
      plot_profit_in_years(n_occ,n_avail,15)    }
    else if (selecttype=="Profit_in_20_Years") {
      plot_profit_in_years(n_occ,n_avail,20)    }
    else if (selecttype=="Profit_in_25_Years") {
      plot_profit_in_years(n_occ,n_avail,25)    }
    else if (selecttype=="Profit_in_30_Years") {
      plot_profit_in_years(n_occ,n_avail,30)    }
  })
  output$map <- renderLeaflet({
    growth_final_shiny%>%
      leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      htmlwidgets::onRender("function(el, x) {
                            L.control.zoom({ position: 'topright' }).addTo(this)
  }") %>%
      addTiles() %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude)) %>%
      addLegend(position="bottomright",pal = qpal,value = ~neighbourhood_group_cleansed, title = "Neighbourhood") %>%
      addCircleMarkers(lat = ~latitude,lng = ~longitude,color = ~qpal(neighbourhood_group_cleansed),fillOpacity = 0.4,
                       popup = paste("zipcode", growth_final_shiny$zipcode, "<br>",
                                     "Neighbourhood:", growth_final_shiny$neighbourhood_group_cleansed, "<br>",
                                     "Average Growth (%):", round(growth_final_shiny$growth), "<br>",
                                     "Median Price per night:", growth_final_shiny$price, "<br>",
                                     "Cost (2019):", round(growth_final_shiny$cost_2019), "<br>",
                                     "Break Even Time (In Years):", round((growth_final_shiny$cost_2019)/(growth_final_shiny$price*n_occ*n_avail)), "<br>"
                       ), radius =growth_final_shiny$cost_2019/100000,
                       clusterOptions = markerClusterOptions())
  })
} 
# Run the application 
shinyApp(ui = ui, server = server)