import os 
import os.path

gses_descs = []
gses_ewas = []
gses_model = []

gses = [
  # "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  # "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  # "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan

  # "GSE221864"   TO CHECK Epic, n=72 # Alterations of DNA Methylation Profile in Peripheral Blood of Children with Simple Obesity
  # "GSE62640"    TO CHECK 450k, n=87  # Analysis of sex differences in DNA methylation in human pancreatic islets
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
  # "GSE140686", # WARNING mixed 450k & Epic (n=1505) only keep Epic (n=1020) # Sarcoma Classification by DNA-methylation profiling
  # "GSE154566", # WARNING mixed 450k & Epic (n=1177) only keep Epic (n=944) # DNA methylation signatures of adolescent victimization: Analysis of a longitudinal monozygotic twin sample.
  # "GSE156374",  NO GO # GSE Epilepto # TODO Fabien: few probes on GEO matrix need to used IDAT
  "GSE50923",    # PROBLEM no age # 27k GBM vs. normal brain
  "GSE60753",    # PROBLEM no age # 450k # Alcohol #
  "GSE85210",    # PROBLEM no age # 450k # n=250 # tobacco
  "GSE90496" ,   # PROBLEM no age # 450k, n=2801 # DNA methylation-based classification of human central nervous system tumors [reference set]
  "GSE109379",   # PROBLEM no age # 450k, n=1104 # DNA methylation-based classification of human central nervous system tumors [validation set]
  "GSE185090",   # PROBLEM no age # EPic # n=215  # MCD in the human brain
  "GSE43976",    # PROBLEM gse='GSE43976'  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # 450k, PB, tobacco # error in
  "GSE48461",    # PROBLEM gse="GSE48461"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render("04_model.Rmd"); # 450k, glioma
  "GSE49393",    # PROBLEM gse="GSE49393"  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # Brain, Alcohol, n=48, 450k ; 50000 probes == NA
  "GSE104293",   # PROBLEM gse="GSE104293" ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # Glioma # n=130 # 450k
  "GSE124413",   # PROBLEM gse="GSE124413" ; source(knitr::purl("04_model"))    # Epic # n=500 # childhood acute myeloid leukemia (AML)
  "GSE197678",  # Epic, n=2922 # Genome-wide association studies identify novel genetic loci for epigenetic age acceleration among survivors of childhood cancer
  "GSE20067",    # PROBLEM gse="GSE20067" correct?  ; run=1; nbewasprobes=3000; nb_core=6; rmarkdown::render('04_model.Rmd'); # "incorrect number of dimensions" FCh: problem in selecting probes?
  "GSE36278" , # 450k, n=142  # Methylation data from glioblastoma tumor samples
  "GSE50660" , # 450k, n=464  # Cigarette Smoking Reduces DNA Methylation Levels at Multiple Genomic Loci but the Effect is Partially Reversible upon Cessation
  "GSE97362" , # 450k, n=235  # CHARGE and Kabuki syndromes: Gene-specific DNA methylation signatures
  "GSE87648" , # 450k, n=350  # DNA Methylation May Mediate Genetic Risk In Inflammatory Bowel Disease
  "GSE89353" , # 450k, n=600  # Proband : Epimutations as a novel cause of congenital disorders
  "GSE106648", # 450k, n=279  # Differential DNA methylation in Multiple Sclerosis
  "GSE147740", # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
  "GSE151732", # Epic, n=250  # Racial Disparities in Epigenetic Aging of the Right versus the Left Colon
    # "GSE68838",       # TCGA COAD
    # "GSE55763" , # 450k, n=2711 # A coherent approach for analysis of the Illumina HumanMethylation450 BeadChip improves data quality and performance in epigenome-wide association studies
    # "GSE56105" , # 450k, n=614  # Brisbane Systems Genetics Study - DNA methylation data, MZ and DZ twin pairs, their siblings and their parents.
    # "GSE72680",   # 450k, n=422 # DNA Methylation of African Americans from the Grady Trauma Project
    # "GSE72775" , # 450k, n=335  # DNA methylation profiles of human blood samples from Hispanics and Caucasians
    # "GSE136296", # Epic, n=113  # Age-Associated Epigenetic Change in Chimpanzees and Humans
    # "GSE152026",  # Epic, n=934 # Blood DNA methylation profiles from first episode psychosis patients and controls I
  "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
]

prefix = os.getcwd()
info_build = [f"{prefix}/info_build_{gse}.rds"                               for gse in gses]

localrules: target, R00_create_empty_expgrpwrapper, R00_create_empty_datawrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_build,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """



        
include: "r01_build_study_rule.py"

