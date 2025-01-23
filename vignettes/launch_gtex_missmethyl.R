# Define required files
start = Sys.time()

required_files = list(
  markdown = "gtex_missmethyl.Rmd",
  launcher = "launch_gtex_missmethyl.R",
  datasets = c("study_gtex_trscr608.rds", "study_gtex_trscr_complete.rds"),
  ewas_file = "ewas_GSE147740_modelcalllm_meth~age.rds",
  predimeth_bed = "predimeth_probes_GSE147740_10.bed",
  go_files = list(
    ewasBH = "GSE147740_ewasBH_GO_sign_genes.txt",
    ewasBonf = "GSE147740_ewasBonf_GO_sign_genes.txt",
    predimeth = "GSE147740_predimeth_GO_sign_genes.txt"
  ),
  ewas4combp = "ewas4combp_study_GSE147740.rds_modelcalllm_meth~age.bed",
  combp_reg = "dmr_study_GSE147740.rds_modelcalllm_meth~age_1e-30.regions-t.bed",
  study = "datashare/GSE147740/study_preproc_GSE147740.rds"
)

# Define variables for the pipeline
datasets = c("gtex608", "complete")
tissues = c("Lung", "Blood")
genes_generations = c("missmethyl", "list", "combp") 
missmethyls_probes = c("ewasBH", "ewasBonf", "predimeth")
go_words = c("development","metabolic")
go_tresholds = c("no_tresh", 300, 1000)
selections = c("unspecific", "promoter", "predimeth")

#Test 
# dataset = "complete"
# tissue = "Lung"
# genes_generation = "missmethyl" 
# missmethyl_probes = "ewasBonf"
# go_word = "development"
# go_treshold = 300
# selection = "unspecific"
# html_output = paste0(dataset, "_", tissue, "_", selection, "_", genes_generation, "_", missmethyl_probes, "_", go_word, "_go", go_treshold, ".html")
# rmarkdown::render("gtex_missmethyl.Rmd",output_file = html_output)


# Define root directory for checking missing files
current_dir = getwd()
root_dir = ifelse(basename(current_dir) == "gtex_missmethyl", dirname(current_dir), current_dir)
gtex_dir = file.path(root_dir, "gtex_missmethyl")

# Ensure working directory is gtex_missmethyl
if (basename(current_dir) != "gtex_missmethyl") {
    if (!dir.exists(gtex_dir)) {
        # Create gtex_missmethyl and its subdirectories
        dir.create(gtex_dir)
        dir.create(file.path(gtex_dir, "HTML"))
        dir.create(file.path(gtex_dir, "tables"))
        dir.create(file.path(gtex_dir, "genes"))

        # Create subdirectories for GO files
        for (dataset in datasets) {
            dir.create(file.path(gtex_dir, "HTML", dataset))
            for (genes_generation in genes_generations) {
                dir.create(file.path(gtex_dir, "tables", genes_generation))
                dir.create(file.path(gtex_dir, "genes", genes_generation))
                dir.create(file.path(gtex_dir, "HTML", dataset, genes_generation))
            }
        }

        for (probe in missmethyls_probes) {
            dir.create(file.path(gtex_dir, "tables/missmethyl", probe))
            dir.create(file.path(gtex_dir, "genes/missmethyl", probe))
            for (go_word in go_words) {
                dir.create(file.path(gtex_dir, "tables/missmethyl", probe, go_word))
                dir.create(file.path(gtex_dir, "genes/missmethyl", probe, go_word))
            }
        }

        for (dataset in datasets) {
            for (tissue in tissues) {
                dir.create(file.path(gtex_dir, "HTML", dataset, "missmethyl", tissue))
                for (missmethyl_probes in missmethyls_probes) {
                    dir.create(file.path(gtex_dir, "HTML", dataset, "missmethyl", tissue, missmethyl_probes))
                    for (go_word in go_words) {
                        dir.create(file.path(gtex_dir, "HTML", dataset, "missmethyl", tissue, missmethyl_probes, go_word))
                    }
                }
            }
        }

        message("Directory 'gtex_missmethyl' and its subdirectories have been created.")

        # Copy Markdown and launcher into gtex_missmethyl
        for (file in c(required_files$markdown, required_files$launcher)) {
            file_path = file.path(root_dir, file)
            if (file.exists(file_path)) {
                file.copy(file_path, gtex_dir)
            } else {
                message(paste0("File ", file, " not found in root directory."))
            }
        }

        # Copy datasets into gtex_missmethyl
        for (file in required_files$datasets) {
            file_path = file.path(root_dir, file)
            if (file.exists(file_path)) {
                file.copy(file_path, gtex_dir)
            } else {
                message(paste0("Dataset file ", file, " not found in root directory."))
            }
        }

        # Copy predimeth BED file into gtex_missmethyl
        predimeth_bed_path = file.path(root_dir, required_files$predimeth_bed)
        if (file.exists(predimeth_bed_path)) {
            file.copy(predimeth_bed_path, gtex_dir)
        } else {
            message(paste0("Predimeth BED file ", required_files$predimeth_bed, " not found in root directory."))
        }

        # Copy EWAS file into gtex_missmethyl
        ewas_file_path = file.path(root_dir, required_files$ewas_file)
        if (file.exists(ewas_file_path)) {
            file.copy(ewas_file_path, gtex_dir)
        } else {
            message(paste0("EWAS file ", required_files$ewas_file, " not found in root directory."))
        }

        # Copy GO files into corresponding subdirectories
        for (probe in names(required_files$go_files)) {
            go_file = required_files$go_files[[probe]]
            go_file_path = file.path(root_dir, go_file)
            go_list_dir = file.path(gtex_dir, "tables/missmethyl", probe)

            if (file.exists(go_file_path)) {
                file.copy(go_file_path, go_list_dir)
                message(paste0("File ", go_file, " has been copied to ", go_list_dir, "."))
            } else {
                message(paste0("GO file ", go_file, " not found in root directory. It will be recalculated."))
            }
        }

        # Copy comb-p requirements 
        combp_file_path = file.path(root_dir, required_files$combp_reg)
        if (file.exists(combp_file_path)) {
            file.copy(combp_file_path, gtex_dir)
            message(paste0("Combp file ", required_files$combp_reg, " found in root directory, don't need to be recalculate."))
        } else {
            message(paste0("Combp file ", required_files$combp_reg, " not found in root directory, it will be recalculate with EWAS bed file, be sure to have it in root and to have combp on your computer."))
            ewas4combp_file_path = file.path(root_dir, required_files$ewas4combp)
            if (file.exists(ewas4combp_file_path)) {
                file.copy(ewas4combp_file_path, gtex_dir)
            } else {
                message(paste0("EWAS bed file ", required_files$ewas4combp, " not found in root directory, we can create it if u have study_preproc_GSE147740.rds file in your datashare vignettes directory."))
                study_file_path = file.path(root_dir, required_files$study)
                if (!file.exists(combp_file_path)) {
                    message(paste0("Study file ", required_files$study, " not found in datashare directory attached to vignettes, be sure to have this datashare directory on vignettes and to have gtex_missmethyl dir directly in vignettes."))
                }
            }    
        }
    }
    setwd(gtex_dir)
}


# Start the pipeline
for (dataset in datasets) {
    for (tissue in tissues) {
        for (genes_generation in genes_generations) {

            if (genes_generation == "missmethyl") {

                for (missmethyl_probes in missmethyls_probes) {

                    if (missmethyl_probes == "predimeth") {
                        selections = c("unspecific", "promoter")
                    }

                    for (selection in selections) {
                        for (go_word in go_words) {
                            for (go_treshold in go_tresholds) {
                                # Define the HTML output file
                                html_dir = file.path(gtex_dir, "HTML", dataset, genes_generation, tissue, missmethyl_probes, go_word)
                                html_file = paste0(
                                    dataset, "_", tissue, "_", selection, "_", genes_generation, "_", missmethyl_probes, "_", go_word, "_go", go_treshold, ".html"
                                )
                                html_output = file.path(html_dir, html_file)

                                if(!file.exists(html_output)) {
                                # Render the R Markdown
                                rmarkdown::render(
                                    "gtex_missmethyl.Rmd",
                                    output_file = html_output
                                )
                                }

                            }
                        }
                    }
                }
            } else if (genes_generation == "list") {
                
                list_of_genes = "hox"

                html_dir = file.path(gtex_dir, "HTML", dataset, genes_generation)
                html_file = paste0( dataset, "_", tissue, "_", list_of_genes, ".html")
                html_output = file.path(html_dir, html_file)
                
                if(!file.exists(html_output)) {
                # Render the R Markdown
                rmarkdown::render("gtex_missmethyl.Rmd", output_file = html_output)
                }

            } else {

                html_dir = file.path(gtex_dir, "HTML", dataset, genes_generation)
                html_file = paste0( dataset, "_", tissue, "_", genes_generation, ".html")
                html_output = file.path(html_dir, html_file)

                if(!file.exists(html_output)) {
                    # Render the R Markdown
                    rmarkdown::render("gtex_missmethyl.Rmd", output_file = html_output)
                }
            }

        }
    }
}

stop = Sys.time()
time = difftime(stop, start, units = "auto")
message(paste0("Pipeline completed successfully in ", time," mins."))
