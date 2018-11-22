{*******************************************}
{                                           }
{            FastReport v2.2                }
{                                           }
{   Editeur d'expression                    }
{ (C) Guilbaud Olivier                      }
{        golivier@bigfoot.com               }
{                                           }
{ FastReport :(c) 1998-99 by Tzyganenko A.  }
{                                           }
{ Merci de transmettre vos commantaires &   }
{ modifications                             }
{Ceci est un FREEWARE il peut être utilisé  }
{librement.                                 }
{ Attention : vous cette unité fait partie  }
{ du patch 1.2 mini de FR.
{*******************************************}
{Histo :                                    }
{ 03/06/99 : Création                       }
{ 04/06/99 : Corrections minueurs
             ajouté le bouton "Défaire"
}

unit edExpr;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DB, Fr_Class, ComCtrls;

type
  TExprEditor = class(TForm)
    moExpres: TMemo;
    GroupBox1: TGroupBox;
    edConst: TEdit;
    cbConstType: TComboBox;
    BitBtn1: TBitBtn;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    BUndo: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    GroupBox3: TGroupBox;
    cbCatFunction: TComboBox;
    lbFunction: TListBox;
    baddFct: TBitBtn;
    HlpFct1: TLabel;
    GroupBox4: TGroupBox;
    rbVarOrData: TRadioGroup;
    cbCatData: TComboBox;
    lbData: TListBox;
    BitBtn7: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    tbOper: TTabControl;
    Panel4: TPanel;
    pnMath: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    pnLogique: TPanel;
    Button6: TButton;
    Button5: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button13: TButton;
    Button12: TButton;
    Button14: TButton;
    Button17: TButton;
    Button18: TButton;
    moHlp2: TMemo;
    Button15: TButton;
    MoneyTo: TEdit;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure tbOperChange(Sender: TObject);
    procedure rbVarOrDataClick(Sender: TObject);
    procedure cbCatDataClick(Sender: TObject);
    procedure cbCatFunctionClick(Sender: TObject);
    procedure lbFunctionClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure baddFctClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BUndoClick(Sender: TObject);
    procedure MoneyToChange(Sender: TObject);
    procedure MoneyToExit(Sender: TObject);
  private
    { Déclarations privées }
    CurExp: string; // Chaine généré par un bouton add
    UndoLst: TStringList;
    procedure AddFctStandard(CatIndex: Integer);
  public
    { Déclarations publiques }

    function CurVal: string;
    function CurDataSet: string;
    procedure GetFields(Value: string);
    procedure GetSpecValues;
    procedure FillValCombo;
    procedure FillCatCombo;
    procedure FillFctList(CatIndex: Integer);

    function DecodeFrCat(S: string; n: Integer): string;
    function GetDBField: string;
    procedure TraiteSaisie;
  end;

var
  ExprEditor: TExprEditor;

implementation
{$R *.DFM}
uses edExpPar, FR_Const, FR_Utils;

const
  FctStd: array[1..FctStdCnt] of string = ('IF', 'INT', 'FRAC', 'COPY', 'ROUND',
    'STR', 'NUMBERTOLETTER', 'TRUNC',
    'ABS', 'ARCTAN', 'COS', 'EXP', 'LN',
    'PI', 'SIN', 'SQR', 'SQRT', 'POWER',
    'POS', 'LENGTH', 'VAL', 'AVG', 'COUNT',
    'FORMATDATETIME', 'FORMATFLOAT',
    'LOWERCASE', 'MAX', 'MIN', 'NAMECASE',
    'STRTODATE', 'STRTOTIME', 'SUM',
    'UPPERCASE', 'PHRASECASE',
    'MONEYTOEURO', 'MONEY', 'EURO',
    'EUROTOMONEY', 'MONEYTOEUROVAL',
    'EUROTOMONEYVAL', 'CEIL', 'FLOOR',
    'FILLSTR');

function LoadStr(S: string): string;
var
  I: Integer;
  R: string;
  OK: Boolean;
begin
  Result := '';
  OK := False;
  S := UpperCase(S);
  I := 1;
  while (I <= FctStdCnt) and (not OK) do
    begin
      R := UpperCase(Copy(FRConst_Functions[I], 1, Pos('=', FRConst_Functions[I]) - 1));
      if S = R then
        OK := True
      else
        Inc(I);
    end;
  if OK then
    Result := Copy(FRConst_Functions[I], Length(R) + 2,
      Length(FRConst_Functions[I]) - Length(R) - 1)
  else
    begin
      I := 0;
      while (I <= DescriptionList.Count - 1) and (not OK) do
        begin
          R := UpperCase(Copy(DescriptionList[I], 1, Pos('=', DescriptionList[I]) - 1));
          if S = R then
            OK := True
          else
            Inc(I);
        end;
      if OK then
        Result := Copy(DescriptionList[I], Length(R) + 2,
          Length(DescriptionList[I]) - Length(R) - 1);
    end;
end;

procedure TExprEditor.TraiteSaisie;
var
  OldExp: string;
begin
  if CurExp = '' then exit;
  OldExp := moExpres.Lines[0];
  moExpres.Lines[0] := moExpres.Lines[0] + CurExp;
  CurExp := '';
  UndoLst.Add(OldExp);
  BUndo.Enabled := (UndoLst.Count <> 0);
end;

procedure TExprEditor.FillCatCombo;
var
  FctLib: TfrFunctionLibrary;
  I, J: Integer;
  LstT: TStringList;
  S: string;
begin
  LstT := nil;
  try
    LstT := TStringList.Create;
    LstT.Sorted := True;
    LstT.Duplicates := dupIgnore;

    cbCatFunction.Items.Clear;
    cbCatFunction.Items.Add(FRConst_CatAll);
    cbCatFunction.Text := '';
    for i := 0 to frFunctionsCount - 1 do
      begin
        FctLib := frFunctions[i].FunctionLibrary;
        for J := 0 to FctLib.List.Count - 1 do
          begin
            S := FctLib.List.Strings[J];
            S := DecodeFrCat(S, 1);
            if S = '' then S := FRConst_CatInconnue;
            LstT.Add(S);
          end;
      end;

    for J := 1 to FctStdCnt do
      begin
        S := FctStd[J];
        S := DecodeFrCat(S, 1);
        if S = '' then S := FRConst_CatInconnue;
        LstT.Add(S);
      end;

    cbCatFunction.Items.AddStrings(LstT);
    cbCatFunction.ItemIndex := 0;

  finally
    LstT.Free;
  end;
end;

procedure TExprEditor.FillFctList(CatIndex: Integer);
var
  FctLib: TfrFunctionLibrary;
  I, J: Integer;
  S, St: string;
  Ajout: Boolean;
  Lst: TStringList;
begin
  lbFunction.Items.Clear;
  for i := 0 to frFunctionsCount - 1 do
    begin
      FctLib := frFunctions[i].FunctionLibrary;
      for J := 0 to FctLib.List.Count - 1 do
        begin
          s := FctLib.List.Strings[J];
          st := CbCatFunction.Items.Strings[CatIndex];
          if St = FRConst_CatInconnue then St := ''; // catégorie inconnue
          Ajout := (CatIndex = 0) or (St = DecodeFrCat(LoadStr(S), 1));
          if Ajout then
            lbFunction.Items.Add(S)
        end;

    end;

  AddFctStandard(CatIndex);

  // force le trie
  lst := nil;
  try
    Lst := TStringList.Create;
    Lst.Assign(lbFunction.Items);
    Lst.Sort;
    lbFunction.Items.Assign(Lst);
  finally
    Lst.free;
  end;

end;

procedure TExprEditor.AddFctStandard(CatIndex: Integer);
var
  Aj: Boolean;
  St: string;
  i: Integer;
begin
  Aj := (CatIndex = 0);
  ST := cbCatFunction.Items.Strings[CatIndex];
  if St = FRConst_CatInconnue then St := '';

  for i := 1 to FctStdCnt do
    if Aj or (St = DecodeFrCat(FctStd[i], 1)) then
      lbFunction.Items.ADD(FctStd[i]);
end;

procedure TExprEditor.FormActivate(Sender: TObject);
begin
  cbConstType.Text := cbConstType.Items[1];
  // Init Memo
  if moExpres.Lines[0] <> '' then
    moExpres.SelStart := Length(moExpres.Lines[0]);
  // Opérateurs
  tbOper.TabIndex := 0;
  pnMath.Visible := True;
  pnLogique.visible := False;

  // les variable
  rbVarOrData.ItemIndex := 0;

  // Init List functions
  FillCatCombo;
  FillFctList(0);
  lbFunction.ItemIndex := 0;
  lbFunctionClick(nil);
end;

procedure TExprEditor.tbOperChange(Sender: TObject);
begin
  pnMath.Visible := (tbOper.TabIndex = 0);
  pnLogique.Visible := not pnMath.Visible;
end;

procedure TExprEditor.rbVarOrDataClick(Sender: TObject);
begin
  case rbVarOrData.ItemIndex of
    0:
      begin
        CurReport.GetCategoryList(cbCatData.Items);
        cbCatData.ItemIndex := 0;
        cbCatDataClick(nil);
      end;
    1:
      begin
        FillValCombo;
        cbCatData.ItemIndex := 0;
        cbCatDataClick(nil);
      end;
  end;

end;

function TExprEditor.CurDataSet: string;
begin
  Result := '';
  if cbCatData.ItemIndex <> -1 then
    Result := cbCatData.Items[cbCatData.ItemIndex];
end;

function TExprEditor.CurVal: string;
begin
  Result := '';
  if lbData.ItemIndex <> -1 then
    Result := lbData.Items[lbData.ItemIndex];
end;

procedure TExprEditor.FillValCombo;
var
  i, j: Integer;
  s: TStringList;
  procedure EnumDataSets(f: TComponent);
  var
    i: Integer;
    c: TComponent;
  begin
    for i := 0 to f.ComponentCount - 1 do
      begin
        c := f.Components[i];
        if c is TDataSet then
          if f = CurReport.Owner then
            s.Add(c.Name)
          else
            s.Add(f.Name + '.' + c.Name);
      end;
  end;
begin
  s := TStringList.Create;
  for i := 0 to Screen.FormCount - 1 do
    EnumDataSets(Screen.Forms[i]);
  for i := 0 to Screen.DataModuleCount - 1 do
    EnumDataSets(Screen.DataModules[i]);
  for i := 0 to Screen.FormCount - 1 do
    for j := 0 to Screen.Forms[i].ComponentCount - 1 do
      if Screen.Forms[i].Components[j] is TDataModule then
        EnumDataSets(Screen.Forms[i].Components[j]);
  s.Sort;
  s.Add(FRConst_SpecVal);
  cbCatData.Items.Assign(s);
  s.Free;
end;

procedure TExprEditor.GetFields(Value: string);
var
  DataSet: TDataSet;
  i: Integer;
  SaveAct: Boolean;
begin
  lbData.Items.Clear;
  DataSet := frGetDataSet(Value);
  with DataSet do
    begin
      SaveAct := Active;
      try
        Active := True;
        if FieldCount > 0 then
          for i := 0 to FieldCount - 1 do
            lbData.Items.Add(Fields[i].FieldName)
        else
          for i := 0 to FieldDefs.Count - 1 do
            lbData.Items.Add(FieldDefs.Items[i].Name);
      except
        on Exception do ;
      end;
      Active := SaveAct;
    end;
end;

procedure TExprEditor.GetSpecValues;
var
  i: Integer;
begin
  with lbData.Items do
    begin
      Clear;
      for i := 0 to frSpecCount - 1 do
        if i <> 1 then
          Add(frSpecArr[i]);
    end;
end;

function TExprEditor.GetDbField: string;
begin
  Result := '';
  if rbVarOrData.ItemIndex = 1 then
    begin
      if cbCatData.Text <> FRConst_SpecVal then
        begin
          if lbData.ItemIndex >= 0 then
            Result := cbCatData.Text + '."' + LbData.Items.Strings[lbData.ItemIndex] + '"'
          else
            Result := '';
        end
      else
        if lbData.ItemIndex >= 0 then
          begin
            if lbData.ItemIndex = 0 then
              Result := frSpecFuncs[lbData.ItemIndex]
            else
              Result := frSpecFuncs[lbData.ItemIndex + 1]
          end;
    end;
end;

procedure TExprEditor.cbCatDataClick(Sender: TObject);
begin
  case rbVarOrData.ItemIndex of
    0: CurReport.GetVarList(cbCatData.ItemIndex, lbData.Items);
    1:
      begin
        if CurDataSet <> FRConst_SpecVal then
          GetFields(CurDataSet)
        else
          GetSpecValues;
      end;
  end;
end;

procedure TExprEditor.cbCatFunctionClick(Sender: TObject);
begin
  FillFctList(cbCatFunction.ItemIndex);
  if lbFunction.Items.Count > 0 then
    begin
      lbFunction.ItemIndex := 0;
      lbFunctionClick(nil);
    end;
end;

function TExprEditor.DecodeFrCat(S: string; n: Integer): string;
var
  Cg, C, H1, H2: string;
begin
  Cg := LoadStr(S);
  C := trim(Copy(Cg, 1, Pos('|', Cg) - 1));
  System.Delete(Cg, 1, Pos('|', Cg));

  H1 := Trim(Copy(Cg, 1, Pos('|', Cg) - 1));
  System.Delete(Cg, 1, Pos('|', Cg));

  H2 := Trim(Cg);

  Result := '';

  case n of
    1: Result := C;
    2: Result := H1;
    3: Result := H2;
  end;
end;

procedure TExprEditor.lbFunctionClick(Sender: TObject);
var
  Cg, C, H1, H2: string;
  S: string;
begin
  S := lbFunction.Items.Strings[lbFunction.itemIndex];
  Cg := LoadStr(S);
  C := Copy(Cg, 1, Pos('|', Cg) - 1);
  System.Delete(Cg, 1, Pos('|', Cg));

  H1 := Copy(Cg, 1, Pos('|', Cg) - 1);
  System.Delete(Cg, 1, Pos('|', Cg));

  H2 := Cg;

  HlpFct1.Caption := H1;
  moHlp2.Lines.Clear;
  moHlp2.Lines.Add(H2);
end;

procedure TExprEditor.MoneyToChange(Sender: TObject);
Var
   Money : Extended;
begin
   Money:=Abs(StrToFloatDef(Trim(MoneyTo.Text),1.00));
   MoneyToEuro:=Money;
End;

procedure TExprEditor.MoneyToExit(Sender: TObject);
begin
   MoneyTo.Text:=FloatToStr(MoneyToEuro);
end;

procedure TExprEditor.BitBtn1Click(Sender: TObject);
begin
  case cbConstType.ItemIndex of
    0:
      if Pos('''', edConst.Text) = 0 then
        CurExp := '''' + edConst.Text + '''';
    1: CurExp := edConst.Text;
  end;

  TraiteSaisie;
  edConst.Text := '';
end;

procedure TExprEditor.FormCreate(Sender: TObject);
begin
  CurExp := '';
  moExpres.Lines.Clear;
  moExpres.Lines.Add('');
  // liste des modif
  UndoLst := TStringList.Create;

  Caption := FRConst_ExpresEditorCaption;
  GroupBox1.Caption := FRConst_ExpresEditorGB1Caption;
  BitBtn1.Caption := FRConst_ExpresEditorBB1Caption;
  GroupBox2.Caption := FRConst_ExpresEditorGB2Caption;
  BUndo.Caption := FRConst_ExpresEditorBUndoCapt;
  BitBtn3.Caption := FRConst_ExpresEditorBB3Caption;
  GroupBox3.Caption := FRConst_ExpresEditorGB3Caption;
  BaddFct.Caption := FRConst_ExpresEditorBaddFctCap;
  GroupBox4.Caption := FRConst_ExpresEditorGB4Caption;
  BitBtn7.Caption := FRConst_ExpresEditorBB7Caption;
  BitBtn4.Caption := FRConst_OK;
  BitBtn5.Caption := FRConst_Cancel;
  RbVarOrData.Items.Clear;
  RbVarOrData.Items.Add(FRConst_ExpresEditorRbItems1);
  RbVarOrData.Items.Add(FRConst_ExpresEditorRbItems2);
  TbOper.Tabs.Clear;
  TbOper.Tabs.Add(FRConst_ExpresEditorTbTabs1);
  TbOper.Tabs.Add(FRConst_ExpresEditorTbTabs2);
  CbConstType.Items.Clear;
  CbConstType.Items.Add(FRConst_ExpresEditorCbCItems1);
  CbConstType.Items.Add(FRConst_ExpresEditorCbCItems2);
end;

procedure TExprEditor.Button1Click(Sender: TObject);
begin
  if Sender is TButton then
    CurExp := TButton(Sender).Caption;
  TraiteSaisie;
end;

procedure TExprEditor.BitBtn3Click(Sender: TObject);
begin
  UndoLst.Add(moExpres.Lines[0]);
  moExpres.Lines[0] := '';
  BUndo.Enabled := (UndoLst.Count <> 0);
end;

procedure TExprEditor.BitBtn7Click(Sender: TObject);
begin
  case rbVarOrData.ItemIndex of
    0:
      begin //Variable
        if lbData.ItemIndex <> -1 then
          CurExp := '[' + lbData.items.Strings[lbData.ItemIndex] + ']';
      end;
    1:
      begin
        CurExp := GetDbField;
        if CurExp <> '' then CurExp := CurExp;
        //         if CurExp<>'' then CurExp:='['+CurExp+']';
      end;
  end;

  TraiteSaisie;
end;

procedure TExprEditor.baddFctClick(Sender: TObject);
var
  FctBase, ST: string;
  edPar: TedParamFct;
begin
  //Recupère la fonction ou (..)
  if sender = bAddFct then
    ST := HlpFct1.Caption
  else
    St := '(<X>)';

  FctBase := Copy(ST, 1, Pos('(', ST)); // copie 'XXXX('

  if (Pos('()', ST) > 0) or (Pos('(', ST) = 0) then
    begin
      CurExp := ST;
      TraiteSaisie
    end
  else
    begin
      edpar := nil;
      try
        edPar := TedParamFct.Create(SELF);
        edPar.hlp1.Caption := St;
        if Sender = BAddFct then
          edPar.hlp2.Text := moHlp2.Text
        else
          edPar.hlp2.Text := '';

        CurExp := '';
        if edPar.ShowModal = mrOk then
          CurExp := FctBase + edPar.ResultPar + ')';

        TraiteSaisie;
      finally
        edPar.Free;
      end;
    end
end;

procedure TExprEditor.FormDestroy(Sender: TObject);
begin
  UndoLst.Free;
end;

procedure TExprEditor.BUndoClick(Sender: TObject);
begin
  moExpres.Lines[0] := UndoLst.Strings[UndoLst.Count - 1];
  UndoLst.Delete(UndoLst.Count - 1);
  BUndo.Enabled := (UndoLst.Count <> 0);
end;

end.

 