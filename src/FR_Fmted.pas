
{*****************************************}
{                                         }
{             FastReport v2.2             }
{              Format editor              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_fmted;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Const, Buttons;

type
  TFmtForm = class(TForm)
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Panel1: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    SplEdit: TEdit;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Panel2: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure DesEditChange(Sender: TObject);
    procedure SplEditChange(Sender: TObject);
    procedure ComboBox2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SplEditEnter(Sender: TObject);
    procedure ShowPanel1;
    procedure ShowPanel2;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Format: Integer;
  end;

var
  FmtForm: TFmtForm;

implementation

{$R *.DFM}

uses FR_Class;

const
  CategCount = 5;

procedure TFmtForm.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  Panel1.Hide;
  Panel2.Hide;
  ComboBox1.Items.Clear;
  for i := 0 to CategCount - 1 do
    ComboBox1.Items.Add(FRConst_Categ[I + 1]);
  ComboBox1.ItemIndex := (Format and $0F000000) div $01000000;
  ComboBox1Change(nil);
  ComboBox2.ItemIndex := (Format and $00FF0000) div $00010000;
  ShowPanel2;
  ShowPanel1;
end;

procedure TFmtForm.ShowPanel1;
begin
  Panel1.Visible := (ComboBox1.ItemIndex = 1) and (not Panel2.Visible);
  if Panel1.Visible then
    begin
      Edit3.Text := IntToStr((Format and $0000FF00) div $00000100);
      SplEdit.Text := Chr(Format and $000000FF);
    end;
end;

procedure TFmtForm.ShowPanel2;
begin
  Panel2.Visible := ComboBox2.ItemIndex = 4;
end;

procedure TFmtForm.ComboBox1Change(Sender: TObject);
var
  i, k: Integer;
  s: string;
begin
  k := ComboBox1.ItemIndex;
  if k = -1 then Exit;
  ComboBox2.Items.Clear;
  for i := 0 to 4 do
    begin
      s := FRConst_Format[K + 1, I + 1];
      if s <> '' then ComboBox2.Items.Add(s);
    end;
  ComboBox2.ItemIndex := 0;
  if Sender <> nil then
    begin
      ComboBox2Click(nil);
      ShowPanel1;
      Edit1.Text := '';
    end;
end;

procedure TFmtForm.ComboBox1Click(Sender: TObject);
begin
  Format := (Format and $F0FFFFFF) + Round(ComboBox1.ItemIndex * $01000000)
end;

procedure TFmtForm.ComboBox2Click(Sender: TObject);
begin
  Format := (Format and $FF00FFFF) + Round(ComboBox2.ItemIndex * $00010000);
  ShowPanel2;
  ShowPanel1;
end;

procedure TFmtForm.DesEditChange(Sender: TObject);
begin
  Format := (Format and $FFFF00FF) + Round(StrToInt(Edit3.Text) * $00000100);
end;

procedure TFmtForm.SplEditChange(Sender: TObject);
var
  c: Char;
begin
  c := ',';
  if SplEdit.Text <> '' then c := SplEdit.Text[1];
  Format := (Format and $FFFFFF00) + Ord(c);
end;

procedure TFmtForm.SplEditEnter(Sender: TObject);
begin
  SplEdit.SelectAll;
end;

procedure TFmtForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_FmtFormCaption;
  GroupBox2.Caption := FRConst_FmtFormGroupBoxCapt2;
  Label5.Caption := FRConst_FmtFormLabelCaption5;
  Label6.Caption := FRConst_FmtFormLabelCaption6;
  Label1.Caption := FRConst_FmtFormLabelCaption1;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
end;

end.

