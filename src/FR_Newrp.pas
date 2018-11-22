
{*****************************************}
{                                         }
{             FastReport v2.2             }
{             Template viewer             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Newrp;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Class, ComCtrls, {$IFDEF Delphi4}ImgList, {$ENDIF}
  FR_Const, Buttons, ImgList;

type
  TTemplForm = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Image1: TImage;
    Button1: TBitBtn;
    Button2: TBitBtn;
    ListView1: TListView;
    ImageList1: TImageList;
    procedure FormActivate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TemplName: string;
  end;

var
  TemplForm: TTemplForm;

implementation

{$R *.DFM}

var
  Path: string;

procedure TTemplForm.FormActivate(Sender: TObject);
var
  SearchRec: TSearchRec;
  r: Word;
  l: TListItem;
begin
  if CurReport.TemplateDir = '' then
    Path := ''
  else
    Path := CurReport.TemplateDir + '\';
  ListView1.Items.Clear;
  R := FindFirst(Path + '*.frt', faAnyFile, SearchRec);
  while R = 0 do
    begin
      if (SearchRec.Attr and faDirectory) = 0 then
        begin
          l := ListView1.Items.Add;
          l.Caption := ChangeFileExt(SearchRec.Name, '');
        end;
      R := FindNext(SearchRec);
    end;
  FindClose(SearchRec);
  Memo1.Lines.Clear;
  Image1.Picture.Bitmap.Assign(nil);
  Button1.Enabled := False;
end;

procedure TTemplForm.ListBox1Click(Sender: TObject);
begin
  Button1.Enabled := ListView1.Selected <> nil;
  if Button1.Enabled then
    begin
      CurReport.LoadTemplate(Path + ListView1.Selected.Caption + '.frt',
        Memo1.Lines, Image1.Picture.Bitmap, False);
    end;
end;

procedure TTemplForm.ListBox1DblClick(Sender: TObject);
begin
  if Button1.Enabled then ModalResult := mrOk;
end;

procedure TTemplForm.FormDeactivate(Sender: TObject);
begin
  if ModalResult = mrOk then
    if ListView1.Selected <> nil then
      TemplName := Path + ListView1.Selected.Caption + '.frt';
end;

procedure TTemplForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_TemplFormCaption;
  GroupBox1.Caption := FRConst_TemplFormGroupBoxCapt1;
  Button1.Caption := FRCOnst_OK;
  Button2.Caption := FRConst_Cancel;
end;

end.

