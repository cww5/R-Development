#Connor Watson
#Lab9 Codes
train_data = read.csv('/Users/watson/Documents/cs636/kkbox/train_v2.csv', header = T)
trans_data = read.csv('/Users/watson/Documents/cs636/kkbox/transactions_v2.csv', header = T)
merged <- merge(train_data, trans_data, by="msno")
sample_data <- merged
sample_data$is_churn <- as.numeric(sample_data$is_churn)
sample_data$msno <- as.numeric(sample_data$msno)
data <- (sample_data - min(sample_data, na.rm=TRUE))/(max(sample_data,na.rm=TRUE) - 
                                                              min(sample_data, na.rm=TRUE))
set.seed(17)
ind <- sample(2, nrow(data), replace =T, prob = c(0.7,0.3))
train_1 <-data[ind==1,]
test_1 <- data[ind==2,]
library(neuralnet)
names <- names(train_1)
formula <- as.formula(paste("is_churn ~", paste(names[!names %in% "is_churn"], collapse = " + ")))
nmodel <- neuralnet(formula, data=train_1, hidden=3,
                    linear.output = FALSE)
plot(nmodel)
p <- nmodel$net.result[[1]]

pred <- compute(nmodel,train_1[,-1])
p_res <- pred$net.result
p_res <- ifelse(p_res>0.5,1,0)
tab_res <- table(predicted=p_res, Actual = train_1$is_churn)
tab_res
(1- sum(diag(tab_res)/sum(tab_res))) * 100
(sum(diag(tab_res)/sum(tab_res))) * 100

pred <- compute(nmodel,test_1[,-1])
p_res_2 <- pred$net.result
p_res_2 <- ifelse(p_res_2>0.5,1,0)
tab_res_2 <- table(predicted=p_res_2, Actual = test_1$is_churn)
tab_res_2
(1- sum(diag(tab_res_2)/sum(tab_res_2))) * 100
(sum(diag(tab_res_2)/sum(tab_res_2))) * 100

detach(package:neuralnet, unload = T)

library(ROCR)
nn.pred = prediction(p_res_2, test_1$is_churn)
pref <- performance(nn.pred, "tpr", "fpr")
plot(pref)

auc.perf = performance(nn.pred, measure = "auc")
auc.perf@y.values  #area is 0.5

rm(list = ls())
detach(package:ROCR, unload = T)

#_____________________________________________________

train_data = read.csv('/Users/watson/Documents/cs636/kkbox/train_v2.csv', header = T)
trans_data = read.csv('/Users/watson/Documents/cs636/kkbox/transactions_v2.csv', header = T)
merged <- merge(train_data, trans_data, by="msno")

set.seed(17)
ind <- sample(2, nrow(merged), replace = T, prob = c(0.1, 0.9))
sample_data <- merged[ind == 1,]
data <- sample_data
data$is_churn <- as.factor(data$is_churn)
set.seed(17)
ind <- sample(2, nrow(data), replace = T, prob = c(0.7, 0.3))
train_2 <- data[ind==1,]
test_2 <- data[ind==2,]
#install.packages("randomForest")
library(randomForest)
rf <- randomForest(is_churn ~ + payment_method_id + payment_plan_days + plan_list_price + actual_amount_paid + 
        is_auto_renew + transaction_date + membership_expire_date + is_cancel, train_2,
        importance = T,  ntree = 100, mtry = 8)
rf
#install.packages('e1071', dependencies=TRUE)
library(caret)
library(ROCR)
library(pROC)
pred_1 <- predict(rf, train_2)
confusionMatrix(pred_1, train_2$is_churn)
pred1_ints <- ifelse(as.numeric(pred_1)==1,0,1)
pred1_ints
train_pred <- prediction(pred1_ints, train_2$is_churn)
train_perf <- performance(train_pred, 'tpr', 'fpr')
plot(train_perf)
auc.perf_1 = performance(train_pred, measure = "auc")
auc.perf_1@y.values

pred_2 <- predict(rf, test_2)
confusionMatrix(pred_2, test_2$is_churn)
pred2_ints <- ifelse(as.numeric(pred_2)==1,0,1)
pred2_ints
test_pred <- prediction(pred2_ints, test_2$is_churn)
test_perf <- performance(test_pred, 'tpr', 'fpr')
plot(test_perf)
auc.perf_2 = performance(test_pred, measure = "auc")
auc.perf_2@y.values

varImpPlot(rf)
plot(rf)