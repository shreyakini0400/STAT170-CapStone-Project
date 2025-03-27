# logistic regression model of 
# antibiotic status ~ patient demographics + all comorbidities

stats_model_2 <- function(comorb_person) {

    cols = c("abx_status", "Gender", "covid_status", "covid_active", "Smoking", "Pregnancy", "Chronic_Kidney_Disease", "Heart_Conditions", "Cancer", "Chronic_Liver_Disease", "Asthma", "Cystic_Fibrosis", "Dementia", "Alzheimer", "Disability", "HIV_Infection", "Overweight", "Solid_Organ", "Stroke", "Hypertension")
    comorb_person[cols] = lapply(comorb_person[cols], factor)

    model2 = glm(abx_status ~ Age + Gender + Ethnicity + covid_active + Smoking + Pregnancy + Chronic_Kidney_Disease +          Heart_Conditions + Cancer +  Chronic_Liver_Disease + Asthma +  Cystic_Fibrosis + Dementia + Disability + HIV_Infection  + Alzheimer + Stroke + Overweight + Solid_Organ + Hypertension , family = binomial(link = "logit"), data = comorb_person)
    
    print(summary(model2))
    return(NULL)  
    
}