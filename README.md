## Instructions 

1. Install packages by pasting the packages code  in `00-constants.R`

2. Run scripts in correct order (shown below). Proteomics workflow must be run prior to transcriptomics workflow.



## Packages 

### CRAN Packages

| Package | Version |
|---|---|
| dplyr | 1.2.1 |
| ggplot2 | 4.0.3 |
| ggrepel | 0.9.8 |
| glmnet | 5.0 |
| magrittr | 2.0.5 |
| msigdbr | 26.1.1 |
| patchwork | 1.3.2 |
| pROC | 1.19.1 |
| randomForest | 4.7.1.2 |
| rsample | 1.3.2 |
| stringr | 1.6.0 |
| tibble | 3.3.1 |
| tidyr | 1.3.2 |

### Bioconductor Packages

| Package | Version |
|---|---|
| AnnotationDbi | 1.74.0 |
| clusterProfiler | 4.20.0 |
| DESeq2 | 1.52.0 |
| edgeR | 4.10.5 |
| limma | 3.68.5 |
| SomaScan.db | 0.99.10 |




# Proteomics LRTI-classifier

## Raw Data

1. `vap_soma_normalized.csv` contains patient_id (n=151) and SomaScan protein matrix with 7596 PROBEIDs. PHI filtered out to create protein_mat_PROBEID, which is compressed to protein_mat_ALL, which is then subsetted to protein_mat with n=105 patient_ids.

2. `metadata_JCI_mNGS_hits_added_06122026.csv` features metadata as well as the pathogenic viral and bacterial hits for all patient samples. Restricted to n=105 patients.





## Scripts

1. `01-data_import.Rmd` - Imports and log2 transforms SomaScan protein matrix counts in addition to metadata.

2. `02-protein_lookup_table.Rmd` - Uses SomaScan.db to map Protein PROBEIDs to gene symbol and Uniprot ID. Compresses mean PROBEID value for gene symbols with >1 PROBEID. Outputs protein matrix with gene symbols and generates a protein lookup table to map PROBEID to gene symbol.

3. `03-parameters.Rmd` - Exports protein matrix and defines workflow parameters

4. `04-fold_assignment.Rmd` - Uses rsample package to split samples into 5 folds for cross-validation. Guarantees a minimum of 6 No Evidence samples per each fold to ensure balanced representation across folds.

5. `05-lasso_cv.Rmd` - Uses LASSO logistic regression to select proteins per each train/test split. Options selecting lambda which yields 1 feature per fold, 3 features per fold, or cross-validation Full LASSO at lambda.1se (cross_validation error within 1 standard error of lambda.min).

6. `06-random_forest.Rmd` - Selected proteins are trained in a random forest model (ntrees = 10000). For each split, out-of-fold LRTI probabilities are generated for held-out test samples.

7. `07-roc_curve_auc.Rmd` - Receiver Operating Characteristic (ROC) curve is generated from the out-of-fold lasso/RF probabilities of Definite LRTI status. AUC is reported per-fold with DeLong 95% Confidence Interval. 

8. `08-differential_abundance.Rmd` - Uses limma to generate Differential Abundance (DA) volcano plot from protein matrix counts. Generates data frame from DA results which includes significance values and log2FC based on LRTI adjudication, with sex and age as covariates.



# Transcriptomic LRTI-classifier

# Raw Data

1. `host_gene_counts.csv` contains a gene matrix with n=261 patients and n=36816 genes. The matrix is subsetted to the same patients in metadata_df and is transformed and filtered downstream for differentially expressed genes.

2. `microbe_reports_bgfilter.csv` contains background filtered microbe reports for all patient samples. Subset to patients (n=105) in metadata_df, and filtered to only include viral taxa for viral RPM data frame.



## Scripts

1. `01-data_import.Rmd` - Imports metadata file and subsets to the same 105 patients as proteomic workflow. Defines workflow parameters

2. `02-fold_assignment.Rmd` - Uses rsample package to split samples into 5 folds for cross-validation. Guarantees a minimum of 6 No Evidence samples per each fold to ensure balanced representation across folds.

3. `03-lasso_vst.Rmd` - Uses LASSO logistic regression to select genes per each train/test split. Options selecting lambda which yields 1 feature per fold, 3 features per fold, or cross-validation Full LASSO at lambda.1se (cross_validation error within 1 standard error of lambda.min). VST (variance stabilized transform) parameters are estimated using only training samples, while test fold is transformed separately using frozen training parameters.

4. `04-random_forest.Rmd` - Selected genes are trained in a random forest model (ntrees = 10000). For each split, out-of-fold LRTI probabilities are generated for held-out test samples.

5. `05-roc_curve_auc.Rmd` - Receiver Operating Characteristic (ROC) curve is generated from the out-of-fold lasso/RF probabilities of Definite LRTI status. AUC is reported per-fold with DeLong 95% Confidence Interval.

6. `06-differential_expr.Rmd` - Uses limma + voom method to generate Differential Expression (DE) volcano plot from host gene counts. Generates data frame from DE results which includes significance values and log2FC based on LRTI adjudication, with sex and age as covariates.

7. `07-rna_protein_conc_plot.Rmd` - Imports DE results from transcriptomic workflow and DA results from proteomics workflow to generate an RNA/Protein concordance plot, mapping log2FC of proteins vs. genes based on LRTI adjudication. 

8. `08-pathway_analysis_gsea.Rmd` - Performs gene set enrichment analysis (GSEA) on ranked Differential Expression results to identify biologically relevant pathways. Enrichment is computed using the ClusterProfiler package and hallmark and reactome gene sets are pulled from MSigDB. Differential Abundance results are imported from proteomics workflow to generate a dot plot comparing top pathways in both protein and gene sets and ranking by the sum of the absolute value of the normalized enrichment score for both the gene and protein sets.

9. `09-viral_rpm_IFNs.Rmd` - Plots standardized composite IFN alpha score for both protein and RNA against log-transformed viral RPM. Composite IFN alpha score is calculated from summing scaled mean expression for both protein and RNA counts from IFN gene sets determined by GSEA.  Viral RPM data is obtained from `microbe_reports_bgfilter.csv`, filtered to patients with pathogenic viral hits as reported in `metadata_JCI_mNGS_hits_added_06122026.csv` Viral RPM is computed by sum viral RPM from all reported pathogenic viruses. Neutrophil degranulation score is similarly plotted against Bacterial RPM using the same methodology.

10. `10-biomarker_concordance_plot.Rmd` - For select biomarkers, plots z-scored protein matrix (log2 transformed) counts against z-scored VST gene matrix counts, where each dot is one patient_id (n=105). Plots color by LRTI adjudication and fit a linear model to each LRTI adjudication.

11. `11-correlation_density_plot.Rmd` - Density plot demonstrating the overall correlation behavior of all shared analytes (genes with corresponding proteins) (n=6238). Pearson r on the x-axis is computed for each shared gene/protein pair, with density measured on the y-axis.

12. `12-patchwork.Rmd` - R package patchwork used to compile individual figures into multi-panel displays of varying shape and orientation.

