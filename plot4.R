## Step 1: Set up working directory and packages
setwd("~/Studie/Data Science/0004 Exploratory Data Analysis/data")
library(data.table)
library(dplyr)
library(lubridate)
library(tidyr)

## Step 2: Creates "data" directory to put the zip file with the data sets
if (!file.exists("dataset")) {
    dir.create("dataset")
}

## Step 3: Downloads the zipfile to the data directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./dataset/dataset.zip", method = "curl")

## Step 4: Unzips the file to the dataset dir and reads the textfile into R
unzip("./dataset/dataset.zip", exdir = "dataset")
DTraw <- fread("./dataset/household_power_consumption.txt",sep = ";",header = T)

## Step 5: Subset 2-day period, rowbind, cleaning & date, num convertion
DTfeb1 <- subset(DTraw, Date=="1/2/2007")
DTfeb2 <- subset(DTraw, Date=="2/2/2007")
DTsub <- rbind(DTfeb1, DTfeb2)
rm(DTraw, DTfeb1, DTfeb2, fileUrl)
DTsub$Date <- with(DTsub, paste(Date, Time))
DTsub$Date <- dmy_hms(DTsub$Date) ## With lubridate
DTsub$Global_active_power <- as.numeric(DTsub$Global_active_power)
DTsub$Global_reactive_power <- as.numeric(DTsub$Global_reactive_power)
DTsub$Sub_metering_1 <- as.numeric(DTsub$Sub_metering_1)
DTsub$Sub_metering_2 <- as.numeric(DTsub$Sub_metering_2)
DTsub$Sub_metering_3 <- as.numeric(DTsub$Sub_metering_3)
DTsub$Voltage <- as.numeric(DTsub$Voltage)

## Step 6: Check missing values ("?")
for (i in names(DTsub)) {print(sum(DTsub$i == "?"))}

## Step 7: Plot 4
Sys.setlocale("LC_TIME", "English") ## change local time to English for Thu, Fri..
par(mfrow=c(2,2))
#TopLeft
with(DTsub, plot(Date, Global_active_power, type="l", ylab = "Global Active Power", xlab="", lwd=0.1))
#Topright
with(DTsub, plot(Date, Voltage, type="l", xlab = "datatime", ylab = "Voltage",
                 lwd=0.1))
#BottomLeft
with(DTsub, plot(Date, Sub_metering_1, type="n", xlab="", ylab = "Energy sub metering"))
lines(DTsub$Date, DTsub$Sub_metering_1, col="black")
lines(DTsub$Date, DTsub$Sub_metering_2, col="red")
lines(DTsub$Date, DTsub$Sub_metering_3, col="blue")
legend("topright", lty = c(1, 1, 1), col=c("black","red", "blue"),
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       xjust = 1, cex=0.8, y.intersp=0.6, lwd = 0.5, bty="n")
#BottomRight
with(DTsub, plot(Date, Global_reactive_power, type="l", xlab="datetime", lwd=0.1))
dev.copy(png, file = "plot4.png")
dev.off()

