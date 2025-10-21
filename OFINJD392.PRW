Function OFINJD39_2()

    Local aSize     := FWGetDialogSize( oMainWnd )
	Local oDMSBrwStru
	Local oBrwJD39 
    Private oDpm        := OFJDRpmConfig():New()
    Private oArrHlp     := DMS_ArrayHelper():New()

    Pergunte("OFINJD39",.F.)//Carrego as MV_PAR's sem exibir a tela
     
    lRet := SetMVValue("OFINJD39","MV_PAR01", last12M()) //Atualizo o valor da terceira pergunta para a data de hoje
    
    If lRet
        Conout("Pergunte 1 atualizado corretamente")
    EndIf

    aFils := oArrHlp:Map(oDpm:GetFiliais(), {|aEl| aEl[1] })
	aadd(aFils, "TODAS") // TODAS

    lRet := SetMVValue("OFINJD39","MV_PAR02", aFils) //Atualizo o valor da terceira pergunta para a data de hoje
    
    If lRet
        Conout("Pergunte 2 atualizado corretamente")
    EndIf

    If !Pergunte('OFINJD39',.T.)
        Return 
    Else

    

	oDlgJD39 := MSDialog():New( aSize[1], aSize[2], aSize[3], aSize[4],STR0001, , , , nOr( WS_VISIBLE, WS_POPUP ), , , , , .T., , , , .F. ) //Painel Reservas

		oTPanJD39 := TPanel():New(0,0,"",oDlgOFC310,NIL,.T.,.F.,NIL,NIL,100,(oDlgOFC310:nClientHeight/4)-10,.F.,.F.)
		oTPanJD39:Align := CONTROL_ALIGN_TOP

		OFC310001I_ConfigBrowseVE6(@oDMSBrwStru)	
		oBrwJD39 := FWmBrowse():New()	
		oBrwJD39:SetOwner(oTPanJD39)
		oDMSBrwStru:SetBrwOwner(oBrwJD39)	
		oBrwJD39:SetTemporary(.T.)
		oBrwJD39:SetUseFilter( .T. )
		oBrwJD39:SetDescription(STR0002) //Consulta de itens reservados
		oBrwJD39:SetWalkThru(.F.)
		oBrwJD39:SetAmbiente(.F.)	
		oBrwJD39:AddLegend( 'B2_QATU == VE6_QTDITE' , 'BR_VERDE'    , STR0003 ) // "Sem divergência de itens entre o armazem de reserva e os itens reservados"
		oBrwJD39:AddLegend( 'B2_QATU <> VE6_QTDITE' , 'BR_VERMELHO' , STR0004 ) // "Divergência de quantidade de itens entre o armazem de reserva e os itens reservados"
		oBrwJD39:SetSeek(.T.,oDMSBrwStru:GetSeek())	
		oBrwJD39:SetFieldFilter(oDMSBrwStru:_aColFilter)	
		oBrwJD39:SetQueryIndex(oDMSBrwStru:_aIndex)	
		oBrwJD39:DisableDetails()	
		oDMSBrwStru:AddBrwColumn()	
		oBrwJD39:SetAlias(oDMSBrwStru:GetAlias())
		oBrwJD39:AddButton( STR0005 , { || OFC310005I_GeraExcelOFIC310() } ) //"Exportar para excel"
		oBrwJD39:Activate()

    oDlgOFC310:Activate( , , , , , , ) //ativa a janela
Return

/*/{Protheus.doc} last12M
    Retornar ultimos 12 meses em data e em array, todas no ultimo dia do mês

    @author Vinicius Gati
    @since  12/05/2016
/*/
Static Function last12M()
	aRegs := oSqlHlp:GetSelect({;
		{'campos', {"DATAEX"}},;
		{'query' , " SELECT DISTINCT DATAEX FROM MIL_DPM_CACHE_INVENTARIO WHERE D_E_L_E_T_ = ' ' AND FLAGP != ' ' ORDER BY DATAEX DESC "};
	})
Return oArrHlp:Map(aRegs, {|r| DTOC(STOD(r:GetValue('DATAEX'))) })
