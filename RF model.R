library(randomForest)
library(caret)
library(doParallel)
library(foreach)

housedata<-read.csv('C:\\Users\\Liu\\Desktop\\毕业论文\\预处理后数据集.csv',
                    header=TRUE)
names(housedata)
summary(housedata)

set.seed(666)
createDataPartition(y=housedata$unitprice,p=0.75,list = FALSE)->inTrain
trainset<-housedata[inTrain,]
testset<-housedata[-inTrain,]
RF<-randomForest(unitprice~.,data=trainset,importance=TRUE)
print(RF)
predict(RF,trainset)->pred_train
1-sum((pred_train-trainset$unitprice)^2)/sum((trainset$unitprice-mean(trainset$unitprice))^2)
sqrt(mean((pred_train-trainset$unitprice)^2))
mean(abs(pred_train-trainset$unitprice))
mean(abs(pred_train-trainset$unitprice)/trainset$unitprice)
head(cbind(trainset$unitprice,pred_train,abs(pred_train-trainset$unitprice)),10)

predict(RF,testset)->pred_test
1-sum((pred_test-testset$unitprice)^2)/sum((testset$unitprice-mean(testset$unitprice))^2)
sqrt(mean((pred_test-testset$unitprice)^2))
mean(abs(pred_test-testset$unitprice))
mean(abs(pred_test-testset$unitprice)/testset$unitprice)
head(cbind(testset$unitprice,pred_test,abs(pred_test-testset$unitprice)),10)

RF$mse
plot(RF)

MRE_train<-c()
MRE_test<-c()
i=0
cl <- makeCluster(4)
registerDoParallel(cl)
for(t in c(2:20))
  {i=i+1
  RF1<- foreach(ntree=rep(100, 4), 
              .combine=combine,
              .packages='randomForest') %dopar% randomForest(unitprice~., 
                                                             data=trainset, 
                                                             ntree=ntree, 
                                                             mtry=t)
  MRE_train[i]<-mean(abs(predict(RF1,trainset)-trainset$unitprice)/trainset$unitprice)
  MRE_test[i]<-mean(abs(predict(RF1,testset)-testset$unitprice)/testset$unitprice)}
stopCluster(cl)

MRE_train2<-c()
MRE_test2<-c()
i=0
cl <- makeCluster(4)
registerDoParallel(cl)
for(t in seq(from=100,to=1000,by=100))
  {i=i+1
  RF1<- foreach(ntree=rep(t/4, 4), 
               .combine=combine,
               .packages='randomForest') %dopar% randomForest(unitprice~., 
                                                              data=trainset, 
                                                              ntree=ntree,
                                                              mtry=18)
  MRE_train2[i]<-mean(abs(predict(RF1,trainset)-trainset$unitprice)/trainset$unitprice)
  MRE_test2[i]<-mean(abs(predict(RF1,testset)-testset$unitprice)/testset$unitprice)
  }
stopCluster(cl)

RF_final<-randomForest(unitprice~., data=trainset, ntree=400, mtry=18, 
                       importance=TRUE,do.trace=TRUE)
predict(RF_final,trainset)->pred_train
predict(RF_final,testset)->pred_test

imp<-importance(RF_final)
varImpPlot(RF_final)

#线性回归
LM<-lm(unitprice~.,data=trainset)
summary(LM)
step(LM)

predict(LM,trainset)->pred_LM
1-sum((pred_LM-trainset$unitprice)^2)/sum((trainset$unitprice-mean(trainset$unitprice))^2)
sqrt(mean((pred_LM-trainset$unitprice)^2))
mean(abs(pred_LM-trainset$unitprice))
mean(abs(pred_LM-trainset$unitprice)/trainset$unitprice)

predict(LM,testset)->pred_LM2
1-sum((pred_LM2-testset$unitprice)^2)/sum((testset$unitprice-mean(testset$unitprice))^2)
sqrt(mean((pred_LM2-testset$unitprice)^2))
mean(abs(pred_LM2-testset$unitprice))
mean(abs(pred_LM2-testset$unitprice)/testset$unitprice)


