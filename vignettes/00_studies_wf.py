import os 
import os.path
# trick to load gse define as R vector
def c(*args): return list(args)



# gses = [
#   # Epigentic clocks
#   "GSE40279" , # 450k, n=656  # Genome-wide Methylation Profiles Reveal Quantitative Views of Human Aging Rates
#   "GSE42861" , # 450k, n=689  # Differential DNA methylation in Rheumatoid arthritis
#   "GSE87571" , # 450k, n=750  # Continuous Aging of the Human DNA Methylome Throughout the Human Lifespan
#   "GSE147740", # Epic, n=1129 # DNA methylation analysis of human peripheral blood mononuclear cell collected in the AIRWAVE study
#   "CustGSE147740rr",
#   "GSE152026", # Epic, n=934  # Blood DNA methylation profiles from first episode psychosis patients and controls I
#   # GTex
#   "GSE213478", # Epic, n=987  # Methylation data from nine tissues from GTEx samples profiled with Infinium HumanMethylationEPIC BeadChip
#   # MDS/AML
#   "GSE119617", # Epic n=26    #: Epigenome analysis of normal and myelodysplastic sundrome (MDS) bone marrow derived mesenchymal stromal cells (MSCs)
#   "GSE152710", #  450k, n=166 # : A methylation signature at diagnosis in patients with high-risk Myelodysplastic Syndromes and secondary Acute Myeloid Leukemia predicts azacitidine response but not relapse
#   "CustGSE152710aml",
#   "CustGSE152710mds",
#   "GSE159907", # Epic, n=316  #  : DNA methylation analysis of acute myeloid leukemia (AML)
#   "GSE62298" , # 450k, n=68   # NOIDAT       : Genome-scale profiling of the DNA methylation landscape in human AML patients
#   # Epilepto
#   "GSE156374", # Epic, n=96 , IDAT, **Epilepto** # DNA methylation and copy number profiling in polymicrogyria
#   "GSE185090", # Epic, n=215, IDAT, **Epilepto** # DNA methylation-based classification of MCD in the human brain
#   "GSE227239", # Epic, n=7  , IDAT, **Epilepto** # The specific DNA methylation landscape in Focal Cortical Dysplasia ILAE Type 3D
#   # CNS Tumors
#   "GSE90496" , # PROBLEM no age # 450k, n=2801 # DNA methylation-based classification of human central nervous system tumors [reference set]
#   "GSE109379", # PROBLEM no age # 450k, n=1104 # DNA methylation-based classification of human central nervous system tumors [validation set]
#   "GSE221745", # Epic, n=28  #  : Genomic and epigenomic profiling of GATA2 deficiency reveals aberrant hypermethylation pattern in Bone Marrow and Peripheral Blood

#   # TCGA
#   "BRB",
#   "TCGA-LUSC",
#   "TCGA-LUAD",
#   "TCGA-BLCA",
#   "TCGA-BRCA",
#   "TCGA-CESC",
#   "TCGA-CHOL",
#   "TCGA-COAD",
#   "TCGA-DLBC",
#   "TCGA-ESCA",
#   "TCGA-HNSC",
#   "TCGA-KICH",
#   "TCGA-KIRC",
#   "TCGA-KIRP",
#   "TCGA-LAML",
#   "TCGA-LIHC",
#   "TCGA-MESO",
#   "TCGA-PAAD",
#   "TCGA-PCPG",
#   "TCGA-PRAD",
#   "TCGA-READ",
#   "TCGA-SARC",
#   "TCGA-SKCM",
#   "TCGA-STAD",
#   "TCGA-TGCT",
#   "TCGA-THCA",
#   "TCGA-THYM",
#   "TCGA-UCS" ,
#   "TCGA-UVM" ,
#   "TCGA-GBM" ,
#   "TCGA-ACC" ,
#   "TCGA-LGG" ,
#   "TCGA-OV"  ,

#   "CustTCGA-LUSCrr",
#   "CustTCGA-LUADrr",
#   "CustTCGA-BLCArr",
#   "CustTCGA-BRCArr",
#   "CustTCGA-CESCrr",
#   "CustTCGA-CHOLrr",
#   "CustTCGA-COADrr",
#   "CustTCGA-DLBCrr",
#   "CustTCGA-ESCArr",
#   "CustTCGA-HNSCrr",
#   "CustTCGA-KICHrr",
#   "CustTCGA-KIRCrr",
#   "CustTCGA-KIRPrr",
#   "CustTCGA-LAMLrr",
#   "CustTCGA-LIHCrr",
#   "CustTCGA-MESOrr",
#   "CustTCGA-PAADrr",
#   "CustTCGA-PCPGrr",
#   "CustTCGA-PRADrr",
#   "CustTCGA-READrr",
#   "CustTCGA-SARCrr",
#   "CustTCGA-SKCMrr",
#   "CustTCGA-STADrr",
#   "CustTCGA-TGCTrr",
#   "CustTCGA-THCArr",
#   "CustTCGA-THYMrr",
#   "CustTCGA-UCSrr" ,
#   "CustTCGA-UVMrr" ,
#   "CustTCGA-GBMrr" ,
#   "CustTCGA-ACCrr" ,
#   "CustTCGA-LGGrr" ,
#   "CustTCGA-OVrr"  ,
#   "CustBRBrr"  ,


#   # Bariatric surgery
#   "GSE44798", # 450k,  # Gene methylation profiles in offspring born before vs. after maternal bariatric surgery
#   "GSE48325", # 450k,  # DNA methylation analysis in non-alcoholic fatty liver disease suggests distinct disease-specific and remodeling signatures after bariatric surgery
#   # GSE61454  # 450k,  # DNA methylation from severely obese samples in liver, muscle, visceral adipose tissue and subcutaneous adipose samples
#   "GSE61446", #	  Epigenome analysis of the human liver
#   "GSE61450", #	  Epigenome analysis of the human subqutaneous adipose tissue
#   "GSE61452", #	  Epigenome analysis of the human muscle
#   "GSE61453", #	  Epigenome analysis of the human visceral adipose tissue

#   # "GSE72774",  # TO CHECK 450k, n=508 # DNA methylation profiles of human blood samples from Caucasian subjects with Parkinson's disease
#   # "GSE197678", # Epic, n=2922 # Genome-wide association studies identify novel genetic loci for epigenetic age acceleration among survivors of childhood cancer
#   "GSE50660" , # 450k, n=464  # Cigarette Smoking Reduces DNA Methylation Levels at Multiple Genomic Loci but the Effect is Partially Reversible upon Cessation
#   "GSE97362" , # 450k, n=235  # CHARGE and Kabuki syndromes: Gene-specific DNA methylation signatures
#    "GSE87648" , # 450k, n=350  # DNA Methylation May Mediate Genetic Risk In Inflammatory Bowel Disease
#   "GSE89353" , # 450k, n=600  # Proband : Epimutations as a novel cause of congenital disorders
#   "CustGSE89353rr", 
#   # "GSE56105" , # 450k, n=614  # Brisbane Systems Genetics Study - DNA methylation data, MZ and DZ twin pairs, their siblings and their parents.
#   "GSE72680",  # 450k, n=422 # DNA Methylation of African Americans from the Grady Trauma Project
#   "GSE72775" , # 450k, n=335  # DNA methylation profiles of human blood samples from Hispanics and Caucasians
#   "GSE136296", # Epic, n=113  # Age-Associated Epigenetic Change in Chimpanzees and Humans
#   "GSE41037"   # **************27k*************** Aging effects on DNA methylation modules in blood tissue
# ]

exec(open("gses_studies.R").read())

prefix = os.getcwd()
info_build =    [f"{prefix}/info_build_{gse}.rds"                               for gse in gses]
idatstudy_rds = [f"{prefix}/datashare/{gse}/study_idat_{gse}.rds"                               for gse in gses]

localrules: target, r00_create_empty_expgrpwrapper, r00_create_empty_datawrapper

rule target:
    threads: 1
    message: "-- Rule target completed. --"
    input: 
      info_build,
      # idatstudy_rds,
    shell:"""
export PATH="/summer/epistorage/opt/bin:$PATH"
export PATH="/summer/epistorage/miniconda3/envs/dnamaging_env/bin:$PATH"
pwd
RCODE="source('data_info.R')"
echo $RCODE | Rscript - 2>&1 > data_info.Rout
          """



        
rule r00_create_empty_expgrpwrapper:
    input: 
    output: 
      r_expgrpwrapper="{prefix}/02_wrappers/expgrpwrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {output.r_expgrpwrapper}
"""

rule r00_create_empty_datawrapper:
    input: 
    output: 
      r_datawrapper="{prefix}/02_wrappers/datawrapper_{gse}.R",
    threads: 1
    shell:"""
cd {wildcards.prefix}
touch {output.r_datawrapper}
"""        

# rule r00_create_empty_idatstudy:
#     input:
#     output:
#       idatstudy_rds = "{prefix}/datashare/{gse}/study_idat_{gse}.rds",
#     threads: 1
#     shell:"""
# cd {wildcards.prefix}
# touch {output.idatstudy_rds}
# """

rule r02_genericstudy:
    input: 
      rmd = "{prefix}/02_genericstudy.Rmd",
      r_datawrapper   = "{prefix}/02_wrappers/datawrapper_{gse}.R",
      r_expgrpwrapper = "{prefix}/02_wrappers/expgrpwrapper_{gse}.R",
      # idatstudy_rds = "{prefix}/datashare/{gse}/study_idat_{gse}.rds",
    output: 
      study_rds =   "{prefix}/datashare/{gse}/study_{gse}.rds",
      df_rds =      "{prefix}/datashare/{gse}/df_{gse}.rds"    ,           
      html =        "{prefix}/02_genericstudy_{gse}.html"      ,           
      info       =  "{prefix}/info_build_{gse}.rds"   ,
    threads: 32
    shell:"""
# export PATH="/summer/epistorage/opt/bin:$PATH"
# export PATH="/summer/epistorage/miniconda3/envs/genericstudy_env/bin:$PATH"
export PATH="/home/chuffarf/miniconda3/envs/genericstudy_env/bin:$PATH"
echo $PATH
# source ~/conda_config.sh
# conda activate genericstudy_env

export OMP_NUM_THREADS=1
cd {wildcards.prefix}

rm -Rf /var/tmp/wd_{wildcards.gse}
mkdir -p /var/tmp/wd_{wildcards.gse}
cd /var/tmp/wd_{wildcards.gse}
ln -s {wildcards.prefix}/datashare 
cp {input.rmd} .
mkdir 02_wrappers
cp {input.r_datawrapper} {input.r_expgrpwrapper} 02_wrappers/.

RCODE="gse='{wildcards.gse}'; rmarkdown::render('02_genericstudy.Rmd', output_file=paste0('02_genericstudy_',gse,'.html'));"
echo $RCODE | Rscript - 2>&1 > 02_genericstudy_{wildcards.gse}.Rout

cp 02_genericstudy_{wildcards.gse}.Rout info_build_{wildcards.gse}.rds 02_genericstudy_{wildcards.gse}.html {wildcards.prefix}/.
cd {wildcards.prefix}
rm -Rf /var/tmp/wd_{wildcards.gse}
"""

