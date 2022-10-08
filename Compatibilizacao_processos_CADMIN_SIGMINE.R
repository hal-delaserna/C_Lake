# compatibilizar processo no formato sigmine p/ o formato Cadastro mineiro ----


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
