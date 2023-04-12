# rm(list = ls())

library(tidyverse)
library(httr)
library(progress)

source("D:/Users/humberto.serna/Desktop/Anuario_Mineral_Brasileiro/Funcoes_de_Formatacao_Estilo/Funcoes_de_Formatacao_Estilo.R")

# WebScrapping SCA ----

# _____ autenticando sessão ----
PGSESSION <-
  rvest::session(
    'https://sistemas.dnpm.gov.br/SCM/intra/site/admin/dadosProcesso.aspx',
    authenticate("humberto.serna", "animusrisunovatur", type = "ntlm")
  )

# _____ Formulário: Preenchimento e Consulta  ----
formulario <-
  rvest::html_form(PGSESSION)[[1]]

 # __________ Injeção das consultas: ciclo FOR ----

processos <- unique(df_Processos_Cnpj_BAIXADOS$Processo)

for (j in c(1000,2000,3000,4000,5000,6000,7000,8000,9000)) {
  barra <-
    progress::progress_bar$new(total = 100, width = 90) 
  
  lista <- list()
  l <- 0
  for (i in processos[j:(j + 999)]) {
    
    barra$tick() # barra de progresso
    
    formulario_preenchido <-
      rvest::html_form_set(form = formulario,
                           `ctl00$conteudo$txtNumeroProcesso` = i)
    Sys.sleep(1)
    consultaSubmetida <-
      rvest::session_submit(PGSESSION, formulario_preenchido,
                            submit = "ctl00$conteudo$btnConsultarProcesso")
    Sys.sleep(3)
    respostaConsulta <- xml2::read_html(consultaSubmetida)
    
    a <-
      rvest::html_table(respostaConsulta, fill = TRUE)[[64]] %>% data.frame()
    
    a$processo <- i
    l <- l + 1
    lista[[l]] <- a
  }
  
  # __________consolidando tabelas Rbind ----
  Processos_Eventos_SCA <-
    do.call(what = 'rbind', args = lista)
  
  
  # * str_squish ----
  Processos_Eventos_SCA$Publicação.D.O.U <-
    gsub(pattern = "\r\n|\n|\r|;\'|\"",
         replacement = " ",
         x = Processos_Eventos_SCA$Publicação.D.O.U) %>% FUNA_removeAcentos() %>% str_squish()
  
  Processos_Eventos_SCA$Observação <-
    gsub(pattern = "\r\n|\n|\r|;\'|\"",
         replacement = " ",
         x = Processos_Eventos_SCA$Observação) %>%  FUNA_removeAcentos() %>% str_squish()
  
  Processos_Eventos_SCA$Descrição <-
    gsub(pattern = "\r\n|\n|\r|;\'|\"",
         replacement = " ",
         x = Processos_Eventos_SCA$Descrição) %>%  FUNA_removeAcentos() %>% str_squish()
  
  # __________gravação ----
  write.table(
    x = Processos_Eventos_SCA,
    file = paste("D:/Users/",Sys.getenv("USERNAME"),
      "/Desktop/","Eventos_Portarias_de_Lavra_",j ,".csv",sep = ""),
    sep = ";",
    row.names = FALSE,
    na = "",
    quote = TRUE)
  
  rm(Processos_Eventos_SCA)
}




  # titular, responsável técnico/legal ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[51]][[2]][6] %>% data.frame() %>% View()
  # substâncias/DATAS ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[53]] %>% data.frame() %>% View()
  # titulo e data de publicacao ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[54]] %>% data.frame() %>% View()q
  # Substância - tipo de uso ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[55]] %>% data.frame() %>% View()
  # municipio ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[56]] %>% data.frame() %>% View()
  # tipo: "propriedade de terceiros", etc ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[57]] %>% data.frame() %>% View()
  # processo associado ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[58]] %>% data.frame() %>% View()
  # informção sobre orçamento ----
  rvest::html_table(respostaConsulta,fill = TRUE)[[59]] %>% data.frame() %>% View()
  
  # EVENTOS
  rvest::html_table(respostaConsulta,fill = TRUE)[[59]] %>% data.frame() %>% View()
  
  
  
  
  
  
#___________________________________________________ anexos interessantes  ----





pgForm    <- html_form(x = pgSession)[[1]]  # x = node, node set or document


#______Logando
filled_form <- set_values(form = pgForm,
  `ctl00$ContentPlaceHolderCorpo$TextBoxUsuario` = "humberto.serna", 
  `ctl00$ContentPlaceHolderCorpo$TextBoxSenha` = "nosceteipsum")

PesquisarRalsSession <- submit_form(session = pgSession,
                                    form = filled_form,
                                    submit = 'ctl00$ContentPlaceHolderCorpo$ButtonOk')
#_____________________________________________________________________________

### _________________________________________
VIEWSTATE <- AbrirRalSession %>% 
               read_html() %>% 
               html_node(css = '#__VIEWSTATE') %>% 
               html_attr('value')

EVENTVALIDATION <- AbrirRalSession %>% 
               read_html() %>% 
               html_node(css = '#__EVENTVALIDATION') %>% 
               html_attr('value')

VIEWSTATEGENERATOR <- AbrirRalSession %>% 
               read_html() %>% 
               html_node(css = '#__VIEWSTATEGENERATOR') %>% 
               html_attr('value')
### __________________________________________________________


#____________________________________________________________________________________________
params <- list(`__EVENTTARGET` = "",
               `__EVENTARGUMENT` = "",
               `__LASTFOCUS` = "",
               `__VIEWSTATE` = VIEWSTATE,
               `__VIEWSTATEGENERATOR` = VIEWSTATEGENERATOR,
               `__VIEWSTATEENCRYPTED` = "",
               `__EVENTVALIDATION` = EVENTVALIDATION,
               `ctl00$ctl00$ctl00$ctl00$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$txtDNPM` = "820.061/1998")



resposta <- httr::POST(PesquisarRalsSession,
                       body = params,
                       encode = 'form') %>% 
  xml2::read_html()
#____________________________________________________________________________________________


### Expressão para pegar o nome do campo
PesquisarRalsSession %>% 
  html_nodes(xpath = '//*[@id="ctl00_ctl00_ctl00_ctl00_ContentPlaceHolderCorpo_ContentPlaceHolderCorpo_ContentPlaceHolderCorpo_ContentPlaceHolderCorpo_txtDNPM"]') %>% 
  html_attr(name = 'name')
#_______________________________________



# Pesquisar RALs ----


# html_form retornará uma lista. Assim, para um objeto 'form' devemos usar [[1]]
PesquisarRalForm <- html_form(x = PesquisarRalsSession)[[1]]  
filled_form <- set_values(form = PesquisarRalForm,
                          `ctl00$ctl00$ctl00$ctl00$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$txtDNPM` = '826.947/2013')
# Pesquisar                      
RalSession <- submit_form(session = PesquisarRalsSession, 
                          form = filled_form,
                          submit = "ctl00$ctl00$ctl00$ctl00$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$btnPesquisar")


# Abrir RAL

### Expressão para pegar o nome do campo
AbrirRalSession %>% 
   html_nodes(xpath = '/html/body/form/div[4]/div[4]/div[2]/table/tbody/tr/td[2]/div[4]/table/tbody/tr[5]/td/table/tbody/tr/td/a') %>% 
   html_attr(name = 'name')
#_______________________________________

# html_form retornará uma lista. Assim, para um objeto 'form' devemos usar [[1]]
RalForm <- html_form(x = RalSession)[[1]]  
# Pesquisar                      
AbrirRalSession <- submit_form(session = RalSession, 
                               form = RalForm,
                               submit = "ctl00$ctl00$ctl00$ctl00$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$ContentPlaceHolderCorpo$gridViewRal$ctl02$btnEditar")

AbrirRalSession %>% read_html() %>% html_text() %>% grep(pattern = "inconsistência")
 



# EXEMPLO Rvest ####

movie <- read_html("http://www.imdb.com/title/tt1490017/")
cast <- html_nodes(movie, "#titleCast span")
html_text(cast)
html_name(cast)
html_attrs(cast)
html_attr(cast, "class")
  
  
  
## 
PesquisarInconsistencia <- "http://amb.dnpm.gov.br/AMB/Site/Inconsistencia/PesquisarInconsistencia.aspx"
pgPesquisarInconsistencia <- html_session(PesquisarInconsistencia)

status_code(pgPesquisarInconsistencia)
get <- GET(PesquisarInconsistencia)


a <- read_html(pgPesquisarInconsistencia)
html_form(a) %>% edit()



rvest::session_history(pgPesquisarInconsistencia)

pgPesquisarInconsistencia <- rvest::jump_to(pgPesquisarInconsistencia, url = "http://amb.dnpm.gov.br/AMB/Site/Inconsistencia/PesquisarInconsistencia.aspx")


a <- GET(PesquisarInconsistencia) %>% rvest::html_form(pgPesquisarInconsistencia)

html_session()


url <- "https://sistemas.dnpm.gov.br/SCM/intra/site/admin/Default.aspx"
CadMin <- html_session(url)



##### Pesquisar Inconsistência formato HTM ####
library('tidyr')
library('rvest')
library('dplyr')

lista <- c("Variacao_Acima_da_Calculada1.csv.csv",
           "Variacao_Acima_da_Calculada2.csv.csv",
           "Variacao_Acima_da_Calculada3.csv.csv",
           "Variacao_Acima_da_Calculada4.csv.csv",
           "Variacao_Acima_da_Calculada5.csv.csv",
           "Variacao_Acima_da_Calculada6.csv.csv",
           "Variacao_Acima_da_Calculada7.csv.csv",
           "Variacao_Acima_da_Calculada8.csv.csv",
           "Variacao_Acima_da_Calculada9.csv.csv",
           "Variacao_Acima_da_Calculada10.csv.csv",
           "Variacao_Acima_da_Calculada11.csv.csv",
           "Variacao_Acima_da_Calculada12.csv.csv",
           "Variacao_Acima_da_Calculada13.csv.csv",
           "Variacao_Acima_da_Calculada14.csv.csv",
           "Variacao_Acima_da_Calculada15.csv.csv",
           "Variacao_Acima_da_Calculada16.csv.csv",
           "Variacao_Acima_da_Calculada17.csv.csv",
           "Variacao_Acima_da_Calculada18.csv.csv",
           "Variacao_Acima_da_Calculada19.csv.csv",
           "Variacao_Acima_da_Calculada20.csv.csv",
           "Variacao_Acima_da_Calculada21.csv.csv",
           "Variacao_Acima_da_Calculada22.csv.csv",
           "Variacao_Acima_da_Calculada23.csv.csv",
           "Variacao_Acima_da_Calculada24.csv.csv",
           "Variacao_Acima_da_Calculada25.csv.csv",
           "Variacao_Acima_da_Calculada26.csv.csv",
           "Variacao_Acima_da_Calculada27.csv.csv",
           "Variacao_Acima_da_Calculada28.csv.csv",
           "Variacao_Acima_da_Calculada29.csv.csv",
           "Variacao_Acima_da_Calculada30.csv.csv",
           "Variacao_Acima_da_Calculada31.csv.csv")

setwd("C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Cadastrar_Reservas_Minerais/A_variação_entre_as_reservas_medidas_declarada_e_calculada_no_ano_base_está_acima_do_estabelecido_para_a_campanha/")


a <- c(read.csv(lista[1],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[2],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[3],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[4],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[5],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[6],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[7],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[8],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[9],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[10],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[11],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[12],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[13],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[14],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[15],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[16],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[17],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[18],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[19],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[20],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[21],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[22],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[23],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[24],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[25],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[26],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[27],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[28],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[29],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[30],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[31],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[32],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[33],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[34],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[35],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[36],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[37],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[38],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[39],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[40],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[41],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[42],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[43],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[44],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[45],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[46],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[47],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[48],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[49],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[50],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[51],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[52],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[53],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[54],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[55],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[56],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[57],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[58],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[59],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[60],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[61],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[62],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[63],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[64],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[65],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[66],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[67],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[68],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[69],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[70],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[71],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[72],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[73],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[74],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[75],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[76],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[77],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[78],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[79],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[80],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[81],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[82],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[83],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[84],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[85],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[86],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[87],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[88],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[89],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[90],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[91],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[92],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[93],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[94],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[95],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[96],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[97],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[98],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[99],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[100],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[101],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[102],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
       )



##  Obtendo uma lista com a as Reservas Calculadas (pelo próprio AMB). 
## é o atributo de título das imagens de bolinhas

ordenacao <- 1:30
ValoresCalculados <- as.list(1:30)

for (i in ordenacao) {
  ValoresCalculados[[i]] <- read_html(a[[i]]) %>% 
    html_nodes('img') %>% 
    html_attr('title')
}


# Coerce to a dataframe
ValoresCalculados <- as.data.frame(ValoresCalculados, sep = "Pendente", headers = FALSE)
# nomes novos nas colunas
colnames(ValoresCalculados) <- c(1:30)

#@@@@@@@@@@@@@@@ se a1 até aN tem 20 registros cada, pulamos o sequEncia abaixo


    # como a pag 19 (a19) tem somente 14 registros, e não 20, será armazenada em variável
    # com outro nome, e depois reunida ao restante
ValoresCalculados1 <- as.list(1)
ValoresCalculados1[[1]] <- read_html(a[[31]]) %>% 
     html_nodes('img') %>% 
     html_attr('title')
   # Coerce to a dataframe
ValoresCalculados1 <- as.data.frame(ValoresCalculados1, sep = "Pendente", headers = FALSE)
   # nomes novos nas colunas
     colnames(ValoresCalculados1) <- c(30)
     
     
     # reunir dataframes em coluna
     ValoresCalculados <- gather(ValoresCalculados)
     # excluindo a coluna 'Key'
     ValoresCalculados[,1] <- NULL
     # Reuninado a18 + a19
      colnames(ValoresCalculados1) <- c(colnames(ValoresCalculados))
      ValoresCalculados <- rbind(ValoresCalculados,ValoresCalculados1)

      
# se todas as páginas de inconsistência tem a mesma quantidade de registros, 
# pode-se pular as etapas acima e continuar aqui
      
# excluindo as linhas com "Pendente"
      ValoresCalculados <- subset(ValoresCalculados, value!="Pendente")
 
write.table(ValoresCalculados, "ValCalc2.csv", sep=';')


#tranformando em dataframe, a tabela de inconsist?ncia de cada p?gina
a1 <- read_html(a[[1]]) %>% html_table() %>% data.frame() 
a2 <- read_html(a[[2]]) %>% html_table() %>% data.frame() 
a3 <- read_html(a[[3]]) %>% html_table() %>% data.frame() 
a4 <- read_html(a[[4]]) %>% html_table() %>% data.frame() 
a5 <- read_html(a[[5]]) %>% html_table() %>% data.frame() 
a6 <- read_html(a[[6]]) %>% html_table() %>% data.frame() 
a7 <- read_html(a[[7]]) %>% html_table() %>% data.frame() 
a8 <- read_html(a[[8]]) %>% html_table() %>% data.frame() 
a9 <- read_html(a[[9]]) %>% html_table() %>% data.frame() 
a10 <- read_html(a[[10]]) %>% html_table() %>% data.frame() 
a11 <- read_html(a[[11]]) %>% html_table() %>% data.frame() 
a12 <- read_html(a[[12]]) %>% html_table() %>% data.frame() 
a13 <- read_html(a[[13]]) %>% html_table() %>% data.frame() 
a14 <- read_html(a[[14]]) %>% html_table() %>% data.frame() 
a15 <- read_html(a[[15]]) %>% html_table() %>% data.frame() 
a16 <- read_html(a[[16]]) %>% html_table() %>% data.frame() 
a17 <- read_html(a[[17]]) %>% html_table() %>% data.frame() 
a18 <- read_html(a[[18]]) %>% html_table() %>% data.frame() 
a19 <- read_html(a[[19]]) %>% html_table() %>% data.frame() 
a20 <- read_html(a[[20]]) %>% html_table() %>% data.frame() 
a21 <- read_html(a[[21]]) %>% html_table() %>% data.frame() 
a22 <- read_html(a[[22]]) %>% html_table() %>% data.frame() 
a23 <- read_html(a[[23]]) %>% html_table() %>% data.frame() 
a24 <- read_html(a[[24]]) %>% html_table() %>% data.frame() 
a25 <- read_html(a[[25]]) %>% html_table() %>% data.frame() 
a26 <- read_html(a[[26]]) %>% html_table() %>% data.frame() 
a27 <- read_html(a[[27]]) %>% html_table() %>% data.frame() 
a28 <- read_html(a[[28]]) %>% html_table() %>% data.frame() 
a29 <- read_html(a[[29]]) %>% html_table() %>% data.frame() 
a30 <- read_html(a[[30]]) %>% html_table() %>% data.frame() 
a31 <- read_html(a[[31]]) %>% html_table() %>% data.frame() 
a32 <- read_html(a[[32]]) %>% html_table() %>% data.frame() 
a33 <- read_html(a[[33]]) %>% html_table() %>% data.frame() 
a34 <- read_html(a[[34]]) %>% html_table() %>% data.frame() 
a35 <- read_html(a[[35]]) %>% html_table() %>% data.frame() 
a36 <- read_html(a[[36]]) %>% html_table() %>% data.frame() 
a37 <- read_html(a[[37]]) %>% html_table() %>% data.frame() 
a38 <- read_html(a[[38]]) %>% html_table() %>% data.frame() 
a39 <- read_html(a[[39]]) %>% html_table() %>% data.frame() 
a40 <- read_html(a[[40]]) %>% html_table() %>% data.frame() 
a41 <- read_html(a[[41]]) %>% html_table() %>% data.frame() 
a42 <- read_html(a[[42]]) %>% html_table() %>% data.frame() 
a43 <- read_html(a[[43]]) %>% html_table() %>% data.frame() 
a44 <- read_html(a[[44]]) %>% html_table() %>% data.frame() 
a45 <- read_html(a[[45]]) %>% html_table() %>% data.frame() 
a46 <- read_html(a[[46]]) %>% html_table() %>% data.frame() 
a47 <- read_html(a[[47]]) %>% html_table() %>% data.frame() 
a48 <- read_html(a[[48]]) %>% html_table() %>% data.frame() 
a49 <- read_html(a[[49]]) %>% html_table() %>% data.frame() 
a50 <- read_html(a[[50]]) %>% html_table() %>% data.frame() 
a51 <- read_html(a[[51]]) %>% html_table() %>% data.frame() 
a52 <- read_html(a[[52]]) %>% html_table() %>% data.frame() 
a53 <- read_html(a[[53]]) %>% html_table() %>% data.frame() 
a54 <- read_html(a[[54]]) %>% html_table() %>% data.frame() 
a55 <- read_html(a[[55]]) %>% html_table() %>% data.frame() 
a56 <- read_html(a[[56]]) %>% html_table() %>% data.frame() 
a57 <- read_html(a[[57]]) %>% html_table() %>% data.frame() 
a58 <- read_html(a[[58]]) %>% html_table() %>% data.frame() 
a59 <- read_html(a[[59]]) %>% html_table() %>% data.frame() 
a60 <- read_html(a[[60]]) %>% html_table() %>% data.frame() 
a61 <- read_html(a[[61]]) %>% html_table() %>% data.frame() 
a62 <- read_html(a[[62]]) %>% html_table() %>% data.frame() 
a63 <- read_html(a[[63]]) %>% html_table() %>% data.frame() 
a64 <- read_html(a[[64]]) %>% html_table() %>% data.frame() 
a65 <- read_html(a[[65]]) %>% html_table() %>% data.frame() 
a66 <- read_html(a[[66]]) %>% html_table() %>% data.frame() 
a67 <- read_html(a[[67]]) %>% html_table() %>% data.frame() 
a68 <- read_html(a[[68]]) %>% html_table() %>% data.frame() 
a69 <- read_html(a[[69]]) %>% html_table() %>% data.frame() 
a70 <- read_html(a[[70]]) %>% html_table() %>% data.frame() 
a71 <- read_html(a[[71]]) %>% html_table() %>% data.frame() 
a72 <- read_html(a[[72]]) %>% html_table() %>% data.frame() 
a73 <- read_html(a[[73]]) %>% html_table() %>% data.frame() 
a74 <- read_html(a[[74]]) %>% html_table() %>% data.frame() 
a75 <- read_html(a[[75]]) %>% html_table() %>% data.frame() 
a76 <- read_html(a[[76]]) %>% html_table() %>% data.frame() 
a77 <- read_html(a[[77]]) %>% html_table() %>% data.frame() 
a78 <- read_html(a[[78]]) %>% html_table() %>% data.frame() 
a79 <- read_html(a[[79]]) %>% html_table() %>% data.frame() 

#Reunindo linhas
tabela<-rbind(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,
              a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,
              a29,a30,a31,a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,
              a42,a43,a44,a45,a46,a47,a48,a49,a50,a51,a52,a53,a54,
              a55,a56,a57,a58,a59,a60,a61,a62,a63,a64,a65,a66,a67,
              a68,a69,a70,a71,a72,a73,a74,a75,a76,a77,a78,a79)

# Montando a Tabela de inconsist?ncia com valores para corre??o
tabela <- cbind(cbind(tabela[,1],tabela[,2],tabela[,3],tabela[,4]),
            cbind(ValoresCalculados[,1])
            )

View(tabela)

# Exportando tabela
write.csv2(tabela,"Substância_AMB_da_Mina_e_Processo.csv")

##### Tabelas do SISPLAN ####

library(rvest)
library(XML)
setwd('C:/Users/humberto.serna/Desktop/SISPLAN')

url <- read_html("C:/Users/humberto.serna/Desktop/SISPLAN/CONSOLIDADO.HTM")

a1<- html_nodes(url, xpath = "/html/body/table[1]")%>% html_table() %>% data.frame()
a2<- html_nodes(url, xpath = "/html/body/table[2]")%>% html_table() %>% data.frame()
a3<- html_nodes(url, xpath = "/html/body/table[3]")%>% html_table() %>% data.frame()
a4<- html_nodes(url, xpath = "/html/body/table[4]")%>% html_table() %>% data.frame()
a5<- html_nodes(url, xpath = "/html/body/table[5]")%>% html_table() %>% data.frame()
a6<- html_nodes(url, xpath = "/html/body/table[6]")%>% html_table() %>% data.frame()
a7<- html_nodes(url, xpath = "/html/body/table[7]")%>% html_table() %>% data.frame()
a8<- html_nodes(url, xpath = "/html/body/table[8]")%>% html_table() %>% data.frame()
a9<- html_nodes(url, xpath = "/html/body/table[9]")%>% html_table() %>% data.frame()
a10<- html_nodes(url, xpath = "/html/body/table[10]")%>% html_table() %>% data.frame()
a12<- html_nodes(url, xpath = "/html/body/table[10]")%>% html_table() %>% data.frame()
a13<- html_nodes(url, xpath = "/html/body/table[10]")%>% html_table() %>% data.frame()
a11<- html_nodes(url, xpath = "/html/body/table[11]")%>% html_table() %>% data.frame()
a14<- html_nodes(url, xpath = "/html/body/table[14]")%>% html_table() %>% data.frame()

tabela<-rbind(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14)
write.csv2(tabela,"Execução_por_Natureza_da_Despesa.csv")



# Nome da Mina, processos e minério - Formato HTM ####

library('tidyr')
library('rvest')
library('dplyr')

lista <- c('Ordenação_Minas_Processos1.csv',
           'Ordenação_Minas_Processos2.csv',
           'Ordenação_Minas_Processos3.csv',
           'Ordenação_Minas_Processos4.csv',
           'Ordenação_Minas_Processos5.csv',
           'Ordenação_Minas_Processos6.csv',
           'Ordenação_Minas_Processos7.csv',
           'Ordenação_Minas_Processos8.csv',
           'Ordenação_Minas_Processos9.csv',
           'Ordenação_Minas_Processos10.csv',
           'Ordenação_Minas_Processos11.csv',
           'Ordenação_Minas_Processos12.csv',
           'Ordenação_Minas_Processos13.csv',
           'Ordenação_Minas_Processos14.csv',
           'Ordenação_Minas_Processos15.csv',
           'Ordenação_Minas_Processos16.csv',
           'Ordenação_Minas_Processos17.csv',
           'Ordenação_Minas_Processos18.csv',
           'Ordenação_Minas_Processos19.csv',
           'Ordenação_Minas_Processos20.csv',
           'Ordenação_Minas_Processos21.csv',
           'Ordenação_Minas_Processos22.csv',
           'Ordenação_Minas_Processos23.csv',
           'Ordenação_Minas_Processos24.csv',
           'Ordenação_Minas_Processos25.csv',
           'Ordenação_Minas_Processos26.csv',
           'Ordenação_Minas_Processos27.csv',
           'Ordenação_Minas_Processos28.csv',
           'Ordenação_Minas_Processos29.csv',
           'Ordenação_Minas_Processos30.csv',
           'Ordenação_Minas_Processos31.csv',
           'Ordenação_Minas_Processos32.csv',
           'Ordenação_Minas_Processos33.csv',
           'Ordenação_Minas_Processos34.csv',
           'Ordenação_Minas_Processos35.csv',
           'Ordenação_Minas_Processos36.csv',
           'Ordenação_Minas_Processos37.csv',
           'Ordenação_Minas_Processos38.csv',
           'Ordenação_Minas_Processos39.csv',
           'Ordenação_Minas_Processos40.csv',
           'Ordenação_Minas_Processos41.csv',
           'Ordenação_Minas_Processos42.csv'
           )


setwd("C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Ordenação_de_Processos_e_Minas/Tela_Producao_Bruta")

a <- c(read.csv(lista[1],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[2],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[3],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[4],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[5],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[6],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[7],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[8],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[9],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[10],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[11],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[12],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[13],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[14],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[15],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[16],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[17],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[18],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[19],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[20],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[21],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[22],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[23],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[24],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[25],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[26],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[27],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[28],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[29],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[30],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[31],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[32],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[33],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[34],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[35],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[36],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[37],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[38],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[39],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[40],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[41],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8"),
       read.csv(lista[42],header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
       )


ordenacao <- 1:42

# caso conste algum erro de scrape e tivermos erro de valor não disponível,"EANF"
for (i in ordenacao) {
  a[i] <-  gsub('#EANF#',"<table><tbody><tr><th scope=''col''>Mina</th><th scope=''col''>DNPM</th><th scope=''col''>Minério</th><th scope=''col''>Substância</th><th class=''AlinharCentro'' scope=''col''>Excluir</th></tr> <tr><td>vazio</td><td>vazio</td><td>vazio</td><td>vazio</td><td>vazio</td></tr></tbody></table>",a[i])
}

             

#_____________ Injecao das Correções ####
library(tidyr)

setwd('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/AMB_Metálicos/Ouro')

imacro <- read.csv2('injeção_das_correções.csv', 
                    header = FALSE,
                    encoding = 'ANSI',
                    stringsAsFactors = FALSE)

t_imacro <- t(imacro)
t_imacro <- as.data.frame(t_imacro)
injecao_das_reservas <- gather(t_imacro)
write.table(injecao_das_reservas, "injeção_das_correções_final.csv",sep = ";")


## Migração das Reservas ####
library(rvest)
library(dplyr)

CADUC <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/CADUC.htm')
CESSAO_PARCIAL <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/CESSÃO_PARCIAL.htm')
CESSAO_TOTAL <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/CESSÃO_TOTAL.htm')
CONC_LAV <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/CONC_LAV.htm')
DESMEMBRAMENTO <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/DESMEMBRAMENTO.htm')
INCORPORACAO <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/INCORPORAÇÃO.htm')
REL_PESQ <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/REL_PESQ.htm')
RRR <- read_html('C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas/RRR.htm')

setwd("C:/Users/humberto.serna/Desktop/Depuração_Ano_Base_2016/Migração das Reservas")

CADUC <- CADUC %>% html_table() %>% data.frame()
CADUC$Evento <- c("caducidade")

CESSAO_PARCIAL <- CESSAO_PARCIAL %>% html_table() %>% data.frame()
CESSAO_PARCIAL$Evento <- c("CESSAO_PARCIAL")

CESSAO_TOTAL <- CESSAO_TOTAL %>% html_table() %>% data.frame()
CESSAO_TOTAL$Evento <- c("CESSAO_TOTAL")

CONC_LAV <- CONC_LAV %>% html_table() %>% data.frame()
CONC_LAV$Evento <- c("CONC_LAV")

DESMEMBRAMENTO <- DESMEMBRAMENTO %>% html_table() %>% data.frame() 
DESMEMBRAMENTO$Evento <- c('DESMEMBRAMENTO')

INCORPORACAO <- INCORPORACAO %>% html_table() %>% data.frame() 
INCORPORACAO$Evento <- c('INCORPORACAO')

REL_PESQ <- REL_PESQ %>% html_table() %>% data.frame() 
REL_PESQ$Evento <- c('REL_PESQ')

RRR <- RRR %>% html_table() %>% data.frame() 
RRR$Evento <- c('RRR')

Not_Migração_de_Reservas <- bind_rows(CADUC,
                                      CESSAO_PARCIAL,
                                      CESSAO_TOTAL,
                                      CONC_LAV,
                                      DESMEMBRAMENTO,
                                      INCORPORACAO,
                                      REL_PESQ,
                                      RRR)

colnames(Not_Migração_de_Reservas) <- c(RRR[1,1:12],'Evento')


write.table(Not_Migração_de_Reservas,"Not_Migração_de_Reservas.csv", sep=";")



# RSelenium ####
# install_github(repo = "crubba/Rwebdriver", username = "crubba") # instalar devtools antes

library('devtools')
library(Rwebdriver)
library(XML)
library(RSelenium)


# usar o Docker ao invés do rsDriver: https://coredump.pt/questions/45395849/cant-execute-rsdriver-connection-refused


shell('docker pull selenium/standalone-firefox')

shell('docker run -d -p 4445:4444 selenium/standalone-firefox')

remDr <- remoteDriver(remoteServerAddr = "localhost", port = 5040L, browserName = "firefox'")


#rsDriver(browser = 'firefox', check = TRUE, verbose = TRUE) # Caso você tenha instalado o Selenium pelo pacote. Se não, terá que iniciar manualmente

remDr <- remoteDriver(browserName = "firefox", remoteServerAddr = 'localhost') # Conecta com o Selenium no Chrome (Siga as intruções para instalar o driver do Chrome: https://cran.r-project.org/web/packages/RSelenium/vignettes/RSelenium-saucelabs.html#id1a)
remDr$open() # Abre o navegador
remDr$navigate("http://www.vivareal.com.br/venda/minas-gerais/uberlandia/apartamento_residencial/#1/") # Abre a página a ser explorada














funcao_demorada <- function(x) {
  Sys.sleep(1)
  x ^ 2
}


nums <- 1:5
barra <- progress::progress_bar$new(total = length(nums)) # cria a barra

resultados <- list()
for (x in nums) {
  barra$tick() # dá um passo
  resultados[[x]] <- funcao_demorada(x)
}






# ********* GRAVAR NO CLIPBOARD ********* ----
#     write.table(x = Licenciamentos_SP_PRAZOS, file = "Licenciamentos_SP_PRAZOS.csv", quote = TRUE, sep = ";", na = "", row.names = FALSE)





