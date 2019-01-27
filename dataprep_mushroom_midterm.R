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
