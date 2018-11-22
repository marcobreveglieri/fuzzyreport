
{*****************************************}
{                                         }
{             FastReport v2.2             }
{        Framed memo Add-In Object        }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_FMemo;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class, StdCtrls, ExtCtrls, ClipBrd, Buttons, ImgList,
 //$IFDEF Delphi4}, ImgList{$ENDIF},
  FR_Const;

type
  TfrFramedMemoObject = class(TComponent) // fake component
  end;

  TfrFrameLine = packed record
    Typ: Byte;
    Width: Byte;
  end;

  TfrFramedMemoView = class(TfrMemoView)
  public
    Frame: array[0..3] of TfrFrameLine;
    constructor Create(Rep: TfrReport); override;
    procedure Assign(From: TfrView); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure CalcGaps; override;
    procedure ShowFrame; override;
    procedure ShowBackGround; override;
  end;

  TFramedMemoForm = class(TfrObjEditorForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    M1: TMemo;
    CancBtn: TBitBtn;
    VarBtn: TBitBtn;
    FldBtn: TBitBtn;
    ExpBtn: TBitBtn;
    OKBtn: TBitBtn;
    ImageList1: TImageList;
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button5Click(Sender: TObject);
    procedure M1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ExpBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

{$R *.DFM}

{$R frFMemo.dcr}

{$R FMemo.res}

uses FR_Var, FR_Flds, EdExpr;

{----------------------------------------------------------------------------}
constructor TfrFramedMemoView.Create(Rep: TfrReport);
var
  i: Integer;
begin
  inherited;
  Typ := gtAddIn;
  for i := 0 to 3 do
    Frame[i].Width := 1;
end;

procedure TfrFramedMemoView.Assign(From: TfrView);
begin
  inherited Assign(From);
  Frame := (From as TfrFramedMemoView).Frame;
end;

procedure TfrFramedMemoView.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  Stream.Read(Frame, SizeOf(Frame));
end;

procedure TfrFramedMemoView.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  Stream.Write(Frame, SizeOf(Frame));
end;

procedure TfrFramedMemoView.CalcGaps;
var
  i: Integer;
begin
  FrameWidth := 1;
  for i := 0 to 3 do
    with Frame[i] do
      if Width + Width * Typ * 2 > FrameWidth then FrameWidth := Width + Width * Typ * 2;
  inherited CalcGaps;
end;

procedure TfrFramedMemoView.ShowFrame;
  procedure Line(x, y, dx, dy: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + dx, y + dy);
  end;

  procedure DrawLineHorz(X1, Y1, X2, Y2, W: Integer);
  var
    I: Integer;
  begin
    for I := 0 to W - 1 do
      begin
        Canvas.MoveTo(X1, Y1 - W div 2 + I);
        Canvas.LineTo(X2, Y1 - W div 2 + I);
      end;
  end;

  procedure DrawLineVert(X1, Y1, X2, Y2, W: Integer);
  var
    I: Integer;
  begin
    for I := 0 to W - 1 do
      begin
        Canvas.MoveTo(X1 - W div 2 + I, Y1);
        Canvas.LineTo(X1 - W div 2 + I, Y2);
      end;
  end;

  function Space(I: Integer): Integer;
  begin
    Result := (Frame[I].Width * (1 + Frame[I].Typ * 2)) div 2;
  end;

  procedure FrameLine(i: Integer);
  begin
    Canvas.Pen.Width := 1;
    case i of
      0:
        if Frame[i].Typ = 0 then
          DrawLineVert(Left + Width, Top - Space(3), Left + Width, Top + Height + Space(2) + 1, Frame[I].Width)
        else
          if Frame[i].Typ = 1 then
            begin
              DrawLineVert(Left + Width - Frame[i].Width, Top + Space(3) - Frame[3].Width + 1,
                Left + Width - Frame[i].Width,
                Top + Height - Space(2) + Frame[2].Width - 1, Frame[I].Width);
              DrawLineVert(Left + Width + Frame[i].Width, Top - Space(3),
                Left + Width + Frame[i].Width, Top + Height + Space(2), Frame[I].Width);
            end;
      1:
        if Frame[i].Typ = 0 then
          DrawLineVert(Left, Top - Space(3), Left, Top + Height + Space(2), Frame[I].Width)
        else
          if Frame[i].Typ = 1 then
            begin
              DrawLineVert(Left - Frame[i].Width, Top - Space(3), Left - Frame[i].Width,
                Top + Height + Space(2), Frame[I].Width);
              DrawLineVert(Left + Frame[i].Width, Top + Space(3) - Frame[3].Width + 1,
                Left + Frame[i].Width, Top + Height - Space(2) + Frame[2].Width - 1,
                Frame[I].Width);
            end;
      2:
        if Frame[i].Typ = 0 then
          DrawLineHorz(Left - Space(1), Top + Height, Left + Width + Space(0), Top + Height, Frame[I].Width)
        else
          if Frame[i].Typ = 1 then
            begin
              DrawLineHorz(Left + Space(1) - Frame[1].Width + 1, Top + Height - Frame[I].Width,
                Left + Width - Space(0) + Frame[0].Width - 1,
                Top + Height - Frame[I].Width, Frame[I].Width);
              DrawLineHorz(Left - Space(1), Top + Height + Frame[I].Width,
                Left + Width + Space(0), Top + Height + Frame[I].Width, Frame[I].Width);
            end;
      3:
        if Frame[i].Typ = 0 then
          DrawLineHorz(Left - Space(1), Top, Left + Width + Space(0), Top, Frame[I].Width)
        else
          if Frame[i].Typ = 1 then
            begin
              DrawLineHorz(Left - Space(1), Top - Frame[I].Width,
                Left + Width + Space(0), Top - Frame[I].Width, Frame[I].Width);
              DrawLineHorz(Left + Space(1) - Frame[1].Width + 1, Top + Frame[I].Width,
                Left + Width - Space(0) + Frame[0].Width - 1,
                Top + Frame[I].Width, Frame[I].Width);
            end;
    end;
  end;
begin
  if DisableDrawing then Exit;
  if (DocMode = dmPrinting) and ((FrameTyp and $F) = 0) then Exit;
  with Canvas do
    begin
      Pen.Style := psSolid;
      Brush.Style := bsClear;
      Pen.Color := FrameColor;
      Pen.Width := Frame[0].Width;
      if ((FrameTyp and $F) = 0) and (DocMode = dmDesigning) then
        begin
          Pen.Color := clBlack;
          Pen.Width := 1;
          Line(Left, Top + 3, 0, -3);
          Line(Left, Top, 4, 0);
          Line(Left, Top + Height - 4, 0, 3);
          Line(Left, Top + Height - 1, 4, 0);
          Line(Left + Width - 4, Top, 3, 0);
          Line(Left + Width - 1, Top, 0, 4);
          Line(Left + Width - 4, Top + Height - 1, 3, 0);
          Line(Left + Width - 1, Top + Height - 1, 0, -4);
        end
      else
        begin
          if ((FrameTyp and $F) = $F) and
            (Frame[0].Typ + Frame[1].Typ + Frame[2].Typ + Frame[3].Typ = 0) and
            (Frame[1].Width = Frame[0].Width) and
            (Frame[2].Width = Frame[0].Width) and
            (Frame[3].Width = Frame[0].Width) then
            Rectangle(Left, Top, Left + Width + 1, Top + Height + 1)
          else
            begin
              if (FrameTyp and $1) <> 0 then FrameLine(0);
              if (FrameTyp and $4) <> 0 then FrameLine(1);
              if (FrameTyp and $2) <> 0 then FrameLine(2);
              if (FrameTyp and $8) <> 0 then FrameLine(3);
            end;
        end;
    end;
end;

procedure TfrFramedMemoView.ShowBackGround;
var
  fp: TColor;
begin
  if DisableDrawing then Exit;
  if (DocMode = dmPrinting) and (Color = clNone) then Exit;
  if DocMode = dmDesigning then
    begin
      Canvas.Pen.Width := FrameWidth;
      Canvas.Pen.Color := clWhite;
      Canvas.Rectangle(Left, Top, Left + Width + 1, Top + Height + 1);
    end;
  fp := Color;
  if (DocMode = dmDesigning) and (fp = clNone) then fp := clWhite;
  Canvas.Brush.Color := fp;
  Canvas.FillRect(Rect(Left - Frame[1].Typ * Frame[1].Width,
    Top - Frame[3].Typ * Frame[3].Width,
    Left + Width + Frame[0].Typ * Frame[0].Width,
    Top + Height + Frame[2].Typ * Frame[2].Width));
end;

{-------------------------------------------------------------------------}
procedure TFramedMemoForm.ShowEditor(t: TfrView);
var
  c: array[0..3] of TComboBox;
  i: Integer;
begin
  c[0] := ComboBox1;
  c[1] := ComboBox2;
  c[2] := ComboBox3;
  c[3] := ComboBox4;
  M1.Lines.Assign(t.Memo);
  with t as TfrFramedMemoView do
    begin
      for i := 0 to 3 do
        c[i].ItemIndex := Frame[i].Typ * 3 + Frame[i].Width - 1;
      if ShowModal = mrOk then
        begin
          for i := 0 to 3 do
            begin
              Frame[i].Typ := c[i].ItemIndex div 3;
              Frame[i].Width := c[i].ItemIndex mod 3 + 1;
            end;
          Memo.Assign(M1.Lines);
        end;
    end;
end;

procedure TFramedMemoForm.FormActivate(Sender: TObject);
begin
  M1.SetFocus;
end;

procedure TFramedMemoForm.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do
    begin
      Canvas.FillRect(Rect);
      ImageList1.BkColor := clWhite;
      if odSelected in State then
        ImageList1.ImageType := itMask
      else
        ImageList1.ImageType := itImage;
      ImageList1.Draw(Canvas, Rect.Left, Rect.Top, Index);
    end;
end;

procedure TFramedMemoForm.Button5Click(Sender: TObject);
begin
  VarForm := TVarForm.Create(nil);
  with VarForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        if Variables.ItemIndex >= 0 then
          ClipBoard.AsText := '[' + Variables.Items[Variables.ItemIndex] + ']';
        M1.PasteFromClipboard;
      end;
  VarForm.Free;
  M1.SetFocus;
end;

procedure TFramedMemoForm.M1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and (Shift = []) then Button5Click(Self);
  if Key = vk_Escape then ModalResult := mrCancel;
end;

procedure TFramedMemoForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Return) and (ssCtrl in Shift) then
    begin
      ModalResult := mrOk;
      Key := 0;
    end;
end;

procedure TFramedMemoForm.Button6Click(Sender: TObject);
begin
  FieldsForm := TFieldsForm.Create(nil);
  with FieldsForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := '[' + DBField + ']';
        M1.PasteFromClipboard;
      end;
  FieldsForm.Free;
  M1.SetFocus;
end;

procedure TFramedMemoForm.ExpBtnClick(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := '';
    if edEx.ShowModal = MrOk then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := '[' + edEx.moExpres.Text + ']';
        M1.PasteFromClipboard;
      end;
  finally
    edEx.Free;
  end;
end;

procedure TFramedMemoForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_FrmdMemoFrmCaption;
  GroupBox1.Caption := FRConst_FrmdMemoFrmGroupBoxCap;
  Label1.Caption := FRConst_FrmdMemoFrmLabelCap1;
  Label2.Caption := FRConst_FrmdMemoFrmLabelCap2;
  Label3.Caption := FRConst_FrmdMemoFrmLabelCap3;
  Label4.Caption := FRConst_FrmdMemoFrmLabelCap4;
  VarBtn.Caption := FRConst_Var;
  FldBtn.Caption := FRConst_DB;
  ExpBtn.Caption := FRConst_Exp;
  OKBtn.Caption := FRConst_OK;
  CancBtn.Caption := FRConst_Cancel;
end;

var
  Bmp: TBitMap;

initialization
  Bmp := TBitMap.Create;
  Bmp.Handle := LoadBitmap(HInstance, 'FMEMOBITMAP');
  frRegisterObject(TfrFramedMemoView, Bmp, FRConst_InsFMemo, TFramedMemoForm);

finalization
  Bmp.Free;

end.

