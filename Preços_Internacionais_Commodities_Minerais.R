library(tidyverse)
library(lubridate)
options(editor = "notepad")


# Carregamento ----

prices_commodity_WB <- 
  read.table("./D_Lake/World_Bank_Commodity_Price_Data_(The Pink Sheet).csv", 
           header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE, encoding = "UTF-8")

prices_commodity_WB$month <- 
  lubridate::ym(prices_commodity_WB$month)

prices_commodity_WB$quarter <- 
  lubridate::quarter(prices_commodity_WB$month)

prices_commodity_WB$trimestre <- 
  paste("0", prices_commodity_WB$quarter, "TRIM", year(prices_commodity_WB$month), sep = "")

# ---------------------------------------------------------------------------

# unidades de medida ----
#($/mt);COAL_AUS
#($/mt);COAL_SAFRICA
#($/mt);PHOSROCK
#($/mt);POTASH
#($/mt);ALUMINUM
#($/dmtu);IRON_ORE
#($/mt);COPPER
#($/mt);LEAD
#($/mt);Tin
#($/mt);NICKEL
#($/mt);Zinc
#($/troyoz);GOLD
#($/troyoz);PLATINUM
#($/troyoz);SILVER


prices_commodity_WB_trimestre <-
  left_join(summarise(group_by(prices_commodity_WB, trimestre),"COAL_AUS" = mean(COAL_AUS)),
    left_join(summarise(group_by(prices_commodity_WB, trimestre),"COAL_SAFRICA" = mean(COAL_SAFRICA)),
      left_join(summarise(group_by(prices_commodity_WB, trimestre),"PHOSROCK" = mean(PHOSROCK)),
        left_join(summarise(group_by(prices_commodity_WB, trimestre), "POTASH" = mean(POTASH)),
          left_join(summarise(group_by(prices_commodity_WB, trimestre),"ALUMINUM" = mean(ALUMINUM)),
            left_join(summarise(group_by(prices_commodity_WB, trimestre),"IRON_ORE" = mean(IRON_ORE)),
              left_join(summarise(group_by(prices_commodity_WB, trimestre), "COPPER" = mean(COPPER)),
                        left_join(summarise(group_by(prices_commodity_WB, trimestre), "LEAD" = mean(LEAD)),
                  left_join(summarise(group_by(prices_commodity_WB, trimestre), "Tin" = mean(Tin)),
                    left_join(summarise(group_by(prices_commodity_WB, trimestre), "NICKEL" = mean(NICKEL)),
                      left_join(summarise(group_by(prices_commodity_WB, trimestre), "Zinc" = mean(Zinc)),
                        left_join(summarise(group_by(prices_commodity_WB, trimestre), "GOLD" = mean(GOLD)),
                          left_join(summarise(group_by(prices_commodity_WB, trimestre),"PLATINUM" = mean(PLATINUM)),
                            summarise(group_by(prices_commodity_WB, trimestre), "SILVER" = mean(SILVER)),
                            by = "trimestre"),by = "trimestre"),by = "trimestre"),by = "trimestre"),
                    by = "trimestre"),by = "trimestre"),by = "trimestre"),by = "trimestre"),
            by = "trimestre"),by = "trimestre"),by = "trimestre"),by = "trimestre"),by = "trimestre")






