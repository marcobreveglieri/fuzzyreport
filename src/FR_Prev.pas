{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_Prev;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, StrUtils, ExtCtrls, Buttons, Menus, ImgList, ComCtrls, ToolWin,
  Registry, ShellApi, FR_Const, FR_Class, FR_Find;

const
  CM_SetZoom  = WM_USER + 1;
  crHandFlat = 23;
  crHandGrab = 24;
  crMoveAll = 25;
  crMoveN = 26;
  crMoveS = 27;
  crMoveE = 28;
  crMoveW = 29;
  crMoveNE = 30;
  crMoveNW = 31;
  crMoveSE = 32;
  crMoveSW = 33;

type

  TZoomType = (ztNormal,ztWidth,ztOnePage,ztTwoPages);
  TMoveType = (mtStop, mtN, mtS, mtE, mtW, mtNW, mtNE, mtSE, mtSW);

  TPaintPanel = class(TPanel)
  private
    { Private declarations }
    Timer: TTimer;
    SmallV, SmallH, MoveY, MoveX: integer;
    MoveAll: Boolean;
    FMoveType: TMoveType;
    procedure SetMoveType(const Value: TMoveType);
    property MoveType: TMoveType read FMoveType write SetMoveType default mtStop;
  public
    { Public declarations }
    NoPaint, Drag, NoSetY: Boolean;
    DragX, DragY: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnTimer(Sender: TObject);
    procedure Paint; override;
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
    procedure MouseDown (Button: TMouseButton; Shift: TShiftState;X, Y: Integer); override;
    procedure MouseMove (Shift: TShiftState; X, Y: Integer); override;
  end;

  TStandardPreview = class(TfrPreview)
    StatusBar: TPanel;
    VPanel: TPanel;
    BPanel: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    CloseBtn: TSpeedButton;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    PrintBtn: TSpeedButton;
    SavePdf: TSpeedButton;
    FindBtn: TSpeedButton;
    Panel0: TPanel;
    SpacePanel: TPanel;
    ZoomBtn: TComboBox;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    Timer: TTimer;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    CenterPanel: TPanel;
    PagePanel: TPanel;
    PaintPage: TPaintBox;
    Panel1: TPanel;
    VScroll: TScrollBar;
    LeftPanel: TPanel;
    HScroll: TScrollBar;
    LeftBtnPanel: TPanel;
    RightBtnPanel: TPanel;
    HPanel: TPanel;
    LabelPage: TLabel;
    RightPanel: TPanel;
    PrevBtn: TSpeedButton;
    FirstBtn: TSpeedButton;
    LastBtn: TSpeedButton;
    NextBtn: TSpeedButton;
    OnePageBtn: TSpeedButton;
    TwoPageBtn: TSpeedButton;
    WdtPageBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VScrollChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HScrollChange(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FirstBtnClick(Sender: TObject);
    procedure LastBtnClick(Sender: TObject);
    procedure ZoomBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SavePdfClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ZoomBtnKeyPress(Sender: TObject; var Key: Char);
    procedure FindBtnClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure PaintPagePaint(Sender: TObject);
    procedure ZoomBtnKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure OnePageBtnClick(Sender: TObject);
    procedure TwoPageBtnClick(Sender: TObject);
    procedure WdtPageBtnClick(Sender: TObject);
  private
    { Private declarations }
    Panel: TPaintPanel;
    Vposition,HPosition,FPageNo: Integer;
    FZoom: Double;
    FindText, TextFound, CaseSensitive, SubString,
    NextItem, PrevItem, CurrPage, ResizePaint: Boolean;
    TextToFind: String;
    ExtRect: TRect;
    PageFound, FoundTimer, ObjectNo, LastObject, CurrObject,
    MaxWidth, MaxHeight, Start, Len: Integer;
    LastY, LastZoom: Double;
    FZoomType, LastZoomType: TZoomType;
    procedure SetPageNumber (Value:Integer);
    procedure SetZoom (Value:Double);
    procedure CheckZoom;
    procedure SetZoomFactor;
    function  FindXY (Pn: Integer): TPoint;
    procedure MenuClick (Sender: TObject);
    procedure CMSetZoom (Var Message:TMessage); Message CM_SetZoom;
    {$IFDEF Delphi4}
    procedure MouseWheelUp   (Sender: TObject; Shift: TShiftState;
                              MousePos: TPoint; var Handled: Boolean);
    procedure MouseWheelDown (Sender: TObject; Shift: TShiftState;
                              MousePos: TPoint; var Handled: Boolean);
    {$ENDIF}
  protected
    // Protected procedures & data ...
    FEnableStatusBar, FEnablePagePanel, FOldEnableStatusBar: Boolean;
    FSmallChange, FLargeChange: Integer;
    procedure DrawPage(Cnv:HDC;N:Integer;R:TRect); override;
    procedure SetStatusBar (Value:Boolean);
    procedure SetPagePanel (Value:Boolean);
    procedure SetSmallChange (Value:Integer);
    procedure SetLargeChange (Value:Integer);     
  public
    { Public declarations }
    procedure Open; virtual;
    procedure Save; virtual;
    procedure Print; virtual;
    procedure Find; virtual;
    procedure First; virtual;
    procedure Last; virtual;
    procedure Next; virtual;
    procedure Prior; virtual;
    procedure ZoomWidth; virtual;
    procedure ZoomOnePage; virtual;
    procedure ZoomTwoPages; virtual;
    property EnableStatusBar :Boolean read FEnableStatusBar write SetStatusBar default True;
    property EnablePagePanel :Boolean read FEnablePagePanel write SetPagePanel default True;
    property ZoomType:TZoomType read FZoomType;
    property PageNo  :Integer read FPageNo write SetPageNumber;
    property Zoom    :Double read FZoom write SetZoom;
    property SmallChange:Integer read FSmallChange write SetSmallChange default 20;
    property LargeChange:Integer read FLargeChange write SetLargeChange default 200;
  end;

implementation

{$R *.DFM}
{$R Cursor.Res}

Var
   WinNt   : Boolean;
   PDFExe  : String;

//------------------------------------------------------------------------------

Constructor TPaintPanel.Create(AOwner: TComponent);
begin
  inherited;
  Timer := TTimer.Create(self);
  Timer.Enabled := False;
  Timer.OnTimer := OnTimer;
  Timer.Interval := 100;
  SmallV := 0;
  SmallH := 0;
  FMoveType := mtStop;
end;

destructor TPaintPanel.Destroy;
begin
  If Assigned(Timer) Then
  Begin
    Timer.Enabled:=False;
    Timer.Free;
  End;
  inherited;
end;

procedure TPaintPanel.OnTimer(Sender: TObject);
begin
  with TStandardPreview(Parent) do
  begin
  case MoveType of
    mtN :
    begin
      VScroll.Position := Vscroll.Position - SmallV;
    end;
    mtS :
    begin
      VScroll.Position := Vscroll.Position + SmallV;
    end;
    mtE :
    begin
      HScroll.Position := HScroll.Position + SmallH;
    end;
    mtW :
    begin
      HScroll.Position := HScroll.Position - SmallH;
    end;
    mtNW:
    begin
      VScroll.Position := Vscroll.Position - SmallV;
      HScroll.Position := HScroll.Position - SmallH;
    end;
    mtNE:
    begin
      VScroll.Position := Vscroll.Position - SmallV;
      HScroll.Position := HScroll.Position + SmallH;
    end;
    mtSE:
    begin
      VScroll.Position := Vscroll.Position + SmallV;
      HScroll.Position := HScroll.Position + SmallH;
    end;
    mtSW:
    begin
      VScroll.Position := Vscroll.Position + SmallV;
      HScroll.Position := HScroll.Position - SmallH;
    end;
  end;
  end;
end;

procedure TPaintPanel.SetMoveType(const Value: TMoveType);
begin
  if FMoveType <> Value then
  begin
    FMoveType := Value;
    case MoveType of
      mtStop: Self.Cursor := crMoveAll;
      mtN   : Self.Cursor := crMoveN;
      mtS   : Self.Cursor := crMoveS;
      mtE   : Self.Cursor := crMoveE;
      mtW   : Self.Cursor := crMoveW;
      mtNW  : Self.Cursor := crMoveNW;
      mtNE  : Self.Cursor := crMoveNE;
      mtSW  : Self.Cursor := crMoveSW;
      mtSE  : Self.Cursor := crMoveSE;
    end;
    Perform(WM_SETCURSOR, Handle, HTCLIENT);
  end;
end;

procedure TPaintPanel.Paint;
var
  I, Y, X, MaxY, MaxX, BigY, NewPageNo: Integer;
  Dx, Dy: Double;
  R: TRect;
begin
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color   := clBlack;
  Y    := 10 - TStandardPreview(Parent).VScroll.Position;
  MaxY := 10;
  NewPageNo := 1;
  BigY := 0;
  for I := 0 to TStandardPreview(Parent).Report.EMFPages.Count-1 do
    with TStandardPreview(Parent).Report.EMFPages.Pages[I].Pict do
    begin
      Dx := (TStandardPreview(Parent).Report.EMFPages.Pages[I].pgWidth * mmToPixel) /
              TStandardPreview(Parent).Report.EMFPages.Pages[I].Pict.Width *
              TStandardPreview(Parent).Zoom / 100;
      Dy := (TStandardPreview(Parent).Report.EMFPages.Pages[I].pgHeight * mmToPixel) /
              TStandardPreview(Parent).Report.EMFPages.Pages[I].Pict.Height *
              TStandardPreview(Parent).Zoom / 100;
      if not NoPaint then
      begin
        if Y<=10 then NewPageNo := I + 1;
        if not((Y>Canvas.ClipRect.Bottom) or (Round(Y+Height*Dy+1)<Canvas.ClipRect.Top)) then
        begin
          if Round(Width*Dx-Self.Width)>0 then
            X := 10
          else if TStandardPreview(Parent).ZoomType<>ztTwoPages then
            X := Round ((Self.Width-(Width*Dx+20)-2)/2)+10
          else if I mod 2=0 then
            X := Round ((Self.Width/2-(Width*Dx)-2)/2)
          else X := Round ((Self.Width/2-(Width*Dx)-2)/2 + Self.Width/2);
          Dec (X,TStandardPreview(Parent).HScroll.Position);
          if Y<=10 then TStandardPreview(Parent).LastY := Abs(Y-10)/(Height*Dy);
          R := Rect (X,Y,Round(X+Width*Dx+1),Round(Height*Dy+Y+1));
          Canvas.Rectangle (R.Left,R.Top,R.Right,R.Bottom);
          Canvas.Rectangle (R.Right,R.Top+3,R.Right+1,R.Bottom);
          Canvas.Rectangle (R.Left+3,R.Bottom,R.Right+1,R.Bottom+1);
          R.Right := R.Right - 1;
          R.Bottom := R.Bottom - 1;
          TStandardPreview(Parent).DrawPage(Canvas.Handle,I,R);
        end;
      end;
      if Round(Height*Dy)>BigY then BigY := Round(Height*Dy);
      if (TStandardPreview(Parent).ZoomType<>ztTwoPages) or (I mod 2=1) then
      begin
        Inc (Y,BigY+12);
        Inc (MaxY,BigY+12);
        BigY := 0;
      end;
    end;
  if not NoPaint then
  begin
    if (TStandardPreview(Parent).ZoomType=ztTwoPages) and (NewPageNo>1) then Dec (NewPageNo);
    if NewPageNo<>TStandardPreview(Parent).PageNo then
    begin
      TStandardPreview(Parent).FPageNo := NewPageNo;
      TStandardPreview(Parent).PaintPagePaint (nil);
    end;
  end;
  Dec (MaxY,Height);
  if MaxY>0 then
  begin
    TStandardPreview(Parent).VScroll.Max := MaxY;
    TStandardPreview(Parent).VScroll.Enabled := True;
  end else
  begin
    TStandardPreview(Parent).VScroll.Max := 0;
    TStandardPreview(Parent).VScroll.Enabled := False;
  end;
  MaxX := Round (TStandardPreview(Parent).MaxWidth * TStandardPreview(Parent).Zoom / 100);
  if MaxX - Width >0 then
  begin
    TStandardPreview(Parent).HScroll.Max := MaxX - Width + 20;
    TStandardPreview(Parent).HScroll.Enabled := True;
  end else
  begin
    TStandardPreview(Parent).HScroll.Max := 0;
    TStandardPreview(Parent).HScroll.Enabled := False;
  end;
End;

procedure TPaintPanel.MouseUp (Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  P: TPoint;
  I: Integer;
begin
  if Drag then
  begin
    Drag  := False;
//*** Gio *** al rilascio del tasto destro del mouse rispristina il cursore (03/08/2005)
    Self.Cursor := crHandFlat;
//*** Gio *** fine modifica (03/08/2005)
  end;
  with TStandardPreview(Parent) do
  begin
    ZoomBtnClick (nil);
    if Button=mbRight then
    begin
      P := Panel.ClientToScreen (Point(X,Y));
      for I := 0 to PopupMenu.Items.Count-1 do
        if ((ZoomType=ztNormal) and (PopupMenu.Items[I].Caption=ZoomBtn.Text)) or
            ((ZoomType=ztWidth) and (PopupMenu.Items[I].Caption=FRConst_ZoomWidth)) or
            ((ZoomType=ztOnePage) and (PopupMenu.Items[I].Caption=FRConst_ZoomOnePage)) or
            ((ZoomType=ztTwoPages) and (PopupMenu.Items[I].Caption=FRConst_ZoomTwoPages)) then
          PopupMenu.Items[I].Checked := True
        else PopupMenu.Items[I].Checked := False;
      PopupMenu.Popup (P.X,P.Y);
    end;
  end;
end;

procedure TPaintPanel.MouseDown (Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
//*** Gio *** alla pressione del tasto destro del mouse cambia il cursore (04/08/2005)
  case Button of
    mbLeft :
    begin
      MoveAll := False;
      Drag   := True;
      DragX  := X;
      DragY  := Y;
      Self.Cursor := crHandGrab;
      Perform(WM_SETCURSOR, Handle, HTCLIENT);
    end;
    mbMiddle:
    begin
      MoveAll := not MoveAll;
      MoveX  := X;
      MoveY  := Y;
      if MoveAll then
        Self.Cursor := crMoveAll
      else Self.Cursor := crHandFlat;
      Perform(WM_SETCURSOR, Handle, HTCLIENT);
    end;
  else
    MoveAll := False;
    Self.Cursor := crHandFlat;
    Perform(WM_SETCURSOR, Handle, HTCLIENT);
  end;
//*** Gio *** fine modifica (04/08/2005)
end;

procedure TPaintPanel.MouseMove (Shift: TShiftState; X, Y: Integer);
var
  MyX, MyY: integer;
begin
  if Drag then
  begin
    with TStandardPreview(Parent) do
    begin
      VScroll.Position := Vscroll.Position - (Y - DragY);
      HScroll.Position := HScroll.Position - (X - DragX);
      DragX := X;
      DragY := Y;
    end;
  end;
//*** Gio *** inizio modifica (05/08/2005)
  if MoveAll then
  begin
    MyY := MoveY - Y;
    MyX := MoveX - X;
    if MyY = 0 then
    begin
      if MyX = 0 then MoveType := mtStop;
      if MyX < 0 then MoveType := mtE;
      if MyX > 0 then MoveType := mtW;
    end;
    if MyY > 0 then
    begin
      if MyX = 0 then MoveType := mtN;
      if MyX < 0 then MoveType := mtNE;
      if MyX > 0 then MoveType := mtNW;
    end;
    if MyY < 0 then
    begin
      if MyX = 0 then MoveType := mtS;
      if MyX < 0 then MoveType := mtSE;
      if MyX > 0 then MoveType := mtSW;
    end;
    if MyX < 0 then SmallH := (MyX * -1) else SmallH := MyX;
    if MyY < 0 then SmallV := (MyY * -1) else SmallV := MyY;
    Timer.Enabled := True;
  end else Timer.Enabled := False;
//*** Gio *** fine modifica (05/08/2005)
end;

//------------------------------------------------------------------------------

procedure TStandardPreview.SetPageNumber (Value:Integer);
var
  Y, I, BigY: Integer;
  D: Double;
begin
  BigY := 0;
  if (Value>=1) and (Value<=Report.EMFPages.Count) then
  begin
    Y := 0;
    for I := 0 to Value-2 do
    begin
      D := (Report.EMFPages.Pages[I].pgHeight * mmToPixel) /
           Report.EMFPages.Pages[I].Pict.Height * Zoom / 100;
      if Round(Report.EMFPages.Pages[I].Pict.Height*D)>BigY then
        BigY := Round(Report.EMFPages.Pages[I].Pict.Height*D);
      if (ZoomType<>ztTwoPages) or (I mod 2=1) then
      begin
        Inc (Y,BigY+12);
        BigY := 0;
      end;
    end;
    if VScroll.Position<>Y then VScroll.Position := Y;
//*** Gio *** inizio modifica (04/08/2005)
//    FirstBtn.Enabled     := not (Value=1);
//    PrevBtn.Enabled      := not (Value=1);
//    NextBtn.Enabled      := not (Value=Report.EMFPages.Count);
//    LastBtn.Enabled      := not (Value=Report.EMFPages.Count);
//*** Gio *** fine modifica (04/08/2005)
    FPageNo := Value;
    PaintPagePaint (nil);
  end;
end;

procedure TStandardPreview.SetZoom (Value:Double);
var
// Dy: Double;
  R: TRect;
  S: TNotifyEvent;
begin
  If (Value<>FZoom) And (TextFound) Then
    Begin
      ExtRect.Left   := Round(ExtRect.Left * (Value/FZoom));
      ExtRect.Top    := Round(ExtRect.Top * (Value/FZoom));
      ExtRect.Right  := Round(ExtRect.Right * (Value/FZoom));
      ExtRect.Bottom := Round(ExtRect.Bottom * (Value/FZoom));
    End;
  Panel.NoPaint := True;
  FZoom := Value;
  Panel.Paint;
  If (Not Panel.NoSetY) And (IsWindowVisible (Handle)) Then
    Begin
      SetPageNumber (PageNo);
      S := VScroll.OnChange;
      VScroll.OnChange := Nil;
(*      Dy := (Report.EMFPages.Pages[PageNo-1].pgHeight * mmToPixel) /
            Report.EMFPages.Pages[PageNo-1].Pict.Height * Zoom / 100;
      VScroll.Position := VScroll.Position +
                          Round(LastY * Report.EMFPages[PageNo-1].Pict.Height * Dy);*)
      VScroll.OnChange := S;
      VPosition := VScroll.Position;
    End;
  PostMessage (Handle,CM_SetZoom,0,0);
  If HScroll.Max<=70 Then HScroll.Position := HScroll.Max Div 2
                     Else HScroll.Position := 0;
  Panel.NoPaint := False;
  If (LastZoom<>Zoom) Or (LastZoomType<>ZoomType) Or (ResizePaint) Then
    Begin
      R := Rect (0,0,Panel.Width,Panel.Height);
      InvalidateRect (Panel.Canvas.Handle,@R,False);
      Panel.Canvas.Brush.Color := Panel.Color;
      Panel.Canvas.FillRect (Rect(0,0,Panel.Width,Panel.Height));
      Panel.Paint;
      LastZoom     := Zoom;
      LastZoomType := ZoomType;
      ResizePaint := False;
    End;
end;

procedure TStandardPreview.CheckZoom;
Var
  S: String;
  I: Double;
  W: Integer;
begin
  If Screen.ActiveControl=ZoomBtn Then
    Begin
      ZoomBtn.Enabled := False;
      S := ZoomBtn.Text;
      If S=FRConst_ZoomWidth Then Begin
                                    FZoomType := ztWidth;
                                    SetZoomFactor;
                                  End
                             Else
      If S=FRConst_ZoomOnePage Then Begin
                                      FZoomType := ztOnePage;
                                      SetZoomFactor;
                                    End
                               Else
      If S=FRConst_ZoomTwoPages Then Begin
                                       FZoomType := ztTwoPages;
                                       SetZoomFactor;
                                     End
                                Else
        Begin
          If Pos('%',S)=Length(S) Then Delete (S,Pos('%',S),1);
          If Pos(FormatSettings.DecimalSeparator,S)>0 Then S[Pos(FormatSettings.DecimalSeparator,S)]:='.';
          Val (S,I,W);
          If (W<>0) Or (I=0) Then Begin
                                    Beep;
                                    PostMessage (Handle,CM_SetZoom,0,0);
                                  End
                             Else If (ZoomType<>ztNormal) Or (Zoom<>I) Then
                                    Begin
                                      FZoomType := ztNormal;
                                      Zoom := I;
                                    End
                                                                       Else
                                    PostMessage (Handle,CM_SetZoom,0,0);
        End;
      ZoomBtn.Enabled := True;
    End;
end;

procedure TStandardPreview.SetZoomFactor;
Var
  Z: Double;
begin
  Case ZoomType of
    ztWidth   : Zoom := (Panel.Width - 20) / MaxWidth * 100;
    ztOnePage : Begin
                  Z := (Panel.Width - 20) / MaxWidth;
                  If MaxHeight*Z>Panel.Height-20 Then
                    Z := Z * ((Panel.Height - 20) / (MaxHeight*Z));
                  Zoom := Z * 100;
                End;
    ztTwoPages: Begin
                  Z := (Panel.Width - 20) / (MaxWidth * 2);
                  If MaxHeight*Z>Panel.Height-20 Then
                    Z := Z * ((Panel.Height - 20) / (MaxHeight*Z));
                  Zoom := Z * 100;
                End;
    ztNormal  : Zoom := Zoom;
  End;
end;

function TStandardPreview.FindXY (Pn: Integer): TPoint;
Var I, Y, X, BigY: Integer;
    Dx, Dy: Double;
Begin
  Y := 10 - VScroll.Position;
  I := 0;
  BigY := 0;
  While I<=Pn Do
    With Report.EMFPages.Pages[I].Pict Do
      Begin
        If I=Pn Then
          Begin
            Dx := (Report.EMFPages.Pages[I].pgWidth * mmToPixel) /
                  Report.EMFPages.Pages[I].Pict.Width * Zoom / 100;
            If Round(Width*Dx-Panel.Width)>0 Then X := 10
                                             Else
            If ZoomType<>ztTwoPages Then
              X := Round ((Panel.Width-(Width*Dx+20)-2)/2)+10
                                    Else
            If I Mod 2=0 Then
              X := Round ((Panel.Width/2-(Width*Dx)-2)/2)
                         Else
              X := Round ((Panel.Width/2-(Width*Dx)-2)/2 + Panel.Width/2);
            Dec (X,HScroll.Position);
            Result := Point (X,Y);
          End;
        If I<Pn Then
          Begin
            Dy := (Report.EMFPages.Pages[I].pgHeight * mmToPixel) /
                  Report.EMFPages.Pages[I].Pict.Height * Zoom / 100;
            If Round(Height*Dy)>BigY Then BigY := Round(Height*Dy);
            If (ZoomType<>ztTwoPages) Or (I Mod 2=1) Then
              Begin
                Inc (Y,BigY+12);
                BigY := 0;
              End;
          End;
        Inc (I);
      End;
end;

procedure TStandardPreview.DrawPage(Cnv:HDC; N:Integer; R:TRect);
Const
   EMFDraw  : Set Of Byte  = [
      2,3,4,5,6,7,8,15,41,42,43,44,45,46,47,53,
      55,56,71,72,73,74,76,77,78,79,81,83,84,85,
      86,87,88,89,90,91,92,96,97];
   Chars    : Set Of AnsiChar  = [
      ' ','.',';',':','?','!','''','(',')','[',']','"'];
Type
   Params = Record
      Pn       : Integer;
      ObjNo    : Integer;
      Rct      : TRect;
      Dx,Dy    : Double;
      LastAngle: Double;
      NewDraw  : Boolean;
      Angs     : TStringList;
      SPreview : TStandardPreview;
      WDx,WDy,
      Wx,Wy,
      VDx,VDy,
      Vx,Vy: Integer;
      DrawAll  : Boolean;
   End;
   PParams  = ^ Params;
   Arr      = Array [0..999] Of Integer;
   PArr     = ^Arr;

   SaveFont = Record
      Angle: Double;
   End;
   PSaveFont = ^SaveFont;

Var
   Param : PParams;
   Ix    : Integer;
   //
   function CustomEnhMetaFileProc(DC:HDC; HandleTable:PHandleTable;
                                  MyEnhMetaRecord:PEnhMetaRecord;
                                  nObj:Integer; LParam:Pointer):Bool; stdcall;
   Var
      E: TEMRExtTextOut;
      Q: PEMRExtCreateFontIndirect;
      Image: Pointer;
      Info: ^ TBitmapInfo;
      B: PEMRStretchBlt;
      X: PEMRBitBlt;
      Y: PEMRSetViewPortExtEx;
      Z: PEMRSetViewPortOrgEx;
      D: PEMRDeleteObject;
      P: TLogPen;
      S, S0, Text: String;
      I, OldBKMode, OldMapMode: Integer;
      Wnd, Vprt: TSize;
      Wp, Vp: TPoint;
      Pnt: TPoint;
      Metric: TTextMetric;
      OldFont: HFont;
      OldTxtColor, OldBKColor: TColor;
      DrawOK: Boolean;
      TheParam: PParams;
      SF: PSaveFont;
   //
   function RectOK (R1, R2: TRect): Boolean;
   Var
      P: TLogPen;
   begin
      InflateRect (R2,1,1);
      GetObject (GetCurrentObject(DC,OBJ_PEN),SizeOf(P),@P);
      InflateRect (R1,4+P.lopnWidth.x Div 2,4+P.lopnWidth.x Div 2);
      R1.Left   := Round(R1.Left * TheParam^.Dx);
      R1.Right  := Round(R1.Right * TheParam^.Dx);
      R1.Top    := Round(R1.Top * TheParam^.Dy);
      R1.Bottom := Round(R1.Bottom * TheParam^.Dy);
      OffsetRect (R1,TheParam^.Rct.Left,TheParam^.Rct.Top);
      LpToDP (DC,R2,2);
      Result := Not ((R1.Right<R2.Left) Or (R1.Left>R2.Right) Or
                    (R1.Top>R2.Bottom) Or (R1.Bottom<R2.Top));
   End;

   procedure NewTextOut;
   Var
      Sw : PWideChar;
      I, D, X, N: Integer;
      C, V: TSize;
      A  : PArr;
      Sx, Sy, Sy0: Double;
      W  : Arr;
   begin
      If (TheParam^.NewDraw) And
       (TheParam^.WDx=1) And (TheParam^.WDy=1) And
       (TheParam^.Wx=0) And (TheParam^.Wy=0)  And 
       //(TheParam^.VDx=1) And (TheParam^.VDy=1) And //Itta????????? BOHHHHHHHH !!!
       (TheParam^.Vx=0) And (TheParam^.Vy=0)      Then
      Begin
         OldMapMode := SetMapMode (DC,MM_ANISOTROPIC);
         If Not WinNT Then
         Begin
            SetWindowExtEx(DC,1000,1000,@Wnd);
            SetWindowOrgEx(DC,0,0,@Wp);
         End
         Else
         Begin
            SetWindowExtEx(DC,Round(TheParam^.Dx*1000),Round(TheParam^.Dy*1000),@Wnd);
            SetWindowOrgEx(DC,TheParam^.Rct.Left,TheParam^.Rct.Top,@Wp);
         End;
         SetViewPortExtEx(DC,1000,1000,@Vprt);
         SetViewPortOrgEx(DC,TheParam^.Rct.Left,TheParam^.Rct.Top,@Vp);
         E.emrtext.rcl.Left   := Round(E.emrtext.rcl.Left*TheParam^.Dx);
         E.emrtext.rcl.Top    := Round(E.emrtext.rcl.Top*TheParam^.Dy);
         E.emrtext.rcl.Right  := Round(E.emrtext.rcl.Right*TheParam^.Dx);
         E.emrtext.rcl.Bottom := Round(E.emrtext.rcl.Bottom*TheParam^.Dy);
         //A:=PArr(PChar(MyEnhMetaRecord)+E.EMRText.offDx);
         A:=PArr(PAnsiChar(MyEnhMetaRecord)+E.EMRText.offDx);
         X := 0;
         N := 0;
         D := E.rclBounds.Right-E.rclBounds.Left+1;
         If TheParam^.LastAngle<>0 Then
            D := Round (Cos(TheParam^.LastAngle)*D+
               Sin(TheParam^.LastAngle)*(E.rclBounds.Bottom-E.rclBounds.Top+1));
         Repeat
           Inc (X,A^[N]);
           Inc (N);
         Until (X>=D) Or (N>=Round(E.emrtext.nChars));
         If N>=Round(E.emrtext.nChars) Then N:=Round(E.emrtext.nChars);
         //Sw := PWideChar(PChar(MyEnhMetaRecord)+E.EMRText.offString);
         Sw:=PWideChar(PAnsiChar(MyEnhMetaRecord)+E.EMRText.offString); 
         GetTextExtentPoint32W(DC,PWideChar(PAnsiChar(MyEnhMetaRecord)+
             E.EMRText.offString+(N-1)*2),1,V);
         GetTextExtentPoint32W(DC,Sw,N-1,C);
         If N>1 Then
         Begin
            If C.cx=0 Then C.Cx := 1;
            Sx:=(X*TheParam^.Dx-V.cx)/C.cx
         End
         Else
            Sx:=1;
         //
         Sy:=0;
         For I:=0 To N-1 Do
         Begin
            GetTextExtentPoint32W (DC,PWideChar(PAnsiChar(MyEnhMetaRecord)+
                                   E.EMRText.offString+I*2),1,C);
            Sy0:=Sy;
            Sy:=Sy+C.cx;
            W[I]:=Round(Sy*Sx)-Round(Sy0*Sx);
         End;
         ExtTextOutW(DC,Round(E.emrtext.ptlReference.x*TheParam^.Dx),
                        Round(E.emrtext.ptlReference.y*TheParam^.Dy),
                        E.emrtext.fOptions,@E.emrtext.rcl,
                        Sw,N,@W);
         SetMapMode (DC,OldMapMode);
         SetWindowExtEx(DC,Wnd.cx,Wnd.cy,Nil);
         SetWindowOrgEx(DC,Wp.x,Wp.Y,Nil);
         SetViewPortExtEx(DC,Vprt.cx,Vprt.cy,Nil);
         SetViewPortOrgEx(DC,Vp.x,Vp.y,Nil);
         DrawOK := False;
      End
      Else
         PlayEnhMetafileRecord (DC,HandleTable^,MyEnhMetaRecord^,nObj);
   End;
   /////////////////
   BEGIN
      Result := True;
      TheParam := PParams(LParam);
      If Not TheParam^.SPreview.FindText Then
      Begin
         If MyEnhMetaRecord^.iType=1 Then
            TheParam^.ObjNo := 10000 * TheParam^.Pn
         Else
            Inc (TheParam^.ObjNo);
         //
         If TheParam^.NewDraw Then
         Begin
            If (MyEnhMetaRecord^.iType=37) And (TheParam^.Angs.Count>0) Then
            Begin
               D:=PEMRDeleteObject(MyEnhMetaRecord);
               If TheParam^.Angs.Find(IntToStr(D^.ihObject),I) Then
                  TheParam^.LastAngle := PSaveFont(TheParam^.Angs.Objects[I])^.Angle;
            End;
            If (MyEnhMetaRecord^.iType=40) And (TheParam^.Angs.Count>0) Then
            Begin
               D := PEMRDeleteObject(MyEnhMetaRecord);
               If TheParam^.Angs.Find(IntToStr(D^.ihObject),I) Then
               Begin
                  Dispose (PSaveFont(TheParam^.Angs.Objects[I]));
                  TheParam^.Angs.Delete (I);
                  If TheParam^.Angs.Count=0 Then TheParam^.LastAngle := 0;
               End;
            End;
            If MyEnhMetaRecord^.iType in [9,11] Then
            Begin
               Y := PEMRSetViewPortExtEx(MyEnhMetaRecord);
               If MyEnhMetaRecord^.iType=9 Then
               Begin
                  TheParam^.WDx := Y^.szlExtent.cx;
                  TheParam^.WDy := Y^.szlExtent.cy;
               End
               Else
               Begin
                  TheParam^.VDx := Y^.szlExtent.cx;
                  TheParam^.VDy := Y^.szlExtent.cy;
               End;
            End;
            If MyEnhMetaRecord^.iType in [10,12] Then
            Begin
               Z := PEMRSetViewPortOrgEx(MyEnhMetaRecord);
               If MyEnhMetaRecord^.iType=10 Then
               Begin
                  TheParam^.WDx := Z^.ptlOrigin.x;
                  TheParam^.WDy := Z^.ptlOrigin.y;
               End
               Else
               Begin
                  TheParam^.VDx := Z^.ptlOrigin.x;
                  TheParam^.VDy := Z^.ptlOrigin.y;
               End;
            End;
         End;
         If MyEnhMetaRecord^.iType=76 Then
         Begin
            X := PEMRBitBlt(MyEnhMetaRecord);
            If X^.cbBitsSrc>0 Then
            Begin
                Image := Pointer(PAnsiChar(MyEnhMetaRecord)+X^.offBitsSrc);
                Info  := Pointer(PAnsiChar(MyEnhMetaRecord)+X^.offBmiSrc);
                StretchDIBits (DC,X^.xDest,X^.yDest,X^.cxDest,X^.cyDest,
                                  X^.Xsrc,X^.ySrc,X^.cxDest,X^.cyDest,Image,Info^,
                                  X^.iUsageSrc,X^.dwRop);
                DrawOK := False;
            End;
         End
         Else
         Begin
            If MyEnhMetaRecord^.iType=77 Then
            Begin
               B := PEMRStretchBlt (MyEnhMetaRecord);
               If B^.cbBitsSrc>0 Then
               Begin
                  Image := Pointer(PAnsiChar(MyEnhMetaRecord)+B^.offBitsSrc);
                  Info  := Pointer(PAnsiChar(MyEnhMetaRecord)+B^.offBmiSrc);
                  StretchDIBits (DC,B^.xDest,B^.yDest,B^.cxDest,B^.cyDest,
                                    B^.Xsrc,B^.ySrc,B^.cxSrc,B^.cySrc,Image,Info^,
                                    B^.iUsageSrc,B^.dwRop);
                  DrawOK := False;
               End;
            End
            Else
            Begin
               If MyEnhMetaRecord^.iType=82 Then
               Begin
                  If (TheParam^.NewDraw) And
                     (TheParam^.WDx=1) And (TheParam^.WDy=1) And
                     (TheParam^.Wx=0) And (TheParam^.Wy=0) And
                     (TheParam^.VDx=1) And (TheParam^.VDy=1) And
                     (TheParam^.Vx=0) And (TheParam^.Vy=0) Then
                  Begin
                     Q := PEMRExtCreateFontIndirect(MyEnhMetaRecord);
                     Pnt := Point (Q^.elfw.elfLogFont.lfWidth,Q^.elfw.elfLogFont.lfHeight);
                     If (Q^.elfw.elfLogFont.lfEscapement<>0) And
                        (Q^.elfw.elfLogFont.lfOrientation<>0) Then
                     Begin
                        New (SF);
                        SF^.Angle := (Q^.elfw.elfLogFont.lfOrientation / 10) / (2 * Pi);
                        TheParam^.Angs.AddObject (IntToStr(Q^.ihFont),TObject(SF));
                     End;
                     If Round(TheParam^.Dx*100)<>Round(TheParam^.Dy*100) Then
                     Begin
                        Q^.elfw.elfLogFont.lfHeight :=
                          Round(Q^.elfw.elfLogFont.lfHeight * TheParam^.Dy * 10);
                        PlayEnhMetafileRecord (DC,HandleTable^,MyEnhMetaRecord^,nObj);
                        OldFont := SelectObject (DC,HandleTable^.objectHandle[Q^.ihFont]);
                        GetTextMetrics (DC,Metric);
                        Q^.elfw.elfLogFont.lfHeight := Round(Pnt.y * TheParam^.Dy);
                        Q^.elfw.elfLogFont.lfWidth  := Round(Metric.tmAveCharWidth / 10 *
                                                      (TheParam^.Dx/TheParam^.Dy));
                        SelectObject (DC,OldFont);
                        DeleteObject (HandleTable^.objectHandle[Q^.ihFont]);
                     End
                     Else
                     Begin
                        Q^.elfw.elfLogFont.lfHeight:=Round(Q^.elfw.elfLogFont.lfHeight * TheParam^.Dy);
                     End;
                     //
                     PlayEnhMetafileRecord (DC,HandleTable^,MyEnhMetaRecord^,nObj);
                     Q^.elfw.elfLogFont.lfWidth  := Pnt.x;
                     Q^.elfw.elfLogFont.lfHeight := Pnt.y;
                     DrawOK := False;
                  End
                  Else
                  Begin
                     DrawOK := True;
                  End;
               End
               Else
               Begin
                 If MyEnhMetaRecord^.iType in EMFDraw Then
                 Begin
                    E := PEMRExtTextOut(MyEnhMetaRecord)^;
                    If Not TheParam^.DrawAll Then
                    Begin
                       DrawOK := RectOK (E.rclBounds,TheParam^.SPreview.Panel.Canvas.ClipRect);
                       If DrawOK Then
                       Begin
                          If (TheParam^.SPreview.TextFound) And
                             (TheParam^.Pn=TheParam^.SPreview.PageFound) And
                             (TheParam^.ObjNo=TheParam^.SPreview.ObjectNo) Then
                          Begin
                             If TheParam^.SPreview.FoundTimer Mod 2=1 Then
                                With TheParam^.SPreview.Panel.Canvas Do
                                Begin
                                   OldTxtColor := GetTextColor (DC);
                                   OldBKColor  := GetBKColor(DC);
                                   OldBKMode   := GetBKMode(DC);
                                   If OldTxtColor=clWhite Then
                                      SetTextColor (DC,clYellow Xor Round(OldTxtColor))
                                   Else
                                      SetTextColor (DC,clWhite);
                                   SetBKColor (DC,clBlack);
                                   SetBKMode (DC,OPAQUE);
                                   NewTextOut;
                                   SetBKColor (DC,OldBKColor);
                                   SetBKMode (DC,OldBKMode);
                                   SetTextColor (DC,OldTxtColor);
                                   Rectangle (-10000,-10000,-10001,-10001);
                                   DrawOK := False;
                                End;
                          End;
                       End;
                    End
                    Else
                    Begin
                       DrawOK := True;
                    End;
                 End
                 Else
                    DrawOK := True;
               End;
            End;
         End;
         //
         If DrawOK Then
         Begin
            If MyEnhMetaRecord^.iType in [83,84] Then
               NewTextOut
            Else
               PlayEnhMetafileRecord (DC,HandleTable^,MyEnhMetaRecord^,nObj);
         End;
      End
      Else
      Begin
         If Not TheParam^.DrawAll Then
         Begin
            If Not TheParam^.SPreview.TextFound Then
            Begin
               If MyEnhMetaRecord^.iType=1 Then
                  TheParam^.SPreview.ObjectNo := 10000 * TheParam^.Pn
               Else
                  TheParam^.SPreview.ObjectNo := TheParam^.SPreview.ObjectNo + 1;
               If MyEnhMetaRecord^.iType in [83,84] Then
               Begin
                  Text := TheParam^.SPreview.TextToFind;
                  E    := PEMRExtTextOut(MyEnhMetaRecord)^;
                  S:='';
                  If E.EMRText.nChars>0 Then
                  Begin
                     Ix:=0;
                     While Ix<Abs(E.EMRText.nChars)*Abs(StringElementSize(S)) Do //2=StringElementSize
                     Begin
                        S:=S+Utf8ToString(PAnsiChar(MyEnhMetaRecord)+E.EMRText.offString+Ix);
                        Inc(Ix);
                     End;
                  End;
                  S0   := S;
                  I := 1;
                  While I<=Length(S) Do
                  Begin
                     If Copy(S,I,1)<' ' Then
                        Delete (S,I,1)
                     Else
                        Inc (I);
                  End;
                  If Not TheParam^.SPreview.CaseSensitive Then
                  Begin
                     S    := UpperCase (S);
                     Text := UpperCase (Text);
                  End;
                  If Length(S)>Length(Text) Then
                  Begin
                     S:=S+' ';
                     S:=Copy(S,1,Length(S)-1);
                  End;
                  TheParam^.SPreview.TextFound:=Pos(Text,S)>0;
                  If (TheParam^.SPreview.TextFound) And (Not TheParam^.SPreview.SubString) Then
                     TheParam^.SPreview.TextFound := (Text=S) Or (((Pos(Text,S)=1) Or
                        (CharInSet(S[Pos(Text,S)-1],Chars))) And
                        ((Pos(Text,S)+Length(Text)-1=Length(S)) Or
                        (CharInSet(S[Pos(Text,S)+Length(Text)],Chars))));
                  If TheParam^.SPreview.TextFound Then
                      TheParam^.SPreview.CurrObject := TheParam^.SPreview.CurrObject + 1;
                  If (TheParam^.SPreview.TextFound) And
                     (((Not TheParam^.SPreview.NextItem) And (Not TheParam^.SPreview.PrevItem) And
                      ((Not TheParam^.SPreview.CurrPage) Or (TheParam^.Pn>=TheParam^.SPreview.PageNo-1))) Or
                     ((TheParam^.SPreview.NextItem) And
                      (TheParam^.SPreview.CurrObject=TheParam^.SPreview.LastObject+1)) Or
                       ((TheParam^.SPreview.PrevItem) And
                     (TheParam^.SPreview.CurrObject=TheParam^.SPreview.LastObject-1))) Then
                  Begin
                     TheParam^.SPreview.LastObject := TheParam^.SPreview.CurrObject;
                     TheParam^.SPreview.ExtRect := E.rclBounds;
                     GetObject (GetCurrentObject(DC,OBJ_PEN),SizeOf(P),@P);
                     InflateRect(TheParam^.SPreview.ExtRect,4+P.lopnWidth.x Div 2,4+P.lopnWidth.x Div 2);
                     TheParam^.SPreview.ExtRect.Left   := Round(TheParam^.SPreview.ExtRect.Left * TheParam^.Dx);
                     TheParam^.SPreview.ExtRect.Right  := Round(TheParam^.SPreview.ExtRect.Right * TheParam^.Dx);
                     TheParam^.SPreview.ExtRect.Top    := Round(TheParam^.SPreview.ExtRect.Top * TheParam^.Dy);
                     TheParam^.SPreview.ExtRect.Bottom := Round(TheParam^.SPreview.ExtRect.Bottom * TheParam^.Dy);
                     TheParam^.SPreview.PageFound      := TheParam^.Pn;
                     TheParam^.SPreview.FoundTimer    := 0;
                     TheParam^.SPreview.Timer.Enabled := True;
                     TheParam^.SPreview.Start := Pos(Text,S);
                     TheParam^.SPreview.Len   := Length(Text);
                     Result := False;
                   End
                   Else
                      TheParam^.SPreview.TextFound := False;
               End;
            End;
         End;
      End;
   END;

begin
  New (Param);
  Param^.Pn := N;
  Param^.Rct := R;
  Param^.Dx := (Report.EMFPages.Pages[N].pgWidth * mmToPixel) /
                Report.EMFPages.Pages[N].Pict.Width * Zoom / 100;
  Param^.Dy := (Report.EMFPages.Pages[N].pgHeight * mmToPixel) /
                Report.EMFPages.Pages[N].Pict.Height * Zoom / 100;
  Param^.NewDraw := False;
  Param^.Angs := TStringList.Create;
  Param^.Angs.Sorted := True;
  Param^.LastAngle := 0;
  Param^.SPreview := Self;
  Param^.WDx := 1;
  Param^.WDy := 1;
  Param^.Wx  := 0;
  Param^.Wy  := 0;
  Param^.VDx := 1;
  Param^.VDy := 1;
  Param^.Vx  := 0;
  Param^.Vy  := 0;
  Param^.DrawAll := Cnv<>Panel.Canvas.Handle;
  EnumEnhMetafile (Cnv,Report.EMFPages.Pages[N].Pict.Handle,
                   @CustomEnhMetaFileProc,Param,R);
  Param^.Angs.Free;
  Dispose (Param);
end;

procedure TStandardPreview.MenuClick (Sender: TObject);
begin
  ZoomBtn.Text := TMenuItem(Sender).Caption;
  ZoomBtn.SetFocus;
  CheckZoom;
end;

procedure TStandardPreview.CMSetZoom (var message:TMessage);
var
  S: string;
begin
  S := FloatToStr(Int(Zoom) + Round(Frac(Zoom)*10) / 10);
  ZoomBtn.Text := S + '%';
end;

{$IFDEF Delphi4}
procedure TStandardPreview.MouseWheelUp (Sender: TObject; Shift: TShiftState;
                                         MousePos: TPoint; var Handled: Boolean);
begin
  VScroll.Position := VScroll.Position - VScroll.SmallChange;
end;

procedure TStandardPreview.MouseWheelDown (Sender: TObject; Shift: TShiftState;
                                           MousePos: TPoint; var Handled: Boolean);
begin
  VScroll.Position := VScroll.Position + VScroll.SmallChange;
end;
{$ENDIF}

procedure TStandardPreview.FormCreate(Sender: TObject);

  procedure AddMenu(T: TMenuItem; B: TSpeedButton);
  var
    M: TMenuItem;
  begin
    M := TMenuItem.Create (Nil);          
    {$IFDEF Delphi4}
      M.ImageIndex := ImageList.AddMasked (B.Glyph,B.Glyph.Canvas.Pixels[0,15]);
    {$ENDIF}
    M.Caption := B.Caption;
    M.OnClick := B.OnClick;
    T.Add (M);
  end;

var
  P: TMenuItem;
  I: Integer;
begin
  FEnablePagePanel  := True;
  FEnableStatusBar  := True;
  SmallChange      := 20;
  LargeChange      := 200;
  Caption           := FRConst_PreviewCaption;
  OpenBtn.Caption   := FRConst_OpenBtnCaption;
  OpenBtn.Hint      := FRConst_OpenBtnHint;
  SaveBtn.Caption   := FRConst_SaveBtnCaption;
  SaveBtn.Hint      := FRConst_SaveBtnHint;
  PrintBtn.Caption  := FRConst_PrintBtnCaption;
  PrintBtn.Hint     := FRConst_PrintBtnHint;
  FindBtn.Caption   := FRConst_FindBtnCaption;
  FindBtn.Hint      := FRConst_FindBtnHint;
  CloseBtn.Caption  := FRConst_CloseBtnCaption;
  CloseBtn.Hint     := FRConst_CloseBtnHint;
  FirstBtn.Hint     := FRConst_FirstBtnHint;
  LastBtn.Hint      := FRConst_LastBtnHint;
  PrevBtn.Hint      := FRConst_PrevBtnHint;
  NextBtn.Hint      := FRConst_NextBtnHint;
  OnePageBtn.Hint   := FRConst_ZoomOnePage;
  TwoPageBtn.Hint   := FRConst_ZoomTwoPages;
  WdtPageBtn.Hint   := FRConst_ZoomWidth;
  ZoomBtn.Hint      := FRConst_ZoomBtnHint;
  ZoomBtn.Items.Add (FRConst_ZoomWidth);
  ZoomBtn.Items.Add (FRConst_ZoomOnePage);
  ZoomBtn.Items.Add (FRConst_ZoomTwoPages);
  OpenDialog.Title  := FRConst_OpenDiatogTitle;
  OpenDialog.Filter := FRConst_OpenDiatogFilter;
  SaveDialog.Title  := FRConst_SaveDiatogTitle;
  ResizePaint := False;
  LastZoom     := 100;
  LastZoomType := ztNormal;
  FindText     := False;
  TextFound := False;
  OpenBtn.Flat   := True;
  SaveBtn.Flat   := True;
  PrintBtn.Flat  := True;
  SavePdf.Flat   := True;
  FindBtn.Flat   := True;
  CloseBtn.Flat  := True;
  FirstBtn.Flat  := True;
  PrevBtn.Flat   := True;
  NextBtn.Flat   := True;
  LastBtn.Flat   := True;
  //FullScrBtn.Flat:= True;
  OnePageBtn.Flat:= True;
  TwoPageBtn.Flat:= True;
  WdtPageBtn.Flat:= True;
  {$IFDEF Delphi4}
    OnMouseWheelUp   := MouseWheelUp;
    OnMouseWheelDown := MouseWheelDown;
    PopupMenu.Images := ImageList;
    {$IFDEF Delphi5}
      PopupMenu.AutoHotkeys := maManual;
    {$ENDIF}
  {$ENDIF}
  AddMenu (PopupMenu.Items,OpenBtn);
  AddMenu (PopupMenu.Items,SaveBtn);
  AddMenu (PopupMenu.Items,PrintBtn);
  AddMenu (PopupMenu.Items,FindBtn);
  P := TMenuItem.Create (Nil);
  P.Caption := '-';
  PopupMenu.Items.Add (P);
  for I := 0 to ZoomBtn.Items.Count-1 do
  begin
    P := TMenuItem.Create (nil);
    P.Caption := ZoomBtn.Items[I];
    P.OnClick := MenuClick;
    PopupMenu.Items.Add (P);
  end;
  Panel := TPaintPanel.Create (Self);
  Panel.Parent      := Self;
  Panel.Align       := alClient;
  Panel.BevelOuter  := bvNone;
  Panel.ParentBackground := False;
  Panel.ParentColor := False;
  Panel.Color       := clBtnShadow;
  Panel.FullRepaint := False;
  Panel.NoPaint     := False;
  Panel.Drag        := False;
  Panel. NoSetY     := False;
  Panel.Cursor      := crHandFlat;
  PagePanel.BringToFront;
end;

procedure TStandardPreview.VScrollChange(Sender: TObject);
begin
  ScrollWindow (Panel.Handle,0,VPosition-VScroll.Position,nil,nil);
  VPosition := VScroll.Position;
  CheckZoom;
end;

procedure TStandardPreview.HScrollChange(Sender: TObject);
begin
  ScrollWindow (Panel.Handle,HPosition-HScroll.Position,0,Nil,Nil);
  HPosition := HScroll.Position;
  CheckZoom;
end;

procedure TStandardPreview.FormKeyDown(Sender: TObject; var Key: Word;
                                       Shift: TShiftState);
begin
  If Screen.ActiveControl<>ZoomBtn Then
    Case Key of
      VK_Home  : First;
      VK_End   : Last;
      VK_Up    : VScroll.Position := VScroll.Position - VScroll.SmallChange;
      VK_Down  : VScroll.Position := VScroll.Position + VScroll.SmallChange;
      VK_Prior : If ssCtrl in Shift Then Prior
                                    Else
                   VScroll.Position := VScroll.Position - VScroll.LargeChange;
      VK_Next  : If ssCtrl in Shift Then Next
                                    Else
                   VScroll.Position := VScroll.Position + VScroll.LargeChange;
      VK_Left  : HScroll.Position := HScroll.Position - HScroll.SmallChange;
      VK_Right : HScroll.Position := HScroll.Position + HScroll.SmallChange;
      VK_Escape: Close;
      VK_F2    : Print;
      VK_F3    : Find;
      VK_F10   : Open;
      VK_F11   : Save;
      187      : Next;   // + key
      189      : Prior;  // - key
    End;
end;

procedure TStandardPreview.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TStandardPreview.FormShow(Sender: TObject);
var
  I, Dx, Dy: Integer;
begin
  PagePanel.Visible := False;
  PagePanel.Top := 0;
  BPanel.Visible := True;
  VPanel.Visible := True;
  HPanel.Visible := True;
  MaxWidth  := 0;
  MaxHeight := 0;
  for I := 0 to Report.EMFPages.Count-1 do
  begin
    Dx := Round (Report.EMFPages.Pages[I].pgWidth * mmToPixel);
    Dy := Round (Report.EMFPages.Pages[I].pgHeight * mmToPixel);
    if Dx>MaxWidth  then MaxWidth  := Dx;
    if Dy>MaxHeight then MaxHeight := Dy;
  end;
  VScroll.Position := 0;
  HScroll.Position := 0;
  VPosition := 0;
  HPosition := 0;
  HPanel.Height       := GetSystemMetrics (SM_CYHSCROLL);
  VPanel.Width        := GetSystemMetrics (SM_CXVSCROLL);
//*** Gio *** inizio modifica (04/08/2005)
//  ButtonsPanel.Height := HPanel.Height * 2;
//  PrevBtn.Width       := ButtonsPanel.Width;
//  PrevBtn.Height      := HPanel.Height;
//  NextBtn.Width       := ButtonsPanel.Width;
//  NextBtn.Top         := PrevBtn.Top + PrevBtn.Height;
//  NextBtn.Height      := HPanel.Height;
//*** Gio *** fine modifica (04/08/2005)
  SpacePanel.Width    := VPanel.Width;
  PageNo    := 1;
  FZoomType := ztNormal;
  Zoom      := 100;
  //
end;

//*** Gio *** inizio modifica (04/08/2005)

procedure TStandardPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Timer.Enabled then
  begin
    FoundTimer := 8;
    TimerTimer (nil);
  end;

/////////////////////////////  Panel.Free;

  PopupMenu.Items.Clear;   
end;

procedure TStandardPreview.FirstBtnClick(Sender: TObject);
begin
  First;
end;

procedure TStandardPreview.LastBtnClick(Sender: TObject);
begin
  Last;
end;

procedure TStandardPreview.OnePageBtnClick(Sender: TObject);
begin
  ZoomOnePage;
end;

procedure TStandardPreview.TwoPageBtnClick(Sender: TObject);
begin
  ZoomTwoPages;
end;

procedure TStandardPreview.WdtPageBtnClick(Sender: TObject);
begin
  ZoomWidth;
end;

//*** Gio *** fine modifica (04/08/2005)

procedure TStandardPreview.PrevBtnClick(Sender: TObject);
begin
  Prior;
end;

procedure TStandardPreview.NextBtnClick(Sender: TObject);
begin
  Next;
end;

procedure TStandardPreview.ZoomBtnClick(Sender: TObject);
begin
  CheckZoom;
end;

procedure TStandardPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 Then Key := #0;
end;

procedure TStandardPreview.OpenBtnClick(Sender: TObject);
begin
  Open;
end;

procedure TStandardPreview.SaveBtnClick(Sender: TObject);
begin
  Save;
end;

procedure TStandardPreview.SavePdfClick(Sender: TObject);
Var
   OldCur   : TCursor;
   OldDir   : String;
   Ix       : Integer;
   FName    : String;
   FClass   : TClass;
   FExt     : String;
begin
   CheckZoom;
   OldDir := GetCurrentDir;
   Ix:=0;
   While (Ix<frFiltersCount) And (UpperCase(frFilters[Ix].FilterExt)<>'*.PDF') Do Inc(Ix);
   If Ix<frFiltersCount Then
      SaveDialog.FilterIndex:=Ix
   Else
      Exit;
   //
  FClass:=frFilters[Ix].ClassRef;
  FExt:=Copy(frFilters[Ix].FilterExt,2,Length(frFilters[Ix].FilterExt));
  With SaveDialog Do
  Begin
      Filter:=FRConst_SaveDiatogFilter;
      Filter:=frFilters[Ix].FilterDesc+'|'+frFilters[Ix].FilterExt;
      If Execute Then
      Begin
         FName:=ChangeFileExt(FileName,FExt);
         OldCur:=Screen.Cursor;
         Try
            Screen.Cursor:=crHourGlass;
            Report.ExportTo(FClass,FName);
         Finally
            Screen.Cursor:=OldCur;
         End;
      End;
   End;

//Itta
   If PDFExe<>'' Then
   Begin
      ShellExecute(Handle,
         'Open',
         PWideChar(PDFExe),
         PWideChar(ExtractFileName(FName)),
         PWideChar(ExtractFileDir(FName)),
         SW_SHOWNORMAL);
   End;
//
End;

procedure TStandardPreview.PrintBtnClick(Sender: TObject);
begin
  Print;
end;

procedure TStandardPreview.FormResize(Sender: TObject);
begin
  ResizePaint := True; //ZoomType in [ztOnePage,ztTwoPages];
  SetZoomFactor;
  if PagePanel.Visible then
    PagePanel.Top := ClientHeight-PagePanel.Height;
//*** Gio *** ridimensionamento della navigationbar (04/08/2005)
  if BPanel.Visible then
  begin
    LeftPanel.Width := (ClientWidth - 200) div 2;
    RightPanel.Width := LeftPanel.Width;
  end;
//*** Gio *** fine modifica (04/08/2005)
end;

procedure TStandardPreview.ZoomBtnKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (CharInSet(Key,['0'..'9','%',FormatSettings.DecimalSeparator,#8])) Then Key:=Chr(0); //#0;
end;

procedure TStandardPreview.FindBtnClick(Sender: TObject);
begin
  FindData.OFindOrigin:=0; //FindFirstPage
  Repeat
      Find;
      FindData.OFindOrigin:=2; //FIndNext
  Until Not TextFound; 
end;

procedure TStandardPreview.TimerTimer(Sender: TObject);
var
  P: PRect;
  T: TPoint;
begin
  Inc (FoundTimer);
  New (P);
  Try
     CopyRect (P^,ExtRect);
     T := FindXY (PageFound);
     OffsetRect (P^,T.X,T.Y);
     InvalidateRect (Panel.Handle,P,False);
     if FoundTimer=9 then
     begin
       Timer.Enabled := False;
       TextFound     := False;
       InvalidateRect (Panel.Handle,P,False);
     end;
  Finally
     Dispose (P);
  End;
end;

procedure TStandardPreview.PaintPagePaint(Sender: TObject);
var
  S: string;
//  R: TRect;
begin
   //DrawText (PaintPage2.Canvas.Handle,PChar(S),Length(S),R,DT_VCENTER);
   S := IntToStr(PageNo) + FRConst_PageSeparator + IntToStr(Report.EMFPages.Count);
   LabelPage.Caption := trim(S);
end;

procedure TStandardPreview.SetStatusBar (Value:Boolean);
begin
   if Value then
      StatusBar.Height:=24
   Else
      StatusBar.Height:=0;
End;

procedure TStandardPreview.SetPagePanel(Value:Boolean);
begin
  if Value<>FEnablePagePanel then
  begin
    if Value then
    begin
       LeftPanel.Visible:=True
    end
    else
    begin
      PagePanel.Visible:=False;
      PagePanel.Top:=0;
    end;
    FEnablePagePanel:=Value;
  end;
end;

procedure TStandardPreview.SetSmallChange (Value:Integer);
begin
  If Value<>FSmallChange Then
    Begin
      FSmallChange := Value;
      HScroll.SmallChange := Value;
      VScroll.SmallChange := Value;
    End;
end;

procedure TStandardPreview.SetLargeChange (Value:Integer);
begin
  If Value<>FLargeChange Then
    Begin
      FLargeChange := Value;
      HScroll.LargeChange := Value;
      VScroll.LargeChange := Value;
    End;
end;

// Public procedures...
procedure TStandardPreview.Open;
Var
   OldDir: String;
begin
  CheckZoom;
  OldDir := GetCurrentDir;
  With OpenDialog Do
    Begin
      If Execute Then
      Begin
          Application.ProcessMessages;
          Report.LoadPreparedReport (FileName);
          LastZoom := 0;
          FormShow(Nil);
      End;
    End;
  SetCurrentDir (OldDir);
end;

procedure TStandardPreview.Save;
Var
   OldDir   : String;
   OldFName : String;
   I,IExt   : Integer;
   ExtStd   : String;
   FName    : String;
begin
  CheckZoom;
  OldDir := GetCurrentDir;
  OldFName:=Report.FileName;
  SaveDialog.Filter := FRConst_SaveDiatogFilter;
  For I := 0 To frFiltersCount-1 Do
     SaveDialog.Filter:=SaveDialog.Filter+'|'+frFilters[I].FilterDesc+'|'+frFilters[I].FilterExt;
  ExtStd:=Trim(Copy(FRConst_SaveDiatogFilter,Pos('|',FRConst_SaveDiatogFilter)+1,255));
  ExtStd:=Trim(Copy(ExtStd,Pos('*',ExtStd)+1,255));
  SaveDialog.FilterIndex:=0; //.Frp
  SaveDialog.InitialDir:=ExtractFileDir(Report.FileName);
  SaveDialog.FileName:=ExtractFileName(Report.FileName);
  SaveDialog.Filename:=ChangeFileExt(SaveDialog.FileName,ExtStd);
  If SaveDialog.Execute Then
  Begin
     Application.ProcessMessages;
     IExt:=SaveDialog.FilterIndex-1;
     FName:=SaveDialog.FileName;
     If ChangeFileExt(ExtractFileName(FName),'')='' Then Exit;
     If IExt=0 Then
     Begin
        FName:=ChangeFileExt(FName,ExtStd);
        Report.SavePreparedReport(FName)
     End
     Else
     Begin
        FName:=ChangeFileExt(FName,Copy(frFilters[IExt-1].FilterExt,2,255));
        Report.ExportTo(frFilters[IExt-1].ClassRef,FName);
     End;
  End;
  SetCurrentDir(OldDir);
end;

procedure TStandardPreview.Print;
Var
   Copy    : Integer;
begin
   CheckZoom;
   With PrintDialog Do
   Begin
      MinPage  := 1;
      MaxPage  := Report.EMFPages.Count;
      FromPage := MinPage;
      ToPage   := MaxPage;
      Copies   := 1;
      If Execute Then
      Begin
         Copy   := Copies;
         Copies := 1;
         Report.PrintPreparedReport(FromPage,ToPage,Copy,'');
      End;
   End;
end;

procedure TStandardPreview.Find;
Var
   FindForm : TFindForm;
   OldText  : String;
   OldCase  : Boolean;
   OldSub   : Boolean;
   OldNext  : Boolean;
   OldPrev  : Boolean;
   OldDir   : Integer;
   I        : Integer;
begin
   FindForm:=TFindForm.Create(Nil);
   Try
      With FindForm Do
      Begin
         FindCase.Checked:=FindData.OFindCase;
         FindSub.Checked:=FindData.OFindSub;
         FindFirstPage.Checked   :=False;
         FindCurrentPage.Checked :=False;
         FindNext.Checked        :=False;
         FindPrevious.Checked    :=False;
         Case FindData.OFindOrigin Of
           0: FindFirstPage.Checked   :=True;
           1: FindCurrentPage.Checked :=True;
           2: FindNext.Checked        :=True;
           3: FindPrevious.Checked    :=True;
         End;
         FindNext.Enabled := FindData.EnbNext;
         FindPrevious.Enabled := FindData.EnbPrev;
         FindText.Text := FindData.OText;
         Try 
           If FindData.OFindText<>Nil Then
              FindText.Items.Assign (FindData.OFindText);
         Except
         End;
         OldText :=FindText.Text;
         OldCase :=FindCase.Checked;
         OldSub  :=FindSub.Checked;
         OldNext :=FindNext.Enabled;
         OldPrev :=FindPrevious.Enabled;
         If FindFirstPage.Checked Then OldDir:=0
         Else
            If FindCurrentPage.Checked Then OldDir:=1
            Else
               If FindNext.Checked Then OldDir:=2
               Else
                  OldDir:=3;
      End;
      If FindForm.ShowModal=mrOK Then
      Begin
         If TextFound Then
         Begin
            FoundTimer:=8;
            TimerTimer(Nil);
         End;
         Application.ProcessMessages;
         FindText      :=True;
         TextFound     :=False;
         TextToFind    :=FindForm.FindText.Text;
         CaseSensitive :=FindForm.FindCase.Checked;
         SubString     :=FindForm.FindSub.Checked;
         NextItem      :=FindForm.FindNext.Checked;
         PrevItem      :=FindForm.FindPrevious.Checked;
         CurrPage      :=FindForm.FindCurrentPage.Checked;
         CurrObject    :=0;
         I:=0;
         While (I<=Report.EMFPages.Count-1) And (Not TextFound) Do
         Begin
            DrawPage(Panel.Canvas.Handle,I,Rect(0,0,10,10));
            Inc (I);
         End;
         FindText:=False;
         If TextFound Then
         Begin
            FindForm.FindNext.Enabled     := True;
            FindForm.FindPrevious.Enabled := (FindForm.FindNext.Checked) Or
                                             (FindForm.FindPrevious.Checked);
            If FindForm.FindText.Items.IndexOf (FindForm.FindText.Text)=-1 Then
               FindForm.FindText.Items.Add (FindForm.FindText.Text);
            If PageNo<>PageFound+1 Then SetPageNumber (PageFound+1);
            HScroll.Position := HScroll.Position + FindXY(PageFound).X + ExtRect.Left -
                                (Panel.Width-(ExtRect.Right - ExtRect.Left)) Div 2;
            VScroll.Position := VScroll.Position + FindXY(PageFound).Y + ExtRect.Top -
                               (Panel.Height-(ExtRect.Bottom - ExtRect.Top)) Div 2;
            TimerTimer (Nil);
         End
         Else
         Begin
            Application.MessageBox (PChar(FRConst_FindError),PChar(FRConst_FindTitle),
                        MB_OK or MB_ICONWARNING Or MB_SYSTEMMODAL);
         End;
      End
      Else
      Begin
         TextFound     :=False;
         With FindForm Do
         Begin
            FindText.Text        := OldText;
            FindCase.Checked     := OldCase;
            FindSub.Checked      := OldSub;
            FindNext.Enabled     := OldNext;
            FindPrevious.Enabled := OldPrev;
            Case OldDir of
               0: FindFirstPage.Checked   := True;
               1: FindCurrentPage.Checked := True;
               2: FindNext.Checked        := True;
               3: FindPrevious.Checked    := True;
            End;
         End;
         Vposition:=0;
         HPosition:=0;
         VScrollChange(Self);
      End;
      With FindForm Do
      Begin
         FindData.OFindCase := FindCase.Checked;
         FindData.OFindSub  := FindSub.Checked;
         If FindFirstPage.Checked Then FindData.OFindOrigin:=0
         Else
            If FindCurrentPage.Checked Then FindData.OFindOrigin:=1
            Else
               If FindNext.Checked Then FindData.OFindOrigin:=2
               Else FindData.OFindOrigin:=3;
         FindData.EnbNext := FindNext.Enabled;
         FindData.EnbPrev := FindPrevious.Enabled;
         FindData.OText   := FindText.Text;
         Try
            If FindData.OFindText<>Nil Then
               FindData.OFindText.Text:=FindText.Items.Text;
         Except
         End;
      End;
   Finally
      FindForm.Free; 
   End;
end;

procedure TStandardPreview.First;
begin
  SetPageNumber(1);
end;

procedure TStandardPreview.Last;
begin
  SetPageNumber(Report.EMFPages.Count);
end;

procedure TStandardPreview.Next;
begin
  if PageNo<Report.EMFPages.Count then
    if ZoomType<>ztTwoPages then
      SetPageNumber (PageNo+1)
    else SetPageNumber (PageNo+2);
  CheckZoom;
end;

procedure TStandardPreview.Prior;
begin
  if PageNo>1 then
    if ZoomType<>ztTwoPages then
      SetPageNumber (PageNo-1)
    else SetPageNumber (PageNo-2);
  CheckZoom;
end;

procedure TStandardPreview.ZoomWidth;
begin
  ZoomBtn.Text := FRConst_ZoomWidth;
  FZoomType := ztWidth;
  SetZoomFactor;
end;

procedure TStandardPreview.ZoomOnePage;
begin
  ZoomBtn.Text := FRConst_ZoomOnePage;
  FZoomType := ztOnePage;
  SetZoomFactor;
end;

procedure TStandardPreview.ZoomTwoPages;
begin
  ZoomBtn.Text := FRConst_ZoomTwoPages;
  FZoomType := ztTwoPages;
  SetZoomFactor;
end;

procedure TStandardPreview.ZoomBtnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then CheckZoom;
end;


//------------------------------------------------------------------------------

function GetOSVersion:Cardinal;
var
  Info: TOsVersionInfo;
begin
  Info.dwOSVersionInfoSize := SizeOf(Info);
  GetVersionEx (Info);
  Result := Info.dwPlatformId;
end;

function GetExeByExtension(SExt:String):String;
Var
   SExtD : String;
begin
   With TRegistry.Create do
   Begin
      Try
         RootKey:=HKEY_CLASSES_ROOT;
         If OpenKeyReadOnly(SExt) then
         begin
            SExtD:=ReadString('') ;
            CloseKey;
         End;
         If SExtD<>'' Then
         begin
            If OpenKeyReadOnly(SExtD+'\Shell\Open\Command') then
            begin
               Result:=ReadString('') ;
            End
         End;
      Finally
         Free;
      End;
   End;
   //
   If Result<>'' then
   Begin
      If Result[1]='"' then
         Result:=Copy(Result,2,-1+Pos('"',Copy(Result,2,MaxInt))) ;
   End;
End;

Initialization
  WinNT:=GetOSVersion>=VER_PLATFORM_WIN32_NT;
  PDFExe:=GetExeByExtension('.PDF') ;

  //
  Screen.Cursors [crHandFlat] := LoadCursor (HInstance,'HAND_FLAT');
  Screen.Cursors [crHandGrab] := LoadCursor (HInstance,'HAND_GRAB');
  Screen.Cursors [crMoveAll] := LoadCursor (HInstance,'MOVE_ALL');
  Screen.Cursors [crMoveN] := LoadCursor (HInstance,'MOVE_N');
  Screen.Cursors [crMoveS] := LoadCursor (HInstance,'MOVE_S');
  Screen.Cursors [crMoveE] := LoadCursor (HInstance,'MOVE_E');
  Screen.Cursors [crMoveW] := LoadCursor (HInstance,'MOVE_W');
  Screen.Cursors [crMoveNE] := LoadCursor (HInstance,'MOVE_NE');
  Screen.Cursors [crMoveNW] := LoadCursor (HInstance,'MOVE_NW');
  Screen.Cursors [crMoveSE] := LoadCursor (HInstance,'MOVE_SE');
  Screen.Cursors [crMoveSW] := LoadCursor (HInstance,'MOVE_SW');
  SetPreviewClass (TStandardPreview);

Finalization
  DestroyCursor (Screen.Cursors [crHandFlat]);
  DestroyCursor (Screen.Cursors [crHandGrab]);
  DestroyCursor (Screen.Cursors [crMoveAll]);
  DestroyCursor (Screen.Cursors [crMoveN]);
  DestroyCursor (Screen.Cursors [crMoveS]);
  DestroyCursor (Screen.Cursors [crMoveE]);
  DestroyCursor (Screen.Cursors [crMoveW]);
  DestroyCursor (Screen.Cursors [crMoveNE]);
  DestroyCursor (Screen.Cursors [crMoveNW]);
  DestroyCursor (Screen.Cursors [crMoveSE]);
  DestroyCursor (Screen.Cursors [crMoveSW]);

End.
