{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_Save;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FR_Const;

type
  TSaveForm = class(TForm)
    Label1: TLabel;
    Edit: TEdit;
    Cancel: TBitBtn;
    OK: TBitBtn;
    procedure EditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileName: string;
    function Execute: Boolean;
  end;

var
  SaveForm: TSaveForm;

implementation

{$R *.DFM}

procedure TSaveForm.EditChange(Sender: TObject);
begin
  OK.Enabled := Edit.Text <> '';
end;

function TSaveForm.Execute: Boolean;
begin
  if ShowModal = mrOK then
    begin
      if Pos('.FRF', UpperCase(Edit.Text)) <> Length(Edit.Text) - 3 then
        FileName := Edit.Text + '.frf'
      else
        FileName := Edit.Text;
      Result := True;
    end
  else
    Result := False;
end;

procedure TSaveForm.FormCreate(Sender: TObject);
begin
  FileName := '';

  Caption := FRConst_SaveFormCaption;
  Label1.Caption := FRConst_SaveFormLabelCaption1;
  Cancel.Caption := FRConst_Cancel;
  OK.Caption := FRConst_OK;
end;

procedure TSaveForm.FormShow(Sender: TObject);
begin
  if Pos('.FRF', UpperCase(FileName)) = Length(FileName) - 3 then
    Edit.Text := Copy(FileName, 1, Length(FileName) - 4)
  else
    Edit.Text := FileName
end;

end.

