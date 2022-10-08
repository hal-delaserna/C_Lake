

cbo <-
  read.table(
    file = "~/D_Lake/CBO2002 - Ocupacao.csv",
    sep = ";",
    stringsAsFactors = FALSE,
    header = TRUE,
    colClasses = "character",
    encoding = 'ANSI',
    quote = ""
  )