# ```{r launch champ package}
library(ChAMP)
library(stringr)

print("Which analysis do you want to do ? (450k/EPIC)")
analysis<-"EPIC"

print("Do you want to exclude XY probes from analysis ? (TRUE/FALSE)")
XY<-TRUE

myLoad<-champ.load(directory="datashare/GRIMEC001/raw/", autoimpute=TRUE, detPcut=0.01, filterXY=XY, arraytype=analysis)
myLoad$pd$Slide<-as.character(as.factor(myLoad$pd$Slide))

dir.create(path="datashare/GRIMEC001/Results")
dir.create(path="datashare/GRIMEC001/Results/ChAMP")

save(myLoad, file = file.path("datashare/GRIMEC001/Results/ChAMP/myLoad.rda"))
champ.QC(beta=myLoad$beta,pheno=myLoad$pd$Sample_Group,resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_QCimages_Sample_Group/")

# ```
#
# ```{r normalization}

normali<-"Yes"

if(file.exists(file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.rda"))){
  if(normali == "Yes"){
    myNorm<-champ.norm(beta=myLoad$beta,method="PBC",arraytype=analysis,core=detectCores(),resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_Normalization/")
    # myNorm<-champ.norm(beta=myLoad$beta,arraytype=analysis,core=detectCores(),resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_Normalization/")
    save(myNorm, file = file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.rda"))
    write.table(cbind(rownames(myNorm),data.frame(myNorm,row.names=NULL)),file = file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.csv"),sep = ",",row.names = F)
    betavalplot<-boxplot(myNorm,cex.axis = 0.8, las =2, ylab = "BetaValue")
    save(betavalplot,file = file.path("datashare/GRIMEC001/Results/ChAMP/betavalueplot.png"))
    champ.SVD(beta = as.data.frame(myNorm),resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_SVDimages/")
  if(normali == "No"){
    load("datashare/GRIMEC001/Results/ChAMP/myNorm.rda")
    }
  }
}
if(!(file.exists(file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.rda")))){
  myNorm<-champ.norm(beta=myLoad$beta,method="PBC",arraytype=analysis,core=detectCores(),resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_Normalization/")
  # myNorm<-champ.norm(beta=myLoad$beta,arraytype=analysis,core=detectCores(),resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_Normalization/")
  save(myNorm, file = file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.rda"))
  write.table(cbind(rownames(myNorm),data.frame(myNorm,row.names=NULL)),file = file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.csv"),sep = ",",row.names = F)
  betavalplot<-boxplot(myNorm,cex.axis = 0.8, las =2, ylab = "BetaValue")
  save(betavalplot,file = file.path("datashare/GRIMEC001/Results/ChAMP/betavalueplot.png"))
  champ.SVD(beta = as.data.frame(myNorm),resultsDir="datashare/GRIMEC001/Results/ChAMP/CHAMP_SVDimages/")
}

# ```
#
# ```{r batch correction}
batchcorr<-"No"

if(batchcorr == "Yes"){
  myCombat<-champ.runCombat()
  save(myCombat, file = file.path("datashare/GRIMEC001/Results/ChAMP/myCombat.rda"))
  myNorm<-myCombat
  write.table(cbind(rownames(myNorm),data.frame(myNorm,row.names=NULL)),file = file.path("datashare/GRIMEC001/Results/ChAMP/myNorm.csv"),sep = ",",row.names = F)
}
gc()

# ```
#
# ```{r sample name}
s$data = myNorm
s$stuffs$orig = "ChAMP"
s$platform_name = "GPL21145"
# saveRDS(myNorm,"datashare/GRIMEC001/df_GRIMEC001.rds")
# ```









