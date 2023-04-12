rm(list = ls())
library(rvest)
library(tidyr)
library(dplyr)


# para importar a base do cadastro mineiro e ajustá-la para análise, transformando-a em .RDS

library(rvest)
processos_protocolados <- read_html('D:/Users/humberto.serna/Desktop/D_Lake/CadMin_SP.html') %>% html_table() %>% data.frame()
colnames(processos_protocolados) <- processos_protocolados[1,]
processos_protocolados <- processos_protocolados[2:nrow(processos_protocolados),]

# Filtrando a Super SP
processos_SP_protocolados <- processos_protocolados[processos_protocolados$`Unidade Protocolizadora`=="SÃO PAULO",]

processos_SP_ativos <- processos_protocolados[processos_protocolados$`Situação`=="Ativo",]

# Separando substâncias colunas em colunas distintas
processos_SP_ativos <- separate(data = processos_SP_ativos,
         col = 'Substâncias',
         into = c('Substância1','Substância2','Substância3','Substância4','Substância5','Substância6','Substância7','Substância8','Substância9'), 
         sep = '@') 



# Separando minicípios em colunas distintas
processos_SP_ativos <- separate(data = processos_SP_ativos,
                                col = 'Municípios',
                                into = c('Município1','Município2','Município3','Município4'), 
                                sep = '@') 



colnames(processos_SP_ativos) <- c("processo", "requerimento", "fase", "cpfcnpj", 
                                "titular", "mun1", "mun2", "mun3", 
                                "mun4", "substancia1", "substancia2", "substancia3", "substancia4", 
                                "substancia5", "substancia6", "substancia7", "substancia8", "substancia9", 
                                "uso", "situacao", "unidade_protocolizadora", "superintendencia", 
                                "hectares")


View(processos_SP_ativos)
saveRDS(processos_SP_ativos, file = 'C:/Users/humberto.serna/Desktop/D_Lake/processos_SP_ativos.rds')


