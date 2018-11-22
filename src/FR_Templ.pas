
{*****************************************}
{                                         }
{             FastReport v2.2             }
{            New Template form            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Templ;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Const, Buttons;

type
  TTemplNewForm = class(TForm)
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Button2: TBitBtn;
    Button3: TBitBtn;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TemplNewForm: TTemplNewForm;

implementation

{$R *.DFM}

procedure TTemplNewForm.Button1Click(Sender: TObject);
begin
  OpenDialog1.Filter := FRConst_BMPFile + ' (*.bmp)|*.bmp';
  with OpenDialog1 do
    if Execute then
      Image1.Picture.LoadFromFile(FileName);
end;

procedure TTemplNewForm.FormActivate(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Image1.Picture.Assign(nil);
  Memo1.SetFocus;
end;

procedure TTemplNewForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_TemplNewFormCaption;
  Label1.Caption := FRConst_TemplNewFormLabelCapt1;
  GroupBox2.Caption := FRConst_TemplNewFormGrpBoxCap2;
  Button1.Caption := FRConst_TemplNewFormButtonCap1;
  Button2.Caption := FRConst_OK;
  Button3.Caption := FRConst_Cancel;
end;

end.

