# Using the dataset from Final_table.sql,
# we create some visualizations:
# 1) Number of URI Patients by Antibiotics Status, barplot
# 2) Age distribution of Unique URI Patients, histogram
# 3) Number of Unique URI Patients by Ethnicity, barplot
# 4) Number of Antibiotics Prescription Grouped by COVID-19 Status, grouped barplot (3 variables)

library(ggplot2)
library(scales)

abx_status <- function(final_dataset) {
    gg = ggplot(prev_uri, aes(x = abx_status)) +
            geom_bar(fill = "#b9d015", width = 0.7) +
            labs(x = "Antibiotics Prescribed?", y = "Number of Patients") +
            theme(text = element_text(size = 27)) +
            ggtitle("URI Patients by Antibiotics Status") +
            theme(plot.title = element_text(hjust = 0.5)) +
            scale_y_continuous(labels = comma) + # for comma every thousands
            geom_text(stat='count', aes(label=comma(..count..)), vjust = 2.0, size = 8, position = position_dodge2(width = 0.9, preserve = "single"))
    plot(gg)
    return(NULL)
}

age_distribution <- function(End_Table) {
    gg = ggplot(End_Table, aes(x = Age)) +
            geom_histogram(breaks = seq(from=0, to=max(End_Table$Age, na.rm=TRUE), by=5),
                fill="chocolate2", color="white") +
            labs(x = "Age (years)", y = "Number of Patients") +
            theme(text = element_text(size = 20)) +
            theme(plot.title = element_text(hjust = 0.5)) +
            ggtitle("Age Distribution of Unique URI Patients") +
            scale_y_continuous(labels = comma) # for comma every thousands
    plot(gg)
    #print(max(End_Table$age, na.rm=TRUE))
    return(NULL)
}

ethnicity <- function(End_Table) {
    gg = ggplot(End_Table, aes(x = Ethnicity)) +
            geom_bar(fill = "#b9d015", width = 0.7) +
            labs(x = "Ethnicity", y = "Number of Patients") +
            theme(text = element_text(size = 27)) +
            ggtitle("Unique URI Patients by Ethnicity") +
            theme(plot.title = element_text(hjust = 0.5)) +
            scale_y_continuous(labels = comma) + # for comma every thousands
            geom_text(stat='count', aes(label=comma(..count..)), vjust = 2.0, size = 8, position = position_dodge2(width = 0.9, preserve = "single"))
    plot(gg)
    return(NULL)
}

abx_by_covid <- function(comorb_person) {
    print(table(comorb_person[, c("covid_status", "abx_status")]))

    covid = c(rep("Yes", 2), rep("No", 2))
    abx = rep(c("Yes", "No"), 2)
    value = c(22046, 279950, 279446, 1937553)
    data = data.frame(covid,abx,value)

    gg = ggplot(data, aes(fill = abx, y=value, x=covid)) +
        geom_bar(position="dodge", stat="identity") +
        labs(x = "COVID-19 Status", y = "Antibiotics Prescription",
        fill = "Antibiotics Prescription") +
        geom_text(aes(label = value), vjust = -0.3, position = position_dodge2(width = 0.9, preserve = "single")) +
        ggtitle("Antibiotics Prescription Grouped by COVID-19 Status")
    plot(gg)
    return(NULL)
}