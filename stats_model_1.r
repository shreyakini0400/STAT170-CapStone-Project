# logistic regression model of 
# antibiotic status ~ patient demographics

stats_model_1 <- function(comorb_person) {

    # columns to factorise
    cols = c("abx_status", "Gender", "covid_status", "covid_active", "Smoking", "Pregnancy", "Chronic_Kidney_Disease", "Heart_Conditions")
    comorb_person[cols] = lapply(comorb_person[cols], factor)

    comorb_person$Age = as.numeric(comorb_person$Age)

    # active
    # TODO: compare only status and active
    print("Covid_active")    
    model1 = glm(abx_status ~ Age + Gender + Ethnicity + covid_active, family = binomial(link = "logit"), data = comorb_person)
    print(summary(model1))

    # log likelihood CI
    print("Confidence Intervals")
    a = confint(model1)
    print(a)

    print("Covid_status")
    model2 = glm(abx_status ~ Age + Gender + Ethnicity + covid_status, family = binomial(link = "logit"), data = comorb_person)
    print(summary(model2))

    # we decided to go with the variable covid_active, instead of covid_status.
    return(NULL)