{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_Find;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, FR_Const;

type
  TFindForm = class(TForm)
    FindText: TComboBox;
    FindLabel: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FindOptions: TGroupBox;
    FindCase: TCheckBox;
    FindSub: TCheckBox;
    FindOrigin: TGroupBox;
    FindFirstPage: TRadioButton;
    FindCurrentPage: TRadioButton;
    FindNext: TRadioButton;
    FindPrevious: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FindTextChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  OldData = record
    OFindCase, OFindSub, EnbNext, EnbPrev: Boolean;
    OFindOrigin: Byte;
    OFindText: TStringList;
    OText: string;
  end;

Var
  FindData: OldData;

implementation

{$R *.DFM}

procedure TFindForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_FindTextCaption;
  FindLabel.Caption := FRConst_FindLabelCaption;
  FindOptions.Caption := FRConst_FindOptionsCaption;
  FindCase.Caption := FRConst_FindCaseCaption;
  FindSub.Caption := FRConst_FindSubCaption;
  FindOrigin.Caption := FRConst_FindOriginCaption;
  FindFirstPage.Caption := FRConst_FindFirstPageCaption;
  FindCurrentPage.Caption := FRConst_FindCurrentPageCaption;
  FindNext.Caption := FRConst_FindNextCaption;
  FindPrevious.Caption := FRConst_FindPreviousCaption;
  OKBtn.Caption := FRConst_OK;
  CancelBtn.Caption := FRConst_Cancel;
end;

procedure TFindForm.FormShow(Sender: TObject);
begin
  If FindText.CanFocus Then
     FindText.SetFocus;
end;

procedure TFindForm.FindTextChange(Sender: TObject);
begin
  If Not FindText.CanFocus Then Exit;
  FindNext.Enabled := False;
  FindPrevious.Enabled := False;
  if (FindNext.Checked) or (FindPrevious.Checked) then
    FindFirstPage.Checked := True;
end;

initialization
  FindData.OFindText := TStringList.Create;
  FindData.OFindCase := False;
  FindData.OFindSub := True;
  FindData.OFindOrigin := 0;
  FindData.EnbNext := False;
  FindData.EnbPrev := False;
  FindData.OText := '';

finalization
  FindData.OFindText.Free;
end.

