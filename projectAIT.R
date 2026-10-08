# Load libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(maps)
library(mapdata)
install.packages("mapdata")
install.packages("plotly")
library(plotly)
# Load dataset
file_path <- "Mental_Health_Care_in_the_Last_4_Weeks.csv"
df <- read.csv(file_path)

# Basic exploration
summary(df)
str(df)

# Handle missing values
df <- df[complete.cases(df$Value, df$LowCI, df$HighCI), ]
# Ensure the Time Period Start Date is in the correct date format
df$Time.Period.Start.Date <- as.Date(df$Time.Period.Start.Date, format = "%m/%d/%Y")

# Plot trends in mental health care usage over time
ggplot(df, aes(x = Time.Period.Start.Date, y = Value)) +
  geom_line() +
  ggtitle("Trends in Mental Health Care Usage Over Time") +
  xlab("Time Period Start Date") +
  ylab("Usage (Value)") +
  theme_minimal()

# Ensure relevant groups
relevant_groups <- c("By Age", "By Sex", "By Presence of Symptoms of Anxiety/Depression",
                     "By State", "By Race/Hispanic ethnicity", "By Sexual orientation", 
                     "By Education", "By Gender identity")

# Filter the dataset for relevant groups
filtered_df <- df %>% filter(Group %in% relevant_groups)

# Question 1: Differences in mental health care usage across subgroups
# Filter specific groups for analysis
age_df <- filtered_df %>% filter(Group == 'By Age')
state_df <- filtered_df %>% filter(Group == 'By State')
gender_df <- filtered_df %>% filter(Group == 'By Sex')

# Set up plotting area
par(mfrow=c(1, 3))  # Layout for 3 plots

# Plot for age groups
ggplot(age_df, aes(x=Subgroup, y=Value)) +
  geom_boxplot() +
  labs(title='Mental Health Care Usage by Age Group') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Plot for state groups
ggplot(state_df, aes(x=Subgroup, y=Value)) +
  geom_boxplot() +
  labs(title='Mental Health Care Usage by State') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Plot for gender groups
ggplot(gender_df, aes(x=Subgroup, y=Value)) +
  geom_boxplot() +
  labs(title='Mental Health Care Usage by Gender') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

par(mfrow=c(1, 1))  # Reset layout

# Calculate average usage by state
state_mean <- state_df %>%
  group_by(State) %>%
  summarise(avg_value = mean(Value, na.rm = TRUE))

# Convert state names in state_mean to lower case
state_mean$State <- tolower(state_mean$State)

# Get the US map data
us_states <- map_data("state")

# Print unique values to ensure matching
print(unique(state_mean$State))
print(unique(us_states$region))

# Merge average values with state map data
state_map_data <- left_join(us_states, state_mean, by = c("region" = "State"))

# Check the merge results
print(head(state_map_data))

# Plot the map
ggplot(state_map_data, aes(x = long, y = lat, group = group, fill = avg_value)) +
  geom_polygon(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "darkblue", na.value = "grey50") +
  labs(title = "Average Mental Health Care Usage by State",
       fill = "Usage (%)") +
  coord_fixed(1.3) +
  theme_void()




# Calculate average usage by state
state_mean <- state_df %>%
  group_by(State) %>%
  summarise(avg_value = mean(Value, na.rm = TRUE))

# Convert state names in state_mean to lower case
state_mean$State <- tolower(state_mean$State)

# Get the US map data
us_states <- map_data("state")

# Merge average values with state map data
state_map_data <- left_join(us_states, state_mean, by = c("region" = "State"))

# Create the ggplot map
map_plot <- ggplot(state_map_data, aes(x = long, y = lat, group = group, fill = avg_value, text = region)) +
  geom_polygon(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "darkblue", na.value = "grey50") +
  labs(title = "Average Mental Health Care Usage by State",
       fill = "Usage (%)") +
  coord_fixed(1.3) +
  theme_void()

# Convert the ggplot map to an interactive plotly object
interactive_map <- ggplotly(map_plot, tooltip = "text")

# Display the interactive map
interactive_map