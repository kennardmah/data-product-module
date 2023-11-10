# # install packages if haven't done yet
# install.packages("tidyverse")
# install.packages("lubridate")
# install.packages("janitor")
# install.packages("rvest")
# install.packages("httr")
# install.packages("polite")
# install.packages("treemap")
# install.packages("d3treeR")
# devtools::install_github("jeromefroe/circlepackeR")
# install.packages("data.tree")

# To clean data
library(tidyverse)
library(lubridate)
library(janitor)

# To scrape data
library(rvest)
library(httr)
library(polite)

# for treemap
library(treemap)
library(d3treeR)

# for circular packaging
library(circlepackeR)
library(data.tree)

# scrape data table from wikipedia
url <- "https://en.wikipedia.org/wiki/Counties_in_England_by_population"
url_bow <- polite::bow(url)
ind_html <- # scrape table from urlbow
  polite::scrape(url_bow) %>%  # scrape web page
  rvest::html_nodes("table.wikitable") %>% # pull out specific table
  rvest::html_table(fill = TRUE) 
ind_tab <- # flatten table ind_html
  ind_html[[1]] %>% 
  clean_names()

mydata <- ind_tab # store in dataframe ('mydata')

# data curation
mydata$total_population <- as.numeric(gsub(",", "", mydata$total_population)) # converting to numeric
mydata$region[15] <- mydata$region[10] # small adjustment

#
# create a treemap w groups/subgroups
#

# prepare data
group <- mydata$region
subgroup <- mydata$county
value <- mydata$total_population
data <- data.frame(group, subgroup, value)
# basic treemap
p <- treemap(data,
             index=c("group","subgroup"),
             vSize="value",
             type="index",
             palette = "Set2",
             # bg.labels=c("white"),
             align.labels=list(
               c("center", "center"),
               c("right", "bottom")
             )
)
# # make it interactive ("rootname" becomes the title of the plot):
# inter <- d3tree2(p, rootname="General")

#
# Create circular packaging chart
#


# create a nested data frame giving the info of a nested dataset:
data <- data.frame(
  group,
  subgroup,
  value
)

# Change the format. This use the data.tree library. This library needs a column that looks like root/group/subgroup/..., so I build it
data$pathString <- paste("world", data$group, data$subgroup, data$subsubgroup, sep = "/")
population <- as.Node(data)
# Make the plot
circlepackeR(population, size = "value")

# You can custom the minimum and maximum value of the color range.
p <- circlepackeR(population, size = "value", color_min = "hsl(56,80%,80%)", color_max = "hsl(341,30%,40%)")

# save the widget
library(htmlwidgets)
saveWidget(p, file=paste0( getwd(), "/HtmlWidget/circular_packing_circlepackeR2.html"))
