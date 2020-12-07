install.packages("polycor")
library(polycor)

#Import the Data
#data = read.csv()
data[1:5, 1:5]

data2 = data[,-c(1:2)]
data2[1:5, 1:5]
correlationDF = data.frame()
 
for(i in 1:nrow(data)){
   matrixCor = hetcor(data$Grade, data2[,i])
   matrixCor$correlations[1,2]
   correlationDF = rbind(correlationDF, matrixCor$correlations[1,2])
   rownames(correlationDF)[i] = colnames(data2)[i]
   print(i/nrow(data))
}
 