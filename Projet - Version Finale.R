
setwd("~/Desktop/Apprentissage statistique")
credit = read.csv("Data_Projetfinal/CreditGame_train.csv")
head(credit)

table(credit$DEFAULT)


credit$TYP_RES = as.factor(credit$TYP_RES)
credit$ST_EMPL = as.factor(credit$ST_EMPL)
levels(credit$ST_EMPL)[levels(credit$ST_EMPL)==""] = "Others"


credit.compl = credit[complete.cases(credit), ]



set.seed(0202)
id.na = sample(1:nrow(credit))
credit.train = credit[id.na[1:640000],]
credit.test = credit[id.na[640001:nrow(credit)],]

head(credit.train)





# création de RMU
credit.train$RMU = ifelse (credit.train$MNT_AUT_REN == 0, 0, 
                           (credit.train$MNT_UTIL_REN/credit.train$MNT_AUT_REN ))

credit.test$RMU = ifelse (credit.test$MNT_AUT_REN == 0, 0, 
                          (credit.test$MNT_UTIL_REN/credit.test$MNT_AUT_REN ))



# création de RTS     NB_SATI/NB_OPER
credit.train$RTS = ifelse (credit.train$NB_OPER == 0, 0, (credit.train$NB_SATI/credit.train$NB_OPER ))
credit.test$RTS = ifelse (credit.test$NB_OPER == 0, 0, (credit.test$NB_SATI/credit.test$NB_OPER ))


# création de RAP   actif/passif
credit.train$RAP = ifelse (credit.train$MNT_PASS == 0, 0, (credit.train$MNT_ACT/credit.train$MNT_PASS ))
credit.test$RAP = ifelse (credit.test$MNT_PASS == 0, 0, (credit.test$MNT_ACT/credit.test$MNT_PASS))

head(credit.train)


mod.log = glm(DEFAULT~., data=credit.train[,-c(1, 8, 17, 28, 31:34)], family=binomial(link="logit"))

summary(mod.log)

#AIC de 220784

<br>
  
  
# Ajout de RMU
mod.log2 = glm(DEFAULT~., data=credit.train[,-c(1, 8, 17, 25, 26, 28, 31, 33, 34)], family=binomial(link="logit"))

summary(mod.log2)

# AIC de 219393


# Ajout de RMU et RTS
mod.log3 = glm(DEFAULT~., data=credit.train[,-c(1, 8, 15, 17, 25, 26, 27, 28, 31, 34)], family=binomial(link="logit"))

summary(mod.log3)
#AIC de 219212


# Ajout de RMU, RTS et RAP
mod.log4 = glm(DEFAULT~., data=credit.train[,-c(1, 8, 15, 17, 23, 34, 25, 26, 27, 28, 31)], family=binomial(link="logit"))

summary(mod.log4)
#AIC de 219572



# Ajout de RMU et RTS et retrait de NB_COUR
mod.log5 = glm(DEFAULT~., data=credit.train[,-c(1, 8, 15, 16, 17, 25, 26, 27, 28, 31, 34)], family=binomial(link="logit"))

summary(mod.log5)
#AIC de 219465

# Ajout de RMU et RTS et retrait de MNT_DEMANDE
mod.log6 = glm(DEFAULT~., data=credit.train[,-c(1, 8, 15, 17, 25, 26, 27, 28, 29, 31, 34)], family=binomial(link="logit"))

summary(mod.log6)
#AIC de 219212


credit.test6 = credit.test[complete.cases(credit.test), ]

prob.predict6 = predict.glm(mod.log6, credit.test6[,-c(1, 8, 15, 17, 25, 26, 27, 28, 29, 31, 34)], type="response")

library(ROCR)

pred6 = prediction(prob.predict6, credit.test6$DEFAULT)
auc6 = performance(pred6, measure="auc")
auc6@y.values

#AUC de 0.7714721



# Minimiser le taux de faux positifs et de faux négatifs
pred6 = prediction(prob.predict6, credit.test6$DEFAULT)
perf6 = performance(pred6, measure="fpr", x.measure="fnr")

opt.cut = function(perf, pred)
{
  cut.ind = mapply(FUN=function(x, y, p){
    d = (x - 0)^2 + (y-0)^2
    ind = which(d == min(d))
    c(False_positive_rate = y[[ind]], False_negative_rate = x[[ind]],
      cutoff = p[[ind]])
  }, perf@x.values, perf@y.values, pred@cutoffs)
}

print(opt.cut(perf6, pred6))

#False_positive_rate 0.28316857
#False_negative_rate 0.31510661
#cutoff              0.04835162


cutoff = 0.04835162
test.pred = rep(0, nrow(credit.test6))
test.pred[prob.predict6 > cutoff] = 1




  

M = table(test.pred, credit.test6$DEFAULT,dnn=c("Prediction","Observation"))
M


               #Observation
#Prediction      0      1
      #0     102145   2177
       #1     46995   5511



# Test pour voir l'évolution de PROFIT_LOSS

credit.test6$test.pred = test.pred

credit.test6$loss_test = ifelse ( (credit.test6$test.pred == 1 & credit.test6$PROFIT_LOSS < 0), 0, 
                                  credit.test6$PROFIT_LOSS)

credit.test6$loss_test2 = ifelse ( (credit.test6$test.pred == 1 & credit.test6$DEFAULT == 0), 0, 
                                   credit.test6$loss_test)

#somme de PROFIT_LOSS en test avant modèle 43 097 531 et somme après modèle 81 097 638








# Maximiser le taux de vrais positifs pour un certain seuil de faux positifs
pred6_bis = prediction(prob.predict6, credit.test6$DEFAULT)
perf6_bis = performance(pred6_bis, measure="tpr", x.measure="fpr")


cutoffs=data.frame(cut = perf6_bis@alpha.values[[1]], fpr = perf6_bis@x.values[[1]], 
                   tpr = perf6_bis@y.values[[1]])
head(cutoffs)


cutoffs <- cutoffs[order(cutoffs$tpr, decreasing=TRUE),]
head(subset(cutoffs, fpr < 0.4))


cutoff2 = 0.03968678
test.pred2 = rep(0, nrow(credit.test6))
test.pred2[prob.predict6 > cutoff2] = 1



M2 = table(test.pred2, credit.test6$DEFAULT,dnn=c("Prediction","Observation"))
M2



#           Observation
#Prediction     0     1
#       0     89491  1585
#       1     59649  6103




# Test pour voir l'évolution de PROFIT_LOSS

credit.test6$test.pred2 = test.pred2

credit.test6$loss_test3 = ifelse ( (credit.test6$test.pred2 == 1 & credit.test6$PROFIT_LOSS < 0), 0, 
                                  credit.test6$PROFIT_LOSS)

credit.test6$loss_test4 = ifelse ( (credit.test6$test.pred2 == 1 & credit.test6$DEFAULT == 0), 0, 
                                   credit.test6$loss_test3)

#somme de PROFIT_LOSS en test avant modèle 43 097 531 et somme après modèle 76 901 574







cutoffs <- cutoffs[order(cutoffs$tpr, decreasing=TRUE),]
head(subset(cutoffs, fpr < 0.45))


cutoff3 = 0.03542061
test.pred3 = rep(0, nrow(credit.test6))
test.pred3[prob.predict6 > cutoff3] = 1



M3 = table(test.pred3, credit.test6$DEFAULT,dnn=c("Prediction","Observation"))
M3




#           Observation
#Prediction     0       1
#       0     82028    1282
#       1     67112    6406




# Test pour voir l'évolution de PROFIT_LOSS

credit.test6$test.pred3 = test.pred3

credit.test6$loss_test5 = ifelse ( (credit.test6$test.pred3 == 1 & credit.test6$PROFIT_LOSS < 0), 0, 
                                   credit.test6$PROFIT_LOSS)

credit.test6$loss_test6 = ifelse ( (credit.test6$test.pred3 == 1 & credit.test6$DEFAULT == 0), 0, 
                                   credit.test6$loss_test5)

#somme de PROFIT_LOSS en test avant modèle 43 097 531 et somme après modèle 72 919 814


