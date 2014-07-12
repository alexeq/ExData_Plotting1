## Read data
# Attention! This script assumes that file "household_power_consumption.txt" 
# is already downloaded to the current directory!

# Column names
names <- c(
    "Date", "Time", 
    "Global_active_power", "Global_reactive_power",
    "Voltage", "Global_intensity", 
    "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

# Read CSV partially (limits are found by grep)
#
# First line of the dataset:
# $ grep -n -m 1 -e "^[12]/2/2007" household_power_consumption.txt
# > 66638:1/2/2007;00:00:00;0.326;0.128;243.150;1.400;0.000;0.000;0.000
# Count of lines in the dataset:
# $ grep -c -e "^[12]/2/2007" household_power_consumption.txt
# > 2880
dt <- read.csv("household_power_consumption.txt", header=F, sep=";", dec=".", 
    na.strings="?", skip=66000, nrows=5000, col.names=names)

# Filter data to first 2 days of Feb, 2007
dt <- dt[dt$Date %in% c("1/2/2007", "2/2/2007"), ]

# Convert 2 columns to date, time
dt$DateTime <- strptime(paste(dt$Date, dt$Time), format="%d/%m/%Y %H:%M:%S")
#dt$Date <- strptime(dt$Date, format="%d/%m/%Y")
#dt$Time <- strptime(dt$Time, format="%H:%M:%S")

## Create graphic device PNG and draw plot
png(file="plot4.png", width=480, height=480)
# Set locale, so that week days will be shown in English
Sys.setlocale("LC_TIME", "English")

# Break the space to 4 areas
par(mfcol=c(2, 2))

# Graph 1
plot(dt$DateTime, dt$Global_active_power, type="l",
    xlab="", ylab="Global Active Power")

# Graph 2
plot(dt$DateTime, dt$Sub_metering_1, col="black", 
    type="l", ylab="Energy sub metering", xlab="")
lines(dt$DateTime, dt$Sub_metering_2, col="red")
lines(dt$DateTime, dt$Sub_metering_3, col="blue")
legend("topright", col=c("black", "red", "blue"), lty=1, bty="n", legend=names[7:9])

# Graph 3
plot(dt$DateTime, dt$Voltage, type="l", xlab="datetime", ylab=names[5])

# Graph 4
plot(dt$DateTime, dt$Global_reactive_power, type="l", xlab="datetime", ylab=names[4])

dev.off()
