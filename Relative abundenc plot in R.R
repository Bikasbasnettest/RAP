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
SM<- read_tsv("E:/Relative abundance plot in R/sample_metadata.tsv")#,
                 # col_types = cols(.default = col_character()))
SM
colnames(SM)

##3#now add the new column
DAT <- DAT %>%
  left_join(SM, by = "otu_id")


