#Connor Watson
#Lab9 Codes
train_v2_data = read.csv('/Users/watson/Documents/cs636/kkbox/train_v2.csv', header = T)
transaction_v2_data = read.csv('/Users/watson/Documents/cs636/kkbox/transactions_v2.csv', header = T)
train_transaction_v2 <- merge(train_v2_data, transaction_v2_data, by="msno")
data_sample_v2 <- train_transaction_v2
data_sample_v2$is_churn <- as.numeric(data_sample_v2$is_churn)
data_sample_v2$msno <- as.numeric(data_sample_v2$msno)
data <- (data_sample_v2 - min(data_sample_v2, na.rm=TRUE))/(max(data_sample_v2,na.rm=TRUE) - 
                                                              min(data_sample_v2, na.rm=TRUE))
set.seed(17)
ind <- sample(2, nrow(data), replace =T, prob = c(0.7,0.3))
train1 <-data[ind==1,]
test1 <- data[ind ==2,]
library(neuralnet)
n <- names(train1)
f <- as.formula(paste("is_churn ~", paste(n[!n %in% "is_churn"], collapse = " + ")))
nmodel <- neuralnet(f, data=train1, hidden=3,
                    linear.output = FALSE)
plot(nmodel)
p <- nmodel$net.result[[1]]

pred <- compute(nmodel,train1[,-1])
p5 <- pred$net.result
p5 <- ifelse(p5>0.5,1,0)
tab5 <- table(predicted=p5, Actual = train1$is_churn)
tab5
#Actual
#predicted      0 0.0000000494295410808174
#0 713228                    79398
(1- sum(diag(tab5)/sum(tab5))) * 100
(sum(diag(tab5)/sum(tab5))) * 100
#[1] 89.98291754

pred <- compute(nmodel,test1[,-1])
p6 <- pred$net.result
p6 <- ifelse(p6>0.5,1,0)
tab6 <- table(predicted=p6, Actual = test1$is_churn)
tab6
#Actual
#predicted      0 0.0000000494295410808174
#0 305235                    34175
(1- sum(diag(tab6)/sum(tab6))) * 100
#[1] 10.06894317
(sum(diag(tab6)/sum(tab6))) * 100
#[1] 89.93105683