IGP_IPAI <-
  ipeadatar::ipeadata(code = 'IGP_IPAI')

IGP_IPAI$ano <- 
  lubridate::year(IGP_IPAI$date)


Producao_Bruta <-
  read.table(
    file = 'https://app.anm.gov.br/DadosAbertos/AMB/Producao_Bruta.csv',
    sep = ',',
    header = TRUE,
    dec = ','
  )

Producao_Beneficiada <-
  read.table(
    file = 'https://app.anm.gov.br/DadosAbertos/AMB/Producao_Beneficiada.csv',
    sep = ',',
    header = TRUE,
    dec = ','
  )

Agua_Mineral_Producao <-
  read.table(
    file = 'https://app.anm.gov.br/dadosabertos/AMB/Agua_Mineral_Producao.csv',
    sep = ',',
    header = TRUE, 
    dec = ','
  )



Producao_Bruta$DFL_Valor.Venda..R.. <- NA
Producao_Bruta$DFL_Valor.Transferência.para.Transformação...Utilização...Consumo..R.. <- NA
Producao_Bruta$DFL_Valor.Transformação...Consumo...Utilização.nesta.mina..R.. <- NA
Producao_Beneficiada$DFL_Valor.Venda..R.. <- NA
Producao_Beneficiada$DFL_Valor.Transferência.para.Transformação...Utilização...Consumo..R.. <- NA
Producao_Beneficiada$DFL_Valor.Consumo...Utilização.na.Usina..R.. <- NA
Agua_Mineral_Producao$DFL_Valor..R...Garrafão <- NA
Agua_Mineral_Producao$DFL_Valor..R...Garrafa.Plástica <- NA
Agua_Mineral_Producao$DFL_Valor..R...Garrafa.de.Vidro <- NA
Agua_Mineral_Producao$DFL_Valor..R...Copo <- NA
Agua_Mineral_Producao$DFL_Valor..R...Outras.Embalagens <- NA
Agua_Mineral_Producao$DFL_Valor..R...Composição.Produtos.Industrializados <- NA

for (y in unique(Producao_Bruta$Ano.base)) {
  
  Producao_Bruta[Producao_Bruta$Ano.base == y, ]$DFL_Valor.Venda..R.. <-
    Producao_Bruta[Producao_Bruta$Ano.base == y, ]$Valor.Venda..R.. *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Producao_Bruta$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Producao_Bruta[Producao_Bruta$Ano.base == y, ]$DFL_Valor.Transferência.para.Transformação...Utilização...Consumo..R.. <-
    Producao_Bruta[Producao_Bruta$Ano.base == y, ]$Valor.Transferência.para.Transformação...Utilização...Consumo..R.. *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Producao_Bruta$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Producao_Bruta[Producao_Bruta$Ano.base == y, ]$DFL_Valor.Transformação...Consumo...Utilização.nesta.mina..R.. <-
    Producao_Bruta[Producao_Bruta$Ano.base == y, ]$Valor.Transformação...Consumo...Utilização.nesta.mina..R.. *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Producao_Bruta$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Producao_Beneficiada[Producao_Beneficiada$Ano.base == y, ]$DFL_Valor.Venda..R.. <-
    Producao_Beneficiada[Producao_Beneficiada$Ano.base == y, ]$Valor.Venda..R.. *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Producao_Beneficiada$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Producao_Beneficiada[Producao_Beneficiada$Ano.base == y, ]$DFL_Valor.Transferência.para.Transformação...Utilização...Consumo..R.. <-
    Producao_Beneficiada[Producao_Beneficiada$Ano.base == y, ]$Valor.Transferência.para.Transformação...Utilização...Consumo..R.. *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Producao_Beneficiada$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Producao_Beneficiada[Producao_Beneficiada$Ano.base == y, ]$DFL_Valor.Consumo...Utilização.na.Usina..R.. <-
    Producao_Beneficiada[Producao_Beneficiada$Ano.base == y, ]$Valor.Consumo...Utilização.na.Usina..R.. *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Producao_Beneficiada$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$DFL_Valor..R...Garrafão <-
    Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$Valor..R...Garrafão *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Agua_Mineral_Producao$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$DFL_Valor..R...Garrafa.Plástica <-
    Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$Valor..R...Garrafa.Plástica *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Agua_Mineral_Producao$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$DFL_Valor..R...Garrafa.de.Vidro <-
    Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$Valor..R...Garrafa.de.Vidro *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Agua_Mineral_Producao$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value    
  
  
  Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$DFL_Valor..R...Copo <-
    Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$Valor..R...Copo *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Agua_Mineral_Producao$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$DFL_Valor..R...Outras.Embalagens <-
    Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$Valor..R...Outras.Embalagens *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Agua_Mineral_Producao$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value
  
  
  Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$DFL_Valor..R...Composição.Produtos.Industrializados <-
    Agua_Mineral_Producao[Agua_Mineral_Producao$Ano.base == y, ]$Valor..R...Composição.Produtos.Industrializados *
    IGP_IPAI[IGP_IPAI$ano == tail(unique(Agua_Mineral_Producao$Ano.base), 1), ]$value /
    IGP_IPAI[IGP_IPAI$ano == y, ]$value    
  
  
}
