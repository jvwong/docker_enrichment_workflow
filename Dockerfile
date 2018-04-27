FROM bioconductor/release_core2:latest

MAINTAINER Jeffrey Wong <jvwong@outlook.com>

#Install the required packages
RUN R -e 'install.packages(c("devtools"));'
RUN R -e 'devtools::install_github("cytoscape/cytoscape-automation/for-scripters/R/r2cytoscape")'
RUN R -e 'biocLite(c("edgeR"), suppressUpdates=TRUE, ask=FALSE)'

# Copy over the data dependencies
COPY ./code /home/rstudio/code
RUN chown -R rstudio /home/rstudio/code

EXPOSE 8787

