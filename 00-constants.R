


# 00-constants


# Change to personal computer file path

UCSF_dir <- "C:/Users/peter/OneDrive/Documents/UCSF"


# Shared raw data

raw_data_dir <- file.path(
  UCSF_dir, "raw_data"
)


# Protein project

prot_data_dir <- file.path(
  UCSF_dir, "BREATH2.Prot/data"
)

prot_results_dir <- file.path(
  UCSF_dir, "BREATH2.Prot/results"
)


# Gene project

gene_data_dir <- file.path(
  UCSF_dir, "BREATH2.Gene/data"
)

gene_results_dir <- file.path(
  UCSF_dir, "BREATH2.Gene/results"
)


# Figures

plots_dir <- file.path(
  UCSF_dir, "plots"
)



# Analysis parameters

nfolds <- 5
ntrees <- 10000


# Set project seed

project_seed <- 8634782



# Colors

gene_color <- "#0072B2"

protein_color <- "#009E73"

LRTI_color <- "#D55E00"

control_color <- "#8B4789"

full_lasso_color <- "#CC79A7"

three_target_color <- "#56B4E9"



# Packages


# Paste all of the below into R console


# CRAN packages
cran_packages <- c(
  "dplyr",
  "magrittr",
  "rsample",
  "ggplot2",
  "glmnet",
  "tibble",
  "randomForest",
  "pROC",
  "ggrepel",
  "msigdbr",
  "stringr",
  "tidyr",
  "patchwork"
)

# Bioconductor packages
bioc_packages <- c(
  "DESeq2",
  "edgeR",
  "limma",
  "clusterProfiler",
  "AnnotationDbi",
  "SomaScan.db"
)

# Install CRAN packages
install.packages(cran_packages)

# Install BiocManager if necessary
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# Install Bioconductor packages
BiocManager::install(bioc_packages)


