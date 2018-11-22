
{*****************************************}
{                                         }
{             FastReport v2.2             }
{              Picture editor             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_GEdit;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, FR_Const
  {$IFNDEF DELPHI2} ,extdlgs {$ENDIF};

type
  TGEditorForm = class(TForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    Button3: TBitBtn;
    Button4: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GEditorForm: TGEditorForm;

implementation

{$R *.DFM}

procedure TGEditorForm.BitBtn1Click(Sender: TObject);
var
  OldDir: string;
  OpenDlg: TOpenDialog;
begin
   OpenDlg := TOpenPictureDialog.Create (nil);
   OpenDlg.Filter := FRConst_PictFile +
      ' (*.bmp *.ico *.wmf *.emf *.jpg *.jpeg)|*.bmp;*.ico;*.wmf;*.emf;*.jpg;*.jpeg|' +
      FRConst_AllFiles + '|*.*';
   OpenDlg.Title := FRConst_PictOpenFile;
   OldDir := GetCurrentDir;
   if OpenDlg.Execute then
      Image1.Picture.LoadFromFile(OpenDlg.FileName);
   OpenDlg.Free;
   SetCurrentDir(OldDir);
end;

procedure TGEditorForm.Button4Click(Sender: TObject);
begin
  Image1.Picture.Assign(nil);
end;

procedure TGEditorForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_GEditorFormCaption;
  Button3.Caption := FRConst_GEditorFormButtonCapt3;
  Button4.Caption := FRConst_GEditorFormButtonCapt4;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
end;

end.
