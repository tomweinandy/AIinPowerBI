##### Ingest data
# Set directory
filepath <- "/Users/mymac/Downloads/"
# filepath = "C:/Users/tomwe/Documents/GoogleTrendsData/"
setwd(filepath)

# Read the list of files in the specified folder
file_list <- list.files()

# Extract "multiTimeline" files
filtered_list <- grep("^multiTimeline", file_list, value=TRUE)

# Identify the most recent date
most_recent_file <- max(filtered_list)

# Load data
full_filepath <- paste(filepath, most_recent_file, sep="")
df <- read.csv(most_recent_file, skip=2)
print(df)


### Transform data
# Import packages
# install.packages("zoo")
library(zoo)

# Read in data
df = read.csv(url("https://raw.githubusercontent.com/tomweinandy/AIinPowerBI/main/multiTimeline2023-06.csv"), skip=2)
df_rolling = df

# Rename columns
colnames(df_rolling)[colnames(df_rolling) == "python.machine.learning...United.States."] <- "python machine learning"
colnames(df_rolling)[colnames(df_rolling) == "r.machine.learning...United.States."] <- "r machine learning"

# Add six-month moving average
df_rolling$Month <- as.Date(paste(df_rolling$Month, "01", sep = "-"))
df_rolling$"python moving average" <- rollapply(df_rolling$"python machine learning", width=6, FUN=mean, align="right", partial=TRUE)
df_rolling$"r moving average" <- rollapply(df_rolling$"r machine learning", width=6, FUN=mean, align="right", partial=TRUE)

# Load data
print(df_rolling)


### Visualize data
# Import packages

# Format plot and add monthly observations as a scatter plot
plot(df_rolling$Month, df_rolling$"python machine learning", pch=16, col=rgb(1, 0.85, 0, alpha=0.5), xlab="", ylab="Google Search Frequency Index")
points(df_rolling$Month, df_rolling$"r machine learning", col=rgb(1, 0, 0, alpha=0.5), pch=16)

# Plot moving averages as a line
lines(df_rolling$Month, df_rolling$"python moving average", col=rgb(1, 0.85, 0), lwd=3)
lines(df_rolling$Month, df_rolling$"r moving average", col="red", lwd=3)

# Add the legend and title
legend("topleft", legend=c("python machine learning", "r machine learning"), col=c(rgb(1, 0.85, 0), "red"), lwd=c(2, 2), bty="n")
title(main="Change in Programming Language Popularity Over Time")
