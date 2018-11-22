
{*****************************************}
{                                         }
{             FastReport v2.2             }
{               Fields list               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Flds;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, FR_Const, Buttons, FR_Utils;

type
  TFieldsForm = class(TForm)
    ValCombo: TComboBox;
    ValList: TListBox;
    Label1: TLabel;
    Button2: TBitBtn;
    procedure ValComboClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ValListClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function CurVal: string;
    function CurDataSet: string;
    procedure GetFields(Value: string);
    procedure GetSpecValues;
    procedure FillValCombo;
  public
    { Public declarations }
    DBField: string;
  end;

var
  FieldsForm: TFieldsForm;
  LastDB: string;

implementation

{$R *.DFM}

uses FR_Class;

procedure TFieldsForm.FormActivate(Sender: TObject);
var
  I: Integer;
begin
  FillValCombo;
  I := TStringList(ValCombo.Items).IndexOf(LastDB);
  if I = -1 then I := 0;
  ValCombo.ItemIndex := I;
  ValComboClick(nil);
end;

function TFieldsForm.CurVal: string;
begin
  Result := '';
  if ValList.ItemIndex <> -1 then
    Result := ValList.Items[ValList.ItemIndex];
end;

function TFieldsForm.CurDataSet: string;
begin
  Result := '';
  if ValCombo.ItemIndex <> -1 then
    Result := ValCombo.Items[ValCombo.ItemIndex];
end;

procedure TFieldsForm.FillValCombo;
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
  ValCombo.Items.Assign(s);
  s.Free;
end;

procedure TFieldsForm.ValComboClick(Sender: TObject);
begin
  if CurDataSet <> FRConst_SpecVal then
    GetFields(CurDataSet)
  else
    GetSpecValues;
  LastDB := ValCombo.Items[ValCombo.ItemIndex];
end;

procedure TFieldsForm.GetFields(Value: string);
var
  DataSet: TDataSet;
  i: Integer;
  SaveAct: Boolean;
begin
  ValList.Items.Clear;
  ValList.Items.Add(FRConst_NotAssigned);
  DataSet := frGetDataSet(Value);
  with DataSet do
    begin
      SaveAct := Active;
      Active := True;
      FieldDefs.Update;
      try
        Active := True;
        if FieldCount > 0 then
          for i := 0 to FieldCount - 1 do
            ValList.Items.Add(Fields[i].FieldName)
        else
          for i := 0 to FieldDefs.Count - 1 do
            ValList.Items.Add(FieldDefs.Items[i].Name);
      except
        on Exception do ;
      end;
      Active := SaveAct;
    end;
end;

procedure TFieldsForm.GetSpecValues;
var
  i: Integer;
begin
  with ValList.Items do
    begin
      Clear;
      Add(FRConst_NotAssigned);
      for i := 0 to frSpecCount - 1 do
        if i <> 1 then
          Add(frSpecArr[i]);
    end;
end;

procedure TFieldsForm.ValListClick(Sender: TObject);
begin
  if CurVal = FRCOnst_NotAssigned then
    ModalResult := mrCancel
  else
    begin
      if CurDataSet <> FRConst_SpecVal then
        DBField := CurDataSet + '."' + CurVal + '"'
      else
        if ValList.ItemIndex > 1 then
          DBField := frSpecFuncs[ValList.ItemIndex]
        else
          DBField := frSpecFuncs[0];
      ModalResult := mrOk;
    end;
end;

procedure TFieldsForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFieldsForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_FieldsFormCaption;
  Label1.Caption := FRConst_FieldsFormLabelCapt1;
  Button2.Caption := FRConst_Cancel;
end;

initialization
  LastDB := '';

end.

