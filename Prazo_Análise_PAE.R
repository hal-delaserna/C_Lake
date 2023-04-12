rm(list = ls())


library(dplyr)


removeAcentos <- function(x) {
  gsub(pattern = "á",replacement = "a", x) %>% gsub(pattern = "â",replacement = "a") %>% 	gsub(pattern = "à",replacement = "a") %>% 	gsub(pattern = "ã",replacement = "a") %>% 	gsub(pattern = "é",replacement = "e") %>% 	gsub(pattern = "ê",replacement = "e") %>% 	gsub(pattern = "í",replacement = "i") %>% 	gsub(pattern = "ó",replacement = "o") %>% 	gsub(pattern = "ô",replacement = "o") %>% 	gsub(pattern = "õ",replacement = "o") %>% 	gsub(pattern = "ú",replacement = "u") %>% 	gsub(pattern = "ç",replacement = "c") %>% 	gsub(pattern = "Á",replacement = "A") %>% 	gsub(pattern = "Â",replacement = "A") %>% 	gsub(pattern = "À",replacement = "A") %>% 	gsub(pattern = "Ã",replacement = "A") %>% 	gsub(pattern = "É",replacement = "E") %>% 	gsub(pattern = "Ê",replacement = "E") %>% 	gsub(pattern = "Í",replacement = "I") %>% 	gsub(pattern = "Ó",replacement = "O") %>% 	gsub(pattern = "Ô",replacement = "O") %>% 	gsub(pattern = "Õ",replacement = "O") %>% 	gsub(pattern = "Ú",replacement = "U") %>% gsub(pattern = "Ç",replacement = "C") %>% gsub(pattern = "'",replacement = "")
}
maiusculasSemAcento <- function(x) {
  gsub(pattern =  "a", replacement =  "A", x) %>%	gsub(pattern =  "b", replacement =  "B") %>%	gsub(pattern =  "c", replacement =  "C") %>%	gsub(pattern =  "d", replacement =  "D") %>%	gsub(pattern =  "e", replacement =  "E") %>%	gsub(pattern =  "f", replacement =  "F") %>%	gsub(pattern =  "g", replacement =  "G") %>%	gsub(pattern =  "h", replacement =  "H") %>%	gsub(pattern =  "i", replacement =  "I") %>%	gsub(pattern =  "j", replacement =  "J") %>%	gsub(pattern =  "l", replacement =  "L") %>%	gsub(pattern =  "m", replacement =  "M") %>%	gsub(pattern =  "n", replacement =  "N") %>%	gsub(pattern =  "o", replacement =  "O") %>%	gsub(pattern =  "p", replacement =  "P") %>%	gsub(pattern =  "q", replacement =  "Q") %>%	gsub(pattern =  "r", replacement =  "R") %>%	gsub(pattern =  "s", replacement =  "S") %>%	gsub(pattern =  "t", replacement =  "T") %>%	gsub(pattern =  "u", replacement =  "U") %>%	gsub(pattern =  "v", replacement =  "V") %>%	gsub(pattern =  "x", replacement =  "X") %>%	gsub(pattern =  "z", replacement =  "Z")
}

#-----------------------------------------------------------------------------

eventos_CadMin <- read.csv('C:/Users/humberto.serna/Desktop/D_Lake/eventos_cad_Min.csv',
                           stringsAsFactors = FALSE, sep = ";", dec = ",", encoding = "ANSI")

for (i in 1:nrow(eventos_CadMin)) {
  eventos_CadMin$evento[i] <- removeAcentos(eventos_CadMin$evento[i])
}
View(eventos_CadMin)

select(eventos_CadMin, everything()) %>% 
    filter(grepl(x = eventos_CadMin$evento, pattern = "RE PESQ")==TRUE & 
           grepl(x = eventos_CadMin$evento, pattern = "PUBLI")==TRUE) | 
           grepl(x = eventos_CadMin$evento, pattern = "PLANO LAVRA")==TRUE |
           grepl(x = eventos_CadMin$evento, pattern = "PLANO APROVEITAMENTO ECON")==TRUE |
           grepl(x = eventos_CadMin$evento, pattern = "REQUERIMENTO LAVRA PROTOCOLIZADO")==TRUE |
           grepl(x = eventos_CadMin$evento, pattern = "REQUERIMENTO LAVRA PROT")==TRUE |
           grepl(x = eventos_CadMin$evento, pattern = "REQ LAVRA PROT")==TRUE |
           grepl(x = eventos_CadMin$evento, pattern = "REQ LAV PROT")==TRUE)
  
select(eventos_CadMin, everything()) %>% 
  filter(grepl(x = eventos_CadMin$evento, pattern = "PORTARIA CONCESSAO DE LAVRA PUBLICADA")==TRUE) &
           grepl(x = eventos_CadMin$evento, pattern = "REQUERIMENTO")==FALSE &
           grepl(x = eventos_CadMin$evento, pattern = "APLICADA")==FALSE



#======================================================================

library(xml2)
library(rvest)

setwd('C:/Users/humberto.serna/Desktop/D_Lake')

processo <- read_html(x = 'processos.htm',encoding = 'ANSI')
gsub(pattern = '\r\n',replacement = "&",x = processo)



html_table(processo) 

%>% data_frame()

View(df)
