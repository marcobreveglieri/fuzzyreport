{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_GrFld;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Const, Buttons, ComCtrls, ExtCtrls;

type
  TFrGraphFieldEditor = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TSpeedButton;
    Panel2: TPanel;
    E1: TSpeedButton;
    Edit1: TEdit;
    Panel1: TPanel;
    E2: TSpeedButton;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Color1: TShape;
    procedure E1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure E2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure E3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure ColorSelected(Sender: TObject);
  end;

var
  FieldEditor: TFrGraphFieldEditor;
  Str1, Str2: string;
  Col1: TColor;

implementation

{$R *.DFM}

uses edExpr, FR_Color;

var
  Col: TColorSelector;

procedure TFrGraphFieldEditor.E1Click(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := Edit1.Text;
    if edEx.ShowModal = MrOk then
      Edit1.Text := edEx.moExpres.Text;
  finally
    edEx.Free;
  end;
end;

procedure TFrGraphFieldEditor.Button1Click(Sender: TObject);
begin
  Col.Visible := True;
  Col.Left := TButton(Sender).Left;
  Col.Top := TButton(Sender).Top + TButton(Sender).Height;
  Col.Color := Color1.Brush.Color;
  Color1.Visible := True;
end;

procedure TFrGraphFieldEditor.E2Click(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := Edit2.Text;
    if edEx.ShowModal = MrOk then
      Edit2.Text := edEx.moExpres.Text;
  finally
    edEx.Free;
  end;
end;

procedure TFrGraphFieldEditor.FormShow(Sender: TObject);
begin
  Col.Color := Col1;
  Color1.Brush.Color := Col1;
  Edit1.Text := Str1;
  Edit2.Text := Str2;
end;

procedure TFrGraphFieldEditor.ColorSelected(Sender: TObject);
begin
  if Col.Color <> clNone then
    Color1.Brush.Color := Col.Color
  else
    Color1.Brush.Color := clWhite;
end;

procedure TFrGraphFieldEditor.BitBtn1Click(Sender: TObject);
begin
  Str1 := Edit1.Text;
  Str2 := Edit2.Text;
  Col1 := Col.Color;
end;

procedure TFrGraphFieldEditor.E3Click(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := Edit2.Text;
    if edEx.ShowModal = MrOk then
      Edit2.Text := edEx.moExpres.Text;
  finally
    edEx.Free;
  end;
end;

procedure TFrGraphFieldEditor.FormCreate(Sender: TObject);
begin
  Caption := FRConst_GrphFldEditCaption;
  Label1.Caption := FRConst_GrphFldEditLabelCapt1;
  Label2.Caption := FRConst_GrphFldEditLabelCapt2;
  Button1.Caption := FRConst_GrphFldEditButtonCapt1;
  BitBtn1.Caption := FRConst_OK;
  BitBtn2.Caption := FRConst_Cancel;
end;

initialization
  FieldEditor := TFrGraphFieldEditor.Create(nil);
  Col := TColorSelector.Create(FieldEditor);
  Col.Visible := False;
  Col.OnColorSelected := FieldEditor.ColorSelected;

finalization
  FieldEditor.Free;

end.

