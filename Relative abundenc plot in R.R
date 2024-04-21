library(ggplot2)
library(tidyverse)
DAT<-read_tsv("E:/Relative abundance plot in R/otu_table.tsv")
colnames(DAT)
###333 not that pibvot_longer deals about the which new 
###variable that we gonna have in a new column and minus symbol remove the those variabe which we dont want 
DAT<- DAT %>%
  pivot_longer(-otu_id, names_to = "Sample_id", values_to = "count")
DAT
###Next steps we are gonna add the new data layer from the layer, that is the
##3taxonomy function which they originaly beocmes 
Taxononmy<-read_tsv("E:/Relative abundance plot in R/otu_taxonomy.tsv",col_types = cols(.default = "character"))
Taxononmy
###3now we have add the layer of the 2nd data to the first data tables as a new column with the new fucntion of the tydiverse
#layer added data
DAT<- DAT %>%
  left_join(Taxononmy, by = "otu_id")
DAT

###now we are gonna a sample metadeta file addtion likewise same the 
Meta<-read_tsv("E:/Relative abundance plot in R/sample_metadata.tsv",
              col_types = cols(.default = col_character()))
                
Meta
colnames(SM)

##3#now add the new column
DAT <- DAT %>%
  left_join(Meta, by = c("Sample_id" = "sample_id"))

DAT


##33# separation of the sample by fractions and types of the soil
DAT %>%
  ggplot(aes(x = Sample_id, y = count)) +
  facet_grid(~ fraction + soil, scales = "free_x", space = "free_x") +
  geom_bar(aes(fill = Phylum.y), stat = "identity", position = "fill", width = 1)
####paring of the data sets
DAT %>%
  ggplot(aes(x = Sample_id, y = count)) +
  facet_grid(~ fraction + soil, scales = "free_x", space = "free_x") +
  geom_bar(aes(fill = Phylum.y), stat = "identity", position = "fill", width = 1) +
  scale_fill_brewer(palette = "Paired")

##3to order the phylum based on the realtive abundance of the species 
phyla_order <- c("Proteobacteria",
                 "Actinobacteria",
                 "Bacteroidetes",
                 "Acidobacteria",
                 "Firmicutes",
                 "Cyanobacteria",
                 "Verrucomicrobia",
                 "Gemmatimonadetes",
                 "Armatimonadetes",
                 "Chloroflexi",
                 "unclassified")
DAT <- DAT %>%
  mutate(Phylum = factor(Phylum.y, levels = phyla_order))
#3#3final plot 
DAT %>%
  ggplot(aes(x = Sample_id, y = count)) +
  facet_grid(~ fraction + soil, scales = "free_x", space = "free_x") +
  geom_bar(aes(fill = Phylum.y), stat = "identity", position = "fill", width = 1) +
  scale_fill_brewer(palette = "Paired") +
  scale_y_continuous(name = "Relative abundance of the bacterial species",
                     labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 45, size = 10),
        axis.text.y = element_text(color = "black"),
        strip.text = element_text(face = "bold"),
        strip.background = element_blank())
##3to set the color by manual
standard_colors <- c("maroon", "#ff7f0e", "navy", "magenta", "red", "darkgreen", 
                     "springgreen", "yellow", "cyan", "purple", "orange", "blue")

RAD<-DAT %>%
  ggplot(aes(x = Sample_id, y = count, fill = Phylum.y)) +
  facet_grid(~ fraction + soil, scales = "free_x", space = "free_x") +
  geom_bar(stat = "identity", position = "fill", width = 1) +
  scale_fill_manual(values = standard_colors) +  
  scale_y_continuous(name = "Relative abundance of the bacterial species",
                     labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 45, size = 10),
        axis.text.y = element_text(color = "black"),
        strip.text = element_text(face = "bold"),
        strip.background = element_blank())
RAD
getwd()
ggsave("Relative abundenc plot of bacteria species plot.png", RAD, width = 15, height = 12, dpi = 800)

