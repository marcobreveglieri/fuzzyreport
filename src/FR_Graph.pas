{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit Fr_Graph;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Class, FR_Const, Buttons, Grids,
  Variants;

type
  TfrGraphType = (Istograms, Istograms_Lines, Triangles, Triangles_Lines, Points,
    Points_Lines, Lines);

  TfrGraphObject = class(TComponent) // fake component
  end;

  TfrGraphView = class(TfrView)
  protected
    function GetLinkToDataSet: Boolean; override;
  public
    XTitle, YTitle, FieldsTitle, GraphTitle: ShortString;
    LegendView, TitleView, XView, YView: Boolean;
    GraphType: TfrGraphType;
    FormatY: ShortString;
    constructor Create(Rep: TfrReport); override;
    destructor Destroy; override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

  TFrGraphEditor = class(TfrObjEditorForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    SlctDS: TSpeedButton;
    GroupBox1: TGroupBox;
    GNew: TSpeedButton;
    GDel: TSpeedButton;
    DrawGrid1: TDrawGrid;
    GMod: TSpeedButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Panel3: TPanel;
    E3: TSpeedButton;
    Edit4: TEdit;
    Options: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    Label5: TLabel;
    ComboBox2: TComboBox;
    Label6: TLabel;
    procedure SlctDSClick(Sender: TObject);
    procedure GNewClick(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: {$IFDEF Delphi2}
      Longint; {$ELSE}Integer; {$ENDIF}
      Rect: TRect; State: TGridDrawState);
    procedure GDelClick(Sender: TObject);
    function GetItem(Cl, Rw: Integer): string;
    procedure FormShow(Sender: TObject);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure E3Click(Sender: TObject);
    procedure DrawGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  public
    Obj: TfrView;
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

{$R frGraph.dcr}

{$R *.DFM}

{$R Graph.res}

uses Fr_BndEd, FR_GrFld, Fr_Expr, edExpr, DB;

var
  Mem: TStringList;
  DS: TfrDataSet;
  OldDS: string;

  //---------------------- DEFINE GRAPH -----------------//
function TfrGraphView.GetLinkToDataSet: Boolean;
begin
  Result := True;
end;

constructor TfrGraphView.Create(Rep: TfrReport);
begin
  inherited;
  XTitle := '';
  YTitle := '';
  GraphTitle := '';
  FieldsTitle := '';
  LegendView := True;
  TitleView := True;
  XView := True;
  YView := True;
  GraphType := Istograms;
  FormatY := '';
end;

destructor TfrGraphView.Destroy;
var
  I: Integer;
  D: TfrDataSet;
begin
  if (FormatStr <> '') and (CurReport <> nil) then
    if CurReport.DataSetList.Find(FormatStr, I) then
      begin
        D := TfrDataSet(CurReport.DataSetList.Objects[I]);
        if D.Owner = nil then
          D.Free
        else
          CurReport.DataSetList.Delete(I);
      end;
  inherited;
end;

procedure TfrGraphView.Assign(From: TfrView);
begin
  inherited Assign(From);
  XTitle := TfrGraphView(From).XTitle;
  YTitle := TfrGraphView(From).YTitle;
  FieldsTitle := TfrGraphView(From).FieldsTitle;
  GraphTitle := TfrGraphView(From).GraphTitle;
  LegendView := TfrGraphView(From).LegendView;
  TitleView := TfrGraphView(From).TitleView;
  XView := TfrGraphView(From).XView;
  YView := TfrGraphView(From).YView;
  GraphType := TfrGraphView(From).GraphType;
  FormatY := TfrGraphView(From).FormatY;
end;

procedure TFrGraphView.Draw(Canvas: TCanvas);
const
  Frm: array[0..4] of string[10] = ('0.##', '0.00', '0,.##', '0,.00', '0,');
var
  I, J, L, Width1, Height1, Left1, Top1, NFlds,
    MaxX, MinX, X1, Y1, W1, H1, Y, MaxY, K, MaxL, TY, XY, YX: Integer;
  OldF, NewF: HFont;
  ValF: array[0..9, 0..499] of Double;
  LegF: array[0..9] of string;
  TitF: array[0..499] of string;
  Ordn: array[0..21] of string;
  DS: TfrDataSet;
  Max, Min, St, X, Sd: Double;
  S: string;
  R: TRect;
  Trngl: array[0..3] of TPoint;
  Old: Byte;

  function Create90Font(Font: TFont): HFont;
  var
    F: TLogFont;
  begin
    GetObject(Font.Handle, SizeOf(TLogFont), @F);
    F.lfEscapement := 900;
    F.lfOrientation := 900;
    Result := CreateFontIndirect(F);
  end;

  procedure CheckDSEvent(FrDS: TfrDataSet; Operation: TfrDataSetOperation);
  var
    RecCount: Integer;
    Ds: TDataSet;
  begin
    if Assigned(CurReport.OnDataSetWork) then
      begin
        if FrDS is TfrDBDataSet then
          Ds := TfrDBDataSet(FrDS).DataSet
        else
          Ds := nil;
        RecCount := FrDS.RangeEndCount;
        CurReport.OnDataSetWork(String(Name), Ds, RecCount, Operation);
        FrDS.RangeEndCount := RecCount;
      end;
  end;

begin
  if (DocMode = dmPrinting) and (not Visible) then Exit;
  if DisableDrawing then Exit;
  BeginDraw(Canvas);
  CalcGaps;
  with Canvas do
    begin
      ShowBackground;
      if DocMode = dmPrinting then
        begin
          if FormatStr <> '' then
            begin
              if ParentReport.DataSetList.Find(FormatStr, I) then
                begin
                  Font.Name := 'Arial';
                  Font.Style := [];
                  Font.Color := clNavy;
                  if TitleView then
                    begin
                      Font.Size := 16;
                      TY := TextHeight(String(GraphTitle)) + 1;
                      S := String(GraphTitle);
                      R.Left := Left + 1;
                      R.Top := Top + 1;
                      R.Right := Left + Width + 1;
                      R.Bottom := R.Top + TY + 1;
                      DrawText(Handle, PChar(S), Length(S), R, DT_CENTER or DT_VCENTER);
                    end
                  else
                    TY := 0;
                  if XView then
                    begin
                      Font.Size := 10;
                      XY := TextHeight(String(YTitle)) + 2;
                      S := String(XTitle);
                      R.Left := Left + 1;
                      R.Top := Top + Height - XY;
                      R.Right := Left + Width + 1;
                      R.Bottom := Top + Height - 1;
                      DrawText(Handle, PChar(S), Length(S), R, DT_CENTER or DT_VCENTER);
                    end
                  else
                    XY := 0;
                  if YView then
                    begin
                      Font.Size := 10;
                      NewF := Create90Font(Font);
                      OldF := SelectObject(Handle, NewF);
                      YX := TextHeight(String(XTitle)) + 2;
                      S := String(YTitle);
                      R.Left := Left + 2;
                      R.Top := Top + 1;
                      R.Right := Left + YX + 1;
                      R.Bottom := Top + Height - 1;
                      TextRect(R, R.Left, R.Top + Height - (Height - TextWidth(S)) div 2, S);
                      SelectObject(Handle, OldF);
                      DeleteObject(NewF);
                    end
                  else
                    YX := 0;
                  DS := TfrDataSet(ParentReport.DataSetList.Objects[I]);
                  I := 0;
                  Max := -MaxInt;
                  Min := MaxInt;
                  NFlds := Memo.Count div 3;
                  DS.Init;
                  CheckDSEvent(DS, opInit);
                  DS.First;
                  CheckDSEvent(DS, opFirst);
                  for J := 0 to NFlds - 1 do
                    if Memo[J * 3 + 2] <> '' then
                      LegF[J] := VarToStr(Calc(Memo[J * 3 + 2]))
                    else
                      LegF[J] := '';
                  while not DS.EOF do
                    begin
                      for J := 0 to NFlds - 1 do
                        begin
                          ValF[J, I] := Calc(Memo[J * 3]);
                          if ValF[J, I] > Max then Max := ValF[J, I];
                          if ValF[J, I] < Min then Min := ValF[J, I];
                          if J = 0 then
                            if FieldsTitle <> '' then
                              TitF[I] := VarToStr(Calc(String(FieldsTitle)))
                            else
                              TitF[I] := '';
                        end;
                      Inc(I);
                      DS.Next;
                      CheckDSEvent(DS, opNext);
                    end;
                  DS.Exit;
                  CheckDSEvent(DS, opExit);
                  if Min > 0 then Min := 0;
                  if Max < 0 then Max := 0;
                  Font.Size := 7;
                  Sd := (Max - Min) / 20;
                  MaxX := 0;
                  for J := 0 to 20 do
                    begin
                      if FormatY = '' then
                        S := IntToStr(Round(Min + Sd * J))
                      else
                        if FormatY[1] = '[' then
                          case Ord(FormatY[2]) - 49 of
                            0:
                              begin
                                Old := FormatSettings.NegCurrFormat;
                                FormatSettings.NegCurrFormat := 12;
                                S := SysUtils.Format('%m', [Min + Sd * J]);
                                FormatSettings.NegCurrFormat := Old;
                              end;
                            1: S := '€ ' + FloatToStrF(ROUND((Min + Sd * J) / MoneyToEuro *
                                100) / 100, ffNumber, 10, 2);
                            2..7: s := FormatFloat(String(Frm[Ord(FormatY[2]) - 51]), Min + Sd * J);
                          end
                        else
                          S := FormatFloat(String(FormatY), Min + Sd * J);
                      MinX := TextWidth(S);
                      if MinX > MaxX then MaxX := MinX;
                      Ordn[J] := S;
                    end;
                  MaxL := 0;
                  if LegendView then
                    begin
                      for J := 0 to NFlds - 1 do
                        begin
                          if Length(LegF[J]) > 20 then
                            LegF[J] := Copy(LegF[J], 1, 19) + '.';
                          Y := TextWidth(LegF[J]);
                          if Y > MaxL then MaxL := Y;
                        end;
                      if MaxL > 0 then Inc(MaxL, 18);
                    end;
                  MinX := TextHeight('1') div 2;
                  NewF := Create90Font(Font);
                  OldF := SelectObject(Handle, NewF);
                  MaxY := 0;
                  for J := 0 to I - 1 do
                    begin
                      if Length(TitF[J]) > 12 then
                        TitF[J] := Copy(TitF[J], 1, 11) + '.';
                      Y := TextWidth(TitF[J]);
                      if Y > MaxY then MaxY := Y;
                    end;
                  if MaxY > 0 then Inc(MaxY, TY - 5);
                  if MaxX > 0 then Inc(MaxX, 5);
                  X1 := Left + MaxX + YX;
                  Y1 := Top + TY + 1;
                  H1 := Height - MaxY - XY - 1;
                  Height1 := H1 - 20 - 3;
                  Left1 := X1 + 3;
                  Top1 := Y1 + (H1 - Height1) div 2 - 1;
                  W1 := Width - (X1 - Left) + 1 - MaxL;
                  Width1 := W1 - 10 - 3;
                  if (Max <> 0) or (Min <> 0) then
                    begin
                      St := Height1 / (Max - Min);
                      X := Width1 / (I * (NFlds * 2) + I - 1);
                      Y := TextHeight('1') div 2;
                      K := NFlds * 2 + 1;
                      for J := 0 to I - 1 do
                        begin
                          TextOut(Left1 + Round((J * K + NFlds) * X) - Y,
                            Top1 + Round((Max - Min) * St) + 9 + TextWidth(TitF[J]) - 3, TitF[J]);
                        end;
                      SelectObject(Handle, OldF);
                      DeleteObject(NewF);
                      if (LegendView) and (MaxL > 0) then
                        begin
                          Y := TextHeight('1') div 2;
                          K := Top + (H1 - (14 * NFlds)) div 2;
                          Brush.Color := clWhite;
                          Rectangle(Left + Width - MaxL + 3, K,
                            Left + Width - 1, K + (14 * Nflds) + 1);
                          for J := 0 to Nflds - 1 do
                            begin
                              Brush.Color := Calc(Memo[J * 3 + 1]);
                              Rectangle(Left + Width - MaxL + 5, K + J * 14 + 2,
                                Left + Width - MaxL + 15, K + J * 14 + 13);
                            end;
                          Brush.Style := bsClear;
                          for J := 0 to Nflds - 1 do
                            TextOut(Left + Width - MaxL + 17, K + J * 14 + 8 - Y, LegF[J]);
                        end;
                      Pen.Style := psDot;
                      Pen.Color := clGray;
                      Brush.Style := bsClear;
                      for J := 0 to 20 do
                        begin
                          if Round(Min + Sd * J) < 0 then
                            Y := 2
                          else
                            Y := 0;
                          TextOut(Left - 3 + (MaxX - TextWidth(Ordn[J])) + YX,
                            Top1 + Round((Max - Min) * St) - Round(Sd * St * J) - MinX + Y,
                            Ordn[J]);
                          MoveTo(X1, Top1 + Round((Max - Min) * St) - Round(Sd * St * J) + Y);
                          LineTo(X1 + W1 - 1, Top1 + Round((Max - Min) * St) - Round(Sd * St * J) + Y);
                        end;
                      Pen.Style := psSolid;
                      Pen.Color := clBlack;
                      for J := 0 to 2 do
                        begin
                          MoveTo(X1 + J, Y1 + Integer((J <> 1)));
                          LineTo(X1 + J, Y1 + H1 - Integer((J <> 1)));
                          MoveTo(X1 + Integer((J <> 1)), Top1 + Round(Max * St) + J);
                          LineTo(X1 - Integer((J <> 1)) + W1, Top1 + Round(Max * St) + J);
                        end;
                      if I > 0 then
                        begin
                          X := Width1 / (I * (NFlds * 2) + I - 1);
                          K := NFlds * 2 + 1;
                          for L := 0 to NFlds - 1 do
                            begin
                              Brush.Color := Calc(Memo[L * 3 + 1]);
                              for J := 0 to I - 1 do
                                begin
                                  if ValF[L, J] < 0 then
                                    Y := 3
                                  else
                                    Y := 0;
                                  if (GraphType = Istograms) or
                                    (GraphType = Istograms_Lines) then
                                    Rectangle(Left1 + Round((J * K + (L * 2)) * X),
                                      Top1 + Round(Max * St) - Round(ValF[L, J] * St) + Y,
                                      Left1 + Round((J * K + (L * 2) + 2) * X) + 1, Top1 + Round(Max * St) + Y);
                                  if (GraphType = Triangles) or
                                    (GraphType = Triangles_Lines) then
                                    begin
                                      Trngl[0].X := Left1 + Round((J * K + (L * 2)) * X);
                                      Trngl[0].Y := Top1 + Round(Max * St) + Y;
                                      Trngl[1].X := Left1 + Round((J * K + (L * 2) + 2) * X) + 1;
                                      Trngl[1].Y := Top1 + Round(Max * St) + Y;
                                      Trngl[2].X := (Trngl[0].X + Trngl[1].X) div 2;
                                      Trngl[2].Y := Top1 + Round(Max * St) - Round(ValF[L, J] * St) + Y;
                                      Windows.Polygon(Handle, Trngl, 3);
                                    end;
                                  if (GraphType = Lines) or
                                    (GraphType = Points_Lines) then
                                    if J < I - 1 then
                                      begin
                                        Pen.Width := 3;
                                        Pen.Color := Brush.Color;
                                        MoveTo((Left1 + Round((J * K + (L * 2)) * X) +
                                          Left1 + Round((J * K + (L * 2) + 2) * X) + 1) div 2,
                                          Top1 + Round(Max * St) - Round(ValF[L, J] * St) + Y);
                                        LineTo((Left1 + Round(((J + 1) * K + (L * 2)) * X) +
                                          Left1 + Round(((J + 1) * K + (L * 2) + 2) * X) + 1) div 2,
                                          Top1 + Round(Max * St) - Round(ValF[L, (J + 1)] * St) + Y);
                                        Pen.Width := 1;
                                        Pen.Color := ClBlack;
                                      end;
                                  if (GraphType = Points) or (GraphType = Points_Lines) then
                                    begin
                                      Rectangle((Left1 + Round((J * K + (L * 2)) * X) +
                                        Left1 + Round((J * K + (L * 2) + 2) * X) + 1) div 2 - 3,
                                        Top1 + Round(Max * St) - Round(ValF[L, J] * St) + Y - 3,
                                        (Left1 + Round((J * K + (L * 2)) * X) +
                                        Left1 + Round((J * K + (L * 2) + 2) * X) + 1) div 2 + 3,
                                        Top1 + Round(Max * St) - Round(ValF[L, J] * St) + Y + 3);
                                    end;
                                end;
                            end;
                          if (GraphType = Istograms_Lines) or
                            (GraphType = Triangles_Lines) then
                            for L := 0 to NFlds - 1 do
                              begin
                                Pen.Width := 3;
                                for J := 0 to I - 1 do
                                  begin
                                    if ValF[L, J] < 0 then
                                      Y := 3
                                    else
                                      Y := 0;
                                    if J < I - 1 then
                                      begin
                                        MoveTo((Left1 + Round((J * K + (L * 2)) * X) +
                                          Left1 + Round((J * K + (L * 2) + 2) * X) + 1) div 2,
                                          Top1 + Round(Max * St) - Round(ValF[L, J] * St) + Y);
                                        LineTo((Left1 + Round(((J + 1) * K + (L * 2)) * X) +
                                          Left1 + Round(((J + 1) * K + (L * 2) + 2) * X) + 1) div 2,
                                          Top1 + Round(Max * St) - Round(ValF[L, (J + 1)] * St) + Y);
                                      end;
                                  end;
                                Pen.Width := 1;
                              end;
                        end;
                    end;
                end
            end;
          ShowFrame;
        end
      else
        begin
          ShowFrame;
          I := SaveDC(Handle);
          Pen.Style := psSolid;
          Pen.Color := clBlack;
          Pen.Width := 3;
          SetMapMode(Handle, MM_ANISOTROPIC);
          SetWindowExtEx(Handle, 920, 500, nil);
          SetViewPortExtEx(Handle, Width, Height, nil);
          SetViewPortOrgEx(Handle, Left, Top, nil);
          MoveTo(100, 20);
          LineTo(100, 480);
          MoveTo(20, 400);
          LineTo(900, 400);
          Pen.Width := 1;
          Brush.Color := clBlue;
          Rectangle(150, 200, 250, 400);
          Brush.Color := clRed;
          Rectangle(300, 100, 400, 400);
          Brush.Color := clGreen;
          Rectangle(450, 300, 550, 400);
          Brush.Color := clMaroon;
          Rectangle(600, 250, 700, 400);
          Brush.Color := clAqua;
          Rectangle(750, 100, 850, 400);
          RestoreDC(Handle, I);
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

procedure TFrGraphView.LoadFromStream(Stream: TStream);
var
  B: Byte;
begin
  inherited LoadFromStream(Stream);
  Stream.Read(B, SizeOf(B));
  XTitle[0] := AnsiChar(B);
  Stream.Read(XTitle[1], B);
  Stream.Read(B, SizeOf(B));
  YTitle[0] := AnsiChar(B);
  Stream.Read(YTitle[1], B);
  Stream.Read(B, SizeOf(B));
  FieldsTitle[0] := AnsiChar(B);
  Stream.Read(FieldsTitle[1], B);
  Stream.Read(B, SizeOf(B));
  GraphTitle[0] := AnsiChar(B);
  Stream.Read(GraphTitle[1], B);
  Stream.Read(LegendView, SizeOf(LegendView));
  Stream.Read(TitleView, SizeOf(TitleView));
  Stream.Read(XView, SizeOf(XView));
  Stream.Read(YView, SizeOf(YView));
  Stream.Read(GraphType, SizeOf(GraphType));
  Stream.Read(B, SizeOf(B));
  FormatY[0] := AnsiChar(B);
  Stream.Read(FormatY[1], B);
end;

procedure TFrGraphView.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  Stream.Write(XTitle[0], Length(XTitle) + 1);
  Stream.Write(YTitle[0], Length(YTitle) + 1);
  Stream.Write(FieldsTitle[0], Length(FieldsTitle) + 1);
  Stream.Write(GraphTitle[0], Length(GraphTitle) + 1);
  Stream.Write(LegendView, SizeOf(LegendView));
  Stream.Write(TitleView, SizeOf(TitleView));
  Stream.Write(XView, SizeOf(XView));
  Stream.Write(YView, SizeOf(YView));
  Stream.Write(GraphType, SizeOf(GraphType));
  Stream.Write(FormatY[0], Length(FormatY) + 1);
end;

//--------------------- EDITOR ------------------------//
procedure TFrGraphEditor.ShowEditor(t: TfrView);
begin
  Obj := t;
  if ShowModal = mrOk then
    begin
    end;
end;

procedure TFrGraphEditor.SlctDSClick(Sender: TObject);
begin
  BandEditorForm := TBandEditorForm.Create(nil);
  BandEditorForm.ShowEditor(Obj);
  BandEditorForm.Free;
end;

procedure TFrGraphEditor.GNewClick(Sender: TObject);
begin
  Str1 := '';
  Str2 := '';
  Col1 := clWhite;
  if FieldEditor.ShowModal = mrOK then
    begin
      Mem.Add(Str1);
      Mem.Add(IntToStr(Col1));
      Mem.Add(Str2);
      CheckMemo;
    end;
  DrawGrid1.Refresh;
end;

function TFrGraphEditor.GetItem(Cl, Rw: Integer): string;
var
  I: Integer;
begin
  I := (Rw - 1) * DrawGrid1.ColCount + Cl;
  if I <= Mem.Count - 1 then
    Result := Mem[I]
  else
    Result := '';
end;

procedure TFrGraphEditor.DrawGrid1DrawCell(Sender: TObject; ACol,
  ARow: {$IFDEF Delphi2}Longint; {$ELSE}Integer; {$ENDIF}
  Rect: TRect; State: TGridDrawState);
var
  S: string;
  OldC: TColor;
begin
  if ARow = 0 then
    begin
      Rect.Left := Rect.Left + 1;
      S := FRConst_GraphFieldsTitle[ACol];
      DrawText(TDrawGrid(Sender).Canvas.Handle, PChar(S), Length(S), Rect,
        DT_LEFT or DT_VCENTER or DT_SINGLELINE);
    end
  else
    begin
      S := GetItem(ACol, ARow);
      if S <> '' then
        begin
          if ACol <> 1 then Rect.Left := Rect.Left + 1;
          case ACol of
            0, 2: DrawText(TDrawGrid(Sender).Canvas.Handle, PChar(S), Length(S), Rect,
                DT_LEFT or DT_VCENTER or DT_SINGLELINE);
            1:
              begin
                OldC := TDrawGrid(Sender).Canvas.Pen.Color;
                TDrawGrid(Sender).Canvas.Pen.Color := clBlack;
                TDrawGrid(Sender).Canvas.Brush.Color := StrToInt(S);
                Rectangle(TDrawGrid(Sender).Canvas.Handle, Rect.Left + 1, Rect.Top + 1,
                  Rect.Right - 1, Rect.Bottom - 1);
                TDrawGrid(Sender).Canvas.Pen.Color := OldC;
              end;
          end;
        end;
    end;
end;

procedure TFrGraphEditor.GDelClick(Sender: TObject);
var
  I: Integer;
begin
  if DrawGrid1.Row <= (Mem.Count div DrawGrid1.ColCount) then
    if Application.MessageBox(PChar(FRConst_ItemDelete),
      PChar(FRConst_Attenction),
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_Yes then
      begin
        for I := 1 to DrawGrid1.ColCount do
          Mem.Delete((DrawGrid1.Row - 1) * DrawGrid1.ColCount);
        DrawGrid1.Refresh;
      end;
end;

procedure TFrGraphEditor.FormShow(Sender: TObject);
var
  I: Integer;
  D: TfrDataSet;
begin
  {$IFNDEF Delphi2}
  E3.Flat := False;
  {$ENDIF}
  CheckMemo;
  Edit1.Text := String(TfrGraphView(Obj).XTitle);
  Edit2.Text := String(TfrGraphView(Obj).YTitle);
  Edit3.Text := String(TfrGraphView(Obj).GraphTitle);
  Edit4.Text := String(TfrGraphView(Obj).FieldsTitle);
  CheckBox1.Checked := TfrGraphView(Obj).LegendView;
  CheckBox2.Checked := TfrGraphView(Obj).TitleView;
  CheckBox3.Checked := TfrGraphView(Obj).XView;
  CheckBox4.Checked := TfrGraphView(Obj).YView;
  ComboBox1.ItemIndex := Integer(TfrGraphView(Obj).GraphType);
  ComboBox2.Text := String(TfrGraphView(Obj).FormatY);
  Mem.Assign(Obj.Memo);
  OldDS := Obj.FormatStr;
  if Obj.FormatStr = '' then
    DS := nil
  else
    begin
      if CurReport.DataSetList.Find(Obj.FormatStr, I) then
        begin
          D := TfrDataSet(CurReport.DataSetList.Objects[I]);
          if D is TfrDBDataSet then
            begin
              DS := TfrDBDataSet.Create(nil);
              TfrDBDataSet(DS).DataSet := TfrDBDataSet(D).DataSet;
              TfrDBDataSet(DS).Filter := TfrDBDataSet(D).Filter;
              TfrDBDataSet(DS).Filtered := TfrDBDataSet(D).Filtered;
            end
          else
            begin
              DS := TfrUserDataSet.Create(nil);
            end;
          DS.RangeBegin := D.RangeBegin;
          DS.RangeEnd := D.RangeEnd;
          DS.RangeEndCount := D.RangeEndCount;
        end;
    end;
end;

procedure TFrGraphEditor.DrawGrid1DblClick(Sender: TObject);
var
  I: Integer;
begin
  if DrawGrid1.Row <= (Mem.Count div DrawGrid1.ColCount) then
    begin
      Str1 := GetItem(0, DrawGrid1.Row);
      Str2 := GetItem(2, DrawGrid1.Row);
      Col1 := StrToInt(GetItem(1, DrawGrid1.Row));
      if FieldEditor.ShowModal = mrOK then
        begin
          I := (DrawGrid1.Row - 1) * DrawGrid1.ColCount;
          Mem[I] := Str1;
          Mem[I + 1] := IntToStr(Col1);
          Mem[I + 2] := Str2;
        end;
      DrawGrid1.Refresh;
    end;
end;

procedure TFrGraphEditor.Button1Click(Sender: TObject);
begin
  TfrGraphView(Obj).XTitle := UTF8Encode(Edit1.Text);
  TfrGraphView(Obj).YTitle := UTF8Encode(Edit2.Text);
  TfrGraphView(Obj).GraphTitle := UTF8Encode(Edit3.Text);
  TfrGraphView(Obj).FieldsTitle := UTF8Encode(Edit4.Text);
  TfrGraphView(Obj).LegendView := CheckBox1.Checked;
  TfrGraphView(Obj).TitleView := CheckBox2.Checked;
  TfrGraphView(Obj).XView := CheckBox3.Checked;
  TfrGraphView(Obj).YView := CheckBox4.Checked;
  TfrGraphView(Obj).GraphType := TfrGraphType(ComboBox1.ItemIndex);
  TfrGraphView(Obj).FormatY := UTF8Encode(ComboBox2.Text);
  Obj.Memo.Assign(Mem);
end;

procedure TfrGraphEditor.CheckMemo;
var
  I: Integer;
begin
  I := 1 + (Obj.Memo.Count div DrawGrid1.ColCount);
  if I > 7 then
    DrawGrid1.RowCount := I
  else
    DrawGrid1.RowCount := 7;
end;

procedure TFrGraphEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if DS <> nil then DS.Free;
end;

procedure TFrGraphEditor.Button2Click(Sender: TObject);
var
  I: Integer;
  D: TfrDataSet;
begin
  if CurReport.DataSetList.Find(Obj.FormatStr, I) then
    begin
      D := TfrDataSet(CurReport.DataSetList.Objects[I]);
      if D.Owner = nil then
        D.Free
      else
        CurReport.DataSetList.Delete(I);
    end;
  Obj.FormatStr := OldDS;
  if DS <> nil then
    begin
      DS.Name := OldDS;
      CurReport.DataSetList.AddObject(OldDS, DS);
      DS := nil;
    end;
end;

procedure TFrGraphEditor.E3Click(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := Edit4.Text;
    if edEx.ShowModal = MrOk then
      Edit4.Text := edEx.moExpres.Text;
  finally
    edEx.Free;
  end;
end;

procedure TFrGraphEditor.DrawGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then
    GDelClick(nil)
  else
    if Key = vk_Insert then GNewClick(nil);
end;

procedure TFrGraphEditor.FormCreate(Sender: TObject);
begin
  Caption := FRConst_FrGrpEditCaption;
  SlctDS.Caption := FRConst_FrGrpEditSlctDSCaption;
  GNew.Hint := FRConst_FrGrpEditGNewHint;
  GDel.Hint := FRConst_FrGrpEditGDelHint;
  GMod.Hint := FRConst_FrGrpEditGModHint;
  Label1.Caption := FRConst_FrGrpEditLabelCaption1;
  Label2.Caption := FRConst_FrGrpEditLabelCaption2;
  Label3.Caption := FRConst_FrGrpEditLabelCaption3;
  Label4.Caption := FRConst_FrGrpEditLabelCaption4;
  CheckBox1.Caption := FRConst_FrGrpEditCheckBoxCapt1;
  CheckBox2.Caption := FRConst_FrGrpEditCheckBoxCapt2;
  CheckBox3.Caption := FRConst_FrGrpEditCheckBoxCapt3;
  CheckBox4.Caption := FRConst_FrGrpEditCheckBoxCapt4;
  Options.Caption := FRConst_FrGrpEditOptionsCapt;
  ComboBox1.Items.Text := FRConst_FrGrpEditComboBoxItms1;
  ComboBox2.Items.Text := FRConst_FrGrpEditComboBoxItms2;
  Label5.Caption := FRConst_FrGrpEditLabelCaption5;
  Label6.Caption := FRConst_FrGrpEditLabelCaption6;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
  {$IFNDEF Delphi2}
  GNew.Flat := True;
  GDel.Flat := True;
  GMod.Flat := True;
  {$ENDIF}

  DrawGrid1.OnDrawCell := DrawGrid1DrawCell;
end;

var
  Bmp: TBitMap;

initialization
  Bmp := TBitmap.Create;
  Bmp.Handle := LoadBitmap(HInstance, 'GRAPHBITMAP');
  Mem := TStringList.Create;
  frRegisterObject(TfrGraphView, Bmp, FRConst_FrGrpInsGrph, TfrGraphEditor);

finalization
  Bmp.Free;
  Mem.Free;

end.


