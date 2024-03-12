/*   
Esta consulta corresponde ao item: Consumo e geração de energia
	Energia a partir de geração própria (kWh/ano)
	Energia a partir da aquisição de terceiros (kWh/ano)

Resultados p/ empreendimentos MINA: Usar Join à TB_Mina)
		   p/ empreendimentos USINA: Usar Join à TB_USINA	

As 2 variáveis ocorrem por 'AgrupamentoEmpreendimento'. 
por quais critérios se permite ao minerador agrupar empreendimentos?
(proximidade/substância?)

Atenção: a tabela TES não tem PK/FK, nem integridade referencial! Descrita como: 
	"Armazena os dados do relacionamento entre Empreendimento e Substância"
Esa consulta usa Join à TB_Mina 	
	
Constar Unidade geográfica pra fins de anonimização
*/


USE DBAMB
SELECT 
/* TB_BalancoEnergeticoAgrupamentoEmpreendimento as TBEAE */
 TBEAE.[QTConsumoGeracaoPropria]
,TBEAE.[QTConsumoGeracaoTerceiros]
,TBEAE.[NRAno]
,TBEAE.[IDAgrupamentoEmpreendimentoMatrizEnergetica] /*fk*/

/* TB_AgrupamentoEmpreendimentoMatrizEnergetica as Agrupamento as TAEME */
,TAEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica] /*pk*/
,TAEME.[IDRal] /*fk*/

/* TB_EmpreendimentoMatrizEnergetica as TEME */
,TEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica] /*fk*/
,TEME.[IDEmpreendimento] /*fk*/

/* ___________________ TB_Mina as TM */
					/* ,TM.[IDEmpreendimento] 
					,TM.[IDSubstancia] */

					
/* ___________________ TB_Usina as TU */
					,TU.[IDEmpreendimento]
					,TU.[IDMina]
					,TU.[IDMunicipio]
					,TU.[IDSubstanciaPrincipal]

/* TB_Empreendimento as TE */
,TE.[IDEmpreendimento] /*pk*/
,TE.[IDRal] /*fk*/
,TE.[NMEmpreendimento]
,TE.[DSLocalizacao]
,TE.[IDMunicipioPrincipal] /*fk*/

/* TB_Ral as TR */
,TR.[IDRal] /*PK*/
,TR.[IDAnoBaseRal]
,TR.[NRCpfCnpj]
,TR.[BTHabilitado]

/* TB_Titular as TT */
,TT.[IDTitular] /*pk*/
,TT.[IDRal]	/*fk*/
,TT.[NRCpfCnpj]
,TT.[NMTitular]
	
FROM [dbo].[TB_BalancoEnergeticoAgrupamentoEmpreendimento] as TBEAE

INNER JOIN [dbo].[TB_AgrupamentoEmpreendimentoMatrizEnergetica] as TAEME
	ON (TBEAE.[IDAgrupamentoEmpreendimentoMatrizEnergetica] = TAEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica])

INNER JOIN [dbo].[TB_EmpreendimentoMatrizEnergetica] as TEME
	ON (TAEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica] = TEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica])

/* ___________________ Join com TB_Mina as TM 
						INNER JOIN [dbo].[TB_Mina] as TM
							ON (TEME.[IDEmpreendimento] = TM.[IDEmpreendimento]) 
							
						INNER JOIN [dbo].[TB_Empreendimento] as TE
							ON (TM.[IDEmpreendimento] = TE.[IDEmpreendimento]) */

/* ___________________ Join com TB_Usina as TU */
						INNER JOIN [dbo].[TB_Usina] as TU
							ON (TEME.[IDEmpreendimento] = TU.[IDEmpreendimento])
														
						INNER JOIN [dbo].[TB_Empreendimento] as TE
							ON (TU.[IDEmpreendimento] = TE.[IDEmpreendimento]) 
	
	
INNER JOIN [dbo].[TB_Ral] as TR
	ON (TE.[IDRal] = TR.[IDRal])
	
INNER JOIN [dbo].[TB_Titular] as TT
	ON (TR.[IDRal] = TT.[IDRal])
	

/* condicoes */

WHERE /* TR.[IDAnoBaseRal] = '2021' */ 
TR.[BTHabilitado] = 1 /* Aceitando o RAL da caixa de entrada, habilita por cima do anterior */
AND 
TR.[IDAnoBaseRal] = 2021 







