library(caret)
library(ROCR)
library(pROC)
library(dplyr)
#library(nnet)

#Below is the code for problem 1
trainlabels <- "C:\\Users\\watson\\Documents\\cs636\\kkbox\\train.csv"
traindata <- "C:\\Users\\watson\\Documents\\cs636\\kkbox\\transactions.csv"

tl <- read.csv(trainlabels)
td <- read.csv(traindata)
merged <- merge(tl, td, by="msno", all=F)
colnames(merged)

total_rows <- nrow(merged)
total_rows

half <- total_rows %/% 2
train <- merged[1:half,]
test <- merged[(half+1):total_rows,]
nrow(train)
nrow(test)

#~ 1min
model <- glm(is_churn ~ transaction_date + membership_expire_date + is_cancel,
             family=binomial(link='logit'), data=train)

summary(model)

fitted.results <- predict(model,newdata=test,type='response')
median(unique(fitted.results), na.rm=T)
mean(unique(fitted.results), na.rm=T)

#This contains roughly the median as the decision boundary
a.results <- ifelse(fitted.results > 0.07,1,0)
a.misClasificError <- mean(a.results != test$is_churn, na.rm=T)
a.misClasificError
print(paste('Accuracy',1-a.misClasificError))

a.pr <- prediction(fitted.results, test$is_churn)
a.prf <- performance(a.pr, measure = "tpr", x.measure = "fpr")
plot(a.prf)

a.auc <- performance(a.pr, measure = "auc")
a.auc <- a.auc@y.values[[1]]
a.auc

#Below is the code for Problem 2 (Cannot verify if it works or not)
#Create 5 folds for cross validation (~ 4:05)
set.seed(42)
#~6 min
b.folded_model <- train(is_churn ~ transaction_date + membership_expire_date + is_cancel, merged,
                      method="glm",
                      trControl=trainControl(
                        method="cv", number=5,
                        verboseIter=T
                      )
)
b.folded.results <- predict(b.folded_model,test)

#This contains roughly the median as the decision boundary
b.results <- ifelse(b.folded.results > 0.07,1,0)
b.misClasificError <- mean(b.results != test$is_churn, na.rm=T)
b.misClasificError
print(paste('Accuracy',1-b.misClasificError))

b.pr <- prediction(b.folded.results, test$is_churn)
b.prf <- performance(b.pr, measure = "tpr", x.measure = "fpr")
plot(b.prf)

b.auc <- performance(b.pr, measure = "auc")
b.auc <- b.auc@y.values[[1]]
b.auc

#Below is the code for Problem 3
testdata_csv <- "C:\\Users\\watson\\Documents\\cs636\\kkbox\\sample_submission_zero.csv"
test_data <- read.csv(testdata_csv)
nrow(test_data)
#6 mins
#merge training data with the labels from test data for classification
merged_test <- merge(td, test_data, by="msno", all=F)
colnames(merged_test)

nrow(merged)
c.merged <- merged[1:1000000,] #use most of the data
c.model <- glm(is_churn ~ transaction_date + membership_expire_date + is_cancel,
             family=binomial(link='logit'), data=c.merged)

summary(c.model)
colnames(c.merged)

c.fitted.results <- predict(c.model,newdata=merged_test,type='response')
median(unique(c.fitted.results), na.rm=T)
mean(unique(c.fitted.results), na.rm=T)

#This contains roughly the median as the decision boundary
c.results <- ifelse(c.fitted.results > 0.07,1,0)
c.misClasificError <- mean(c.results != merged_test$is_churn, na.rm=T)
c.misClasificError
print(paste('Accuracy',1-c.misClasificError))

nrow(merged_test) == length(c.results)
nrow(merged_test)
colnames(merged_test)
labels.needed <- merged_test[1]
predictions.made <- cbind(labels.needed, c.results)
colnames(predictions.made) <- c("msno", "is_churn")
pred.df <- predictions.made[!duplicated(predictions.made$msno), ]
nrow(pred.df)
write.table(pred.df, file = "C:\\Users\\watson\\Documents\\cs636\\kkbox.csv",row.names=FALSE, sep=",")
kag.df <- pred.df[1:907471,]
nrow(kag.df)
write.table(kag.df, file = "C:\\Users\\watson\\Documents\\cs636\\kkbox_submission.csv",row.names=FALSE, sep=",")
