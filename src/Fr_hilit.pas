
{*****************************************}
{                                         }
{             FastReport v2.2             }
{       Highlight attributes dialog       }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Hilit;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FR_Const, FR_Utils, ExtCtrls;

type
  THilightForm = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    CB1: TCheckBox;
    CB2: TCheckBox;
    CB3: TCheckBox;
    Button3: TBitBtn;
    Button4: TBitBtn;
    ColorDialog1: TColorDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    RB1: TRadioButton;
    RB2: TRadioButton;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    CBX1: TCheckBox;
    Edit2: TEdit;
    Panel2: TPanel;
    BEditor: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RB1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBX1Click(Sender: TObject);
    procedure BEditorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FontColor,FillColor: TColor;
  end;

var
  HilightForm: THilightForm;

implementation

{$R *.DFM}

uses FR_Desgn, FR_Class, edExpr;

procedure THilightForm.SpeedButton1Click(Sender: TObject);
begin
  ColorDialog1.Color := FontColor;
  if ColorDialog1.Execute then
  begin
    FontColor := ColorDialog1.Color;
    frSetGlyph(FontColor,SpeedButton1,0);
  end;
end;

procedure THilightForm.SpeedButton2Click(Sender: TObject);
begin
  ColorDialog1.Color := FillColor;
  if ColorDialog1.Execute then
  begin
    FillColor := ColorDialog1.Color;
    frSetGlyph(FillColor,SpeedButton2,1);
  end;
end;

procedure THilightForm.FormActivate(Sender: TObject);
begin
  frSetGlyph(FontColor,SpeedButton1,0);
  frSetGlyph(FillColor,SpeedButton2,1);
  if FillColor = clNone then
    RB1.Checked := True else
    RB2.Checked := True;
  RB1Click(nil);
  CBX1Click(nil);  
end;

procedure THilightForm.RB1Click(Sender: TObject);
begin
  SpeedButton2.Enabled := RB2.Checked;
  if RB1.Checked then FillColor := clNone;
end;

procedure THilightForm.FormCreate(Sender: TObject);
begin
  Caption              := FRConst_HlghtFrmCaption;
  GroupBox1.Caption    := FRConst_HlghtFrmGroupBoxCapt1;
  SpeedButton1.Caption := FRConst_HlghtFrmSpeedBtnCapt1;
  CB1.Caption          := FRConst_HlghtFrmCBCaption1;
  CB2.Caption          := FRConst_HlghtFrmCBCaption2;
  CB3.Caption          := FRConst_HlghtFrmCBCaption3;
  GroupBox2.Caption    := FRConst_HlghtFrmGroupBoxCapt2;
  SpeedButton2.Caption := FRConst_HlghtFrmSpeedBtnCapt2;
  RB1.Caption          := FRConst_HlghtFrmRBCaption1;
  RB2.Caption          := FRConst_HlghtFrmRBCaption2;
  GroupBox3.Caption    := FRConst_HlghtFrmGroupBoxCapt3;
  Label2.Caption       := FRConst_HlghtFrmLabelCaption2;
  CBX1.Caption         := FRConst_HlghtFrmCBXCaption1;
  Button3.Caption      := FRConst_OK;
  Button4.Caption      := FRConst_Cancel;
end;

procedure THilightForm.CBX1Click(Sender: TObject);
begin
  frEnableControls([Label2,Edit2],CBX1.Checked);
  Panel2.Enabled := CBX1.Checked;
end;

procedure THilightForm.BEditorClick(Sender: TObject);
Var edEx : TExprEditor;
begin
  edEx:=NIL;
  Try
    edEx:=TExprEditor.Create(Self);
    edEx.moExpres.Text:=Edit2.Text;
    if edEx.ShowModal=MrOk then
     edit2.Text:=edEx.moExpres.Text;
  finally
    edEx.Free;
  end;
end;

end.
