
{*****************************************}
{                                         }
{             FastReport v2.2             }
{            Document options             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Dopt;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Const, Buttons;

type
  TDocOptForm = class(TForm)
    GroupBox2: TGroupBox;
    CB2: TCheckBox;
    Button1: TBitBtn;
    Button2: TBitBtn;
    CB3: TCheckBox;
    CB4: TCheckBox;
    procedure CB3Click(Sender: TObject);
    procedure CB4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DocOptForm: TDocOptForm;

implementation

{$R *.DFM}

uses FR_Prntr;

procedure TDocOptForm.CB3Click(Sender: TObject);
begin
  CB4.Enabled := CB3.Checked;
  if not CB3.Checked then CB4.Checked := False;
end;

procedure TDocOptForm.CB4Click(Sender: TObject);
begin
  if CB4.Checked then
    begin
      CB2.Checked := True;
      CB2.Enabled := False;
    end
  else
    CB2.Enabled := True;
end;

procedure TDocOptForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_DocOptFormCaption;
  GroupBox2.Caption := FRConst_DocOptFormGroupBoxCap2;
  CB2.Caption := FRConst_DocOptFormCBCaption2;
  CB3.Caption := FRConst_DocOptFormCBCaption3;
  CB4.Caption := FRConst_DocOptFormCBCaption4;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
end;

end.

