import os 
import os.path



gses = [
  # "GSE62969"    TO CHECK 450k, n=-100# Predicting genome-wide DNA methylation
  # "GSE197305"   TO CHECK Epic, n=1221# Cortex DNA methylation profiles for the Brains for Dementia research cohort
  # "GSE117859"   TO CHECK 450k, n=608 # Smoking-associated DNA methylation features link to HIV outcomes [HumanMethylation450 BeadChip]
  # "GSE117860"   TO CHECK Epic, n=529 # Smoking-associated DNA methylation features link to HIV outcomes [Infinium MethylationEPIC]
  # "GSE158063"   TO CHECK Epic, n=915 # Smaller stature in childhood following assisted reproductive technologies (ART) is not explained by... 
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
  # NOIDAT "GSE50923",    # PROBLEM no age # 27k GBM vs. normal brain
  # NOIDAT "GSE60753",    # PROBLEM no age # 450k # Alcohol #
  # NOIDAT "GSE20067",    # PROBLEM gse="GSE20067"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # "incorrect number of dimensions" FCh: problem inselecting probes?
  # NOIDAT "GSE48461",    # PROBLEM gse="GSE48461"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render("04_model.Rmd"); # 450k, glioma
  # NOIDAT "GSE49393",    # PROBLEM gse="GSE49393"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # Brain, Alcohol, n=48, 450k ; 50000 probes == NA
  # NOIDAT "GSE36278" , # 450k, n=142  # Methylation data from glioblastoma tumor samples
  # NOIDAT "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  # NOIDAT "GSE89353" , # 450k, n=600  # Proband : Epimutations as a novel cause of congenital disorders
  # NOIDAT "GSE106648", # 450k, n=279  # Differential DNA methylation in Multiple Sclerosis
  # NOIDAT "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
  # PROBLEM in IDAT processing "GSE136296", # Epic, n=113  # Age-Associated Epigenetic Change in Chimpanzees and Humans
  # NOIDAT "GSE50660" , # 450k, n=464  # Cigarette Smoking Reduces DNA Methylation Levels at Multiple Genomic Loci but the Effect is Partially Reversible upon Cessation

  # NOIDAT "GSE55763" , # 450k, n=2711 # A coherent approach for analysis of the Illumina HumanMethylation450 BeadChip improves data quality and performance in epigenome-wide association studies
  # NOIDAT "GSE56105" , # 450k, n=614  # Brisbane Systems Genetics Study - DNA methylation data, MZ and DZ twin pairs, their siblings and their parents.
  # NOIDAT "GSE72775" , # 450k, n=335  # DNA methylation profiles of human blood samples from Hispanics and Caucasians
  # NOIDAT "GSE72680",   # 450k, n=422 # DNA Methylation of African Americans from the Grady Trauma Project
  # NOIDAT "GSE152026",  # Epic, n=934 # Blood DNA methylation profiles from first episode psychosis patients and controls I
  # Epilepto
  "GSE156374", # Epic, n=96 , IDAT, **Epilepto** # DNA methylation and copy number profiling in polymicrogyria
  "GSE185090", # Epic, n=215, IDAT, **Epilepto** # DNA methylation-based classification of MCD in the human brain
  "GSE227239", # Epic, n=7  , IDAT, **Epilepto** # The specific DNA methylation landscape in Focal Cortical Dysplasia ILAE Type 3D
  # Epigenetic  Clocks
  "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
  "GSE147740",  # need more memory/space # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
  # MDS/AML
  "GSE152710", #  450k, n=166 # : A methylation signature at diagnosis in patients with high-risk Myelodysplastic Syndromes and secondary Acute Myeloid Leukemia predicts azacitidine response but not relapse
  # "GSE119617", # RENAMED IDAT Epic n=26    #: Epigenome analysis of normal and myelodysplastic sundrome (MDS) bone marrow derived mesenchymal stromal cells (MSCs)
  "GSE159907", # Epic, n=316  #  : DNA methylation analysis of acute myeloid leukemia (AML)
  # "GSE62298", # NOIDAT       : Genome-scale profiling of the DNA methylation landscape in human AML patients
  "GSE124413",   # PROBLEM gse="GSE124413" ; source(knitr::purl("04_model"))    # Epic # n=500 # childhood acute myeloid leukemia (AML)
  

  "GSE197678",  # n=2000 # Childhood Cancer Survivors
  # PROBLEM in IDAT processing "GSE154566",  # need more memory/space #  WARNING mixed 450k & Epic (n=1177) only keep Epic (n=944) # DNA methylation signatures of adolescent victimization: Analysis of a longitudinal monozygotic twin sample.
  "GSE140686",  # need more memory/space # WARNING mixed 450k & Epic (n=1505) only keep Epic (n=1020) # Sarcoma Classification by DNA-methylation profiling
  "GSE90496"  , # need more memory/space # TO CHECK 450k, n=2801 # DNA methylation-based classification of human central nervous system tumors [reference set]

  "GSE109379" ,  # TO CHECK 450k, n=1104 # DNA methylation-based classification of human central nervous system tumors [validation set]
  "GSE85210",    # PROBLEM no age # 450k # n=250 # tobacco
  "GSE43976",    # PROBLEM gse='GSE43976'  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # 450k, PB, tobacco # error in
  "GSE104293",   # PROBLEM gse="GSE104293" ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # Glioma # n=130 # 450k
  "GSE97362" , # 450k, n=235  # CHARGE and Kabuki syndromes: Gene-specific DNA methylation signatures
  "GSE87648" , # 450k, n=350  # DNA Methylation May Mediate Genetic Risk In Inflammatory Bowel Disease
  # "GSE68838",       # TCGA COAD
  # "GSE151732", # Epic, n=250  # Racial Disparities in Epigenetic Aging of the Right versus the Left Colon
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
export PATH="/summer/epistorage/miniconda3/envs/idat2study_env/bin:$PATH"
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
export PATH="/summer/epistorage/miniconda3/envs/idat2study_env/bin:$PATH"
export OMP_NUM_THREADS=1
cd {wildcards.prefix}

rm -Rf /tmp/wdidat2study_{wildcards.gse}
mkdir -p /tmp/wdidat2study_{wildcards.gse}
cd /tmp/wdidat2study_{wildcards.gse}
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} .

RCODE="gse='{wildcards.gse}'; rmarkdown::render('01_idat2study.Rmd', output_file=paste0('01_idat2study_',gse,'.html'));"
echo $RCODE | Rscript - 2>&1 > 01_idat2study_{wildcards.gse}.Rout

cp 01_idat2study_{wildcards.gse}.Rout info_idat2study_{wildcards.gse}.rds 01_idat2study_{wildcards.gse}.html {wildcards.prefix}/.
cp -r {wildcards.gse}/analysis_* {wildcards.prefix}/datashare/{wildcards.gse}/raw/.
cp -r {wildcards.gse} {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /tmp/wdidat2study_{wildcards.gse}
"""
