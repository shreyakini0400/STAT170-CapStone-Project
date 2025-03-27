# Using the dataset from Final_table.sql,
# we check some of the assumptions that are needed for logistic regression:
# 1) Independent variables linearly related to the log of odds
# 2) No multicollinearity amongst the independent variables

library(tidyverse)
library(broom)
library(ggcorrplot) 
theme_set(theme_classic())

assumptions_linearity <- function(final_dataset) {
    set.seed(12345)
    # drop numerical columns with na's
    prev_uri = prev_uri %>% drop_na(Age, days_since_pandemic, prev_uri_visits, Gender, Ethnicity, covid_active) #

    # modeling
    cols = c("abx_status", "Gender", "covid_status", "covid_active", "Smoking", "Pregnancy", "Chronic_Kidney_Disease", "Heart_Conditions", "Cancer", "Chronic_Liver_Disease", "Asthma", "Cystic_Fibrosis", "Dementia", "Alzheimer", "Disability", "HIV_Infection", "Overweight", "Solid_Organ", "Stroke", "Hypertension")
    prev_uri[cols] = lapply(prev_uri[cols], factor)

    prev_uri$Age = as.numeric(prev_uri$Age)
    prev_uri$days_since_pandemic = as.numeric(prev_uri$days_since_pandemic)
    prev_uri$prev_uri_visits = as.numeric(prev_uri$prev_uri_visits)

    # Since it takes forever to plot the entire dataset, I am using 1% of the dataset.

    sample_data = prev_uri[sample(1:nrow(prev_uri), 25000, replace=FALSE),]

    model = glm(abx_status ~ Age + Gender + Ethnicity + covid_active + days_since_pandemic + prev_uri_visits, family = binomial(link = "logit"), data = sample_data)
    probabilities <- predict(model, type = "response")
    probabilities[is.na(probabilities)] = 0
    # print(head(probabilities))
    predicted.classes <- ifelse(probabilities > 0.15, "pos", "neg")

    # only numeric predictors
    mydata = sample_data %>%
        dplyr::select_if(is.numeric)
    predictors = colnames(mydata)

    mydata = na.omit(mydata)

    mydata = mydata %>%
        mutate(logit = log(probabilities/(1-probabilities))) %>%
        gather(key = "predictors", value = "predictor.value", -logit)
    

    gg = ggplot(mydata, aes(logit, predictor.value))+
        geom_point(size = 0.5, alpha = 0.5) +
        geom_smooth(method = "loess") + 
        theme_bw() + 
        facet_wrap(~predictors, scales = "free_y") +
        theme(text = element_text(size = 20))  

    plot(gg)

    return(NULL)
}

asssumptions_corrplot <- function(final_dataset) {
    # drop numerical columns with na's
    prev_uri = prev_uri %>% drop_na(Age, days_since_pandemic, prev_uri_visits, Gender, Ethnicity, covid_active) #

    prev_uri$abx_status = ifelse(prev_uri$abx_status == "Yes", 1, 0)
    prev_uri$covid_status = ifelse(prev_uri$covid_status == "Yes", 1, 0)
    prev_uri$covid_active = ifelse(prev_uri$covid_active == "Yes", 1, 0)
    prev_uri$Smoking = ifelse(prev_uri$Smoking == "Yes", 1, 0)
    prev_uri$Pregnancy = ifelse(prev_uri$Pregnancy == "Yes", 1, 0)
    prev_uri$Chronic_Kidney_Disease = ifelse(prev_uri$Chronic_Kidney_Disease == "Yes", 1, 0)
    prev_uri$Heart_Conditions = ifelse(prev_uri$Heart_Conditions == "Yes", 1, 0)
    prev_uri$Cancer = ifelse(prev_uri$Cancer == "Yes", 1, 0)
    prev_uri$Chronic_Liver_Disease = ifelse(prev_uri$Chronic_Liver_Disease == "Yes", 1, 0)
    prev_uri$Asthma = ifelse(prev_uri$Asthma == "Yes", 1, 0)
    prev_uri$Cystic_Fibrosis = ifelse(prev_uri$Cystic_Fibrosis == "Yes", 1, 0)
    prev_uri$Dementia = ifelse(prev_uri$Dementia == "Yes", 1, 0)
    prev_uri$Alzheimer = ifelse(prev_uri$Alzheimer == "Yes", 1, 0)
    prev_uri$Disability = ifelse(prev_uri$Disability == "Yes", 1, 0)
    prev_uri$HIV_Infection = ifelse(prev_uri$HIV_Infection == "Yes", 1, 0)
    prev_uri$Overweight = ifelse(prev_uri$Overweight == "Yes", 1, 0)
    prev_uri$Solid_Organ = ifelse(prev_uri$Solid_Organ == "Yes", 1, 0)
    prev_uri$Stroke = ifelse(prev_uri$Stroke == "Yes", 1, 0)
    prev_uri$Hypertension = ifelse(prev_uri$Hypertension == "Yes", 1, 0)

    prev_uri$Age = as.numeric(prev_uri$Age)
    prev_uri$days_since_pandemic = as.numeric(prev_uri$days_since_pandemic)
    prev_uri$prev_uri_visits = as.numeric(prev_uri$prev_uri_visits)

    corr <- round(cor(prev_uri[, c('abx_status', 'Age', 'covid_active', 'days_since_pandemic', 'prev_uri_visits', 'Cancer', 'Chronic_Kidney_Disease', 'Chronic_Liver_Disease', 'Asthma', 'Cystic_Fibrosis', 'Dementia', 'Alzheimer', 'Disability', 'HIV_Infection',  'Overweight', 'Pregnancy', 'Smoking', 'Solid_Organ', 'Stroke', 'Heart_Conditions', 'Hypertension')]), 3)
    print(head(corr))

    gg = ggcorrplot(corr, tl.cex = 16)  + theme(legend.key.size = unit(2, 'cm'))
    plot(gg)


    return(NULL)