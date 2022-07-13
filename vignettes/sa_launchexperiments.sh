#!/bin/bash
# Prepare df for numerical exploration
echo "source('sa_preparedf.R')" | Rscript -


for GSE in `cat ourgses.txt`
do
  RCODE="MODESA=TRUE ; gse='${GSE}' ; source('sa_callpipeline.R')"
  echo ${RCODE} 
  echo ${RCODE} | Rscript -
done

