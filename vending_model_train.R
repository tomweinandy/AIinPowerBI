# Install and load the required packages
# install.packages("xgboost")
# install.packages("xgboost")

# Load the required packages
library(xgboost)
library(readr)

# GitHub CSV URL
url <- "https://raw.githubusercontent.com/tomweinandy/AIinPowerBI/main/vending_revenue.csv"
df <- read.csv(url)
df <- na.omit(df)
df <- subset(df, select = -c(WeekStartingSat))

# Convert the target variable to a factor
df$Location <- as.factor(df$Location)
df$Total <- as.numeric(df$Total)
df$Quantity <- as.numeric(df$Quantity)

# Split the data into training and validation sets
set.seed(24)
train_indices <- sample(1:nrow(df), 0.7 * nrow(df))
train_data <- df[train_indices, ]
test_data <- df[-train_indices, ]

# Define the features from the target variable "Location"
features <- setdiff(names(train_data), "Location")

# Convert the data to DMatrix format (an efficient data structure used by xgboost)
dtrain <- xgb.DMatrix(data = as.matrix(train_data[, features]), label = train_data$Location)
dtest <- xgb.DMatrix(data = as.matrix(test_data[, features]), label = test_data$Location)

# Set hyperparameters for the xgboost model
params <- list(
  objective = "multi:softprob", # For multi-class classification problems
  num_class = length(levels(df$Location)), # Number of classes in the target variable
  eta = 0.1, # Learning rate
  max_depth = 6, # Maximum depth of each tree
  nrounds = 100 # Number of boosting rounds
)

# Train the model
model <- xgboost(params, data = dtrain, nrounds = params$nrounds)

# Predict on the test set
predictions <- predict(model, dtest)

# Convert the predicted probabilities to class labels
predicted_ints = as.integer(round(predictions))
location_mapping <- c('Factory', 'Library', 'Mall 1', 'Mall 2', 'Office')
predicted_classes <- factor(predicted_ints, levels = 1:5, labels = location_mapping)

# Calculate accuracy
accuracy <- mean(predicted_classes == test_data$Location)

# Print accuracy
print(paste("Accuracy:", accuracy))

# 
df_shuffled = df[sample(1:nrow(df)), ]
df_shuffled_matrix = xgb.DMatrix(data = as.matrix(df_shuffled[, features]), label = df_shuffled$Location)

final_predictions <- predict(model, df_shuffled_matrix)

# Convert the predicted probabilities to class labels
final_predicted_ints = as.integer(round(final_predictions))
location_mapping <- c('Factory', 'Library', 'Mall 1', 'Mall 2', 'Office')
final_predicted_classes <- factor(final_predicted_ints, levels = 1:5, labels = location_mapping)
df_final = cbind(PredictedLocation = final_predicted_classes, df_shuffled)


# Calculate accuracy
accuracy <- mean(df_final$PredictedLocation == df_final$Location)

# Print accuracy
print(paste("Accuracy:", accuracy))