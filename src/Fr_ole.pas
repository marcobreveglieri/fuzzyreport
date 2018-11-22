
{*****************************************}
{                                         }
{             FastReport v2.2             }
{            OLE Add-In Object            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_OLE;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtnrs, StdCtrls, ExtCtrls, DB, Menus, FR_Class, FR_Const, Buttons,
  {$IFDEF Delphi2}
  DBTables, Ole2;
{$ELSE}
  ActiveX;
{$ENDIF}

type
  TfrOLEObject = class(TComponent) // fake component
  end;

  TfrOLEView = class(TfrCustomPictureView)
  public
    OleContainer: TOleContainer;
    constructor Create(Rep: TfrReport); override;
    procedure Assign(From: TfrView); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure GetBlob(b: TField); override;
  end;

  TOleForm = class(TfrObjEditorForm)
    Panel2: TPanel;
    OleContainer1: TOleContainer;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button5: TButton;
    MainMenu1: TMainMenu;
    Edit1: TMenuItem;
    Panel3: TPanel;
    Button3: TBitBtn;
    Button4: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowEditor(t: TfrView); override;
  end;

var
  ParentForm: TForm;
  ParentCount: Integer;

implementation

{$R *.DFM}

{$R frOLE.dcr}

{$R OLE.res}

procedure AssignOle(Cont1, Cont2: TOleContainer);
var
  st: TMemoryStream;
begin
  if Cont2.OleObjectInterface = nil then
    begin
      Cont1.DestroyObject;
      Exit;
    end;
  st := TMemoryStream.Create;
  Cont2.SaveToStream(st);
  st.Position := 0;
  Cont1.LoadFromStream(st);
  st.Free;
end;

{----------------------------------------------------------------------------}
constructor TfrOLEView.Create(Rep: TfrReport);
begin
  inherited;
  OleContainer := TOleContainer.Create(nil);
  with OleContainer do
    begin
      Inc(ParentCount);
      if ParentForm = nil then ParentForm := TForm.Create(nil);
      Parent := ParentForm;
      Visible := False;
      AllowInPlace := False;
      AutoVerbMenu := False;
      BorderStyle := bsNone;
      SizeMode := smClip;
    end;
  Flags := 1;
end;

procedure TfrOLEView.Assign(From: TfrView);
begin
  inherited Assign(From);
  AssignOle(OleContainer, (From as TfrOLEView).OleContainer);
end;

destructor TfrOLEView.Destroy;
begin
  if ParentForm <> nil then OleContainer.Free;
  Dec(ParentCount);
  if ParentCount = 0 then
    begin
      ParentForm.Free;
      ParentForm := nil;
    end;
  inherited Destroy;
end;

procedure TfrOLEView.Draw(Canvas: TCanvas);
var
  SD: Integer;
  S, Cnt, K: TPoint;
  X, Y: Double;

  function CalcSize: TPoint;
  var
    ViewObject2: IViewObject2;
    Size: TPoint;
  begin
    if Succeeded(OleContainer.OleObjectInterface.
      QueryInterface({$IFDEF Delphi2}IID_IViewObject2
      {$ELSE}IViewObject2{$ENDIF}, ViewObject2)) then
      begin
        ViewObject2.GetExtent(DVASPECT_CONTENT, -1, nil, Size);
        Size.X := MulDiv(Size.X, Screen.PixelsPerInch, 2540);
        Size.Y := MulDiv(Size.Y, Screen.PixelsPerInch, 2540);
        Result := Size;
      end
    else
      Result := Point(0, 0);
  end;

begin
  if (DocMode = dmPrinting) and (not Visible) then Exit;
  BeginDraw(Canvas);
  OleContainer.Width := Width;
  OleContainer.Height := Height;
  if DocMode = dmPrinting then
    begin
      Memo1.Assign(Memo);
      CurReport.InternalOnEnterRect(Memo1, Self);
    end;
  CalcGaps;
  with Canvas do
    begin
      ShowBackground;
      with OleContainer do
        if OleObjectInterface <> nil then
          begin
            if not Stretch then
              S := CalcSize
            else
              begin
                if not KeepRatio then
                  S := Point(DRect.Right - DRect.Left,
                    DRect.Bottom - DRect.Top)
                else
                  begin
                    K := CalcSize;
                    X := (DRect.Right - DRect.Left) / K.X;
                    Y := (DRect.Bottom - DRect.Top) / K.Y;
                    if X > Y then
                      S := Point(Round((DRect.Right - DRect.Left) * (Y / X)),
                        DRect.Bottom - DRect.Top)
                    else
                      S := Point(DRect.Right - DRect.Left,
                        Round((DRect.Bottom - DRect.Top) * (X / Y)));
                  end;
              end;
            if Center then
              Cnt := Point(((DRect.Right - DRect.Left + 1) - S.X) div 2,
                ((DRect.Bottom - DRect.Top + 1) - S.Y) div 2)
            else
              Cnt := Point(0, 0);
            SD := SaveDC(Canvas.Handle);
            IntersectClipRect(Canvas.Handle, Self.Left, Self.Top,
              Self.Left + Self.Width + 1,
              Self.Top + Self.Height + 1);

            OleDraw(OleObjectInterface, DVASPECT_CONTENT, Canvas.Handle,
              Rect(DRect.Left + Cnt.X, DRect.Top + Cnt.Y,
              DRect.Left + S.X + Cnt.X, DRect.Top + S.Y + Cnt.Y));
            RestoreDC(Canvas.Handle, SD);
          end
        else
          if DocMode = dmDesigning then
            begin
              Font.Name := 'Arial';
              Font.Size := 8;
              Font.Style := [];
              Font.Color := clBlack;
              TextOut(Self.Left + 2, Self.Top + 2, '[OLE]');
            end;
      ShowFrame;
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

procedure TfrOLEView.LoadFromStream(Stream: TStream);
var
  b: Byte;
begin
  inherited LoadFromStream(Stream);
  Stream.Read(b, 1);
  if b <> 0 then
    OleContainer.LoadFromStream(Stream);
end;

procedure TfrOLEView.SaveToStream(Stream: TStream);
var
  b: Byte;
begin
  inherited SaveToStream(Stream);
  b := 0;
  if OleContainer.OleObjectInterface <> nil then
    begin
      b := 1;
      Stream.Write(b, 1);
      OleContainer.SaveToStream(Stream);
    end
  else
    Stream.Write(b, 1);
end;

procedure TfrOLEView.GetBlob(b: TField);
var
  s: TMemoryStream;
begin
  s := TMemoryStream.Create;
  (b as TBlobField).SaveToStream(s);
  s.Position := 0;
  OleContainer.LoadFromStream(s);
  s.Free;
end;

{----------------------------------------------------------------------------}
procedure TOleForm.ShowEditor(t: TfrView);
begin
  AssignOle(OleContainer1, (t as TfrOLEView).OleContainer);
  if ShowModal = mrOK then
    AssignOle((t as TfrOLEView).OleContainer, OleContainer1);
  OleContainer1.DestroyObject;
end;

procedure TOleForm.Button1Click(Sender: TObject);
begin
  with OleContainer1 do
    if InsertObjectDialog then
      DoVerb(PrimaryVerb);
end;

procedure TOleForm.Button2Click(Sender: TObject);
begin
  if OleContainer1.OleObjectInterface <> nil then OleContainer1.DoVerb(ovPrimary);
end;

procedure TOleForm.Button5Click(Sender: TObject);
var
  X: TOleContainer;
begin
  X := TOleContainer.Create(OleContainer1.Owner);
  AssignOle(OleContainer1, X);
  X.Free;
end;

procedure TOleForm.FormResize(Sender: TObject);
begin
  Panel2.Height := Panel2.Parent.ClientHeight - Panel1.Height;
end;

procedure TOleForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_OLEFormCaption;
  Button1.Caption := FRConst_OLEFormButtonCaption1;
  Button2.Caption := FRConst_OLEFormButtonCaption2;
  Button5.Caption := FRConst_OLEFormButtonCaption5;
  Button3.Caption := FRConst_OK;
  Button4.Caption := FRConst_Cancel;
end;

var
  Bmp: TBitMap;

initialization
  Bmp := TBitMap.Create;
  Bmp.Handle := LoadBitmap(HInstance, 'OLEBITMAP');
  frRegisterObject(TfrOLEView, Bmp, FRConst_InsOLE, TOleForm);
  ParentForm := nil;
  ParentCount := 0;

finalization
  Bmp.Free;

end.

