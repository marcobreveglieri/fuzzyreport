
{*****************************************}
{                                         }
{             FastReport v2.2             }
{             Progress dialog             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_progr;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Class, FR_Const, Buttons;

const
  CM_BeforeModal = WM_USER + 1;

type
  TProgressForm = class(TForm)
    Button1: TBitBtn;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDoc: TfrReport;
    FOnBeforeModal: TNotifyEvent;
    procedure CMBeforeModal(var Message: TMessage); message CM_BeforeModal;
  public
    { Public declarations }
    FirstCaption: string;
    property OnBeforeModal: TNotifyEvent read FOnBeforeModal write FOnBeforeModal;
    function Show_Modal(Doc: TfrReport): Word;
  end;

var
  ProgressForm: TProgressForm;

implementation

{$R *.DFM}

function TProgressForm.Show_Modal(Doc: TfrReport): Word;
begin
  FDoc := Doc;
  PostMessage(Handle, CM_BeforeModal, 0, 0);
  Result := ShowModal;
end;

procedure TProgressForm.Button1Click(Sender: TObject);
begin
  FDoc.Terminated := True;
  ModalResult := mrCancel;
end;

procedure TProgressForm.CMBeforeModal(var message: TMessage);
begin
  if Assigned(FOnBeforeModal) then FOnBeforeModal(Self);
end;

procedure TProgressForm.FormCreate(Sender: TObject);
begin
  Button1.Caption := FRConst_Cancel;
end;

end.

