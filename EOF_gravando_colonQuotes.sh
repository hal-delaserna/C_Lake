#!/bin/bash

sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Licenciamento.csv  
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Guia_de_Utilizacao_Autorizada.csv  
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   PLG.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Portaria_de_Lavra.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Registro_de_Extracao_Publicado.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Relatorio_de_Pesquisa_Aprovado.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Requerimento_de_Lavra.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Requerimento_de_Licenciamento.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Requerimento_de_PLG.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Requerimento_de_Pesquisa.csv
sed -i  's/","/@/g  ;   s/^"/#/g  ;   s/"\r/#/g  ;  s/"/'\''/g   ;  s/@/","/g  ;   s/#/"/g   '   Requerimento_de_Registro_de_Extracao_Protocolizado.csv