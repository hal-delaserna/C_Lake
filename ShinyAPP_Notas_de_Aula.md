<script src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' async></script>
<style> body {background: ivory; font-size: small;}  p, li {color: #333333}  table {align-self: center; } .markdown-body h1 {color: darkslateblue; border-bottom: 5px solid darkslateblue;} .markdown-body h2 {color: darkslateblue; border-bottom: 4px solid darkslateblue;} .markdown-body h3 {color: darkslateblue; border-bottom: 3px solid darkslateblue;} .markdown-body h4 {color: darkslateblue; border-bottom: 2px solid darkslateblue;} .markdown-body h5 {color: darkslateblue; border-bottom: 1px solid darkslateblue;} .markdown-body h6 {color: darkslateblue; margin-bottom: 1px} .markdown-body blockquote {background-color: antiquewhite; margin-left: 80px; margin-right: 20px; border-left-color: antiquewhite;} .markdown-body hr {background-color: darkslateblue; height: 2px;} </style>

# Shiny App


- [Vídeos das aulas](https://classroom.google.com/c/MzA3NjQ0NzY3NDY0)
- [Pasta local](/home/hal/Documentos/ShinyDashboards)  
- [curso-r.github.io/dashboards](https://curso-r.github.io/202105-dashboards/)
- [HUGO framework for building websites](https://gohugo.io/)  
- [***blogdown***](https://bookdown.org/yihui/blogdown/) Creating Websites with R Markdown


## Aula 1

Funções e renderizdor para fazer aplicativos no R  

Funções Shiny são estruturas que transformam comandos do R em trechos de html/css/javascript. Programar com Shiny tem o benefício de nos liberar da preocupação pormenorizada cos itens de *layout*. Claro que uma vez que temos o aplicativo pronto, nada impede fazermos intervenções de estilo e *layout* nos arquivos CSS.  

Num aplicativo Shiny programamos num no mesmo arquivo código do *server side* e do *user side*.  

#### User Side

É onde diagramamos o itens de *layout* bem como menus, abas, itens gráficos (mapas, imagens, gráficos, etc.), além de textos, formulários, etc  

+ Layout mais elementar:  

> 		ui <- fixedPage(...)  


+ Linhas com 12 colunas "fluídas". Dimensionam seus componentes dinamicamente para preencher toda a largura do navegador:  

> 		ui <- fluidPage(...)    


+ Barra com abas no topo da página:  

> 		ui <- navbarPage(...)      


+ Cria um menu lateral com linhas onde podemos planejar formulários de consulta ao dashboard:   

> 		ui <- dashboardPage(...)   

Outros layouts: fillPage(), flowLayout(), sidebarLayout(), splitLayout(), verticalLayout()    


Pra visualizarmos a parcial do *input* executamos o snippet `shinyApp(ui)`  sem preencher o atributo para *server*.   


No *ui* inserimos elementos visuais e de interação ao usuário. Podemo ser elementos de *input* (formulários, botões, etc.) ou de *output* (gráficos, tabelas, mapas, etc.):  

- Caixa de seleção: `selectInput(inputID, label, choices, ...)`  

- Gráfico: `plotOutput(outputID, ...)`  

- Tabela: `tableOutput(outputID, ...)`

- [Galeria com Inputs Shiny](https://shiny.rstudio.com/gallery/widget-gallery.html)   

- [Galeria com Outputs Shiny](https://shiny.rstudio.com/gallery/widget-gallery.html)  



#### Server Side

É onde incluimos funções de renderização dos elementos gráficos, transformações nos dados, comandos de procura e *subsetting*, etc.

 Funções *render*

- `renderPlot(outputID)`
- `renderTable(outputID)`
- `renderText(outputID)`


***bs4dash::*** : pacote para Bootstrap

***shinydashboard::*** pacote com templates


## Aula 2


Deploy no ShinyApp.io............1:10:00

#### Reatividade

- Paradigmas de programação: Imperativa x Declarativa ("sequencial"; "ñ sequencial")  

Quando planejamos **reatividade** poupamos processamento desnecessário do servidor pois as computações passam a depender de ações do usuário (não se cria outputs desnecessários).  

- **Diagrama de Reatividade**. O fluxo de reatividade é formado por:
	- valores reativos
	- expressões reativas
	- observers (ex. função *renderPlot*, etc)

Só existe *reatividade* quando começa com um *valor reativo* e termina com um *observer* (*fluxo de reatividade*)  

*valores reativos* mais comuns são os que colocamos na lista `input$`  

**Expressões reativas**: uma estrutura que recebe um *valor reativo*, aplica uma operação/transformação, e entrega o novo valor ao *observer*. Usando `reactive({})` ou usando `eventReactive({})`  

Melhor usar o `reactive({})` para transformações complexas (pq calculará uma única vez?)   

Obs: Objeto criado dentro de uma função reativa, não será compartilhado fora da função   

**Fluxo de reatividade:** Do *valor reativo* ao *observer*. O servidor não calcula um `reactive({})` não ligado a um *observer* (Ex de observer: `renderText()`)  


## Aula 3  


Há vezes que não se deseja pronta vizualização de um output após atualizarmos um campo. Usamos `eventReactive({})` quando a reatividade só deve ocorrer após um comando do usuário: Ex. Preencher caixas/botões de seleção e só atualizar o gráfico após darmos um botão "OK"   

*eventReactive()* especifica um comando que dispara a reatividade. No *reactive()* basta atualizar o *valor reativo*.   
*eventReactive()* é muito útil em formulários: ex. somente o botão "enviar" disparará reatividade   
Servem para *expressões reativas* intermediárias pré output  


>		saudacao <-   
>			eventReactive(input$botao, {   
>			"Olá meu nome é {input$nome}!"  
>			})  


Também se obtém idêntico resultado usando a função `isolate()`.  

>		saudacao <-    
>			Reactive({  
>				nome <- isolate(input$nome)  
>				input$botao   
>			"Olá meu nome é {input$nome}!"   
>			})  


[Filtros hierárquicos: aula anterior disse que falaria nessa]   

*UX: experiência do usuário (ou "o usuário não sabe disso"). Decisões do desenvolvedor devem envolver expectativas/percepções do usuário*   

Podemos vizualizar o *fluxo de reatividade* com `ctrl + F3` (deve-se setar `options(shiny.reactlog = TRUE)` )  

Observando a reatividade no console:  
>     observeEvent(input$name, {  
>       print("Greeting performed")  
>       })


###### corrigndo erros (debug)
	+ *Browser()* é uma maneira de debugar o código
	+ erros de sintaxe não retornam mensagens do R. Mas erros default do navegador
	+ expressão reativa dentro de um contexto reativo

Dica: `isTruthy()` verifica se uma expressão é válida no Shiny  

###### Arquitetura de um Servidor Shiny (2:20:00)
Um servidor pode ser configurado para abrir novas instâncias com processamento dedicado a cada novo grupo de usuários. É uma forma de preservar processamento ante uma previsão/planejamento de acessos.  Uma instância com muitos usuários gerará fila por processamento.  

> Aplicação > Instância (máquinas virtual?) > Worker (sessão R) > conexões (usuários)  

Também se deve planejar a leitura da base de dados. Se colocamos o `readRDS()` antes da antes `ui <- fluidPage({... })`  a base será lida prévia à criação de cada instância. Nesse caso os usuários dessa instância compartilharão a mesma base; Se colocarmos `readRDS()`dentro do `server <- function({...})` a importação da base ocorrerá para cada usuário.  [essa última deve conferir vantagens de reatividade mas a custa de mais espaço em RAM?]

Ainda, se desejarmos atualização em tempo real, não apenas colocamos a base dentro do `server <- ` como também dentro do `eventReactive()`  



***Plotly***: gráficos com interativiadde (pesados entretanto)

#### Bootstrap (introdução)  
*3:10:00*  
Conjunto de regras CSS para fins de responsividade ao tamanho da tela.


Ex. o boostrap framework do Twitter segue o sistema de grid  


## Aula 4

####Bootstrap (continuação)

É um conjunto de regras CSS  

*fluidrow()* para criar linhas  
*column(width = a, offset = b)* criar colunas dentro das linhas


Pacote ***fresh::*** para cores de layout, css

https://dgranjon.shinyapps.io/bs4DashDemo/

Painel lateral:   

>     sidebarLayout(
>       sidebarPanel =     ,
>       mainPanel = )

##### Barra superior com abas:  

>      navbarPage(  
>        title = "Shiny com barra superior",  
>        tabPanel(title = "texto na aba 1",  
>                 h2('Título da Tela 1')),  
>        tabPanel(title = "texto na aba 2",  
>                 h2('Título da Tela 2')),  
>        tabPanel(title = "texto na aba 3",  
>                 h2('Título da Tela 3'))  
>      )  


##### Barra de menu:  

>      navbarMenu(  
>        title = "Shiny com barra superior",  
>        tabPanel(title = "texto na aba 1",  
>                 h2('Título da Tela 1')),  
>        tabPanel(title = "texto na aba 2",  
>                 h2('Título da Tela 2')),  
>        tabPanel(title = "texto na aba 3",  
>                 h2('Título da Tela 3'))  
>      )  

 No navbarPage os inputs criados numa aba ficam disponíveis para demais abas

#####    DASHBOARDS

pacote ***shinydashboard::***  


>       dashboardPage(  
>           dashboardHeader(),  
>           dashboardSidebar(),  
>           dashboardBody()  
>                          )  


com `sidebarMenu()` dentro de `dashboardSidebar()` cria-se um menu na vertical.



**CSS:** as vezes é necessáro colocar o *custom.css* dentro de uma pasta chamada `'WWW'`

`href = www/custom.css`  


###### Reativiadde (parte 2)


função *observe()*

função *isolate()*




## Aula 5

Nessa aula veremos *Observers* que não são funções *render()*

JavaScript no R com ***htmlwidgets::***

`PickerInput()` do **ShinyWidgets::** É um `SelectInput()` turbinado  


O `infoBoxOutput()` é uma função que já cria um elemento da classe coluna (*Bootstrap*). Por isso não devemos colocar InfoBox dentro de colunas (não podemos colocar uma coluna dentro da outra sem uma linha entre elas. Bagunçaria as margens). 

#### Tabelas

***rhandsomtable::*** e ***DT::*** são pacotes que permitem ao usuário inserir valores com JavaScript

#### Gráficos 
***Plotly::*** gráficos pesados, ruim com muitos pontos/elementos. Tem interatividade

***highcharts::*** 
	os gráficos mais bonitos estão aqui (efeitos smooth). Muito rápido. Mas é fresco pra fazer deploy. (Pra uso corporativo/governo, tem que pagar).

#### mapas
	
***tmap::***, ***highcharter::***, ***echarts::***


Uma boa prática: layout do `infoBox()` na UI; manipulação dos dados, no server.



### Layouts


**fluidpage()** / **fluidRow()**


>      fluidPage(fluidRow(  
>       column(offset =
>                width = ),
>       column(offset =
>                width = ),
>          (...)
>       column(offset =
>                width = )
>     )
>           (...)
>     fluidRow(
>       column(offset =
>                width = ),
>       column(offset =
>                width = ),
>          (...)
>       column(offset =
>                width = )
>     ))




**navbarPage()**



**sidebarLayout()**


>      fluidPage(
>       sidebarLayout(
>         mainPanel = 
>         sidebarPanel = )
>     )




**shinydashBoard()**



#### Itens de Layout


**navbarMenu()**




[Guia Rstudio de Layout](https://shiny.rstudio.com/articles/layout-guide.html)  


#### Pacotes

***shinycssloaders::***  animações pré-carregamento



[início](#shiny-app)  


