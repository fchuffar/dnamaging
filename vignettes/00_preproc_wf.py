import os 
import os.path

gses_descs = []
gses_ewas = []
gses_model = []

gses = [
  # Epigentic clocks
  "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
  "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
  "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
  "GSE147740", # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
  "GSE152026", # Epic, n=934 # Blood DNA methylation profiles from first episode psychosis patients and controls I
  # GTex
  "GSE213478", # Epic, n=987 # Methylation data from nine tissues from GTEx samples profiled with Infinium HumanMethylationEPIC BeadChip
  # MDS/AML
  "GSE152710", #  450k, n=166 # : A methylation signature at diagnosis in patients with high-risk Myelodysplastic Syndromes and secondary Acute Myeloid Leukemia predicts azacitidine response but not relapse
  "GSE119617", # Epic n=26    #: Epigenome analysis of normal and myelodysplastic sundrome (MDS) bone marrow derived mesenchymal stromal cells (MSCs)
  "GSE159907", # Epic, n=316  #  : DNA methylation analysis of acute myeloid leukemia (AML)
  "GSE62298" , # NOIDAT       : Genome-scale profiling of the DNA methylation landscape in human AML patients
  # Epilepto
  "GSE156374", # Epic, n=96 , IDAT, **Epilepto** # DNA methylation and copy number profiling in polymicrogyria
  "GSE185090", # Epic, n=215, IDAT, **Epilepto** # DNA methylation-based classification of MCD in the human brain
  "GSE227239", # Epic, n=7  , IDAT, **Epilepto** # The specific DNA methylation landscape in Focal Cortical Dysplasia ILAE Type 3D
  # CNS Tumors
  "GSE90496" , # PROBLEM no age # 450k, n=2801 # DNA methylation-based classification of human central nervous system tumors [reference set]
  "GSE109379", # PROBLEM no age # 450k, n=1104 # DNA methylation-based classification of human central nervous system tumors [validation set]


  "GSE72774",  # TO CHECK 450k, n=508 # DNA methylation profiles of human blood samples from Caucasian subjects with Parkinson's disease
  # "GSE197678", # Epic, n=2922 # Genome-wide association studies identify novel genetic loci for epigenetic age acceleration among survivors of childhood cancer
  "GSE50660" , # 450k, n=464  # Cigarette Smoking Reduces DNA Methylation Levels at Multiple Genomic Loci but the Effect is Partially Reversible upon Cessation
  "GSE97362" , # 450k, n=235  # CHARGE and Kabuki syndromes: Gene-specific DNA methylation signatures
  "GSE87648" , # 450k, n=350  # DNA Methylation May Mediate Genetic Risk In Inflammatory Bowel Disease
  "GSE89353" , # 450k, n=600  # Proband : Epimutations as a novel cause of congenital disorders
  # "GSE56105" , # 450k, n=614  # Brisbane Systems Genetics Study - DNA methylation data, MZ and DZ twin pairs, their siblings and their parents.
  "GSE72680",  # 450k, n=422 # DNA Methylation of African Americans from the Grady Trauma Project
  "GSE72775" , # 450k, n=335  # DNA methylation profiles of human blood samples from Hispanics and Caucasians
  "GSE136296", # Epic, n=113  # Age-Associated Epigenetic Change in Chimpanzees and Humans
  "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
]

prefix = os.getcwd()
info_descs = [f"{prefix}/info_desc_{gse}.rds"                               for gse in gses]

localrules: target, R00_create_empty_expgrpwrapper, R00_create_empty_datawrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_descs,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """

include: "rules.py"

