# rm(list = ls())

library(tidyverse)
library(httr)
library(progress)

source("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Funcoes_de_Formatacao_Estilo/Funcoes_de_Formatacao_Estilo.R")
# Licenciamentos_SP c/ eventos do SCA
Licenciamentos_SP <- read.table(file = paste(Sys.getenv("R_USER"), "/D_Lake/", 'Licenciamentos_SP.csv', sep = ""),sep = ";", fill = TRUE,  encoding  = "ANSI", header = TRUE, stringsAsFactors = FALSE )


# * str_squish ----
Licenciamentos_SP$Publicacao.D.O.U <-
  gsub(pattern = "\r\n|\n|\r|;|-", replacement = " ", x = Licenciamentos_SP$Publicacao.D.O.U) %>% FUNA_removeAcentos() %>% str_squish()

Licenciamentos_SP$Observação <-
  gsub(pattern = "\r\n|\n|\r|;|-", replacement = " ", x = Licenciamentos_SP$Observação) %>%  FUNA_removeAcentos() %>% str_squish()

Licenciamentos_SP$Descrição <-
  gsub(pattern = "\r\n|\n|\r|;|-", replacement = " ", x = Licenciamentos_SP$Descrição) %>%  FUNA_removeAcentos() %>% str_squish()


# ____ Datas de fim de vigência ----
Licenciamentos_SP$Publicacao.D.O.U <- 
  Licenciamentos_SP$Publicacao.D.O.U

Licenciamentos_SP <- 
  separate(
    Licenciamentos_SP,
    col = "Publicacao.D.O.U",
    sep = "encimento",
    into = c(NA, 'Vencimento'),
    remove = TRUE, extra = 'merge'
  )



# regex p/ excluir 
Licenciamentos_SP$Vencimento <- 
  str_squish(
    gsub(
      Licenciamentos_SP$Vencimento,
      pattern = ".+(Licenca|Licenciamento)|.+(em )|:|,|\"|)|\\.|.+(?i)(ate|prazo|validade)",
      replacement = ""
    )) # %>% gsub(pattern = "(?i)(INDETERMINAD.)", replacement = "")) %>% edit()



# Eventos alvo do Licenciamento ----

Licenciamentos_SP$situacao <- ""
for (i in 1:nrow(Licenciamentos_SP)) { 
  if (Licenciamentos_SP$Descrição[i]  == "1811 AREA BLOQUEADA JUDICIALMENTE") {
    Licenciamentos_SP$situacao[i]  <- "BLOQUEIO judicial"
  } else if (Licenciamentos_SP$Descrição[i]  == "328 DISPONIB/AREA DISPONIVEL ART 26 CM PUBLI") {
    Licenciamentos_SP$situacao[i]  <- "DISPONIBILIDADE"
  } else if (Licenciamentos_SP$Descrição[i]  == "1351 DISPONIB/TORNA S/EFEITO DISPONIB ART 26 AREA LICEN") {
    Licenciamentos_SP$situacao[i]  <- "s/ efeito DISPONIBILIDADE"
  } else if (Licenciamentos_SP$Descrição[i]  == "704 LICEN/CANCELAMENTO LICENCIAMENTO PUB") {
    Licenciamentos_SP$situacao[i]  <- "CANCELAMENTO do licenciamento"
  } else if (Licenciamentos_SP$Descrição[i]  == "705 LICEN/BAIXA LICENCIAMENTO ESGOTADO PRAZO") {
    Licenciamentos_SP$situacao[i]  <- "BAIXA do licenciamento por Prazo"
  } else if (Licenciamentos_SP$Descrição[i]  == "730 LICEN/LICENCIAMENTO AUTORIZADO PUBLICADO") {
    Licenciamentos_SP$situacao[i]  <- "licenciamento PUBLICADO"
  } else if (Licenciamentos_SP$Descrição[i]  == "742 LICEN/PRORROGACAO REGISTRO LICENCA AUTORIZADA") {
    Licenciamentos_SP$situacao[i]  <- "PRORROGADO"
  } else if (Licenciamentos_SP$Descrição[i]  == "751 LICEN/BAIXA LICENCA ESGOTADO PRAZO") {
    Licenciamentos_SP$situacao[i]  <- "BAIXA por esgotamento Prazo"
  } else if (Licenciamentos_SP$Descrição[i]  == "771 LICEN/TORNA S/EFEITO LICENCIAMENTO PUB") {
    Licenciamentos_SP$situacao[i]  <- "Torna licenciamento s/ efeito"
  } else if (Licenciamentos_SP$Descrição[i]  == "781 LICEN/ARQUIVAMENTO PROCESSO LICENCIAMENTO PUBL") {
    Licenciamentos_SP$situacao[i]  <- "licenciamento ARQUIVADO"
  } else if (Licenciamentos_SP$Descrição[i]  == "782 LICEN/AREA BLOQUEADA ART 42 CM PUB") {
    Licenciamentos_SP$situacao[i]  <- "BLOQUEIO (art 42)"
  } else if (Licenciamentos_SP$Descrição[i]  == "784 LICEN/RENUNCIA LICENCIAMENTO HOMOLOGADA PUBLICADA") {
    Licenciamentos_SP$situacao[i]  <- "RENUNCIA"
  } else if (Licenciamentos_SP$Descrição[i]  == "796 LICEN/TORNA S/EFEITO CANCELAMENTO DO TITULO PUB") {
    Licenciamentos_SP$situacao[i]  <- "S/ efeito CANCELAMENTO"
  } else if (Licenciamentos_SP$Descrição[i]  == "797 LICEN/TORNA S/EFEITO LICENCIAMENTO ART 43 CONST") {
    Licenciamentos_SP$situacao[i]  <- "TORNA S/ EFEITO (art 43)"
  } else if (Licenciamentos_SP$Descrição[i]  == "799 LICEN/CANCELAMENTO LICENCIAMENTO PUBLIC") {
    Licenciamentos_SP$situacao[i]  <- "CANCELAMENTO do licenciamento"
  } else if (Licenciamentos_SP$Descrição[i]  == "1285 LICEN/OPCAO REGIME AUTORIZACAO PESQ AUTORIZADA") {
    Licenciamentos_SP$situacao[i]  <- "MUDANCA DE REGIME: autor. de Presquisa"
  } else if (Licenciamentos_SP$Descrição[i]  == "1286 LICEN/INSTAURA PROC ADM NULIDADE REGISTRO LICENCA") {
    Licenciamentos_SP$situacao[i]  <- "proc admin NULIDADE licenciamento"
  } else if (Licenciamentos_SP$Descrição[i]  == "1287 LICEN/INSTAURA PROC ADM CASSACAO REGISTRO LICENCA") {
    Licenciamentos_SP$situacao[i]  <- "proc admin CASSACAO licendiamento"
  } else if (Licenciamentos_SP$Descrição[i]  == "1288 LICEN/REGISTRO DE LICENCA ANULADO") {
    Licenciamentos_SP$situacao[i]  <- "ANULADO licenciamento"
  } else if (Licenciamentos_SP$Descrição[i]  == "1321 LICEN/TORNA S/ EFEITO DESPACHO NULIDADE DO TITULO") {
    Licenciamentos_SP$situacao[i]  <- "S/ efeito NULIDADE"
  } else if (Licenciamentos_SP$Descrição[i]  == "1816 LICEN/BAIXA TRANSCRICAO TITULO MUDANCA DE REGIME") {
    Licenciamentos_SP$situacao[i]  <- "BAIXA por mudanca de regime"
  } else if (Licenciamentos_SP$Descrição[i]  == "2118 LICEN/BAIXA LICENCIAMENTO LIBERADA PARA EDITAL") {
    Licenciamentos_SP$situacao[i]  <- "BAIXA Licenciamento"
  } else if (Licenciamentos_SP$Descrição[i]  == "1147 REQ LICEN/ARQUIVAMENTO PROCESSO PUBLICADO") {
    Licenciamentos_SP$situacao[i]  <- "ARQUIVAMENTO"
  } else if (Licenciamentos_SP$Descrição[i]  == "1342 REQ LICEN/AREA DISPONIBILIDADE PARA PESQUISA EDITAL") {
    Licenciamentos_SP$situacao[i]  <- "edital DISPONIBILIDADE"
  } else if (Licenciamentos_SP$Descrição[i]  == "1821 REQ LICEN/TORNA S/EFEITO NULIDADE DO TITULO") {
    Licenciamentos_SP$situacao[i]  <- "S/ efeito NULIDADE"
  } 
} 





# _____ EVENTOS_que_inativam_LICENCIAMENTOS ----
EVENTOS_que_inativam_LICENCIAMENTOS <- 
  read.table(file = paste(Sys.getenv("R_USER"), "/D_Lake/", 'EVENTOS_que_inativam_LICENCIAMENTOS.csv', sep = ""), 
             header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE, encoding = "ANSI")

EVENTOS_que_inativam_LICENCIAMENTOS$Descrição <-
  gsub(pattern = "\r\n|\n|\r|;", replacement = " ", x = EVENTOS_que_inativam_LICENCIAMENTOS$Descrição) %>% FUNA_removeAcentos() %>% str_squish()

# _____ EVENTOS_que_REVOGAM_EVENTOS ----
EVENTOS_que_REVOGAM_EVENTOS <- 
  read.table(file = paste(Sys.getenv("R_USER"), "/D_Lake/", 'EVENTOS_que_REVOGAM_EVENTOS.csv', sep = ""), 
             header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE, encoding = "ANSI")

EVENTOS_que_REVOGAM_EVENTOS$Descrição <-
  gsub(pattern = "\r\n|\n|\r|;", replacement = " ", x = EVENTOS_que_REVOGAM_EVENTOS$Descrição) %>% FUNA_removeAcentos() %>% str_squish()

# _____ eventos presentes em Licenciamentos_SP ----
eventosDoLicenciamento <- 
  data.frame(Descrição = unique(Licenciamentos_SP$Descrição), stringsAsFactors = FALSE) 

eventos_1 <- 
  anti_join(eventosDoLicenciamento, EVENTOS_que_inativam_LICENCIAMENTOS, by = 'Descrição')

eventos_1 <- 
  anti_join(eventos_1, EVENTOS_que_REVOGAM_EVENTOS, by = 'Descrição')


eventos_1$inativacao <- 1
eventosDoLicenciamento <- 
  rbind(eventos_1, EVENTOS_que_inativam_LICENCIAMENTOS, EVENTOS_que_REVOGAM_EVENTOS)

#Licenciamentos_SP <- left_join(Licenciamentos_SP, eventosDoLicenciamento, by = "Descrição")

# _____ prorrogação: valor 2 ----
Licenciamentos_SP[grepl(Licenciamentos_SP$Descrição, pattern= "742|722"),]$inativacao <- 2



situacaoDos_Licenciamentos <- 
  select(Licenciamentos_SP, everything()) %>% group_by(processo) %>%
  summarise("vigente" = prod(inativacao))


sem_vigencia <- 
  situacaoDos_Licenciamentos[situacaoDos_Licenciamentos$vigente < 0,]$processo



# Licenciamentos SP PRAZOS ----
# _____ carregamento ---- 
Licenciamentos_SP_PRAZOS <- 
  read.table(file = paste(Sys.getenv("R_USER"), "/D_Lake/", 'Licenciamentos_SP_PRAZOS.csv', sep = ""),sep = ";", fill = TRUE,  encoding  = "ANSI", header = TRUE, stringsAsFactors = FALSE )

# _____ formatando p/ datas ----
Licenciamentos_SP_PRAZOS$Data.de.publicação <- 
  lubridate::dmy(Licenciamentos_SP_PRAZOS$Data.de.publicação) 

Licenciamentos_SP_PRAZOS$Data.Vencimento <- 
  lubridate::dmy(Licenciamentos_SP_PRAZOS$Data.Vencimento) 


passado <-
  data.frame("processo" = unique(
               Licenciamentos_SP_PRAZOS[Licenciamentos_SP_PRAZOS$Data.Vencimento < lubridate::today(), 'processo']),
              stringsAsFactors = FALSE)
futuro <-
  data.frame("processo" = unique(
               Licenciamentos_SP_PRAZOS[Licenciamentos_SP_PRAZOS$Data.Vencimento > lubridate::today(), 'processo']),
             stringsAsFactors = FALSE)
# Licenciamentos Vencidos ----

Licenciamentos_Vencidos <- 
  anti_join(passado, futuro,by = "processo")

Licenciamentos_Vencidos <-
  left_join(Licenciamentos_Vencidos, Licenciamentos_SP_PRAZOS, by = "processo")

# _____ datas de vencimentos ----
datas_Vencimentos <-
  select(Licenciamentos_Vencidos, everything()) %>%
  group_by(processo) %>% summarise("vencimento" = max(Data.Vencimento, na.rm = TRUE))

datas_Vencimentos$id <-
  paste(datas_Vencimentos$processo,
        datas_Vencimentos$vencimento,
        sep = "")

Licenciamentos_Vencidos$id <-
  paste(Licenciamentos_Vencidos$processo,
        Licenciamentos_Vencidos$Data.Vencimento,
        sep = "")

Licenciamentos_Vencidos <-
  left_join(datas_Vencimentos, Licenciamentos_Vencidos, by = "id")

Licenciamentos_Vencidos <- 
  Licenciamentos_Vencidos[,c(2,4:10)] 

colnames(Licenciamentos_Vencidos)[2] <- "processo"

# foi encontrado em Licenciamentos_Vencidos processos com evento de baixa/arquivamento, ainda Ativo.  ----
  # contraste Licenciamentos_Vencidos x sem_vigencia

Licenciamentos_realmente_Vencidos <- 
  anti_join(Licenciamentos_Vencidos, data.frame("processo" = unique(sem_vigencia)), by = "processo")


# há licenciamentos com vencimento INDETERMINADO:

Vencimento_indeterminado <- 
  Licenciamentos_SP[grepl(Licenciamentos_SP$Vencimento, pattern = "INDETER."),c("processo", 'Vencimento')]

Vencimento_indeterminado$Vencimento <- "Vencimento Indeterminado"
  
# unindo Licenciamentos (realmente) Vencidos com os de Vencimento indeterminado ----

Licenciamentos_realmente_Vencidos <- 
  left_join(Licenciamentos_realmente_Vencidos, Vencimento_indeterminado, by = "processo")


 write.table(x = Licenciamentos_realmente_Vencidos, file = 'Licenciamentos_realmente_Vencidos.csv', sep = ";", row.names = FALSE) 


# licenciamentos da GerSP 
Licenciamentos_realmente_Vencidos <- 
  inner_join(Licenciamentos_realmente_Vencidos,lice_SP, by = 'processo') 


Licenciamentos_SP[Licenciamentos_SP$processo %in% as.character(situacaoDos_Licenciamentos[situacaoDos_Licenciamentos$vigente == -1, ]$processo), ] %>% View()




