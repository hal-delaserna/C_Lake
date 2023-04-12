library(dplyr)

geocod <-
  read.table(
    file = paste(sep = "",
                 "./data/",
                 "GeoCodigos_IBGE_202201.csv"),
    header = TRUE,
    sep = ";",
    fill = TRUE,
    stringsAsFactors = FALSE,
    encoding = "latin1",
    quote = "\"",
    colClasses = c(
      'integer',	     # Cod_UF
      'character',	   # UF
      'character',	   # UF_sigla
      'integer',	     # Cod Região Intermed
      'character',	   # Região Intermediária
      'integer',	     # Cod Região Imed
      'character',	   # Região Imediata
      'integer',	     # Cod_Mesorregi?o.Geogr?fica
      'character',	   # Mesorregi?o
      'integer',	     # Cod_Microrregi?o
      'character',	   # Microrregi?o
      'integer',	     # GEOCOD
      'character',	   # Munic?pio
      'character'	     # Regi?o_Administrativa_SP
    )
  )


geocod$GEOCOD_6 <-
  as.integer(gsub(geocod$GEOCOD, pattern = ".$", replacement = ""))
  
geocod$id_mun_UF <-
  paste(
    geocod$Município |> 
      iconv(from = 'Latin1', to = 'ASCII//TRANSLIT') |> 
      gsub(pattern = "-| {1,}|'|\"", replacement = "") |> 
      stringr::str_squish() |> gsub(pattern = " ", replacement = "") |> 
      toupper(),
    geocod$UF_sigla, sep = "_")
    


## Regiões Metropolitanas -----

RM <-
  read.table(
    "./data/Regiões_Metropolitanas_IBGE.csv",
    header = TRUE, sep = ";",
    fill = TRUE, quote = "",
    fileEncoding = 'Latin1', encoding = "UTF-8")

colnames(RM)[5] <- c("RegMet")



geocod <- 
  left_join(geocod, 
            RM[,c("COD_RECMETROPOL", "RegMet", "COD_MUN")], 
            by = c("GEOCOD" = "COD_MUN"))

  




