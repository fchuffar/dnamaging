import os 
import os.path

gses = [
  "GSE90496"  ,  # TO CHECK 450k, n=2801 # DNA methylation-based classification of human central nervous system tumors [reference set]
  "GSE109379" ,  # TO CHECK 450k, n=1104 # DNA methylation-based classification of human central nervous system tumors [validation set]
  # "GSE48472"    TO CHECK 450k, n=56  # Identification and systematic annotation of tissue-specific differentially methylated regions using the Illumina 450k array
  # "GSE64495"    TO CHECK 450k, n=113 # DNA methylation profiles of human blood samples from a severe developmental disorder and controls
  # "GSE72774"    TO CHECK 450k, n=508 # DNA methylation profiles of human blood samples from Caucasian subjects with Parkinson's disease
  # "GSE72776"    TO CHECK 450k, n=84  # DNA methylation profiles of human blood samples from Hispanic subjects with Parkinson's disease
  # "GSE61257"    TO CHECK 450k, n=32  # Genome wide DNA methylation profiles of human adipose tissue.
  # "GSE61259"    TO CHECK 450k, n=26  # Genome wide DNA methylation profiles of human muscle tissue.
    # "GSE146917"   TO CHECK 450k, n=76  # DNA methylation profiles of human buffy coat samples from Huntington's disease
  # "GSE64490"    TO CHECK 450k, n=48  # DNA methylation profiles of human bone samples
  # "GSE197719"   TO CHECK 450k, n=27  # In vitro methylation studies in multiple human cell types
  # "GSE142439"   TO CHECK Epic, n=16  # Transient non-integrative nuclear reprogramming promotes multifaceted reversal of aging in human cells
  # NOIDAT "GSE72680",   # 450k, n=422 # DNA Methylation of African Americans from the Grady Trauma Project
  # "GSE140686",  NO GO  mixed 450k & EPIC # n=1500  sarcoma samples
  # NOIDAT "GSE152026",  # Epic, n=934 # Blood DNA methylation profiles from first episode psychosis patients and controls I
  "GSE154566" # WARNING mixed 450k & EPIC (n=1177) only keep EPIC (n=944) # NA methylation signatures of adolescent victimization: Analysis of a longitudinal monozygotic twin sample.
  # "GSE156374",  NO GO # GSE Epilepto # TODO Fabien: few probes on GEO matrix need to used IDAT
  # "GSE197678",  NO GO # could not directly load beta matrix from GEO API for GSE169156 # n=2000 # Childhood Cancer Survivors
  # "GSE68838",       # TCGA COAD



  # NOIDAT "GSE50923",    # PROBLEM no age # 27k GBM vs. normal brain
  # NOIDAT "GSE60753",    # PROBLEM no age # 450k # Alcohol #
  "GSE85210",    # PROBLEM no age # 450k # n=250 # tobacco
  "GSE185090",   # PROBLEM no age # EPic # n=215  # MCD in the human brain

  # NOIDAT "GSE20067",    # PROBLEM gse="GSE20067"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # "incorrect number of dimensions" FCh: problem inselecting probes?
  "GSE43976",    # PROBLEM gse='GSE43976'  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # 450k, PB, tobacco # error in
  # NOIDAT "GSE48461",    # PROBLEM gse="GSE48461"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render("04_model.Rmd"); # 450k, glioma
  # NOIDAT "GSE49393",    # PROBLEM gse="GSE49393"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # Brain, Alcohol, n=48, 450k ; 50000 probes == NA
  "GSE104293",   # PROBLEM gse="GSE104293" ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # Glioma # n=130 # 450k
  "GSE124413",   # PROBLEM gse="GSE124413" ; source(knitr::purl("04_model"))    # Epic # n=500 # childhood acute myeloid leukemia (AML)

  # NOIDAT "GSE36278" , # 450k, n=142  # Methylation data from glioblastoma tumor samples
  # NOIDAT "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  # NOIDAT "GSE50660" , # 450k, n=464  # Cigarette Smoking Reduces DNA Methylation Levels at Multiple Genomic Loci but the Effect is Partially Reversible upon Cessation

  # NOIDAT "GSE55763" , # 450k, n=2711 # A coherent approach for analysis of the Illumina HumanMethylation450 BeadChip improves data quality and performance in epigenome-wide association studies
  # NOIDAT "GSE56105" , # 450k, n=614  # Brisbane Systems Genetics Study - DNA methylation data, MZ and DZ twin pairs, their siblings and their parents.
  # NOIDAT "GSE72775" , # 450k, n=335  # DNA methylation profiles of human blood samples from Hispanics and Caucasians
  "GSE97362" , # 450k, n=235  # CHARGE and Kabuki syndromes: Gene-specific DNA methylation signatures
  "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
  "GSE87648" , # 450k, n=350  # DNA Methylation May Mediate Genetic Risk In Inflammatory Bowel Disease
  # NOIDAT "GSE89353" , # 450k, n=600  # Proband : Epimutations as a novel cause of congenital disorders
  # NOIDAT "GSE106648", # 450k, n=279  # Differential DNA methylation in Multiple Sclerosis
  # PROBLEM in IDAT processing "GSE136296", # Epic, n=113  # Age-Associated Epigenetic Change in Chimpanzees and Humans
  "GSE147740", # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
  "GSE151732", # Epic, n=250  # Racial Disparities in Epigenetic Aging of the Right versus the Left Colon
  # NOIDAT "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
]



prefix = os.getcwd()
info_idat  = [f"{prefix}/01_idat2study_{gse}.html" for gse in gses]

localrules: target 

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_idat,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
pwd
# RCODE="source('data_info.R')"
# echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """



        
rule R01_idat2study:
    input: 
      rmd = "{prefix}/01_idat2study.Rmd",
    output: 
      study_rds = "{prefix}/datashare/{gse}/study_idat_{gse}.rds",
      html      = "{prefix}/01_idat2study_{gse}.html"   ,
      info      = "{prefix}/info_idat2study_{gse}.rds"   ,
    threads: 32
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/R3.6.1_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

rm -Rf /tmp/wd2study_{wildcards.gse}
mkdir -p /tmp/wdidat2study_{wildcards.gse}
cd /tmp/wdidat2study_{wildcards.gse}
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} .

RCODE="gse='{wildcards.gse}'; rmarkdown::render('01_idat2study.Rmd', output_file=paste0('01_idat2study_',gse,'.html'));"
echo $RCODE | Rscript - 2>&1 > 01_idat2study_{wildcards.gse}.Rout

cp 01_idat2study_{wildcards.gse}.Rout info_idat2study_{wildcards.gse}.rds 01_idat2study_{wildcards.gse}.html {wildcards.prefix}/.
cp -r {wildcards.gse}/analysis {wildcards.prefix}/datashare/{wildcards.gse}/raw/.
cp -r {wildcards.gse} {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wdidat2study_{wildcards.gse}
"""
