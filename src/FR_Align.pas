
{*****************************************}
{                                         }
{             FastReport v2.2             }
{         Designer's align window         }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Align;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, FR_Const;

type
  TAlignForm = class(TForm)
    ScrollBox1: TScrollBox;
    B0: TSpeedButton;
    B1: TSpeedButton;
    B2: TSpeedButton;
    B3: TSpeedButton;
    B4: TSpeedButton;
    B5: TSpeedButton;
    B6: TSpeedButton;
    B7: TSpeedButton;
    B8: TSpeedButton;
    B9: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure B0Click(Sender: TObject);
    procedure B5Click(Sender: TObject);
    procedure B4Click(Sender: TObject);
    procedure B9Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure B6Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
    procedure B7Click(Sender: TObject);
    procedure B3Click(Sender: TObject);
    procedure B8Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlignForm: TAlignForm;

implementation

{$R *.DFM}

uses FR_Desgn, FR_Class;

function Objects: TList;
begin
  Result := frDesigner.Page.Objects;
end;

function GetFirstSelected: TfrView;
begin
  if FirstSelected <> nil then
    Result := FirstSelected
  else
    Result := Objects[frGetTopSelected];
end;

function GetLeftObject: Integer;
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  t := Objects[frGetTopSelected];
  x := t.Left;
  Result := frGetTopSelected;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        if t.Left < x then
          begin
            x := t.Left;
            Result := i;
          end;
    end;
end;

function GetRightObject: Integer;
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  t := Objects[frGetTopSelected];
  x := t.Left + t.Width;
  Result := frGetTopSelected;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        if t.Left + t.Width > x then
          begin
            x := t.Left + t.Width;
            Result := i;
          end;
    end;
end;

function GetTopObject: Integer;
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  t := Objects[frGetTopSelected];
  y := t.Top;
  Result := frGetTopSelected;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        if t.Top < y then
          begin
            y := t.Top;
            Result := i;
          end;
    end;
end;

function GetBottomObject: Integer;
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  t := Objects[frGetTopSelected];
  y := t.Top + t.Height;
  Result := frGetTopSelected;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        if t.Top + t.Height > y then
          begin
            y := t.Top + t.Height;
            Result := i;
          end;
    end;
end;

procedure TAlignForm.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
    SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure TAlignForm.B0Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum < 2 then Exit;
  t := GetFirstSelected;
  x := t.Left;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        t.Left := x;
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B5Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum < 2 then Exit;
  t := GetFirstSelected;
  y := t.Top;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        t.Top := y;
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B4Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum < 2 then Exit;
  t := GetFirstSelected;
  x := t.Left + t.Width;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        t.Left := x - t.Width;
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B9Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum < 2 then Exit;
  t := GetFirstSelected;
  y := t.Top + t.Height;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        t.Top := y - t.Height;
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B1Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum < 2 then Exit;
  t := GetFirstSelected;
  x := t.Left + t.Width div 2;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        t.Left := x - t.Width div 2;
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B6Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum < 2 then Exit;
  t := GetFirstSelected;
  y := t.Top + t.Height div 2;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        t.Top := y - t.Height div 2;
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B2Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  x: Integer;
begin
  if SelNum = 0 then Exit;
  t := Objects[GetLeftObject];
  x := t.Left;
  t := Objects[GetRightObject];
  x := x + (t.Left + t.Width - x - frDesigner.Page.PrnInfo.Pgw) div 2;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then Dec(t.Left, x);
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B7Click(Sender: TObject);
var
  i: Integer;
  t: TfrView;
  y: Integer;
begin
  if SelNum = 0 then Exit;
  t := Objects[GetTopObject];
  y := t.Top;
  t := Objects[GetBottomObject];
  y := y + (t.Top + t.Height - y - frDesigner.Page.PrnInfo.Pgh) div 2;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then Dec(t.Top, y);
    end;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B3Click(Sender: TObject);
var
  s: TStringList;
  i, dx: Integer;
  t: TfrView;
begin
  if SelNum < 3 then Exit;
  s := TStringList.Create;
  s.Sorted := True;
  s.Duplicates := dupAccept;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then s.AddObject(Format('%4.4d', [t.Left]), t);
    end;
  dx := (TfrView(s.Objects[s.Count - 1]).Left - TfrView(s.Objects[0]).Left) div (s.Count - 1);
  for i := 1 to s.Count - 2 do
    TfrView(s.Objects[i]).Left := TfrView(s.Objects[i - 1]).Left + dx;
  s.Free;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.B8Click(Sender: TObject);
var
  s: TStringList;
  i, dy: Integer;
  t: TfrView;
begin
  if SelNum < 3 then Exit;
  s := TStringList.Create;
  s.Sorted := True;
  s.Duplicates := dupAccept;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then s.AddObject(Format('%4.4d', [t.Top]), t);
    end;
  dy := (TfrView(s.Objects[s.Count - 1]).Top - TfrView(s.Objects[0]).Top) div (s.Count - 1);
  for i := 1 to s.Count - 2 do
    TfrView(s.Objects[i]).Top := TfrView(s.Objects[i - 1]).Top + dy;
  s.Free;
  DesignerForm.RedrawPage;
  Preview.GetMultipleSelected;
  DesignerForm.ChangeObject;
end;

procedure TAlignForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key >= VK_F1) and (Key <= VK_F12) then
    if frDesigner <> nil then
      PostMessage(frDesigner.Handle, WM_KEYDOWN, Key, 1);
end;

procedure TAlignForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_AlignFormCaption;
  B0.Hint := FRConst_AlignFormHint0;
  B1.Hint := FRConst_AlignFormHint1;
  B2.Hint := FRConst_AlignFormHint2;
  B3.Hint := FRConst_AlignFormHint3;
  B4.Hint := FRConst_AlignFormHint4;
  B5.Hint := FRConst_AlignFormHint5;
  B6.Hint := FRConst_AlignFormHint6;
  B7.Hint := FRConst_AlignFormHint7;
  B8.Hint := FRConst_AlignFormHint8;
  B9.Hint := FRConst_AlignFormHint9;
  {$IFNDEF Delphi2}
  B0.Flat := True;
  B1.Flat := True;
  B2.Flat := True;
  B3.Flat := True;
  B4.Flat := True;
  B5.Flat := True;
  B6.Flat := True;
  B7.Flat := True;
  B8.Flat := True;
  B9.Flat := True;
  {$ENDIF}
end;

end.

