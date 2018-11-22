
{*****************************************}
{                                         }
{             FastReport v2.2             }
{             Report Designer             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Desgn;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Printers, ComCtrls,
  Menus, ImgList, FR_Class, FR_Color, FR_Const, FR_Pages;

const
  RegKey = 'Software\' + FRConst_RepNoName + '\';
  ToolBarName = 'ToolBas';
  Options = 'Options';
  Millimeters = 794 / 210;
  Inch = 96;

type
  TSelectionType = (ssBand, ssMemo, ssOther, ssMultiple, ssClipboardFull);
  TSelectionStatus = set of TSelectionType;

  TfrDesigner = class(TComponent) // fake component
  end;

  TCanvasPanel = class(TPanel)
  private
    property Canvas;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TFRDesignerForm = class(TfrReportDesigner)
    StatusBar1: TStatusBar;
    Popup1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    MainMenu1: TMainMenu;
    N4: TMenuItem;
    N7: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N26: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    Gr2: TMenuItem;
    N36: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    Pan5: TMenuItem;
    N8: TMenuItem;
    Gr3: TMenuItem;
    Gr4: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N22: TMenuItem;
    N35: TMenuItem;
    ImageList2: TImageList;
    N38: TMenuItem;
    Pan6: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N42: TMenuItem;
    MastMenu: TMenuItem;
    Gr5: TMenuItem;
    N16: TMenuItem;
    N37: TMenuItem;
    Pan1: TMenuItem;
    Pan2: TMenuItem;
    Pan3: TMenuItem;
    Pan4: TMenuItem;
    N15: TMenuItem;
    N34: TMenuItem;
    Undo: TMenuItem;
    Restore: TMenuItem;
    M1: TMenuItem;
    M2: TMenuItem;
    M3: TMenuItem;
    TabPages: TTabControl;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Horiz: TPanel;
    Vert: TPanel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel2: TPanel;
    AlB1: TSpeedButton;
    AlB2: TSpeedButton;
    AlB3: TSpeedButton;
    AlB4: TSpeedButton;
    AlB5: TSpeedButton;
    FnB1: TSpeedButton;
    FnB2: TSpeedButton;
    FnB3: TSpeedButton;
    ClB2: TSpeedButton;
    HlB1: TSpeedButton;
    AlB6: TSpeedButton;
    AlB7: TSpeedButton;
    AlB8: TSpeedButton;
    frTBSeparator6: TPanel;
    frTBSeparator7: TPanel;
    frTBSeparator8: TPanel;
    frTBSeparator9: TPanel;
    frTBPanel1: TPanel;
    C3: TComboBox;
    C2: TComboBox;
    Panel1: TPanel;
    FileBtn1: TSpeedButton;
    FileBtn2: TSpeedButton;
    FileBtn3: TSpeedButton;
    FileBtn4: TSpeedButton;
    CutB: TSpeedButton;
    CopyB: TSpeedButton;
    PstB: TSpeedButton;
    ZB1: TSpeedButton;
    ZB2: TSpeedButton;
    SelAllB: TSpeedButton;
    PgB1: TSpeedButton;
    PgB2: TSpeedButton;
    PgB3: TSpeedButton;
    GB2: TSpeedButton;
    ExitB: TSpeedButton;
    BtnPrev: TSpeedButton;
    BtnNext: TSpeedButton;
    frTBSeparator1: TPanel;
    frTBSeparator2: TPanel;
    frTBSeparator3: TPanel;
    frTBSeparator4: TPanel;
    frTBSeparator5: TPanel;
    frTBSeparator13: TPanel;
    Panel4: TPanel;
    OB1: TSpeedButton;
    OB2: TSpeedButton;
    OB3: TSpeedButton;
    OB4: TSpeedButton;
    OB5: TSpeedButton;
    Panel7: TPanel;
    Images: TImageList;
    Wiz1: TMenuItem;
    N41: TMenuItem;
    ReopenMenu: TMenuItem;
    PgB4: TSpeedButton;
    FrB1: TSpeedButton;
    FrB2: TSpeedButton;
    FrB3: TSpeedButton;
    FrB4: TSpeedButton;
    FrB5: TSpeedButton;
    FrB6: TSpeedButton;
    ClB1: TSpeedButton;
    frTBSeparator11: TPanel;
    frTBSeparator10: TPanel;
    ClB3: TSpeedButton;
    UpDown1: TUpDown;
    Edit1: TEdit;
    Panel3: TPanel;
    Panel9: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DoClick(Sender: TObject);
    procedure ClB1Click(Sender: TObject);
    procedure RenumerTabPages;
    procedure ZB1Click(Sender: TObject);
    procedure ZB2Click(Sender: TObject);
    procedure PgB1Click(Sender: TObject);
    procedure PgB2Click(Sender: TObject);
    procedure OB2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OB1Click(Sender: TObject);
    procedure CutBClick(Sender: TObject);
    procedure CopyBClick(Sender: TObject);
    procedure PastBClick(Sender: TObject);
    procedure SelAllBClick(Sender: TObject);
    procedure ExitBClick(Sender: TObject);
    procedure PgB3Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure Gr2Click(Sender: TObject);
    procedure GB2Click(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure FileBtn1Click(Sender: TObject);
    procedure FileBtn2Click(Sender: TObject);
    procedure FileBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure Gr3Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure C2DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure HlB1Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure FileBtn4Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure Popup1Popup(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure Pan1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure BtnPrevClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure FileBtn31Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure M1Click(Sender: TObject);
    procedure MastMenuClick(Sender: TObject);
    procedure TabPagesChange(Sender: TObject);
    procedure Wiz1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure C3KeyPress(Sender: TObject; var Key: Char);
    procedure N4Click(Sender: TObject);
    procedure PgB4Click(Sender: TObject);
  private
    { Private declarations }
    FCurPage: Integer;
    ColorSelector: TColorSelector;
    FGridSize, FUnits: Integer;
    FConverter: Double;
    FGridAlign, ShowInsp, ShowAlign: Boolean;
    ImgHoriz, ImgVert: TCanvasPanel;
    procedure GetFontList;
    procedure SetCurPage(Value: Integer);
    procedure SetGridSize(Value: Integer);
    procedure SetGridAlign(Value: Boolean);
    function GetSelectionStatus: TSelectionStatus;
    procedure ShowUnit;
    procedure SelectionChanged;
    procedure EnableControls;
    procedure ResetSelection;
    procedure DeleteObjects;
    procedure RemovePage(n: Integer);
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure FillInspFields;
    function RectTypEnabled: Boolean;
    function FontTypEnabled: Boolean;
    function ZEnabled: Boolean;
    function CutEnabled: Boolean;
    function CopyEnabled: Boolean;
    function PasteEnabled: Boolean;
    function DelEnabled: Boolean;
    function EditEnabled: Boolean;
    procedure ColorSelected(Sender: TObject);
    procedure MoveObjects(dx, dy: Integer; Resize: Boolean);
    procedure SelectAll;
    procedure Unselect;
    procedure WorkWithTheClipboard(Del: Boolean);
    procedure CutToClipboard;
    procedure CopyToClipboard;
    procedure SaveState;
    procedure RestoreState;
    procedure ActiveForm;
    procedure DeActiveForm;
    function SaveAsOK: Boolean;
    function SaveOK: Boolean;
    procedure Load(S: string);
    procedure AggiornaRecenti(sFileName: string);
    procedure ReOpenReport(Sender: TObject);
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
  protected
  public
    { Public declarations }
    procedure ClearChangedList; override;
    procedure RegisterObject(ButtonBmp: TBitmap; const ButtonHint: string;
      ButtonTag: Integer); override;
    procedure PopupNotify(Sender: TfrView); override;
    procedure ChangeObject; // Stored into the TList of Stream the current Report
    procedure ShowMemoEditor;
    procedure ShowEditor;
    procedure RedrawPage;
    procedure OnModify(Item: Integer; var EditText: ShortString);
    procedure OnSelect(N: ShortString);
    property CurPage: Integer read FCurPage write SetCurPage;
    property SelStatus: TSelectionStatus read GetSelectionStatus;
    property GridSize: Integer read FGridSize write SetGridSize;
    property Units: Integer read FUnits;
    property GridAlign: Boolean read FGridAlign write SetGridAlign;
    property Converter: Double read FConverter;
  end;

  TPreview = class(TPanel)
  private
    property Canvas;
    procedure MDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure WMMove(var Msg: TWMMove); message WM_MOVE;
    procedure DClick(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetPage;
    procedure GetMultipleSelected;
    procedure NormalizeRect(var r: TRect);
  end;

function DesignerForm: TfrDesignerForm;
function frGetTopSelected: Integer;
procedure frSetGlyph(Color: TColor; sb: TSpeedButton; n: Integer);
procedure frRegisterTool(MenuCaption: string; OnClick: TNotifyEvent);
function frCheckBand(b: TfrBandType): Boolean;

procedure ClearClipBoard; //Itta
procedure NullList; //Itta

var
  Preview: TPreview;
  FirstSelected: TfrView;
  SelNum: Integer; // number of objects currently selected
  NoPreview: Boolean;
  OldCaption: string;
  ListAction: TList;
  IndexAction: Integer;
  CurFontColor, CurFillColor, CurFrameColor: TColor;
  ClipBd: TList; //Itta clipboard
  SaveMenu: TStringList; //Itta


  
implementation

{$R *.DFM}
{$R CoolMenu.RES}

uses
  FR_Pgopt, FR_GEdit, FR_Edit, FR_Templ, FR_Newrp, FR_Insp,
  FR_Prntr, FR_Hilit, FR_Flds, FR_Dopt, FR_Align, FR_Ev_ed,
  FR_BndEd, FR_BTyp, FR_Utils, FR_GrpEd, Registry, FR_Wizar, FR_Load,
  FR_Save;

type
  TDesignerDrawMode = (dmAll, dmSelection, dmShape);
  TSplitInfo = record
    SplRect: TRect;
    SplX: Integer;
    View1, View2: TfrView;
  end;

procedure DrawFocusRect(Canvas: TCanvas; Rect: TRect); forward;
procedure DrawHSplitter(Canvas: TCanvas; Rect: TRect); forward;
procedure DrawSelection(t: TfrView); forward;
procedure DrawShape(t: TfrView); forward;
procedure Draw(N: Integer; ClipRgn: HRGN); forward;
procedure DrawPage(DrawMode: TDesignerDrawMode); forward;
function GetUnusedBand: TfrBandType; forward;
procedure SendBandsToDown; forward;
procedure Unselect; forward;
//Itta procedure ClearClipBoard; forward;
function Objects: TList; forward;
procedure GetRegion; forward;

var
  Down, // mouse button was pressed
  Moved, // mouse was moved (with pressed btn)
  DFlag, // was double click
  RFlag, // selecting objects by framing
  OIFlag, // object inspector flag
  MRFlag, // several objects was selected
  ObjRepeat: Boolean; // was pressed Shift + Insert Object
//Itta  ClipBd: TList; // clipboard
  Mode: (mdInsert, mdSelect); // current mode
  LastX, LastY: Integer; // here stored last mouse coords
  OldRect, OldRect1: TRect; // object rect after mouse was clicked
  CT: (ctNone, ct1, ct2, ct3, ct4); // current mouse cursor (sizing arrows)
  BPanel, RPanel: TPanel; // special panels (see TDesignForm.Create)
  Busy: Boolean; // busy flag. need!
  RightBottom: Integer;
  fld: array[0..6] of shortstring;
  ShapeMode: (smFrame, smBar); // show selection: frame or bar
  GridBitmap: TBitmap; // for drawing grid in design time
  LastFontName: string;
  LastFontSize: Integer;
  LeftTop: TPoint;
  ClrButton: TSpeedButton;
  FirstChange, FirstBandMove: Boolean;
  SplitInfo: TSplitInfo;
  ClipRgn: HRGN;
  MoveObject: Boolean;
//Itta  SaveMenu: TStringList;

function DesignerForm: TfrDesignerForm;
begin
  Result := TfrDesignerForm(frDesigner);
end;

procedure SaveToolBar(T: TPanel);
var
  Ini: TRegIniFile;
begin
  Ini := TRegIniFile.Create(RegKey);
  Ini.WriteBool(ToolBarName, T.Name, T.Visible);
  Ini.Free;
end;

procedure RestoreToolBar(T: TPanel);
var
  Ini: TRegIniFile;
begin
  Ini := TRegIniFile.Create(RegKey);
  T.Visible := Ini.ReadBool(ToolBarName, T.Name, T.Visible);
  Ini.Free;
end;

procedure SaveFormPosition(f: TForm);
var
  Ini: TRegIniFile;
begin
  Ini := TRegIniFile.Create(RegKey);
  Ini.WriteBool(F.Name, 'Visible', F.Visible);
  Ini.WriteInteger(F.Name, 'Left', F.Left);
  Ini.WriteInteger(F.Name, 'Top', F.Top);
  Ini.WriteInteger(F.Name, 'Width', F.Width);
  Ini.WriteInteger(F.Name, 'Height', F.Height);
  Ini.Free;
end;

procedure RestoreFormPosition(f: TForm);
var
  Ini: TRegIniFile;
begin
  Ini := TRegIniFile.Create(RegKey);
  if F = InspForm then
    begin
      F.Left := Ini.ReadInteger(F.Name, 'Left', Screen.Width - F.Width - 25);
      F.Top := Ini.ReadInteger(F.Name, 'Top', 20);
    end
  else
    begin
      F.Left := Ini.ReadInteger(F.Name, 'Left', Screen.Width - InspForm.Width - 25 - F.Width);
      F.Top := Ini.ReadInteger(F.Name, 'Top', InspForm.Height - F.Height + InspForm.Top);
    end;
  F.Visible := Ini.ReadBool(F.Name, 'Visible', True);
  F.Width := Ini.ReadInteger(F.Name, 'Width', F.Width);
  F.Height := Ini.ReadInteger(F.Name, 'Height', F.Height);
  Ini.Free;
end;

procedure SaveReport;
var
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  with DesignerForm do
    begin
      M.Write(CurPage, 4);
      CurReport.SaveToStream(M);
    end;
  ListAction.Add(M);
end;

procedure LoadReport;
var
  M: TMemoryStream;
  PageN, OldN: Integer;
begin
  OldN := CurReport.Pages.Count;
  M := TMemoryStream(ListAction[IndexAction]);
  M.Position := 0;
  with DesignerForm do
    begin
      M.Read(PageN, 4);
      CurReport.LoadFromStream(M);
      if CurReport.Pages.Count <> OldN then RenumerTabPages;
      CurPage := PageN;
    end;
end;

function OnlyName: string;
begin
  if Pos('.frf', LowerCase(ExtractFileName(CurReport.FileName))) > 0 then
    Result := Copy(ExtractFileName(CurReport.FileName), 1,
      Pos('.', ExtractFileName(CurReport.FileName)) - 1)
  else
    Result := ExtractFileName(CurReport.FileName);
end;

function TFRDesignerForm.SaveOK: Boolean;
var
  CurDir: string;
begin
  if CurReport.FileName = '' then
    begin
      Result := SaveAsOK
    end
  else
    begin
      try
        if CurReport.ReportDir <> '' then
          begin
            CurDir := GetCurrentDir;
            SetCurrentDir(CurReport.ReportDir);
          end;
        CurReport.SaveToFile(CurReport.FileName);
        AggiornaRecenti(CurReport.FileName);
        if CurReport.ReportDir <> '' then
          begin
            SetCurrentDir(CurDir);
          end;
        Result := True;
      except
        Result := False;
      end;
    end;
end;

function TFRDesignerForm.SaveAsOK: Boolean;
var
  S: string;
  CurDir: string;
  sFileName: string;
begin
  Result := False;
  // save as
  if CurReport.ReportDir = '' then
    with SaveDialog1 do
      begin
        Filter := FRConst_FormFile + ' (*.frf)|*.frf|' +
          FRConst_TemplFile + ' (*.frt)|*.frt';
        FileName := CurReport.FileName;
        FilterIndex := 1;
        if Execute then
          begin
            if FilterIndex = 1 then
              begin
                s := '.frf';
                CurReport.SaveToFile(ChangeFileExt(FileName, s));
                AggiornaRecenti(sFileName);
                Caption := OldCaption + ' - ' + OnlyName;
              end
            else
              begin
                s := ExtractFileName(ChangeFileExt(FileName, '.frt'));
                if CurReport.TemplateDir <> '' then
                  s := CurReport.TemplateDir + '\' + s;
                TemplNewForm := TTemplNewForm.Create(nil);
                try
                  with TemplNewForm do
                    begin
                      if ShowModal = mrOk then
                        begin
                          CurReport.SaveTemplate(s, Memo1.Lines, Image1.Picture.Bitmap);
                          AggiornaRecenti(S);
                        end;
                    end;
                finally
                  TemplNewForm.Free;
                end;
              end;
            Result := True;
          end;
      end
  else
    begin
      CurDir := GetCurrentDir;
      SetCurrentDir(CurReport.ReportDir);
      SaveForm := TSaveForm.Create(nil);
      try
        SaveForm.FileName := CurReport.FileName;
        if SaveForm.Execute then
          begin
            if (not FileExists(SaveForm.FileName)) or
              (Application.MessageBox(FRConst_FileOverWrite,
              FRConst_Attenction,
              MB_YesNo or MB_ICONQUESTION or MB_DefButton2) = ID_Yes) then
              begin
                CurReport.SaveToFile(SaveForm.FileName);
                AggiornaRecenti(SaveForm.FileName);
                Caption := OldCaption + ' - ' + OnlyName;
              end;
          end;
      finally
        SaveForm.Free;
        SetCurrentDir(CurDir);
      end;
    end;
end;

function OKNew: Boolean;
var
  I: Integer;
  S: string;
begin
  //Itta
  If Assigned(CurReport.ToStream) Then
  Begin
     //Result:=DesignerForm.SaveAsOK;
     Result:=True;
     Exit;
  End;
  //

  if not (doSaveConfirm in CurReport.DesignerOptions) then
    Result := True
  else
  begin
      if not DesignerForm.FileBtn3.Enabled then
        Result := True
      else
      begin
          if CurReport.FileName = '' then
            S := FRConst_MessageNewBlank
          else
            S := FRConst_MessageNew + ' ' +
              ExtractFileName(CurReport.FileName) + ' ?';
          I := Application.MessageBox(PChar(S), FRConst_Attenction,
            MB_YesNoCancel or MB_ICONQUESTION or MB_DefButton1);
          if I = ID_No then
            begin
              Result := True;
              I := IndexAction;
              IndexAction := 0;
              LoadReport;
              IndexAction := I;
            end
          else
          Begin
            if I = ID_Cancel then
              Result := False
            else
              Result := DesignerForm.SaveOK;
          End;
          //Result:=True; //Itta
        end;
    end;
end;

procedure NullList;
var
  I: Integer;
begin
  for I := 0 to ListAction.Count - 1 do
    begin
      TMemoryStream(ListAction[0]).Free;
      ListAction.Delete(0);
    end;
  if DesignerForm <> nil then
    begin
      with DesignerForm do
        begin
          BtnPrev.Enabled := False;
          BtnNext.Enabled := False;
          FileBtn3.Enabled := False;
          Undo.Enabled := False;
          Restore.Enabled := False;
          //N15.Enabled:=False;
          N20.Enabled := False;
        end;
      DesignerForm.ChangeObject;
    end;
end;

procedure TFRDesignerForm.ClearChangedList;
begin
  NullList;
end;

procedure TFRDesignerForm.ChangeObject;
var
  I: Integer;
begin
  if IndexAction < ListAction.Count - 1 then
    for I := IndexAction + 1 to ListAction.Count - 1 do
      begin
        TMemoryStream(ListAction[ListAction.Count - 1]).Free;
        ListAction.Delete(ListAction.Count - 1);
      end;
  SaveReport;
  IndexAction := ListAction.Count - 1;

  if ListAction.Count > 1 then
    begin
      BtnPrev.Enabled := True;
      FileBtn3.Enabled := True;
      //N15.Enabled:=True;
      N20.Enabled := True;
      Undo.Enabled := True;
    end
  else
    begin
      BtnPrev.Enabled := False;
      Undo.Enabled := False;
    end;
  BtnNext.Enabled := False;
  Restore.Enabled := False;
  if CurReport.Pages.Count < TabPages.Tabs.Count then
    begin
      TabPages.Tabs.Delete(TabPages.Tabs.Count - 1);
      //CurPage := CurPage; //Itta
      CurPage:=TabPages.Tabs.Count-1;
    end;
end;

procedure frRegisterTool(MenuCaption: string; OnClick: TNotifyEvent);
var
  m: TMenuItem;
begin
  m := TMenuItem.Create(DesignerForm.MastMenu);
  m.Caption := MenuCaption;
  m.OnClick := OnClick;
  DesignerForm.MastMenu.Enabled := True;
  DesignerForm.MastMenu.Add(m);
end;

{--------------------------------------------------}
constructor TCanvasPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  Canvas.Font.Name := 'Times New Roman';
  Canvas.Font.Size := 7;
end;

procedure TCanvasPanel.Paint;
var
  R: HRGN;
  I: Integer;
  PixelTo2: Double;
  X: Byte;
begin
  if (CurReport = nil) or (CurReport.Pages.Count = 0) then Exit;
  case DesignerForm.Units of
    0:
      begin
        PixelTo2 := 3;
        X := 3;
      end;
    1:
      begin
        PixelTo2 := Millimeters;
        X := 1;
      end;
  else
    begin
      PixelTo2 := Inch / 10;
      X := 1;
    end;
  end;

  if frCharset <> DEFAULT_CHARSET then
    Canvas.Font.Charset := frCharset;

  R := CreateRectRgn(0, 0, Width, Height);
  SelectClipRgn(Canvas.Handle, R);
  with Canvas do
    begin
      Brush.Color := clWhite;
      Brush.Style := bsSolid;
      Rectangle(0, 0, Width, Height);
      if Parent = DesignerForm.Horiz then
        begin
          Brush.Color := clGray;
          Rectangle(0, 0, CurReport.Pages.Pages[DesignerForm.CurPage].
            pgMargins.Left + 1, Height);
          Rectangle(Width - CurReport.Pages.Pages[DesignerForm.CurPage].
            pgMargins.Right - 1, 0, Width, Height);
          Brush.Color := clNone;
          Brush.Style := bsClear;
          for I := 0 to (Width div 5) do
            if I mod 2 = 0 then
              TextOut(Round(I * 5 * PixelTo2) -
                TextWidth(IntToStr(I * X div 2)) div 2, 1,
                IntToStr(I * X div 2))
            else
              Rectangle(Round(I * 5 * PixelTo2), 5,
                Round(I * 5 * PixelTo2) + 1, Height - 5);
        end
      else
        begin
          Brush.Color := clGray;
          Rectangle(0, 0, Width, CurReport.Pages.Pages[DesignerForm.CurPage].
            pgMargins.Top + 1);
          Rectangle(0, Height - CurReport.Pages.Pages[DesignerForm.CurPage].
            pgMargins.Bottom - 1, Width, Height);
          Brush.Color := clNone;
          Brush.Style := bsClear;
          for I := 0 to (Height div 5) do
            if I mod 2 = 0 then
              TextOut((Width div 2) - TextWidth(IntToStr(I * X div 2)) div 2,
                Round(I * 5 * PixelTo2) - 6, IntToStr(I * X div 2))
            else
              Rectangle(5, Round(I * 5 * PixelTo2), Width - 5,
                Round(I * 5 * PixelTo2) + 1);
        end;
    end;
  DeleteObject(R);
  SelectClipRgn(Canvas.Handle, 0);
end;

{--------------------------------------------------}
constructor TPreview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Color := clWhite;
  BorderStyle := bsNone;
  OnMouseDown := MDown;
  OnMouseUp := MUp;
  OnMouseMove := MMove;
  OnDblClick := DClick;
end;

procedure TPreview.SetPage;
var
  Pgw, Pgh: Integer;
begin
  if frDesigner.Page = nil then Exit;
  Pgw := frDesigner.Page.PrnInfo.Pgw;
  Pgh := frDesigner.Page.PrnInfo.Pgh;
  if Pgw > Parent.Width then
    SetBounds(10, 10, Pgw, Pgh)
  else
    SetBounds((Parent.Width - Pgw) div 2, 10, Pgw, Pgh);
  BPanel.Top := Top + Height + 10;
  RPanel.Left := Left + Width + 10;
end;

procedure TPreview.Paint;
begin
  Draw(10000, 0);
  DesignerForm.ShowUnit;
end;

procedure TPreview.WMMove(var Msg: TWMMove);
begin
  inherited;
  DesignerForm.ImgHoriz.Left := Preview.Left + 2;
  DesignerForm.ImgVert.Top := Preview.Top + 2;
end;

procedure TPreview.GetMultipleSelected;
var
  i, j, k: Integer;
  t: TfrView;
begin
  j := 0;
  k := 0;
  LeftTop := Point(10000, 10000);
  RightBottom := -1;
  MRFlag := False;
  if SelNum > 1 then {find right-bottom element}
    begin
      for i := 0 to Objects.Count - 1 do
        begin
          t := Objects[i];
          if t.Selected then
            begin
              t.OriginalRect := Rect(t.Left, t.Top, t.Width, t.Height);
              if (t.Left + t.Width > j) or ((t.Left + t.Width = j) and (t.Top + t.Height > k)) then
                begin
                  j := t.Left + t.Width;
                  k := t.Top + t.Height;
                  RightBottom := i;
                end;
              if t.Left < LeftTop.x then LeftTop.x := t.Left;
              if t.Top < LeftTop.y then LeftTop.y := t.Top;
            end;
        end;
      t := Objects[RightBottom];
      OldRect := Rect(LeftTop.x, LeftTop.y, t.Left + t.Width, t.Top + t.Height);
      OldRect1 := OldRect;
      MRFlag := True;
    end;
end;

procedure TPreview.NormalizeRect(var r: TRect);
var
  i: Integer;
begin
  with r do
    begin
      if Left > Right then
        begin
          i := Left;
          Left := Right;
          Right := i
        end;
      if Top > Bottom then
        begin
          i := Top;
          Top := Bottom;
          Bottom := i
        end;
    end;
end;

procedure TPreview.MDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  f, DontChange, v: Boolean;
  t: TfrView;
  Rgn: HRGN;
  p: TPoint;
begin
  DesignerForm.ColorSelector.Visible := False;
  if DFlag then
    begin
      DFlag := False;
      Exit;
    end;
  DrawPage(dmSelection);
  Down := True;
  DontChange := False;
  if Button = mbLeft then
    if (ssCtrl in Shift) or (Cursor = crCross) then
      begin
        RFlag := True;
        OldRect := Rect(x, y, x, y);
        Unselect;
        SelNum := 0;
        RightBottom := -1;
        MRFlag := False;
        FirstSelected := nil;
        Exit;
      end;
  if Cursor = crDefault then
    begin
      f := False;
      for i := Objects.Count - 1 downto 0 do
        begin
          t := Objects[i];
          Rgn := t.GetClipRgn(rtNormal);
          v := PtInRegion(Rgn, X, Y);
          DeleteObject(Rgn);
          if v then
            begin
              if ssShift in Shift then
                begin
                  t.Selected := not t.Selected;
                  if t.Selected then
                    Inc(SelNum)
                  else
                    Dec(SelNum);
                end
              else
                begin
                  if not t.Selected then
                    begin
                      Unselect;
                      SelNum := 1;
                      t.Selected := True;
                    end
                  else
                    DontChange := True;
                end;
              if SelNum = 0 then
                FirstSelected := nil
              else
                if SelNum = 1 then
                  FirstSelected := t
                else
                  if FirstSelected <> nil then
                    if not FirstSelected.Selected then FirstSelected := nil;
              f := True;
              break;
            end;
        end;
      if not f then
        begin
          Unselect;
          SelNum := 0;
          FirstSelected := nil;
          if Button = mbLeft then
            begin
              RFlag := True;
              OldRect := Rect(x, y, x, y);
              Exit;
            end;
        end;
      GetMultipleSelected;
      if not DontChange then DesignerForm.SelectionChanged;
    end;
  if SelNum = 0 then
    begin // reset multiple selection
      RightBottom := -1;
      MRFlag := False;
    end;
  LastX := x;
  LastY := y;
  Moved := False;
  FirstChange := True;
  FirstBandMove := True;
  if Button = mbRight then
    begin
      DrawPage(dmSelection);
      Down := False;
      GetCursorPos(p);
      DesignerForm.Popup1Popup(nil);
      DesignerForm.Popup1.Popup(p.X, p.Y);
    end
  else
    DrawPage(dmShape);
end;

procedure TPreview.MUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, k, dx, dy: Integer;
  t: TfrView;
  nx, ny, x1, x2, y1, y2: Double;
  procedure AddObject(ot: Byte);
  begin
    Objects.Add(frCreateObject(ot, ''));
    t := Objects.Last;
  end;
  procedure CreateMemo;
  begin
    Objects.Add(TfrMemoView.Create(CurReport));
    t := Objects.Last;
  end;
  function CreateSection: Boolean;
  begin
    BandTypesForm := TBandTypesForm.Create(nil);
    if BandTypesForm.ShowModal = mrOK then
      begin
        Objects.Add(TfrBandView.Create(CurReport));
        t := Objects.Last;
        TfrBandView(t).bandType := TfrBandType(BandTypesForm.SelectedTyp);
        BandTypesForm.Free;
        SendBandsToDown;
        Result := True
      end
    else
      begin
        BandTypesForm.Free;
        Result := False
      end
  end;
  procedure CreateSubReport;
  begin
    Objects.Add(TfrSubReportView.Create(CurReport));
    t := Objects.Last;
    (t as TfrSubReportView).SubPage := CurReport.Pages.Count;
    with DesignerForm do
      begin
        ResetSelection;
        CurReport.Pages.Add;
        TabPages.Tabs.Add(FRConst_Pg + ' ' + IntToStr(CurReport.Pages.Count));
      end;
  end;

begin
  if Button <> mbLeft then Exit;
  Down := False;
  DrawPage(dmShape);
  //inserting a new object
  if Cursor = crCross then
    begin
      DrawFocusRect(Canvas, OldRect);
      NormalizeRect(OldRect);
      if DesignerForm.GridAlign then
        with OldRect do
          begin
            Left := Left - Left mod DesignerForm.GridSize;
            Top := Top - Top mod DesignerForm.GridSize;
            Right := Right - Right mod DesignerForm.GridSize;
            Bottom := Bottom - Bottom mod DesignerForm.GridSize;
          end;
      RFlag := False;
      with DesignerForm.Panel4 do
        for i := 0 to ControlCount - 1 do
          if Controls[i] is TSpeedButton then
            with Controls[i] as TSpeedButton do
              if Down then
                begin
                  if Tag = gtBand then
                    if GetUnusedBand <> btNone then
                      if not CreateSection then
                        Exit
                      else
                    else
                      Exit
                  else
                    if Tag = gtSubReport then
                      CreateSubReport
                    else
                      if Tag >= gtAddIn then
                        begin
                          k := Tag - gtAddIn;
                          Objects.Add(frCreateObject(gtAddIn, frAddIns[k].ClassRef.ClassName));
                          t := Objects.Last;
                        end
                      else
                        AddObject(Tag);
                  break;
                end;
      with OldRect do
        if (Left = Right) or (Top = Bottom) then
          if T is TfrCustomMemoView then
            OldRect := Rect(Left, Top, Left + 120, Top + 16)
          else
            OldRect := Rect(Left, Top, Left + 120, Top + 48);

      Unselect;
      t.Left := OldRect.Left;
      t.Top := OldRect.Top;
      t.Width := OldRect.Right - OldRect.Left;
      t.Height := OldRect.Bottom - OldRect.Top;
      t.Selected := True;
      t.FrameWidth := 1;
      if t.Typ <> gtBand then T.SetAllFrames;
      if t is TfrMemoView then
        with t as TfrMemoView do
          begin
            Font.Name := LastFontName;
            Font.Size := LastFontSize;
          end;
      SelNum := 1;
      if t.Typ = gtBand then
        Draw(10000, t.GetClipRgn(rtExtended))
      else
        begin
          t.Draw(Canvas);
          DrawSelection(t);
        end;
      if not ObjRepeat then DesignerForm.OB1.Down := True;
      DesignerForm.SelectionChanged;
      DesignerForm.ChangeObject;
      InspForm.AddObject(String(T.Name));
      Exit;
    end;
  //calculating which objects contains in frame (if user select it with mouse+Ctrl key)
  if RFlag then
    begin
      DrawFocusRect(Canvas, OldRect);
      RFlag := False;
      NormalizeRect(OldRect);
      for i := 0 to Objects.Count - 1 do
        begin
          t := Objects[i];
          with OldRect do
            if not ((t.Left > Right) or (t.Left + t.Width < Left) or
              (t.Top > Bottom) or (t.Top + t.Height < Top)) then
              begin
                t.Selected := True;
                Inc(SelNum);
              end;
        end;
      GetMultipleSelected;
      DesignerForm.SelectionChanged;
      DrawPage(dmSelection);
      Exit;
    end;
  // splitting
  if Moved and MRFlag and (Cursor = crHSplit) then
    begin
      with SplitInfo do
        begin
          dx := SplRect.Left - SplX;
          if (View1.Width + dx > 0) and (View2.Width - dx > 0) then
            begin
              Inc(View1.Width, dx);
              Inc(View2.Left, dx);
              Dec(View2.Width, dx);
            end;
        end;
      GetMultipleSelected;
      Draw(frGetTopSelected, ClipRgn);
      Exit;
    end;
  // resizing several objects
  if Moved and MRFlag and (Cursor <> crDefault) then
    begin
      DrawFocusRect(Canvas, OldRect);
      nx := (OldRect.Right - OldRect.Left) / (OldRect1.Right - OldRect1.Left);
      ny := (OldRect.Bottom - OldRect.Top) / (OldRect1.Bottom - OldRect1.Top);
      for i := 0 to Objects.Count - 1 do
        begin
          t := Objects[i];
          if t.Selected then
            begin
              x1 := (t.OriginalRect.Left - LeftTop.x) * nx;
              x2 := t.OriginalRect.Right * nx;
              dx := Round(x1 + x2) - (Round(x1) + Round(x2));
              t.Left := LeftTop.x + Round(x1);
              t.Width := Round(x2) + dx;

              y1 := (t.OriginalRect.Top - LeftTop.y) * ny;
              y2 := t.OriginalRect.Bottom * ny;
              dy := Round(y1 + y2) - (Round(y1) + Round(y2));
              t.Top := LeftTop.y + Round(y1);
              t.Height := Round(y2) + dy;
            end;
        end;
      Draw(frGetTopSelected, ClipRgn);
      Exit;
    end;
  // redrawing all moved or resized objects
  if not Moved then DrawPage(dmSelection);
  if (SelNum >= 1) and Moved then
    if SelNum > 1 then
      begin
        Draw(frGetTopSelected, ClipRgn);
        GetMultipleSelected;
      end
    else
      begin
        t := Objects[frGetTopSelected];
        if t.Width < 0 then
          begin
            t.Width := -t.Width;
            t.Left := t.Left - t.Width;
          end;
        if t.Height < 0 then
          begin
            t.Height := -t.Height;
            t.Top := t.Top - t.Height;
          end;
        if Cursor <> crDefault then
          begin
            t.Resized;
            DesignerForm.ChangeObject;
          end;
        Draw(frGetTopSelected, ClipRgn);
        DesignerForm.FillInspFields;
        InspForm.ItemsChanged;
      end;
  Moved := False;
  CT := ctNone;
end;

procedure TPreview.MMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i, j, kx, ky, w: Integer;
  t, t1, Bnd: TfrView;
  function Cont(px, py, x, y: Integer): Boolean;
  begin
    Result := (x >= px - w) and (x <= px + w + 1) and (y >= py - w) and (y <= py + w + 1);
  end;
  function GridCheck: Boolean;
  begin
    with DesignerForm do
      begin
        Result := (kx >= GridSize) or (kx <= -GridSize) or
          (ky >= GridSize) or (ky <= -GridSize);
        if Result then
          begin
            kx := kx - kx mod GridSize;
            ky := ky - ky mod GridSize;
          end;
      end;
  end;

begin
  if NoPreview then
    begin
      Moved := True;
      w := 2;
      if FirstChange and Down and not RFlag then GetRegion;

      if not Down then
        if DesignerForm.OB1.Down then
          begin
            Mode := mdSelect;
            Cursor := crDefault;
          end
        else
          begin
            Mode := mdInsert;
            Cursor := crCross;
          end;
      // cursor shapes
      if not Down and (SelNum = 1) and (Mode = mdSelect) then
        begin
          t := Objects[frGetTopSelected];
          if Cont(t.Left, t.Top, x, y) or Cont(t.Left + t.Width, t.Top + t.Height, x, y) then
            Cursor := crSizeNWSE
          else
            if Cont(t.Left + t.Width, t.Top, x, y) or Cont(t.Left, t.Top + t.Height, x, y) then
              Cursor := crSizeNESW
            else
              if Cont(t.Left + t.Width div 2, t.Top, x, y) or Cont(t.Left + t.Width div 2, t.Top + t.Height, x, y) then
                Cursor := crSizeNS
              else
                if Cont(t.Left, t.Top + t.Height div 2, x, y) or Cont(t.Left + t.Width, t.Top + t.Height div 2, x, y) then
                  Cursor := crSizeWE
                else
                  Cursor := crDefault;
        end;
      // selecting a lot of objects
      if RFlag then
        begin
          DrawFocusRect(Canvas, OldRect);
          OldRect := Rect(OldRect.Left, OldRect.Top, x, y);
          DrawFocusRect(Canvas, OldRect);
          Exit;
        end;
      // check for multiple selected objects - right-bottom corner
      if not Down and (SelNum > 1) and (Mode = mdSelect) then
        begin
          t := Objects[RightBottom];
          if Cont(t.Left + t.Width, t.Top + t.Height, x, y) then
            Cursor := crSizeNWSE
        end;
      // split checking
      if not Down and (SelNum > 1) and (Mode = mdSelect) then
        begin
          for i := 0 to Objects.Count - 1 do
            begin
              t := Objects[i];
              if (t.Typ <> gtBand) and t.Selected then
                if (x >= t.Left) and (x <= t.Left + t.Width) and (y >= t.Top) and (y <= t.Top + t.Height) then
                  begin
                    for j := 0 to Objects.Count - 1 do
                      begin
                        t1 := Objects[j];
                        if (t1.Typ <> gtBand) and (t1 <> t) and t1.Selected then
                          if ((t.Left = t1.Left + t1.Width) and ((x >= t.Left) and (x <= t.Left + 2))) or
                            ((t1.Left = t.Left + t.Width) and ((x >= t1.Left - 2) and (x <= t.Left))) then
                            begin
                              Cursor := crHSplit;
                              with SplitInfo do
                                begin
                                  SplRect := Rect(x, t.Top, x, t.Top + t.Height);
                                  if t.Left = t1.Left + t1.Width then
                                    begin
                                      SplX := t.Left;
                                      View1 := t1;
                                      View2 := t;
                                    end
                                  else
                                    begin
                                      SplX := t1.Left;
                                      View1 := t;
                                      View2 := t1;
                                    end;
                                  SplRect.Left := SplX;
                                  SplRect.Right := SplX;
                                end;
                            end;
                      end;
                  end;
            end;
        end;
      // splitting
      if Down and MRFlag and (Mode = mdSelect) and (Cursor = crHSplit) then
        begin
          kx := x - LastX;
          ky := 0;
          if DesignerForm.GridAlign and not GridCheck then Exit;
          with SplitInfo do
            begin
              DrawHSplitter(Canvas, SplRect);
              SplRect := Rect(SplRect.Left + kx, SplRect.Top, SplRect.Right + kx, SplRect.Bottom);
              DrawHSplitter(Canvas, SplRect);
            end;
          LastX := x - ((x - LastX) - kx);
          Exit;
        end;
      // sizing several objects
      if Down and MRFlag and (Mode = mdSelect) and (Cursor <> crDefault) then
        begin
          kx := x - LastX;
          ky := y - LastY;
          if DesignerForm.GridAlign and not GridCheck then Exit;
          DrawFocusRect(Canvas, OldRect);
          OldRect := Rect(OldRect.Left, OldRect.Top, OldRect.Right + kx, OldRect.Bottom + ky);
          DrawFocusRect(Canvas, OldRect);
          LastX := x - ((x - LastX) - kx);
          LastY := y - ((y - LastY) - ky);
          DesignerForm.StatusBar1.Repaint;
          Exit;
        end;
      // moving
      if (not Down) and (Mode = mdSelect) and (SelNum >= 1) and (Cursor = crDefault)
        and (MoveObject) then
        begin
          DesignerForm.ChangeObject;
          MoveObject := False;
        end;
      if Down and (Mode = mdSelect) and (SelNum >= 1) and (Cursor = crDefault) then
        begin
          kx := x - LastX;
          ky := y - LastY;
          if ((kx <> 0) or (ky <> 0)) and ((not DesignerForm.GridAlign) or
            ((Abs(kx) >= DesignerForm.GridSize) or (Abs(ky) >= DesignerForm.GridSize))) then
            MoveObject := True;
          if DesignerForm.GridAlign and not GridCheck then Exit;
          if FirstBandMove and (SelNum = 1) and ((kx <> 0) or (ky <> 0)) and
            not (ssAlt in Shift) then
            if TfrView(Objects[frGetTopSelected]).Typ = gtBand then
              begin
                Bnd := Objects[frGetTopSelected];
                for i := 0 to Objects.Count - 1 do
                  begin
                    t := Objects[i];
                    if t.Typ <> gtBand then
                      if (t.Left >= Bnd.Left) and (t.Left + t.Width <= Bnd.Left + Bnd.Width) and
                        (t.Top >= Bnd.Top) and (t.Top + t.Height <= Bnd.Top + Bnd.Height) then
                        begin
                          t.Selected := True;
                          Inc(SelNum);
                        end;
                  end;
                GetMultipleSelected;
              end;
          FirstBandMove := False;
          DrawPage(dmShape);
          for i := 0 to Objects.Count - 1 do
            begin
              t := Objects[i];
              if not t.Selected then continue;
              t.Left := t.Left + kx;
              t.Top := t.Top + ky;
            end;
          DrawPage(dmShape);
          LastX := x - ((x - LastX) - kx);
          LastY := y - ((y - LastY) - ky);
          DesignerForm.StatusBar1.Repaint;
        end;
      // resizing
      if Down and (Mode = mdSelect) and (SelNum = 1) and (Cursor <> crDefault) then
        begin
          kx := x - LastX;
          ky := y - LastY;
          if DesignerForm.GridAlign and not GridCheck then Exit;
          DrawPage(dmShape);
          t := Objects[frGetTopSelected];
          w := 3;
          if Cursor = crSizeNWSE then
            if (CT = ct1) or Cont(t.Left, t.Top, LastX, LastY) then
              begin
                t.Left := t.Left + kx;
                t.Width := t.Width - kx;
                t.Top := t.Top + ky;
                t.Height := t.Height - ky;
                CT := ct1;
              end
            else
              begin
                t.Width := t.Width + kx;
                t.Height := t.Height + ky;
              end;
          if Cursor = crSizeNESW then
            if (CT = ct2) or Cont(t.Left + t.Width, t.Top, LastX, LastY) then
              begin
                t.Top := t.Top + ky;
                t.Width := t.Width + kx;
                t.Height := t.Height - ky;
                CT := ct2;
              end
            else
              begin
                t.Left := t.Left + kx;
                t.Width := t.Width - kx;
                t.Height := t.Height + ky;
              end;
          if Cursor = crSizeWE then
            if (CT = ct3) or Cont(t.Left, t.Top + t.Height div 2, LastX, LastY) then
              begin
                t.Left := t.Left + kx;
                t.Width := t.Width - kx;
                CT := ct3;
              end
            else
              t.Width := t.Width + kx;
          if Cursor = crSizeNS then
            if (CT = ct4) or Cont(t.Left + t.Width div 2, t.Top, LastX, LastY) then
              begin
                t.Top := t.Top + ky;
                t.Height := t.Height - ky;
                CT := ct4;
              end
            else
              t.Height := t.Height + ky;
          DrawPage(dmShape);
          LastX := x - ((x - LastX) - kx);
          LastY := y - ((y - LastY) - ky);
          DesignerForm.StatusBar1.Repaint;
        end;
    end;
end;

procedure TPreview.DClick(Sender: TObject);
begin
  Down := False;
  if SelNum <> 1 then Exit;
  DesignerForm.ShowEditor;
  DFlag := True;
end;

{-----------------------------------------------------------------------------}
procedure BDown(SB: TSpeedButton);
begin
  SB.Down := True;
end;

procedure BUp(SB: TSpeedButton);
begin
  SB.Down := False;
end;

procedure TFRDesignerForm.ActiveForm;
begin
  if ShowInsp then
    SetWindowPos(InspForm.Handle, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  if ShowAlign then
    SetWindowPos(AlignForm.Handle, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure TFRDesignerForm.DeActiveForm;
begin
  if Visible then
    begin
      if InspForm <> nil then
        begin
          ShowInsp := IsWindowVisible(InspForm.Handle);
          SetWindowPos(InspForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0,
            SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
        end;
      if AlignForm <> nil then
        begin
          ShowAlign := IsWindowVisible(AlignForm.Handle);
          SetWindowPos(AlignForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0,
            SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
        end;
    end;
end;

procedure TFRDesignerForm.WMActivate(var Msg: TWMActivate);
begin
  inherited;
  if Msg.Active = WA_INACTIVE then
    DeActiveForm
  else
    ActiveForm;
end;

procedure TFRDesignerForm.GetFontList;
  function EnumFontFamProc(var EnumLogFont: TEnumLogFont; var TextMetric:
    TNewTextMetric; FontType: Integer; Data: Integer): Integer; stdcall;
  begin
    with DesignerForm.C2.Items do
      if IndexOf(StrPas(EnumLogFont.elfLogFont.lfFaceName)) < 0 then
        AddObject(StrPas(EnumLogFont.elfLogFont.lfFaceName), TObject(FontType));
    Result := 1;
  end;

var
  DC: HDC;
begin
  C2.Items.Clear;

  DC := GetDC(0);
  EnumFontFamilies(DC, nil, @EnumFontFamProc, Integer(Self));
  ReleaseDC(0, DC);

  LastFontName := C2.Items[0];
  if C2.Items.IndexOf('Arial') <> -1 then
    LastFontName := 'Arial'
  else
    if C2.Items.IndexOf('Arial Cyr') <> -1 then
      LastFontName := 'Arial Cyr';
  LastFontSize := 10;
end;

procedure TFRDesignerForm.FormCreate(Sender: TObject);
var
  i: Integer;
  Item: TMenuItem;
  procedure AddImage(B: TSpeedButton; M: TMenuItem);
  begin
     M.ImageIndex := Images.AddMasked(B.Glyph, B.Glyph.Canvas.Pixels[0, 15]);
  end;
begin
  NoPreview := True;
  Busy := True;
  // these invisible panels are added to set scroll range to
  // 0..Preview.Width+10 and 0..Preview.Height+10
  BPanel := TPanel.Create(ScrollBox1);
  BPanel.Parent := ScrollBox1;
  BPanel.Height := 1;
  BPanel.Left := 0;
  BPanel.Top := ScrollBox1.Height;
  BPanel.Color := ScrollBox1.Color;

  RPanel := TPanel.Create(ScrollBox1);
  RPanel.Parent := ScrollBox1;
  RPanel.Width := 1;
  RPanel.Left := ScrollBox1.Width;
  RPanel.Top := 0;
  RPanel.Color := ScrollBox1.Color;

  Preview := TPreview.Create(ScrollBox1);
  Preview.PopupMenu := Popup1;
  Preview.ShowHint := True;

  ColorSelector := TColorSelector.Create(Self);
  ColorSelector.OnColorSelected := ColorSelected;

  GridBitmap := TBitmap.Create;
  with GridBitmap do
    begin
      Width := 8;
      Height := 8;
    end;

  for i := 0 to frAddInsCount - 1 do
    with frAddIns[i] do
      RegisterObject(ButtonBmp, ButtonHint, Integer(gtAddIn) + i);

  OIFlag := False;
  InspForm := TInspForm.Create(nil);
  AlignForm := TAlignForm.Create(nil);
  EditorForm := TEditorForm.Create(nil);

  ImgHoriz := TCanvasPanel.Create(Horiz);
  ImgHoriz.Height := Horiz.Height;
  ImgHoriz.Top := 0;
  ImgHoriz.Color := clWhite;

  ImgVert := TCanvasPanel.Create(Vert);
  ImgVert.Width := Vert.Width;
  ImgVert.Left := 0;
  ImgVert.Color := clWhite;
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TSpeedButton then
      TSpeedButton(Components[I]).Flat := True;
  MainMenu1.Images := Images;
  AddImage(SelAllB, N28);
  AddImage(CopyB, N12);
  AddImage(CutB, N11);
  AddImage(ExitB, N10);
  AddImage(FileBtn1, N23);
  AddImage(BtnNext, Restore);
  AddImage(FileBtn2, N19);
  AddImage(PstB, N13);
  AddImage(BtnPrev, Undo);
  AddImage(FileBtn4, N39);
  AddImage(FileBtn3, N20);
  AddImage(ZB2, N33);
  AddImage(ZB1, N32);
  AddImage(PgB3, N25);
  AddImage(PgB1, N29);
  AddImage(PgB2, N30);
  Caption := FRConst_DsgFrm_Caption;
  FileBtn1.Hint := FRConst_DsgFrm_FileBtn1Hint;
  FileBtn2.Hint := FRConst_DsgFrm_FileBtn2Hint;
  FileBtn3.Hint := FRConst_DsgFrm_FileBtn3Hint;
  FileBtn4.Hint := FRConst_DsgFrm_FileBtn4Hint;
  CutB.Hint := FRConst_DsgFrm_CutBHint;
  CopyB.Hint := FRConst_DsgFrm_CopyBHint;
  PstB.Hint := FRConst_DsgFrm_PstBHint;
  BtnPrev.Hint := FRConst_DsgFrm_BtnPrevHint;
  BtnNext.Hint := FRConst_DsgFrm_BtnNextHint;
  ZB1.Hint := FRConst_DsgFrm_ZB1Hint;
  ZB2.Hint := FRConst_DsgFrm_ZB2Hint;
  SelAllB.Hint := FRConst_DsgFrm_SelAllBHint;
  PgB1.Hint := FRConst_DsgFrm_PgB1Hint;
  PgB2.Hint := FRConst_DsgFrm_PgB2Hint;
  PgB3.Hint := FRConst_DsgFrm_PgB3Hint;
  PgB4.Hint := FRConst_DsgFrm_PgB4Hint;
  GB2.Hint := FRConst_DsgFrm_GB2Hint;
  ExitB.Caption := FRConst_DsgFrm_ExitBCaption;
  ExitB.Hint := FRConst_DsgFrm_ExitBHint;
  AlB1.Hint := FRConst_DsgFrm_AlB1Hint;
  AlB2.Hint := FRConst_DsgFrm_AlB2Hint;
  AlB3.Hint := FRConst_DsgFrm_AlB3Hint;
  AlB8.Hint := FRConst_DsgFrm_AlB8Hint;
  AlB5.Hint := FRConst_DsgFrm_AlB5Hint;
  AlB6.Hint := FRConst_DsgFrm_AlB6Hint;
  AlB7.Hint := FRConst_DsgFrm_AlB7Hint;
  AlB4.Hint := FRConst_DsgFrm_AlB4Hint;
  FnB1.Hint := FRConst_DsgFrm_FnB1Hint;
  FnB2.Hint := FRConst_DsgFrm_FnB2Hint;
  FnB3.Hint := FRConst_DsgFrm_FnB3Hint;
  ClB2.Hint := FRConst_DsgFrm_ClB2Hint;
  C3.Hint := FRConst_DsgFrm_C3Hint;
  C2.Hint := FRConst_DsgFrm_C2Hint;
  HlB1.Hint := FRConst_DsgFrm_HlB1Hint;
  FrB1.Hint := FRConst_DsgFrm_FrB1Hint;
  FrB2.Hint := FRConst_DsgFrm_FrB2Hint;
  FrB3.Hint := FRConst_DsgFrm_FrB3Hint;
  FrB4.Hint := FRConst_DsgFrm_FrB4Hint;
  FrB5.Hint := FRConst_DsgFrm_FrB5Hint;
  FrB6.Hint := FRConst_DsgFrm_FrB6Hint;
  ClB1.Hint := FRConst_DsgFrm_ClB1Hint;
  ClB3.Hint := FRConst_DsgFrm_ClB3Hint;
  Edit1.Hint := FRConst_DsgFrm_Edit1Hint;
  UpDown1.Hint := FRConst_DsgFrm_UpDown1Hint;
  OB1.Hint := FRConst_DsgFrm_OB1Hint;
  OB2.Hint := FRConst_DsgFrm_OB2Hint;
  OB3.Hint := FRConst_DsgFrm_OB3Hint;
  OB4.Hint := FRConst_DsgFrm_OB4Hint;
  OB5.Hint := FRConst_DsgFrm_OB5Hint;
  Wiz1.Caption := FRConst_DsgFrm_Wiz1Caption;
  N2.Caption := FRConst_DsgFrm_N2Caption;
  N1.Caption := FRConst_DsgFrm_N1Caption;
  N3.Caption := FRConst_DsgFrm_N3Caption;
  N5.Caption := FRConst_DsgFrm_N5Caption;
  N16.Caption := FRConst_DsgFrm_N16Caption;
  N6.Caption := FRConst_DsgFrm_N6Caption;
  N4.Caption := FRConst_DsgFrm_N4Caption;
  N23.Caption := FRConst_DsgFrm_N23Caption;
  N19.Caption := FRConst_DsgFrm_N19Caption;
  N15.Caption := FRConst_DsgFrm_N15Caption;
  N20.Caption := FRConst_DsgFrm_N20Caption;
  N42.Caption := FRConst_DsgFrm_N42Caption;
  N8.Caption := FRConst_DsgFrm_N8Caption;
  N25.Caption := FRConst_DsgFrm_N25Caption;
  N39.Caption := FRConst_DsgFrm_N39Caption;
  N10.Caption := FRConst_DsgFrm_N10Caption;
  N7.Caption := FRConst_DsgFrm_N7Caption;
  Undo.Caption := FRConst_DsgFrm_UndoCaption;
  Restore.Caption := FRConst_DsgFrm_RestoreCaption;
  N11.Caption := FRConst_DsgFrm_N11Caption;
  N12.Caption := FRConst_DsgFrm_N12Caption;
  N13.Caption := FRConst_DsgFrm_N13Caption;
  N27.Caption := FRConst_DsgFrm_N27Caption;
  N28.Caption := FRConst_DsgFrm_N28Caption;
  N36.Caption := FRConst_DsgFrm_N36Caption;
  N29.Caption := FRConst_DsgFrm_N29Caption;
  N30.Caption := FRConst_DsgFrm_N30Caption;
  N32.Caption := FRConst_DsgFrm_N32Caption;
  N33.Caption := FRConst_DsgFrm_N33Caption;
  N9.Caption := FRConst_DsgFrm_N9Caption;
  N14.Caption := FRConst_DsgFrm_N14Caption;
  Gr2.Caption := FRConst_DsgFrm_Gr2Caption;
  Gr3.Caption := FRConst_DsgFrm_Gr3Caption;
  Gr4.Caption := FRConst_DsgFrm_Gr4Caption;
  Gr5.Caption := FRConst_DsgFrm_Gr5Caption;
  N18.Caption := FRConst_DsgFrm_N18Caption;
  N22.Caption := FRConst_DsgFrm_N22Caption;
  N35.Caption := FRConst_DsgFrm_N35Caption;
  N37.Caption := FRConst_DsgFrm_N37Caption;
  Pan1.Caption := FRConst_DsgFrm_Pan1Caption;
  Pan2.Caption := FRConst_DsgFrm_Pan2Caption;
  Pan3.Caption := FRConst_DsgFrm_Pan3Caption;
  Pan4.Caption := FRConst_DsgFrm_Pan4Caption;
  Pan5.Caption := FRConst_DsgFrm_Pan5Caption;
  Pan6.Caption := FRConst_DsgFrm_Pan6Caption;
  MastMenu.Caption := FRConst_DsgFrm_MastMenuCaption;
  M1.Caption := FRConst_DsgFrm_M1Caption;
  M2.Caption := FRConst_DsgFrm_M2Caption;
  M3.Caption := FRConst_DsgFrm_M3Caption;
  for I := 0 to SaveMenu.Count - 1 do
    begin
      Item := TMenuItem.Create(nil);
      Item.AutoHotkeys := maManual;
      Item.Caption := SaveMenu[I];
      Item.OnClick := ReOpenReport;
      ReopenMenu.Add(Item);
    end;
  ReopenMenu.AutoHotkeys := maManual;
  ReopenMenu.Caption := FRConst_DsgFrm_ReOpMenu;
end;

procedure TFRDesignerForm.FormShow(Sender: TObject);
begin
  Busy := True;
  DocMode := dmDesigning;
  GetFontList;
  C2.Perform(CB_SETDROPPEDWIDTH, 170, 0);
  with InspForm do
    begin
      ClearItems;
      Items.AddObject(FRConst_Name, TProp.Create(@fld[0], csEdit, nil));
      Items.AddObject(FRConst_Left, TProp.Create(@fld[1], csEdit, nil));
      Items.AddObject(FRConst_Top, TProp.Create(@fld[2], csEdit, nil));
      Items.AddObject(FRConst_Width, TProp.Create(@fld[3], csEdit, nil));
      Items.AddObject(FRConst_Height, TProp.Create(@fld[4], csEdit, nil));
      Items.AddObject(FRConst_Visible, TProp.Create(@fld[5], csEdit, nil));
      Items.AddObject(FRConst_Memo, TProp.Create(@fld[6], csDefEditor, EditorForm));
      OnModify := Self.OnModify;
      OnSelect := Self.OnSelect;
    end;
  CurPage := 0; // this cause TPreview sizing
  Unselect;
  Down := False;
  DFlag := False;
  RFlag := False;
  EnableControls;
  Preview.Cursor := crDefault;
  CT := ctNone;
  BDown(OB1);
  frSetGlyph(0, ClB1, 1);
  frSetGlyph(0, ClB2, 0);
  frSetGlyph(0, ClB3, 2);
  ColorSelector.Hide;
  RestoreState;
  FillInspFields;
  InspForm.ItemsChanged;
  OldCaption := FRConst_DsgFrm_Caption;
  if ListAction.Count = 0 then NullList;
  Caption := OldCaption;
  if OnlyName <> '' then Caption := Caption + ' - ' + OnlyName;
  RenumerTabPages;
end;

procedure TFRDesignerForm.FormHide(Sender: TObject);
begin
  SaveState;
end;

procedure TFRDesignerForm.FormDestroy(Sender: TObject);
var
  i: Integer;
  bmp: TBitmap;
begin
  SaveMenu.Clear;
  for I := 0 to ReopenMenu.Count - 1 do
    SaveMenu.Add(ReopenMenu[I].Caption);
  Preview.Free;
  BPanel.Free;
  RPanel.Free;
  GridBitmap.Free;
  ColorSelector.Free;
  InspForm.Free;
  AlignForm.Free;
  EditorForm.Free;
  bmp := nil;
  for i := 0 to Images.Count - 1 do
    begin
      Images.GetBitmap(i, bmp);
      if bmp <> nil then bmp.Free;
    end;
end;

procedure TFRDesignerForm.FormResize(Sender: TObject);
var
  p: TPoint;
begin
  if csDestroying in ComponentState then Exit;
  with ScrollBox1 do
    begin
      HorzScrollBar.Position := 0;
      VertScrollBar.Position := 0;
    end;
  p := ClientToScreen(Point(ClientWidth - 152, 75));
  FillInspFields;
  InspForm.ItemsChanged;
  OIFlag := True;
  Preview.SetPage;
end;

procedure TFRDesignerForm.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  // for best view
  with Msg.MinMaxInfo^ do
    begin
      ptMaxSize.x := Screen.Width;
      ptMaxSize.y := Screen.Height;
      ptMaxPosition.x := 0;
      ptMaxPosition.y := 0;
    end;
end;

procedure TFRDesignerForm.SetCurPage(Value: Integer);
var
  I: Integer;
begin
  // setting curpage and do all manipulation
  FCurPage := Value;
  Page := CurReport.Pages[CurPage];
  ScrollBox1.VertScrollBar.Position := 0;
  ScrollBox1.HorzScrollBar.Position := 0;
  Preview.SetPage;
  ResetSelection;
  SendBandsToDown;
  Preview.Repaint;
  InspForm.ClearObjects;
  for I := 0 to Page.Objects.Count - 1 do
    InspForm.AddObject(String(TfrView(Page.Objects[I]).Name));
  DesignerForm.ImgHoriz.Left := Preview.Left + 2;
  DesignerForm.ImgHoriz.Width := CurReport.Pages.Pages[CurPage].PrnInfo.Pgw;
  DesignerForm.ImgVert.Top := Preview.Top + 2;
  DesignerForm.ImgVert.Height := CurReport.Pages.Pages[CurPage].PrnInfo.Pgh;
  TabPages.TabIndex := CurPage;
  PgB2.Enabled := CurReport.Pages.Count > 1;
end;

procedure TFRDesignerForm.SetGridSize(Value: Integer);
begin
  if FGridSize = Value then Exit;
  FGridSize := Value;
  RedrawPage;
end;

procedure TFRDesignerForm.SetGridAlign(Value: Boolean);
begin
  if FGridAlign = Value then Exit;
  GB2.Down := Value;
  FGridAlign := Value;
end;

procedure TFRDesignerForm.PopupNotify(Sender: TfrView);
begin
  DrawPage(dmSelection);
  Draw(frGetTopSelected, 0);
  ChangeObject;
end;

procedure TFRDesignerForm.RegisterObject(ButtonBmp: TBitmap;
  const ButtonHint: string; ButtonTag: Integer);
var
  b: TSpeedButton;

  function NButtons: Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to Panel4.ControlCount - 1 do
      if Panel4.Controls[I] is TSpeedButton then Inc(Result);
  end;

begin
  b := TSpeedButton.Create(Self);
  //Itta
  b.Height:=b.Height+6;
  b.Width:=b.Width+6;
  //
  b.Parent := Panel4;
  b.Glyph := ButtonBmp;
  b.Hint := ButtonHint;
  b.GroupIndex := 1;
  b.Flat := True;
  b.SetBounds(OB1.Left, OB1.Top + (NButtons - 1) * OB1.Height + 10 + 6 {//Itta}, 
     OB1.Width, OB1.Height);
  b.Tag := ButtonTag;
end;

procedure TFRDesignerForm.RemovePage(n: Integer);
begin
  with CurReport do
    if (n >= 0) and (n < Pages.Count) then
      if Pages.Count = 1 then
        Pages[n].Clear
      else
        CurReport.Pages.Delete(n);
end;

procedure TFRDesignerForm.WorkWithTheClipboard(Del: Boolean);
var
  i, J: Integer;
  t: TfrView;
  d, dd: TfrDataSet;
begin
  ClearClipBoard;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        begin
          ClipBd.Add(frCreateObject(t.Typ, t.ClassName));
          TfrView(ClipBd.Last).Assign(t);
          if T.LinkToDataSet then
            if CurReport.DataSetList.Find(T.FormatStr, J) then
              begin
                dd := TfrDataSet(CurReport.DataSetList.Objects[J]);
                if dd is TfrDBDataSet then
                  d := TfrDBDataSet.Create(nil)
                else
                  d := TfrDataSet.Create(nil);
                d.RangeBegin := dd.RangeBegin;
                d.RangeEnd := dd.RangeEnd;
                d.RangeEndCount := dd.RangeEndCount;
                if d is TfrDBDataSet then
                  begin
                    TfrDBDataSet(d).DataSet := TfrDBDataSet(dd).DataSet;
                    TfrDBDataSet(d).Filter := TfrDBDataSet(dd).Filter;
                    TfrDBDataSet(d).Filtered := TfrDBDataSet(dd).Filtered;
                  end;
                ClipBd.Add(d);
              end
            else
              ClipBd.Add(nil);
        end;
    end;
  if Del then
    begin
      for i := Objects.Count - 1 downto 0 do
        begin
          t := Objects[i];
          if t.Selected then
            begin
              InspForm.DeleteObject(String(T.Name));
              Page.Delete(i);
            end;
        end;
      SelNum := 0;
      ResetSelection;
      FirstSelected := nil;
    end;
end;

procedure TFRDesignerForm.CutToClipboard;
begin
  WorkWithTheClipboard(True);
end;

procedure TFRDesignerForm.CopyToClipboard;
begin
  WorkWithTheClipboard(False);
end;

procedure TFRDesignerForm.SelectAll;
var
  i: Integer;
begin
  SelNum := 0;
  for i := 0 to Objects.Count - 1 do
    begin
      TfrView(Objects[i]).Selected := True;
      Inc(SelNum);
    end;
end;

procedure TFRDesignerForm.Unselect;
var
  i: Integer;
begin
  SelNum := 0;
  for i := 0 to Objects.Count - 1 do
    TfrView(Objects[i]).Selected := False;
end;

procedure TFRDesignerForm.ShowUnit;
begin
  if CurReport = nil then Exit;
  case FUnits of
    0: StatusBar1.Panels[0].Text := M1.Caption;
    1: StatusBar1.Panels[0].Text := M2.Caption;
    2: StatusBar1.Panels[0].Text := M3.Caption;
  end;
end;

procedure TFRDesignerForm.ResetSelection;
begin
  Unselect;
  SelNum := 0;
  EnableControls;
  FillInspFields;
  InspForm.ItemsChanged;
end;

procedure TFRDesignerForm.RedrawPage;
begin
  Draw(10000, 0);
end;

procedure TFRDesignerForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  StepX, StepY: Integer;
  i, tx, ty, tx1, ty1, d, d1: Integer;
  t, t1: TfrView;
begin
  StepX := 0;
  StepY := 0;
  if (Key = vk_Return) and (ActiveControl = C3) then
    begin
      Key := 0;
      DoClick(C3);
    end;
  if (Key = vk_Return) and (ActiveControl = Edit1) then
    begin
      Key := 0;
      DoClick(UpDown1);
    end;
  if (Key = vk_Delete) and DelEnabled then
    begin
      DeleteObjects;
      Key := 0;
    end;
  if (Key = vk_Return) and EditEnabled then
    begin
      if ssCtrl in Shift then
        ShowMemoEditor
      else
        ShowEditor;
    end;
  if CutEnabled then
    if (Key = vk_Delete) and (ssShift in Shift) then CutBClick(Self);
  if CopyEnabled then
    if (Key = vk_Insert) and (ssCtrl in Shift) then CopyBClick(Self);
  if PasteEnabled then
    if (Key = vk_Insert) and (ssShift in Shift) then PastBClick(Self);
  if Key = vk_Prior then
    with ScrollBox1.VertScrollBar do
      begin
        Position := Position - 200;
        Key := 0;
      end;
  if Key = vk_Next then
    with ScrollBox1.VertScrollBar do
      begin
        Position := Position + 200;
        Key := 0;
      end;
  if ActiveControl = nil then
    if SelNum > 0 then
      begin
        if Key = vk_Up then
          StepY := -1
        else
          if Key = vk_Down then
            StepY := 1
          else
            if Key = vk_Left then
              StepX := -1
            else
              if Key = vk_Right then StepX := 1;
        if (StepX <> 0) or (StepY <> 0) then
          begin
            if ssCtrl in Shift then
              MoveObjects(StepX, StepY, False)
            else
              if ssShift in Shift then
                MoveObjects(StepX, StepY, True)
              else
                if SelNum = 1 then
                  begin
                    t := Objects[frGetTopSelected];
                    tx := t.Left;
                    ty := t.Top;
                    tx1 := t.Left + t.Width;
                    ty1 := t.Top + t.Height;
                    d := 10000;
                    t1 := nil;
                    for i := 0 to Objects.Count - 1 do
                      begin
                        t := Objects[i];
                        if not t.Selected and (t.Typ <> gtBand) then
                          begin
                            d1 := 10000;
                            if StepX <> 0 then
                              begin
                                if t.Top + t.Height < ty then
                                  d1 := ty - (t.Top + t.Height)
                                else
                                  if t.Top > ty1 then
                                    d1 := t.Top - ty1
                                  else
                                    if (t.Top <= ty) and (t.Top + t.Height >= ty1) then
                                      d1 := 0
                                    else
                                      d1 := t.Top - ty;
                                if ((t.Left <= tx) and (StepX = 1)) or
                                  ((t.Left + t.Width >= tx1) and (StepX = -1)) then
                                  d1 := 10000;
                                if StepX = 1 then
                                  begin
                                    if t.Left > tx1 then
                                      d1 := d1 + t.Left - tx1
                                    else
                                      d1 := d1 + t.Left - tx;
                                  end
                                else
                                  begin
                                    if t.Left + t.Width < tx then
                                      d1 := d1 + tx - (t.Left + t.Width)
                                    else
                                      d1 := d1 + tx1 - (t.Left + t.Width);
                                  end;
                              end
                            else
                              if StepY <> 0 then
                                begin
                                  if t.Left + t.Width < tx then
                                    d1 := tx - (t.Left + t.Width)
                                  else
                                    if t.LEft > tx1 then
                                      d1 := t.Left - tx1
                                    else
                                      if (t.Left <= tx) and (t.Left + t.Width >= tx1) then
                                        d1 := 0
                                      else
                                        d1 := t.LEft - tx;
                                  if ((t.Top <= ty) and (StepY = 1)) or
                                    ((t.Top + t.Height >= ty1) and (StepY = -1)) then
                                    d1 := 10000;
                                  if StepY = 1 then
                                    begin
                                      if t.Top > ty1 then
                                        d1 := d1 + t.Top - ty1
                                      else
                                        d1 := d1 + t.Top - ty;
                                    end
                                  else
                                    begin
                                      if t.Top + t.Height < ty then
                                        d1 := d1 + ty - (t.Top + t.Height)
                                      else
                                        d1 := d1 + ty1 - (t.Top + t.Height);
                                    end;
                                end;
                            if d1 < d then
                              begin
                                d := d1;
                                t1 := t;
                              end;
                          end;
                      end;
                    if t1 <> nil then
                      begin
                        DrawPage(dmSelection);
                        Unselect;
                        SelNum := 1;
                        t1.Selected := True;
                        DrawPage(dmSelection);
                        SelectionChanged;
                      end;
                  end;
          end
      end
    else
      begin
        if Key = vk_Up then
          with ScrollBox1.VertScrollBar do
            begin
              Position := Position - 10;
              Key := 0;
            end
        else
          if Key = vk_Down then
            with ScrollBox1.VertScrollBar do
              begin
                Position := Position + 10;
                Key := 0;
              end
          else
            if Key = vk_Left then
              with ScrollBox1.HorzScrollBar do
                begin
                  Position := Position - 10;
                  Key := 0;
                end;
        if Key = vk_Right then
          with ScrollBox1.HorzScrollBar do
            begin
              Position := Position + 10;
              Key := 0;
            end;
      end;
end;

procedure TFRDesignerForm.MoveObjects(dx, dy: Integer; Resize: Boolean);
var
  i: Integer;
  t: TfrView;
begin
  GetRegion;
  DrawPage(dmSelection);
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        if Resize then
          begin
            Inc(t.Width, dx);
            Inc(t.Height, dy);
          end
        else
          begin
            Inc(t.Left, dx);
            Inc(t.Top, dy);
          end;
    end;
  FillInspFields;
  InspForm.ItemsChanged;
  StatusBar1.Repaint;
  Preview.GetMultipleSelected;
  Draw(frGetTopSelected, ClipRgn);
  ChangeObject;
end;

procedure TFRDesignerForm.DeleteObjects;
var
  i: Integer;
  t: TfrView;
begin
  GetRegion;
  DrawPage(dmSelection);
  for i := Objects.Count - 1 downto 0 do
    begin
      t := Objects[i];
      if t.Selected then
        begin
          InspForm.DeleteObject(String(T.Name));
          Page.Delete(i);
        end;
    end;
  ResetSelection;
  FirstSelected := nil;
  Draw(10000, ClipRgn);
  ChangeObject;
end;

function TFRDesignerForm.GetSelectionStatus: TSelectionStatus;
var
  t: TfrView;
begin
  Result := [];
  if SelNum = 1 then
    begin
      t := Objects[frGetTopSelected];
      if t.Typ = gtBand then
        Result := [ssBand]
      else
        if t is TfrMemoView then
          Result := [ssMemo]
        else
          Result := [ssOther];
    end
  else
    if SelNum > 1 then
      Result := [ssMultiple];
  if ClipBd.Count > 0 then
    Result := Result + [ssClipboardFull];
end;

function TFRDesignerForm.RectTypEnabled: Boolean;
begin
  Result := [ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TFRDesignerForm.FontTypEnabled: Boolean;
begin
  Result := [ssMemo, ssMultiple] * SelStatus <> [];
end;

function TFRDesignerForm.ZEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TFRDesignerForm.CutEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TFRDesignerForm.CopyEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TFRDesignerForm.PasteEnabled: Boolean;
begin
  Result := ssClipboardFull in SelStatus;
end;

function TFRDesignerForm.DelEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TFRDesignerForm.EditEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther] * SelStatus <> [];
end;

procedure TFRDesignerForm.EnableControls;
  procedure SetEnabled(const Ar: array of TObject; en: Boolean);
  var
    i: Integer;
  begin
    for i := Low(Ar) to High(Ar) do
      if Ar[i] is TControl then
        (Ar[i] as TControl).Enabled := en
      else
        if Ar[i] is TMenuItem then
          (Ar[i] as TMenuItem).Enabled := en;
  end;
begin
  SetEnabled([FrB1, FrB2, FrB3, FrB4, FrB5, FrB6, ClB1, ClB3, UpDown1, Edit1],
    RectTypEnabled);
  SetEnabled([ClB2, C2, C3, FnB1, FnB2, FnB3, AlB1, AlB2, AlB3, AlB4, AlB5, AlB6, AlB7, AlB8, HlB1],
    FontTypEnabled);
  SetEnabled([ZB1, ZB2, N32, N33], ZEnabled);
  SetEnabled([CutB, N11, N2], CutEnabled);
  SetEnabled([CopyB, N12, N1], CopyEnabled);
  SetEnabled([PstB, N13, N3], PasteEnabled);
  SetEnabled([N27, N5], DelEnabled);
  SetEnabled([N36, N6], EditEnabled);
  InspForm.EnableItem(6, EditEnabled);
  StatusBar1.Repaint;
end;

procedure TFRDesignerForm.SelectionChanged;
var
  t: TfrView;
  n: Integer;
begin
  Busy := True;
  ColorSelector.Hide;
  EnableControls;
  if SelNum = 1 then
    begin
      t := Objects[frGetTopSelected];
      InspForm.SelectObject(String(T.Name));
      if t.Typ <> gtBand then
        with t do
          begin
            FrB1.Down := DrawFrameTop;
            FrB2.Down := DrawFrameLeft;
            FrB3.Down := DrawFrameBottom;
            FrB4.Down := DrawFrameRight;
            UpDown1.Position := FrameWidth;
            frSetGlyph(Color, ClB1, 1);
            frSetGlyph(FrameColor, ClB3, 2);
            if t is TfrMemoView then
              with t as TfrMemoView do
                begin
                  frSetGlyph(Font.Color, ClB2, 0);
                  C2.ItemIndex := C2.Items.IndexOf(Font.Name);
                  n := C3.Items.IndexOf(IntToStr(Font.Size));
                  if n <> -1 then
                    C3.ItemIndex := n
                  else
                    C3.Text := IntToStr(Font.Size);
                  FnB1.Down := (fsBold in Font.Style);
                  FnB2.Down := (fsItalic in Font.Style);
                  FnB3.Down := (fsUnderline in Font.Style);
                  AlB4.Down := Rotate90;
                  AlB5.Down := (VerticalAlignment in [tvaCenter]);
                  AlB6.Down := (VerticalAlignment in [tvaUp]);
                  ;
                  AlB7.Down := (VerticalAlignment in [tvaDown]);
                  case Alignment of
                    frLeftJustify: BDown(AlB1);
                    frRightJustify: BDown(AlB2);
                    frCenter: BDown(AlB3);
                    frWidthJustify: BDown(AlB8);
                  end;
                end;
          end;
    end
  else
    if SelNum > 1 then
      begin
        BUp(FrB1);
        BUp(FrB2);
        BUp(FrB3);
        BUp(FrB4);
        frSetGlyph(0, ClB1, 1);
        UpDown1.Position := 1;
        C2.ItemIndex := 0;
        C3.ItemIndex := 5;
        BUp(FnB1);
        BUp(FnB2);
        BUp(FnB3);
        BDown(AlB1);
        BUp(AlB4);
        BUp(AlB5);
      end;
  if SelNum <> 1 then InspForm.SelectObject('');
  Busy := False;
  FillInspFields;
  InspForm.ItemsChanged;
  ActiveControl := nil;
end;

procedure TFRDesignerForm.DoClick(Sender: TObject);
var
  i, b: Integer;
  DRect: TRect;
  t: TfrView;
begin
  if Busy then Exit;
  DrawPage(dmSelection);
  GetRegion;
  b := (Sender as TControl).Tag;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected and ((t.Typ <> gtBand) or (b = 16)) then
        with t do
          begin
            if t is TfrMemoView then
              with t as TfrMemoView do
                case b of
                  7:
                    if C2.ItemIndex <> 0 then
                      begin
                        Font.Name := C2.Text;
                        LastFontName := Font.Name;
                      end;
                  8:
                    begin
                      Font.Size := StrToInt(C3.Text);
                      LastFontSize := Font.Size;
                    end;
                  9:
                    if FnB1.Down then
                      Font.Style := Font.Style + [fsBold]
                    else
                      Font.Style := Font.Style - [fsBold];
                  10:
                    if FnB2.Down then
                      Font.Style := Font.Style + [fsItalic]
                    else
                      Font.Style := Font.Style - [fsItalic];
                  11: Alignment := frLeftJustify;
                  12: Alignment := frRightJustify;
                  13: Alignment := frCenter;
                  14: Rotate90 := AlB4.Down;
                  15:
                    if AlB5.Down then
                      VerticalAlignment := tvaCenter
                    else
                      if AlB6.Down then
                        VerticalAlignment := tvaUp
                      else
                        VerticalAlignment := tvaDown;
                  17: Font.Color := ColorSelector.Color;
                  18:
                    if FnB3.Down then
                      Font.Style := Font.Style + [fsUnderline]
                    else
                      Font.Style := Font.Style - [fsUnderline];
                  22: Alignment := frWidthJustify;
                end;
            case b of
              1:
                begin
                  DrawFrameTop := FrB1.Down;
                  DRect := Rect(t.Left - 10, t.Top - 10, t.Left + t.Width + 10, t.Top + 10)
                end;
              2:
                begin
                  DrawFrameLeft := FrB2.Down;
                  DRect := Rect(t.Left - 10, t.Top - 10, t.Left + 10, t.Top + t.Height + 10)
                end;
              3:
                begin
                  DrawFrameBottom := FrB3.Down;
                  DRect := Rect(t.Left - 10, t.Top + t.Height - 10, t.Left + t.Width + 10, t.Top + t.Height + 10)
                end;
              4:
                begin
                  DrawFrameRight := FrB4.Down;
                  DRect := Rect(t.Left + t.Width - 10, t.Top - 10, t.Left + t.Width + 10, t.Top + t.Height + 10)
                end;
              20: SetAllFrames;
              21: ResetAllFrames;
              5: Color := ColorSelector.Color;
              6: FrameWidth := UpDown1.Position;
              19: FrameColor := ColorSelector.Color;
            end;
          end;
    end;
  Draw(frGetTopSelected, ClipRgn);
  ActiveControl := nil;
  if b in [20, 21] then SelectionChanged;
  ChangeObject;
end;

procedure TFRDesignerForm.HlB1Click(Sender: TObject);
var
  t: TfrMemoView;
  i: Integer;
begin
  t := Objects[frGetTopSelected];
  HilightForm := THilightForm.Create(nil);
  with HilightForm do
    begin
      FontColor := t.Highlight.FontColor;
      FillColor := t.Highlight.FillColor;
      CBX1.Checked := t.UseHighlight;
      Edit2.Text := t.HighlightStr;
      CB1.Checked := (fsBold in t.Highlight.FontStyle);
      CB2.Checked := (fsItalic in t.Highlight.FontStyle);
      CB3.Checked := (fsUnderline in t.Highlight.FontStyle);
      if ShowModal = mrOk then
        begin
          for i := 0 to frDesigner.Page.Objects.Count - 1 do
            begin
              t := frDesigner.Page.Objects[i];
              if t.Selected then
                begin
                  t.UseHighlight := CBX1.Checked;
                  t.HighlightStr := Edit2.Text;
                  t.Highlight.FontColor := FontColor;
                  t.Highlight.FillColor := FillColor;
                  t.Highlight.FontStyle := [];
                  if CB1.Checked then t.Highlight.FontStyle := t.Highlight.FontStyle + [fsBold];
                  if CB2.Checked then t.Highlight.FontStyle := t.Highlight.FontStyle + [fsItalic];
                  if CB3.Checked then t.Highlight.FontStyle := t.Highlight.FontStyle + [fsUnderline];
                end;
            end;
          ChangeObject;
        end;
    end;
  HilightForm.Free;
end;

procedure TFRDesignerForm.FillInspFields;
var
  t: TfrView;
begin
  fld[0] := '';
  fld[1] := '';
  fld[2] := '';
  fld[3] := '';
  fld[4] := '';
  fld[5] := '';
  fld[6] := '';
  InspForm.V := nil;
  if SelNum = 1 then
    begin
      t := Objects[frGetTopSelected];
      InspForm.V := t;
      fld[0] := T.Name;
      fld[1] := UTF8EncodeToShortString(FloatToStr(Round(t.Left * FConverter * 100) / 100));
      fld[2] := UTF8EncodeToShortString(FloatToStr(Round(t.Top * FConverter * 100) / 100));
      fld[3] := UTF8EncodeToShortString(FloatToStr(Round(t.Width * FConverter * 100) / 100));
      fld[4] := UTF8EncodeToShortString(FloatToStr(Round(t.Height * FConverter * 100) / 100));
      if T.Visible then
        fld[5] := FRConst_True
      else
        fld[5] := FRConst_False
    end;
  InspForm.HideProperties := SelNum = 0;
end;

procedure TFRDesignerForm.OnModify(Item: Integer; var EditText: ShortString);
var
  t: TfrView;
  i, C: Integer;
  K: Double;
  S: string;
begin
  k := 0;
  C := 0;
  if (Item < 5) and (Item > 0) then
    begin
      S := String(fld[Item]);
      if Pos(FormatSettings.DecimalSeparator, S) > 0 then S[Pos(FormatSettings.DecimalSeparator, S)] := '.';
      Val(S, k, C);
    end;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        if C = 0 then
          with t do
            case Item of
              0:
                begin
                  InspForm.DeleteObject(String(Name));
                  Name := RawByteString(fld[Item]);
                  EditText := Name;
                  InspForm.AddObject(String(Name));
                  InspForm.SelectObject(String(Name));
                  ChangeObject;
                end;
              1:
                begin
                  Left := Round(k / FConverter);
                  EditText := ShortString(FormatFloat('0.##', Round(k / FConverter) * FConverter));
                  ChangeObject;
                end;
              2:
                begin
                  Top := Round(k / FConverter);
                  EditText := ShortString(FormatFloat('0.##', Round(k / FConverter) * FConverter));
                  ChangeObject;
                end;
              3:
                begin
                  Width := Round(k / FConverter);
                  EditText := ShortString(FormatFloat('0.##', Round(k / FConverter) * FConverter));
                  ChangeObject;
                end;
              4:
                begin
                  Height := Round(k / FConverter);
                  EditText := ShortString(FormatFloat('0.##', Round(k / FConverter) * FConverter));
                  ChangeObject;
                end;
              5:
                begin
                  if UpperCase(String(fld[Item])) = UpperCase(FRConst_True) then
                    begin
                      Visible := True;
                      EditText := FRConst_True;
                      ChangeObject;
                    end
                  else
                    if UpperCase(String(fld[Item])) = UpperCase(FRConst_False) then
                      begin
                        Visible := False;
                        EditText := FRConst_False;
                        ChangeObject;
                      end
                    else
                      begin
                        if Visible then
                          EditText := FRConst_True
                        else
                          EditText := FRConst_False;
                        fld[Item] := UTF8EncodeToShortString(EditText);
                        Application.MessageBox(FRConst_PropertyError,
                          FRConst_Error, MB_OK + mb_IconError)
                      end
                end;
            end
        else
          begin
            case Item of
              1: EditText := ShortString(IntToStr(T.Left));
              2: EditText := ShortString(IntToStr(T.Top));
              3: EditText := ShortString(IntToStr(T.Width));
              4: EditText := ShortString(IntToStr(T.Height));
            end;
            fld[Item] := UTF8EncodeToShortString(EditText);
            Application.MessageBox(FRConst_PropertyError,
              FRConst_Error, MB_OK + mb_IconError);
            Break
          end;
    end;
  RedrawPage;
end;

procedure TFRDesignerForm.OnSelect(N: ShortString);
var
  I: Integer;
begin
  SelNum := 1;
  for I := 0 to Page.Objects.Count - 1 do
    begin
      if TfrView(Page.Objects[I]).Name = N then
        TfrView(Page.Objects[I]).Selected := True
      else
        TfrView(Page.Objects[I]).Selected := False;
    end;
  RedrawPage;
  SelectionChanged;
end;

procedure TFRDesignerForm.ClB1Click(Sender: TObject);
var
  p: TPoint;
begin
  with (Sender as TControl) do
    p := Self.ScreenToClient(Parent.ClientToScreen(Point(Left, Top)));
  if ColorSelector.Left = p.X then
    ColorSelector.Visible := not ColorSelector.Visible
  else
    begin
      ColorSelector.Left := p.X;
      ColorSelector.Top := p.Y + 26;
      ColorSelector.Visible := True;
    end;
  ClrButton := Sender as TSpeedButton;
  case ClrButton.Tag of
    5: ColorSelector.Color := CurFillColor;
    19: ColorSelector.Color := CurFrameColor;
    17: ColorSelector.Color := CurFontColor;
  end;
end;

procedure TFRDesignerForm.ColorSelected(Sender: TObject);
var
  n: Integer;
begin
  n := 0;
  if ClrButton = ClB1 then
    n := 1
  else
    if ClrButton = ClB3 then
      n := 2;
  frSetGlyph(ColorSelector.Color, ClrButton, n);
  DoClick(ClrButton);
end;

procedure TFRDesignerForm.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  t: TfrView;
  s: string;
  nx, ny: Double;
begin
  with StatusBar.Canvas do
    begin
      FillRect(Rect);
      ImageList1.Draw(StatusBar.Canvas, Rect.Left + 2, Rect.Top, 0);
      ImageList1.Draw(StatusBar.Canvas, Rect.Left + 92, Rect.Top, 1);
      if SelNum = 1 then
        begin
          t := Objects[frGetTopSelected];
          TextOut(Rect.Left + 20, Rect.Top + 1, FloatToStr(Round(t.Left * FConverter * 100) / 100) +
            ' / ' + FloatToStr(Round(t.Top * FConverter * 100) / 100));
          TextOut(Rect.Left + 110, Rect.Top + 1, FloatToStr(Abs(Round(t.Width * FConverter * 100) / 100)) +
            ' / ' + FloatToStr(Abs(Round(t.Height * FConverter * 100) / 100)));
          if (t.Typ = gtPicture) then
            with t as TfrPictureView do
              if (Picture.Graphic <> nil) and not Picture.Graphic.Empty then
                begin
                  s := IntToStr(Width * 100 div Picture.Width) + ',' +
                    IntToStr(Height * 100 div Picture.Height);
                  TextOut(Rect.Left + 150, Rect.Top + 1, '% ' + s);
                end;
        end
      else
        if (SelNum > 0) and MRFlag then
        begin
            Try
               nx := (OldRect.Right - OldRect.Left) / (OldRect1.Right - OldRect1.Left);
               ny := (OldRect.Bottom - OldRect.Top) / (OldRect1.Bottom - OldRect1.Top);
               s := IntToStr(Round(nx * 100)) + ',' + IntToStr(Round(ny * 100));
               TextOut(Rect.Left + 150, Rect.Top + 1, '% ' + s);
            Except
            End;
        end;
    end;
end;

procedure TFRDesignerForm.C2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with C2.Canvas do
    begin
      FillRect(Rect);
      if (Integer(C2.Items.Objects[Index]) and TRUETYPE_FONTTYPE) <> 0 then
        ImageList2.Draw(C2.Canvas, Rect.Left, Rect.Top + 1, 0);
      TextOut(Rect.Left + 20, Rect.Top + 1, C2.Items[Index]);
    end;
end;

procedure TFRDesignerForm.ShowMemoEditor;
begin
  with EditorForm do
    begin
      View := Objects[frGetTopSelected];
      if ShowEditor = mrOk then
        begin
          DrawPage(dmSelection);
          Draw(frGetTopSelected, View.GetClipRgn(rtExtended));
          ChangeObject;
        end;
    end;
  ActiveControl := nil;
end;

procedure TFRDesignerForm.ShowEditor;
var
  t: TfrView;
  i: Integer;
  bt: TfrBandType;
  MDResult: Integer;
  EditorForm: TfrObjEditorForm;
begin
  MDResult := mrCancel;
  t := Objects[frGetTopSelected];
  if t.Typ = gtMemo then
    ShowMemoEditor
  else
    if t.Typ = gtPicture then
      begin
        GEditorForm := TGEditorForm.Create(nil);
        with GEditorForm do
          begin
            Image1.Picture.Assign((t as TfrPictureView).Picture);
            if ShowModal = mrOk then
              begin
                MDResult := mrOK;
                DrawPage(dmSelection);
                (t as TfrPictureView).Picture.Assign(Image1.Picture);
                Draw(frGetTopSelected, t.GetClipRgn(rtExtended));
              end;
          end;
        GEditorForm.Free;
        StatusBar1.Repaint;
      end
    else
      if t.Typ = gtBand then
        begin
          DrawPage(dmSelection);
          bt := TfrBandView(T).BandType;
          if bt in [btMasterData, btDetailData, btSubDetailData, btColumnData] then
            begin
              BandEditorForm := TBandEditorForm.Create(nil);
              BandEditorForm.ShowEditor(t);
              MDResult := BandEditorForm.ModalResult;
              BandEditorForm.Free;
              Draw(frGetTopSelected, t.GetClipRgn(rtExtended));
            end
          else
            if bt = btGroupHeader then
              begin
                GroupEditorForm := TGroupEditorForm.Create(nil);
                GroupEditorForm.ShowEditor(t);
                MDResult := GroupEditorForm.ModalResult;
                GroupEditorForm.Free;
                Draw(frGetTopSelected, t.GetClipRgn(rtExtended));
              end;
        end
      else
        if t.Typ = gtSubReport then
          begin
            CurPage := (t as TfrSubReportView).SubPage;
          end
        else
          if t.Typ = gtAddIn then
            begin
              for i := 0 to frAddInsCount - 1 do
                if frAddIns[i].ClassRef.ClassName = t.ClassName then
                  begin
                    if frAddIns[i].EditorClass <> nil then
                      begin
                        DrawPage(dmSelection);
                        EditorForm := TfrObjEditorForm(frAddIns[i].EditorClass.NewInstance).Create(nil);
                        EditorForm.ShowEditor(t);
                        MDResult := EditorForm.ModalResult;
                        Draw(frGetTopSelected, t.GetClipRgn(rtExtended));
                      end
                    else
                      ShowMemoEditor;
                    break;
                  end;
            end;
  ActiveControl := nil;
  if MDResult = mrOK then ChangeObject;
end;

procedure TFRDesignerForm.ZB1Click(Sender: TObject); // go up
var
  i, j, n: Integer;
  t: TfrView;
begin
  n := Objects.Count;
  i := 0;
  j := 0;
  while j < n do
    begin
      t := Objects[i];
      if t.Selected then
        begin
          Objects.Delete(i);
          Objects.Add(t);
        end
      else
        Inc(i);
      Inc(j);
    end;
  SendBandsToDown;
  RedrawPage;
  ChangeObject;
end;

procedure TFRDesignerForm.ZB2Click(Sender: TObject); // go down
var
  t: TfrView;
  i, j, n: Integer;
begin
  n := Objects.Count;
  j := 0;
  i := n - 1;
  while j < n do
    begin
      t := Objects[i];
      if t.Selected then
        begin
          Objects.Delete(i);
          Objects.Insert(0, t);
        end
      else
        Dec(i);
      Inc(j);
    end;
  SendBandsToDown;
  RedrawPage;
  ChangeObject;
end;

procedure TFRDesignerForm.PgB1Click(Sender: TObject);
begin
  // add page
  ResetSelection;
  CurReport.Pages.Add;
  TabPages.Tabs.Add(FRConst_Pg + ' ' + IntToStr(CurReport.Pages.Count));
  CurPage := CurReport.Pages.Count - 1;
  ChangeObject;
end;

procedure TFRDesignerForm.RenumerTabPages;
var
  I: Integer;
begin
  TabPages.Tabs.Clear;
  for I := 0 to CurReport.Pages.Count - 1 do
    TabPages.Tabs.Add(FRConst_Pg + ' ' + IntToStr(I + 1));
end;

procedure TFRDesignerForm.PgB2Click(Sender: TObject);
begin
  // remove page
  if Application.MessageBox(FRConst_RemovePg, FRConst_Confirm,
    mb_IconQuestion + mb_YesNo) = mrYes then
    begin
      RemovePage(CurPage);
      TabPages.Tabs.Delete(CurPage);
      if CurPage > 0 then
        CurPage := CurPage - 1
      else
        CurPage := 0;
      RenumerTabPages;
      ChangeObject;
    end;
end;

procedure TFRDesignerForm.OB1Click(Sender: TObject);
begin
  ObjRepeat := False;
end;

procedure TFRDesignerForm.OB2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ObjRepeat := ssShift in Shift;
end;

procedure TFRDesignerForm.CutBClick(Sender: TObject); //cut
begin
  CutToClipboard;
  FirstSelected := nil;
  EnableControls;
  RedrawPage;
  ChangeObject;
end;

procedure TFRDesignerForm.CopyBClick(Sender: TObject); //copy
begin
  CopyToClipboard;
  EnableControls;
end;

procedure TFRDesignerForm.PastBClick(Sender: TObject); //paste
var
  i, minx, miny: Integer;
  t, t1: TfrView;
  d, dd: TfrDataSet;
begin
  Unselect;
  SelNum := 0;
  minx := 32767;
  miny := 32767;
  with ClipBd do
    begin
      I := 0;
      while I <= Count - 1 do
        begin
          t := Items[i];
          if t.Left < minx then minx := t.Left;
          if t.Top < miny then miny := t.Top;
          Inc(I);
          if T.LinkToDataSet then Inc(I);
        end;
    end;
  I := 0;
  while I <= ClipBd.Count - 1 do
    begin
      T := ClipBd.Items[I];
      if (T.Typ = gtBand) and (frCheckBand(TfrBandView(T).BandType)) and
        not (TfrBandView(T).BandType in [btMasterHeader, btMasterData, btMasterFooter,
        btDetailHeader, btDetailData, btDetailFooter,
          btSubDetailHeader, btSubDetailData, btSubDetailFooter,
          btGroupHeader, btGroupFooter]) then
        begin
          Inc(I);
          if (TfrBandView(T).BandType in
            [btMasterData, btDetailData, btSubDetailData, btColumnData]) then Inc(I);
          continue;
        end;
      T.Left := T.Left - minx;
      if Preview.Top < 0 then
        T.Top := T.Top - miny + ((-Preview.Top) - (-Preview.Top) mod 4)
      else
        t.Top := t.Top - miny;
      Inc(SelNum);
      Objects.Add(frCreateObject(t.Typ, t.ClassName));
      t1 := Objects.Last;
      InspForm.AddObject(String(t1.Name));
      t1.Assign(t);
      if T1.LinkToDataSet then
        begin
          Inc(I);
          d := ClipBd.Items[i];
          if d <> nil then
            begin
              if d is TfrDBDataSet then
                dd := TfrDBDataSet.Create(nil)
              else
                dd := TfrDataSet.Create(nil);
              dd.Name := CurReport.Name + '_' + String(T1.Name) + '_DataSet';
              dd.RangeBegin := d.RangeBegin;
              dd.RangeEnd := d.RangeEnd;
              dd.RangeEndCount := d.RangeEndCount;
              if d is TfrDBDataSet then
                begin
                  TfrDBDataSet(dd).DataSet := TfrDBDataSet(d).DataSet;
                  TfrDBDataSet(dd).Filter := TfrDBDataSet(d).Filter;
                  TfrDBDataSet(dd).Filtered := TfrDBDataSet(d).Filtered;
                end;
              CurReport.DataSetList.AddObject(dd.Name, dd);
              t1.FormatStr := dd.Name;
            end;
        end;
      Inc(I);
    end;
  SelectionChanged;
  SendBandsToDown;
  Preview.GetMultipleSelected;
  RedrawPage;
  ChangeObject;
end;

procedure TFRDesignerForm.SelAllBClick(Sender: TObject); // select all
begin
  DrawPage(dmSelection);
  SelectAll;
  Preview.GetMultipleSelected;
  DrawPage(dmSelection);
  SelectionChanged;
end;

procedure TFRDesignerForm.ExitBClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFRDesignerForm.N5Click(Sender: TObject);
begin
  // popup delete command
  DeleteObjects;
end;

procedure TFRDesignerForm.N6Click(Sender: TObject);
begin
  // popup edit command
  ShowEditor;
end;

procedure TFRDesignerForm.FileBtn1Click(Sender: TObject);
begin
  // create new
  if OKNew then
  begin
      CurReport.NewReport;
      CurPage := 0;
      Caption := OldCaption;
      NullList;
      ImgHoriz.Paint;
      ImgVert.Paint;
      ShowUnit;
      LastDB := '';
   end;
end;

procedure TFRDesignerForm.N23Click(Sender: TObject);
begin
  // create new from template
  TemplForm := TTemplForm.Create(nil);
  with TemplForm do
    if ShowModal = mrOk then
      begin
        CurReport.LoadTemplate(TemplName, nil, nil, True);
        CurPage := 0; // do all
        CurReport.FileName := '';
        Caption := OldCaption;
        NullList;
        LastDB := '';
      end;
  TemplForm.Free;
end;

procedure TFRDesignerForm.FileBtn2Click(Sender: TObject);
var
  CurDir: string;
begin
  // open
  if OKNew then
  begin
      if CurReport.ReportDir = '' then
        begin
          OpenDialog1.Filter := FRConst_FormFile + ' (*.frf)|*.frf';
          if OpenDialog1.Execute then Load(OpenDialog1.FileName);
        end
      else
        begin
          CurDir := GetCurrentDir;
          SetCurrentDir(CurReport.ReportDir);
          LoadForm := TLoadForm.Create(nil);
          if LoadForm.Execute then Load(LoadForm.FileName);
          LoadForm.Free;
          SetCurrentDir(CurDir);
        end;
  end;
end;

procedure TFRDesignerForm.FileBtn3Click(Sender: TObject);
begin
  SaveAsOK;
end;

procedure TFRDesignerForm.FileBtn4Click(Sender: TObject);
var
  v1, v2: Boolean;
  S: TMemoryStream;
begin
  NoPreview := False;
  S := TMemoryStream.Create;
  CurReport.SaveToStream(S);
  S.Position := 0;
  CurReport.Pages.Clear;
  CurReport.Pages.Add;
  CurPage := 0;
  Application.ProcessMessages;
  CurReport.LoadFromStream(S);
  S.Free;
  DocMode := dmPrinting;
  v1 := InspForm.Visible;
  v2 := AlignForm.Visible;
  InspForm.Hide;
  AlignForm.Hide;
  Application.ProcessMessages;
  CurReport.ShowReport;
  NoPreview := True;
  InspForm.Visible := v1;
  AlignForm.Visible := v2;
  SetFocus;
  DocMode := dmDesigning;
  CurPage := 0;
end;

procedure TFRDesignerForm.N42Click(Sender: TObject);
begin
  // var editor
  if ShowEvEditor(CurReport) then ChangeObject;
end;

procedure TFRDesignerForm.PgB3Click(Sender: TObject);
var
  w, h, p: Integer;
begin
  // page setup
  PgoptForm := TPgoptForm.Create(nil);
  with PgoptForm, Page do
    begin
      CB1.Checked := PrintToPrevPage;
      CB2.Checked := PHonFirst;
      CB3.Checked := PFonLast;
      CB4.Checked := CHCopy;
      Up1.Position := Page.ZoomX;
      Up2.Position := Page.ZoomY;
      if pgOr = poPortrait then
        RB1.Checked := True
      else
        RB2.Checked := True;
      ComB1.Items := PrinterSettings.PaperNames;
      ComB1.ItemIndex := PrinterSettings.GetArrayPos(pgSize);
      E1.Text := '';
      E2.Text := '';
      if pgSize = pgCustomSize then
        begin
          E1.Text := IntToStr(pgWidth div 10);
          E2.Text := IntToStr(pgHeight div 10);
        end;
      E3.Text := IntToStr(Round(pgMargins.Left / Millimeters));
      E4.Text := IntToStr(Round(pgMargins.Top / Millimeters));
      E5.Text := IntToStr(Round(pgMargins.Right / Millimeters));
      E6.Text := IntToStr(Round(pgMargins.Bottom / Millimeters));
      E7.Text := IntToStr(Round(ColGap / Millimeters));
      UpDown1.Position := ColCount;
      UpDown1.Associate := Edit1;
      if ShowModal = mrOk then
        begin
          Page.ZoomX := Up1.Position;
          Page.ZoomY := Up2.Position;
          PrintToPrevPage := CB1.Checked;
          PHonFirst := CB2.Checked;
          PFonLast := CB3.Checked;
          CHCopy := CB4.Checked;
          if RB1.Checked then
            pgOr := poPortrait
          else
            pgOr := poLandscape;
          p := PrinterSettings.PaperSizes[ComB1.ItemIndex];
          w := 0;
          h := 0;
          if p = pgCustomSize then
          try
            w := StrToInt(E1.Text) * 10;
            h := StrToInt(E2.Text) * 10;
          except
            on exception do p := 9; // A4
          end;
          try
            pgMargins := Rect(Round(StrToInt(E3.Text) * Millimeters),
              Round(StrToInt(E4.Text) * Millimeters),
              Round(StrToInt(E5.Text) * Millimeters),
              Round(StrToInt(E6.Text) * Millimeters));
            ColGap := Round(StrToInt(E7.Text) * Millimeters);
          except
            on exception do
              begin
                pgMargins := Rect(0, 0, 0, 0);
                ColGap := 0;
              end;
          end;
          ColCount := UpDown1.Position;
          ChangePaper(p, w, h, pgOr);
          CurPage := CurPage; // for repaint and other
          ChangeObject;
          ImgHoriz.Paint;
          ImgVert.Paint;
          ShowUnit;
        end;
    end;
  PgoptForm.Free;
end;

procedure TFRDesignerForm.N8Click(Sender: TObject);
begin
  // printer setup
  DocOptForm := TDocOptForm.Create(nil);
  with DocOptForm do
    begin
      CB2.Checked := CurReport.DoublePass;
      CB3.Checked := CurReport.Fascicoli;
      CB4.Enabled := CurReport.Fascicoli;
      CB4.Checked := CurReport.Reimpose;
      if ShowModal = mrOk then
        begin
          CurReport.DoublePass := CB2.Checked or CB4.Checked;
          CurReport.Fascicoli := CB3.Checked;
          CurReport.Reimpose := CB4.Checked;
          ChangeObject;
        end;
      Free;
    end;
end;

procedure TFRDesignerForm.N14Click(Sender: TObject);
begin
  // grid menu
  Gr2.Checked := GridAlign;
  case GridSize of
    4: Gr3.Checked := True;
    8: Gr4.Checked := True;
    19: Gr5.Checked := True;
  end;
end;

procedure TFRDesignerForm.Gr2Click(Sender: TObject);
begin
  // Grid-align menu command
  with Sender as TMenuItem do
    begin
      Checked := not Checked;
      GridAlign := Checked;
    end;
end;

procedure TFRDesignerForm.Gr3Click(Sender: TObject);
begin
  // grid size
  with Sender as TMenuItem do
    begin
      Checked := True;
      GridSize := Tag;
    end;
end;

procedure TFRDesignerForm.GB2Click(Sender: TObject);
begin
  GridAlign := GB2.Down;
end;

procedure TFRDesignerForm.N22Click(Sender: TObject);
begin
  // selection shape
  (Sender as TMenuItem).Checked := True;
  if N22.Checked then
    ShapeMode := smFrame
  else
    ShapeMode := smBar;
end;

procedure TFRDesignerForm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  DoClick(UpDown1);
end;

procedure TFRDesignerForm.Popup1Popup(Sender: TObject);
var
  i: Integer;
  t, t1: TfrView;
  fl: Boolean;
begin
  EnableControls;
  while Popup1.Items.Count > 7 do
    Popup1.Items.Delete(7);
  if SelNum = 1 then
    TfrView(Objects[frGetTopSelected]).DefinePopupMenu(Popup1)
  else
    if SelNum > 1 then
      begin
        t := Objects[frGetTopSelected];
        fl := True;
        for i := 0 to Objects.Count - 1 do
          begin
            t1 := Objects[i];
            if t1.Selected then
              if not (((t is TfrMemoView) and (t1 is TfrMemoView)) or
                ((t.Typ <> gtAddIn) and (t.Typ = t1.Typ)) or
                ((t.Typ = gtAddIn) and (t.ClassName = t1.ClassName))) then
                begin
                  fl := False;
                  break;
                end;
          end;
        if fl then t.DefinePopupMenu(Popup1);
      end;
end;

procedure TFRDesignerForm.N37Click(Sender: TObject);
begin
  // toolbars
  Pan1.Checked := Panel1.Visible;
  Pan2.Checked := Panel2.Visible;
  Pan3.Checked := Panel3.Visible;
  Pan4.Checked := Panel4.Visible;
  Pan5.Checked := InspForm.Visible;
  Pan6.Checked := AlignForm.Visible;
end;

procedure TFRDesignerForm.Pan1Click(Sender: TObject);
begin
  with Sender as TMenuItem do
    begin
      Checked := not Checked;
      case Tag of
        0:
          begin
            Panel1.Visible := Checked;
            Panel1.Top := -30;
          end;
        1:
          begin
            Panel2.Visible := Checked;
            Panel2.Top := 20;
          end;
        2:
          begin
            Panel3.Visible := Checked;
            Panel3.Top := 90;
          end;
        3: Panel4.Visible := Checked;
        4: InspForm.Visible := Checked;
        5: AlignForm.Visible := Checked;
      end;
    end;
  SetFocus;
end;

const
  rsGridAlign = 'GridAlign';
  rsGridSize = 'GridSize';
  rsUnits = 'Units';

procedure TFRDesignerForm.SaveState;
var
  Ini: TRegIniFile;
  procedure DoSaveToolbars(t: array of TPanel);
  var
    i: Integer;
  begin
    for i := Low(t) to High(t) do
      begin
        SaveToolBar(t[i]);
        t[i].Visible := False;
      end;
  end;

begin
  Ini := TRegIniFile.Create(RegKey);
  Ini.WriteBool(Options, rsGridAlign, GridAlign);
  Ini.WriteInteger(Options, rsGridSize, GridSize);
  Ini.WriteInteger(Options, rsUnits, Units);
  Ini.Free;
  DoSaveToolbars([Panel1, Panel2, Panel3, Panel4]);
  SaveFormPosition(InspForm);
  InspForm.Hide;
  SaveFormPosition(AlignForm);
  AlignForm.Hide;
end;

procedure TFRDesignerForm.RestoreState;
var
  Ini: TRegIniFile;
  procedure DoRestoreToolbars(t: array of TPanel);
  var
    i: Integer;
  begin
    for i := Low(t) to High(t) do
      RestoreToolBar(t[i]);
  end;

begin
  Ini := TRegIniFile.Create(RegKey);
  GridSize := Ini.ReadInteger(Options, rsGridSize, 4);
  FUnits := Ini.ReadInteger(Options, rsUnits, DefaultUnit);
  case FUnits of
    0: FConverter := 1;
    1: FConverter := 1 / Millimeters;
    2: FConverter := 1 / Inch;
  end;
  GridAlign := Ini.ReadBool(Options, rsGridAlign, True);
  Ini.Free;
  DoRestoreToolBars([Panel4, Panel3, Panel2, Panel1]);
  RestoreFormPosition(InspForm);
  RestoreFormPosition(AlignForm);
end;
{----------------------------------------------------------------------------}
function Objects: TList;
begin
  Result := frDesigner.Page.Objects;
end;

procedure DrawHSplitter(Canvas: TCanvas; Rect: TRect);
begin
  with Canvas do
    begin
      Pen.Mode := pmXor;
      Pen.Color := clSilver;
      Pen.Width := 1;
      MoveTo(Rect.Left, Rect.Top);
      LineTo(Rect.Right, Rect.Bottom);
      Pen.Mode := pmCopy;
    end;
end;

procedure DrawFocusRect(Canvas: TCanvas; Rect: TRect);
begin
  with Canvas do
    begin
      Pen.Mode := pmXor;
      Pen.Color := clSilver;
      Pen.Width := 1;
      Pen.Style := psSolid;
      Brush.Style := bsClear;
      Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
      Pen.Mode := pmCopy;
      Brush.Style := bsSolid;
    end;
end;

procedure frSetGlyph(Color: TColor; sb: TSpeedButton; n: Integer);
var
  b: TBitmap;
  r: TRect;
  i, j, X, Y: Integer;
begin
  case sb.Tag of
    5: CurFillColor := Color;
    19: CurFrameColor := Color;
    17: CurFontColor := Color;
  end;
  b := TBitmap.Create;
  b.Width := 32;
  b.Height := 16;
  with b.Canvas do
    begin
      r := Rect(n * 32, 0, n * 32 + 32, 16);
      CopyRect(Rect(0, 0, 32, 16), DesignerForm.Image1.Picture.Bitmap.Canvas, r);
      I := 0;
      J := 0;
      while (I <= 32) and (Pixels[I, J] <> clRed) do
        begin
          J := 0;
          while (J <= 16) and (Pixels[I, J] <> clRed) do
            Inc(J);
          if (Pixels[I, J] <> clRed) then Inc(I);
        end;
      for X := I to I + 15 do
        for Y := J to J + 2 do
          if Color <> clNone then
            Pixels[X, Y] := Color
          else
            if (X = I) or (X = I + 15) or (Y = J) or (Y = J + 2) then
              Pixels[X, Y] := clBlack
            else
              Pixels[X, Y] := clSilver;
    end;
  sb.Glyph.Assign(b);
  sb.NumGlyphs := 2;
  b.Free;
end;

procedure DrawSelection(t: TfrView);
var
  px, py: Word;
  procedure DrawPoint(x, y: Word);
  begin
    Preview.Canvas.MoveTo(x, y);
    Preview.Canvas.LineTo(x, y);
  end;
begin
  if t.Selected then
    with t, Preview.Canvas do
      begin
        Pen.Width := 5;
        Pen.Mode := pmXor;
        Pen.Color := clWhite;
        px := Left + Width div 2;
        py := Top + Height div 2;
        DrawPoint(Left, Top);
        DrawPoint(Left + Width, Top);
        DrawPoint(Left, Top + Height);
        if Objects.IndexOf(t) = RightBottom then
          Pen.Color := clTeal;
        DrawPoint(LEft + Width, Top + Height);
        Pen.Color := clWhite;
        if SelNum = 1 then
          begin
            DrawPoint(px, Top);
            DrawPoint(px, Top + Height);
            DrawPoint(Left, py);
            DrawPoint(Left + Width, py);
          end;
        Pen.Mode := pmCopy;
      end;
end;

procedure DrawShape(t: TfrView);
begin
  if t.Selected then
    with t do
      if ShapeMode = smFrame then
        DrawFocusRect(Preview.Canvas, Rect(Left, Top, Left + Width + 1, Top + Height + 1))
      else
        with Preview.Canvas do
          begin
            Pen.Width := 1;
            Pen.Mode := pmNot;
            Brush.Style := bsSolid;
            Rectangle(Left, Top, Left + Width + 1, Top + Height + 1);
            Pen.Mode := pmCopy;
          end;
end;

procedure Draw(N: Integer; ClipRgn: HRGN);
var
  i: Integer;
  t: TfrView;
  R, R1: HRGN;
  procedure DrawBackground;
  var
    K: Integer;
    PixelTo2: Double;
  begin
    with Preview.Canvas do
      begin

        Brush.Style := bsSolid;
        Brush.Color := clWhite;
        Pen.Color := clWhite;
        Rectangle(0, 0, Preview.Width, Preview.Height);

        if NoPreview then
          begin
            Brush.Style := bsClear;
            Pen.Width := 1;
            Pen.Color := $00E0E0E0;
            Pen.Style := psSolid;
            Pen.Mode := pmCopy;

            case DesignerForm.Units of
              0: PixelTo2 := 3;
              1: PixelTo2 := Millimeters;
            else
              PixelTo2 := Inch / 10;
            end;
            Pen.Style := psSolid;
            for K := 0 to Preview.Width div 5 do
              begin
                if K mod 2 = 0 then
                  Rectangle(Round(K * 5 * PixelTo2), 0,
                    Round(K * 5 * PixelTo2) + 1, Preview.Height);
              end;

            Pen.Style := psDot;
            for K := 0 to Preview.Width div 5 do
              if K mod 2 = 1 then
                Rectangle(Round(K * 5 * PixelTo2), 0,
                  Round(K * 5 * PixelTo2) + 1, Preview.Height);

            Pen.Style := psSolid;
            for K := 0 to Preview.Height div 5 do
              if K mod 2 = 0 then
                Rectangle(0, Round(K * 5 * PixelTo2), Preview.Width,
                  Round(K * 5 * PixelTo2) + 1);

            Pen.Style := psDot;
            for K := 0 to Preview.Height div 5 do
              if K mod 2 = 1 then
                Rectangle(0, Round(K * 5 * PixelTo2), Preview.Width,
                  Round(K * 5 * PixelTo2) + 1);

          end;

        Brush.Style := bsClear;
        Pen.Width := 1;
        Pen.Color := clGray;
        Pen.Style := psSolid;
        Pen.Mode := pmCopy;

        with frDesigner.Page do
          begin
            if NoPreview then
              with PrnInfo do
                Rectangle(Ofx, Ofy, Pw + Ofx, Ph + Ofy);
            Pen.Style := psDot;
            with pgMargins, PrnInfo do
              if (Left <> 0) or (Right <> 0) or (Top <> 0) or (Bottom <> 0) then
                Rectangle(Left, Top, Pgw - Right, Pgh - Bottom);
          end;
      end;
  end;
  function IsVisible(t: TfrView): Boolean;
  var
    R: HRGN;
  begin
    R := t.GetClipRgn(rtNormal);
    Result := CombineRgn(R, R, ClipRgn, RGN_AND) <> NULLREGION;
    DeleteObject(R);
  end;

begin
  if (DocMode <> dmDesigning) or (CurReport.Pages.Count = 0) then Exit;
  if ClipRgn = 0 then
    with Preview.Canvas.ClipRect do
      ClipRgn := CreateRectRgn(Left, Top, Right, Bottom);

  if frCharset <> DEFAULT_CHARSET then
    Preview.Canvas.Font.Charset := frCharset;

  R := CreateRectRgn(0, 0, Preview.Width, Preview.Height);
  if Objects = nil then Exit;
  for i := Objects.Count - 1 downto 0 do
    begin
      t := Objects[i];
      if i <= N then
        if t.Selected then
          t.Draw(Preview.Canvas)
        else
          if IsVisible(t) then
            begin
              R1 := CreateRectRgn(0, 0, 1, 1);
              CombineRgn(R1, ClipRgn, R, RGN_AND);
              SelectClipRgn(Preview.Canvas.Handle, R1);
              DeleteObject(R1);
              t.Draw(Preview.Canvas);
            end;
      R1 := t.GetClipRgn(rtNormal);
      CombineRgn(R, R, R1, RGN_DIFF);
      DeleteObject(R1);
      SelectClipRgn(Preview.Canvas.Handle, R);
    end;
  CombineRgn(R, R, ClipRgn, RGN_AND);
  DrawBackground;

  DeleteObject(R);
  DeleteObject(ClipRgn);
  SelectClipRgn(Preview.Canvas.Handle, 0);
  DrawPage(dmSelection);
end;

procedure DrawPage(DrawMode: TDesignerDrawMode);
var
  i: Integer;
  t: TfrView;
begin
  if DocMode <> dmDesigning then Exit;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      case DrawMode of
        dmAll: t.Draw(Preview.Canvas);
        dmSelection: DrawSelection(t);
        dmShape: DrawShape(t);
      end;
    end;
end;

function frGetTopSelected: Integer;
var
  i: Integer;
begin
  if CurReport.Pages.Count > 0 then
    begin
      Result := Objects.Count - 1;
      for i := Objects.Count - 1 downto 0 do
        if TfrView(Objects[i]).Selected then
          begin
            Result := i;
            break;
          end;
    end
  else
    Result := 0;
end;

function frCheckBand(b: TfrBandType): Boolean;
var
  i: Integer;
  t: TfrView;
begin
  Result := False;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Typ = gtBand then
        if b = TfrBandView(T).BandType then
          begin
            Result := True;
            break;
          end;
    end;
end;

function GetUnusedBand: TfrBandType;
var
  b: TfrBandType;
begin
  Result := btNone;
  for b := btReportTitle to btNone do
    if not frCheckBand(b) then
      begin
        Result := b;
        break;
      end;
  if Result = btNone then Result := btMasterData;
end;

procedure SendBandsToDown;
var
  i, j, n, k: Integer;
  t: TfrView;
begin
  n := Objects.Count;
  j := 0;
  i := n - 1;
  k := 0;
  while j < n do
    begin
      t := Objects[i];
      if t.Typ = gtBand then
        begin
          Objects.Delete(i);
          Objects.Insert(0, t);
          Inc(k);
        end
      else
        Dec(i);
      Inc(j);
    end;
  for i := 0 to n - 1 do // sends btOverlay to back
    begin
      t := Objects[i];
      if (t.Typ = gtBand) and (TfrBandView(T).BandType = btOverlay) then
        begin
          Objects.Delete(i);
          Objects.Insert(0, t);
          break;
        end;
    end;
  i := 0;
  j := 0;
  while j < n do // sends btColumnXXX to front
    begin
      t := Objects[i];
      if (t.Typ = gtBand) and
        (TfrBandView(T).BandType in [btColumnHeader..btColumnFooter]) then
        begin
          Objects.Delete(i);
          Objects.Insert(k - 1, t);
        end
      else
        Inc(i);
      Inc(j);
    end;
end;

procedure Unselect;
begin
  DesignerForm.Unselect;
end;

procedure ClearClipBoard;
var
  t: TfrView;
begin
  if Assigned(ClipBd) then
    with ClipBd do
      while Count > 0 do
        begin
          t := Items[0];
          if T.LinkToDataSet then
            begin
              T.Free;
              Delete(0);
            end
          else
            T.Free;
          Delete(0);
        end;
end;

procedure GetRegion;
var
  i: Integer;
  t: TfrView;
  R: HRGN;
begin
  ClipRgn := CreateRectRgn(0, 0, 0, 0);
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
        begin
          R := t.GetClipRgn(rtExtended);
          CombineRgn(ClipRgn, ClipRgn, R, RGN_OR);
          DeleteObject(R);
        end;
    end;
  FirstChange := False
end;

procedure TFRDesignerForm.BtnPrevClick(Sender: TObject);
begin
  Dec(IndexAction);
  LoadReport;
  BtnNext.Enabled := True;
  Restore.Enabled := True;
  if IndexAction = 0 then
    begin
      BtnPrev.Enabled := False;
      FileBtn3.Enabled := False;
      //                          N15.Enabled:=False;
      N20.Enabled := False;
      Undo.Enabled := False;
    end;
end;

procedure TFRDesignerForm.BtnNextClick(Sender: TObject);
begin
  Inc(IndexAction);
  LoadReport;
  BtnPrev.Enabled := True;
  Undo.Enabled := True;
  FileBtn3.Enabled := True;
  //N15.Enabled:=True;
  N20.Enabled := True;
  if IndexAction = ListAction.Count - 1 then
    begin
      BtnNext.Enabled := False;
      Restore.Enabled := False;
    end;
end;

procedure TFRDesignerForm.FileBtn31Click(Sender: TObject);
begin
   SaveOK;
end;

procedure TFRDesignerForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If Not Assigned(CurReport.ToStream) Then
     if not OKNew then CanClose:=False;
end;

procedure TFRDesignerForm.M1Click(Sender: TObject);
begin
  with Sender as TMenuItem do
    begin
      Checked := True;
      FUnits := Tag;
    end;
  case FUnits of
    0: FConverter := 1;
    1: FConverter := 1 / Millimeters;
    2: FConverter := 1 / Inch;
  end;
  ImgHoriz.Paint;
  ImgVert.Paint;
  ShowUnit;
  StatusBar1.Repaint;
  FillInspFields;
  InspForm.ItemsChanged;
  RedrawPage;
end;

procedure TFRDesignerForm.MastMenuClick(Sender: TObject);
begin
  case FUnits of
    0: M1.Checked := True;
    1: M2.Checked := True;
    2: M3.Checked := True;
  end;
end;

procedure TFRDesignerForm.TabPagesChange(Sender: TObject);
begin
  CurPage := TabPages.TabIndex;
end;

procedure TFRDesignerForm.Wiz1Click(Sender: TObject);
begin
  // create new report from wizard
  if OKNew then
    begin
      ReportWizard := TReportWizard.Create(nil);
      if ReportWizard.ShowModal = mrOK then
        begin
          CurPage := 0;
          Caption := OldCaption;
          ImgHoriz.Paint;
          ImgVert.Paint;
          ShowUnit;
          LastDB := '';
        end;
      ReportWizard.Free;
    end;
end;

procedure TFRDesignerForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (((Key >= 'a') and (Key <= 'z')) or ((Key >= 'A') and (Key <= 'Z'))) and
    not ((ActiveControl is TCustomEdit) or
    (ActiveControl is TCustomComboBox)) then
    begin
      InspForm.SetFocus;
      SendMessage(InspForm.Edit1.Handle, WM_Char, Ord(Key), 0);
    end;
end;

procedure TFRDesignerForm.C3KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key < '0') or (Key > '9') then Key := #0;
end;

{ 07/03/2001 - Zanella
  Portata a a livello PRIVATE la routine di caricamento report }
procedure TFRDesignerForm.Load(S: string);
begin
  { Se il file esiste, carica il report }
  if FileExists(S) then
    begin
      CurReport.Pages.Clear;
      CurReport.Pages.Add;
      CurPage := 0;
      CurReport.FileName := '';
      Caption := OldCaption;
      CurReport.LoadFromFile(S);
      Caption := OldCaption + ' - ' + OnlyName;
      RenumerTabPages;
      CurPage := 0; // do all
      LastDB := '';

      { 07/03/2001 - Zanella
        Aggiorna il menu dei report recentemente aperti }
      AggiornaRecenti(S);
      { 07/03/2001 - Zanella }
    end
  else
    begin
      { Altrimenti visualizza un messaggio di errore }
      Application.MessageBox(PChar(Format(FRConst_NoLoadReport, [ExtractFileName(S), S])),
        PChar(FRConst_Attenction), MB_OK or MB_ICONERROR);
    end;
end;
{ 08/03/2001 - Fine }

{ 08/03/2001 - Zanella
  Aggiunta routine per l'aggiornamento dell'elenco degli ultimi report aperti }
procedure TFRDesignerForm.AggiornaRecenti(sFileName: string);
var
  iNumReport: Integer;
  Item: TMenuItem;

  function FindMenu(Menu: TMenuItem; FileName: string): Boolean;
  var
    I: Integer;
  begin
    I := 0;
    while (I <= Menu.Count - 1) and
      (UpperCase(Menu[I].Caption) <> UpperCase(FileName)) do
      Inc(I);
    Result := I <= Menu.Count - 1;
  end;

begin
  { Se il report non è già nell'elenco... }
  if not FindMenu(ReopenMenu, sFileName) then
    begin
      { Salva il numero di item del sottomenu }
      iNumReport := ReopenMenu.Count;

      { Conserva al massimo 5 report }
      if (iNumReport >= 5) then
        begin
          { Punta al report più vecchio della lista dei recenti }
          Item := ReopenMenu.Items[Pred(iNumReport)];

          { Rimuove l'item dal menu e lo rilascia }
          ReopenMenu.Remove(Item);
          Item.Free;
        end;

      { Inserisce il nuovo menu nella lista dei recenti }
      Item := TMenuItem.Create(ReopenMenu);
      Item.Caption := sFileName;
      Item.OnClick := ReOpenReport;

      ReopenMenu.Insert(0, Item);
    end;
end;
{ 08/03/2001 - Fine }

{ 08/03/2001 - Zanella
  Aggiunta routine per la riapertura di un report }
procedure TFRDesignerForm.ReOpenReport(Sender: TObject);
var
  S: string;
begin
  if (Sender is TMenuItem) then
    begin
      { Se l'utente conferma l'apertura del report... }
      if OKNew then
        begin
          { ...Riapre il report }
          S := TMenuItem(Sender).Caption;
          Load(S);
        end;
    end;
end;
{ 08/03/2001 - Fine }

procedure TFRDesignerForm.N4Click(Sender: TObject);
begin
  ReopenMenu.Enabled := (ReopenMenu.Count > 0);
end;

procedure TFRDesignerForm.PgB4Click(Sender: TObject);
var
  P: TPagesList;
  I, J, N: Integer;
  S: string;
  St: TMemoryStream;
  L: TList;
  T: TfrView;
  B: Byte;
  M: ShortString;
begin
  P := TPagesList.Create(nil);
  with P do
    begin
      for I := 1 to CurReport.Pages.Count do
        P.Pages.Items.Add(FRConst_Page + ' ' + IntToStr(I));
      if P.ShowModal = mrOK then
        begin
          L := TList.Create;
          St := TMemoryStream.Create;
          for I := 0 to CurReport.Pages.Count - 1 do
            begin
              L.Add(Pointer(St.Position));
              CurReport.Pages.Pages[I].SaveToStream(St);
              N := CurReport.Pages.Pages[I].Objects.Count;
              St.Write(N, 4);
              for J := 0 to N - 1 do
                begin
                  T := CurReport.Pages.Pages[I].Objects[J];
                  B := Byte(T.Typ);
                  St.Write(B, 1);
                  if T.Typ = gtAddIn then
                    begin
                      M := RawByteString(T.ClassName);
                      B := Length(M);
                      St.Write(B, 1);
                      St.Write(M[1], B);
                    end;
                  T.SaveToStream(St);
                end;
            end;
          for I := 0 to CurReport.Pages.Count - 1 do
            begin
              S := P.Pages.Items[I];
              N := StrToInt(Copy(S, Length(FRConst_Page + ' ') + 1, 100)) - 1;
              St.Position := Integer(L[N]);
              CurReport.Pages.Pages[I].LoadFromStream(St);
              CurReport.Pages.Pages[I].Objects.Clear;
              St.Read(N, 4);
              for J := 0 to N - 1 do
                begin
                  St.Read(B, 1);
                  if B = gtAddIn then
                    begin
                      St.Read(B, 1);
                      M[0] := AnsiChar(B);
                      St.Read(M[1], B);
                      CurReport.Pages.Pages[I].Objects.Add(frCreateObject(gtAddIn, String(M)))
                    end
                  else
                    CurReport.Pages.Pages[I].Objects.Add(frCreateObject(B, String(M)));
                  T := CurReport.Pages.Pages[I].Objects.Items[CurReport.Pages.Pages[I].Objects.Count - 1];
                  T.LoadFromStream(St);
                end;
            end;
          L.Free;
          St.Free;
          ChangeObject;
          CurPage := CurPage;
        end;
      Free;
    end;
end;

initialization
  ListAction := TList.Create;
  frDesignerClass := TfrDesignerForm;
  ClipBd := TList.Create;
  IndexAction := 0;
  MoveObject := False;
  SaveMenu := TStringList.Create;

   If ListAction=Nil Then
      ListAction:=TList.Create;
   If frDesignerClass=Nil Then
      frDesignerClass:=TfrDesignerForm;
   If ClipBd=Nil Then
      ClipBd:=TList.Create;
   IndexAction:=0;
   MoveObject:=False;
   If (frDesignerClass<>Nil) And (SaveMenu=Nil) Then
      SaveMenu := TStringList.Create;

finalization
   ClearClipBoard;
   NullList;
   //
   If ClipBd<>Nil Then
   Begin
      ClearClipBoard;
      FreeAndNil(ClipBd);
   End;
   If ListAction<>Nil Then
   Begin
      NullList;
      FreeAndNil(ListAction);
   End;
   If SaveMenu<>Nil Then
      FreeAndNil(SaveMenu);

end.
