
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
dataset <- df

# Import packages
library(zoo)

# Rename columns
colnames(dataset)[colnames(dataset) == "Month"] <- "month_year"
colnames(dataset)[colnames(dataset) == "python.machine.learning...United.States."] <- "python_machine_learning"
colnames(dataset)[colnames(dataset) == "r.machine.learning...United.States."] <- "r machine learning"

# Add six-month moving average
dataset$Month <- as.Date(paste(dataset$Month, "01", sep = "-"))
dataset$"python moving average" <- rollapply(dataset$"python machine learning", width=6, FUN=mean, align="right", partial=TRUE)
dataset$"r moving average" <- rollapply(dataset$"r machine learning", width=6, FUN=mean, align="right", partial=TRUE)


# Load data
print(df_rolling)



### Visualize data


# Import packages
library(ggplot2)


# Encode data to proper format (not necessary in R Studio)
dataset$MonthYear <- as.Date(dataset$MonthYear)
dataset$python_machine_learing <- as.numeric(dataset$python_machine_learning)
dataset$r_machine_learning <- as.numeric(dataset$r_machine_learning)
dataset$python_moving_average <- as.numeric(dataset$python_moving_average)
dataset$r_moving_average <- as.numeric(dataset$r_moving_average)


# Display plot
ggplot(dataset, aes(x=MonthYear)) +
  
  # Add scatter plots
  geom_point(aes(y=python_machine_learning, color="gold"), alpha=0.5, size=4) +
  geom_point(aes(y=r_machine_learning, color="red"), alpha=0.5, size=4) +
  
  # Add line plots
  geom_line(aes(y=python_moving_average, color="gold"), lwd=2) +
  geom_line(aes(y=r_moving_average, color="red"), lwd=2) +
  
  # Add labels
  labs(x = "", y = "Google Search Frequency Index") +
  ggtitle("Change in Programming Language Popularity Over Time") +
  
  # Format
  theme_minimal() +
  theme(text=element_text(size=24)) +
  theme(plot.title = element_text(hjust = 0.5),
        panel.grid = element_blank(),
        panel.border = element_rect(color = "black", fill=NA, size = 0.5),
        legend.position = c(0.15, 0.9),
        legend.background = element_blank()) +
  
  # Override legend so colors, labels align with plot
  scale_color_identity(name="",
                       breaks=c("gold", "red"),
                       labels=c("Python machine learning", "R machine learning"),
                       guide = "legend")












# ##### Ingest data
# # Set directory
# filepath <- "/Users/mymac/Downloads/"
# # filepath = "C:/Users/tomwe/Documents/GoogleTrendsData/"
# setwd(filepath)
# 
# # Read the list of files in the specified folder
# file_list <- list.files()
# 
# # Extract "multiTimeline" files
# filtered_list <- grep("^multiTimeline", file_list, value=TRUE)
# 
# # Identify the most recent date
# most_recent_file <- max(filtered_list)
# 
# # Load data
# full_filepath <- paste(filepath, most_recent_file, sep="")
# df <- read.csv(most_recent_file, skip=2)
# print(df)
# 
# 
# ### Transform data
# # Import packages
# # install.packages("zoo")
# library(zoo)
# 
# # Read in data
# df = read.csv(url("https://raw.githubusercontent.com/tomweinandy/AIinPowerBI/main/multiTimeline2023-06.csv"), skip=2)
# df_rolling = df
# 
# # Rename columns
# colnames(df_rolling)[colnames(df_rolling) == "python.machine.learning...United.States."] <- "python_machine_learning"
# colnames(df_rolling)[colnames(df_rolling) == "r.machine.learning...United.States."] <- "r_machine_learning"
# 
# # Add six-month moving average
# df_rolling$Month <- as.Date(paste(df_rolling$Month, "01", sep = "-"))
# df_rolling$"python_moving_average" <- rollapply(df_rolling$"python_machine_learning", width=6, FUN=mean, align="right", partial=TRUE)
# df_rolling$"r_moving_average" <- rollapply(df_rolling$"r_machine_learning", width=6, FUN=mean, align="right", partial=TRUE)
# 
# # Load data
# print(df_rolling)
# 
# 
# ### Visualize data
# # Import packages
# library(ggplot2)
# dataset = df_rolling
# 
# ggplot(dataset, aes(x = Month)) +
#   
#   # Add scatter plots
#   geom_point(aes(y=python_machine_learning, color="gold"), alpha=0.5) +
#   geom_point(aes(y=r_machine_learning, color="red"), alpha=0.5) +
#   
#   # Add line plots
#   geom_line(aes(y=python_moving_average), color="gold", lwd=1) +
#   geom_line(aes(y=r_moving_average), color="red", lwd=1) +
#   
#   # Add labels
#   labs(x = "", y = "Google Search Frequency Index") +
#   ggtitle("Change in Programming Language Popularity Over Time") +
#   
#   # Format 
#   theme_minimal() +
#   theme(plot.title = element_text(hjust = 0.5),
#         panel.grid = element_blank(),
#         panel.border = element_rect(color = "black", fill=NA, size = 0.5),
#         axis.text = element_text(size = 12),
#         legend.text = element_text(size = 12),
#         legend.position = c(0.18, 0.92),
#         legend.background = element_blank()) +
#   
#   # Override legend so colors, labels align with plot
#   scale_color_identity(name="",
#                        breaks=c("gold", "red"),
#                        labels=c("Python machine learning", "R machine learning"),
#                        guide = "legend")
# 
# 
# # # Display the plot
# # print(plot)
# # 
# # plot <- ggplot(dataset, aes(x=Month, y=python_machine_learning)) + geom_point(color="gold", alpha=0.5)
# # plot <- plot + geom_line(dataset, aes(x=Month, y=python_moving_average), color="gold") #, alpha=0.5)
# # print(plot)
# # 
# # rlang::last_trace(drop=FALSE)
# # # Format plot and add monthly observations as a scatter plot
# # date_range <- c(as.Date("2013-07-01"), as.Date("2023-06-01"))
# # plot(df_rolling$Month, df_rolling$"python machine learning", pch=16, col=rgb(1, 0.85, 0, alpha=0.5), xlab="", ylab="Google Search Frequency Index", xlim=date_range)
# # points(df_rolling$Month, df_rolling$"r machine learning", col=rgb(1, 0, 0, alpha=0.5), pch=16)
# # 
# # # Plot moving averages as a line
# # lines(df_rolling$Month, df_rolling$"python moving average", col=rgb(1, 0.85, 0), lwd=3)
# # lines(df_rolling$Month, df_rolling$"r moving average", col="red", lwd=3)
# # 
# # # Add the legend and title
# # legend("topleft", legend=c("python machine learning", "r machine learning"), col=c(rgb(1, 0.85, 0), "red"), lwd=c(2, 2), bty="n")
# # title(main="Change in Programming Language Popularity Over Time")
