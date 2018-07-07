## If data is not in working directory, download data
if(!file.exists("data")) { dir.create("data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
download.file(url = fileurl, destfile = "./data/household_power_consumption.txt")

# Read Data
hpcDataAll <- read.table("./data/household_power_consumption.txt", 
                         sep = ";", header = TRUE, stringsAsFactors = FALSE, na.strings = "?")

# subset data for 2 days:
hpa <- hpcDataAll[hpcDataAll$Date == "1/2/2007", ]
hpb <- hpcDataAll[hpcDataAll$Date == "2/2/2007", ]
hpc_ab <- rbind(hpa, hpb)

# change date and time formats
library(dplyr)
hpcdataDT <- select(hpc_ab, Date, Time) # extract Date, Time columns
date_time1 <- paste(hpcdataDT$Date, hpcdataDT$Time, sep = " ") # paste into one
date_time <- strptime(date_time1, format = "%d/%m/%Y %H:%M:%S") # change to PosIXlt format
hpcData <- select(hpc_ab, 3:9) # extract variables not Date and Time
hpc_data <- cbind(date_time, hpcData) # combine new date-time variable to all others.

# Plot 3:
png(filename = "Plot3.png", width = 480, height = 480)
plot(hpc_data$date_time, hpc_data$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(hpc_data$date_time, hpc_data$Sub_metering_1, lty=1)
lines(hpc_data$date_time, hpc_data$Sub_metering_2, lty=1, col = "red")
lines(hpc_data$date_time, hpc_data$Sub_metering_3, lty=1, col = "blue")
legend("topright", pch = "___", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()