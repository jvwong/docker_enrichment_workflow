# Require R version >=3.3.2
FROM bioconductor/release_base

MAINTAINER Jeffrey Wong <jvwong@outlook.com>

#Install the required Bioconductor packages
#The biocLite() function is provided by BiocInstaller. This is a wrapper around install.packages, but with the repository chosen according to the version of Bioconductor in use, rather than to the version relevant at the time of the release of R.
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("SummarizedExperiment", "TCGAbiolinks", "DEFormats", "edgeR"), suppressUpdates=TRUE, ask=FALSE);'

# Copy over the data dependencies
COPY ./get_data /src
