# source("./R/carregamento_Bases_AMB_outras.R")

# df <- 
# unique(producaoBRUTA[, c("Minerio", "Substancia.RAL", "Substancia.AMB", "Substancia.Agrupadora")])
# 
# df$Minerio <- 
#   gsub(df$Minerio, pattern = "\"", replacement = "")
# 
# df$Substancia.RAL <- 
#   gsub(df$Substancia.RAL, pattern = "\"", replacement = "")
# 
# df$Substancia.AMB <- 
#   gsub(df$Substancia.AMB, pattern = "\"", replacement = "")
# 
# df$Substancia.Agrupadora <- 
#   gsub(df$Substancia.Agrupadora, pattern = "\"", replacement = "")
# 
# 
# write.csv(
#   df,
#   "Substancia_Minerio_correlacao.csv",
#   quote = TRUE,
#   sep = ",",
#   row.names = F, fileEncoding = "UTF-8"
# )

Substancia_Minerio_correlacao <- 
  read.csv(file = "./data/Substancia_Minerio_correlacao.csv", header = TRUE, sep = ",", fileEncoding = "utf-8")




