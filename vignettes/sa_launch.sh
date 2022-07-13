#!/bin/bash
for GSE in gseGSE40279n100seed1p1000 gseGSE40279n100seed2p1000 gseGSE40279n100seed3p1000
do
 echo "MODESA=TRUE ; gse='${GSE}' ; rmarkdown::render('00_fullpipeline1.Rmd', output_file=paste0('00_fullpipeline1_', gse, '.Rmd'))" | Rscript -
done

