lapply(c("dplyr","Seurat","ggplot2","anndata","readxl",
         "RColorBrewer","reticulate","sceasy","Polychrome", "stringr"),library, character.only = T)
library(Rsubread)
library(data.table)
data_dir = "/xchip/beroukhimlab/srangasw/POMT/data/bulk/counts"
samples = list.files(data_dir)
gtf_path = '/xchip/beroukhimlab/srangasw/POMT/genome/mouse/genes/updated.genes.gtf'
gene_ids_map = read.table("/xchip/beroukhimlab/srangasw/POMT/genome/mouse/genes/gene_id_to_name.txt")
rownames(gene_ids_map) <- gene_ids_map[["V1"]]

for (i in 1:length(samples)){
    sample_path = paste(data_dir, samples[[i]], "Aligned.sortedByCoord.out.bam", sep = "/")
    fc_PEO_RNA <- featureCounts(files=sample_path, annot.ext=gtf_path, isGTFAnnotationFile=TRUE, nthread=32, GTF.featureType="exon", GTF.attrType="gene_name", useMetaFeatures=TRUE, isPairedEnd=T)
    counts <- fc_PEO_RNA$counts
    gene_names = rownames(fc_PEO_RNA$counts)
    counts <- as.data.table(counts)
    counts$genes <- gene_names
    setnames(counts, "Aligned.sortedByCoord.out.bam", samples[[i]])
    save_path = paste(data_dir, samples[[i]], paste0(samples[[i]], "_counts.txt"), sep = "/")
    write.table(x=counts, file=save_path,quote=FALSE,sep="\t",row.names=TRUE)
    }
