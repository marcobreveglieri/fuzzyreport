{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_Load;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Fr_Const, StdCtrls, Buttons{$IFDEF Delphi4}, ImgList{$ENDIF}, ComCtrls,
  ImgList;

type
  TLoadForm = class(TForm)
    ListView1: TListView;
    ImageList1: TImageList;
    Label1: TLabel;
    OK: TBitBtn;
    Cancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileName: string;
    function Execute: Boolean;
  end;

var
  LoadForm: TLoadForm;

implementation

{$R *.DFM}

procedure TLoadForm.FormShow(Sender: TObject);
var
  SearchRec: TSearchRec;
  Li: TListItem;
begin
  if FindFirst(GetCurrentDir + '\*.frf', faAnyFile, SearchRec) = 0 then
    repeat
      Li := ListView1.Items.Add;
      Li.Caption := Copy(ExtractFileName(SearchRec.Name), 1,
        Length(ExtractFileName(SearchRec.Name)) - 4);
    until FindNext(SearchRec) <> 0;
end;

function TLoadForm.Execute: Boolean;
begin
  if ShowModal = mrOK then
    begin
      FileName := ListView1.Selected.Caption + '.frf';
      Result := True;
    end
  else
    Result := False;
end;

procedure TLoadForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if ListView1.Selected <> nil then
    OK.Enabled := True
  else
    Ok.Enabled := False;
end;

procedure TLoadForm.ListView1DblClick(Sender: TObject);
begin
  if OK.Enabled then ModalResult := mrOK;
end;

procedure TLoadForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_LoadFormCaption;
  Label1.Caption := FRConst_LoadFormLabelCaption1;
  OK.Caption := FRConst_OK;
  Cancel.Caption := FRConst_Cancel;
end;

end.

