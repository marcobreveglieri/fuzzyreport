
{*****************************************}
{                                         }
{             FastReport v2.2             }
{             Color selector              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Color;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, FR_Const {**};

type
  TColorSelector = class(TPanel)
  private
    FColor: TColor;
    FOtherBtn, FNoneBtn: TSpeedButton;
    FOnColorSelected: TNotifyEvent;
    procedure ButtonClick(Sender: TObject);
    procedure SetColor(Value: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    property Color: TColor read FColor write SetColor;
    property OnColorSelected: TNotifyEvent read FOnColorSelected write
      FOnColorSelected;
  end;

implementation

const
  Colors: array[0..15] of TColor =
  (clWhite, clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua);

constructor TColorSelector.Create(AOwner: TComponent);
var
  b: TSpeedButton;
  i, j: Integer;
  bmp: TBitmap;
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  Width := 96;
  Height := 132;
  bmp := TBitmap.Create;
  bmp.Width := 16;
  bmp.Height := 17;
  with bmp.Canvas do
    begin
      Brush.Color := clBtnFace;
      FillRect(Rect(0, 0, 16, 17));
    end;
  for i := 0 to 3 do
    for j := 0 to 3 do
      begin
        b := TSpeedButton.Create(Self);
        b.Parent := Self;
        b.SetBounds(j * 22 + 4, i * 22 + 4, 22, 22);
        with bmp.Canvas do
          begin
            Brush.Color := Colors[i * 4 + j];
            Pen.Color := clBtnShadow;
            Rectangle(0, 0, 16, 16);
          end;
        b.Glyph.Assign(bmp);
        b.Tag := i * 4 + j;
        b.OnClick := ButtonClick;
        b.GroupIndex := 1;
        {$IFNDEF Delphi2}
        b.Flat := True;
        {$ENDIF}
      end;

  FNoneBtn := TSpeedButton.Create(Self);
  with FNoneBtn do
    begin
      Parent := Self;
      SetBounds(4, 92, 88, 18);
      Tag := 16;
      Caption := FRConst_ColorNone; {**}
      OnClick := ButtonClick;
      GroupIndex := 1;
      {$IFNDEF Delphi2}
      FNoneBtn.Flat := True;
      {$ENDIF}
    end;

  FOtherBtn := TSpeedButton.Create(Self);
  with FOtherBtn do
    begin
      Parent := Self;
      SetBounds(4, 110, 88, 18);
      Tag := 17;
      Caption := FRConst_ColorOther; {**}
      OnClick := ButtonClick;
      GroupIndex := 1;
      {$IFNDEF Delphi2}
      FOtherBtn.Flat := True;
      {$ENDIF}
    end;
  bmp.Free;
end;

procedure TColorSelector.ButtonClick(Sender: TObject);
var
  cd: TColorDialog;
  i: Integer;
begin
  i := (Sender as TSpeedButton).Tag;
  case i of
    0..15: FColor := Colors[i];
    16: FColor := clNone;
    17:
      begin
        cd := TColorDialog.Create(Self);
        cd.Options := [cdFullOpen];
        cd.Color := FColor;
        if cd.Execute then
          FColor := cd.Color
        else
          begin
            Hide;
            Exit;
          end;
      end;
  end;
  Hide;
  if Assigned(FOnColorSelected) then FOnColorSelected(Self);
end;

procedure TColorSelector.SetColor(Value: TColor);
var
  I: Integer;
  Bmp: TBitmap;
begin
  FColor := Value;
  FNoneBtn.Down := False;
  FOtherBtn.Down := False;
  FOtherBtn.Glyph.Assign(nil);
  for I := 0 to ControlCount - 1 do
    TSpeedButton(Controls[I]).Down := False;
  for I := 0 to ControlCount - 1 do
    if Colors[I] = Value then
      begin
        TSpeedButton(Controls[I]).Down := True;
        Exit;
      end;
  if Value = clNone then
    begin
      FNoneBtn.Down := True;
      Exit;
    end;
  Bmp := TBitmap.Create;
  Bmp.Width := 12;
  bmp.Height := 13;
  with bmp.Canvas do
    begin
      Brush.Color := clBtnFace;
      FillRect(Rect(0, 0, 12, 13));
      Brush.Color := Value;
      Pen.Color := clBtnShadow;
      Rectangle(0, 0, 12, 12);
    end;
  FOtherBtn.Glyph.Assign(bmp);
  FOtherBtn.Down := True;
  Bmp.Free;
end;

end.

