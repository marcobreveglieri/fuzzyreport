
{*****************************************}
{                                         }
{             FastReport v2.2             }
{           Select Band dialog            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_BTyp;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Const, Buttons;

type
  TBandTypesForm = class(TForm)
    Button1: TBitBtn;
    GB1: TGroupBox;
    Button2: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure bClick(Sender: TObject);
  public
    { Public declarations }
    SelectedTyp: Integer;
  end;

var
  BandTypesForm: TBandTypesForm;

implementation

uses FR_Class, FR_Desgn;

{$R *.DFM}

procedure TBandTypesForm.FormCreate(Sender: TObject);
var
  b: TRadioButton;
  bt: TfrBandType;
  First: Boolean;
begin
  First := True;
  for bt := btReportTitle to btColumnFooter do
    begin
      b := TRadioButton.Create(GB1);
      b.Parent := GB1;
      if Integer(bt) > 10 then
        begin
          b.Left := GB1.Width div 2 + 8; //130;
          b.Top := (Integer(bt) - 11) * 20 + 20;
        end
      else
        begin
          b.Left := 8;
          b.Top := Integer(bt) * 20 + 20;
        end;
      B.Width := GB1.Width div 2 - 9;
      b.Tag := Integer(bt);
      b.Caption := frBandNames[Integer(bt)];
      b.OnClick := bClick;
      b.Enabled := (bt in [btMasterHeader, btMasterData, btMasterFooter,
        btDetailHeader, btDetailData, btDetailFooter,
          btSubDetailHeader, btSubDetailData, btSubDetailFooter,
          btGroupHeader, btGroupFooter]) or not frCheckBand(bt);
      if b.Enabled and First then
        begin
          b.Checked := True;
          SelectedTyp := Integer(bt);
          First := False;
        end;
    end;

  Caption := FRConst_BandTypeCaption;
  GB1.Caption := FRConst_BandTypeGBCaption;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
end;

procedure TBandTypesForm.bClick(Sender: TObject);
begin
  SelectedTyp := (Sender as TComponent).Tag;
end;

end.

