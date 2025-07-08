gses_models = c(
  # Epigentic clocks
  "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
  "GSE147740", # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
  "GSE152026", # Epic, n=934 # Blood DNA methylation profiles from first episode psychosis patients and controls I
  "GSE72680" , 
  "GSE89353" , 
  "GSE87648" , 
  "GSE97362" , 
  "GSE50660" , 
  "GSE72775" , 
  # "GSE136296" ,
  # CustGSEXXXrr
  "CustGSE40279rr", 
  "CustGSE42861rr", 
  "CustGSE87571rr", 
  # "CustGSE147740rr",
  "CustGSE152026rr", 
  "CustGSE72680rr", 
  "CustGSE89353rr" , 
  "CustGSE87648rr", 
  "CustGSE97362rr", 
  "CustGSE50660rr", 
  "CustGSE72775rr", 
  # "CustGSE136296rr", 
  # 27k
  "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
)


# cd 02_wrappers/
# rm -Rf datawrapper_CustGSE40279rr.R           
# rm -Rf datawrapper_CustGSE42861rr.R           
# rm -Rf datawrapper_CustGSE87571rr.R           
# rm -Rf datawrapper_CustGSE72680rr.R           
# rm -Rf datawrapper_CustGSE87648rr.R           
# rm -Rf datawrapper_CustGSE97362rr.R           
# rm -Rf datawrapper_CustGSE50660rr.R           
# rm -Rf datawrapper_CustGSE72775rr.R           
# rm -Rf datawrapper_CustGSE41037rr.R           
# rm -Rf datawrapper_CustGSE136296rr.R           
# rm -Rf expgrpwrapper_CustGSE40279rr.R           
# rm -Rf expgrpwrapper_CustGSE42861rr.R           
# rm -Rf expgrpwrapper_CustGSE87571rr.R           
# rm -Rf expgrpwrapper_CustGSE72680rr.R           
# rm -Rf expgrpwrapper_CustGSE87648rr.R           
# rm -Rf expgrpwrapper_CustGSE97362rr.R           
# rm -Rf expgrpwrapper_CustGSE50660rr.R           
# rm -Rf expgrpwrapper_CustGSE72775rr.R           
# rm -Rf expgrpwrapper_CustGSE41037rr.R           
# rm -Rf expgrpwrapper_CustGSE136296rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE40279rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE42861rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE87571rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE72680rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE87648rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE97362rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE50660rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE72775rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE41037rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE136296rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE40279rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE42861rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE87571rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE72680rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE87648rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE97362rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE50660rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE72775rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE41037rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE136296rr.R           

# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE152026rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE152026rr.R           
# ln -s expgrpwrapper_CustGSE147740rr.R expgrpwrapper_CustGSE89353rr.R           
# ln -s datawrapper_CustGSE147740rr.R   datawrapper_CustGSE89353rr.R           



# git add datawrapper_CustGSE40279rr.R
# git add datawrapper_CustGSE42861rr.R
# git add datawrapper_CustGSE87571rr.R
# git add datawrapper_CustGSE72680rr.R
# git add datawrapper_CustGSE87648rr.R
# git add datawrapper_CustGSE97362rr.R
# git add datawrapper_CustGSE50660rr.R
# git add datawrapper_CustGSE72775rr.R
# git add datawrapper_CustGSE41037rr.R
# git add datawrapper_CustGSE136296rr.R
# git add  expgrpwrapper_CustGSE40279rr.R
# git add  expgrpwrapper_CustGSE42861rr.R
# git add  expgrpwrapper_CustGSE87571rr.R
# git add  expgrpwrapper_CustGSE72680rr.R
# git add  expgrpwrapper_CustGSE87648rr.R
# git add  expgrpwrapper_CustGSE97362rr.R
# git add  expgrpwrapper_CustGSE50660rr.R
# git add  expgrpwrapper_CustGSE72775rr.R
# git add  expgrpwrapper_CustGSE41037rr.R
# git add  expgrpwrapper_CustGSE136296rr.R

