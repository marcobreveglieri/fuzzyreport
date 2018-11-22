
{*****************************************}
{                                         }
{             FastReport v2.2             }
{           Rich Add-In Object            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Rich;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, ComCtrls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ClipBrd,
  {$IFDEF RX_RICH}RxRichEd, {$ENDIF}RichEdit, DB, {$IFDEF Delphi2}
  DBTables, {$ENDIF}FR_Class;

type
  {$IFDEF RX_RICH}
  TRichType = TRxRichEdit;
  {$ELSE}
  TRichType = TRichEdit;
  {$ENDIF}

  TfrRichObject = class(TComponent) // fake component
  end;

  TfrRichView = class(TfrCustomMemoView)
  private
    Lines: array[0..9999] of Word;
    TotalLine, LastChar: Integer;
    Calc, ElabVar: Boolean;
    DrawRich: TRichType;
    procedure P1Click(Sender: TObject);
    procedure CalcHeightRich;
    function GetCalcExpr: Boolean;
    procedure SetCalcExpr(Value: Boolean);
  protected
    function ThetextHeight: Integer; override;
    procedure ExpandVariables; override;
  public
    RichEdit: TRichType;
    constructor Create(Rep: TfrReport); override;
    procedure Assign(From: TfrView); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure GetBlob(b: TField); override;
    procedure DefinePopupMenu(Popup: TPopupMenu); override;
    property CalcExpr: Boolean read GetCalcExpr write SetCalcExpr;
  end;

  TRichForm = class(TfrObjEditorForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SpeedBar: TPanel;
    OpenButton: TSpeedButton;
    SaveButton: TSpeedButton;
    UndoButton: TSpeedButton;
    Ruler: TPanel;
    FontDialog1: TFontDialog;
    FirstInd: TLabel;
    LeftInd: TLabel;
    RulerLine: TBevel;
    RightInd: TLabel;
    BoldButton: TSpeedButton;
    FontName: TComboBox;
    ItalicButton: TSpeedButton;
    LeftAlign: TSpeedButton;
    CenterAlign: TSpeedButton;
    RightAlign: TSpeedButton;
    UnderlineButton: TSpeedButton;
    BulletsButton: TSpeedButton;
    SpeedButton1: TSpeedButton;
    CancBtn: TSpeedButton;
    OkBtn: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    Edit1: TEdit;
    FontSize: TUpDown;

    procedure SelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure SelectFont(Sender: TObject);
    procedure RulerResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BoldButtonClick(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure AlignButtonClick(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure BulletsButtonClick(Sender: TObject);
    procedure RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RulerItemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RightIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CancBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FUpdating: Boolean;
    FDragOfs: Integer;
    FDragging: Boolean;
    RichEdit1: TRichType;
    function CurrText: {$IFDEF RX_RICH}
    TRxTextAttributes;
    {$ELSE}
    TTextAttributes;
    {$ENDIF}
    procedure GetFontNames;
    procedure SetupRuler;
    procedure SetEditRect;
  public
    procedure ShowEditor(t: TfrView); override;
  end;

procedure AssignRich(Rich1, Rich2: TRichType);
{$IFDEF RX_RICH}
procedure AssignRxRichToRich(SimpleRich: TRichEdit; RxRich: TRxRichEdit);
procedure AssignRichToRxRich(SimpleRich: TRichEdit; RxRich: TRxRichEdit);
{$ENDIF}

var
  ParentForm: TForm;
  ParentCount: Integer;

implementation

uses FR_Var, FR_Const;

const
  RulerAdj = 4 / 3;
  GutterWid = 6;
  flNoCalcExpr = 32768;

  {$R *.DFM}

  {$R Rich.res}

procedure AssignRich(Rich1, Rich2: TRichType);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  Rich2.Lines.SaveToStream(st);
  st.Position := 0;
  Rich1.Lines.LoadFromStream(st);
  st.Free;
end;

{$IFDEF RX_RICH}
procedure AssignRxRichToRich(SimpleRich: TRichEdit; RxRich: TRxRichEdit);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  RxRich.Lines.SaveToStream(st);
  st.Position := 0;
  SimpleRich.Lines.LoadFromStream(st);
  st.Free;
end;

procedure AssignRichToRxRich(SimpleRich: TRichEdit; RxRich: TRxRichEdit);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  SimpleRich.Lines.SaveToStream(st);
  st.Position := 0;
  RxRich.Lines.LoadFromStream(st);
  st.Free;
end;
{$ENDIF}

{----------------------------------------------------------------------------}
constructor TfrRichView.Create(Rep: TfrReport);
begin
  inherited;
  Inc(ParentCount);
  if ParentForm = nil then ParentForm := TForm.Create(nil);
  RichEdit := TRichType.Create(nil);
  RichEdit.BorderStyle := bsNone;
  RichEdit.Parent := ParentForm;
  RichEdit.Visible := False;
  DrawRich := TRichType.Create(nil);
  DrawRich.BorderStyle := bsNone;
  DrawRich.Parent := ParentForm;
  DrawRich.Visible := False;
  Calc := False;
  ElabVar := False;
end;

procedure TfrRichView.Assign(From: TfrView);
begin
  inherited Assign(From);
  AssignRich(RichEdit, (From as TfrRichView).RichEdit);
end;

destructor TfrRichView.Destroy;
begin
  RichEdit.Free;
  DrawRich.Free;
  Dec(ParentCount);
  if ParentCount = 0 then
    begin
      ParentForm.Free;
      ParentForm := nil;
    end;
  inherited Destroy;
end;

procedure TfrRichView.P1Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
begin
  with Sender as TMenuItem do
    begin
      Checked := not Checked;
      for i := 0 to frDesigner.Page.Objects.Count - 1 do
        begin
          t := frDesigner.Page.Objects[i];
          if t.Selected then
            t.Flags := (t.Flags and not flNoCalcExpr) + Word(Checked) * flNoCalcExpr;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrRichView.DefinePopupMenu(Popup: TPopupMenu);
var
  m: TMenuItem;
begin
  inherited DefinePopupMenu(Popup);
  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_NoCalcEsp;
  m.OnClick := P1Click;
  m.Checked := (Flags and flNoCalcExpr) <> 0;
  Popup.Items.Add(m)
end;

function TfrRichView.ThetextHeight: Integer;
var
  YY, YY1, I: Integer;
begin
  if TotalLine = 0 then
    Result := 2
  else
    if FromLine > 0 then
      Result := Lines[FromLine - 1]
    else
      begin
        YY := CurViewDy - FrameWidth;
        I := 0;
        YY1 := 0;
        while (I < TotalLine) and (YY1 < YY) do
          begin
            Inc(YY1, Lines[I]);
            Inc(I)
          end;
        if I > 1 then
          Result := Lines[I - 2]
        else
          Result := Lines[0]
      end;
  // To fill. Return the height of the current text line.
end;

procedure TfrRichView.CalcHeightRich;
var
  Sl, I, J, Hi: Integer;
  Font: TFont;
  Metrics: TTextMetric;
  Old: THandle;
  AddSpace: Boolean;
begin
  FillChar(Lines, SizeOf(Lines), #0);
  Sl := 0;
  Hi := 0;
  TotalLine := 0;
  Font := TFont.Create;
  AddSpace := False;
  for I := 0 to DrawRich.Lines.Count - 1 do
    begin
      if DrawRich.Lines[I] = '' then
        begin
          DrawRich.Lines[I] := ' ';
          AddSpace := True;
        end;
      for J := 0 to Length(DrawRich.Lines[I]) - 1 do
        begin
          DrawRich.SelStart := Sl + J;
          DrawRich.SelLength := 1;
          Font.Name := DrawRich.SelAttributes.Name;
          Font.Size := DrawRich.SelAttributes.Size;
          Font.Style := DrawRich.SelAttributes.Style;
          Old := SelectObject(Canvas.Handle, Font.Handle);
          GetTextMetrics(Canvas.Handle, Metrics);
          if (Metrics.tmHeight + Metrics.tmInternalLeading) > Lines[TotalLine] then
            Lines[TotalLine] := (Metrics.tmHeight + Metrics.tmInternalLeading);
          SelectObject(Canvas.Handle, Old);
        end;
      if AddSpace then
        begin
          DrawRich.Lines[I] := '';
          AddSpace := False;
        end;
      Hi := Hi + Lines[TotalLine];
      Sl := Sl + Length(DrawRich.Lines[I]);
      if Length(DrawRich.Text) >= Sl + 2 then
        if Copy(DrawRich.Text, Sl + 1, 2) = #13#10 then Inc(Sl, 2);
      Inc(TotalLine);
    end;
  Font.Free;
  if ((AutoStretch) or (Hi >= Height - FrameWidth)) and
    (DrawMode = drCalcHeight) then TotalHeight := Hi;
  Calc := True;
  FromLine := 0;
end;

procedure TfrRichView.ExpandVariables;
var
  I, J, Gap: Integer;
  Txt, VarNo, VarVal: string;
begin
  Gap := ((FrameWidth + 1) div 2) * 2;
  DrawRich.Width := Width - Gap;
  DrawRich.Height := Height - Gap;
  AssignRich(DrawRich, RichEdit);
  if ((Flags and flNoCalcExpr) <> 0) or (DocMode = dmDesigning) then Exit;
  DrawRich.SelStart := 0;
  DrawRich.SelLength := DrawRich.GetTextLen;
  Txt := DrawRich.SelText;
  repeat
    I := Pos('[', Txt);
    if I > 0 then
      begin
        J := Length(Txt);
        VarNo := GetBrackedVariable(Txt, I, J);
        if I <> J then
          begin
            CurReport.InternalOnGetValue(VarNo, VarVal);
            Delete(Txt, I, J - I + 1);
            Insert(VarVal, Txt, I);
            DrawRich.SelStart := I - 1;
            DrawRich.SelLength := J - I + 1;
            DrawRich.SelText := VarVal
          end
      end;
  until I = 0;
end;

procedure TfrRichView.Draw(Canvas: TCanvas);

  procedure ShowRich(Design: Boolean);
  var
    Range: TFormatRange;
    LogX, H, Hi: Integer;
    Old_H: THandle;

    function DrawX(Rich: TRichType; R: TFormatRange): Integer;
    var
      EMF: TMetaFile;
      EMFC: TMetaFileCanvas;

      function CustomEnhMetaFileProc(DC: HDC; HandleTable: PHandleTable;
        MyEnhMetaRecord: PEnhMetaRecord;
        nObj: Integer; LParam: Pointer): Bool; stdcall;
      var
        E: PEMRExtTextOut;
      begin
        Result := True;
        if MyEnhMetaRecord.iType = 18 then
          SetBKMode(DC, Transparent)
        else
          if MyEnhMetaRecord.iType in [83, 84] then
            begin
              E := PEMRExtTextOut(MyEnhMetaRecord);
              E^.emrtext.fOptions := E^.emrtext.fOptions and (MaxInt - ETO_OPAQUE);
            end;
        PlayEnhMetafileRecord(DC, HandleTable^, MyEnhMetaRecord^, nObj);
      end;

    begin
      if Color <> clNone then
        Result := Rich.Perform(EM_FORMATRANGE, 1, Longint(@R))
      else
        begin
          EMF := TMetaFile.Create;
          EMF.Width := ((DRect.Right - 1) - (DRect.Left + 1) - 1);
          EMF.Height := ((DRect.Bottom - 1) - (DRect.Top + 1) - 1);
          EMFC := TMetaFileCanvas.Create(EMF, 0);
          R.hdc := EMFC.Handle;
          R.hdcTarget := R.hdc;
          Result := Rich.Perform(EM_FORMATRANGE, 1, Longint(@R));
          EMFC.Free;
          EnumEnhMetafile(Canvas.Handle, EMF.Handle, @CustomEnhMetaFileProc,
            nil, Rect(0, 0, EMF.Width, EMF.Height));
          EMF.Free;
        end;
    end;

  begin
    FillChar(Range, SizeOf(TFormatRange), 0);
    with Range do
      begin
        LogX := Screen.PixelsPerInch;
        hdc := Canvas.Handle;
        hdcTarget := hdc;
        rcPage := rc;
        chrg.cpMax := -1;
        H := 0;
        if (Design) or (not AutoStretch) or
          ((Parent <> nil) and (not Parent.Stretched)) then
          begin
            if not Design then
              begin
                Memo1.Assign(Memo);
                CurReport.InternalOnEnterRect(Memo1, Self);
                ExpandVariables;
              end;
            Old_H := SelectObject(Canvas.Handle, Canvas.Font.Handle);
            if Design then
              if Color = clNone then
                RichEdit.Color := clWhite
              else
                RichEdit.Color := Color
            else
              if Color <> clNone then DrawRich.Color := Color;
            if ((Color = clNone) and (Design)) or (Color <> clNone) then
              begin
                if Color <> clNone then
                  Canvas.Brush.Color := Color
                else
                  Canvas.Brush.Color := clWhite;
                Canvas.FillRect(Rect(Left, Top, Left + Width + 1, Top + Height));
              end;
            chrg.cpMin := 0;
            rc := Rect((DRect.Left + 1) * 1440 div LogX, (DRect.Top + 1) * 1440 div LogX,
              (DRect.Right - 1) * 1440 div LogX, (DRect.Bottom - 1) * 1440 div LogX);
            if Design then
              begin
                RichEdit.Perform(EM_FORMATRANGE, 1, Longint(@Range));
                RichEdit.Perform(EM_FORMATRANGE, 0, 0);
              end
            else
              begin
                DrawX(DrawRich, Range);
                DrawRich.Perform(EM_FORMATRANGE, 0, 0);
              end;
            SelectObject(Canvas.Handle, Old_H);
          end
        else
          begin
            Old_H := SelectObject(Canvas.Handle, Canvas.Font.Handle);
            repeat
              Hi := Lines[FromLine];
              chrg.cpMin := LastChar;
              if (not DisableDrawing) then
                begin
                  if Color <> clNone then
                    begin
                      Canvas.Brush.Color := Color;
                      Canvas.FillRect(Rect(DRect.Left, DRect.Top + H,
                        DRect.Right + 2, DRect.Top + H + Hi + 2));
                    end;
                  rc := Rect((DRect.Left + 1) * 1440 div LogX, (DRect.Top + H + 1) * 1440 div LogX,
                    (DRect.Right - 1) * 1440 div LogX, (DRect.Top + H + Hi + 1) * 1440 div LogX);
                  LastChar := DrawX(DrawRich, Range);
                end;
              Inc(FromLine);
              H := H + Hi;
            until (FromLine = TotalLine) or
              (DRect.Top + H + Lines[FromLine] > DRect.Bottom);
            DrawRich.Perform(EM_FORMATRANGE, 0, 0);
            SelectObject(Canvas.Handle, Old_H);
            if DrawMode <> drAll then Height := H + ((FrameWidth + 1) div 2) * 2;
            TotalHeight := TotalHeight - H;
          end;
      end;
  end;

begin
  if (DocMode = dmPrinting) and (not Visible) then Exit;
  if DocMode = dmDesigning then
    begin
      BeginDraw(Canvas);
      CalcGaps;
      ShowRich(True);
      ShowFrame;
    end
  else
    if (DrawMode in [drCalcHeight, drAfterCalcHeight]) and
      (DrawRich.Lines.Count = 0) then
      begin
        if DrawMode = drAfterCalcHeight then
          begin
            BeginDraw(Canvas);
            CalcGaps;
            ShowBackGround;
            ShowFrame;
          end;
      end
    else
      begin
        BeginDraw(Canvas);
        DRect := Rect(Left + (FrameWidth + 1) div 2, Top + (FrameWidth + 1) div 2,
          Left + Width - (FrameWidth + 1) div 2, Top + Height + (FrameWidth + 1) div 2);
        if DrawMode in [drAll, drCalcHeight] then
          begin
            if not ElabVar then
              begin
                Memo1.Assign(Memo);
                CurReport.InternalOnEnterRect(Memo1, Self);
                ExpandVariables;
                ElabVar := True;
              end;
            if not Calc then CalcHeightRich;
          end;

        if ((DrawMode = drCalcHeight) and (AutoStretch)) then
          Height := TotalHeight;

        if (DrawMode <> drCalcHeight) and (not DisableDrawing) then
          begin
            if FromLine = 0 then LastChar := 0;
            ShowRich(False);
            ShowFrame;
          end;

        if ((DrawMode in [drAll, drAfterCalcHeight]) or (TotalLine = FromLine)) or
          ((DrawMode = drCalcHeight) and (DisableDrawing)) then
          begin
            ElabVar := False;
            Calc := False;
          end;
      end;
  if not Visible then
    begin
      Canvas.Pen.Color := ClRed;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(Left, Top);
      Canvas.LineTo(Left + Width, Top + Height);
      Canvas.MoveTo(Left + Width, Top);
      Canvas.LineTo(Left, Top + Height);
    end;
end;

procedure TfrRichView.LoadFromStream(Stream: TStream);
var
  b: Byte;
  n: Integer;
begin
  inherited LoadFromStream(Stream);
  Stream.Read(b, 1);
  Stream.Read(n, 4);
  if b <> 0 then RichEdit.Lines.LoadFromStream(Stream);
  Stream.Seek(n, soFromBeginning)
end;

procedure TfrRichView.SaveToStream(Stream: TStream);
var
  b: Byte;
  n, o: Integer;
begin
  inherited SaveToStream(Stream);
  b := 0;
  if RichEdit.Lines.Count <> 0 then b := 1;
  Stream.Write(b, 1);
  n := Stream.Position;
  Stream.Write(n, 4);
  if b <> 0 then RichEdit.Lines.SaveToStream(Stream);
  o := Stream.Position;
  Stream.Seek(n, soFromBeginning);
  Stream.Write(o, 4);
  Stream.Seek(0, soFromEnd);
end;

procedure TfrRichView.GetBlob(b: TField);
var
  s: TMemoryStream;
begin
  s := TMemoryStream.Create;
  (b as TBlobField).SaveToStream(s);
  s.Position := 0;
  RichEdit.Lines.LoadFromStream(s);
  s.Free;
end;

function TfrRichView.GetCalcExpr: Boolean;
begin
  Result := (Flags and flStretched) > 0;
end;

procedure TfrRichView.SetCalcExpr(Value: Boolean);
begin
  Flags := (Flags and not flNoCalcExpr) or Integer(Value) * flNoCalcExpr;
end;

{------------------------------------------------------------------------}
procedure TRichForm.ShowEditor(t: TfrView);
begin
  if (t as TfrRichView).RichEdit.Lines.Count = 0 then
    begin
      (t as TfrRichView).RichEdit.DefAttributes.Name := 'Arial';
      (t as TfrRichView).RichEdit.DefAttributes.Size := 10;
    end;
  AssignRich(RichEdit1, (t as TfrRichView).RichEdit);
  if ShowModal = mrOk then AssignRich((t as TfrRichView).RichEdit, RichEdit1);
  RichEdit1.Lines.Clear;
end;

procedure TRichForm.SelectionChange(Sender: TObject);
begin
  with RichEdit1.Paragraph do
  try
    FUpdating := True;
    FirstInd.Left := Trunc(FirstIndent * RulerAdj) - 4 + GutterWid;
    LeftInd.Left := Trunc((LeftIndent + FirstIndent) * RulerAdj) - 4 + GutterWid;
    RightInd.Left := Ruler.ClientWidth - 6 - Trunc((RightIndent + GutterWid) * RulerAdj);
    BoldButton.Down := fsBold in RichEdit1.SelAttributes.Style;
    ItalicButton.Down := fsItalic in RichEdit1.SelAttributes.Style;
    UnderlineButton.Down := fsUnderline in RichEdit1.SelAttributes.Style;
    BulletsButton.Down := Boolean(Numbering);
    FontSize.Position := RichEdit1.SelAttributes.Size;
    FontName.Text := RichEdit1.SelAttributes.Name;
    case Ord(Alignment) of
      0: LeftAlign.Down := True;
      1: RightAlign.Down := True;
      2: CenterAlign.Down := True;
    end;
  finally
    FUpdating := False;
  end;
end;

function TRichForm.CurrText: {$IFDEF RX_RICH}
TRxTextAttributes;
{$ELSE}
TTextAttributes;
{$ENDIF}
begin
  if RichEdit1.SelLength > 0 then
    Result := RichEdit1.SelAttributes
  else
    Result := RichEdit1.DefAttributes;
end;

procedure TRichForm.GetFontNames;
begin
  FontName.Items := Screen.Fonts;
  FontName.Sorted := True;
end;

procedure TRichForm.SetupRuler;
var
  I: Integer;
  S: string;
begin
  SetLength(S, 201);
  I := 1;
  while I < 200 do
    begin
      S[I] := #9;
      S[I + 1] := '|';
      Inc(I, 2);
    end;
  Ruler.Caption := S;
end;

procedure TRichForm.SetEditRect;
var
  R: TRect;
begin
  with RichEdit1 do
    begin
      R := Rect(GutterWid, 0, ClientWidth - GutterWid, ClientHeight);
      SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
    end;
end;

{ Event Handlers }

procedure TRichForm.FormCreate(Sender: TObject);
begin
  RichEdit1 := TRichType.Create(Self);
  RichEdit1.Parent := Self;
  RichEdit1.Left := 0;
  RichEdit1.Top := 60;
  RichEdit1.Align := alClient;
  RichEdit1.OnSelectionChange := SelectionChange;
  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  GetFontNames;
  SetupRuler;
  SelectionChange(Self);

  Caption := FRConst_RichFormCaption;
  OpenButton.Hint := FRConst_RichFormOpenButtonHint;
  SaveButton.Hint := FRConst_RichFormSaveButtonHint;
  UndoButton.Hint := FRConst_RichFormUndoButtonHint;
  BoldButton.Hint := FRConst_RichFormBoldButtonHint;
  ItalicButton.Hint := FRConst_RichFormItalicButtHint;
  LeftAlign.Hint := FRConst_RichFormLeftAlignHint;
  CenterAlign.Hint := FRConst_RichFormCenterAligHint;
  RightAlign.Hint := FRConst_RichFormRightAlignHint;
  UnderlineButton.Hint := FRConst_RichFormUnderBtnHint;
  BulletsButton.Hint := FRConst_RichFormBulletsBtnHint;
  SpeedButton1.Hint := FRConst_RichFormSpeedBtnHint1;
  CancBtn.Hint := FRConst_RichFormCancBtnHint;
  OKBtn.Hint := FRConst_RichFormOkBtnHint;
  SpeedButton2.Caption := FRConst_RichFormSpeedBtnCapt2;
  SpeedButton2.Hint := FRConst_RichFormSpeedBtnHint2;
  FOntName.Hint := FRConst_RichFormFontNameHint;
  Edit1.Hint := FRConst_RichFormEditHint1;
  FontSize.Hint := FRConst_RichFormFontSizeHint;
end;

procedure TRichForm.FormResize(Sender: TObject);
begin
  SetEditRect;
  SelectionChange(Sender);
end;

procedure TRichForm.FormPaint(Sender: TObject);
begin
  SetEditRect;
end;

procedure TRichForm.FileOpen(Sender: TObject);
begin
  OpenDialog.Filter := FRConst_RTFFile + ' (*.rtf)|*.rtf';
  if OpenDialog.Execute then
    begin
      RichEdit1.Lines.LoadFromFile(OpenDialog.FileName);
      RichEdit1.SetFocus;
      SelectionChange(Self);
    end;
end;

procedure TRichForm.FileSaveAs(Sender: TObject);
begin
  SaveDialog.Filter := FRConst_RTFFile + ' (*.rtf)|*.rtf|' +
    FRConst_TextFile + ' (*.txt)|*.txt';
  if SaveDialog.Execute then
    RichEdit1.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TRichForm.EditUndo(Sender: TObject);
begin
  with RichEdit1 do
    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TRichForm.SelectFont(Sender: TObject);
begin
  FontDialog1.Font.Assign(RichEdit1.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  RichEdit1.SetFocus;
end;

procedure TRichForm.RulerResize(Sender: TObject);
begin
  RulerLine.Width := Ruler.ClientWidth - (RulerLine.Left * 2);
end;

procedure TRichForm.BoldButtonClick(Sender: TObject);
var
  s: TFontStyles;
begin
  if FUpdating then Exit;
  s := [];
  if BoldButton.Down then s := s + [fsBold];
  if ItalicButton.Down then s := s + [fsItalic];
  if UnderlineButton.Down then s := s + [fsUnderline];
  CurrText.Style := s;
end;

procedure TRichForm.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Size := FontSize.Position;
end;

procedure TRichForm.AlignButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  {$IFDEF RX_RICH}
  RichEdit1.Paragraph.Alignment := TParaAlignment(TControl(Sender).Tag);
  {$ELSE}
  RichEdit1.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
  {$ENDIF}
end;

procedure TRichForm.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.Items[FontName.ItemIndex];
end;

procedure TRichForm.BulletsButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  {$IFDEF RX_RICH}
  RichEdit1.Paragraph.Numbering := TRxNumbering(BulletsButton.Down);
  {$ELSE}
  RichEdit1.Paragraph.Numbering := TNumberingStyle(BulletsButton.Down);
  {$ENDIF}
end;

{ Ruler Indent Dragging }

procedure TRichForm.RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragOfs := (TLabel(Sender).Width div 2);
  TLabel(Sender).Left := TLabel(Sender).Left + X - FDragOfs;
  FDragging := True;
end;

procedure TRichForm.RulerItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDragging then
    TLabel(Sender).Left := TLabel(Sender).Left + X - FDragOfs
end;

procedure TRichForm.FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  RichEdit1.Paragraph.FirstIndent := Trunc((FirstInd.Left + FDragOfs - GutterWid) / RulerAdj);
  LeftIndMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TRichForm.LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  RichEdit1.Paragraph.LeftIndent := Trunc((LeftInd.Left + FDragOfs - GutterWid) / RulerAdj) - RichEdit1.Paragraph.FirstIndent;
  SelectionChange(Sender);
end;

procedure TRichForm.RightIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  RichEdit1.Paragraph.RightIndent := Trunc((Ruler.ClientWidth - RightInd.Left + FDragOfs - 2) / RulerAdj) - 2 * GutterWid;
  SelectionChange(Sender);
end;

procedure TRichForm.CancBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TRichForm.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TRichForm.SpeedButton2Click(Sender: TObject);
begin
  VarForm := TVarForm.Create(nil);
  with VarForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        if Variables.ItemIndex >= 0 then
          ClipBoard.AsText := '[' + Variables.Items[Variables.ItemIndex] + ']';
        RichEdit1.PasteFromClipboard;
      end;
  VarForm.Free;
end;

procedure TRichForm.FormActivate(Sender: TObject);
begin
  RichEdit1.SetFocus;
  Edit1.OnChange := FontSizeChange
end;

var
  Bmp: TBitMap;

procedure TRichForm.FormDestroy(Sender: TObject);
begin
  RichEdit1.Free;
end;

initialization
  {$IFDEF RX_RICH}
    RegisterClass(TRxRichEdit);
  {$ELSE}
    RegisterClass(TRichEdit);
  {$ENDIF}
  Bmp := TBitmap.Create;
  Bmp.Handle := LoadBitmap(HInstance, 'RICHBITMAP');
  frRegisterObject(TfrRichView, Bmp, FRConst_InsRichObject, TRichForm);
  ParentCount := 0;
  ParentForm := nil;

finalization
  Bmp.Free;

end.

