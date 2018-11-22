unit FR_PrFlt;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Const, ComCtrls, FR_Class, Buttons;

const
  CM_BeforeModal = WM_USER + 1;

type
  TProgressFilterForm = class(TForm)
    Button1: TBitBtn;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOnBeforeModal: TNotifyEvent;
    procedure CMBeforeModal(var Message: TMessage); message CM_BeforeModal;
  public
    { Public declarations }
    FirstCaption: string;
    property OnBeforeModal: TNotifyEvent read FOnBeforeModal write FOnBeforeModal;
    function Show_Modal: Word;
  end;

var
  ProgressFilterForm: TProgressFilterForm;

implementation

{$R *.DFM}

function TProgressFilterForm.Show_Modal: Word;
begin
  PostMessage(Handle, CM_BeforeModal, 0, 0);
  Result := ShowModal;
end;

procedure TProgressFilterForm.Button1Click(Sender: TObject);
begin
  TerminatedFilter := True;
  ModalResult := mrCancel;
end;

procedure TProgressFilterForm.CMBeforeModal(var message: TMessage);
begin
  if Assigned(FOnBeforeModal) then FOnBeforeModal(Self);
end;

procedure TProgressFilterForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_ProgrFilterFormCaption;
  Button1.Caption := FRConst_Cancel;
end;

end.

