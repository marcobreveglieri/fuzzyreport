{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

Unit FR_ETxt;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class, FR_Const, StdCtrls, ComCtrls, Buttons;

type

  TfrTextExportObject = class(TComponent) // fake component
  end;

  TfrTextExportFilter = class(TfrExportFilter)
  private
    Lines: TStringList;
    LastHeight, LastY, Top, CurHeight, MinX, MinY, MaxTop, Num, ColNumbers: Integer;
    CurXDiv, AVGHeight: Double;
    PageBreak, LeftMargin, TopMargin, BottomMargin: Boolean;
  public
    constructor Create(AFileName,ATitle,AAuthor:String); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    procedure OnEndPage; override;
    procedure OnBeginPage(Width, Height: Integer); override;
    procedure OnText(x, y: Integer; const text: string; Font: TFont); override;
  end;

  TTextFilterForm = class(TForm)
    Group: TGroupBox;
    OK: TBitBtn;
    Cancel: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    PageBreak: TCheckBox;
    TopMargin: TCheckBox;
    BottomMargin: TCheckBox;
    LeftMargin: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R frETxt.dcr}

{$R *.DFM}

function dup(aChar: Char; Count: Integer): String;
var
  i: Integer;
begin
  result := '';
  for i := 1 to Count do
    result := result + aChar;
end;

procedure WriteMemo(Stream: TStream; L: TStrings; X0, Y0, Y1: Integer);
var
  s: string;
  i: Integer;
  b: Byte;

  Ax: RawByteString;
  AL: Integer;

  function FindLength(S: string): Integer;
  begin
    Result := Length(S);
    while S[Result] = ' ' do
      Dec(Result);
  end;

begin
   for I := 0 to Y0 - 1 do
   begin
      b := 13;
      Stream.Write(b, 1);
      b := 10;
      Stream.Write(b, 1);
   end;
   for i := 0 to Y1 - 1 do
   begin
      S := L[i];
      if S <> '' then
      Begin
         //Stream.Write(S[X0], FindLength(S));
         AX:=UTF8Encode(S);
         AL:=Length(AX);
         Stream.Write(AX[X0],AL);
      End;

      // Insert the 'ENTER' char.
      b := 13;
      Stream.Write(b, 1);
      b := 10;
      Stream.Write(b, 1);
   end;
end;

constructor TfrTextExportFilter.Create(AFileName,ATitle,AAuthor:String);
begin
  inherited Create(AFileName,ATitle,AAuthor);
  Stream:=TFileStream.Create(AFileName,fmCreate);
  Lines:=TStringList.Create;
end;

destructor TfrTextExportFilter.Destroy;
begin
  Try
     Lines.Free;
     Stream.Free;
  Finally
    inherited Destroy;
  End;
End;

function TfrTextExportFilter.Execute: Boolean;
var
  TextFilterForm: TTextFilterForm;
begin
  TextFilterForm := TTextFilterForm.Create(nil);
  if TextFilterForm.ShowModal = mrOK then
    begin
      PageBreak := TextFilterForm.PageBreak.Checked;
      LeftMargin := TextFilterForm.LeftMargin.Checked;
      TopMargin := TextFilterForm.TopMargin.Checked;
      BottomMargin := TextFilterForm.BottomMargin.Checked;
      ColNumbers := TextFilterForm.UpDown1.Position;
      Result := True;
    end
  else
    Result := False;
  TextFilterForm.Free;
end;

procedure TfrTextExportFilter.OnBeginPage(Width, Height: Integer);
var
  I: Integer;
begin
  Lines.Clear;
  for I := 0 to 199 do
    Lines.Add('');
  CurXDiv := Width / ColNumbers;
  LastHeight := -1;
  LastY := -1;
  CurHeight := Height;
  MaxTop := -1;
  MinX := MaxInt;
  MinY := MaxInt;
end;

procedure TfrTextExportFilter.OnEndPage;
var
  b: Byte;
  Y0, Y1: Integer;
begin
   // Write the text page.
   if Lines.Count > 0 then
   begin
      if BottomMargin then
        Y1 := Round(Top + (CurHeight - (LastY + LastHeight)) / AVGHeight)
      else
        Y1 := MaxTop + 1;
      if TopMargin then
        Y0 := Round(MinY / AVGHeight)
      else
        Y0 := 0;
      if LeftMargin then
        WriteMemo(Stream, Lines, 1, Y0, Y1)
      else
        WriteMemo(Stream, Lines, MinX, Y0, Y1);
   end;
   // Insert the page jump code.
   if PageBreak then
   begin
      b := 12;
      Stream.Write(b, 1);
      b := 13;
      Stream.Write(b, 1);
      b := 10;
      Stream.Write(b, 1);
   end;
end;

procedure TfrTextExportFilter.OnText(x, y: Integer; const text: string; Font: TFont);
var
  I: Integer;
  S: RawByteString;
  T: RawByteString;
begin
   if Y < MinY then MinY := Y;
   if LastHeight = -1 then
   begin
      LastHeight := -Font.Height + 2;
      LastY := Y;
      Top := 0;
      AVGHeight := LastHeight;
      Num := 1;
   end
   else
   begin
      AVGHeight := ((AVGHeight * Num) + LastHeight) / (Num + 1);
      Inc(Num);
      if Y < LastY + LastHeight - 1 then
      begin
         if - Font.Height + 2 > LastHeight then
         begin
            LastHeight := -Font.Height + 2;
            LastY := Y;
         end;
      end
      else
      begin
         Inc(Top, (Y - LastY) div LastHeight);
         LastHeight := -Font.Height + 2;
         LastY := Y;
         if Top > MaxTop then MaxTop := Top;
      end;
   end;
   X := Round(X / CurXDiv);
   if X < MinX then MinX := X;
   if Lines[Top] = '' then Lines[Top] := Dup(' ', 200);
   S:=Utf8Encode(Lines[Top]);
   T:=Utf8Encode(text);
   for I := 0 to Length(T) - 1 do
      If X+I<=200 Then S[X+I] := T[I + 1];
   Lines[Top] :=UTF8ToString(S);
End;

procedure TTextFilterForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_TxtFltFrmCaption;
  Group.Caption := FRConst_TxtFltFrmGroupCaption;
  Label1.Caption := FRConst_TxtFltFrmLabelCapt1;
  PageBreak.Caption := FRConst_TxtFltFrmPageBrkCapt;
  TopMargin.Caption := FRConst_TxtFltFrmTopMargCapt;
  BottomMargin.Caption := FRConst_TxtFltFrmBotMargCapt;
  LeftMargin.Caption := FRConst_TxtFltFrmLeftMargCapt;
  OK.Caption := FRConst_OK;
  Cancel.Caption := FRConst_Cancel;
end;

initialization
  frRegisterExportFilter(TfrTextExportFilter,
    FRConst_TextFile + ' (*.txt)', '*.txt');

end.

