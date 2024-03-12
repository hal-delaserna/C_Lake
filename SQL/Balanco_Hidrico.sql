/* Esta consulta refere-se ao item: BALANÇO HÍDRICO:
                Água nova de Captação própria (m³/ano)
                Água nova adquirida de terceiros (m³/ano)
                Água necessária ao empreendimento (m³/ano)
                Água tratada devolvida ao meio ambiente (m³/ano)
                Taxa de reusos de água para o processo produtivo (%)
                Perdas totais (%) 

A tabela TB_EmpreendimentoSubstancia não tem integridade referencial com as demais.

*/

USE  DBAMB   
SELECT 
/* TB_BalancoAguaAgrupamentoEmpreendimento as TBAAE */
     TBAAE.[QTAgua]
    ,TBAAE.[IDAgrupamentoEmpreendimentoBalancoHidrico] /*fk*/
    ,TBAAE.[NRAno]
    ,TBAAE.[IDTipoBalancoAgua]      /*fk*/

/* TB_AgrupamentoEmpreendimentoBalancoHidrico as TAEBH */
    ,TAEBH.[IDAgrupamentoEmpreendimentoBalancoHidrico]  /* pk */
    ,TAEBH.[IDRal] /* fk */
    ,TAEBH.[NMBaciaHidrografica]
    ,TAEBH.[NMRioCaptacaoLancamentoEfluentes]

/* TB_TipoBalancoAgua as TTBA */
    ,TTBA.[DSTipoBalancoAgua]
    ,TTBA.[IDTipoBalancoAgua]   /*pk*/

/* TB_EmpreendimentoBalancoHidrico as TEBH */
    ,TEBH.[IDAgrupamentoEmpreendimentoBalancoHidrico]
    ,TEBH.[IDEmpreendimento]

/* TB_Empreendimento as TE */
    ,TE.[IDEmpreendimento] /*pk*/
    ,TE.[NMEmpreendimento]
    ,TE.[IDRal]  /*fk*/
    ,TE.[IDMunicipioPrincipal]
    ,TE.[DSLocalizacao]
    
/* TB_Ral as TR */
    ,TR.[IDRal] /*pk*/
    ,TR.[BTHabilitado]
    ,TR.[IDAnoBaseRal]
    ,TR.[NRCpfCnpj]
   
/* TB_EmpreendimentoSubstancia as TES */
	,TES.[DSTipoEmpreendimento]
	,TES.[DSEmpreendimento]
	,TES.[DSMinerioPrincipal]
	,TES.[DSMunicipio]
	,TES.[DSRegiao]
	,TES.[DSSubstanciaAgrupadora]
	,TES.[DSSubstanciaAMBPrincipal]
	,TES.[DSSubstanciaRALPrincipal]
	,TES.[IDAnoBaseRal]
	,TES.[IDEmpreendimento]
	,TES.[IDRal]
	,TES.[NMSubstanciasAMB]
	,TES.[NMSubstanciasRAL]
	,TES.[SGEstado]
	,TES.[SGRegiao]
	,TES.[IDTipoEmpreendimento]
	
/* TB_Titular as TT */
	,TT.[IDRal]
	/*,TT.[NMTitular]*/ /*char*/
	,TT.[NRCpfCnpj]


FROM [dbo].[TB_BalancoAguaAgrupamentoEmpreendimento] AS TBAAE

INNER JOIN [dbo].[TB_AgrupamentoEmpreendimentoBalancoHidrico] as TAEBH
	ON (TBAAE.[IDAgrupamentoEmpreendimentoBalancoHidrico] = TAEBH.[IDAgrupamentoEmpreendimentoBalancoHidrico])

INNER JOIN [dbo].[TB_TipoBalancoAgua] as TTBA
	ON (TBAAE.[IDTipoBalancoAgua] = TTBA.[IDTipoBalancoAgua])
	
INNER JOIN [dbo].[TB_EmpreendimentoBalancoHidrico] as TEBH
	ON (TBAAE.[IDAgrupamentoEmpreendimentoBalancoHidrico] = TEBH.[IDAgrupamentoEmpreendimentoBalancoHidrico])
	
INNER JOIN [dbo].[TB_Empreendimento] as TE
	ON (TEBH.[IDEmpreendimento] = TE.[IDEmpreendimento])

INNER JOIN [dbo].[TB_Ral] as TR
	ON (TE.[IDRal] = TR.[IDRal])

INNER JOIN [dbo].[TB_EmpreendimentoSubstancia] as TES
	ON (TEBH.[IDEmpreendimento] = TES.[IDEmpreendimento])
	
INNER JOIN [dbo].[TB_Titular] as TT
	ON (TR.[IDRal] = TT.[IDRal])
	
	
/* condicoes */

WHERE /* TR.[IDAnoBaseRal] = '2021' */ 
TR.[BTHabilitado] = 1 /* Aceitando o RAL da caixa de entrada, habilita por cima do anterior */
AND TBAAE.[NRAno] = 2021 



























