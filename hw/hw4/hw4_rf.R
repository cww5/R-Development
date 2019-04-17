## Loading train data which contains msno and is_churn
train_v2_data = read.csv('/Users/watson/Documents/cs636/kkbox/train_v2.csv', header = T)
transaction_v2_data = read.csv('/Users/watson/Documents/cs636/kkbox/transactions_v2.csv', header = T)
train_transaction_v2 <- merge(train_v2_data, transaction_v2_data, by="msno")

set.seed(511)
ind <- sample(2, nrow(train_transaction_v2), replace = T, prob = c(0.1, 0.9))
data_sample <- train_transaction_v2[ind == 1,]
data <- data_sample
data$is_churn <- as.factor(data$is_churn)
set.seed(511)
ind <- sample(2, nrow(data), replace = T, prob = c(0.7, 0.3))
train <- data[ind==1,]
test <- data[ind==2,]
install.packages("randomForest")
library(randomForest)
rf <- randomForest(is_churn ~ + payment_method_id + payment_plan_days + plan_list_price + actual_amount_paid + 
                                 is_auto_renew + transaction_date + membership_expire_date + is_cancel, train,
                               importance = T,  ntree = 100, mtry = 8)
rf
#install.packages("caret")
install.packages('e1071', dependencies=TRUE)
library(caret)
p1 <- predict(rf, train)
confusionMatrix(p1, train$is_churn)
p2 <- predict(rf, test)
confusionMatrix(p2, test$is_churn)
par(mar=c(1,1,1,1))
par("mar")
varImpPlot(rf)
plot(rf)

rm(list=ls())
