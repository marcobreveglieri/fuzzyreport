{ *******************************************
  *             FuzzyReport 2.0             *
  *                                         *
  *  Copyright (c) 2000 by Fabio Dell'Aria  *
  *                                         *
  *-----------------------------------------*
  * For to use this source code, you must   *
  * read and agree all license conditions.  *
  ******************************************* }

unit FR_Const;

interface

{$I FR_Vers.inc}

Uses messages;

Const
  // Generic consts...
  // -------------------------
  // Numeric consts...
  MoneyToEuro: Extended = 1.00; // Conversione do Money locale ad Euro.
  DefaultUnit = 1; // mm
  FctStdCnt = 43; // Standard functions count
  PaperCount = 67; // Paper count.
  frSpecCount = 9; // Other values count (N. page / Total page / ...)

  // Alphanumeric consts...
  FRConst_ReportName = 'FuzzyReport';
  //
  FRConst_AssignNameError = 'Duplicate name !';
  FRConst_GeneralError = 'General Error !';
  FRConst_NameError = 'Name format error !';
  FRConst_ErrorOpenDataSet = 'Open in error ! Dataset:';
  FRConst_DataSetClose = 'Dataset closed !';
  FRConst_DataSetError = 'Dataset non assigned !';
  FRConst_FilterError = 'Filter of band, error in expression ! ';
  FRConst_ErrateParentersNum =
    'Wrong number of parentheses in the expression: ';
  FRConst_UnknownIdentifier = 'Unknown identifier !';
  FRConst_IncompatDataType = 'Incompatible data type expression !';
  FRConst_ErrorLoadfrDataSet = 'frDataset not found:';
  FRConst_Attenction = 'attention';
  FRConst_ErrorInFormat = 'It was not possible to terminate the phase ' +
    'loading reports.' + #10#13 +
    'Probably the report is corrupted, or contains ' +
    'components not included within the project.';
  FRConst_DirLoadError = 'You tried to load the report "%s" from a ' +
    'folder not valid and ' + #13#10 + ' it is not possible ' +
    'load the report folder only: ';
  FRConst_NoLoadReport = 'You tried to load from disk the report ''%s''. ' +
    #13#10 + 'but the file ''%s'' does not exist !';
  FRConst_DirSaveError = 'You tried to save the report "%s" in a ' +
    'not valid folder.' + #13#10 + 'It is possible ' +
    'save the report in folder: ';
  FRConst_SaveError = 'There was an error during the  ' + 'saving of report';
  FRConst_PreviewCaption = 'Preview';
  FRConst_OpenBtnCaption = '&Open';
  FRConst_OpenBtnHint = 'Open report';
  FRConst_SaveBtnCaption = 'Sa&ve';
  FRConst_SaveBtnHint = 'Save report';
  FRConst_PrintBtnCaption = '&Print';
  FRConst_PrintBtnHint = 'Print report';
  FRConst_FindBtnCaption = '&Find';
  FRConst_FindBtnHint = 'Find text';
  FRConst_CloseBtnCaption = '&Close';
  FRConst_CloseBtnHint = 'Close report';
  FRConst_Page = 'Page';
  // *** Gio *** dichiarazioni nuove costanti (04/08/2005)
  FRConst_PageSeparator = ' / ';
  FRConst_FirstBtnHint = 'First page';
  FRConst_LastBtnHint = 'Last page';
  // *** Gio *** fine modifica (04/08/2005)
  FRConst_PrevBtnHint = 'Previous page';
  FRConst_NextBtnHint = 'Next page';
  FRConst_ZoomBtnHint = 'Enlargement';
  FRConst_ZoomWidth = 'width';
  FRConst_ZoomOnePage = 'One page';
  FRConst_ZoomTwoPages = 'two pages';
  FRConst_OpenDiatogTitle = 'Open report.';
  FRConst_OpenDiatogFilter = 'Report files (*.frp)|*.frp';
  FRConst_SaveDiatogTitle = 'Save report.';
  FRConst_SaveDiatogFilter = 'Report file (*.frp)|*.frp';
  FRConst_FindTextCaption = 'Find text.';
  FRConst_FindLabelCaption = 'Text to find';
  FRConst_FindOptionsCaption = 'Options';
  FRConst_FindCaseCaption = 'Upper/LowerCase';
  FRConst_FindSubCaption = 'Part of a word';
  FRConst_FindOriginCaption = 'Origin';
  FRConst_FindFirstPageCaption = 'First page';
  FRConst_FindCurrentPageCaption = 'Current page';
  FRConst_FindNextCaption = 'Next';
  FRConst_FindPreviousCaption = 'Previous';
  FRConst_OK = '&OK';
  FRConst_Cancel = '&Cancel';
  FRConst_DB = '&DB Field';
  FRConst_Var = '&Variabble';
  FRConst_Exp = '&Expression';
  FRConst_FindError = ' We could not find any element that ' +
    'satisfies the request .';
  FRConst_FindTitle = 'Messagge.';
  FRConst_FormFtlrCaption = 'Export...';
  FRConst_FormFtlrBtnCaption = 'Cancel';
  FRConst_PrmEditCaption = 'Parameters editor';
  FRConst_AlignFormCaption = 'Alignment';
  FRConst_AlignFormHint0 = 'Align the left edge';
  FRConst_AlignFormHint1 = 'Horizontally centering';
  FRConst_AlignFormHint2 = 'Center horizontally in window';
  FRConst_AlignFormHint3 = 'Horizontally uniform spaces';
  FRConst_AlignFormHint4 = 'Align the right edge';
  FRConst_AlignFormHint5 = 'Align Top';
  FRConst_AlignFormHint6 = 'Align vertically centering';
  FRConst_AlignFormHint7 = 'Center Vertically in Window';
  FRConst_AlignFormHint8 = 'Vertically uniform spaces';
  FRConst_AlignFormHint9 = 'Align Bottom';
  FRConst_BndEdCaption = 'Source of data band';
  FRConst_BndEdLabelCaption1 = 'Source of data';
  FRConst_BndEdLabelCaption2 = 'Start';
  FRConst_BndEdLabelCaption3 = 'End';
  FRConst_BndEdLabelCaption4 = 'Number';
  FRConst_BndEdComboBoxItems1 = 'First item'#13#10'Current item';
  FRConst_BndEdComboBoxItems2 = 'Last item'#13#10'Current item' + #13#10 +
    'Elements';
  FRConst_BndEdBitBtnHint = 'Displays the name of frDataset';
  FRConst_BndEdGrpFilterCaption = 'Filter';
  FRConst_BndEdLabelCaption5 = 'Filter';
  FRConst_BndEdActiveFiltCaption = 'Filter on';
  FRConst_NotAssigned = '[No One]';
  FRConst_VirtualDataSet = '[Virtual data source]';
  FRConst_NofrDataset = 'It has not been assigned any frDataset';
  FRConst_frDatasetName = 'The name of current frDataset:';
  FRConst_Information = 'Informations';
  FRConst_BandTypeCaption = 'New band';
  FRConst_BandTypeGBCaption = 'Band type';
  FRConst_CodeBarreCaption = 'BarCode';
  FRConst_CodeBarreLabelCaption1 = 'Text';
  FRConst_CodeBarreLabelCaption2 = 'Code type';
  FRConst_CodeBarreLabelCaption3 = 'Scale factor';
  FRConst_CodeBarreOptiCaption = 'Options';
  FRConst_CodeBarreckCheckCapt = 'Calculate the control code';
  FRConst_CodeBarreckViewTxtCapt = 'View the text';
  FRConst_CodeBarreckShChkTxtCap = 'Display the control code';
  FRConst_CodeBarreInstall = 'Insert BarCode';
  FRConst_InternalError = '%s: Internal error';
  FRConst_NumericBarCode = 'The bar code must be numeric';
  FRConst_WrongBarcodeType = '%s: Type of BarCode incorrect';
  FRConst_InvalidTextlen = 'Length of the text wrong';
  FRConst_CodebadData39 = '%s: Code93 incorrect Data <%s>';
  FRConst_ColorNone = 'No one';
  FRConst_ColorOther = 'Other ....';
  FRConst_DocOptFormCaption = 'Report options';
  FRConst_DocOptFormGroupBoxCap2 = 'Other';
  FRConst_DocOptFormCBCaption2 = 'Report in two phases';
  FRConst_DocOptFormCBCaption3 = 'Collate multi-page reports';
  FRConst_DocOptFormCBCaption4 = 'Reparagraph pages collated';
  FRConst_EditorFormCaption = 'Text editor';
  FRConst_EditorFormBitBtn1 = '&Format';
  FRConst_EditorFormBitBtn2 = '&Highlight';
  FRConst_RichFltFormCaption = 'Export to RTF format.';
  FRConst_RichFltFrmGroupCaption = 'Options';
  FRConst_RichFltFrmPageBrkCapt = 'Page break';
  FRConst_RichFltFrmKeepLinCapt = 'Delete slugs';
  FRConst_RichFltFrmLabelCapt1 = 'Left Margin (mm)';
  FRConst_RichFltFrmLabelCapt2 = 'Right Margin (mm)';
  FRConst_RichFltFrmLabelCapt3 = 'Top Margin (mm)';
  FRConst_RichFltFrmLabelCapt4 = 'Bottom Margin (mm)';
  FRConst_RichFile = 'File RTF -';
  FRConst_TxtFltFrmCaption = 'Export in text format.';
  FRConst_PdfFltFrmCaption = 'Export in Pdf format.';
  FRConst_TxtFltFrmGroupCaption = 'Options';
  FRConst_TxtFltFrmLabelCapt1 = 'Number of columns';
  FRConst_TxtFltFrmPageBrkCapt = 'Page break';
  FRConst_TxtFltFrmTopMargCapt = 'Top Margin';
  FRConst_TxtFltFrmBotMargCapt = 'Bottom Margin';
  FRConst_TxtFltFrmLeftMargCapt = 'Left Margin';
  FRConst_TextFile = 'ASCII Text File';
  FRConst_EvFrmCaption = 'Varibles editor';
  FRConst_EvFrmLabelCaption1 = 'Variables';
  FRConst_EvFrmLabelCaption2 = 'Value';
  FRConst_EvFrmLabelCaption3 = 'Expression';
  FRConst_EvFrmNewCategoryHint = 'New category';
  FRConst_EvFrmNewvariableHint = 'New variable';
  FRConst_EvFrmDeleteItemHint = 'Delete item';
  FRConst_EvFrmModifyItemHint = 'Update item';
  FRConst_SpecVal = 'Other';
  FRConst_VarName = 'Variable';
  FRConst_CatName = 'Category';
  FRConst_ItemDelete = 'Delete the selected item ?';
  FRConst_FieldsFormCaption = 'Insert DB field';
  FRConst_FieldsFormLabelCapt1 = 'Available DB';
  FRConst_FrmdMemoFrmCaption = 'Text editor';
  FRConst_FrmdMemoFrmGroupBoxCap = 'edges';
  FRConst_FrmdMemoFrmLabelCap1 = 'Right';
  FRConst_FrmdMemoFrmLabelCap2 = 'Left';
  FRConst_FrmdMemoFrmLabelCap3 = 'Bottom';
  FRConst_FrmdMemoFrmLabelCap4 = 'Upper';
  FRConst_InsFMemo = 'Enter the rectangle bordered';
  FRConst_GEditorFormCaption = 'Image';
  FRConst_GEditorFormButtonCapt3 = '&Load...';
  FRConst_GEditorFormButtonCapt4 = '&Empty';
  FRConst_PictFile = 'Image File';
  FRConst_AllFiles = 'All files';
  FRConst_PictOpenFile = 'Load image';
  FRConst_FrGrpEditCaption = 'Chart Options';
  FRConst_FrGrpEditSlctDSCaption = 'Data source';
  FRConst_FrGrpEditGNewHint = 'Insert new field';
  FRConst_FrGrpEditGDelHint = 'Delete current field';
  FRConst_FrGrpEditGModHint = 'Update current field';
  FRConst_FrGrpEditLabelCaption1 = 'X-axis Title';
  FRConst_FrGrpEditLabelCaption2 = 'Y-Axis Title';
  FRConst_FrGrpEditLabelCaption3 = 'Graphic title';
  FRConst_FrGrpEditLabelCaption4 = 'Fields title';
  FRConst_FrGrpEditCheckBoxCapt1 = 'See the legend';
  FRConst_FrGrpEditCheckBoxCapt2 = 'View the chart title';
  FRConst_FrGrpEditCheckBoxCapt3 = 'Displays the title of the X-Axis';
  FRConst_FrGrpEditCheckBoxCapt4 = 'Displays the title of the Y-Axis';
  FRConst_FrGrpEditOptionsCapt = 'Options';
  FRConst_FrGrpEditComboBoxItms1 =
    'Histograms'#13#10'Histograms and Lines'#13#10
    + 'Triangles'#13#10'Triangles and Lines'#13#10 +
    'Points'#13#10'Points and Lines'#13#10'Lines';
  FRConst_FrGrpEditComboBoxItms2 =

    '[1] - €'#13#10'[2] - Euro'#13#10'[3] - '
    + 'Number (1,00)'#13#10'[4] - Number (1,00)' +
    #13#10'[5] - Number (1,0)'#13#10'[6] - Number' +
    ' (1,00)'#13#10'[7] - Number (1)';



  FRConst_FrGrpEditLabelCaption5 = 'Chart Types';
  FRConst_FrGrpEditLabelCaption6 = 'Format y-Axis';
  FRConst_FrGrpInsGrph = 'Insert Chart';
  FRConst_GraphFieldsTitle: array [0 .. 2] of string = ('Value', 'Color',
    'Legend');
  FRConst_GrphFldEditCaption = 'Field options';
  FRConst_GrphFldEditLabelCapt1 = 'Value of field';
  FRConst_GrphFldEditLabelCapt2 = 'Legend of field';
  FRConst_GrphFldEditButtonCapt1 = 'Color of field';
  FRConst_GroupEditFormCaption = 'Group';
  FRConst_GroupEditFormLabelCap1 = 'Condition';
  FRConst_HlghtFrmCaption = 'highlighting attributes';
  FRConst_HlghtFrmGroupBoxCapt1 = 'Font';
  FRConst_HlghtFrmSpeedBtnCapt1 = 'Color...';
  FRConst_HlghtFrmCBCaption1 = 'Bold';
  FRConst_HlghtFrmCBCaption2 = 'Italic';
  FRConst_HlghtFrmCBCaption3 = 'Underline';
  FRConst_HlghtFrmGroupBoxCapt2 = 'Background';
  FRConst_HlghtFrmSpeedBtnCapt2 = 'Color...';
  FRConst_HlghtFrmRBCaption1 = 'Transparent';
  FRConst_HlghtFrmRBCaption2 = 'Other';
  FRConst_HlghtFrmGroupBoxCapt3 = 'Highlight';
  FRConst_HlghtFrmLabelCaption2 = 'Condition';
  FRConst_HlghtFrmCBXCaption1 = 'Use highlighting';
  FRConst_LoadFormCaption = 'Load Report';
  FRConst_LoadFormLabelCaption1 = 'List of available reports';
  FRConst_TemplFormCaption = 'New report';
  FRConst_TemplFormGroupBoxCapt1 = 'Description';
  FRConst_OLEFormCaption = 'Object OLE';
  FRConst_OLEFormButtonCaption1 = '&Insert';
  FRConst_OLEFormButtonCaption2 = '&Update';
  FRConst_OLEFormButtonCaption5 = '&Clear';
  FRConst_InsOLE = 'Insert object OLE';
  FRConst_PgoptFormCaption = 'Page options';
  FRConst_PgoptFormTabSheetCapt1 = 'Sheet';
  FRConst_PgoptFormGroupBoxCapt2 = 'Orientation';
  FRConst_PgoptFormRBCaption1 = 'Vertical';
  FRConst_PgoptFormRBCaption2 = 'Horizontal';
  FRConst_PgoptFormGroupBoxCapt3 = 'Measure';
  FRConst_PgoptFormLabelCaption1 = 'Width (mm)';
  FRConst_PgoptFormLabelCaption2 = 'Hight (mm)';
  FRConst_PgoptFormTabSheetCapt2 = 'Margins';
  FRConst_PgoptFormGroupBoxCapt4 = 'Page margins';
  FRConst_PgoptFormLabelCaption3 = 'Left (mm)';
  FRConst_PgoptFormLabelCaption4 = 'Top (mm)';
  FRConst_PgoptFormLabelCaption5 = 'Right (mm)';
  FRConst_PgoptFormLabelCaption6 = 'Bottom (mm)';
  FRConst_PgoptFormTabSheetCapt3 = 'Optios';
  FRConst_PgoptFormGroupBoxCapt1 = 'Optios';
  FRConst_PgoptFormCBCaption1 = 'Print to the previous page';
  FRConst_PgoptFormCBCaption2 = 'Header on the first page';
  FRConst_PgoptFormCBCaption3 = 'Footer on last page';
  FRConst_PgoptFormCBCaption4 = 'Copy the table header';
  FRConst_PgoptFormGroupBoxCapt5 = 'Colums';
  FRConst_PgoptFormLabelCaption7 = 'Number';
  FRConst_PgoptFormLabelCaption8 = 'Distance between columns, mm';
  FRConst_PgoptFormTabSheetCapt4 = 'Magnification';
  FRConst_PgoptFormGroupBoxCapt6 = 'Proportions';
  FRConst_PgoptFormLabelCaption9 = 'Page width';
  FRConst_PgoptFormLabelCapt10 = 'Pege height';
  FRConst_ProgrFilterFormCaption = 'Export...';
  FRConst_RichFormCaption = 'Edit RichText';
  FRConst_RichFormOpenButtonHint = 'Open...';
  FRConst_RichFormSaveButtonHint = 'Save...';
  FRConst_RichFormUndoButtonHint = 'Reset';
  FRConst_RichFormBoldButtonHint = 'Bold';
  FRConst_RichFormItalicButtHint = 'Italic';
  FRConst_RichFormLeftAlignHint = 'Align left';
  FRConst_RichFormCenterAligHint = 'Align center';
  FRConst_RichFormRightAlignHint = 'Align right';
  FRConst_RichFormUnderBtnHint = 'Underline';
  FRConst_RichFormBulletsBtnHint = 'List';
  FRConst_RichFormSpeedBtnHint1 = 'Font';
  FRConst_RichFormCancBtnHint = 'Cancel';
  FRConst_RichFormOkBtnHint = 'Close';
  FRConst_RichFormSpeedBtnCapt2 = 'Var';
  FRConst_RichFormSpeedBtnHint2 = 'Insert variable';
  FRConst_RichFormFontNameHint = 'Font type';
  FRConst_RichFormEditHint1 = 'Font size';
  FRConst_RichFormFontSizeHint = 'Font size';
  FRConst_NoCalcEsp = 'Does not calculate expressions';
  FRConst_RTFFile = 'File Rich Text';
  FRConst_InsRichObject = 'Insert RichText object';
  FRConst_SaveFormCaption = 'Save Report';
  FRConst_SaveFormLabelCaption1 = 'Enter the name for the report';
  FRConst_ShapeEditCaption = 'Type of form';
  FRConst_ShapeEditRBShapeCapt = 'Typt';
  FRConst_ShapeEditcbTransCapt = 'Transparent';
  FRConst_ShapeEditRBShapeItems =
    'Ellipse'#13#10'Rectangle'#13#10'Round rectangle'#13#10+
    'Line (type 1)'#13#10+'Line (type 2)';
  FRConst_InsShape = 'Insert geometry form';
  FRConst_TemplNewFormCaption = 'New report from model';
  FRConst_TemplNewFormLabelCapt1 = 'Comment';
  FRConst_TemplNewFormGrpBoxCap2 = 'Icon';
  FRConst_TemplNewFormButtonCap1 = 'File...';
  FRConst_BMPFile = 'Bitmap file';
  FRConst_VarFormCaption = 'Variable';
  FRConst_VarFormLabelCaption1 = 'Category:';
  FRConst_ReportWizardCaption = 'Report wizard';
  FRConst_ReportWizardLabCapt1 = 'Data source';
  FRConst_ReportWizardLabCapt2 = 'Title ofreport';
  FRConst_ReportWizardSrcLabCap = 'Selectable fields';
  FRConst_ReportWizardDstLabCap = 'selected fields';
  FRConst_ReportWizardOptionsCap = 'Sheet';
  FRConst_ReportWizardLandCap = 'Horizontal';
  FRConst_ReportWizardPortCap = 'Vertical';
  FRConst_FmtFormCaption = 'Variable format';
  FRConst_FmtFormGroupBoxCapt2 = 'Variable format';
  FRConst_FmtFormLabelCaption5 = 'Decimals';
  FRConst_FmtFormLabelCaption6 = 'Symbol fraction';
  FRConst_FmtFormLabelCaption1 = 'Format';
  FRConst_Categ: array [1 .. 5] of string = ('Text', 'Number', 'Date',
    'Time', 'Boolean');
  FRConst_Format: array [1 .. 5, 1 .. 5] of string = (('[No One]', '', '', '',
      ''), ('1234,5', '1234,50', '1.234,5', '1.234,50', 'Custom'),
    ('05/11/98', '05/11/1998', '5 nov 1998', '5 november 1998',
      'Custom'), ('02:43:35', '2:43:35', '02:43', '2:43',
      'Custom'), ('0/1', 'Ok/No', 'X/_', '', ''));
  FRConst_ReportConvert = 'Convert the report';
  FRConst_ConvLimit = 'We must place this component on the form ' +
    ' containing QuickReport you want to convert.';
  FRConst_ConvControlName = 'The control name ''';
  FRConst_ConvNoDataSet = ''' did not assign any DataSet.';
  FRConst_RepNoName = 'No name';
  FRConst_DesignReport = 'Draws report';
  FRConst_PreviewReport = 'Preview report';
  FRConst_NewReport = 'New report';
  FRConst_NewFromTemplate = 'New from model...';
  FRConst_OpenReport = 'Open report...';
  FRConst_VarEditor = 'Variables editor...';
  FRConst_FormFile = FRConst_ReportName + ' form';
  FRConst_DefaultPrinter = 'Default Printer';
  FRConst_Paper: array [0 .. 66] of string = ('Custom',
    'Missive, 8 1/2 x 11"', 'Small missive, 8 1/2 x 11"',
    'Compressed, 11 x 17"', 'Ledger, 17 x 11"', 'Legal, 8 1/2 x 14"',
    'Declaration, 5 1/2 x 8 1/2"', 'Executive, 7 1/4 x 10 1/2"',
    'A3 297 x 420 mm', 'A4 210 x 297 mm', 'A4 small sheet, 210 x 297 mm',
    'A5 148 x 210 mm', 'B4 250 x 354 mm', 'B5 182 x 257 mm',
    'Sheet, 8 1/2 x 13"', 'Sheet quarter, 215 x 275 mm', 'Sheet 10 x 14"',
    'Sheet 11 x 17"', 'Notes, 8 1/2 x 11"', '9 Envelope, 3 7/8 x 8 7/8"',
    '#10 Envelope, 4 1/8  x 9 1/2"', '#11 Envelope, 4 1/2 x 10 3/8"',
    '#12 Envelope, 4 3/4 x 11"', '#14 Envelope, 5 x 11 1/2"', 'C Sheet, 17 x 22"',
    'D Sheet, 22 x 34"', 'E Sheet, 34 x 44"', 'DL Sheet, 110 x 220 mm',
    'C5 Envelope, 162 x 229 mm', 'C3 Envelope,  324 x 458 mm',
    'C4 Envelope,  229 x 324 mm', 'C6 Envelope,  114 x 162 mm',
    'C65 Envelope, 114 x 229 mm', 'B4 Envelope,  250 x 353 mm',
    'B5 Envelope,  176 x 250 mm', 'B6 Envelope,  176 x 125 mm',
    'Italian Envelope, 110 x 230 mm', 'Bag king, 3 7/8 x 7 1/2"',
    '6 3/4 Envelope, 3 5/8 x 6 1/2"', 'Amarican Standard Fanfold, 14 7/8 x 11"',
    'German Standard Fanfold, 8 1/2 x 12"',
    'German Legal Fanfold, 8 1/2 x 13"', 'B4 (ISO) 250 x 353 mm',
    'Japanese postcard 100 x 148 mm', 'Sheet 9 x 11"', 'Sheet 10 x 11"',
    'Sheet 15 x 11"', 'Invitation envelope 220 x 220 mm',
    'Extra Letter 9 \ 275 x 12"', 'Extra Legal 9 \275 x 15"',
    'Compressed Extra 11.69 x 18"', 'A4 Extra 9.27 x 12.69"',
    'Letter trasverse 8 \275 x 11"', 'A4 Transverse 210 x 297 mm',
    'Letter Extra Trasverse 9\275 x 12"', 'SuperASuperAA4 227 x 356 mm',
    'SuperBSuperBA3 305 x 487 mm', 'Letter Plus 8.5 x 12.69"',
    'A4 Plus 210 x 330 mm', 'A5 Trasverse 148 x 210 mm',
    'B5 (JIS) Trasverse 182 x 257 mm', 'A3 Extra 322 x 445 mm',
    'A5 Extra 174 x 235 mm', 'B5 (ISO) Extra 201 x 276 mm', 'A2 420 x 594 mm',
    'A3 Trasverse 297 x 420 mm', 'A3 Extra Trasverse 322 x 445 mm');
  FRConst_ErrorOccured = 'There was an error during the preparation phase !';
  FRConst_Object = 'Object';
  FRConst_Band = 'Band:';
  FRConst_Pg = 'Sheet';
  FRConst_ClassNoFound = 'Object not found : %s.' + #10#13 +
    'An advanced component in your report, ' + #10#13 +
    'was not included in the program that uses.';
  FRConst_Error = 'Error';
  FRConst_Stretched = 'Adapted';
  FRConst_ExprHighlightError = 'Expression for the calculation of the highlighting incorrect';
  FRConst_VarFormat = 'Variable format...';
  FRConst_WordWrap = 'Return';
  FRConst_AutoSize = 'Automatic width';
  FRConst_FormNewPage = 'Force a new page';
  FRConst_PrintIfSubsetEmpty = 'Print the details are empty';
  FRConst_Breaked = 'Interrupted band';
  FRConst_CompleteList = 'Complete the list';
  FRConst_SubReportOnPage = 'SubReport in page';
  FRConst_Picture = '[Image]';
  FRConst_InvalidImageFormat = 'Unknown image format.';
  FRConst_PictureCenter = 'Center Image';
  FRConst_KeepAspectRatio = 'Keep the proportions';
  FRConst_From = 'of';
  FRConst_Zero = 'Zero';
  FRConst_Hundred = 'Hundred';
  FRConst_Point = 'Comma';
  FRConst_Negative = 'Minus';
  FRConst_InvalideParameters = 'Invalid parameter format in the function ';
  FRConst_FailAggregation = 'You can not put in a band '+
    'if not enabled the statistical function ';
  FRConst_ErrorParamNumber = 'Number of parameters incorrect ' +
    'for the function ';
  FRConst_FunctPrmError = 'Type of parameters incorrect for the function ';
  FRConst_Yes = 'Yes';
  FRConst_No = 'No';
  FRConst_ReportPreparing = 'Preparing Report';
  FRConst_FirstPass = 'Execution, 1° step:';
  FRConst_PagePreparing = 'Page under construction:';
  FRConst_Preview = 'Preview';
  FRConst_PagePrinting = 'Page for printing:';
  FRConst_PrinterError = 'The selected printer is not valid ';
  FRConst_ErrorFindField = 'It''s not been possible to find the field:';
  FRConst_ObjectNotFound = 'Object not found in the report';
  FRConst_BandNoFound = 'Banda was not found in the report:';
  FRConst_NoAssignNoBand = 'You can not link a frDataset to an object is not a band.';
  FRConst_Value = 'Value';
  FRConst_Bands: array [0 .. 21] of string = ('Title report',
    'Footer report', 'Page header', 'Page footer',
    'Main header', 'main data', 'Main footer',
    'Details header', 'Details data', 'Detail footer',
    'Subdetails header', 'Subdetails data',
    'Subdetails footer', 'Background',
    'Column header', 'Column footer', 'Group header',
    'Group footer', 'Table header', 'Table data',
    'Table footer', 'None');
  FRConst_Vars: array [0 .. frSpecCount - 1] of string = ('Page N°',
    'Expression', 'Date', 'Time', 'Line N°', 'N° continuous line',
    'Column N°', 'N° current line', 'Total pages');
  FRConst_Number1: array [0 .. 19] of string = ('', 'uno', 'due', 'tre',
    'quattro', 'cinque', 'sei', 'sette', 'otto', 'nove', 'dieci', 'undici',
    'dodici', 'tredici', 'quattordici', 'quindici', 'sedici', 'diciassette',
    'diciotto', 'diciannove');
  FRConst_Number2: array [0 .. 9] of string = ('', '', 'venti', 'trenta',
    'quaranta', 'cinquanta', 'sessanta', 'settanta', 'ottanta', 'novanta');
  FRConst_Number3: array [0 .. 9] of string = ('mille', 'mila', 'unmilione',
    'milioni', 'unmiliardo', 'miliardi', 'millemiliardi', 'miliardi',
    'unmilionedimiliardi', 'milionidimiliardi');
  FRConst_CatAll = 'All';
  FRConst_CatInconnue = 'Unknown';
  FRConst_Functions: array[1..FctStdCnt] of string = (
    'AVG=Statistics |AVG(<X>) |Returns the average number of <X>',
    'COUNT=Statistics |COUNT() |Returns the number of elements of the series',
    'FORMATDATETIME=Conversion |FORMATDATETIME(<X>,<Y>) |Returns the date <Y> in the format <X>',
    'FORMATFLOAT=Conversion |FORMATFLOAT(<X>,<Y>) |Returns the number <Y> in the format <X>',
    'LOWERCASE=String |LOWERCASE(<X>) |Returns <X> in lowercase',
    'MAX=Statistics |MAX(<X>) |Returns the max of the series <X>',
    'MIN=Statistics |MIN(<X>) |Returns the min of the series <X>',
    'NAMECASE=String |NAMECASE(<X>) |Returns <X> in lowercase except for the first character uppercase',
    'PHRASECASE=String |PHRASECASE(<X>) |Returns <X> in lowercase except for the first of each word in the text',
    'STRTODATE=Conversion |STRTODATE(<X>) |Returns the date in the string <X>',
    'STRTOTIME=Conversion |STRTOTIME(<X>) |Returns the time in the string <X>',
    'SUM=Statistics |SUM(<X>) |Returns the sum of the series <X>',
    'UPPERCASE=String |UPPERCASE(<X>) |Returns <X> in uppercase',
    'NUMBERTOLETTER=String |NUMBERTOLETTER(<X>) |Returns the number in current italian language <X>',
    'INT=Mathematics |INT(<X>) |Returns the integer part of the number <X>',
    'FRAC=Mathematics |FRAC(<X>) |Return the fractional part of the number <X>',
    'ROUND=Mathematics |ROUND(<X>) |Returns the integer rounded of <X>',
    'STR=String |STR(<X>) |Returns the string of the number <X>',
    'COPY=String |COPY(<X>,<Y>,<Z>) |Returns a substring of <X> from position <Y> to <Z> characters',
    'IF=Boolean |IF(<X>,<Y>,<Z>) |Returns <Y> if expression <X> is true else returns <Z>',
    'TRUNC=Mathematics |TRUNC(<X>) |Returns the integer number by truncation of <X>',
    'ABS=Mathematics |ABS(<X>) |Returns the absolute value of <X>',
    'ARCTAN=Mathematics |ARCTAN(<X>) |Returns the arctangent of <X>',
    'COS=Mathematics |COS(<X>) |Returns the cosin of <X>',
    'EXP=Mathematics |EXP(<X>) |Returns the exponential of <X>',
    'LN=Mathematics |LN(<X>) |Returns the natural logaritm of <X>',
    'PI=Mathematics |PI |Returns the value of pi-greek',
    'SIN=Mathematics |SIN(<X>) |Returns the sin of <X>',
    'SQR=Mathematics |SQR(<X>) |Returns the square of <X>',
    'SQRT=Mathematics |SQRT(<X>) Returns the square root of <X>',
    'POWER=Mathematics |POWER(<X>,<Y>) |Returns the number of <X> elevated to <Y>',
    'CEIL=Mathematics |CEIL(<X>) |Returns the integer number rounding up <X>',
    'FLOOR=Mathematics |FLOOR(<X>) |Returns the integer number rounding down <X>',
    'POS=String |POS(<X>,<Y>) |Returns the integer number of position for the substring <X> in the string <Y>',
    'LENGTH=String |LENGTH(<X>) |Returns the length of the string <X>',
    'FILLSTR=String |FILLSTR(<X>,<Y>) |Returns the string formed by a number <X> of string <Y>',
    'VAL=Mathematics |VAL(<X>) |Returns the value of string <X>',
    'MONEY=Currency |MONEY(<X>) |Returns the string containing the number <X> formatted as currency in the current system',
    'EURO=Currency |EURO(<X>) |Returns the string containing the number <X> formatted as euro',
    'MONEYTOEURO=Currency |MONEYTOEURO(<X>) |Returns the string containing the number <X> converted from current currency to formatted euro',
    'EUROTOMONEY=Currency |EUROTOMONEY(<X>) |Returns the string containing the number <X> converted from euro to formatted currency',
    'MONEYTOEUROVAL=Currency |MONEYTOEUROVAL(<X>) |Returns the number <X> converted from current currency to euro',
    'EUROTOMONEYVAL=Currency |EUROTOMONEYVAL(<X>) |Returns the number <X> converted from euro to current currency');

  FRConst_InspFormCaption = 'Object inspector';
  FRConst_ExpresEditorCaption = 'Expression Editor';
  FRConst_ExpresEditorGB1Caption = 'Costants';
  FRConst_ExpresEditorBB1Caption = 'Add';
  FRConst_ExpresEditorGB2Caption = 'Operators';
  FRConst_ExpresEditorBUndoCapt = 'Reset';
  FRConst_ExpresEditorBB3Caption = 'Delete';
  FRConst_ExpresEditorGB3Caption = 'Funzions';
  FRConst_ExpresEditorBaddFctCap = 'Add';
  FRConst_ExpresEditorGB4Caption = 'Data';
  FRConst_ExpresEditorBB7Caption = 'Add';
  FRConst_ExpresEditorRbItems1 = 'Variables';
  FRConst_ExpresEditorRbItems2 = 'Data';
  FRConst_ExpresEditorTbTabs1 = 'Matematics';
  FRConst_ExpresEditorTbTabs2 = 'Boolean';
  FRConst_ExpresEditorCbCItems1 = 'Text';
  FRConst_ExpresEditorCbCItems2 = 'Numeric';
  FRConst_DsgFrm_Caption = 'Modeller';
  FRConst_DsgFrm_FileBtn1Hint = 'New report';
  FRConst_DsgFrm_FileBtn2Hint = 'Open report';
  FRConst_DsgFrm_FileBtn3Hint = 'Save report';
  FRConst_DsgFrm_FileBtn4Hint = 'Preview report';
  FRConst_DsgFrm_CutBHint = 'Cut';
  FRConst_DsgFrm_CopyBHint = 'Copy';
  FRConst_DsgFrm_PstBHint = 'Past';
  FRConst_DsgFrm_BtnPrevHint = 'Cancel';
  FRConst_DsgFrm_BtnNextHint = 'Reset';
  FRConst_DsgFrm_ZB1Hint = 'Bring to front';
  FRConst_DsgFrm_ZB2Hint = 'Send to back';
  FRConst_DsgFrm_SelAllBHint = 'Select all';
  FRConst_DsgFrm_PgB1Hint = 'Add page';
  FRConst_DsgFrm_PgB2Hint = 'Delete page';
  FRConst_DsgFrm_PgB3Hint = 'Page options';
  FRConst_DsgFrm_PgB4Hint = 'Page management';
  FRConst_DsgFrm_GB2Hint = 'Snap to grid';
  FRConst_DsgFrm_ExitBCaption = 'Close';
  FRConst_DsgFrm_ExitBHint = 'Close modeller';
  FRConst_DsgFrm_AlB1Hint = 'Align Left';
  FRConst_DsgFrm_AlB2Hint = 'Align right';
  FRConst_DsgFrm_AlB3Hint = 'Align centered ';
  FRConst_DsgFrm_AlB8Hint = 'Justify all text';
  FRConst_DsgFrm_AlB5Hint = 'Centered vertically';
  FRConst_DsgFrm_AlB6Hint = 'Align top';
  FRConst_DsgFrm_AlB7Hint = 'Align bottom';
  FRConst_DsgFrm_AlB4Hint = 'Testo normale / 90 gradi';
  FRConst_DsgFrm_FnB1Hint = 'Bold';
  FRConst_DsgFrm_FnB2Hint = 'Italic';
  FRConst_DsgFrm_FnB3Hint = 'Underline';
  FRConst_DsgFrm_ClB2Hint = 'Font color';
  FRConst_DsgFrm_C3Hint = 'Font size';
  FRConst_DsgFrm_C2Hint = 'Font type (name)';
  FRConst_DsgFrm_HlB1Hint = 'Highlighting attributes';
  FRConst_DsgFrm_FrB1Hint = 'Line the top edge';
  FRConst_DsgFrm_FrB2Hint = 'Line the left edge';
  FRConst_DsgFrm_FrB3Hint = 'Line the bottom edge';
  FRConst_DsgFrm_FrB4Hint = 'Line the right edge';
  FRConst_DsgFrm_FrB5Hint = 'All border line';
  FRConst_DsgFrm_FrB6Hint = 'No border line';
  FRConst_DsgFrm_ClB1Hint = 'Background color';
  FRConst_DsgFrm_ClB3Hint = 'Border color';
  FRConst_DsgFrm_Edit1Hint = 'Width bordo';
  FRConst_DsgFrm_UpDown1Hint = 'Width bordo';
  FRConst_DsgFrm_OB1Hint = 'Selected object';
  FRConst_DsgFrm_OB2Hint = 'Insert rectangle';
  FRConst_DsgFrm_OB3Hint = 'Insert band';
  FRConst_DsgFrm_OB4Hint = 'Insert image';
  FRConst_DsgFrm_OB5Hint = 'Insert subreport';
  FRConst_DsgFrm_Wiz1Caption = 'New from Wizard...';
  FRConst_DsgFrm_N2Caption = 'Cut';
  FRConst_DsgFrm_N1Caption = 'Copy';
  FRConst_DsgFrm_N3Caption = 'Past';
  FRConst_DsgFrm_N5Caption = 'Delete';
  FRConst_DsgFrm_N16Caption = 'Select all';
  FRConst_DsgFrm_N6Caption = 'Update...';
  FRConst_DsgFrm_N4Caption = '&File';
  FRConst_DsgFrm_N23Caption = 'New from template...';
  FRConst_DsgFrm_N19Caption = 'Open...';
  FRConst_DsgFrm_N15Caption = 'Save as...';
  FRConst_DsgFrm_N20Caption = 'Save';
  FRConst_DsgFrm_N42Caption = 'List of variables...';
  FRConst_DsgFrm_N8Caption = 'Report options...';
  FRConst_DsgFrm_N25Caption = 'Page options...';
  FRConst_DsgFrm_N39Caption = 'Preview';
  FRConst_DsgFrm_N10Caption = 'Exit';
  FRConst_DsgFrm_N7Caption = '&Update';
  FRConst_DsgFrm_UndoCaption = 'Cancel';
  FRConst_DsgFrm_RestoreCaption = 'Reset';
  FRConst_DsgFrm_N11Caption = 'Cut';
  FRConst_DsgFrm_N12Caption = 'Copy';
  FRConst_DsgFrm_N13Caption = 'Past';
  FRConst_DsgFrm_N27Caption = 'Delete';
  FRConst_DsgFrm_N28Caption = 'Select all';
  FRConst_DsgFrm_N36Caption = 'Update...';
  FRConst_DsgFrm_N29Caption = 'Add page';
  FRConst_DsgFrm_N30Caption = 'Remove page';
  FRConst_DsgFrm_N32Caption = 'Bring to front';
  FRConst_DsgFrm_N33Caption = 'Send to back';
  FRConst_DsgFrm_N9Caption = '&Tools';
  FRConst_DsgFrm_N14Caption = 'Grid';
  FRConst_DsgFrm_Gr2Caption = 'Align to grid';
  FRConst_DsgFrm_Gr3Caption = '4 point (about 1 mm)';
  FRConst_DsgFrm_Gr4Caption = '8 point (about 2 mm)';
  FRConst_DsgFrm_Gr5Caption = '19 point (about 5 mm)';
  FRConst_DsgFrm_N18Caption = 'Selection';
  FRConst_DsgFrm_N22Caption = 'Edge';
  FRConst_DsgFrm_N35Caption = 'Reverse';
  FRConst_DsgFrm_N37Caption = 'Toolbar';
  FRConst_DsgFrm_Pan1Caption = 'Default';
  FRConst_DsgFrm_Pan2Caption = 'Text';
  FRConst_DsgFrm_Pan3Caption = 'Rectangle';
  FRConst_DsgFrm_Pan4Caption = 'Objects';
  FRConst_DsgFrm_Pan5Caption = 'Object control';
  FRConst_DsgFrm_Pan6Caption = 'Alignment tools';
  FRConst_DsgFrm_MastMenuCaption = 'Unit of measure';
  FRConst_DsgFrm_M1Caption = 'Point';
  FRConst_DsgFrm_M2Caption = 'Millimeters';
  FRConst_DsgFrm_M3Caption = 'Inches';
  FRConst_DsgFrm_ReOpMenu = '&Reopen';
  FRConst_Name = 'Name';
  FRConst_Left = 'X';
  FRConst_Top = 'Y';
  FRConst_Width = 'Width';
  FRConst_Height = 'Height';
  FRConst_Memo = 'Text';
  FRConst_Visible = 'Visible';
  FRConst_True = 'True';
  FRConst_False = 'False';
  FRConst_RemovePg = 'Remove this page ?';
  FRConst_Confirm = 'Confirmation';
  FRConst_FileOverWrite = 'There is already a report with this name.' + #13#10 +
    'Do you want to overwrite it ?';
  FRConst_MessageNewBlank =
    'Saving changes to the current report ?';
  FRConst_MessageNew = 'Saving changes to...';
  FRConst_PropertyError = 'The value entered is invalid.';
  FRConst_TemplFile = 'Template ' + FRConst_ReportName;
  FRConst_FrmSelRepCaption = 'List of convertible reports';
  FRConst_FrmSelRepTitle = 'Select the reports to be converted';
  FRConst_PagesListCaption = 'Management pages';
  FRConst_PagesListLabelCaption = 'Page list';

IMPLEMENTATION

END.
