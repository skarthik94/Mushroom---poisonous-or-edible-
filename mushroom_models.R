library(xgboost)
library('neuralnet')
library(randomForest)
library(boot)
library(randomForest)
library(GoodmanKruskal)
library(corrplot)
mushroom_data = read.csv("C:/Users/Karthik/Desktop/MSDA/sem 4-fall 2018/data preparation/project/mushrooms.csv")
table(mushroom_data$cap.shape)
for (i in c(levels(mushroom_data$veil.color))){  #useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$veil.color == i]))
}

for (i in c(levels(mushroom_data$gill.attachment))){  #might be useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$gill.attachment == i]))
}

colnames(mushroom_data)
for (i in c(levels(mushroom_data$ring.number))){  #might be useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$ring.number == i]))
}
mushroom_data = mushroom_data[, !(names(mushroom_data) %in% c('veil.type'))]
GKtauDataframe(mushroom_data)
mushroom_data = mushroom_data[, !(names(mushroom_data) %in% c('gill.attachment','stalk.shape'))]

rf_mush = randomForest(class~.,data = mushroom_data)
rf_mush = randomForest(class~odor+spore.print.color+gill.color+gill.size+ring.type+stalk.surface.above.ring+stalk.surface.below.ring,data = mushroom_data)
rf_mush$importance
varImpPlot(rf_mush)    

for (i in c(levels(mushroom_data$odor))){  #useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$odor == i]))
}

for (i in c(levels(mushroom_data$spore.print.color))){  #useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$spore.print.color == i]))
}

for (i in c(levels(mushroom_data$gill.color))){  #useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$gill.color == i]))
}

for (i in c(levels(mushroom_data$gill.size))){  #useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$gill.size == i]))
}

for (i in c(levels(mushroom_data$stalk.surface.above.ring))){  #useful
  print(i)
  print(table(mushroom_data$class[mushroom_data$stalk.surface.above.ring == i]))
}

mushroom_data_cut = mushroom_data[c('class','odor','spore.print.color','gill.color','gill.size','ring.type','stalk.surface.above.ring'
                                    ,'stalk.surface.below.ring')]

neural_data = model.matrix(~ . + 0, data=mushroom_data_cut)
neural_data = as.data.frame(neural_data)     
y = mushroom_data$class
x = mushroom_data[c('odor','spore.print.color','gill.color','gill.size','ring.type','stalk.surface.above.ring','stalk.surface.below.ring')]

#random forest
#with the default mtry=sqrt(no of features)=2 at each split
rf_mush = randomForest(class~odor+spore.print.color+gill.color+gill.size+ring.type+stalk.surface.above.ring,data = mushroom_data) #0.02% OOB error
rf_mush

tuneRF(x,y, improve=1e-5)

rf_mush_tuned = randomForest(class~odor+spore.print.color+gill.color+gill.size+ring.type+stalk.surface.above.ring
                             ,data = mushroom_data,mtry = 4) #0% OOB error

#neural network
neural_data = neural_data[,!(names(neural_data) %in% c('classp'))]

error = 0
k = 10

n = names(neural_data[,!(names(neural_data) %in% c('classe'))])
f <- as.formula(paste("classe ~", paste(n[!n %in% "medv"], collapse = " + ")))
for(i in 1:k){
  index <- sample(1:nrow(neural_data),round(0.9*nrow(neural_data)))
  train.cv <- neural_data[index,]
  test.cv <- neural_data[-index,]
  
  nn <- neuralnet(f,data=train.cv,hidden=c(5,2),linear.output=T)
  
  pr.nn <- compute(nn,test.cv[,2:39])
  pr.nn <- pr.nn$net.result
  pr.nn = ifelse(pr.nn >0.5,1,0)
  
  tab = table(pr.nn,test.cv$classe)
  error = error + 1-sum(diag(tab))/sum(tab)
  
}
error_cv = error/10 #0% error with 10-fold cross validation


#XGboost
target = as.numeric(y)-1
xg_features = model.matrix(~.+0,data = mushroom_data_cut[c('odor','spore.print.color','gill.color','gill.size','ring.type','stalk.surface.above.ring'
                                                           ,'stalk.surface.below.ring')], with=F)
xg_data = xgb.DMatrix(data = xg_features,label = target)
params = list(booster = "gbtree", objective = "binary:logistic", eta=0.3, gamma=0, max_depth=6, min_child_weight=1, subsample=1, colsample_bytree=1)
xgbcv = xgb.cv( params = params, data = xg_data, nrounds = 100, nfold = 5, showsd = T, stratified = T, print.every.n = 10
                 , early.stop.round = 20, maximize = F) # 0% test error
