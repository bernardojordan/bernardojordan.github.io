#Install latest version of BiocManager
#Note: This was done on R 4.0.3. This may not work on other versions
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.12")
BiocManager::version()  

BiocManager::install("Biobase")
BiocManager::install("GEOquery")
BiocManager::install("biomaRt")

#Packages
library(Biobase)
library(GEOquery)
library(biomaRt)
library(limma)

# load series and platform data from GEO
gset <- getGEO("GSE108474", GSEMatrix =TRUE, getGPL=FALSE)
if (length(gset) > 1) idx <- grep("GPL570", attr(gset, "names")) else idx <- 1
gset <- gset[[idx]]

#Extract Important Data
expressionData = as.data.frame(gset@assayData$exprs)
gradeData = as.data.frame(gset@phenoData@data$`tumor grade:ch1`)
diseaseData = as.data.frame(gset@phenoData@data$`disease:ch1`)
rownames(expressionData)

#Grade Information
#VERY IMPORTANT TO VERIFY WITH THE ORIGINAL DATASET THAT THE CORRECT SAMPLE WAS LABEL 
#WITH THE CORRECT GRADE
test = as.data.frame(t(expressionData[1,]))
gradeInfo = cbind(test, diseaseData, gradeData)
gradeInfo = gradeInfo[,-1]
#Grade for control
for(i in 1:nrow(gradeInfo)){
  if(gradeInfo[i,1] == "normal"){
    gradeInfo[i,2] = 0
  }
}
#For other grades
names(gradeInfo)[names(gradeInfo) == "gset@phenoData@data$`tumor grade:ch1`"] = "Grade"
gradeInfo$Grade[which(gradeInfo$Grade == "grade 1")] = 1
gradeInfo$Grade[which(gradeInfo$Grade == "grade 2")] = 2
gradeInfo$Grade[which(gradeInfo$Grade == "grade 3")] = 3
gradeInfo$Grade[which(gradeInfo$Grade == "grade 4")] = 4
gradeInfoCleaned = na.omit(gradeInfo)
gradeReady = as.data.frame(gradeInfoCleaned[,-1])
rownames(gradeReady) = rownames(gradeInfoCleaned)
names(gradeReady)[] = "Grade"

#Convert Affymetrix IDs to HUGO gene symbols
mart <- useMart("ENSEMBL_MART_ENSEMBL")
mart <- useDataset("hsapiens_gene_ensembl", mart)
annotLookup <- getBM(
  mart = mart,
  attributes = c(
    "affy_hg_u133_plus_2",
    "ensembl_gene_id",
    "gene_biotype",
    "external_gene_name"),
  filter = "affy_hg_u133_plus_2",
  values = rownames(exprs(gset)),
  uniqueRows=TRUE)

geneIDS = data.frame(annotLookup$affy_hg_u133_plus_2, annotLookup$external_gene_name)
geneIDSCleaned = geneIDS[!duplicated(geneIDS$annotLookup.affy_hg_u133_plus_2),]
rownames(geneIDSCleaned) = geneIDSCleaned$annotLookup.affy_hg_u133_plus_2

ds1 = merge(geneIDSCleaned, expressionData, by=0, all=TRUE)

#Always verify that the data has no NAs. In this dataset, the last 8 samples
#contained nothing but NAs. As a result, they needed to be dropped. Then, any NAs 
#caused by a results of the merge were removed. 
ds1[1,545]
ds1[1,546]
ds1[1,547]
ds1[1,548]
ds1[1,549]
ds1[1,550]
ds1[1,551]
ds1[1,552]
ds1[1,553]

ds2 = ds1[,-c(546:553)]
ds3 = na.omit(ds2)
ds3[1:5,1:5]
names(ds3)[names(ds3) == "annotLookup.external_gene_name"] = "Genes"
ds3[1:5, 1:5]


final = as.data.frame(avereps(ds3, ID = ds3$Genes))
rownames(final) = final$Genes
final = final[,-c(1:2)]
final[1:5, 1:5]

dataset = as.data.frame(t(final))
dataset = dataset[-1,]
dataset[1:5, 1:5]

gradedDataset = merge(gradeReady, dataset, by=0, all = TRUE)
gradedDataset[1:5,1:5]
gradedDataset$Grade
gradedDataset[546,1]
gradedDatasetFinal = na.omit(gradedDataset)
gradedDatasetFinal[1:5, 1:5]

#At this point, point, the data can be subsetted by grade. It is important to leave
#the first row columns containing the sample IDs because pathwayPCA requires that the 
#sample IDs be in the first column.
