install.packages("tidyverse")
install.packages("matrixStats")
BiocManager::install("pathwayPCA")
BiocManager::install("rWikiPathways")

library(tidyverse)
library(matrixStats)
library(pathwayPCA)
library(rWikiPathways)

#NOTE: This code only shows how to overall use pathwayPCA and their functions. 
#Please adjust the code to meet your needs.

#After importing the dataset, the pathway collection needs to be downloaded from MSigDB
#download the lastest collection from https://www.gsea-msigdb.org/gsea/msigdb/collections.jsp

#Pathway collection
gmt_path = "C:/Users/berna/Desktop/Capstone/c2.cp.v7.2.symbols.gmt"
cp_pathwayCollection <- read_gmt(gmt_path, description = TRUE)
cp_pathwayCollection

#Create OMIC Data Container
#NOTE: The dataset must have the sample IDs as the first column, not as row names
#OmicSurv Data Container
cancer_Omic = CreateOmics(
  #expression data
  assayData_df = data[,-2],
  #pathway collection
  pathwayCollection_ls = cp_pathwayCollection,
  #survival phenotypes/survival data
  response = data[, c(1:2)],
  #At the current moment, pathwayPCA only takes binary data response data.
  respType = "categ",
  #retain pathways with > 5 proteins
  #This can be changed to allow pathways with less than 5 proteins to be included
  #However, pathways with less than 5 proteins are usually not reliable. 
  minPathSize = 5
)

#Performing PCA. Both supervised and adaptive, elastic-net, sparse PCA exists.
#Refer to help section of package to find the function for supervised
#AES-PCA
cancer_aespcOut = AESPCA_pVals(
  #Omics data container
  object = cancer_Omic,
  #One principal component
  numPCs = 1,
  #parallel computing
  parallel = TRUE, #Specify if you want parallel computing
  numCores = 3, #How many cores. It defaults to max - 1 cores.
  #Estimate p-values parametrically
  numReps = 0,
  #Control FDR via Benjamini-Hochberg
  adjustment = "BH",
  asPCA = TRUE
)

#Identify Pathways
getPathpVals(cancer_aespcOut, numPaths = 10)

#contrust p value plots
#Can be set to take top pathways using numpaths parameter instead of alpha
#PathwayPCA puts the pathways in descending order of highest significace by default
cancerOutGather_df = getPathpVals(cancer_aespcOut, score = TRUE, alpha = 0.001)
view(getPathpVals(cancer_aespcOut, score = FALSE, alpha = .001))

#ploting
ggplot(cancerOutGather_df[1:10,]) +
  theme_bw() +
  #dependent and independent
  aes(x = reorder(terms, score), y = score) +
  #create vertical bar chart
  geom_col(position = "dodge", fill = "#66FFFF", width = 0.7) +
  #Add pathway labels
  geom_text(
    aes(x = reorder(terms, score), label = reorder(description, score), y = 0.001),
    color = "black",
    size = 2, 
    hjust = 0
  ) +
  # Set main and axis titles
  ggtitle("AES-PCA Significant Pathways: Brain Cancer") +
  xlab("Pathways") +
  ylab("Negative LN (p-Value)") +
  # Add a line showing the alpha = 0.01 level
  geom_hline(yintercept = -log(0.001), size = 1, color = "blue") +
  # Flip the x and y axes
  coord_flip()

cancerOutGather_df$terms

#Gather all the PCs into a dataframe
table = data.frame()[1:nrows(data4),]
for (i in nrow(cancerOutGather_df)) {
  print(i)
  if (i < 2) {
    df = getPathPCLs(cancer_aespcOut, cancerOutGather_df$terms[i])
    table = cbind(table,df$PCs)
  } else{
    df = getPathPCLs(cancer_aespcOut, cancerOutGather_df$terms[i])
    table = cbind(table,df$PCs[2])
  }
  
}

#Load Test Data
#If performing a train/test split on data. Use the following code 
#to get PCA values for the test set using the trainingset loadings.
test = as.data.frame(LoadOntoPCs(testSet, cancer_aespcOut$loadings_ls))

#Make sure to re-add grade back to the dataset once you have the PCA dataset.
                     