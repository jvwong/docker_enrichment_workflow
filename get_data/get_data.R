rm(list=ls(all=TRUE))

### ============ Install packages from Bioconductor ========
library(TCGAbiolinks)
library(SummarizedExperiment)
library(DEFormats)

### ============ Declare directories =========
BASE_DIR <- "/home/TCGA/get_data"
TCGAOV_RNASEQ_DATA_DIR <- file.path(BASE_DIR, "data")
TCGAOV_RNASEQ_DOWNLOADS_DIR <- file.path(BASE_DIR, "downloads")
TCGAOV_SUBTYPES_FILE <- file.path(TCGAOV_RNASEQ_DATA_DIR, "Verhaak_JCI_2013_tableS1.txt")

### ============ 1. Query =========
query <- GDCquery(project = "TCGA-OV",
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "HTSeq - Counts",
                  barcode = c("TCGA-24-2024-01A-02R-1568-13"))

### ============ 2. Download =========
GDCdownload(query = query,
            method = "client",
            directory = TCGAOV_RNASEQ_DOWNLOADS_DIR)

### ============ 3. Prepare =========
se <- GDCprepare(query = query,
                 save = TRUE,
                 save.filename = file.path(TCGAOV_RNASEQ_DATA_DIR, "tcgaovRnaSeq.rda"),
                 summarizedExperiment = TRUE,
                 directory = TCGAOV_RNASEQ_DOWNLOADS_DIR,
                 remove.files.prepared = TRUE)

### ============ 4.Integrate =========

### Load subtype assignments
TCGAOV_subtypes <- read.table(TCGAOV_SUBTYPES_FILE,
                              header = TRUE,
                              sep = "\t",
                              quote="\"",
                              check.names = FALSE,
                              stringsAsFactors = FALSE)

### TCGA barcodes shared between se and subtype assignments
barcodes <- intersect(colData(se)$patient, TCGAOV_subtypes$ID)
### Corresponding indices of se
indices_se_with_subtype <- match(barcodes, colData(se)$patient)
### Corresponding indices of TCGAOV_subtypes
indices_subtype_in_se <- match(barcodes, TCGAOV_subtypes$ID)
### Subset se samples
se <- se[, indices_se_with_subtype]

### convert to DGEList
TCGAOV_data = DEFormats::DGEList(se, group=TCGAOV_subtypes$SUBTYPE[indices_subtype_in_se])

### save to TCGAOV_RNASEQ_DATA_DIR
save(TCGAOV_data, file=file.path(TCGAOV_RNASEQ_DATA_DIR, "TCGAOV_data.rda"))
