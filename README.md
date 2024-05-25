# Credit Application

In order to minimize losses and maximize profits, banks must carefully review financing requests. 
The purpose of this project is to develop a model to assist a fictional financial institution in improving its financing approval process. 
To do so, we have access to a large database containing information about loans granted to a group of individuals, as well as the profit or loss incurred on these loans two years later. 
Our goal is to maximize the bank's profits.      


To accomplish this task, several models will be considered (logistic regression, random forest, boosting techniques, bagging techniques etc.) and their performances will be compared.   



<font size="3"> To evaluate the performance of the differents models, we'll look at the following metrics. </font>  

- <font size="3"> **Accuracy** measures how often a model is correct. In our context, it measures how often safe loans are correctly classified as safe and risky loans correctly classified as risky by a model </font>     

- <font size="3"> **False positive rate** is the proportion of safe loans that were incorrectly classified as risky by a model. </font>    

- <font size="3"> **False negative rate** is the proportion of risky loans that were incorrectly classified as safe by a model. </font>   

- <font size="3"> **Precision** is the proportion of truly risky loans among all the loans that were predicted as risky </font>     

- <font size="3"> **Sensitivity** (also callded **true positive rate**) measures how good a model is at correctly identifying risky loans. It is the proportion of risky loans that were correctly classified as risky by a model.  </font>     

- <font size="3"> **Specificity** (also callded **true negative rate**) measures how good a model is at identifying safe loans. It is the proportion of safe loans that were correctly classified as safe by a model. </font>








# Dataset      

ID_TRAIN : Client ID
TYP_FIN : Loan type (car, mortgage, personal ...)
NB_EMPT : Number of borrowers
R_ATD : Monthly expenses over monthly income
PRT_VAL : Amount requested
DUREE : Loan term
AGE_D : Client age
REV_BT : Gross Income
REV_NET : Net Income
TYP_RES : Residency (P: Owner, L: Tenant, A: Other)
ST_EMPL : Employment status (R: full time, P: part-time, T: Self-employed) 
MNT_EPAR : Savings ($)
NB_ER_6MS : Number of transactions declined due to insufficient funds over the last 6 months
NB_ER_12MS : Number of transactions declined due to insufficient funds over the last 12 months
NB_DEC_12MS : Number of credit limit exceedances over the last 12 months
NB_OPER : Total number of transactions 
NB_SATI : Total number of satisfactory transactions 
NB_COUR : Total number of regular transactions
NB_INTR_1M : Number of financing requests made over during the past last month
NB_INTR_12M : Number of financing requests made over the past 12 months
PIR_DEL : Worst deliquency
NB_DEL_30 : Number of 30-59 days deliquency over the last 12 months
NB_DEL_60 : Number of 60-89 days deliquency over the last 12 months
NB_DEL_90 : Number of 90 days or more deliquency over the last 12 months
MNT_PASS : Liabilities
MNT_ACT : Assets
MNT_AUT_REN : Authorized amount of revolving credit 
MNT_UTIL_REN : Amount of revolving credit used
MNT_DEMANDE : Amount of financing requested    
DEFAULT : DEFAULT. A default is recorded when the payment is 90 days or more past due (1: default, 0: no default)      
PROFIT_LOSS : Profit or loss incurred on the loan two years later     




