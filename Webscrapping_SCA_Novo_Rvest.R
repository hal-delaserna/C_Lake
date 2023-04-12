# rm(list = ls())

library(tidyverse)
library(httr)
library(rvest)
library(progress)

# WebScrapping SCA ----

# _____ autenticando sess?o ----
PGSESSION <-
  rvest::session(
    'https://sistemas.dnpm.gov.br/SCM/intra/site/admin/dadosProcesso.aspx',
    authenticate(
      user = "humberto.serna",
      password = "naturnonfacitsaltus",
      type = "ntlm"
    )
  )

# _____ Formul?rio: Preenchimento e Consulta  ----
formulario <- 
  rvest::html_form(PGSESSION)[[1]]

processos <- 
  unique(
    read.table(file = 'D:/Users/humberto.serna/Desktop/Superintendência_de_Regulação/CaducidadeBrasil/amostra.txt',
             header = T, sep = ";")[,1])


# __________ Inje??o das consultas: ciclo FOR ----
barra <- progress::progress_bar$new(total = length(processos))

for (j in seq(1, length(processos), 10)) {
  barra$tick() # barra de progresso
  
  
  lista <- list()
  l <- 0
  for (i in processos[1:(j + 9)]) {
    formulario_preenchido <- rvest::html_form_set(form = formulario,
                                                  `ctl00$conteudo$txtNumeroProcesso` = i)
    
    segundos <- rnorm(1, 5.8, 1.3)
    Sys.sleep(segundos)
    
    consultaSubmetida <-
      rvest::session_submit(PGSESSION, formulario_preenchido,
                            submit = "ctl00$conteudo$btnConsultarProcesso")
    
    
    if (consultaSubmetida[[3]][[2]] != 500) {
      respostaConsulta <- xml2::read_html(consultaSubmetida)
      
      a <-
        rvest::html_table(respostaConsulta, fill = TRUE)[[64]] %>% data.frame()
      
      a$processo <- i
      l <- l + 1
      lista[[l]] <- a
      
    }
  }
  
  # __________consolidando tabelas Rbind ----
  Processos_Eventos_SCA <- 
    do.call(what = 'rbind', args = lista)
  
  # __________grava??o ----
  write.table(
    x = Processos_Eventos_SCA,
    file = paste("D:/Users/",Sys.getenv("USERNAME"),"/Desktop/Nova_pasta/","Eventos_Portarias_de_Lavra_", j , ".csv",sep = ""),
    sep = ";",
    #  dec = ".",
    row.names = FALSE, na = "", quote = TRUE
  )
  
  
  rm(Processos_Eventos_SCA)
  
}

