
{*****************************************}
{                                         }
{             FastReport v2.2             }
{            Group band editor            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_GrpEd;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Class, FR_Const, FR_Var, Buttons, ExtCtrls;

type
  TGroupEditorForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Panel2: TPanel;
    E1: TSpeedButton;
    Button3: TBitBtn;
    Button4: TBitBtn;
    procedure frSpeedButton1Click(Sender: TObject);
    procedure frSpeedButton2Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowEditor(t: TfrView);
  end;

var
  GroupEditorForm: TGroupEditorForm;

implementation

{$R *.DFM}

uses FR_Flds, edExpr, ClipBrd;

procedure TGroupEditorForm.ShowEditor(t: TfrView);
begin
  Edit1.Text := t.FormatStr;
  if ShowModal = mrOk then
    t.FormatStr := Edit1.Text;
end;

procedure TGroupEditorForm.frSpeedButton1Click(Sender: TObject);
begin
  FieldsForm := TFieldsForm.Create(nil);
  with FieldsForm do
    if ShowModal = mrOk then
      Edit1.Text := '[' + DBField + ']';
  FieldsForm.Free;
end;

procedure TGroupEditorForm.frSpeedButton2Click(Sender: TObject);
begin
  VarForm := TVarForm.Create(nil);
  with VarForm do
    if ShowModal = mrOk then
      if Variables.ItemIndex >= 0 then
        Edit1.Text := '[' + Variables.Items[Variables.ItemIndex] + ']';
  VarForm.Free;
end;

procedure TGroupEditorForm.E1Click(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := '';
    if edEx.ShowModal = MrOk then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := edEx.moExpres.Text;
        Edit1.PasteFromClipboard;
      end;
  finally
    edEx.Free;
  end;
  Edit1.SetFocus;
end;

procedure TGroupEditorForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_GroupEditFormCaption;
  Label1.Caption := FRConst_GroupEditFormLabelCap1;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
  Button3.Caption := FRConst_Var;
  Button4.Caption := FRConst_DB;
end;

procedure TGroupEditorForm.Button3Click(Sender: TObject);
begin
  VarForm := TVarForm.Create(nil);
  with VarForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        if Variables.ItemIndex >= 0 then
          ClipBoard.AsText := Variables.Items[Variables.ItemIndex];
        Edit1.PasteFromClipboard;
      end;
  VarForm.Free;
  Edit1.SetFocus;
end;

procedure TGroupEditorForm.Button4Click(Sender: TObject);
begin
  FieldsForm := TFieldsForm.Create(nil);
  with FieldsForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := DBField;
        Edit1.PasteFromClipboard;
      end;
  FieldsForm.Free;
  Edit1.SetFocus;
end;

end.

