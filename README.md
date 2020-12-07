### Author: Bernardo Jordan

### Abstract

Glioblastoma is a highly aggressive form of primary brain tumor that is not fully understood. Even with our current advancements in treatments, the survival rate of patients is very poor. Therefore, research is being done in detecting and understanding low grade glioblastoma in hopes of providing better treatment. 

### Objectives

Goal of the Capstone:
* Create a process to create biologically relevent models using Pathway Analysis.
* Use these different models to detect Low-Grade Glioblastoma.
* Explore casuality between pathways using a Bayesian Network.
* Compare the Pathway created models to Gene created models.

### Dataset

The dataset used was the REMBRANT dataset. This dataset consisted of genetic expression data for patients that had Glioblastoma and their grade.

### Methods
To achieve the goals laid out, Pathway Eigengenes were first created using a package called PathwayPCA. These Pathway Eigengenes are representative of a biological pathway. The Pathway Eigengenes were then used to create a Bayesian Network that could be used as a predictive model. This model was compared to other popular classification models. In addition, the Bayesian Network as was explored and analyzed for biological significance and relevance.


<img src="Images/Method Overview.png" width="600" height="300" />

### Results
Accuracy Results show that the Pathway Approach gave an increase in Accuracy for most models. In additon, the Bayesian Network was non-inferior to the other models.

<img src="Images/Accuracy Results.PNG" width="600" height="300" />

Pathway Node directly connected to the Glioblastoma Node in the Pathway Approach Bayesian Network.

<img src="Images/Pathway network snippet.png" width="600" height="300" />

Gene Nodes directly connected to the Glioblastoma Node in the Gene Bayesian Network.

<img src="Images/Gene network snippet.png" width="600" height="300" />

Literature Analysis of the nodes connected to Glioblastoma. The Gene network made more connections but they are not all biologically relevent while the Pathway Network is. This shows the advantages of using a Pathway Approach for clinical relevance.

<img src="Images/Literature Analysis.PNG" width="600" height="300" />

### Conclusion

The Pathway Approach created models that were biologically relevant and more accurate than models created using Genes. In addition, the Bayesian Network approach proved to be advantageous because it can be used to delineate pathways that are associated with Glioblastoma, unlike the other algorithms that function more as a classifier. If combined with new research, this approach could be used to help Clinicans detect Glioblastoma earlier and better coordinate treatment in hopes of raising the survival rate of patients. 
