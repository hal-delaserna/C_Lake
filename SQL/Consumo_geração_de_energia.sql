/* 
Esta consulta corresponde ao item: 
	"Se existir geração própria:
	     Tipo de geração (ver tabela)
	     Capacidade de geração instalada(kW)
	     Consumo (kWh/ano)"

Constar Unidade geográfica: fins de anonimização

Atenção! a tabela TES não tem PK/FK! Nem integridade referencial. Descrita como: "Armazena os dados do relacionamento entre Empreendimento e Substância"
*/

USE DBAMB
SELECT
/* TB_GeracaoEnergiaPropriaAgrupamentoEmpreendimento as TGEPAE */
 TGEPAE.[IDAgrupamentoEmpreendimentoMatrizEnergetica]    /*pk*/
,TGEPAE.[QTCapacidadeGeracaoInstalada]	 
,TGEPAE.[QTConsumo]
,TGEPAE.[IDOrigemEnergia]  /*fk*/


/* TB_OrigemEnergia as TO */
,TOr.[IDOrigemEnergia] /*pk*/
,TOr.[DSOrigemEnergia]

/* TB_AgrupamentoEmpreendimentoMatrizEnergetica as Agrupamento as TAEME */
,TAEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica] /*pk*/
,TAEME.[IDRal] /*fk*/

/* TB_EmpreendimentoMatrizEnergetica as TEME */
,TEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica] /*fk*/
,TEME.[IDEmpreendimento] /*fk*/

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

											
											/* TB_EmpreendimentoSubstancia as TES */
											/* Tabela TES não tem integridade referencial! 
											 * mas tem informações que somente constam nela */
											,TES.[IDEmpreendimento] /*fk*/
											,TES.[IDRal] /*fk*/
											,TES.[IDTitular] /*k*/
											,TES.[DSTipoEmpreendimento] /* ALVO */
											,TES.[DSEmpreendimento]
											,TES.[DSMunicipio] /* ALVO */
											,TES.[SGEstado] /* ALVO */
											,TES.[SGRegiao]  /* ALVO */
											,TES.[NMSubstanciasRAL]
											,TES.[DSMinerioPrincipal]
											,TES.[NMSubstanciasAMB]
											,TES.[DSSubstanciaAgrupadora]
											,TES.[DSSubstanciaAMBPrincipal]
											,TES.[DSSubstanciaRALPrincipal]
											

FROM [dbo].[TB_GeracaoEnergiaPropriaAgrupamentoEmpreendimento] AS TGEPAE

	
INNER JOIN [dbo].[TB_OrigemEnergia] as TOr
	ON (TGEPAE.[IDOrigemEnergia] = TOr.[IDOrigemEnergia])


INNER JOIN [dbo].[TB_AgrupamentoEmpreendimentoMatrizEnergetica] as TAEME
	ON (TGEPAE.[IDAgrupamentoEmpreendimentoMatrizEnergetica] = TAEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica])

INNER JOIN [dbo].[TB_EmpreendimentoMatrizEnergetica] as TEME
	ON (TAEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica] = TEME.[IDAgrupamentoEmpreendimentoMatrizEnergetica])

INNER JOIN [dbo].[TB_Empreendimento] as TE
	ON (TEME.[IDEmpreendimento] = TE.[IDEmpreendimento])

INNER JOIN [dbo].[TB_Ral] as TR
	ON (TE.[IDRal] = TR.[IDRal])
	
INNER JOIN [dbo].[TB_Titular] as TT
	ON (TR.[IDRal] = TT.[IDRal])
	
LEFT JOIN [dbo].[TB_EmpreendimentoSubstancia] as TES
	ON (TE.[IDEmpreendimento] = TES.[IDEmpreendimento])

/* condicoes */

WHERE /* TR.[IDAnoBaseRal] = '2021' */ 
TR.[BTHabilitado] = 1 /* Aceitando o RAL da caixa de entrada, habilita por cima do anterior */
AND 
TR.[IDAnoBaseRal] = 2021 







