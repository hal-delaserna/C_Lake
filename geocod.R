geocod <-
  read.table(
    file = paste(sep = "",
                 "./data/",
                 "GeoCodigos_IBGE.csv"),
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
  
  
  
  