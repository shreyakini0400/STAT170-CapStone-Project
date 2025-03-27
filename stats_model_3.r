# logistic regression model of 
# antibiotic status ~ patient demographics + all comorbidities + time covariates

stats_model_3 <- function(final_dataset) {
    # columns to factorise
    cols = c("abx_status", "Gender", "covid_status", "covid_active", "Smoking", "Pregnancy", "Chronic_Kidney_Disease", "Heart_Conditions", "Cancer", "Chronic_Liver_Disease", "Asthma", "Cystic_Fibrosis", "Dementia", "Alzheimer", "Disability", "HIV_Infection", "Overweight", "Solid_Organ", "Stroke", "Hypertension")
    prev_uri[cols] = lapply(prev_uri[cols], factor)

    prev_uri$Age = as.numeric(prev_uri$Age)
    prev_uri$days_since_pandemic = as.numeric(prev_uri$days_since_pandemic)
    prev_uri$prev_uri_visits = as.numeric(prev_uri$prev_uri_visits)

    print("Model 3")    
    model3 = glm(abx_status ~ Age + Gender + Ethnicity + covid_active + days_since_pandemic + prev_uri_visits + Smoking + Pregnancy + Chronic_Kidney_Disease +          Heart_Conditions + Cancer +  Chronic_Liver_Disease + Asthma +  Cystic_Fibrosis + Dementia + Disability + HIV_Infection  + Alzheimer + Stroke + Overweight + Solid_Organ + Hypertension, family = binomial(link = "logit"), data = prev_uri)
    print(summary(model3))
    
    return(NULL)
}