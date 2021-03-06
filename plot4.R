## Load subset of data, based on http://stackoverflow.com/questions/6592219/read-csv-from-specific-row/6596549#6596549 (Multiple read.tables subsection)

# Read headers and first line to keep colNames and calculate ncol

DFColNames <- read.table("household_power_consumption.txt", header=T, sep=";", nrow = 1)
nc <- ncol(DFColNames)

#read first column (Date), ignore other columns
DFDates <- read.table("household_power_consumption.txt", sep =";", header = T, na.strings="?", as.is = T, colClasses = c(NA, rep("NULL", nc-1)))

# convert values to POSIXct
x <- strptime(DFDates$Date, "%d/%m/%Y")

# Calculate first line of "2007-02-01" appearence to use later as skip parameter
# ODD: which.min returns 1, which.max returns correct value

bottomDate <- as.POSIXct("2007-02-01")
firstLine <- which.max (x == bottomDate) + 1

# Calculate last line of "2007-02-02" appearence to calculate nrows parameter later
# ODD: which.min returns 1, which.max returns correct value. So, "2007-02-03" is used, and 1 line susbstracted to obtain the correct index

upDate <- as.POSIXct("2007-02-03")
lastLine <- which.max (x == upDate) + 1

# Read subset of data based con calculated rows indexes

DF3 <- read.table("household_power_consumption.txt", sep =";", col.names = names(DFColNames), skip = firstLine -1, nrows = lastLine - firstLine, as.is = TRUE)

# Open PNG device, send Plot, close device
png("plot4.png", width = 480, height = 480)

# set locale to english
Sys.setlocale("LC_TIME", "C")

# concatenate and format Date and Time, based on https://www.youtube.com/watch?v=FLCEkbMttgU
datetime <- paste(DF3$Date, DF3$Time, sep=" ")
rdatetime <- as.POSIXct(datetime, format = "%d/%m/%Y %H:%M:%S")
par(mfcol = c(2,2))
plot(DF3$Global_active_power ~ rdatetime, type = "l", xlab="", ylab="Global Active Power")
plot(DF3$Sub_metering_1 ~ rdatetime, type = "n", xlab="", ylab="Energy sub metering")
lines(x = rdatetime, y = DF3$Sub_metering_1, col = "black")
lines(x = rdatetime, y = DF3$Sub_metering_2, col = "red")
lines(x = rdatetime, y = DF3$Sub_metering_3, col = "blue")
legend("topright", lty = "solid", bty = "n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(DF3$Voltage ~ rdatetime, type = "l", xlab="datetime", ylab="Voltage")
plot(DF3$Global_reactive_power ~ rdatetime, type = "l", xlab="datetime", ylab="Global_reactive_power")
dev.off()
