
{*****************************************}
{                                         }
{             FastReport v2.2             }
{              Page options               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_pgopt;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, FR_Const, Buttons;

type
  TPgoptForm = class(TForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox2: TGroupBox;
    imgLandScape: TImage;
    imgPortrait: TImage;
    RB1: TRadioButton;
    RB2: TRadioButton;
    GroupBox1: TGroupBox;
    CB1: TCheckBox;
    CB2: TCheckBox;
    CB3: TCheckBox;
    CB4: TCheckBox;
    GroupBox3: TGroupBox;
    ComB1: TComboBox;
    E1: TEdit;
    E2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox4: TGroupBox;
    E3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    E4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    E5: TEdit;
    E6: TEdit;
    GroupBox5: TGroupBox;
    Label7: TLabel;
    E7: TEdit;
    Label8: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    TabSheet4: TTabSheet;
    GroupBox6: TGroupBox;
    ScaleX: TEdit;
    Up1: TUpDown;
    Label9: TLabel;
    ScaleY: TEdit;
    Up2: TUpDown;
    Label10: TLabel;
    procedure RB1Click(Sender: TObject);
    procedure RB2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComB1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PgoptForm: TPgoptForm;

implementation

{$R *.DFM}

uses FR_Prntr, FR_Class, FR_Utils;

procedure TPgoptForm.RB1Click(Sender: TObject);
begin
  ImgPortrait.Show;
  ImgLandscape.Hide;
end;

procedure TPgoptForm.RB2Click(Sender: TObject);
begin
  ImgLandscape.Show;
  ImgPortrait.Hide;
end;

procedure TPgoptForm.FormActivate(Sender: TObject);
begin
  if RB1.Checked then
    RB1Click(nil)
  else
    RB2Click(nil);
  ComB1Click(nil);
  ComB1.Perform(CB_SETDROPPEDWIDTH, 200, 0);
end;

procedure TPgoptForm.ComB1Click(Sender: TObject);
begin
  frEnableControls([Label1, Label2, E1, E2], PrinterSettings.PaperSizes[ComB1.ItemIndex] = pgCustomSize);
end;

procedure TPgoptForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_PgoptFormCaption;
  TabSheet1.Caption := FRConst_PgoptFormTabSheetCapt1;
  GroupBox2.Caption := FRConst_PgoptFormGroupBoxCapt2;
  RB1.Caption := FRConst_PgoptFormRBCaption1;
  RB2.Caption := FRConst_PgoptFormRBCaption2;
  GroupBox3.Caption := FRConst_PgoptFormGroupBoxCapt3;
  Label1.Caption := FRConst_PgoptFormLabelCaption1;
  Label2.Caption := FRConst_PgoptFormLabelCaption2;
  TabSheet2.Caption := FRConst_PgoptFormTabSheetCapt2;
  GroupBox4.Caption := FRConst_PgoptFormGroupBoxCapt4;
  Label3.Caption := FRConst_PgoptFormLabelCaption3;
  Label4.Caption := FRConst_PgoptFormLabelCaption4;
  Label5.Caption := FRConst_PgoptFormLabelCaption5;
  Label6.Caption := FRConst_PgoptFormLabelCaption6;
  TabSheet3.Caption := FRConst_PgoptFormTabSheetCapt3;
  GroupBox1.Caption := FRConst_PgoptFormGroupBoxCapt1;
  CB1.Caption := FRConst_PgoptFormCBCaption1;
  CB2.Caption := FRConst_PgoptFormCBCaption2;
  CB3.Caption := FRConst_PgoptFormCBCaption3;
  CB4.Caption := FRConst_PgoptFormCBCaption4;
  GroupBox5.Caption := FRConst_PgoptFormGroupBoxCapt5;
  Label7.Caption := FRConst_PgoptFormLabelCaption7;
  Label8.Caption := FRConst_PgoptFormLabelCaption8;
  TabSheet4.Caption := FRConst_PgoptFormTabSheetCapt4;
  GroupBox6.Caption := FRConst_PgoptFormGroupBoxCapt6;
  Label9.Caption := FRConst_PgoptFormLabelCaption9;
  Label10.Caption := FRConst_PgoptFormLabelCapt10;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
end;

end.

