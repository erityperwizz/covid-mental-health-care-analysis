# Key findings: mental health care use among U.S. adults during COVID-19
# Source: CDC Household Pulse Survey, "Mental Health Care in the Last 4 Weeks"
# Each row is a published survey estimate (percent of adults), so results are
# compared within one indicator at a time.

library(dplyr)

df <- read.csv("Mental_Health_Care_in_the_Last_4_Weeks.csv") %>%
  filter(!is.na(Value))

any_care <- "Took Prescription Medication for Mental Health And/Or Received Counseling or Therapy, Last 4 Weeks"
therapy  <- "Received Counseling or Therapy, Last 4 Weeks"
unmet    <- "Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks"

# 1. National trend: first vs latest survey period
df %>%
  filter(Group == "National Estimate") %>%
  group_by(Indicator) %>%
  arrange(Time.Period, .by_group = TRUE) %>%
  summarise(first = first(Value), latest = last(Value), change = latest - first)

# 2. Groups: average share of adults using any care, and unmet need
group_avg <- function(group, indicator) {
  df %>%
    filter(Group == group, Indicator == indicator) %>%
    group_by(Subgroup) %>%
    summarise(avg_pct = round(mean(Value), 1)) %>%
    arrange(desc(avg_pct))
}
group_avg("By Sex", any_care)
group_avg("By Gender identity", any_care)
group_avg("By Gender identity", unmet)
group_avg("By Sexual orientation", unmet)

# 3. State ranking for any care (sorted table, top and bottom)
state_rank <- group_avg("By State", any_care) %>% mutate(rank = row_number())
head(state_rank, 5)
tail(state_rank, 5)

# 4. Precision: how confidence interval width relates to the estimate
ci <- df %>% mutate(ci_width = HighCI - LowCI)
cor(ci$Value, ci$ci_width)
