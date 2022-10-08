


FUNA_caractereParaNumero <-
  function(x) {
    gsub("[.]", "", x) %>% gsub(pattern = " ", replacement = "") %>% gsub(pattern = " ", replacement = "") %>% gsub(pattern = " ", replacement =                                                                                                                      "") %>% gsub(pattern = "-", replacement = "0") %>% gsub(pattern = ",", replacement = ".") %>% as.numeric()
  }
FUNA_removeAcentos <-
  function(x) {
    stringi::stri_trans_general(str = x, id = "Latin-ASCII") %>% gsub(pattern = "'", replacement = "") %>% gsub(pattern = "-", replacement = " ")
  }
FUNA_maiusculas <-
  function(x) {
    gsub(pattern =  "a", replacement =  "A", x) %>%	gsub(pattern =  "b", replacement =  "B") %>% gsub(pattern =  "c", replacement =  "C") %>%	gsub(pattern =  "d", replacement =  "D") %>%	gsub(pattern =  "e", replacement =  "E") %>%	gsub(pattern =  "f", replacement =  "F") %>%	gsub(pattern =  "g", replacement =  "G") %>%	gsub(pattern =  "h", replacement =  "H") %>%	gsub(pattern =  "i", replacement =  "I") %>%	gsub(pattern =  "j", replacement =  "J") %>%	gsub(pattern =  "k", replacement =  "K") %>%	gsub(pattern =  "l", replacement =  "L") %>%	gsub(pattern =  "m", replacement =  "M") %>%	gsub(pattern =  "n", replacement =  "N") %>%	gsub(pattern =  "o", replacement =  "O") %>%	gsub(pattern =  "p", replacement =  "P") %>%	gsub(pattern =  "q", replacement =  "Q") %>%	gsub(pattern =  "r", replacement =  "R") %>%	gsub(pattern =  "s", replacement =  "S") %>%	gsub(pattern =  "t", replacement =  "T") %>%	gsub(pattern =  "u", replacement =  "U") %>%	gsub(pattern =  "v", replacement =  "V") %>%	gsub(pattern =  "w", replacement =  "W") %>% gsub(pattern =  "x", replacement =  "X") %>% gsub(pattern =  "y", replacement =  "Y")	%>% gsub(pattern =  "z", replacement =  "Z")
  }
FUNA_minusculas <-
  function(x) {
    gsub(replacement =  "a", pattern =  "A", x) %>%	gsub(replacement =  "b", pattern =  "B") %>% gsub(replacement =  "c", pattern =  "C") %>%	gsub(replacement =  "d", pattern =  "D") %>%	gsub(replacement =  "e", pattern =  "E") %>%	gsub(replacement =  "f", pattern =  "F") %>%	gsub(replacement =  "g", pattern =  "G") %>%	gsub(replacement =  "h", pattern =  "H") %>%	gsub(replacement =  "i", pattern =  "I") %>%	gsub(replacement =  "j", pattern =  "J") %>%	gsub(replacement =  "k", pattern =  "K") %>%	gsub(replacement =  "l", pattern =  "L") %>%	gsub(replacement =  "m", pattern =  "M") %>%	gsub(replacement =  "n", pattern =  "N") %>%	gsub(replacement =  "o", pattern =  "O") %>%	gsub(replacement =  "p", pattern =  "P") %>%	gsub(replacement =  "q", pattern =  "Q") %>%	gsub(replacement =  "r", pattern =  "R") %>%	gsub(replacement =  "s", pattern =  "S") %>%	gsub(replacement =  "t", pattern =  "T") %>%	gsub(replacement =  "u", pattern =  "U") %>%	gsub(replacement =  "v", pattern =  "V") %>%	gsub(replacement =  "w", pattern =  "W") %>%	gsub(replacement =  "x", pattern =  "X") %>% gsub(replacement =  "y", pattern =  "Y")	%>% gsub(replacement =  "z", pattern =  "Z")
  }
FUNA_numerosFormatados <-
  function(x, decimais = 0) {
    m <- x
    for (i in 1:nrow(m)) {
      for (j in 1:ncol(m)) {
        if (is.na(x[[i, j]]) == TRUE) {
          m[i, j] <- c("-")
        } else {
          if (is.numeric(x[[i, j]]) == TRUE) {
            m[i, j] <-
              format(
                round(x[[i, j]], digits = decimais),
                big.mark = ".",
                decimal.mark = ","
              )
          }
        }
      }
    }
    return(m)
  }

FUNA_ordenacao <-
  function(tabela, coluna) {
    as.data.frame(tabela)[order(as.data.frame(tabela)[, coluna], decreasing = TRUE),]
  }


FUNA_clipboard <- function(x, sep) {
  
  write.table(x = x, file = 'clipboard', sep = sep, dec = ",", row.names = FALSE)
  
}



# compatibilizar processo no formato sigmine p/ o formato Cadastro mineiro ----

FUNA_processo_sigmine_SCM <- function(df = df) {

df$processo <- NA
for (i in 1:nrow(df)) {
  if (str_count(df$processo[i]) == 3) {
    
    df$processo[i] <-
      paste(
        paste("000", df$processo[i], sep = "."), df$ano[i], sep = "/")
    
  }  else if (str_count(df$processo[i]) == 4) {
    df$processo[i] <-
      paste(paste(
        paste(
          "00",
          str_sub(
            df$processo[i],
            start = 1,
            end = 1
          ),
          sep = ""
        ),
        str_sub(
          df$processo[i],
          start = 2,
          end = 4
        ),
        sep = "."
      ),
      df$ano[i],
      sep = "/")
  } else if (str_count(df$processo[i]) == 5) {
    df$processo[i] <-
      paste(
        paste(
          paste(
            "0",
            str_sub(
              df$processo[i],
              start = 1,
              end = 2
            ),
            sep = ""
          ),
          str_sub(
            df$processo[i],
            start = 3,
            end = 5
          ),
          sep = "."
        ),
        df$ano[i],
        sep = "/"
      )
  } else {
    if (str_count(df$processo[i]) == 6) {
      df$processo[i] <-
        paste(
          paste(
            paste(
              str_sub(
                df$processo[i],
                start = 1,
                end = 3
              ),
              str_sub(
                df$processo[i],
                start = 4,
                end = 6
              ),
              sep = "."
            ),
            df$ano[i],
            sep = "/"))
    }}}
}