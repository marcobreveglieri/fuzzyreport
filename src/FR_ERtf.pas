{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_ERtf;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class, FR_Const, StdCtrls, ComCtrls, Buttons;

type

  TfrRichExportObject = class(TComponent) // fake component
  end;

  TfrRichExportFilter = class(TfrExportFilter)
  private
    PageBreak, DelInterline: Boolean;
    FirstPage: Boolean;
    LastHeight, LastY, LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
    TempStream: TMemoryStream;
    FontTable, ColorTable: TStringList;
    Line: string;
    Tab, IntText: TStringList;
    procedure WriteLine;
  public
    constructor Create(AFileName,ATitle,AAuthor:String); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    procedure OnBeginPage(Width, Height: Integer); override;
    procedure OnEndPage; override;
    procedure OnText(x, y: Integer; const text: string; Font: TFont); override;
  end;

  TRichFilterForm = class(TForm)
    Group: TGroupBox;
    OK: TBitBtn;
    Cancel: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    PageBreak: TCheckBox;
    KeepLines: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Label3: TLabel;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Label4: TLabel;
    Edit4: TEdit;
    UpDown4: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R frERtf.dcr}

{$R *.DFM}

procedure TfrRichExportFilter.WriteLine;
var
  S1  : String;
  S2  : String;
  L   : String;
  I   : Integer;
begin
  S1 := '';
  for I := 0 to Tab.Count - 1 do
    S1 := S1 + Copy(Tab[I], 11, Length(Tab[I]) - 10);
  S2 := '';
  for I := 0 to IntText.Count - 1 do
    S2 := S2 + Copy(IntText[I], 11, Length(IntText[I]) - 10);
  L := '\pard' + S1 + '{' + S2 + '\par}' + #13#10;
  TempStream.Write(UTF8Encode(L)[1], Length(UTF8Encode(L)));
end;

constructor TfrRichExportFilter.Create(AFileName,ATitle,AAuthor:String);
begin
  inherited Create(AFileName,ATitle,AAuthor);
  Stream:=TFileStream.Create(AFileName,fmCreate);
  FirstPage := True;
  TempStream := TMemoryStream.Create;
  FontTable := TStringList.Create;
  FontTable.Add('Arial');
  ColorTable := TStringList.Create;
  Tab := TStringList.Create;
  Tab.Sorted := True;
  IntText := TStringLIst.Create;
  IntText.Sorted := True;
end;

destructor TfrRichExportFilter.Destroy;
var
  S   : String;
  I   : Integer;
begin
   Try
      // Write FontTable
      S := '{\fonttbl';
      Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      for I := 0 to FontTable.Count - 1 do
      begin
         S := '{\f' + IntToStr(I) + ' ' + FontTable[I] + '}';
         Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      end;
      S := '}' + #13#10;
      Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      // Write ColorTable
      S := '{\colortbl;';
      Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      for I := 0 to ColorTable.Count - 1 do
      begin
         S := ColorTable[I];
         Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      end;
      S := '}' + #13#10;
      Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      // Copy The Temporany stream into the file.
      TempStream.Position := TempStream.Position - 2;
      S := '\par}';
      TempStream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
      Stream.CopyFrom(TempStream, 0);
      // Free the shared resource.
      FontTable.Free;
      ColorTable.Free;
      TempStream.Free;
      Stream.Free;
   Finally
      Inherited Destroy;
   End;
End;

function TfrRichExportFilter.Execute: Boolean;
var
  RichFilterForm: TRichFilterForm;
begin
  RichFilterForm := TRichFilterForm.Create(nil);
  if RichFilterForm.ShowModal = mrOK then
    begin
      PageBreak := RichFilterForm.PageBreak.Checked;
      DelInterline := RichFilterForm.KeepLines.Checked;
      LeftMargin := Round(RichFilterForm.UpDown1.Position * 56.7);
      RightMargin := Round(RichFilterForm.UpDown2.Position * 56.7);
      TopMargin := Round(RichFilterForm.UpDown3.Position * 56.7);
      BottomMargin := Round(RichFilterForm.UpDown4.Position * 56.7);
      Result := True;
    end
  else
    Result := False;
  RichFilterForm.Free;
end;

procedure TfrRichExportFilter.OnBeginPage(Width, Height: Integer);
var
  S: String;
begin
  LastHeight := -1;
  if FirstPage then
    begin
      S := '{\rtf1\ansi' + #13#10 + '\margl' + IntToStr(LeftMargin) + '\margr' +
        IntToStr(RightMargin) + '\margt' + IntToStr(TopMargin) + '\margb' +
        IntToStr(BottomMargin) + #13#10;
      Stream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
    end;
  if (not FirstPage) and (PageBreak) then
    begin
      Line := '\page' + #13#10;
      TempStream.Write(Utf8Encode(Line)[1], Length(Utf8Encode(Line)));
    end;
  FirstPage := False;
end;

procedure TfrRichExportFilter.OnEndPage;
begin
  WriteLine;
end;

procedure TfrRichExportFilter.OnText(x, y: Integer; const text: string; Font: TFont);
const
  StepXY = 567 / (794 / 21);
  HChr: array[0..9] of String = ('{\f0\fs2 \par}'#$D#$A,
    '{\f0\fs4 \par}'#$D#$A,
    '{\f0\fs6 \par}'#$D#$A,
    '{\f0\fs8 \par}'#$D#$A,
    '{\f0\fs10 \par}'#$D#$A,
    '{\f0\fs12 \par}'#$D#$A,
    '{\f0\fs14 \par}'#$D#$A,
    '{\f0\fs16 \par}'#$D#$A,
    '{\f0\fs18 \par}'#$D#$A,
    '{\f0\fs20 \par}'#$D#$A);
  SChr: array[0..9] of Integer = (2, 4, 5, 6, 7, 10, 11, 14, 15, 16);

  procedure CheckFont(F: TFont);
  var
    S: String;
  begin
    S := F.Name;
    if FontTable.IndexOf(S) = -1 then FontTable.Add(S);
    S := '\red' + IntToStr(GetRValue(Font.Color)) +
      '\green' + IntToStr(GetGValue(Font.Color)) +
      '\blue' + IntToStr(GetBValue(Font.Color)) + ';';
    if S = '\red255\green255\blue255;' then S := '\red0\green0\blue0;';
    if ColorTable.IndexOf(S) = -1 then ColorTable.Add(S);
  end;

  procedure AddSpaceLines(H: Integer);
  var
    I: Integer;
    S: String;
  begin
    I := 9;
    repeat
      while H >= SChr[I] do
        begin
          Dec(H, SChr[I]);
          S := Hchr[I];
          TempStream.Write(Utf8Encode(S)[1], Length(Utf8Encode(S)));
        end;
      Dec(I);
    until I = 0;
  end;

  function FontType(F: TFont): string;
  var
    Fs: String;
  begin
    Fs := '';
    if (fsItalic in F.Style) then Fs := '\i';
    if (fsBold in F.Style) then Fs := Fs + '\b';
    if (fsUnderline in F.Style) then Fs := Fs + '\u';
    Result := '\f' + IntToStr(FontTable.IndexOf(F.Name)) +
      '\fs' + IntToStr(F.Size * 2) + Fs;
    Fs := '\red' + IntToStr(GetRValue(Font.Color)) +
      '\green' + IntToStr(GetGValue(Font.Color)) +
      '\blue' + IntToStr(GetBValue(Font.Color)) + ';';
    if Fs = '\red255\green255\blue255;' then Fs := '\red0\green0\blue0;';
    Result := Result + '\cf' + IntToStr(ColorTable.IndexOf(Fs) + 1);
  end;

  function FontHeight(F: TFont): Integer;
  var
    DC: HDC;
    SaveFont: HFont;
    Metrics: TTextMetric;
  begin
    DC := GetDC(0);
    SaveFont := SelectObject(DC, F.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    ReleaseDC(0, DC);
    Result := Metrics.tmHeight + Metrics.tmExternalLeading;
  end;

  function Comp(A, L: Integer): string;
  var
    I: Integer;
  begin
    Result := IntToStr(A);
    for I := Length(Result) + 1 to L do
      Result := '0' + Result;
  end;

begin
  CheckFont(Font);
  if LastHeight = -1 then
    begin
      LastHeight := FontHeight(Font);
      LastY := Y;
      // Add space line.
      if (not DelInterline) and (Y - (TopMargin / StepXY) > 0) then
        AddSpaceLines(Round(Y - (TopMargin / StepXY)));
      // Add a new line.
      Tab.Clear;
      IntText.Clear;
    end
  else
    begin
      if Y <= Round(LastY + LastHeight / 2 - 1) then
        begin
          if Y + FontHeight(Font) > LastY + LastHeight then
            LastHeight :=(Y + FontHeight(Font) - 1) - LastY + 1;
        end
      else
        begin
          WriteLine;
          // Add space line.
          if (not DelInterline) and (Y - (LastY + LastHeight) > 0) then
            AddSpaceLines(Y - (LastY + LastHeight));
          // Add a new line.
          Tab.Clear;
          IntText.Clear;
          LastHeight := FontHeight(Font);
          LastY := Y;
        end;
    end;
  Tab.Add(Comp(X, 10) + '\tx' + IntToStr(Round(X * StepXY) - LeftMargin));
  IntText.Add(Comp(X, 10) + '{\tab' + FontType(Font) + ' ' + Text + '}');
end;

procedure TRichFilterForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_RichFltFormCaption;
  Group.Caption := FRConst_RichFltFrmGroupCaption;
  PageBreak.Caption := FRConst_RichFltFrmPageBrkCapt;
  KeepLines.Caption := FRConst_RichFltFrmKeepLinCapt;
  Label1.Caption := FRConst_RichFltFrmLabelCapt1;
  Label2.Caption := FRConst_RichFltFrmLabelCapt2;
  Label3.Caption := FRConst_RichFltFrmLabelCapt3;
  Label4.Caption := FRConst_RichFltFrmLabelCapt4;
  OK.Caption := FRConst_OK;
  Cancel.Caption := FRConst_Cancel;
end;

procedure TRichFilterForm.FormShow(Sender: TObject);
begin
  if CurReport.CanRebuild then
    begin
      Edit1.Text := IntToStr(Round(CurReport.Pages[0].pgMargins.Left / 3.8));
      Edit2.Text := IntToStr(Round(CurReport.Pages[0].pgMargins.Right / 3.8));
      Edit3.Text := IntToStr(Round(CurReport.Pages[0].pgMargins.Top / 3.8));
      Edit4.Text := IntToStr(Round(CurReport.Pages[0].pgMargins.Bottom / 3.8));
    end;
end;

initialization
  frRegisterExportFilter(TfrRichExportFilter,
    FRConst_RichFile + ' (*.Rtf)', '*.Rtf');

end.

