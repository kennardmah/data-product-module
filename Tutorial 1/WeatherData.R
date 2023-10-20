WeatherData <- read.csv("http://pierrepinson.com/wp-content/uploads/2023/10/Heathrow-weather-data-1948-2022.csv", header=TRUE)

# display raw data
WeatherData
# display dimension
dim(WeatherData)
# display characteristics
summary(WeatherData)
WeatherData$tmin # specific trait

# # plot time-series for tmin
# plot ( WeatherData$tmin , type ="l", col ="blue", ylim =c(-5,20),
#        xlab="years", ylab ="degrees [Celsius]", axes = FALSE)
# # add axis
# axis (1, c(seq(1, length(WeatherData$tmin), 20*12), length(WeatherData$tmin)),
#       c(seq(1948,2008,20), 2022))
# axis (2, seq(-5,20,5))

# plot min temp of Heathrow as a function of the month of the year
tmin.vect <- WeatherData$tmin # extract the variable of interest
dim(tmin.vect) <- c(12, length(tmin.vect )/12) # transform the vector into a matrix
tmin.vect <- t(tmin.vect) # take the transpose of the matrix
tmin.mean <- colMeans(tmin.vect) # calculate the mean per row

# plot min temp of Heathrow as a function of the month of the year
tmax.vect <- WeatherData$tmax # extract the variable of interest
dim(tmax.vect) <- c(12, length(tmax.vect )/12) # transform the vector into a matrix
tmax.vect <- t(tmax.vect) # take the transpose of the matrix
tmax.mean <- colMeans(tmax.vect) # calculate the mean per row

# begin screenshot
png("Heathrow-T-climatology.png", width=600, height=450, pointsize=12)

# plot tmin
plot (tmin.mean, type="l", col="blue", ylim =c(-5,25),
      xlab="months", ylab = "degrees [Celsius]", axes = FALSE)

par(new=TRUE) # add to the same plot

# plot tmax
plot (tmax.mean, type="l", col="red", ylim =c(-5,25),
      xlab="months", ylab = "degrees [Celsius]", axes = FALSE)

# add graph labels
months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
axis(1, at = seq(1,12,1), labels = months)
axis(2, at = seq(-5,25,5))
legend(x=1, y=25, legend = c("tmax", "tmin"),
       col = c("red", "blue"), lty = 1)


dev.off()

