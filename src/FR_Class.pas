
{*****************************************}
{                                         }
{             FastReport v2.2             }
{             Report classes              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Class;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Printers, Controls,
  Forms, StdCtrls, StrUtils, ComCtrls, Dialogs, Menus, Buttons, DB, DBClient,
  Variants, ExtCtrls, JPEG, FR_Utils, FR_Expr, FR_Const;

const
  flStretched = 1;
  flWordWrap = 2;
  flAutoSize = 4;
  flBandNewPageAfter = 2;
  flBandPrintifSubsetEmpty = 4;
  flBandPageBreak = 8;
  flBandCompleteList = 16;
  flPictCenter = 2;
  flPictRatio = 4;
  gtMemo = 0;
  gtPicture = 1;
  gtBand = 2;
  gtSubReport = 3;
  gtAddIn = 10;

  mmToPixel = 794 / 2100;

type

  TfrDsgOptions = set of (doSaveConfirm);

  TRangeBegin = (rbFirst, rbCurrent);
  TRangeEnd = (reLast, reCurrent, reCount);
  TCheckEOFEvent = procedure(Sender: TObject; var EOF: Boolean) of object;

  TFrAlignment = (frLeftJustify, frRightJustify, frCenter, frWidthJustify);

  TFrVerticalAlignment = (tvaUp, tvaCenter, tvaDown);

  TSaveDataSet = record
    Start: TRangeBegin;
    TheEnd: TRangeEnd;
    Count: Integer;
  end;

  TfrDrawMode = (drAll, drCalcHeight, drAfterCalcHeight, drPart);
  TfrBandType = (btReportTitle, btReportSummary,
    btPageHeader, btPageFooter,
    btMasterHeader, btMasterData, btMasterFooter,
    btDetailHeader, btDetailData, btDetailFooter,
    btSubDetailHeader, btSubDetailData, btSubDetailFooter,
    btOverlay, btStaticColumnHeader, btStaticColumnFooter,
    btGroupHeader, btGroupFooter,
    btColumnHeader, btColumnData, btColumnFooter, btNone);

  SetOfTfrBandType = set of TfrBandType;

  TfrDataSetPosition = (psLocal, psGlobal);
  TfrValueType = (vtNotAssigned, vtDBField, vtOther);
  TfrPageMode = (pmNormal, pmBuildList);
  TfrBandRecType = (rtShowBand, rtFirst, rtNext);
  TfrRgnType = (rtNormal, rtExtended);
  TfrDataSetOperation = (opInit, opExit, opFirst, opNext, opPrior);

  TfrView = class;
  TfrBand = class;
  TfrPage = class;
  TfrReport = class;
  TfrExportFilter = class;

  TDetailEvent = procedure(const ParName: string; var ParValue: Variant) of object;

  TOnDrawObject = procedure(View: TfrView) of object;

  TFunctionEvent = procedure(const name: string; p1, p2, p3: Variant;
    var Val: Variant) of object;

  TOnBeforePrint = procedure(var Continue: Boolean) of object;

  TOnAfterPrint = procedure of object;

  TEnterRectEvent = procedure(Memo: TStringList; View: TfrView) of object;
  TDataSetWorkEvent = procedure(BandName: string; DataSet: TDataSet; var
    RecordCount: Integer; Operation: TfrDataSetOperation) of object;
  TBeginDocEvent = procedure of object;
  TEndDocEvent = procedure of object;
  TBeginPageEvent = procedure(pg: Integer) of object;
  TEndPageEvent = procedure(pg: Integer) of object;
  TProgressEvent = procedure(n: Integer) of object;

  TfrHighlightAttr = packed record
    FontStyle: TFontStyles;
    FontColor, FillColor: TColor;
  end;

  TfrPrnInfo = record // print info about page size, margins e.t.c
    PPgw, PPgh, Pgw, Pgh: Integer; // page width/height (printer/screen)
    POfx, POfy, Ofx, Ofy: Integer; // offset x/y
    Pw, Ph: Integer; // printable width/height
  end;

  PfrPageInfo = ^TfrPageInfo;
  TfrPageInfo = packed record // pages of a preview
    R       : TRect;
    pgSize  : Word;
    pgWidth,
    pgHeight: Integer;
    pgOr    : TPrinterOrientation;
    pgMargins: Boolean;
    PrnInfo : TfrPrnInfo;
    Pict    : TMetaFile;
    Canvas  : TMetafileCanvas;
  end;

  PfrBandRec = ^TfrBandRec;
  TfrBandRec = packed record
    Band: TfrBand;
    Action: TfrBandRecType;
  end;

  PVariantData = ^TVariantData;
  TVariantData = record
    Name: string;
    Data: Variant;
  end;

  TfrFrame = record
    Color: TColor;
    DrawBottom, DrawLeft, DrawRight, DrawTop: Boolean;
    Style: TPenStyle;
    Width: Integer;
  end;

  TfrPreview = class(TForm)
  private
    FReport: TfrReport;
    MS: TMemoryStream;
  protected
    FModal: Boolean;
    procedure DrawPage(Cnv: HDC; N: Integer; R: TRect); virtual;
    procedure Show_Report(AReport: TfrReport);
    procedure DoHide; override;
  public
    property Report: TfrReport read FReport;
  end;

  TfrPreviewClass = class of TfrPreview;

  TfrDataset = class(TComponent)
  protected
    FRangeBegin: TRangeBegin;
    FRangeEnd: TRangeEnd;
    FRangeEndCount: Integer;
    FOnFirst, FOnNext,
    FOnPrior: TNotifyEvent;
    FOnCheckEOF: TCheckEOFEvent;
    FRecNo, FRealRecNo: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure Exit; virtual;
    procedure First; virtual;
    procedure Prior; virtual;
    procedure Next; virtual;
    function EOF: Boolean; virtual;
    property RangeBegin: TRangeBegin read FRangeBegin write FRangeBegin default
      rbFirst;
    property RangeEnd: TRangeEnd read FRangeEnd write FRangeEnd default reLast;
    property RangeEndCount: Integer read FRangeEndCount write FRangeEndCount
      default 0;
    property RecordNo: Integer read FRecNo;
    property OnCheckEOF: TCheckEOFEvent read FOnCheckEOF write FOnCheckEOF;
    property OnFirst: TNotifyEvent read FOnFirst write FOnFirst;
    property OnNext: TNotifyEvent read FOnNext write FOnNext;
    property OnPrior: TNotifyEvent read FOnPrior write FOnPrior;
  end;

  TfrUserDataset = class(TfrDataset)
  published
    property RangeBegin;
    property RangeEnd;
    property RangeEndCount;
    property OnCheckEOF;
    property OnFirst;
    property OnNext;
    property OnPrior;
  end;

  TfrDBDataSet = class(TfrDataset)
  private
    FDataSet: TDataSet;
    FEof, FDisableDataSetControls, OKInit, OldActive, OldDisable: Boolean;
    FGetDataSetError, FFilter: string;
    FFiltered: Boolean;
    function GetDataSet: TDataSet;
  protected
    {$IFNDEF Delphi2}
    FBookmark: Integer;
    {$ELSE}
    FBookmark: TBookmark;
    {$ENDIF}
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure CheckFilter(GoNext: Boolean); virtual;
  public
    procedure Init; override;
    procedure Exit; override;
    procedure First; override;
    procedure Prior; override;
    procedure Next; override;
    function EOF: Boolean; override;
    property GetDataSetError: string read FGetDataSetError;
    property DisableDataSetControls: Boolean read FDisableDataSetControls write
      FDisableDataSetControls default True;
    constructor Create(AOwner: TComponent); override;
  published
    property Filter: string read FFilter write FFilter;
    property Filtered: Boolean read FFiltered write FFiltered default False;
    property DataSet: TDataSet read GetDataSet write FDataSet;
    property RangeBegin;
    property RangeEnd;
    property RangeEndCount;
    property OnCheckEOF;
    property OnFirst;
    property OnNext;
    property OnPrior;
  end;

  TfrView = class(TObject)
  private
    FName: ShortString;
    FReport: TfrReport;
  protected
    Parent: TfrBand;
    Canvas: TCanvas;
    DRect: TRect;
    gapx, gapy: Integer;
    Memo1: TStringList;
    oldx, oldy, olddy, olddx, OldTop: Integer;
    OriginalBandViewType: TfrBandType;
    FrameTyp: Word;
    function GetLinkToDataSet: Boolean; virtual;
    procedure CalcGaps; virtual;
    procedure ShowBackGround; virtual;
    procedure ShowFrame; virtual;
    procedure BeginDraw(ACanvas: TCanvas);
    procedure SetName(Value: ShortString);
    procedure SetCaption(Value: string);
    function GetCaption: string;
    function GetFrameTop: Boolean;
    procedure SetFrameTop(Value: Boolean);
    function GetFrameBottom: Boolean;
    procedure SetFrameBottom(Value: Boolean);
    function GetFrameLeft: Boolean;
    procedure SetFrameLeft(Value: Boolean);
    function GetFrameRight: Boolean;
    procedure SetFrameRight(Value: Boolean);
  public
    Typ: Byte;
    Selected: Boolean;
    OriginalRect: TRect;
    Left, Top, Width, Height: Integer;
    Flags: Word;
    FrameWidth: Integer;
    FrameColor: TColor;
    FrameStyle: TPenStyle;
    // Stored with 2 bytes for compatybility with old FR version (Word).
    Color: TColor;
    Format: Integer;
    FormatStr: string;
    Memo: TStringList;
    Visible: Boolean;
    constructor Create(Rep: TfrReport); virtual;
    procedure Assign(From: TfrView); virtual;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas); virtual; abstract;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure Resized; virtual;
    procedure GetBlob(b: TField); virtual;
    procedure DefinePopupMenu(Popup: TPopupMenu); virtual;
    function GetClipRgn(rt: TfrRgnType): HRGN; virtual;
    procedure SetAllFrames;
    procedure ResetAllFrames;
    property LinkToDataSet: Boolean read GetLinkToDataSet;
    property Name: ShortString read FName write SetName;
    property ParentReport: TfrReport read FReport;
    property Caption: string read GetCaption write SetCaption;
    property DrawFrameTop: Boolean read GetFrameTop write SetFrameTop;
    property DrawFrameBottom: Boolean read GetFrameBottom write SetFrameBottom;
    property DrawFrameLeft: Boolean read GetFrameLeft write SetFrameLeft;
    property DrawFrameRight: Boolean read GetFrameRight write SetFrameRight;
  end;

  TfrCustomMemoView = class(TfrView)
  private
    procedure PStretchClick(Sender: TObject);
  protected
    DrawMode: TfrDrawMode;
    FromLine: Integer;
    TextHeight: Integer;
    TotalHeight: Integer;
    AllTotal, ReturnPresent: Boolean;
    function ThetextHeight: Integer; virtual;
    procedure ExpandVariables; virtual; abstract;
    function GetAutoStretch: Boolean;
    procedure SetAutoStretch(Value: Boolean);
  public
    procedure DefinePopupMenu(Popup: TPopupMenu); override;
    property AutoStretch: Boolean read GetAutoStretch write SetAutoStretch;
  end;

  TfrMemoView = class(TfrCustomMemoView)
  private
    MemoVHeight: integer;
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
  protected
    FUseHlt: Boolean;
    Adjust: Integer;
    procedure AssignFont;
    procedure WrapMemo;
    procedure CheckReturn;
    procedure CalcAutoSize;
    procedure ShowMemo;
    function GetAlignment: TFrAlignment;
    procedure SetAlignment(Value: TFrAlignment);
    function GetVertAlignment: TFrVerticalAlignment;
    procedure SetVertAlignment(Value: TFrVerticalAlignment);
    function GetRotate: Boolean;
    procedure SetRotate(value: Boolean);
    function GetWordWrap: Boolean;
    procedure SetWordWrap(Value: Boolean);
    function GetAutoSize: Boolean;
    procedure SetAutoSize(Value: Boolean);
  public
    Highlight: TfrHighlightAttr;
    HighlightStr: string;
    UseHighlight: WordBool;
    Font: TFont;
    constructor Create(Rep: TfrReport); override;
    destructor Destroy; override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure GetBlob(b: TField); override;
    procedure DefinePopupMenu(Popup: TPopupMenu); override;
    procedure ExpandVariables; override;
    property Alignment: TfrAlignment read GetAlignment write SetAlignment;
    property VerticalAlignment: TFrVerticalAlignment read GetVertAlignment write
      SetVertAlignment;
    property Rotate90: Boolean read GetRotate write SetRotate;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap;
    property AutoSize: Boolean read GetAutoSize write SetAutoSize;
  end;

  // Use this object for create a Band in your report.
  TfrBandView = class(TfrView)
  private
    procedure PStretchClick(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure P4Click(Sender: TObject);
    function GetCompleteList: Boolean;
    procedure SetCompleteList(Value: Boolean);
    function GetForceNewPage: Boolean;
    procedure SetForceNewPage(Value: Boolean);
    function GetPrintifSubsetEmpty: Boolean;
    procedure SetPrintifSubsetEmpty(Value: Boolean);
    function GetPageBreak: Boolean;
    procedure SetPageBreak(Value: Boolean);
    function GetAutoStretch: Boolean;
    procedure SetAutoStretch(Value: Boolean);
    function GetBandType: TfrBandType;
    procedure SetBandType(Value: TfrBandType);
  protected
    function GetLinkToDataSet: Boolean; override;
  public
    // Basic constructor method.
    // Use this method for create an instance to this object.
    constructor Create(Rep: TfrReport); override;

    // Standard destructor method.
    // Do not call Destroy directly in an application.  Instead, call Free.
    destructor Destroy; override;

    // This method draw the object into the specified Canvas.
    // Override this method when you want create a descendent.
    procedure Draw(Canvas: TCanvas); override;

    procedure DefinePopupMenu(Popup: TPopupMenu); override;
    function GetClipRgn(rt: TfrRgnType): HRGN; override;

    // Set this property to True, when you want that any objects into the Band,
    // are automatically showed (whitout text) at the footer's page.
    // Use this property to complete a list in a document.
    //
    // The Default value is False.
    property CompleteList: Boolean read GetCompleteList write SetCompleteList;

    // Set this property to True, when you want that the report change
    // page after every band draw.
    //
    // The Default value is False.
    property ForceNewPage: Boolean read GetForceNewPage write SetForceNewPage;

    // Set this property to True, when you wont show a Master-Band whitout Details.
    // This property is used when you have a multi levels report.
    //
    // The Default value is False.
    property PrintifSubsetEmpty: Boolean read GetPrintifSubsetEmpty write
      SetPrintifSubsetEmpty;

    // Set this property to True, when you wont divide
    // a single long band, into many pages.
    // This property is used when you have a long stretched band.
    //
    // Use it with AutoStretch property.
    //
    // The Default value is False.
    property PageBreak: Boolean read GetPageBreak write SetPageBreak;

    // Set this property to True, when you want that any objects into the Band,
    // are automatically stretched (in the Height).
    // This property works only with TfrCustomMemoView descendents.
    //
    // This objects are simple rettangle text (TfrMemoView),
    // framed memo text (TfrFramedMemoView) and RichText (TfrRichView).
    //
    // The Default value is False.
    property AutoStretch: Boolean read GetAutoStretch write SetAutoStretch;

    // Set this property to select the Band Type (Header, Data, Footer).
    // There are many band types.
    //
    // The complete list is in TfrBandType type.
    property BandType: TfrBandType read GetBandType write SetBandType;
  end;

  TfrSubReportView = class(TfrView)
  protected
    Deleting: boolean;
  public
    SubPage: Integer;
    constructor Create(Rep: TfrReport); override;
    destructor Destroy; override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefinePopupMenu(Popup: TPopupMenu); override;
  end;

  TfrCustomPictureView = class(TfrView)
  private
    procedure PStretchClick(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    function GetCenter: Boolean;
    procedure SetCenter(Value: Boolean);
    function GetStretch: Boolean;
    procedure SetStretch(Value: Boolean);
    function GetKeepRatio: Boolean;
    procedure SetKeepRatio(Value: Boolean);
  public
    procedure DefinePopupMenu(Popup: TPopupMenu); override;
    property Center: Boolean read GetCenter write SetCenter;
    property Stretch: Boolean read GetStretch write SetStretch;
    property KeepRatio: Boolean read GetKeepRatio write SetKeepRatio;
  end;

  TfrPictureView = class(TfrCustomPictureView)
  private
    FGraphic: TGraphic;
  protected
    DrawPict: TPicture;
    DrawPictOK: Boolean;
    DrawBitmap: TBitmap;
  public
    Picture: TPicture;
    constructor Create(Rep: TfrReport); override;
    procedure Assign(From: TfrView); override;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure GetBlob(b: TField); override;
  end;

  TfrBand = class(TObject)
  private
    Parent: TfrPage;
    Typ: TfrBandType;
    Next, Prev: TfrBand;
    SubIndex, MaxY: Integer;
    EOFReached: Boolean;
    EOFArr: array[0..31] of Boolean;
    Positions: array[TfrDatasetPosition] of Integer;
    LastGroupValue: Variant;
    LastBand, FooterBand: TfrBand;
    GroupValues: TStringList;
    Count: Integer;
    Num: Byte;
    procedure InitDataSet(Desc: string);
    function CalcHeight: Integer;
    procedure StretchObjects(var MaxHeight: Integer);
    procedure DrawObject(t: TfrView; DrawMode: TfrDrawMode);
    procedure PrepareSubReports;
    procedure DoSubReports;
    function DrawObjects(DrawMode: TfrDrawMode): Boolean;
    procedure DrawColumnCell(Parnt: TfrBand; CurX: Integer);
    procedure DrawColumnAll;
    function CheckPageBreak(y, dy: Integer; PBreak: Boolean): Boolean;
    procedure DrawPageBreak(DrawMode: TfrDrawMode);
    function DoCalcHeight: Integer;
    procedure DoDraw;
    function Draw: Boolean;
    procedure InitGroupValues;
    procedure DoAggregate;
  protected
    CompleteProcess: Boolean; // Check if complete process is run.
  public
    x, y, dx, dy, maxdy: Integer;
    ParentView: TfrView;
    PrintIfSubsetEmpty, NewPageAfter, Stretched,
      PageBreak, CompleteList, Visible: Boolean;
    Objects: TList;
    Memo: TStringList;
    DataSet: TfrDataSet;
    DataCount, RowCount, MaxDataCount: Integer;
    AggregateFunctions, VerticalFunctions: TStringList;
    GroupCondition: string;
    constructor Create(ATyp: TfrBandType; AParent: TfrPage);
    destructor Destroy; override;
  end;

  TfrValue = class
  public
    Typ: TfrValueType;
    OtherKind: Integer; // for vtOther - typ, for vtDBField - format
    DataSet: string; // for vtDBField
    Field: string; // here is an expression for vtOther
    DSet: TDataSet;
    DField: TField;
  end;

  TfrValues = class(TPersistent)
  private
    FItems: TStringList;
    function GetValue(Index: Integer): TfrValue;
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function AddValue: Integer;
    function FindVariable(const s: string): TfrValue;
    procedure ReadBinaryData(Stream: TStream);
    procedure WriteBinaryData(Stream: TStream);
    procedure Clear;
    property Items: TStringList read FItems write FItems;
    property Objects[Index: Integer]: TfrValue read GetValue;
  end;

  TfrPage = class(TObject)
  private
    Bands: array[TfrBandType] of TfrBand;
    Skip, InitFlag: Boolean;
    CurY, CurBottomY: Integer;
    CurColumn, LastStaticColumnY, XAdjust: Integer;
    List: TList;
    Mode: TfrPageMode;
    PlayFrom: Integer;
    LastBand: TfrBand;
    ColPos, CurPos: Integer;
    function TopMargin: Integer;
    function BottomMargin: Integer;
    function LeftMargin: Integer;
    function RightMargin: Integer;
    procedure InitReport;
    procedure DoneReport;
    procedure TossObjects;
    procedure CheckAggregate;
    procedure FormPage;
    procedure AddRecord(b: TfrBand; rt: TfrBandRecType);
    procedure ClearRecList;
    procedure CompleteBandList(B: TfrBand);
    function PlayRecList: Boolean;
    procedure ShowBand(b: TfrBand);
    procedure NewPage;
    procedure DrawPageFooters(FreeCanvases: Boolean);
    function BandExists(b: TfrBand): Boolean;
  public
    pgSize, pgWidth, pgHeight: Integer;
    ZoomX, ZoomY: Integer; // New. Add in 2.35 version;
    pgMargins: TRect;
    pgOr: TPrinterOrientation;
    PHonFirst, PFonLast, CHCopy, PrintToPrevPage: WordBool;
    PrnInfo: TfrPrnInfo;
    ColCount, ColWidth, ColGap: Integer;
    Objects: TList;
    constructor Create(ASize, AWidth, AHeight: Integer; AOr:
      TPrinterOrientation;
      ADoc: TfrReport);
    destructor Destroy; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure ChangePaper(ASize, AWidth, AHeight: Integer; AOr:
      TPrinterOrientation);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  end;

  TfrPages = class(TComponent) 
  private
    Parent: TfrReport;
    function GetCount: Integer;
    function GetPages(Index: Integer): TfrPage;
  public
    FPages: TList;
    Constructor Create(AOwner: TComponent); Override;
    destructor Destroy; override;
    procedure Clear;
    procedure Add;
    procedure Delete(Index: Integer);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property Pages[Index: Integer]: TfrPage read GetPages; default;
    property Count: Integer read GetCount;
  end;

  TfrEMFPages = class(TComponent) 
  private
    Parent: TfrReport;
    function GetCount: Integer;
    function GetPages(Index: Integer): PfrPageInfo;
  public
    FPages: TList;
    Constructor Create(AOwner: TComponent); Override;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(Page: TfrPage);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    property Pages[Index: Integer]: PfrPageInfo read GetPages; default;
    property Count: Integer read GetCount;
  end;

  TfrReport = class(TComponent)
  private
    FIsSequenced: Boolean;
    FDsgOptions: TfrDsgOptions;
    FAutoLoad, FPathFromExe: string;
    FInternalAutoLoad: string;
    FInternalAutoLoadDateTime: TDateTime;
    FPixelsPerInch: Integer;
    FScaled: Boolean;
    FDisableDataSetControls, FModalPreview: Boolean;
    FPages: TfrPages;                                   
    FEMFPages: TfrEMFPages;                             
    FVars: TStrings;                                     
    FVal: TfrValues;                                     
    FTitle: string;
    FShowProgress: Boolean;
    FReportDir: string;
    FTemplDir: string;
    FOnDataSetWork: TDataSetWorkEvent;
    FOnBeginDoc: TBeginDocEvent;
    FOnBeforePrint: TOnBeforePrint;
    FOnAfterPrint: TOnAfterPrint;
    FOnDrawObject, FOnDrawedObject: TOnDrawObject;
    FOnEndDoc: TEndDocEvent;
    FOnBeginPage: TBeginPageEvent;
    FOnEndPage: TEndPageEvent;
    FOnGetValue: TDetailEvent;
    FOnProgress: TProgressEvent;
    FOnFunction: TFunctionEvent;
    FCurrentFilter: TfrExportFilter;
    FFromPage, FToPage, Fn: Integer;
    //FCollate: Boolean;
    FToPdf:String;
    FToStream:TMemoryStream;
    FCurPage: TfrPage;
    function SearchFunction(Id: string; ParameterList: TStringList): Variant;
    function FormatValue(V: Variant; Format: Integer;
      const FormatStr: string): string;
    procedure PrepareDataSets;
    procedure BuildBeforeModal(Sender: TObject);
    procedure PrintBeforeModal(Sender: TObject);
    procedure DoBuildReport; virtual;
    procedure DoPrintReport(FromPage, ToPage, n: Integer; ToPdf:String=''); //Collate: Boolean);
    procedure SetVars(Value: TStrings);
    procedure StartReport;
    procedure SetAutoLoad(Value: string);
    procedure ResetStatistic(ID: string; var V: Variant);
    procedure InternalExportTo(Sender: TObject);
    procedure WritePixelsPerInch(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadBinaryData(Stream: TStream);
    procedure WriteBinaryData(Stream: TStream);
    procedure CheckAutoLoad;
  public
    DataSetList: TStringList;
    CanRebuild: Boolean; // true, if report can be rebuilded
    FileName: string;
    HasBlobs: Boolean;
    Terminated, Build: Boolean;
    DoublePass, Fascicoli, Reimpose: WordBool;
    FinalPass: Boolean;
    //
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // service methods
    function FindVariable(Variable: string): Integer;
    function FindObject(Name: string): TfrView;
    function ObjectByName(Name: string): TfrView;
    procedure DeleteObject(T: TfrView);
    procedure InsertObject(T: TfrView; PageNo, Index: Integer);
    procedure SetDataSetBand(BandName: string; DataSet: TfrDataSet);
    function ChekBandType(BT: TfrBandType; PageNo: Integer): Boolean;
    //Itta
    function IsDataSetBand(BandName: string): Boolean;
    function GetDataSetBand(BandName: string): TfrDataSet;
    function ReplaceDataSetBand(FromDataSet:String; ToDataSet:TfrDataSet):Boolean;
    // Add in 2.4
    procedure ClearDataSetList;

    // Add in 2.1 (Fuzzy)
    procedure NewPage;

    procedure GetVarList(CatNo: Integer; List: TStrings);
    procedure GetCategoryList(List: TStrings);
    // internal events used through report building
    procedure InternalOnEnterRect(Memo: TStringList; View: TfrView);
    procedure InternalOnGetValue(const ParName: string; var ParValue: string);
    procedure InternalOnProgress(Percent: Integer);
    procedure InternalOnDrawObject(View: TfrView);
    procedure InternalOnDrawedObject(View: TfrView);
    // load/save methods
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(FName: string);
    procedure SaveToFile(FName: string);
    procedure LoadFromDB(DataSet: TDataSet; DocN: Integer);
    procedure SaveToDB(DataSet: TDataSet; DocN: Integer);
    procedure LoadTemplate(fname: string; comm: TStrings;
      Bmp: TBitmap; Load: Boolean);
    procedure SaveTemplate(fname: string; comm: TStrings; Bmp: TBitmap);
    procedure LoadPreparedReport(FName: string);
    procedure SavePreparedReport(FName: string);
    // report manipulation methods
    procedure DesignReport(MStream:TMemoryStream=Nil);
    procedure NewReport;
    function PrepareReport: Boolean;
    procedure ExportTo(Filter: TClass; Var FileName: string);
    procedure ShowReport;
    procedure ShowPreparedReport;
    procedure PrintPreparedReport(FromPage, ToPage, n: Integer; ToPdf:String=''); //Collate: Boolean);
    procedure PrintReport; // New. Add in 2.35 version.
    // printer manipulation methods
    function ChangePrinter(OldIndex, NewIndex: Integer): Boolean;
    //
    property Variables: TStrings read FVars write SetVars;
    property Pages: TfrPages read FPages;
    property EMFPages: TfrEMFPages read FEMFPages;
    property IsSequenced: Boolean read FIsSequenced default True;
    property ToStream: TMemoryStream Read FToStream; //Itta
  published
    property ShowProgress: Boolean read FShowProgress write FShowProgress default
      True;
    property TemplateDir: string read FTemplDir write FTemplDir;
    property Title: string read FTitle write FTitle;
    property Values: TfrValues read FVal write FVal;
    property DisableDataSetControls: Boolean read FDisableDataSetControls write
      FDisableDataSetControls default True;
    property ModalPreview: Boolean read FModalPreview write FModalPreview default
      True;
    property ReportDir: string read FReportDir write FReportDir;
    property AutoLoad: string read FAutoLoad write SetAutoLoad;
    property PathFromExe: string read FPathFromExe write FPathFromExe;
    property PixelsPerInch: Integer read FPixelsPerInch write FPixelsPerInch
      stored False;
    property Scaled: Boolean read FScaled write FScaled default True;
    property DesignerOptions: TfrDsgOptions read FDsgOptions write FDsgOptions
      default [doSaveConfirm];
    property OnDataSetWork: TDataSetWorkEvent read FOnDataSetWork write
      FOnDataSetWork;
    property OnBeforePrint: TOnBeforePrint read FOnBeforePrint write
      FOnBeforePrint;
    property OnAfterPrint: TOnAfterPrint read FOnAfterPrint write FOnAfterPrint;
    property OnBeginDoc: TBeginDocEvent read FOnBeginDoc write FOnBeginDoc;
    property OnEndDoc: TEndDocEvent read FOnEndDoc write FOnEndDoc;
    property OnBeginPage: TBeginPageEvent read FOnBeginPage write FOnBeginPage;
    property OnEndPage: TEndPageEvent read FOnEndPage write FOnEndPage;
    property OnGetValue: TDetailEvent read FOnGetValue write FOnGetValue;
    property OnUserFunction: TFunctionEvent read FOnFunction write FOnFunction;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnDrawObject: TOnDrawObject read FOnDrawObject write FOnDrawObject;
    property OnDrawedObject: TOnDrawObject read FOnDrawedObject write FOnDrawedObject;
  End;

  TfrCompositeReport = class(TfrReport)
  private
    procedure DoBuildReport; override;
  public
    Reports: TList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TfrReportDesigner = class(TForm)
  protected
    procedure ClearChangedList; virtual; abstract;
  public
    Page: TfrPage;
    procedure RegisterObject(ButtonBmp: TBitmap; const ButtonHint: string;
      ButtonTag: Integer); virtual; abstract;
    procedure PopupNotify(Sender: TfrView); virtual; abstract;
  end;

  TfrDesignerClass = class of TfrReportDesigner;

  TfrObjEditorForm = class(TForm)
  public
    procedure ShowEditor(t: TfrView); virtual;
  end;

  TfrEditorClass = class of TfrObjEditorForm;

  TfrExportFilter = class(TObject)
  protected
    Stream  : TStream;
    Doc     : TfrReport;
    FileName: string;
    Title   : String;
    Author  : String;
  public
    constructor Create(AFileName,ATitle,AAuthor:String); virtual;
    function Execute: Boolean; virtual;
    procedure OnBeginDoc; virtual;
    procedure OnEndDoc; virtual;
    procedure OnBeginPage(Width, Height: Integer); virtual;
    procedure OnEndPage; virtual;
    procedure OnText(x, y: Integer; const text: string; Font: TFont); virtual;
    Procedure OnPicture(BM: TBitMap; X, Y, H, E:Integer); Virtual;
    Procedure OnPaintPage(MF:TMetaFile; IPage:Integer); Virtual;
  end;

  TfrFunctionLibrary = class(TObject)
  public
    List: TStringList;

    constructor Create; virtual;
    destructor Destroy; override;
    function OnFunction(const FName: string; p1, p2, p3: Variant; var Val: Variant): Boolean;
    procedure DoFunction(FNo: Integer; p1, p2, p3: Variant; var Val: Variant); virtual; abstract;
  end;

procedure SetPreviewClass(ClassType: TfrPreviewClass);
procedure GetDefaultData(S: string; var DataSet: TDataSet; var Field: TField);
function frCreateObject(Typ: Byte; const ClassName: string): TfrView;
procedure frRegisterObject(ClassRef: TClass; ButtonBmp: TBitmap;
  const ButtonHint: string; EditorClass: TfrEditorClass);
procedure frRegisterExportFilter(ClassRef: TClass;
  const FilterDesc, FilterExt: string);
procedure frRegisterFunctionLibrary(ClassRef: TClass);
procedure DoError(S: string);
function FindGlobalDataSet(GlobalName: string): TDataSet;
function GetBrackedVariable(s: string; var i, j: Integer): string;

// Version History
// 22 2.2  version
// 23 2.3  version
// 24 2.31 version (internal beta version)
// 25 2.32 version (internal beta version)
// 26 2.35 version (The first QuickReport compatible)
// 27 2.0  version (FuzzyReport
//                  With DataSet Expression-Filter, many Properties/Methods/Events added,...)
// 28 2.04 version (Rewrite TfrPictureView - Draw - LoadFromStream - SaveToStream ... )
// 29 2.1 rc1 version

const
  frCurrentVersion = 29; // this is current version (2.1 rc1) from Dell'Aria Fabio
  // Now compatible with QuickReport format page.
  frSpecFuncs: array[0..frSpecCount - 1] of string = ('PAGE#', '',
    'DATE', 'TIME', 'LINE#', 'LINETHROUGH#', 'COLUMN#', 'CURRENT#',
    'TOTALPAGES');

  frBandAutoStretch: SetOfTfrBandType = [btReportTitle, btReportSummary,
  btPageHeader, btColumnHeader,
    btMasterHeader..btSubDetailFooter,
    btGroupHeader, btGroupFooter];
  frBandForceNewPage: SetOfTfrBandType = [btReportTitle, btReportSummary,
  btMasterData, btDetailData,
    btSubDetailData, btMasterFooter,
    btDetailFooter, btSubDetailFooter,
    btGroupHeader];
  frBandPageBreak: SetOfTfrBandType = [btReportTitle, btReportSummary,
  btMasterHeader..btSubDetailFooter,
    btGroupHeader, btGroupFooter];
  frBandPrintIfSubSetEmpty: SetOfTfrBandType = [btMasterData, btDetailData];
  frBandCompleteList: SetOfTfrBandType = [btMasterData, btDetailData,
  btSubDetailData];

type
  TfrAddInObjectInfo = record
    ClassRef: TClass;
    EditorClass: TfrEditorClass;
    ButtonBmp: TBitmap;
    ButtonHint: string;
  end;

  TfrExportFilterInfo = record
    ClassRef: TClass;
    FilterDesc, FilterExt: string;
  end;

  TfrFunctionInfo = record
    FunctionLibrary: TfrFunctionLibrary;
  end;

var
  frDesigner: TfrReportDesigner; // Designer Form reference
  frDesignerClass: TfrDesignerClass; // Designer Class reference
  CurReport: TfrReport; // currently proceeded report
  CurField: TField; // currently uses field (searchfunction)
  DocMode: (dmDesigning, dmPrinting); // current mode
  PrintMode: (pmViewing, pmPrinting); // current print mode
  DisableDrawing: Boolean;
  frAddIns: array[0..31] of TfrAddInObjectInfo; // add-in objects
  frAddInsCount: Integer;
  frFilters: array[0..31] of TfrExportFilterInfo; // export filters
  frFiltersCount: Integer;
  frFunctions: array[0..31] of TfrFunctionInfo; // function libraries
  frFunctionsCount: Integer;
  PageNo: Integer; // current page number in Building mode
  frCharset: 0..255;
  frBandNames: array[0..21] of string;
  frSpecArr: array[0..frSpecCount - 1] of string;
  frVersion: Byte; // version of currently loaded report
  ValueStr: string;
  CurDataRow, CurStrNo, CurFontHeight: Integer; // used for export
  CurViewDy: Integer; // used for calculate TextHeight in any frView controls.
  ErrorFlag: Boolean; // error occured through TfrView drawing
  ErrorStr: string; // error description
  IntoMe: Boolean; // Uses for DrawColumnCell interaction.
  TerminatedFilter: Boolean;

var
  //  Array uses for the NumberToLetter function.
  NumberFunction1: array[0..19] of string;
  NumberFunction2: array[0..9] of string;
  NumberFunction3: array[0..9] of string;

IMPLEMENTATION
Uses
   FR_Fmted, FR_Prev, FR_Prntr, FR_Progr, FR_PrFlt;

const
  pkNone = 0;
  pkBitmap = 1;
  pkMetafile = 2;
  pkIcon = 3;
  pkJPeg = 4;

type
  TfrBandParts = (bpHeader, bpData, bpFooter);

var
  SHeight, VHeight: Integer; // used for height calculation of TfrMemoView
  SMemo: TStringList; // temporary memo used during TfrView drawing
  SBmp: TBitmap; // small bitmap used by TfrBandView drawing
  CurDate, CurTime: TDateTime; // date/time of report starting
  CurView: TfrView; // currently proceeded view
  CurBand: TfrBand; // currently proceeded band
  CurPage: TfrPage; // currently proceeded page
  CurLevel: Integer; // currently band level (1=Maser, 2=Detail, 3=Subdetail)
  CurPageNumber: Integer; // currently page number
  ColumnNumber: Integer; // currently column number
  CurValue: Variant; // used for highlighting
  CurVariable: string;
  SavedAllPages: Integer; // number of pages in entire report
  MasterReport: TfrReport; // reference to main composite report
  NewPageArray: array[0..999] of Word;
  AggregateBand, StatisticBand: TfrBand;
  // Used for calculate aggregate functions;

// variables used through report building
  MCanvas: TMetafileCanvas;
  PrevY, PrevBottomY, ColumnXAdjust: Integer;
  Append, WasPF: Boolean;
  CompositeMode: Boolean;
  PreparedStream: TMemoryStream;
  CurrentPixelsPerInch: Integer;
  PreviewActive: TfrPreview;
  PreviewClass: TfrPreviewClass; // Currently preview class.
  //Itta
  SortedList: TStringList;

Type
   Params = Record
      Pn        : Integer;
      ObjNo     : Integer;
      Rct       : TRect;
      Dx, Dy    : Double;
      LastAngle : Double;
      Angs      : TStringList;
      NewDraw   : Boolean;
      StdPreview: TStandardPreview;
      WDx,WDy   : Integer;
      Wx,Wy     : Integer;
      VDx,VDy   : Integer;
      Vx,Vy     : Integer;
   End;
   PParams  = ^ Params;
   Arr      = Array [0..999] Of Integer;
   PArr     = ^Arr;

   SaveFont = Record
      Angle: Double;
   End;
   PSaveFont = ^SaveFont;

{----------------------------------------------------------------------------}
Function AnteStr(S,Sep:String): String;
begin
   Try
      if Pos(Sep,S)=0 then Result:=S
      else Result:=Copy(S,1,Pos(Sep,S)-1);
   Except
      Result:='';
   End;
end;

Function PostStr(S,Sep:String): String;
begin
   Try
      if Pos(Sep,S)=0 then Result:=''
      else Result:=Copy(S,Pos(Sep,S)+Length(Sep),Length(S));
   Except
      Result:='';
   End;
end;

{----------------------------------------------------------------------------}
function FindGlobalDataSet(GlobalName: string): TDataSet;
var
  C: TComponent;
  I, j: Integer;
  Form, DataSet: string;
begin
  Form := UpperCase(Copy(GlobalName, 1, Pos('.', GlobalName) - 1));
  DataSet := UpperCase(Copy(GlobalName, Pos('.', GlobalName) + 1,
    Length(GlobalName)));
  I := 0;
  C := nil;
  while (I <= Screen.FormCount - 1) and
    (UpperCase(Screen.Forms[I].Name) <> Form) do
    Inc(I);
  if I <= Screen.FormCount - 1 then
    C := Screen.Forms[I]
  else
    begin
      I := 0;
      while (I <= Screen.DataModuleCount - 1) and
        (UpperCase(Screen.DataModules[I].Name) <> Form) do
        Inc(I);
      if I <= Screen.DataModuleCount - 1 then
        C := Screen.DataModules[I]
      else
        begin
          for i := 0 to Screen.FormCount - 1 do
            for j := 0 to Screen.Forms[i].ComponentCount - 1 do
              if (Screen.Forms[i].Components[j] is TDataModule) and
                (UpperCase(Screen.Forms[i].Components[j].Name) = Form) then
                C := Screen.Forms[i].Components[j];
        end;
    end;
  if C <> nil then
    Result := TDataSet(C.FindComponent(DataSet))
  else
    Result := nil;
end;

procedure DoError(S: string);
begin
  if ErrorFlag then Exit;
  ErrorFlag := True;
  ErrorStr := FRConst_ErrorOccured;
  if S <> '' then ErrorStr := ErrorStr + #13 + S;
  if (CurView <> nil) and (CurView.Parent = CurBand) then
    ErrorStr := ErrorStr + #13 + FRConst_Object + ': ' + UTF8ToString(CurView.Name);
    //ErrorStr := ErrorStr + #13 + FRConst_Object + ': ' + CurView.Name;
  if CurBand <> nil then
    ErrorStr := ErrorStr + #13 + FRConst_Band + ' ' +
      frBandNames[Integer(CurBand.Typ)];
  ErrorStr := ErrorStr + #13 + FRConst_Pg + ': ' + IntToStr(CurPageNumber);
  MasterReport.Terminated := True;
end;

procedure ClearValues(Bnd: TfrBand; N: Byte);
var
  I: Integer;
  PV: ^Variant;
  S: string;
begin
  if DisableDrawing then Exit;
  for I := 0 to Bnd.AggregateFunctions.Count - 1 do
    begin
      if Copy(Bnd.AggregateFunctions[I],
        Length(Bnd.AggregateFunctions[I]), 1) <= Chr(N) then
        begin
          S := Copy(Bnd.AggregateFunctions[I], 1, 3);
          PV := Pointer(Bnd.AggregateFunctions.Objects[I]);
          if S = 'SUM' then
            PV^ := 0
          else
            if S = 'AVG' then
              PV^ := 0
            else
              if S = 'MIN' then
                PV^ := 1E200
              else
                if S = 'MAX' then PV^ := -1E200;
        end;
    end;
  Bnd.DataCount := 0;
  Inc(Bnd.RowCount);
end;

procedure AddValues(Bnd: TfrBand);
var
  Prm, Idf, St, LastPrm: string;
  I: Integer;
  PV: ^Variant;
  N, LastValue: Variant;
  L: TList;

  procedure AddNewValue;
  begin
    New(PV);
    if Idf = 'SUM' then
      PV^ := 0
    else
      if Idf = 'AVG' then
        PV^ := 0
      else
        if Idf = 'MIN' then
          PV^ := 1E200
        else
          if Idf = 'MAX' then PV^ := -1E200;
    L.Add(PV);
  end;

begin
  if (DisableDrawing) or (Bnd.DataSet.EOF) then Exit;
  LastPrm := '';
  LastValue := Null;
  for I := 0 to Bnd.AggregateFunctions.Count - 1 do
    begin
      St := Bnd.AggregateFunctions[I];
      PV := Pointer(Bnd.AggregateFunctions.Objects[I]);
      Idf := Copy(St, 1, 3);
      Prm := Copy(St, 5, Length(St) - 7 - Ord(St[Length(St) - 1]));
      if (I = 0) or (LastPrm <> Prm) then
        begin
          N := Calc(Prm);
          LastPrm := Prm;
          LastValue := N;
        end
      else
        N := LastValue;
      if (VarType(N) = varString) and (N = '') then N := 0;
      if Idf = 'SUM' then
        PV^ := PV^ + N
      else
        if Idf = 'AVG' then
          PV^ := ((PV^ * Bnd.DataCount) + N) / (Bnd.DataCount + 1)
        else
          if Idf = 'MIN' then
            begin
              if N < PV^ then
                PV^ := N
            end
          else
            if Idf = 'MAX' then
              begin
                if N > PV^ then
                  PV^ := N
              end
    end;
  Inc(Bnd.DataCount);
  if CurBand.Typ = btMasterData then
    begin
      if (CurPage.Bands[btMasterData].DataSet = nil) or
        (CurPage.Bands[btMasterData].DataSet.EOF) then Exit;
      for I := 0 to Bnd.VerticalFunctions.Count - 1 do
        begin
          St := Bnd.VerticalFunctions[I];
          Idf := Copy(St, 1, 3);
          Prm := Copy(St, 5, Length(St) - 6 - Ord(St[Length(St)]));
          L := TList(Bnd.VerticalFunctions.Objects[I]);
          if L.Count < Bnd.DataCount then AddNewValue;
          PV := L[Bnd.DataCount - 1];
          N := Calc(Prm);
          if (VarType(N) = varString) and (N = '') then N := 0;
          if Idf = 'SUM' then
            PV^ := PV^ + N
          else
            if Idf = 'AVG' then
              PV^ := ((PV^ * Bnd.RowCount) + N) / (Bnd.RowCount + 1)
            else
              if Idf = 'MIN' then
                begin
                  if N < PV^ then
                    PV^ := N
                end
              else
                if Idf = 'MAX' then
                  begin
                    if N > PV^ then
                      PV^ := N
                  end;
        end;
      if Bnd.MaxDataCount < Bnd.DataCount then
        Bnd.MaxDataCount := Bnd.DataCount;
    end;
end;

function GetBrackedVariable(s: string; var i, j: Integer): string;
var
  c: Integer;
begin
  j := i;
  c := 0;
  Result := '';
  if s = '' then Exit;
  Dec(j);
  repeat
    Inc(j);
    if s[j] = '[' then
      begin
        if c = 0 then i := j;
        Inc(c);
      end
    else
      if s[j] = ']' then Dec(c);
  until (c = 0) or (j >= Length(s));
  Result := Copy(s, i + 1, j - i - 1);
end;

procedure CheckAggregateFunctions(Bnd: TfrBand; Operation: TfrDataSetOperation);
begin
  case Operation of
    opFirst:
      begin
        ClearValues(Bnd, 0);
        AddValues(Bnd);
      end;
    opNext: AddValues(Bnd);
  end;
end;

procedure CheckBandEvent(Bnd: TfrBand; Operation: TfrDataSetOperation);
var
  T: TfrView;
  I, J, RecCount: Integer;
  Ds: TDataSet;
  Found: Boolean;
begin
  T := nil;
  I := 0;
  Found := False;
  while (I <= CurReport.Pages.Count - 1) and (not Found) do
    begin
      J := 0;
      while (J <= CurReport.Pages.Pages[I].Objects.Count - 1) and (not Found) do
        begin
          T := CurReport.Pages.Pages[I].Objects[J];
          if (T.Typ = gtBand) and (TfrBandType(T.FrameTyp) in
            [btMasterData, btDetailData, btSubDetailData, btColumnData]) and
            (T.FormatStr = Bnd.DataSet.Name) and
            (Bnd.Typ = TfrBandType(T.FrameTyp)) then
            Found := True
          else
            Inc(J);
        end;
      Inc(I);
    end;
  if T <> nil then
    begin
      if Assigned(CurReport.FOnDataSetWork) then
        begin
          if Bnd.DataSet.InheritsFrom(TfrDBDataSet) then
            Ds := TfrDBDataSet(Bnd.DataSet).DataSet
          else
            Ds := nil;
          RecCount := Bnd.DataSet.RangeEndCount;
          CurReport.FOnDataSetWork(UTF8ToString(T.Name), Ds, RecCount, Operation);
          Bnd.DataSet.RangeEndCount := RecCount;
        end;
    end;
end;

function frCreateObject(Typ: Byte; const ClassName: string): TfrView;
var
  i: Integer;
begin
  Result := nil;
  case Typ of
    gtMemo: Result := TfrMemoView.Create(CurReport);
    gtPicture: Result := TfrPictureView.Create(CurReport);
    gtBand: Result := TfrBandView.Create(CurReport);
    gtSubReport: Result := TfrSubReportView.Create(CurReport);
    gtAddIn:
      begin
        for i := 0 to frAddInsCount - 1 do
          if frAddIns[i].ClassRef.ClassName = ClassName then
            begin
              Result := TfrView(frAddIns[i].ClassRef.NewInstance);
              Result.Create(CurReport);
              Result.Typ := gtAddIn;
              Break;
            end;
        if Result = nil then
          begin
            Application.MessageBox(PChar(Format(FRConst_ClassNoFound, [ClassName])),
              FRConst_Error, MB_OK + MB_ICONERROR);
            SysUtils.Abort;
          end;
      end;
  end;
end;

procedure frRegisterObject(ClassRef: TClass; ButtonBmp: TBitmap;
  const ButtonHint: string; EditorClass: TfrEditorClass);
begin
  frAddIns[frAddInsCount].ClassRef := ClassRef;
  frAddIns[frAddInsCount].EditorClass := EditorClass;
  frAddIns[frAddInsCount].ButtonBmp := ButtonBmp;
  frAddIns[frAddInsCount].ButtonHint := ButtonHint;
  Inc(frAddInsCount);
end;

procedure frRegisterExportFilter(ClassRef: TClass;
  const FilterDesc, FilterExt: string);
begin
  frFilters[frFiltersCount].ClassRef := ClassRef;
  frFilters[frFiltersCount].FilterDesc := FilterDesc;
  frFilters[frFiltersCount].FilterExt := FilterExt;
  Inc(frFiltersCount);
end;

procedure frRegisterFunctionLibrary(ClassRef: TClass);
begin
  frFunctions[frFunctionsCount].FunctionLibrary :=
    TfrFunctionLibrary(ClassRef.NewInstance);
  frFunctions[frFunctionsCount].FunctionLibrary.Create;
  Inc(frFunctionsCount);
end;

function Create90Font(Font: TFont): HFont;
var
  F: TLogFont;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @F);
  F.lfEscapement := 900;
  F.lfOrientation := 900;
  Result := CreateFontIndirect(F);
end;

function CheckColumnBand(B: TfrBandType): Boolean;
var
  Bnd: TfrBand;
begin
  Result := False;
  Bnd := CurPage.Bands[B];
  if (CurView.oldx >= Bnd.x) and (CurView.oldx + CurView.Width <= Bnd.x + Bnd.dx) then Result := True;
end;

function CheckFooterBand: Boolean;
const
  Bnds: array[1..4] of TfrBandType = (btReportSummary, btPageFooter,
    btMasterFooter, btStaticColumnFooter);
var
  Bnd: TfrBand;
  I: Integer;
begin
  Result := False;
  for I := 1 to 4 do
    begin
      Bnd := CurPage.Bands[Bnds[I]];
      if (CurView.oldy >= Bnd.y) and
        (CurView.oldy + CurView.Height <= Bnd.y + Bnd.dy) then
        begin
          Result := True;
          Break;
        end;
    end;
end;

procedure SetPreviewClass(ClassType: TfrPreviewClass);
begin
  PreviewClass := ClassType;
end;

procedure GetDefaultData(S: string; var DataSet: TDataSet; var Field: TField);
var
  Res: TfrDataset;
begin
  if (Pos('.', S) > 0) and (S[1] <> '"') then
    frGetDataSetAndField(S, DataSet, Field)
  else
    begin
      DataSet := nil;
      Res := nil;
      if (CurPage <> nil) and (CurView <> nil) then
        case CurView.OriginalBandViewType of
          btReportTitle, btReportSummary,
            btPageHeader, btPageFooter,
            btMasterHeader, btMasterData, btMasterFooter,
            btStaticColumnHeader, btStaticColumnFooter,
            btGroupHeader, btGroupFooter:
            Res := CurPage.Bands[btMasterData].DataSet;
          btDetailHeader, btDetailData, btDetailFooter:
            Res := CurPage.Bands[btDetailData].DataSet;
          btSubDetailHeader, btSubDetailData, btSubDetailFooter:
            Res := CurPage.Bands[btSubDetailData].DataSet;
          btColumnHeader, btColumnData, btColumnFooter:
            Res := CurPage.Bands[btColumnData].DataSet;
        end;
      if Res <> nil then
        if Res.InheritsFrom(TfrDBDataSet) then DataSet := TfrDBDataSet(Res).DataSet;
      if DataSet <> nil then
        begin
          if (S[1] = '"') and (S[Length(S)] = '"') then
            Field := DataSet.FindField(Copy(s, 2, Length(s) - 2))
          else
            Field := DataSet.FindField(S);
        end;
    end;
end;

function CanAssignName(Rep: TfrReport; NewName: ShortString; Obj: TfrView):
  TfrView;
var
  I, J: Integer;
  Equal: Boolean;
  T: TfrView;
begin
  Equal := False;
  T := nil;
  I := 0;
  if Rep <> nil then
    while (I <= Rep.Pages.Count - 1) and (not Equal) do
      begin
        J := 0;
        while (J <= Rep.Pages.Pages[I].Objects.Count - 1) and (not Equal) do
          begin
            T := Rep.Pages.Pages[I].Objects[J];
            if (T <> Obj) and (UpperCase(UTF8ToString(T.Name)) = UpperCase(UTF8ToString(NewName))) then
              Equal := True
            else
              Inc(J)
          end;
        if not Equal then
          Inc(I)
      end;
  if Equal then
    Result := T
  else
    Result := nil
end;

function FileDateTime(F: string): TDateTime;
var
  FileHandle: integer;
  Info: TByHandleFileInformation;
  ST: TSystemTime;
  FT: TFileTime;

begin
  FileHandle := FileOpen(F, fmOpenRead);
  GetFileInformationByHandle(FileHandle, Info);
  FileClose(FileHandle);
  FileTimeToLocalFileTime(Info.ftLastWriteTime, FT);
  FileTimeToSystemTime(FT, ST);
  Result := (EncodeDate(ST.wYear, ST.wMonth, ST.wDay) +
    EncodeTime(ST.wHour, ST.wMinute, ST.wSecond, ST.wMilliseconds));
end;

function Real_Record_Count(Ds: TDataSet): integer;
begin
  Result := Ds.RecordCount;
end;

{----------------------------------------------------------------------------}

constructor TfrDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RangeBegin := rbFirst;
  RangeEnd := reLast;
  if Owner = nil then
     Name := 'N' + IntToStr(Integer(Self));
end;

destructor TfrDataSet.Destroy;
var
  I: Integer;
begin
  if (CurReport <> nil) and (CurReport.DataSetList.Count > 0) then
    begin
      I := 0;
      while (I <= CurReport.DataSetList.Count - 1) and
        (CurReport.DataSetList.Objects[I] <> Self) do
        Inc(I);
      if (I <= CurReport.DataSetList.Count - 1) then
        CurReport.DataSetList.Delete(I);
    end;
  inherited;
end;

procedure TfrDataSet.Init;
begin
end;

procedure TfrDataSet.Exit;
begin
end;

procedure TfrDataSet.First;
begin
  FRecNo := 0;
  FRealRecNo := 0;
  if Assigned(FOnFirst) then FOnFirst(Self);
end;

procedure TfrDataSet.Next;
begin
  Inc(FRecNo);
  Inc(FRealRecNo);
  if Assigned(FOnNext) then FOnNext(Self);
end;

{ 08/03/2001 - Zanella
  Gestione PRIOR }
procedure TfrDataSet.Prior;
begin
  Dec(FRecNo);
  if Assigned(FOnPrior) then FOnPrior(Self);
end;
{ 08/03/2001 - Fine }

function TfrDataSet.EOF: Boolean;
begin
  Result := False;
  if (FRangeEnd = reCount) and (FRecNo >= FRangeEndCount) then Result := True;
  if Assigned(FOnCheckEOF) then FOnCheckEOF(Self, Result);
end;
//-----------------------------------------------------------------------------
//New version of intern DataSet (DB or Virtual).
constructor TfrDBDataSet.Create(AOwner: TComponent);
begin
  inherited;
  OKInit := False;
  FDisableDataSetControls := True;
  FGetDataSetError := '';
  FFilter := '';
  FFiltered := False;
end;

procedure TfrDBDataSet.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataSet) then FDataSet := nil;
end;

procedure TfrDBDataSet.Init;
begin
  if DataSet <> nil then
    begin
      OldActive := DataSet.Active;
      if not OldActive then
        begin
          try
            DataSet.Open;
          except
            on E: Exception do
              FGetDataSetError := FRConst_ErrorOpenDataSet + ' ' +
                DataSet.Name + #13#10 + E.Message;
          end;
        end;
      if FGetDataSetError = '' then
        begin
          {$IFNDEF Delphi2}
          FBookmark := DataSet.RecNo;
          {$ELSE}
          FBookmark := DataSet.GetBookmark;
          {$ENDIF}
          OldDisable := DataSet.ControlsDisabled;
          if FDisableDataSetControls then
            if not OldDisable then DataSet.DisableControls;
          CheckFilter(True);
        end;
    end;
  FEof := False;
  OKInit := True;
end;

procedure TfrDBDataSet.Exit;
begin
  OKInit := False;
  if DataSet <> nil then
    begin
      if FDisableDataSetControls then
        if not OldDisable then DataSet.EnableControls;
      if not OldActive then
        DataSet.Active := OldActive
      else
        {$IFNDEF Delphi2}
      try
        If FBookMark<>0 Then //Itta   (Condizione)
           DataSet.RecNo:=FBookmark;
      except
      end;
      {$ELSE}
        DataSet.GotoBookmark(FBookmark);
      DataSet.FreeBookmark(FBookmark);
      FBookmark := nil;
      {$ENDIF}
    end;
end;

function TfrDBDataSet.GetDataSet: TDataSet;
begin
  if FDataSet <> nil then
    if FDataSet.Active then
      begin
        Result := FDataSet;
        FGetDataSetError := '';
      end
    else
      begin
        if OKInit then
          FGetDataSetError := FRConst_DataSetClose + ': ' + FDataSet.Name;
        Result := FDataSet;
      end
  else
    begin
      FGetDataSetError := FRConst_DataSetError + ': ' + Name;
      Result := nil;
    end
end;

procedure TfrDBDataSet.CheckFilter(GoNext: Boolean);
begin
  if FFiltered then
  try
    case GoNext of
      True: while (not DataSet.EOF) and (Calc(FFilter) = 0) do
          begin
            DataSet.Next;
            Inc(FRealRecNo);
          end;
      False: while (not DataSet.BOF) and (Calc(FFilter) = 0) do
          DataSet.Prior;
    end;
  except
    raise Exception.Create(FRConst_FilterError);
  end;
end;

procedure TfrDBDataSet.First;
begin
  if FRangeBegin = rbFirst then
    begin
      if DataSet <> nil then
        DataSet.First
    end
  else
    if FRangeBegin = rbCurrent then
    Begin
        if DataSet<>nil then
        begin
          if DataSet.EOF  then 
             Try DataSet.Refresh; Except End;//Se Memory DataSet genera errore !
          {$IFNDEF Delphi2}
          try
            DataSet.RecNo := FBookmark;
          except
          end;
          {$ELSE}
          DataSet.GotoBookmark(FBookmark);
          {$ENDIF}
        End;
     End;   
  CheckFilter(True);
  FEof := False;
  inherited First;
end;

procedure TfrDBDataSet.Next;
{$IFDEF Delphi2}
var
  b: TBookmark;
  n: Integer;
  {$ENDIF}
begin
  FEof := False;
  if FRangeEnd = reCurrent then
    begin
      if DataSet <> nil then
        {$IFNDEF Delphi2}
        if DataSet.RecNo = FBookmark then FEof := True;
      {$ELSE}
        b := DataSet.GetBookmark;
      dbiCompareBookmarks(DataSet.Handle, b, FBookmark, n);
      if n = 0 then FEof := True;
      DataSet.FreeBookmark(b);
      {$ENDIF}
      Exit;
    end;
  if DataSet <> nil then DataSet.Next;
  CheckFilter(True);
  inherited Next;
end;

{ 08/03/2001 - Zanella
  Gestione PRIOR }
procedure TfrDBDataSet.Prior;
{$IFDEF Delphi2}
var
  b: TBookmark;
  n: Integer;
  {$ENDIF}
begin
  FEof := False;
  if FRangeEnd = reCurrent then
    begin
      if DataSet <> nil then
        {$IFNDEF Delphi2}
        if DataSet.RecNo = FBookmark then FEof := True;
      {$ELSE}
        b := DataSet.GetBookmark;
      dbiCompareBookmarks(DataSet.Handle, b, FBookmark, n);
      if n = 0 then FEof := True;
      DataSet.FreeBookmark(b);
      {$ENDIF}
      Exit;
    end;
  if DataSet <> nil then DataSet.Prior;
  CheckFilter(False);
  inherited Prior;
end;
{ 08/03/2001 - Fine }

function TfrDBDataSet.EOF: Boolean;
begin
  if DataSet <> nil then
    Result := inherited EOF or DataSet.EOF or FEof
  else
    Result := inherited EOF or FEof
end;
{----------------------------------------------------------------------------}

constructor TfrView.Create(Rep: TfrReport);
var
  X: Integer;
  Nm: string;
begin
  inherited Create;
  FReport := Rep;
  Parent := nil;
  Memo := TStringList.Create;
  Memo1 := TStringList.Create;
  FrameColor := clBlack;
  Color := clNone;
  Format := 2 * 256 + Ord(FormatSettings.DecimalSeparator);
  OldDY := -1;
  Visible := True;
  FrameWidth := 1;
  FrameTyp := 0;
  X := 0;
  repeat
    Inc(X);
    Nm := Copy(ClassName, 4, Length(ClassName) - 7) + IntToStr(X)
   until CanAssignName(Rep, RawByteString(Nm), Self) = nil;
  //until CanAssignName(Rep, Nm, Self) = nil;
  FName := RawByteString(Nm);
end;

procedure TfrView.SetName(Value: ShortString);
const
  Character: set of AnsiChar = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'L',
  'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'Z', 'X', 'Y', 'J', 'W', 'K',
    '_', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
var
  OK: Boolean;
  I: Integer;
begin
  if Value <> '' then
    begin
      if (Value[1] = '_') or ((UpCase(Value[1]) >= 'A') and
        (UpCase(Value[1]) <= 'Z')) then
        begin
          OK := True;
          I := 2;
          while (I <= Length(Value)) and (OK) do
            if not (UpCase(Value[I]) in Character) then
              OK := False
            else
              Inc(I);
        end
      else
        OK := False
    end
  else
    OK := False;
  if OK then
    begin
      if CanAssignName(FReport, Value, Self) = nil then
        FName := Value
      else
        Application.MessageBox(FRConst_AssignNameError,
          FRConst_Error, MB_OK + mb_IconError)
    end
  else
    Application.MessageBox(FRConst_NameError, FRConst_Error, MB_OK +
      mb_IconError)
end;

procedure TfrView.SetCaption(Value: string);
begin
  Memo.Text := Value;
end;

procedure TfrView.DefinePopupMenu(Popup: TPopupMenu);
begin
  // Abstract method
end;

function TfrView.GetCaption: string;
begin
  Result := Memo.Text;
end;

function TfrView.GetFrameTop: Boolean;
begin
  Result := (FrameTyp and 8) <> 0;
end;

procedure TfrView.SetFrameTop(Value: Boolean);
begin
  FrameTyp := (FrameTyp and not 8) or Word(Value) * 8;
end;

function TfrView.GetFrameBottom: Boolean;
begin
  Result := (FrameTyp and 2) <> 0;
end;

procedure TfrView.SetFrameBottom(Value: Boolean);
begin
  FrameTyp := (FrameTyp and not 2) or Word(Value) * 2;
end;

function TfrView.GetFrameLeft: Boolean;
begin
  Result := (FrameTyp and 4) <> 0;
end;

procedure TfrView.SetFrameLeft(Value: Boolean);
begin
  FrameTyp := (FrameTyp and not 4) or Word(Value) * 4;
end;

function TfrView.GetFrameRight: Boolean;
begin
  Result := (FrameTyp and 1) <> 0;
end;

procedure TfrView.SetFrameRight(Value: Boolean);
begin
  FrameTyp := (FrameTyp and not 1) or Word(Value) * 1;
end;

procedure TfrView.Assign(From: TfrView);
begin
  Typ := From.Typ;
  Selected := From.Selected;
  Left := From.Left;
  Top := From.Top;
  Width := From.Width;
  Height := From.Height;
  Flags := From.Flags;
  FrameTyp := From.FrameTyp;
  FrameWidth := From.FrameWidth;
  FrameColor := From.FrameColor;
  FrameStyle := From.FrameStyle;
  Color := From.Color;
  Format := From.Format;
  FormatStr := From.FormatStr;
  Memo.Assign(From.Memo);
  Visible := From.Visible;
  if CanAssignName(FReport, From.Name, Self) = nil then FName := From.Name;
end;

destructor TfrView.Destroy;
var
  J: Integer;
begin
  // Delete DataSet link to TfrBand.
  if CurReport <> nil then
    if (Typ = gtBand) and (TfrBandType(FrameTyp) in
      [btMasterData, btDetailData, btSubDetailData, btColumnData]) then
      if CurReport.DataSetList.Find(FormatStr, J) then
        if TfrDataSet(CurReport.DataSetList.Objects[J]).Owner = nil then
          TfrDataSet(CurReport.DataSetList.Objects[J]).Free
        else
          CurReport.DataSetList.Delete(J);
  // Free TfrView resources.
  Memo.Free;
  Memo1.Free;
  inherited Destroy;
end;

function TfrView.GetLinkToDataSet: Boolean;
begin
  Result := False;
end;

procedure TfrView.CalcGaps;
var
  bx, by, bx1, by1, wx1, wx2: Integer;
begin
  wx1 := (FrameWidth - 1) div 2;
  wx2 := FrameWidth div 2;
  gapx := wx2 + 2;
  gapy := wx2 div 2 + 1;
  bx := Left;
  by := Top;
  bx1 := Left + Width;
  by1 := Top + Height;
  if (FrameTyp and $1) <> 0 then Dec(bx1, wx2);
  if (FrameTyp and $2) <> 0 then Dec(by1, wx2);
  if (FrameTyp and $4) <> 0 then Inc(bx, wx1);
  if (FrameTyp and $8) <> 0 then Inc(by, wx1);
  DRect := Rect(bx, by, bx1 + 1, by1 + 1);
end;

procedure TfrView.ShowBackground;
Var
  fp : TColor;
begin
  if DisableDrawing then Exit;
  //if (DocMode = dmPrinting) and (Color = clNone) then Exit;
  fp := Color;
  if (DocMode = dmPrinting) and (Color = clNone) then
     fp := clWhite;
  if (DocMode = dmDesigning) and (fp = clNone) then
     fp := clWhite;
  Canvas.Brush.Color := fp;
  if DocMode = dmDesigning then
    Canvas.FillRect(DRect)
  else
    Canvas.FillRect(Rect(Left, Top, Left + Width, Top + Height));
end;

procedure TfrView.ShowFrame;
  procedure Line(x, y, dx, dy: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + dx, y + dy);
  end;
begin
  if DisableDrawing then Exit;
  if (DocMode = dmPrinting) and ((FrameTyp and $F) = 0) then Exit;
  with Canvas do
    begin
      if Pen.Width <> FrameWidth then Pen.Width := FrameWidth;
      if Pen.Color <> FrameColor then Pen.Color := FrameColor;
      if Pen.Style <> psSolid then Pen.Style := psSolid;
      if Brush.Style <> bsClear then Brush.Style := bsClear;
      if ((FrameTyp and $F) = 0) and (DocMode = dmDesigning) then
        begin
          if Pen.Color <> clBlack then Pen.Color := clBlack;
          if Pen.Width <> 1 then Pen.Width := 1;
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
        if (FrameTyp and $F) = $F then
          Rectangle(Left, Top, Left + Width + 1, Top + Height + 1)
        else
          begin
            if (FrameTyp and $1) <> 0 then Line(Left + Width, Top, 0, Height);
            if (FrameTyp and $4) <> 0 then Line(Left, Top, 0, Height);
            if (FrameTyp and $2) <> 0 then Line(Left, Top + Height, Width, 0);
            if (FrameTyp and $8) <> 0 then Line(Left, Top, Width, 0);
          end;
    end;
end;

procedure TfrView.BeginDraw(ACanvas: TCanvas);
begin
  Canvas := ACanvas;
  CurView := Self;
end;

procedure TfrView.LoadFromStream(Stream: TStream);       //Itta
const
  FrToQr = 1123 / 1088;
var
  A: Byte;
begin
   with Stream do
   begin
      Read(Left, 4); Read(Top, 4); Read(Width, 4); Read(Height, 4);
      Read(Flags, 2);
      Read(FrameTyp, 2);
      Read(FrameWidth, 4);
      Read(FrameColor, 4);
      Read(FrameStyle, 2);
      Read(Color, 4);
      Read(Format, 4);
      FormatStr:='';
      frReadMemo(Stream, SMemo);
      if SMemo.Count > 0 then
        FormatStr := SMemo[0];
      frReadMemo(Stream, Memo);
      if frVersion > 22 then
      begin
         Read(Visible, 1);
         Read(A, 1);
         Read(FName[1], A);
         FName[0] := AnsiChar(A); //Chr(A);
      end;
      if frVersion < 24 then
      begin
         // Convert old coordinate type into the new
         // (quickreport compatible)
         Left := Round(Left * FrToQr);
         Top := Round(Top * FrToQr);
         Width := Round(Width * FrToQr);
         Height := Round(Height * FrToQr);
      end;

      If FormatStr='' Then 
         FormatStr:= String(FName);
   end;
end;

procedure TfrView.SaveToStream(Stream: TStream);
begin
   with Stream do
   begin
      Write(Left, 4); Write(Top, 4); Write(Width, 4); Write(Height, 4);
      Write(Flags, 2);
      Write(FrameTyp, 2);
      Write(FrameWidth, 4);
      Write(FrameColor, 4);
      Write(FrameStyle, 2);
      Write(Color, 4);
      Write(Format, 4);
      SMemo.Text:=FormatStr;
      frWriteMemo(Stream, SMemo);
      frWriteMemo(Stream, Memo);
      Write(Visible, 1);
      Write(FName[0], Length(FName) + 1)
   end;
end;

procedure TfrView.Resized;
begin
end;

procedure TfrView.GetBlob(b: TField);
begin
end;

function TfrView.GetClipRgn(rt: TfrRgnType): HRGN;
var
  bx, by, bx1, by1, w1, w2: Integer;
begin
  w1 := FrameWidth shr 1;
  w2 := (FrameWidth - 1) shr 1;
  bx := Left;
  by := Top;
  bx1 := Left + Width + 1;
  by1 := Top + Height + 1;
  if (FrameTyp and $1) <> 0 then Inc(bx1, w2);
  if (FrameTyp and $2) <> 0 then Inc(by1, w2);
  if (FrameTyp and $4) <> 0 then Dec(bx, w1);
  if (FrameTyp and $8) <> 0 then Dec(by, w1);
  if rt = rtNormal then
    Result := CreateRectRgn(bx, by, bx1, by1)
  else
    Result := CreateRectRgn(bx - 10, by - 10, bx1 + 10, by1 + 10);
end;

procedure TfrView.SetAllFrames;
begin
  DrawFrameTop := True;
  DrawFrameBottom := True;
  DrawFrameLeft := True;
  DrawFrameRight := True;
end;

procedure TfrView.ResetAllFrames;
begin
  DrawFrameTop := False;
  DrawFrameBottom := False;
  DrawFrameLeft := False;
  DrawFrameRight := False;
end;

{----------------------------------------------------------------------------}
procedure TfrCustomMemoView.DefinePopupMenu(Popup: TPopupMenu);
var
  m: TMenuItem;
begin
  m := TMenuItem.Create(Popup);
  m.Caption := '-';
  Popup.Items.Add(m);

  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_Stretched;
  m.OnClick := PStretchClick;
  m.Checked := (Flags and flStretched) <> 0;
  Popup.Items.Add(m);
end;

procedure TfrCustomMemoView.PStretchClick(Sender: TObject);
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
            t.Flags := (t.Flags and not flStretched) + Word(Checked);
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

function TfrCustomMemoView.TheTextHeight: Integer;
begin
  Result := TextHeight;
  // To fill. Return the height of the current text line.
end;

function TfrCustomMemoView.GetAutoStretch: Boolean;
begin
  Result := (Flags and flStretched) > 0;
end;

procedure TfrCustomMemoView.SetAutoStretch(Value: Boolean);
begin
  Flags := (Flags and not flStretched) or Word(Value) * flStretched;
end;
{----------------------------------------------------------------------------}
constructor TfrMemoView.Create(Rep: TfrReport);
begin
  inherited;
  Typ := gtMemo;
  Font := TFont.Create;
  Font.Color := clBlack;
  Font.Name := 'Arial';
  Font.Size := 10;
  Font.Style := [];
  Highlight.FontColor := clBlack;
  Highlight.FillColor := clWhite;
  Highlight.FontStyle := [fsBold]; // fsBold
  TextHeight := -Font.Height + 2;
end;

destructor TfrMemoView.Destroy;
begin
  inherited;
  Font.Free;
end;

procedure TfrMemoView.Assign(From: TfrView);
begin
  inherited Assign(From);
  Font.Name := (From as TfrMemoView).Font.Name;
  Font.Size := (From as TfrMemoView).Font.Size;
  Font.Style := (From as TfrMemoView).Font.Style;
  Font.Color := (From as TfrMemoView).Font.Color;
  Adjust := (From as TfrMemoView).Adjust;
  Highlight := (From as TfrMemoView).Highlight;
  HighlightStr := (From as TfrMemoView).HighlightStr;
  UseHighlight := (From as TfrMemoView).UseHighlight;
end;

procedure TfrMemoView.ExpandVariables;
var
  i: Integer;
  s: string;
  procedure GetData(var s: string);
  var
    i, j: Integer;
    s1, s2: string;
  begin
    i := 1;
    repeat
      while (i < Length(s)) and (s[i] <> '[') do
        Inc(i);
      s1 := GetBrackedVariable(s, i, j);
      if i <> j then
        begin
          Delete(s, i, j - i + 1);
          s2 := '';
          CurReport.InternalOnGetValue(s1, s2);
          Insert(s2, s, i);
          Inc(i, Length(s2));
          j := 0;
        end;
    until i = j;
  end;
begin
  Memo1.Clear;
  for i := 0 to Memo.Count - 1 do
    begin
      s := Memo[i];
      if DocMode <> dmDesigning then GetData(s);
      Memo1.Add(s);
    end;
end;

procedure TfrMemoView.AssignFont;
var
  D: Double;
begin
  if Canvas.Brush.Style <> bsClear then Canvas.Brush.Style := bsClear;
  Canvas.Font := Font;
  if (FReport.Scaled) and (FReport.PixelsPerInch <> CurrentPixelsPerInch) then
    begin
      D := FReport.PixelsPerInch / CurrentPixelsPerInch;
      Canvas.Font.Height := Round(Canvas.Font.Height * D);
    end;
end;

procedure TfrMemoView.WrapMemo;
Const
  CharSep: set of AnsiChar = [' ', '.', ',', '-'];

var
  size, size1, maxwidth: Integer;
  procedure OutLine(const str: string);
  begin
    SMemo.Add(Str);
    Inc(size, size1);
  end;

  procedure WrapLine(const s: string);
  var
    cur, beg, last: Integer;
  begin
    last := 1;
    beg := 1;
    if (Length(s) <= 1) or (Canvas.TextWidth(s) <= maxwidth) then
      OutLine(s)
    else
      begin
        for cur := 1 to Length(s) do
          begin
            if Canvas.TextWidth(Copy(s, beg, cur - beg + 1)) >= maxwidth then
              begin
                if last = beg then last := cur;
                OutLine(Copy(s, beg, last - beg + 1));
                if last = cur then
                  begin
                    beg := cur;
                    break;
                  end;
                beg := last + 1;
                last := beg;
              end;
            if CharInSet(s[cur],CharSep) then last := cur;
            //if s[cur] in [' ', '.', ',', '-'] then last := cur;
          end;
        if beg <> cur then OutLine(Copy(s, beg, cur - beg + 1));
      end;
  end;
  procedure OutMemo;
  var
    i: Integer;
  begin
    size := Top + gapy;
    size1 := -Canvas.Font.Height + 2;
    maxwidth := Width - gapx - gapx;
    for i := 0 to Memo1.Count - 1 do
      if (Flags and flWordWrap) <> 0 then
        WrapLine(Memo1[i])
      else
        OutLine(Memo1[i]);
    VHeight := size - (Top + gapy) + gapy + gapy;
    if (DocMode = dmPrinting) and (AutoStretch) and
      (Parent <> nil) and (Parent.Stretched) then
      begin
        if Height <> VHeight then Height := VHeight;
      end;
    TextHeight := size1;
  end;
  procedure OutMemo90;
  var
    i: Integer;
    h, oldh: HFont;
  begin
    h := Create90Font(Canvas.Font);
    oldh := SelectObject(Canvas.Handle, h);
    size := Left + gapx;
    size1 := -Canvas.Font.Height + 2;
    maxwidth := Height - gapy - gapy;
    for i := 0 to Memo1.Count - 1 do
      if (Flags and flWordWrap) <> 0 then
        WrapLine(Memo1[i])
      else
        OutLine(Memo1[i]);
    SelectObject(Canvas.Handle, oldh);
    DeleteObject(h);
    VHeight := size - (Left + gapx) + gapx + gapx;
    if (DocMode = dmPrinting) and (AutoStretch) then Width := VHeight;
  end;
begin
  AssignFont;
  if ReturnPresent then CheckReturn;
  if (Flags and flAutoSize <> 0) and (DocMode = dmPrinting) then CalcAutoSize;
  SMemo.Clear;
  if (Adjust and $4) <> 0 then
    OutMemo90
  else
    OutMemo;
  Memo1.Assign(SMemo);
end;

procedure TfrMemoView.CheckReturn;
var
  I, K: Integer;
  S: string;
begin
  I := 0;
  while I <= Memo1.Count - 1 do
    repeat
      S := Memo1[I];
      K := Pos(#13#10, S);
      if K > 0 then
        begin
          Memo1[I] := Copy(S, 1, K - 1);
          Memo1.Insert(I + 1, Copy(S, K + 2, Length(S) - K));
        end;
      Inc(I);
    until K = 0;
end;

procedure TfrMemoView.CalcAutoSize;
var
  I, Max, W: Integer;
begin
  Max := 0;
  for I := 0 to Memo1.Count - 1 do
    begin
      W := Canvas.TextWidth(Memo1[I]);
      if W > Max then Max := W;
    end;
  Width := Max + GapX * 2;
  CalcGaps;
  //  ShowBackground;
end;

procedure TfrMemoView.ShowMemo;
var
  DR: TRect;
  ad, ox, oy: Integer;

  procedure OutMemo;
  var
    i, cury, th: Integer;

    function OutLine(const str: string): Boolean;
    var
      curx, X: Integer;
      S1, S2: string;
      Space, CurXX: Double;

    begin
      if cury + th <= DR.bottom then
        begin
          if Adjust = 0 then
            curx := Left + gapx
          else
            if Adjust = 1 then
              curx := Left + Width - 1 - gapx - Canvas.TextWidth(str)
            else
              if Adjust = 2 then
                curx := Left + gapx + (Width - gapx - gapx -
                  Canvas.TextWidth(str)) div 2
              else
                curx := Left + gapx;
          S1 := Copy(str, 1, Pos(' ', str) - 1);
          if (Adjust = 3) and (S1 <> '') then
            begin
              CurXX := curx;
              S2 := TrimRight(str);
              Space := 0;
              for X := 1 to Length(S2) do
                if S2[X] = ' ' then Space := Space + 1;
              if Space > 0 then
                Space := (Abs(Dr.Left - Dr.Right + 1 + gapx) -
                  Canvas.TextWidth(S2) +
                  Space * Canvas.TextWidth(' ')) / Space;
              repeat
                ExtTextOut(Canvas.Handle, Round(CurXX), cury, ETO_CLIPPED, @DR,
                  PChar(S1), Length(S1), nil);
                CurXX := CurXX + Canvas.TextWidth(S1) + Space;
                S2 := Copy(S2, Length(S1) + 2, Length(S2));
                if Pos(' ', S2) > 0 then
                  S1 := Copy(S2, 1, Pos(' ', S2) - 1)
                else
                  S1 := S2;
              until S2 = '';
            end
          else
            if ((Flags and flWordWrap) <> 0) or
              (curx < DR.Left) or (curx + Canvas.TextWidth(str) > DR.Right) or
              (cury < DR.Top) or (cury + th > DR.Bottom) then
              ExtTextOut(Canvas.Handle, curx, cury, ETO_CLIPPED, @DR,
                PChar(str), Length(str), nil)
            else
              TextOut(Canvas.Handle, curx, cury, PChar(str), Length(str));
          Result := False;
        end
      else
        Result := True;
      cury := cury + th;
    end; // OutLine

  begin
    // OutMemo
    cury := Top + gapy;
    th := -Canvas.Font.Height + 2;
    CurStrNo := 0;
    for i := FromLine to Memo1.Count - 1 do
      if OutLine(Memo1[i]) then
        begin
          FromLine := i;
          break;
        end;
  end;

  procedure OutMemo90;
  var
    i, th, curx: Integer;
    h, oldh: HFont;
    procedure OutLine(const str: string);
    var
      cury, X: Integer;
      S1, S2: string;
      Space, CurYY: Double;

    begin
      if Adjust = 4 then
        cury := Top + Height - gapy
      else
        if Adjust = 5 then
          cury := Top + gapy + Canvas.TextWidth(str)
        else
          if Adjust = 6 then
            cury := Top + Height - 1 - gapy - (Height - gapy - gapy -
              Canvas.TextWidth(str)) div 2
          else
            cury := Top + Height - gapy;
      S1 := Copy(str, 1, Pos(' ', str) - 1);
      if (Adjust = 7) and (S1 <> '') then
        begin
          CurYY := cury;
          S2 := TrimRight(str);
          Space := 0;
          for X := 1 to Length(S2) do
            if S2[X] = ' ' then Space := Space + 1;
          if Space > 0 then
            Space := (Abs(Dr.Top - Dr.Bottom + 1 + gapy) - Canvas.TextWidth(S2)
              +
              Space * Canvas.TextWidth(' ')) / Space;
          repeat
            ExtTextOut(Canvas.Handle, Curx, Round(curYY), ETO_CLIPPED, @DR,
              PChar(S1), Length(S1), nil);
            CurYY := CurYY - (Canvas.TextWidth(S1) + Space);
            S2 := Copy(S2, Length(S1) + 2, Length(S2));
            if Pos(' ', S2) > 0 then
              S1 := Copy(S2, 1, Pos(' ', S2) - 1)
            else
              S1 := S2;
          until S2 = '';
        end
      else
        if ((Flags and flWordWrap) <> 0) or
          (cury > DR.Bottom) or (cury - Canvas.TextWidth(str) < DR.Top) or
          (curx < DR.Left) or (curx + th > DR.Right) then
          ExtTextOut(Canvas.Handle, curx, cury, ETO_CLIPPED, @DR,
            PChar(str), Length(str), nil)
        else
          TextOut(Canvas.Handle, curx, cury, PChar(str), Length(str));
      curx := curx + th;
    end;

  begin
    // OutMemo90
    h := Create90Font(Canvas.Font);
    oldh := SelectObject(Canvas.Handle, h);
    curx := Left + gapx;
    th := -Canvas.Font.Height + 2;
    CurStrNo := 0;
    for i := 0 to Memo1.Count - 1 do
      OutLine(Memo1[i]);
    SelectObject(Canvas.Handle, oldh);
    DeleteObject(h);
  end;

begin
  //ShowMemo
  if (Docmode <> dmDesigning) and AutoStretch then VHeight := MemoVHeight;
  AssignFont;
  DR := Rect(DRect.Left + 1, DRect.Top, DRect.Right - 2, DRect.Bottom - 1);
  if (Adjust and $18) <> 0 then
    begin
      ad := Adjust;
      ox := Left;
      oy := Top;
      Adjust := Adjust and $7;
      if (ad and $4) <> 0 then
        begin
          if (ad and $18) = $8 then
            Left := Left + (Width - VHeight) div 2
          else
            if (ad and $18) = $10 then
              Left := Left + Width - VHeight;
          OutMemo90;
        end
      else
        begin
          if (ad and $18) = $8 then
            Top := Top + (Height - VHeight) div 2
          else
            if (ad and $18) = $10 then
              Top := Top + Height - VHeight;
          OutMemo;
        end;
      Adjust := ad;
      Left := ox;
      Top := oy;
    end
  else
    if (Adjust and $4) <> 0 then
      OutMemo90
    else
      OutMemo;
end;

procedure TfrMemoView.Draw(Canvas: TCanvas);
var
  s: string;
  CanExpandVar: Boolean;
  OldFontStyle: TFontStyles;
  OldFontColor, OldFillColor: TColor;
  OldFlags: Word;
begin
  VHeight := 0;
  if (DocMode = dmPrinting) and (not Visible) then Exit;
  BeginDraw(Canvas);
  OldFlags := Flags;
  CanExpandVar := True;
  if (DrawMode <> drPart) or (DocMode = dmDesigning) then FromLine := 0;
  if DrawMode in [drAll, drCalcHeight] then
    FUseHlt := UseHighlight;
  if DocMode = dmPrinting then
    begin
      if DrawMode in [drAll, drCalcHeight] then
        begin
          if CurReport.HasBlobs then
            begin
              s := '';
              Memo1.Assign(Memo);
              if Memo1.Count > 0 then s := Memo1[0];
              CurReport.InternalOnEnterRect(Memo1, Self);
              if (Memo1.Count > 0) and (s <> Memo1[0]) then
                CanExpandVar := False;
            end;
        end
      else
        if DrawMode in [drAfterCalcHeight, drPart] then
          CanExpandVar := False;
    end;
  if CanExpandVar then ExpandVariables;
  OldFontStyle := [];
  OldFontColor := 0;
  OldFillColor := 0;
  if (DocMode = dmPrinting) and
    (DrawMode in [drAll, drAfterCalcHeight, drPart]) then
    if UseHighlight then
    try
      if Calc(HighlightStr) = 1 then
        begin
          OldFontStyle := Font.Style;
          Font.Style := Highlight.FontStyle;
          OldFontColor := Font.Color;
          Font.Color := Highlight.FontColor;
          OldFillColor := Color;
          Color := Highlight.FillColor;
        end
      else
        UseHighlight := False
    except
      DoError(FRConst_ExprHighlightError);
    end
    else
      UseHighlight := False;
  CalcGaps;
  with Canvas do
    begin
      if Memo1.Count <> 0 then
        begin
          if DrawMode in [drAll, drCalcHeight] then WrapMemo;
          if DrawMode <> drCalcHeight then
            begin
              ShowBackground;
              ShowFrame;
            end;
          if (DrawMode <> drCalcHeight) and not DisableDrawing then ShowMemo;
        end
      else
        if DrawMode <> drCalcHeight then
          begin
            if (Memo.Count = 0) and (AutoStretch) and
              (OldDy = Height) and (Parent.Stretched) then
              begin
                Height := Round(Height * (Parent.MaxDy / Parent.DY));
                ShowBackground;
                ShowFrame;
                Height := OldDy;
              end
            else
              begin
                ShowBackground;
                ShowFrame;
              end;
          end
    end;
  if (DrawMode = drCalcHeight) and (AutoStretch) then
    if Top + VHeight + 2 > SHeight then SHeight := Top + VHeight + 2;
  if (DrawMode in [drAll, drAfterCalcHeight, drPart]) and (DocMode = dmPrinting) then
    begin
      if UseHighlight then
        begin
          Font.Style := OldFontStyle;
          Font.Color := OldFontColor;
          Color := OldFillColor;
        end;
      UseHighlight := FUseHlt;
    end;
  Flags := OldFlags;
  if not Visible then
    begin
      Canvas.Pen.Color := ClRed;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(Left, Top);
      Canvas.LineTo(Left + Width, Top + Height);
      Canvas.MoveTo(Left + Width, Top);
      Canvas.LineTo(Left, Top + Height);
    end;
  if (DrawMode = drCalcHeight) then MemoVHeight := VHeight;
end;

procedure TfrMemoView.LoadFromStream(Stream: TStream);
var
  I: Integer;
  W: Word;
  C: TColor;
  X: packed record
    FontStyle: Word;
    FontColor, FillColor: TColor;
  end;
begin
  inherited LoadFromStream(Stream);
  frReadMemo(Stream, SMemo);
  Font.Name := SMemo[0];
  with Stream do
    begin
      Read(I, 4);
      Font.Size := I;
      Read(W, 2);
      Font.Style := [];
      if W and 1 <> 0 then Font.Style := Font.Style + [fsItalic];
      if W and 2 <> 0 then Font.Style := Font.Style + [fsBold];
      if W and 4 <> 0 then Font.Style := Font.Style + [fsUnderline];
      Read(C, 4);
      Font.Color := C;
      Read(Adjust, 4);
      Read(X, 10);
      Highlight.FontStyle := [];
      if X.FontStyle and 1 <> 0 then
        Highlight.FontStyle := Highlight.FontStyle + [fsItalic];
      if X.FontStyle and 2 <> 0 then
        Highlight.FontStyle := Highlight.FontStyle + [fsBold];
      if X.FontStyle and 4 <> 0 then
        Highlight.FontStyle := Highlight.FontStyle + [fsUnderline];
      Highlight.FontColor := X.FontColor;
      Highlight.FillColor := X.FillColor;
      Read(UseHighlight, 2);
      frReadMemo(Stream, SMemo);
      if SMemo.Count > 0 then
        HighlightStr := SMemo[0]
      else
        HighlightStr := '';
    end;
  if frVersion = 21 then
    Flags := Flags or flWordWrap;
end;

procedure TfrMemoView.SaveToStream(Stream: TStream);
var
  I: Integer;
  W: Word;
  C: TColor;
  X: packed record
    FontStyle: Word;
    FontColor, FillColor: TColor;
  end;
begin
  inherited SaveToStream(Stream);
  SMemo.Clear;
  SMemo.Add(Font.Name);
  frWriteMemo(Stream, SMemo);
  with Stream do
    begin
      I := Font.Size;
      Write(I, 4);
      W := 0;
      if fsItalic in Font.Style then W := W or 1;
      if fsBold in Font.Style then W := W or 2;
      if fsUnderline in Font.Style then W := W or 4;
      Write(W, 2);
      C := Font.Color;
      Write(C, 4);
      Write(Adjust, 4);
      W := 0;
      if fsItalic in Highlight.FontStyle then
        W := W or 1
      else
        if fsBold in Highlight.FontStyle then
          W := W or 2
        else
          if fsUnderline in Highlight.FontStyle then W := W or 4;
      X.FontStyle := W;
      X.FontColor := Highlight.FontColor;
      X.FillColor := Highlight.FillColor;
      Write(X, 10);
      Write(UseHighlight, 2);
      SMemo.Clear;
      SMemo.Add(HighlightStr);
      frWriteMemo(Stream, SMemo);
    end;
end;

procedure TfrMemoView.GetBlob(b: TField);
begin
  Memo1.Assign(b);
end;

procedure TfrMemoView.DefinePopupMenu(Popup: TPopupMenu);
var
  m: TMenuItem;
begin
  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_VarFormat;
  m.OnClick := P1Click;
  Popup.Items.Add(m);
  inherited DefinePopupMenu(Popup);

  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_WordWrap;
  m.OnClick := P2Click;
  m.Checked := (Flags and flWordWrap) <> 0;
  Popup.Items.Add(m);

  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_AutoSize;
  m.OnClick := P3Click;
  m.Checked := (Flags and flAutoSize) <> 0;
  Popup.Items.Add(m);
end;

procedure TfrMemoView.P1Click(Sender: TObject);
var
  t: TfrView;
  i: Integer;
begin
  FmtForm := TFmtForm.Create(nil);
  t := Self;
  with FmtForm do
    begin
      Format := t.Format;
      Edit1.Text := t.FormatStr;
      if ShowModal = mrOk then
        for i := 0 to frDesigner.Page.Objects.Count - 1 do
          begin
            t := frDesigner.Page.Objects[i];
            if t.Selected then
              begin
                (t as TfrMemoView).Format := Format;
                (t as TfrMemoView).FormatStr := Edit1.Text;
              end;
          end;
    end;
  FmtForm.Free;
  frDesigner.PopupNotify(Self);
end;

procedure TfrMemoView.P2Click(Sender: TObject);
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
            begin
              t.Flags := (t.Flags and not flWordWrap) + Word(Checked) *
                flWordWrap;
              t.Draw(Canvas)
            end
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrMemoView.P3Click(Sender: TObject);
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
            begin
              t.Flags := (t.Flags and not flAutoSize) + Word(Checked) *
                flAutoSize;
              t.Draw(Canvas)
            end
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

function TfrMemoView.GetAlignment: TFrAlignment;
begin
  case Adjust and 3 of
    0: Result := frLeftJustify;
    1: Result := frRightJustify;
    2: Result := FrCenter;
  else
    Result := frWidthJustify;
  end;
end;

procedure TfrMemoView.SetAlignment(Value: TFrAlignment);
begin
  case Value of
    frLeftJustify: Adjust := (Adjust and 252) or 0;
    frRightJustify: Adjust := (Adjust and 252) or 1;
    frCenter: Adjust := (Adjust and 252) or 2;
    frWidthJustify: Adjust := (Adjust and 252) or 3;
  end;
end;

function TfrMemoView.GetWordWrap: Boolean;
begin
  Result := (Flags and flWordWrap) > 0;
end;

procedure TfrMemoView.SetWordWrap(Value: Boolean);
begin
  Flags := (Flags and not flWordWrap) or Word(Value) * flWordWrap;
end;

function TfrMemoView.GetAutoSize: Boolean;
begin
  Result := (Flags and flAutoSize) > 0;
end;

procedure TfrMemoView.SetAutoSize(Value: Boolean);
begin
  Flags := (Flags and not flAutoSize) or Word(Value) * flAutoSize;
end;

function TfrMemoView.GetVertAlignment: TFrVerticalAlignment;
begin
  case Adjust and 24 of
    0: Result := tvaUp;
    8: Result := tvaCenter;
  else
    Result := tvaDown;
  end;
end;

procedure TfrMemoView.SetVertAlignment(Value: TFrVerticalAlignment);
begin
  case Value of
    tvaUp: Adjust := (Adjust and 231) or 0;
    tvaCenter: Adjust := (Adjust and 231) or 8;
    tvaDown: Adjust := (Adjust and 231) or 16;
  end;
end;

function TfrMemoView.GetRotate: Boolean;
begin
  Result := (Adjust and 4) > 0;
end;

procedure TfrMemoView.SetRotate(Value: Boolean);
begin
  if Value then
    Adjust := Adjust or 4
  else
    Adjust := Adjust and 251;
end;

{----------------------------------------------------------------------------}
function TfrBandView.GetLinkToDataSet: Boolean;
begin
  Result := BandType in
    [btMasterData, btDetailData, btSubDetailData, btColumnData];
end;

constructor TfrBandView.Create(Rep: TfrReport);
begin
  inherited;
  Typ := gtBand;
  Format := 0;
end;

destructor TfrBandView.Destroy;
var
  I: Integer;
  D: TfrDataSet;
begin
  if (LinkToDataSet) and (FormatStr <> '') and (CurReport <> nil) then
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

procedure TfrBandView.Draw(Canvas: TCanvas);
var
  h, oldh: HFont;
begin
  FrameWidth := 1;
  if TfrBandType(FrameTyp) in [btColumnHeader..btColumnFooter] then
    begin
      Top := 0;
      Height := frDesigner.Page.PrnInfo.Pgh;
    end
  else
    begin
      Left := 0;
      Width := frDesigner.Page.PrnInfo.Pgw;
    end;
  BeginDraw(Canvas);
  CalcGaps;
  with Canvas do
    begin
      Brush.Bitmap := SBmp;
      FillRect(DRect);
      Font.Name := 'Arial';
      Font.Style := [];
      Font.Size := 8;
      Font.Color := clBlack;
      Pen.Width := 1;
      Pen.Color := clBtnFace;
      Pen.Style := psSolid;
      Brush.Style := bsClear;
      Rectangle(Left, Top, Left + Width + 1, Top + Height + 1);
      Brush.Color := clBtnFace;
      if TfrBandType(FrameTyp) in [btColumnHeader..btColumnFooter] then
        begin
          FillRect(Rect(Left - 18, Top, Left, Top + 130));
          Pen.Color := clBtnShadow;
          MoveTo(Left - 18, Top + 128);
          LineTo(Left, Top + 128);
          Pen.Color := clBlack;
          MoveTo(Left - 18, Top + 129);
          LineTo(Left, Top + 129);
          Pen.Color := clBtnHighlight;
          MoveTo(Left - 18, Top + 129);
          LineTo(Left - 18, Top);
          h := Create90Font(Font);
          oldh := SelectObject(Handle, h);
          TextOut(Left - 15, Top + TextWidth(frBandNames[FrameTyp]) + 4,
            frBandNames[FrameTyp]);
          SelectObject(Handle, oldh);
          DeleteObject(h);
        end
      else
        begin
          FillRect(Rect(Left, Top - 18, Left + 130, Top));
          Pen.Color := clBtnShadow;
          MoveTo(Left + 128, Top - 18);
          LineTo(Left + 128, Top);
          Pen.Color := clBlack;
          MoveTo(Left + 129, Top - 18);
          LineTo(Left + 129, Top);
          TextOut(Left + 4, Top - 17, frBandNames[FrameTyp]);
        end;
    end;
end;

function TfrBandView.GetClipRgn(rt: TfrRgnType): HRGN;
var
  R: HRGN;
begin
  if rt = rtNormal then
    Result := CreateRectRgn(Left, Top, Left + Width + 1, Top + Height + 1)
  else
    Result := CreateRectRgn(Left - 10, Top - 10, Left + Width + 10, Top + Height
      + 10);
  if TfrBandType(FrameTyp) in [btColumnHeader..btColumnFooter] then
    R := CreateRectRgn(Left - 18, Top, Left, Top + 130)
  else
    R := CreateRectRgn(Left, Top - 18, Left + 130, Top);
  CombineRgn(Result, Result, R, RGN_OR);
  DeleteObject(R);
end;

procedure TfrBandView.DefinePopupMenu(Popup: TPopupMenu);
var
  m: TMenuItem;
  b: TfrBandType;
begin
  b := TfrBandType(FrameTyp);
  if b in frBandAutoStretch then
    begin
      m := TMenuItem.Create(Popup);
      m.Caption := '-';
      Popup.Items.Add(m);

      m := TMenuItem.Create(Popup);
      m.Caption := FRConst_Stretched;
      m.OnClick := PStretchClick;
      m.Checked := (Flags and flStretched) <> 0;
      Popup.Items.Add(m);
    end;

  if b in frBandForceNewPage then
    begin
      m := TMenuItem.Create(Popup);
      m.Caption := FRConst_FormNewPage;
      m.OnClick := P1Click;
      m.Checked := (Flags and flBandNewPageAfter) <> 0;
      Popup.Items.Add(m);
    end;

  if b in frBandPrintIfSubSetEmpty then
    begin
      m := TMenuItem.Create(Popup);
      m.Caption := FRConst_PrintIfSubsetEmpty;
      m.OnClick := P2Click;
      m.Checked := (Flags and flBandPrintIfSubsetEmpty) <> 0;
      Popup.Items.Add(m);
    end;

  if b in frBandPageBreak then
    begin
      m := TMenuItem.Create(Popup);
      m.Caption := FRConst_Breaked;
      m.OnClick := P3Click;
      m.Checked := (Flags and flBandPageBreak) <> 0;
      Popup.Items.Add(m);
    end;

  if b in frBandCompleteList then
    begin
      m := TMenuItem.Create(Popup);
      m.Caption := FRConst_CompleteList;
      m.OnClick := P4Click;
      m.Checked := (Flags and flBandCompleteList) <> 0;
      Popup.Items.Add(m);
    end;
end;

procedure TfrBandView.PStretchClick(Sender: TObject);
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
            t.Flags := (t.Flags and not flStretched) + Word(Checked);
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrBandView.P1Click(Sender: TObject);
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
            t.Flags := (t.Flags and not flBandNewPageAfter) +
              Word(Checked) * flBandNewPageAfter;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrBandView.P2Click(Sender: TObject);
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
            t.Flags := (t.Flags and not flBandPrintifSubsetEmpty) +
              Word(Checked) * flBandPrintifSubsetEmpty;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrBandView.P3Click(Sender: TObject);
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
            t.Flags := (t.Flags and not flBandPageBreak) + Word(Checked) *
              flBandPageBreak;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrBandView.P4Click(Sender: TObject);
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
            t.Flags := (t.Flags and not flBandCompleteList) +
              Word(Checked) * flBandCompleteList;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

function TfrBandView.GetCompleteList: Boolean;
begin
  if TfrBandType(FrameTyp) in frBandCompleteList then
    Result := (Flags and flBandCompleteList) > 0
  else
    Result := False;
end;

procedure TfrBandView.SetCompleteList(Value: Boolean);
begin
  if TfrBandType(FrameTyp) in frBandCompleteList then
    Flags := (Flags and not flBandCompleteList) or Word(Value) *
      flBandCompleteList;
end;

function TfrBandView.GetForceNewPage: Boolean;
begin
  if TfrBandType(FrameTyp) in frBandForceNewPage then
    Result := (Flags and flBandNewPageAfter) > 0
  else
    Result := False;
end;

procedure TfrBandView.SetForceNewPage(Value: Boolean);
begin
  if TfrBandType(FrameTyp) in frBandForceNewPage then
    Flags := (Flags and not flBandNewPageAfter) or Word(Value) *
      flBandNewPageAfter;
end;

function TfrBandView.GetPrintifSubsetEmpty: Boolean;
begin
  if TfrBandType(FrameTyp) in frBandPrintIfSubSetEmpty then
    Result := (Flags and flBandPrintifSubSetEmpty) > 0
  else
    Result := False;
end;

procedure TfrBandView.SetPrintifSubsetEmpty(Value: Boolean);
begin
  if TfrBandType(FrameTyp) in frBandPrintIfSubSetEmpty then
    Flags := (Flags and not flBandPrintifSubsetEmpty) or Word(Value) *
      flBandPrintifSubsetEmpty;
end;

function TfrBandView.GetPageBreak: Boolean;
begin
  if TfrBandType(FrameTyp) in frBandPageBreak then
    Result := (Flags and flBandPageBreak) > 0
  else
    Result := False;
end;

procedure TfrBandView.SetPageBreak(Value: Boolean);
begin
  if TfrBandType(FrameTyp) in frBandPageBreak then
    Flags := (Flags and not flBandPageBreak) or Word(Value) * flBandPageBreak;
end;

function TfrBandView.GetAutoStretch: Boolean;
begin
  if TfrBandType(FrameTyp) in frBandAutoStretch then
    Result := (Flags and flStretched) > 0
  else
    Result := False;
end;

procedure TfrBandView.SetAutoStretch(Value: Boolean);
begin
  if TfrBandType(FrameTyp) in frBandAutoStretch then
    Flags := (Flags and not flStretched) or Word(Value) * flStretched;
end;

function TfrBandView.GetBandType: TfrBandType;
begin
  Result := TfrBandType(FrameTyp);
end;

procedure TfrBandView.SetBandType(Value: TfrBandType);
begin
  FrameTyp := Word(Value);
end;

{----------------------------------------------------------------------------}
constructor TfrSubReportView.Create(Rep: TfrReport);
begin
  inherited;
  Typ := gtSubReport;
  Deleting := False;
end;

destructor TfrSubReportView.Destroy;
begin
  if not Deleting then
    begin
      Deleting := true;
      ParentReport.Pages.Delete(SubPage);
    end;
  inherited;
end;

procedure TfrSubReportView.Assign(From: TfrView);
begin
  inherited Assign(From);
  SubPage := (From as TfrSubReportView).SubPage;
end;

procedure TfrSubReportView.Draw(Canvas: TCanvas);
begin
  BeginDraw(Canvas);
  FrameWidth := 1;
  CalcGaps;
  with Canvas do
    begin
      Font.Name := 'Arial';
      Font.Style := [];
      Font.Size := 8;
      Font.Color := clBlack;
      Pen.Width := 1;
      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Brush.Color := clWhite;
      Rectangle(Left, Top, Left + Width + 1, Top + Height + 1);
      Brush.Style := bsClear;
      TextRect(DRect, Left + 2, Top + 2, FRConst_SubReportOnPage + ' ' +
        IntToStr(SubPage + 1));
    end;
end;

procedure TfrSubReportView.DefinePopupMenu(Popup: TPopupMenu);
begin
  // no specific items in popup
end;

procedure TfrSubReportView.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  Stream.Read(SubPage, 4);
end;

procedure TfrSubReportView.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  Stream.Write(SubPage, 4);
end;

{----------------------------------------------------------------------------}
constructor TfrPictureView.Create(Rep: TfrReport);
begin
  inherited;
  DrawBitmap := TBitmap.Create;
  DrawBitmap.Assign(nil);
  FGraphic := nil;
  Typ := gtPicture;
  Picture := TPicture.Create;
  DrawPict := TPicture.Create;
  Flags := flStretched + flPictRatio;
end;

procedure TfrPictureView.Assign(From: TfrView);
begin
  inherited Assign(From);
  Picture.Assign((From as TfrPictureView).Picture);
end;

destructor TfrPictureView.Destroy;
begin
  if FGraphic <> nil then FGraphic.Free;
  Picture.Free;
  DrawPict.Free;
  DrawBitmap.Free;
  inherited Destroy;
end;

procedure TfrPictureView.Draw(Canvas: TCanvas);        //Itta
Type
   PPalEntriesArray = ^TPalEntriesArray;
   TPalEntriesArray = array[0..0] of TPaletteEntry;
Var
   R      : TRect;
   kx, ky : Double;
   w, h,
   w1, h1, SD: Integer;
   DPict  : TPicture;

   procedure DrawEx(Rt: TRect; Bmp: TBitMap);
   begin
      SetStretchBltMode(Canvas.Handle, HALFTONE);
      Canvas.StretchDraw(Rt, Bmp);
   End;

begin
   DPict:=Picture;
   if (DocMode=dmPrinting) And (Not Visible) then Exit;
   BeginDraw(Canvas);
   SMemo.Assign(Memo);
   if DocMode=dmPrinting then
   Begin
      if CurReport.HasBlobs then
      Begin
        DrawPictOK:=False;
        CurReport.InternalOnEnterRect(SMemo,Self);
        if DrawPictOK then DPict:=DrawPict;
      End;
   End;

   CalcGaps;
   if DPict.Graphic <> nil then
   begin
      DrawBitmap.Width := DPict.Graphic.Width;
      DrawBitmap.Height := DPict.Graphic.Height;
      DrawBitmap.Canvas.Draw(0, 0, DPict.Graphic);
   end;
   //
   With Canvas do
   begin
      ShowBackground;
      If (DocMode=dmDesigning) and
         ((DPict.Graphic=Nil) Or (DPict.Graphic.Empty)) then
      begin
         Font.Name := 'Arial';
         Font.Size := 8;
         Font.Style := [];
         Font.Color := clBlack;
         TextRect(DRect, Left + 2, Top + 2, FRConst_Picture);
      End
      Else
      Begin
         if Not ((DPict.Graphic=Nil) Or DPict.Graphic.Empty) then
         begin
            if (Flags and flStretched)<>0 then
            begin
                R := DRect;
                if (Flags and flPictRatio) <> 0 then
                begin
                    kx := Width / DPict.Width;
                    ky := Height / DPict.Height;
                    if kx < ky then
                      r := Rect(DRect.Left, DRect.Top,
                        DRect.Right, DRect.Top + Round(DPict.Height * kx))
                    else
                      r := Rect(DRect.Left, DRect.Top,
                        DRect.Left + Round(DPict.Width * ky), DRect.Bottom);
                    w := DRect.Right - DRect.Left;
                    h := DRect.Bottom - DRect.Top;
                    w1 := r.Right - r.Left;
                    h1 := r.Bottom - r.Top;
                    if (Flags and flPictCenter) <> 0 then
                      OffsetRect(r, (w - w1) div 2, (h - h1) div 2);
                end;
                DrawEx(r, DrawBitmap);
           End
            Else
            begin
                r := DRect;
                if (Flags and flPictCenter) <> 0 then
                  begin
                    w := DRect.Right - DRect.Left;
                    h := DRect.Bottom - DRect.Top;
                    OffsetRect(r, (w - DPict.Width) div 2, (h - DPict.Height) div 2);
                  end;
                SD := SaveDC(Canvas.Handle);
                IntersectClipRect(Canvas.Handle, Left, Top,
                  Left + Width + 1, Top + Height + 1);
                DrawEx(Rect(r.left, r.top, r.left + DrawBitmap.Width, r.top + DrawBitmap.Height),
                  DrawBitmap);
                RestoreDC(Canvas.Handle, SD);
            End;
         End;
      End;

      ShowFrame;
   End;
   if Not Visible then
   begin
      Canvas.Pen.Color:=ClRed;
      Canvas.Pen.Width:=2;
      Canvas.MoveTo(Left,Top);
      Canvas.LineTo(Left+Width,Top+Height);
      Canvas.MoveTo(Left+Width,Top);
      Canvas.LineTo(Left,Top+Height);
   End;
End;

procedure TfrPictureView.LoadFromStream(Stream: TStream);
var
  b: Byte;
  n: Integer;
  MStream: TMemoryStream;
begin
  inherited LoadFromStream(Stream);
  Stream.Read(b, 1);
  Stream.Read(n, 4);
  FGraphic := nil;
  case b of
    pkBitmap: FGraphic := TBitmap.Create;
    pkMetafile: FGraphic := TMetafile.Create;
    pkIcon: FGraphic := TIcon.Create;
    pkJPeg: FGraphic := TJPegImage.Create;
  end;
  if FGraphic <> nil then 
     Picture.Assign(FGraphic);
  if b <> pkNone then
  begin
      MStream := TMemoryStream.Create;
      MStream.CopyFrom(Stream, n - Stream.Position);
      MStream.Position := 0;
      Picture.Graphic.LoadFromStream(MStream);
      MStream.Free;
  End;
  Stream.Seek(n, soFromBeginning);
end;

procedure TfrPictureView.SaveToStream(Stream: TStream);
var
  b: Byte;
  n, o: Integer;
begin
  inherited SaveToStream(Stream);
  b := pkNone;
  if Picture.Graphic <> nil then
    if Picture.Graphic is TBitmap then
      b := pkBitmap
    else
      if Picture.Graphic is TMetafile then
        b := pkMetafile
      else
        if Picture.Graphic is TIcon then
          b := pkIcon
        else
          if Picture.Graphic is TJPegImage then b := pkJPeg
          else
             if Picture.Graphic is TGraphic then b := pkBitMap;

  Stream.Write(b, 1);
  n := Stream.Position;
  Stream.Write(n, 4);
  if b <> pkNone then
    Picture.Graphic.SaveToStream(Stream);
  o := Stream.Position;
  Stream.Seek(n, soFromBeginning);
  Stream.Write(o, 4);
  Stream.Seek(0, soFromEnd);
end;

procedure TfrPictureView.GetBlob(B: TField);
var
  Stream : TStream;
  G      : TGraphic;
  Start  : Integer;
begin
   If (Not Assigned(B)) Or (Not B.IsBlob)  Then
   Begin
      DrawPict.Assign(nil);
      DrawPictOK:=True;
      Exit;
   End;
   //
   G:=Nil;
   Stream:=Nil;
   Try
      Stream:=B.DataSet.CreateBlobStream(B As TBlobField,bmRead);
      //E' un JPeg ???
      Start:=JpegStartInBlobField(Stream);
      If Start>=0 Then
         G:=TJPEGImage.Create
      Else
      Begin
         //E' un BMP ???
         Start:=BMPStartInBlobField(Stream);
         If Start>=0 Then
            G:=TBitmap.Create
         Else
         Begin
            //MetaFile
            Start:=EMFStartInBlobField(Stream);
            If Start>=0 Then
               G:=TMetaFile.Create
            Else
            Begin
               //ICO

            End;
         End;
      End;
      if G<>nil then
      begin
         DrawPict.Assign(G);
         Stream.Position:=Start;
         DrawPict.Graphic.LoadFromStream(Stream);
         DrawPictOK := True;
      End
      Else
         Raise Exception.Create(FRConst_InvalidImageFormat);
   Finally
      If Assigned(G) Then G.Free;
      If Assigned(Stream) Then Stream.Free;
   End;
End;

procedure TfrCustomPictureView.DefinePopupMenu(Popup: TPopupMenu);
var
  m: TMenuItem;
begin
  m := TMenuItem.Create(Popup);
  m.Caption := '-';
  Popup.Items.Add(m);

  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_Stretched;
  m.OnClick := PStretchClick;
  m.Checked := (Flags and flStretched) <> 0;
  Popup.Items.Add(m);
  inherited DefinePopupMenu(Popup);
  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_PictureCenter;
  m.OnClick := P1Click;
  m.Checked := (Flags and flPictCenter) <> 0;
  Popup.Items.Add(m);

  m := TMenuItem.Create(Popup);
  m.Caption := FRConst_KeepAspectRatio;
  m.OnClick := P2Click;
  m.Checked := (Flags and flPictRatio) <> 0;
  Popup.Items.Add(m);
end;

procedure TfrCustomPictureView.PStretchClick(Sender: TObject);
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
            t.Flags := (t.Flags and not flStretched) + Word(Checked);
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrCustomPictureView.P1Click(Sender: TObject);
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
            t.Flags := (t.Flags and not flPictCenter) + Word(Checked) *
              flPictCenter;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

procedure TfrCustomPictureView.P2Click(Sender: TObject);
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
            t.Flags := (t.Flags and not flPictRatio) + Word(Checked) *
              flPictRatio;
        end;
    end;
  frDesigner.PopupNotify(Self);
end;

function TfrCustomPictureView.GetCenter: Boolean;
begin
  Result := (Flags and flPictCenter) > 0;
end;

procedure TfrCustomPictureView.SetCenter(Value: Boolean);
begin
  Flags := (Flags and not flPictCenter) or Word(Value) * flPictCenter;
end;

function TfrCustomPictureView.GetStretch: Boolean;
begin
  Result := (Flags and flStretched) > 0;
end;

procedure TfrCustomPictureView.SetStretch(Value: Boolean);
begin
  Flags := (Flags and not flStretched) or Word(Value) * flStretched;
end;

function TfrCustomPictureView.GetKeepRatio: Boolean;
begin
  Result := (Flags and flPictRatio) > 0;
end;

procedure TfrCustomPictureView.SetKeepRatio(Value: Boolean);
begin
  Flags := (Flags and not flPictRatio) or Word(Value) * flPictRatio;
end;

{----------------------------------------------------------------------------}
constructor TfrBand.Create(ATyp: TfrBandType; AParent: TfrPage);
begin
  inherited Create;
  ParentView := nil;
  AggregateFunctions := TStringList.Create;
  VerticalFunctions := TStringList.Create;
  RowCount := 0;
  MaxDataCount := 0;
  AggregateFunctions.Sorted := True;
  Typ := ATyp;
  Parent := AParent;
  Objects := TList.Create;
  Memo := TStringList.Create;
  GroupValues := TStringList.Create;
  Next := nil;
  Positions[psLocal] := 1;
  Positions[psGlobal] := 1;
  Visible := True;
  Num := 0;
  CompleteProcess := False;
end;

destructor TfrBand.Destroy;
var
  I, J: Integer;
  L: TList;
  PV: ^Variant;
begin
  if Next <> nil then Next.Free;
  Objects.Free;
  Memo.Free;
  GroupValues.Free;
  if DataSet <> nil then
    begin
      DataSet.Exit;
      CheckBandEvent(Self, opExit);
    end;
  for I := 0 to AggregateFunctions.Count - 1 do
    begin
      PV := Pointer(AggregateFunctions.Objects[0]);
      Dispose(PV);
      AggregateFunctions.Delete(0);
    end;
  AggregateFunctions.Free;
  for I := 0 to VerticalFunctions.Count - 1 do
    begin
      L := Pointer(VerticalFunctions.Objects[0]);
      for J := 0 to L.Count - 1 do
        begin
          PV := Pointer(L[0]);
          Dispose(PV);
          L.Delete(0);
        end;
      L.Free;
      VerticalFunctions.Delete(0);
    end;
  VerticalFunctions.Free;
  inherited Destroy;
end;

procedure TfrBand.InitDataSet(Desc: string);
var
  I :  Integer;
begin
  if (Typ<>btGroupHeader) then
  begin
      //Itta
      If Pos('_',Desc)=1 Then
      Begin
         Desc:=PostStr(Desc,'_');
         Desc:=AnteStr(Desc,'_');
      End;
      if CurReport.Owner <> nil then
        DataSet := CurReport.Owner.FindComponent(Desc) as TfrDataSet
      else
        DataSet := nil;
      if DataSet = nil then
        if CurReport.DataSetList.Find(Desc, I) then
          DataSet := CurReport.DataSetList.Objects[I] as TfrDataSet;
      if DataSet <> nil then
      begin
          if DataSet.InheritsFrom(TfrDBDataSet) then
          Begin
             TfrDBDataSet(DataSet).DisableDataSetControls :=
                CurReport.DisableDataSetControls;
             TfrDBDataSet(DataSet).Init;   
             if (DataSet.InheritsFrom(TfrDBDataSet)) and
                (TfrDBDataSet(DataSet).GetDataSetError <> '') then
             begin
                CurView := nil;
                DoError(TfrDBDataSet(DataSet).GetDataSetError);
                DataSet := nil;
             end
             else
               CheckBandEvent(Self, opInit);
          End     
          Else
          Begin
             DataSet.Init;
             CheckBandEvent(Self, opInit);
          End;  
       end
      else
        if Desc <> '' then
        Begin
//            DoError(FRConst_ErrorLoadfrDataSet + ' ' + Desc);
//            Raise Exception.Create(FRConst_ErrorLoadfrDataSet + ' ' + Desc);
        End;    
    end;
end;

function TfrBand.CalcHeight: Integer;
var
  i: Integer;
  t: TfrView;
begin
  CurBand := Self;
  SHeight := dy;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if (t is TfrCustomMemoView) then
        if t.Parent = Self then
          begin
            TfrCustomMemoView(t).DrawMode := drCalcHeight;
            CurReport.InternalOnDrawObject(T);
            t.Draw(MCanvas);
            CurReport.InternalOnDrawedObject(T);
            if SHeight < T.Top + T.Height then
              SHeight := T.Top + T.Height
          end;
    end;
  Result := SHeight;
end;

procedure TfrBand.StretchObjects(var MaxHeight: Integer);
var
  I, J: Integer;
  T, T2: TfrView;
begin
  for I := 0 to Objects.Count - 1 do
    begin
      T := Objects[I];
      if (T is TfrCustomMemoView) and (TfrCustomMemoView(T).AutoStretch) then
        begin
          for J := 0 to Objects.Count - 1 do
            begin
              T2 := Objects[J];
              if (T2 <> T) and (T2.Top > T.Top + T.OldDy) and
                (((T2.Left + T2.OldDx >= T.Left) and (T2.Left + T2.OldDx <=
                T.Left + T.Width)) or
                ((T2.Left >= T.Left) and (T2.Left <= T.Left + T.Width))) then
                begin
                  //                  T2.OldY := T2.OldY + (T.Height-T.OldDy);
                  T2.OldTop := T2.Top;
                  T2.Top := T2.Top + (T.Height - T.OldDy);
                  if T2.Top + T2.Height > MaxHeight then
                    Inc(MaxHeight, (T2.Top + T2.Height) - MaxHeight);
                end;
            end;
        end;
    end;
end;

procedure TfrBand.DrawObject(t: TfrView; DrawMode: TfrDrawMode);
var
  ox, oy: Integer;
begin
  if ErrorFlag then Exit;
  CurPage := Parent;
  CurBand := Self;
  try
    if (t.Parent = Self) and not DisableDrawing then
      begin
        ox := t.Left;
        oy := t.Top;
        if Typ <> btNone then
          begin
            Inc(t.Left, Parent.XAdjust - Parent.LeftMargin);
            Inc(t.Top, y);
          end;
        if t is TfrCustomMemoView then
          begin
            TfrCustomMemoView(t).DrawMode := DrawMode;
            CurReport.InternalOnDrawObject(T);
            t.Draw(MCanvas);
            CurReport.InternalOnDrawedObject(T);
          end
        else
          begin
            CurReport.InternalOnDrawObject(T);
            t.Draw(MCanvas);   //Disegno immagini e barcode
            CurReport.InternalOnDrawedObject(T);
          end;
        t.Left := ox;
        t.Top := oy;
      end;
  except
    on Ex: Exception do DoError(FRConst_GeneralError + ' ' + Ex.Message);
  end;
end;

procedure TfrBand.PrepareSubReports;
var
  i: Integer;
  t: TfrView;
  Page: TfrPage;
begin
  for i := SubIndex to Objects.Count - 1 do
    begin
      t := Objects[i];
      Page := CurReport.Pages[(t as TfrSubReportView).SubPage];
      Page.Mode := pmBuildList;
      Page.FormPage;
      Page.CurY := y + t.Top;
      Page.CurBottomY := Parent.CurBottomY;
      Page.XAdjust := Parent.XAdjust + t.Left;
      Page.CurColumn := Parent.CurColumn;
      Page.PlayFrom := 0;
      EOFArr[i - SubIndex] := False;
    end;
  Parent.LastBand := nil;
end;

procedure TfrBand.DoSubReports;
var
  i, Max: Integer;
  t: TfrView;
  Page: TfrPage;
  NewCol: Boolean;
begin
  NewCol := False;
  Max := -1;
  repeat
    if not EOFReached then
      for i := SubIndex to Objects.Count - 1 do
        begin
          t := Objects[i];
          Page := CurReport.Pages[(t as TfrSubReportView).SubPage];
          if NewCol then
            Page.CurY := Y + T.Top
          else
            Page.CurY := Parent.CurY;
          Page.CurBottomY := Parent.CurBottomY;
        end;
    EOFReached := True;
    MaxY := Parent.CurY;
    for i := SubIndex to Objects.Count - 1 do
      if not EOFArr[i - SubIndex] then
        begin
          t := Objects[i];
          Page := CurReport.Pages[(t as TfrSubReportView).SubPage];
          if Page.PlayRecList then
            EOFReached := False
          else
            begin
              EOFArr[i - SubIndex] := True;
              if Page.CurColumn > 0 then
                MaxY := Max
              else
                Max := -1;
              if Page.CurY > MaxY then MaxY := Page.CurY;
            end;
        end;
    if not EOFReached then
      begin
        if Parent.Skip then
          begin
            Parent.LastBand := Self;
            Exit;
          end
        else
          with CurReport.Pages[TfrSubReportView(Objects[SubIndex]).SubPage] do
            begin
              if CurColumn < ColCount - 1 then
                begin
                  if CurY > Max then Max := CurY;
                  Inc(CurColumn);
                  Inc(XAdjust, ColWidth + ColGap);
                  NewCol := True;
                end
              else
                if Typ <> btPageFooter then
                  begin
                    Parent.NewPage;
                    CurColumn := 0;
                    if ColCount > 1 then XAdjust := LeftMargin;
                    NewCol := False;
                  end
                else
                  EOFReached := True;
            end;
      end;
  until EOFReached or MasterReport.Terminated;
  for i := SubIndex to Objects.Count - 1 do
    begin
      t := Objects[i];
      Page := CurReport.Pages[(t as TfrSubReportView).SubPage];
      Page.ClearRecList;
    end;
  Parent.CurY := MaxY;
  Parent.LastBand := nil;
end;

function TfrBand.DrawObjects(DrawMode: TfrDrawMode): Boolean;
var
  i: Integer;
  t: TfrView;
begin
  Result := False;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Typ = gtSubReport then
        begin
          SubIndex := i;
          Result := True;
          PrepareSubReports;
          DoSubReports;
          break;
        end;
      DrawObject(t, DrawMode);
      if MasterReport.Terminated then break;
    end;
end;

procedure TfrBand.DrawColumnCell(Parnt: TfrBand; CurX: Integer);
var
  i, sfx, sfy: Integer;
  t: TfrView;
begin
  if ErrorFlag then Exit;
  if DisableDrawing then Exit;
  try
    for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if Parnt.Objects.IndexOf(t) <> -1 then
          begin
            sfx := t.Left;
            Inc(t.Left, CurX);
            sfy := t.Top;
            Inc(t.Top, Parnt.y);
            t.Parent := Parnt;
            if t is TfrCustomMemoView then
              TfrCustomMemoView(t).DrawMode := drAll;
            CurReport.InternalOnDrawObject(T);
            t.Draw(MCanvas);
            CurReport.InternalOnDrawedObject(T);
            t.Parent := Self;
            t.Left := sfx;
            t.Top := sfy;
          end;
      end;
  except
    on Ex: Exception do DoError(FRConst_GeneralError + ' ' + Ex.Message);
  end;
end;

procedure TfrBand.DrawColumnAll;
var
  Bnd: TfrBand;
  sfpage: Integer;
  CurX: Integer;
  procedure CheckColumnPageBreak;
  var
    sfy: Integer;
    b: TfrBand;
  begin
    if CurX + Bnd.dx > Parent.RightMargin then
      begin
        Inc(ColumnXAdjust, CurX - Parent.LeftMargin);
        CurX := Parent.LeftMargin;
        Inc(PageNo);
        if PageNo >= MasterReport.EMFPages.Count then
          begin
            MasterReport.EMFPages.Add(Parent);
            sfy := Parent.CurY;
            Parent.ShowBand(Parent.Bands[btOverlay]);
            Parent.ShowBand(Parent.Bands[btPageHeader]); // need 'CurY' saving!
            Parent.CurY := sfy;
            CurReport.InternalOnProgress(PageNo);
          end
        else
          MCanvas := MasterReport.EMFPages[PageNo].Canvas;
        if Parent.CHCopy then
          if Parent.BandExists(Parent.Bands[btColumnHeader]) then
            begin
              b := Parent.Bands[btColumnHeader];
              b.DrawColumnCell(Self, Parent.LeftMargin);
              CurX := Parent.LeftMargin + b.dx;
            end;
      end;
  end;
begin
  if IntoMe then Exit;
  IntoMe := True;
  ColumnXAdjust := 0;
  Parent.ColPos := 1;
  CurX := 0;
  sfpage := PageNo;
  if Parent.BandExists(Parent.Bands[btColumnHeader]) then
    begin
      Bnd := Parent.Bands[btColumnHeader];
      Bnd.DrawColumnCell(Self, Bnd.x);
      CurX := Bnd.x + Bnd.dx;
    end;
  if Parent.BandExists(Parent.Bands[btColumnData]) then
    begin
      Bnd := Parent.Bands[btColumnData];
      if CurX = 0 then CurX := Bnd.x;
      if Bnd.DataSet <> nil then
        begin
          Bnd.DataSet.First;
          CheckBandEvent(Bnd, opFirst);
          CheckAggregateFunctions(Bnd, opFirst);
          ColumnNumber := 1;
          if CurPage.Bands[btMasterData].DataSet <> nil then
            while ((not Bnd.DataSet.EOF) and
              (not CurPage.Bands[btMasterData].DataSet.EOF)) or
              ((CurPage.Bands[btMasterData].DataSet.EOF) and
              (ColumnNumber <= Bnd.MaxDataCount)) do
              begin
                CheckColumnPageBreak;
                Bnd.DrawColumnCell(Self, CurX);
                Inc(CurX, Bnd.dx);
                Inc(Parent.ColPos);
                Bnd.DataSet.Next;
                CheckBandEvent(Bnd, opNext);
                CheckAggregateFunctions(Bnd, opNext);
                if MasterReport.Terminated then break;
                Inc(ColumnNumber);
              end;
        end;
    end;
  if Parent.BandExists(Parent.Bands[btColumnFooter]) then
    begin
      Bnd := Parent.Bands[btColumnFooter];
      if CurX = 0 then CurX := Bnd.x;
      CheckColumnPageBreak;
      Bnd.DrawColumnCell(Self, CurX);
    end;
  PageNo := sfpage;
  MCanvas := MasterReport.EMFPages[PageNo].Canvas;
  ColumnXAdjust := 0;
  IntoMe := False;
end;

function TfrBand.CheckPageBreak(y, dy: Integer; PBreak: Boolean): Boolean;
begin
  Result := False;
  with Parent do
    if y + Bands[btStaticColumnFooter].dy + dy > CurBottomY then
      begin
        if not PBreak then
          begin
            if CurColumn < ColCount - 1 then
              begin
                ShowBand(Bands[btStaticColumnFooter]);
                Inc(CurColumn);
                Inc(XAdjust, ColWidth + ColGap);
                CurY := LastStaticColumnY;
                ShowBand(Bands[btStaticColumnHeader]);
              end
            else
              NewPage;
            Inc(CurDataRow);
          end;
        Result := True;
      end;
end;

procedure TfrBand.DrawPageBreak(DrawMode: TfrDrawMode);
var
  i, th, addy: Integer;
  dy, oldy, olddy, maxy: Integer;
  t: TfrView;
  Flag: Boolean;
  function RoundY: Integer;
  var
    dy: Integer;
  begin
    dy := t.Height div th * th + t.gapy * 2 + 1;
    if dy > t.Height then Dec(dy, th);
    Result := t.Height - dy + 1;
    t.Height := dy;
  end;
  procedure CorrY(t: TfrView; dy: Integer);
  var
    i: Integer;
    t1: TfrView;
  begin
    for i := 0 to Objects.Count - 1 do
      begin
        t1 := Objects[i];
        if t1 <> t then
          if (t1.Top > t.Top + t.Height) and (t1.Left >= t.Left) and
            (t1.Left <= t.Left + t.Width) then Inc(t1.Top, dy);
      end;
  end;
begin
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      t.Selected := True;
      t.OriginalRect := Rect(t.Left, t.Top, t.Width, t.Height);
    end;
  if not CheckPageBreak(y, maxdy, True) then
    DrawObjects(DrawMode)
  else
    begin
      repeat
        dy := Parent.CurBottomY - Parent.Bands[btStaticColumnFooter].dy - y - 2;
        CurViewDy := Dy - T.Top;
        maxy := 0;
        for i := 0 to Objects.Count - 1 do
          begin
            t := Objects[i];
            if t.Selected then
              if (t.Top >= 0) and (t.Top < dy) then
                if (t.Top + t.Height < dy) then
                  begin
                    DrawObject(t, DrawMode);
                    if maxy < t.Top + t.Height then maxy := t.Top + t.Height;
                    t.Selected := False;
                  end
                else
                  begin
                    if t is TfrCustomMemoView then
                      begin
                        th := (t as TfrCustomMemoView).TheTextHeight;
                        olddy := t.Height;
                        t.Height := dy - t.Top + 1;
                        addy := RoundY;
                        if t.Height < th then
                          begin
                            CorrY(t, dy - t.Top);
                            t.Top := dy;
                            addy := 0;
                          end
                        else
                          begin
                            (t as TfrCustomMemoView).FromLine := 0;
                            DrawObject(t, drPart);
                            CorrY(t, addy);
                          end;
                        t.Height := olddy + addy;
                      end
                    else
                      t.Top := dy
                  end
              else
                if (t.Top < 0) and (t.Top + t.Height >= 0) then
                  if t.Top + t.Height < dy then
                    begin
                      th := (t as TfrCustomMemoView).TheTextHeight;
                      oldy := t.Top;
                      olddy := t.Height;
                      t.Height := t.Top + t.Height;
                      t.Top := 0;
                      if t.Height > th div 2 then
                        begin
                          if t is TfrMemoView then
                            t.Height := (t.Memo1.Count - (t as
                              TfrMemoView).FromLine) * th + t.gapy * 2 + 1
                          else
                            T.Height := TfrCustomMemoView(T).TotalHeight +
                              T.FrameWidth;

                          DrawObject(t, drPart);
                          if maxy < t.Top + t.Height then
                            maxy := t.Top + t.Height;
                        end;
                      t.Top := oldy;
                      t.Height := olddy;
                      t.Selected := False;
                    end
                  else
                    begin
                      th := (t as TfrCustomMemoView).TheTextHeight;
                      oldy := t.Top;
                      olddy := t.Height;
                      t.Height := dy;
                      t.Top := 0;
                      addy := RoundY;
                      DrawObject(t, drPart);
                      t.Top := oldy;
                      t.Height := olddy + addy;
                    end;
          end;
        Flag := False;
        for i := 0 to Objects.Count - 1 do
          begin
            t := Objects[i];
            if t.Selected then Flag := True;
            Dec(t.Top, dy);
          end;
        if Flag then CheckPageBreak(y, 10000, False);
        y := Parent.CurY;
      until not Flag;
      maxdy := maxy;
    end;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      t.Top := t.OriginalRect.Top;
      t.Height := t.OriginalRect.Bottom;
    end;
  Inc(Parent.CurY, maxdy);
end;

procedure TfrBand.DoDraw;
var
  sfy, sh, I: Integer;
  UseY, WasSub: Boolean;
  T: TfrView;
  procedure DrawColumns;
  var
    i: Integer;
    t: TfrView;
  begin
    for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if t.Parent <> Self then
          begin
            DrawColumnAll;
            break;
          end;
      end;
  end;

begin
  if Objects.Count = 0 then Exit;
  sfy := y;
  UseY := not (Typ in [btPageFooter, btOverlay, btNone]);
  if UseY then y := Parent.CurY;
  if Stretched then
    begin
      sh := CalcHeight;
      for I := 0 to Objects.Count - 1 do
        begin
          T := Objects[I];
          T.OldTop := -1;
        end;
      StretchObjects(sh);
      maxdy := sh;
      if not PageBreak then CheckPageBreak(y, sh, False);
      y := Parent.CurY;
      WasSub := False;
      if PageBreak then
        begin
          DrawPageBreak(drAfterCalcHeight);
          sh := 0;
        end
      else
        begin
          WasSub := DrawObjects(drAfterCalcHeight);
          DrawColumns;
        end;
      if not WasSub then Inc(Parent.CurY, sh);
      for I := 0 to Objects.Count - 1 do
        begin
          T := Objects[I];
          if T.OldTop <> -1 then
            begin
              T.Top := T.OldTop;
              T.OldTop := -1;
            end;
        end;
    end
  else
    begin
      if UseY then
        begin
          if not PageBreak then CheckPageBreak(y, dy, False);
          y := Parent.CurY;
        end;
      if PageBreak then
        begin
          maxdy := CalcHeight;
          DrawPageBreak(drAfterCalcHeight);
        end
      else
        begin
          WasSub := DrawObjects(drAll);
          DrawColumns;
          if UseY and not WasSub then Inc(Parent.CurY, dy);
        end;
    end;
  y := sfy;
end;

function TfrBand.DoCalcHeight: Integer;
var
  b: TfrBand;
begin
  if (Typ in [btMasterData, btDetailData, btSubDetailData]) and
    (Next <> nil) and (Next.Dataset = nil) then
    begin
      b := Self;
      Result := 0;
      repeat
        Result := Result + b.CalcHeight;
        b := b.Next;
      until b = nil;
    end
  else
    begin
      Result := dy;
      if Stretched then Result := CalcHeight;
    end;
end;

function TfrBand.Draw: Boolean;
var
  b: TfrBand;
  I: Integer;
  T: TfrView;
  Bn: TfrBand;
  OK: Boolean;
begin
  if (ParentView <> nil) and (Objects.Count > 0) then
    CurReport.InternalOnDrawObject(ParentView);
  if (ParentView <> nil) and (not ParentView.Visible) then
    Result := True
  else
    if not CompleteProcess then
      begin
        Result := False;
        if Typ = btStaticColumnHeader then
          Parent.LastStaticColumnY := Parent.CurY;
        if Typ = btPageFooter then
          y := Parent.CurBottomY;

        //Itta ?????????????????????????
        //Nota: Objects contiene gli Items da disegnare in base al tipo Typ
        if Objects.Count > 0 then
          begin
            Bn := nil;
            OK := False;
            //
            // Go to the prior record for draw the currently data.
            // Thanks to "Diego Zanella"...
            if Typ in [btMasterFooter, btDetailFooter, btSubdetailFooter,btGroupFooter] then
            begin
                case Typ of
                  btMasterFooter, btGroupFooter: Bn :=
                    CurPage.Bands[btMasterData];
                  btDetailFooter: Bn := CurPage.Bands[btDetailData];
                  btSubdetailFooter: Bn := CurPage.Bands[btSubdetailData];
                end;
                if (not Bn.DataSet.EOF) then
                  begin
                    CurReport.FIsSequenced := False;
                    OK := True;
                    Bn.DataSet.Prior;
                    CheckBandEvent(Bn, opPrior);
                  end;
            end;
            //...
            if not (Typ in [btPageFooter, btOverlay, btNone]) then
              if (Parent.CurY + DoCalcHeight > Parent.CurBottomY) and not
                PageBreak then
                begin
                  Result := True;
                  if Parent.Skip then
                    Exit
                  else
                    CheckPageBreak(0, 10000, False);
                end;
            EOFReached := True;
            if (Typ in [btMasterData, btDetailData, btSubDetailData]) and
              (Next <> nil) and (Next.Dataset = nil) then
              begin
                b := Self;
                repeat
                  b.DoDraw;
                  Inc(CurDataRow);
                  b := b.Next;
                until b = nil;
              end
            else
              begin
                DoDraw;
                if not (Typ in [btMasterData, btDetailData, btSubDetailData,
                  btGroupHeader]) and
                  NewPageAfter then
                  Parent.NewPage;
              end;
            if not EOFReached then Result := True;

            // Move the recond in the next position for reset the correct record's position.
            if OK then
              begin
                Bn.DataSet.Next;
                CheckBandEvent(Bn, opNext);
                CurReport.FIsSequenced := True;
              end;
            //...

          end;
      end
    else
      begin
        for I := 0 to Objects.Count - 1 do
          begin
            T := TfrView(Objects[I]);
            Inc(T.Top, Parent.CurY);
            Inc(T.Left, (Parent.CurColumn) * (Parent.ColWidth + Parent.Colgap));
            T.Height := T.OldDy;
            T.ShowBackGround;
            T.ShowFrame;
            Dec(T.Top, Parent.CurY);
            Dec(T.Left, (Parent.CurColumn) * (Parent.ColWidth + Parent.Colgap));
          end;
        Inc(Parent.CurY, Dy);
        Result := True;
      end;
  if (ParentView <> nil) and (Objects.Count > 0) then
    CurReport.InternalOnDrawedObject(ParentView);
end;

procedure TfrBand.InitGroupValues;
var
  b: TfrBand;
begin
  CurBand := Self;
  b := Self;
  while b <> nil do
    begin
      if b.FooterBand <> nil then
        begin
          b.FooterBand.GroupValues.Clear;
          b.FooterBand.Count := 0;
        end;
      try
        b.LastGroupValue := Calc(b.GroupCondition);
      except
        on Ex: Exception do
          begin
            //                           CurView:=Nil;
            DoError(FRConst_GeneralError + ' ' + Ex.Message);
          end;
      end;
      b := b.Next;
    end;
end;

procedure TfrBand.DoAggregate;
var
  i: Integer;
  t: TfrView;
  FUseHighlight: Boolean;
  s: string;
begin
  for i := 0 to GroupValues.Count - 1 do
    begin
      s := GroupValues[i];
      GroupValues[i] := Copy(s, 1, Pos('=', s) - 1) + '=0' +
        Copy(s, Pos('=', s) + 2, 255);
    end;

  Visible := False;
  CurBand := Self;
  for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      CurView := t;
      if t is TfrMemoView then
        with t as TfrMemoView do
          begin
            FUseHighlight := UseHighlight;
            ExpandVariables;
            UseHighlight := FUseHighlight;
          end;
    end;
  Visible := True;
  Inc(Count);
end;

{----------------------------------------------------------------------------}
constructor TfrPage.Create(ASize, AWidth, AHeight: Integer; AOr:
  TPrinterOrientation;
  ADoc: TfrReport);
begin
  inherited Create;
  List := TList.Create;
  Objects := TList.Create;
  ChangePaper(ASize, AWidth, AHeight, AOr);
  PHonFirst := True;
  PFonLast := True;
  CHCopy := False;
  PrintToPrevPage := False;
  pgMargins.Left := Round(10 * 794 / 210);
  pgMargins.Top := Round(10 * 794 / 210);
  pgMargins.Right := Round(10 * 794 / 210);
  pgMargins.Bottom := Round(15 * 794 / 210);
  ZoomX := 100;
  ZoomY := 100;
end;

destructor TfrPage.Destroy;
begin
  Clear;
  Objects.Free;
  List.Free;
  inherited Destroy;
end;

procedure TfrPage.ChangePaper(ASize, AWidth, AHeight: Integer; AOr:
  TPrinterOrientation);
begin
  try
    PrinterSettings.SetPrinterInfo(ASize, AWidth, AHeight, AOr);
    PrinterSettings.FillPrnInfo(PrnInfo);
  except
    on exception do
      begin
        PrinterSettings.SetPrinterInfo(pgCustomSize, AWidth, AHeight, AOr);
        PrinterSettings.FillPrnInfo(PrnInfo);
      end;
  end;
  pgSize := PrinterSettings.PaperSize;
  pgWidth := PrinterSettings.PaperWidth;
  pgHeight := PrinterSettings.PaperLength;
  pgOr := PrinterSettings.Orientation;
end;

procedure TfrPage.Clear;
var
  i: Integer;
begin
  for i := Objects.Count - 1 downto 0 do
    Delete(i);
end;

procedure TfrPage.Delete(Index: Integer);
begin
  try
    TfrView(Objects[Index]).Free;
    Objects.Delete(Index);
  except
  end;
end;

procedure TfrPage.InitReport;
var
  b: TfrBandType;
begin
  for b := btReportTitle to btNone do
    Bands[b] := TfrBand.Create(b, Self);
  TossObjects;
  if not ErrorFlag then
    begin
      CheckAggregate;
      InitFlag := True;
      CurPos := 1;
      ColPos := 1;
    end;
end;

procedure TfrPage.DoneReport;
var
  i: Integer;
  b: TfrBandType;
  t: TfrView;
begin
  for b := btReportTitle to btNone do
    Bands[b].Free;
  if InitFlag then
    begin
      for i := 0 to Objects.Count - 1 do // set 'y' value back
        begin
          t := Objects[i];
          if t.Typ <> gtBand then
            begin
              t.Top := t.oldy;
              t.Left := t.oldx;
              t.Height := t.olddy;
              t.Width := t.olddx;
              t.Selected := False;
            end;
        end;
    end;
  InitFlag := False;
end;

function TfrPage.TopMargin: Integer;
begin
  if pgMargins.Top = 0 then
    Result := PrnInfo.Ofy
  else
    Result := pgMargins.Top
end;

function TfrPage.BottomMargin: Integer;
begin
  with PrnInfo do
    if pgMargins.Bottom = 0 then
      Result := Ofy + Ph
    else
      Result := Pgh - pgMargins.Bottom;
  if BandExists(Bands[btPageFooter]) then
    Result := Result - Bands[btPageFooter].dy;
end;

function TfrPage.LeftMargin: Integer;
begin
  if pgMargins.Left = 0 then
    Result := PrnInfo.Ofx
  else
    Result := pgMargins.Left;
end;

function TfrPage.RightMargin: Integer;
begin
  with PrnInfo do
    if pgMargins.Right = 0 then
      Result := Ofx + Pw
    else
      Result := Pgw - pgMargins.Right;
end;

procedure TfrPage.CheckAggregate;
var
  T: TfrView;
  I: Integer;
  OldDisableDrawing: Boolean;
begin
  if InitFlag then Exit;
  CurPage := Self;
  I := 0;
  while (I <= Objects.Count - 1) and (not ErrorFlag) do
    // select all objects exclude bands
    begin
      T := Objects[I];
      if T.Typ <> gtBand then
        begin
          T.OriginalBandViewType := T.Parent.Typ;
          if T is TfrCustomMemoView then
            begin
              CurView := T;
              CurBand := T.Parent;
              case T.Parent.Typ of
                btReportSummary, btPageFooter,
                  btMasterData, btMasterFooter,
                  btStaticColumnFooter,
                  btGroupFooter: StatisticBand := Bands[btMasterData];
                btDetailData,
                  btDetailFooter: StatisticBand := Bands[btDetailData];
                btSubDetailData,
                  btSubDetailFooter: StatisticBand := Bands[btSubDetailData];
                btColumnData,
                  btColumnFooter: StatisticBand := Bands[btColumnData];
              else
                StatisticBand := Bands[btNone];
              end;
              OldDisableDrawing := DisableDrawing;
              DisableDrawing := False;
              TfrCustomMemoView(T).AllTotal := False;
              TfrCustomMemoView(T).ReturnPresent := False;
              SetErrorType(ContinueOnExpection);
              TfrCustomMemoView(T).ExpandVariables;
              SetErrorType(StopOnException);
              DisableDrawing := OldDisableDrawing;
            end;
        end;
      Inc(I);
    end;
  StatisticBand := nil;
end;

procedure TfrPage.TossObjects;
var
  i, j, n, last, miny: Integer;
  b: TfrBandType;
  bt, t: TfrView;
  Bnd, Bnd1: TfrBand;
  FirstBand, Flag: Boolean;
  BArr: array[0..31] of TfrBand;
  List: TStringList;
  Bi: Byte;

  function Complete(S: string): string;
  var
    I: Integer;
  begin
    for I := Length(S) + 1 to 2 do
      S := '0' + S;
    Result := S;
  end;

begin
  List := TStringList.Create;
  List.Sorted := True;
  List.Duplicates := dupAccept;
  for i := 0 to Objects.Count - 1 do // select all objects exclude bands
    begin
      t := Objects[i];
      if (T.Typ = gtBand) and
        (TfrBandType(T.FrameTyp) in [btColumnHeader, btColumnData,
        btColumnFooter]) then
        Bands[TfrBandType(T.FrameTyp)].ParentView := T;
      t.Selected := t.Typ <> gtBand;
      t.oldx := t.Left;
      t.oldy := t.Top;
      t.olddy := t.Height;
      t.olddx := t.width;
      t.Parent := nil;
      if t.Typ = gtSubReport then
        CurReport.Pages[(t as TfrSubReportView).SubPage].Skip := True;
    end;
  Flag := False;
  for i := 0 to Objects.Count - 1 do // search for btColumnXXX bands
    begin
      bt := Objects[i];
      if (bt.Typ = gtBand) and
        (TfrBandType(bt.FrameTyp) in [btColumnHeader..btColumnFooter]) then
        with Bands[TfrBandType(bt.FrameTyp)] do
          begin
            Memo.Assign(bt.Memo);
            x := bt.Left;
            dx := bt.Width;
            //      InitDataSet(bt.FormatStr);
            if TfrBand(bt).Typ = btGroupHeader then
              TfrBand(bt).GroupCondition := bt.FormatStr;
            List.AddObject(Complete(IntToStr(bt.FrameTyp)),
              Bands[TfrBandType(bt.FrameTyp)]);
            if ErrorFlag then Exit;
            Flag := True;
          end;
    end;

  if Flag then // fill a ColumnXXX bands at first
    for b := btColumnHeader to btColumnFooter do
      begin
        Bnd := Bands[b];
        for i := 0 to Objects.Count - 1 do
          begin
            t := Objects[i];
            if t.Selected then
              if (t.Left >= Bnd.x) and (t.Left + t.Width <= Bnd.x + Bnd.dx) then
                begin
                  t.Left := t.Left - Bnd.x;
                  t.Parent := Bnd;
                  Bnd.Objects.Add(t);
                end;
          end;
      end;

  for b := btReportTitle to btGroupFooter do // fill other bands
    begin
      FirstBand := True;
      Bnd := Bands[b];
      BArr[0] := Bnd;
      Last := 1;
      for i := 0 to Objects.Count - 1 do // search for specified band
        begin
          bt := Objects[i];
          if (bt.Typ = gtBand) and (bt.FrameTyp = Integer(b)) then
            begin
              if not FirstBand then
                begin
                  Bnd.Next := TfrBand.Create(b, Self);
                  Bnd := Bnd.Next;
                  BArr[Last] := Bnd;
                  Inc(Last);
                end;
              FirstBand := False;
              Bnd.Memo.Assign(bt.Memo);
              Bnd.y := bt.Top;
              Bnd.dy := bt.Height;
              Bnd.ParentView := bt;
              with bt as TfrBandView, Bnd do
                begin
                  //          InitDataSet(FormatStr);
                  if Typ = btGroupHeader then GroupCondition := FormatStr;
                  List.AddObject(Complete(IntToStr(bt.FrameTyp)), Bnd);
                  if ErrorFlag then Exit;
                  Bnd.CompleteList := TfrBandView(bt).CompleteList;
                  Bnd.Stretched := TfrBandView(bt).AutoStretch;
                  Bnd.PrintIfSubsetEmpty := TfrBandView(bt).PrintIfSubSetEmpty;
                  if Skip then
                    begin
                      Bnd.NewPageAfter := False;
                      Bnd.PageBreak := False;
                    end
                  else
                    begin
                      Bnd.NewPageAfter := TfrBandView(bt).ForceNewPage;
                      Bnd.PageBreak := TfrBandView(bt).PageBreak;
                    end;
                end;
              for j := 0 to Objects.Count - 1 do // placing objects over band
                begin
                  t := Objects[j];
                  if (t.Parent = nil) and (t.Typ <> gtSubReport) then
                    if t.Selected then
                      if (t.Top >= Bnd.y) and (t.Top < Bnd.y + Bnd.dy - 1) then
                        begin
                          t.Parent := Bnd;
                          t.Top := t.Top - Bnd.y;
                          t.Selected := False;
                          Bnd.Objects.Add(t);
                        end;
                end;
              for j := 0 to Objects.Count - 1 do
                // placing ColumnXXX objects over band
                begin
                  t := Objects[j];
                  if t.Parent <> nil then
                    if t.Selected then
                      if (t.Top >= Bnd.y) and (t.Top < Bnd.y + Bnd.dy - 1) then
                        begin
                          t.Top := t.Top - Bnd.y;
                          t.Selected := False;
                          Bnd.Objects.Add(t);
                        end;
                end;
              for j := 0 to Objects.Count - 1 do // placing subreports over band
                begin
                  t := Objects[j];
                  if (t.Parent = nil) and (t.Typ = gtSubReport) then
                    if t.Selected then
                      if (t.Top >= Bnd.y) and (t.Top < Bnd.y + Bnd.dy - 1) then
                        begin
                          t.Parent := Bnd;
                          t.Top := t.Top - Bnd.y;
                          t.Selected := False;
                          Bnd.Objects.Add(t);
                        end;
                end;
            end;
        end;
      for i := 0 to Last - 1 do // sorting bands
        begin
          miny := BArr[i].y;
          n := i;
          for j := i + 1 to Last - 1 do
            if BArr[j].y < miny then
              begin
                miny := BArr[j].y;
                n := j;
              end;
          Bnd := BArr[i];
          BArr[i] := BArr[n];
          BArr[n] := Bnd;
        end;
      Bnd := BArr[0];
      Bands[b] := Bnd;
      Bnd.Prev := nil;
      for i := 1 to Last - 1 do // finally ordering
        begin
          Bnd.Next := BArr[i];
          Bnd := Bnd.Next;
          Bnd.Prev := BArr[i - 1];
        end;
      Bnd.Next := nil;
      Bands[b].LastBand := Bnd;
    end;

  for i := 0 to Objects.Count - 1 do // place other objects on btNone band
    begin
      t := Objects[i];
      if t.Selected then
        begin
          if t.Parent <> nil then t.Left := t.Parent.x + t.Left;
          t.Parent := Bands[btNone];
          Bands[btNone].y := 0;
          Bands[btNone].Objects.Add(t);
        end;
    end;

  Bi := 0;
  Bnd := Bands[btGroupHeader].LastBand;
  Bnd1 := Bands[btGroupFooter];
  repeat
    Bnd.FooterBand := Bnd1;
    Bnd.Num := Bi;
    Bnd1.Num := Bi;
    Inc(Bi);
    Bnd := Bnd.Prev;
    Bnd1 := Bnd1.Next;
  until (Bnd = nil) or (Bnd1 = nil);

  if ColCount = 0 then ColCount := 1;

  // Solvet the ColGap problem...
  ColWidth := (RightMargin - LeftMargin {- ColCount * ColGap}) div ColCount;

  // Initialize all DataSet present into the bands.
  CurPage := Self;
  CurView := TfrMemoView.Create(nil);
  for I := 0 to List.Count - 1 do
    begin
      if not ErrorFlag then
        begin
          CurView.OriginalBandViewType :=
            TfrBandView(TfrBand(List.Objects[0]).ParentView).BandType;
          TfrBand(List.Objects[0]).
            InitDataSet(TfrBand(List.Objects[0]).ParentView.FormatStr);
        end;
      List.Delete(0);
    end;
  CurView.Free;
  CurView := nil;
  List.Free;
end;

procedure TfrPage.ShowBand(b: TfrBand);
begin
  if b <> nil then
    if Mode = pmBuildList then
      AddRecord(b, rtShowBand)
    else
      b.Draw;
end;

procedure TfrPage.AddRecord(b: TfrBand; rt: TfrBandRecType);
var
  p: PfrBandRec;
begin
  GetMem(p, SizeOf(TfrBandRec));
  p^.Band := b;
  p^.Action := rt;
  List.Add(p);
end;

procedure TfrPage.ClearRecList;
var
  i: Integer;
begin
  for i := 0 to List.Count - 1 do
    FreeMem(PfrBandRec(List[i]), SizeOf(TfrBandRec));
  List.Clear;
end;

procedure TfrPage.CompleteBandList(B: TfrBand);
const
  MAXBNDS = 3;
  Bnds: array[1..MAXBNDS, TfrBandParts] of TfrBandType =
  ((btMasterHeader, btMasterData, btMasterFooter),
    (btDetailHeader, btDetailData, btDetailFooter),
    (btSubDetailHeader, btSubDetailData, btSubDetailFooter));

var
  H, J: Integer;

  function ToEOF(Ds: TfrDataSet): Boolean;
  begin
    if Ds.RangeEnd = reCount then
      Result := Ds.RecordNo >= Ds.RangeEndCount - 1
    else
      if Ds.InheritsFrom(TfrDBDataSet) then
        Result := Ds.RecordNo >= Real_Record_Count(TfrDBDataSet(Ds).DataSet) - 1
      else
        Result := False;
  end;

begin
  H := 0;
  for J := 1 to CurLevel do
    if ToEOF(Bands[Bnds[J, bpData]].DataSet) then
      Inc(H, Bands[Bnds[J, bpFooter]].CalcHeight);
  B.CompleteProcess := True;
  while CurBottomY - CurY - H >= B.Dy do
    B.Draw;
  B.CompleteProcess := False;
end;

function TfrPage.PlayRecList: Boolean;
var
  p: PfrBandRec;
  b, LastCompleteBand: TfrBand;
begin
  LastCompleteBand := nil;
  Result := False;
  while PlayFrom < List.Count do
    begin
      p := List[PlayFrom];
      b := p^.Band;
      case p^.Action of
        rtShowBand:
          begin
            if LastBand <> nil then
              begin
                LastBand.DoSubReports;
                if LastBand <> nil then
                  begin
                    Result := True;
                    Exit;
                  end;
              end
            else
              if (LastCompleteBand <> nil) and (not B.CompleteList) then
                begin
                  CompleteBandList(LastCompleteBand);
                  LastCompleteBand := nil;
                end;
            if (B.CompleteList) and (LastCompleteBand = nil) then
              LastCompleteBand := B;
            if b.Draw then
              begin
                Result := True;
                Exit;
              end;
          end;
        rtFirst:
          begin
            b.DataSet.First;
            CheckBandEvent(b, opFirst);
            CheckAggregateFunctions(b, opFirst);
            b.Positions[psLocal] := 1;
          end;
        rtNext:
          begin
            b.DataSet.Next;
            CheckBandEvent(b, opNext);
            CheckAggregateFunctions(b, opNext);
            Inc(CurPos);
            Inc(b.Positions[psGlobal]);
            Inc(b.Positions[psLocal]);
          end;
      end;
      Inc(PlayFrom);
    end;
  if LastCompleteBand <> nil then CompleteBandList(LastCompleteBand);
end;

procedure TfrPage.DrawPageFooters(FreeCanvases: Boolean);
begin
  CurColumn := 0;
  XAdjust := LeftMargin;
  while (PageNo < MasterReport.EMFPages.Count) and
    (MasterReport.EMFPages[PageNo].Pict <> nil) do
    begin
      MCanvas := MasterReport.EMFPages[PageNo].Canvas;
      if not (Append and WasPF) then
        ShowBand(Bands[btPageFooter]);
      if FreeCanvases then
        if MasterReport.EMFPages[PageNo].Canvas <> nil then
          begin
            MasterReport.EMFPages[PageNo].Canvas.Free;
            MasterReport.EMFPages[PageNo].Canvas := nil;
          end;
      Inc(PageNo);
    end;
end;

procedure TfrPage.NewPage;
begin
  CurReport.InternalOnProgress(PageNo + 1);
  ShowBand(Bands[btStaticColumnFooter]);
  DrawPageFooters(True);
  CurBottomY := BottomMargin;
  MasterReport.EMFPages.Add(Self);
  Append := False;
  ShowBand(Bands[btOverlay]);
  CurY := TopMargin;
  ShowBand(Bands[btPageHeader]);
  ShowBand(Bands[btStaticColumnHeader]);
end;

procedure TfrPage.FormPage;
const
  MAXBNDS = 3;
  Bnds: array[1..MAXBNDS, TfrBandParts] of TfrBandType =
  ((btMasterHeader, btMasterData, btMasterFooter),
    (btDetailHeader, btDetailData, btDetailFooter),
    (btSubDetailHeader, btSubDetailData, btSubDetailFooter));
var
  BndStack: array[1..MAXBNDS * 3] of TfrBand;
  MaxLevel, BndStackTop: Integer;
  i, sfPage: Integer;
  HasGroups: Boolean;
  procedure AddToStack(b: TfrBand);
  begin
    if b <> nil then
      begin
        Inc(BndStackTop);
        BndStack[BndStackTop] := b;
      end;
  end;

  procedure ShowStack;
  var
    i: Integer;
  begin
    for i := 1 to BndStackTop do
      if BandExists(BndStack[i]) then
        ShowBand(BndStack[i]);
    BndStackTop := 0;
  end;

  procedure DoLoop(Level: Integer);
  var
    WasPrinted, CheckGroup, CompletedFinish: Boolean;
    b, b1, b2: TfrBand;
    H: Integer;

    procedure InitGroups(b: TfrBand);
    begin
      b.InitGroupValues;
      while b <> nil do
        begin
          Inc(b.Positions[psLocal]);
          Inc(b.Positions[psGlobal]);
          ShowBand(b);
          b := b.Next;
        end;
    end;

    procedure AddHeadersOfBand(b: TfrBand; ShowNow: boolean);
    var
      Ymin, Ymax: integer;
      b1: TfrBand;
    begin
      if Assigned(b.Prev) then
        Ymin := b.Prev.y
      else
        Ymin := 0;
      Ymax := b.y;
      b1 := Bands[Bnds[Level, bpHeader]];
      while Assigned(b1) do
        begin
          if (b1.y > Ymin) and (b1.y < Ymax) then
            if ShowNow then
              ShowBand(b1)
            else
              AddToStack(b1);
          b1 := b1.Next;
        end;
    end;

    procedure AddFootersOfBand(b: TfrBand; ShowNow: boolean);
    var
      Ymin, Ymax: integer;
      b1: TfrBand;
    begin
      if Assigned(b.Next) then
        Ymax := b.Next.y
      else
        Ymax := MaxInt;
      Ymin := b.y;
      b1 := Bands[Bnds[Level, bpFooter]];
      while Assigned(b1) do
        begin
          if (b1.y > Ymin) and (b1.y < Ymax) then
            if ShowNow then
              ShowBand(b1)
            else
              AddToStack(b1);
          b1 := b1.Next;
        end;
    end;

  begin
    CurLevel := Level;
    CompletedFinish := False;
    b := Bands[Bnds[Level, bpData]];
    while (b <> nil) and (b.Dataset <> nil) do
      begin
        CurBand := b;
        //      CurView:=Nil;
        b.DataSet.First;
        CheckBandEvent(b, opFirst);
        CheckAggregateFunctions(b, opFirst);
        if Mode = pmBuildList then
          AddRecord(b, rtFirst)
        else
          b.Positions[psLocal] := 1;

        b1 := Bands[btGroupHeader];
        while b1 <> nil do
          begin
            b1.Positions[psLocal] := 0;
            b1.Positions[psGlobal] := 0;
            b1 := b1.Next;
          end;

        if not b.DataSet.EOF then
          begin
            if (Level = 1) and HasGroups then
              InitGroups(Bands[btGroupHeader]);
            //        AddToStack(Bands[Bnds[Level,bpHeader]]);
            AddHeadersOfBand(b, false); // fix
            while not b.DataSet.EOF do
              begin
                Application.ProcessMessages;
                if MasterReport.Terminated then break;
                AddToStack(b);
                WasPrinted := True;
                if Level < MaxLevel then
                  begin
                    DoLoop(Level + 1);
                    if BndStackTop > 0 then
                      if b.PrintIfSubsetEmpty then
                        ShowStack
                      else
                        begin
                          Dec(BndStackTop);
                          WasPrinted := False;
                        end;
                  end
                else
                  ShowStack;

                if (Level = 1) and HasGroups then
                  begin
                    b1 := Bands[btGroupFooter];
                    while b1 <> nil do
                      begin
                        b1.DoAggregate;
                        b1 := b1.Next;
                      end;
                  end;

                b.DataSet.Next;
                CheckBandEvent(b, opNext);

                CheckGroup := False;

                if (Level = 1) and HasGroups then
                  begin
                    b1 := Bands[btGroupHeader];
                    while (b1 <> nil) and (Trim(b1.GroupCondition) <> '') do
                      begin
                        if (Calc(b1.GroupCondition) <> b1.LastGroupValue) or
                          (b.DataSet.EOF) then
                          begin

                            if B.CompleteList then
                              begin
                                H := Bands[Bnds[Level, bpFooter]].CalcHeight;
                                b2 := Bands[btGroupHeader].LastBand;
                                while b2 <> b1 do
                                  begin
                                    Inc(H, b2.FooterBand.CalcHeight);
                                    b2 := b2.Prev;
                                  end;
                                Inc(H, b1.FooterBand.CalcHeight);
                                B.CompleteProcess := True;
                                while CurBottomY - CurY - H >= B.Dy do
                                  ShowBand(B);
                                B.CompleteProcess := False;
                                CompletedFinish := True;
                              end;
                            //                ShowBand(Bands[Bnds[Level,bpFooter]]);
                            AddFootersOfBand(b, true); // fix
                            b2 := Bands[btGroupHeader].LastBand;
                            while b2 <> b1 do
                              begin
                                ShowBand(b2.FooterBand);
                                b2.Positions[psLocal] := 0;
                                b2 := b2.Prev;
                              end;
                            ShowBand(b1.FooterBand);

                            if not b.DataSet.EOF then
                              begin
                                if not b.DataSet.EOF and b1.NewPageAfter then
                                  NewPage;
                                InitGroups(b1);
                                ClearValues(Bands[btMasterData], b1.Num);
                                AddValues(Bands[btMasterData]);
                                CheckGroup := True;
                                //                    ShowBand(Bands[Bnds[Level,bpHeader]]);
                                AddHeadersOfBand(b, true); // fix
                              end;
                            b.Positions[psLocal] := 0;
                            break;
                          end;
                        b1 := b1.Next;
                      end;
                  end;

                if not CheckGroup then CheckAggregateFunctions(b, opNext);

                if Mode = pmBuildList then
                  AddRecord(b, rtNext)
                else
                  if WasPrinted then
                    begin
                      Inc(CurPos);
                      Inc(b.Positions[psGlobal]);
                      Inc(b.Positions[psLocal]);
                      if not b.DataSet.EOF and b.NewPageAfter then NewPage;
                    end;
                if MasterReport.Terminated then break;
              end;
            if BndStackTop = 0 then
              begin
                if (Mode <> pmBuildList) and (not CompletedFinish) and
                  (B.CompleteList) then
                  begin
                    CompleteBandList(B);
                    CompletedFinish := True;
                  end;
                //            ShowBand(Bands[Bnds[Level,bpFooter]]);
                AddFootersOfBand(b, true) // fix
              end
            else
              Dec(BndStackTop);
          end;
        b := b.Next;
      end;
  end;

begin
  if Mode = pmNormal then
    begin
      if Append then
        if PrevY = PrevBottomY then
          begin
            Append := False;
            WasPF := False;
            while (PageNo < MasterReport.EMFPages.Count) and
              (MasterReport.EMFPages[PageNo].Pict <> nil) do
              begin
                if MasterReport.EMFPages[PageNo].Canvas <> nil then
                  begin
                    MasterReport.EMFPages[PageNo].Canvas.Free;
                    MasterReport.EMFPages[PageNo].Canvas := nil;
                  end;
                Inc(PageNo);
              end;
          end;
      if Append and WasPF then
        CurBottomY := PrevBottomY
      else
        CurBottomY := BottomMargin;
      if not Append then
        begin
          MasterReport.EMFPages.Add(Self);
          CurY := TopMargin;
          ShowBand(Bands[btOverlay]);
          ShowBand(Bands[btNone]);
        end
      else
        CurY := PrevY;
      CurColumn := 0;
      XAdjust := LeftMargin;
      if (BandExists(Bands[btColumnData])) and
        (CurPage.Bands[btColumnData].DataSet <> nil) and
        (CurBand.Typ <> btMasterData) and
        (CurBand.Y < CurPage.Bands[btMasterData].Y) and
        (CurPage.Bands[btMasterData].DataSet <> nil) then
        CurPage.Bands[btMasterData].DataSet.First;
      ShowBand(Bands[btReportTitle]);
      if BandExists(Bands[btPageHeader]) and PHonFirst then
        ShowBand(Bands[btPageHeader]);
      ShowBand(Bands[btStaticColumnHeader]);
    end;

  BndStackTop := 0;
  for i := 1 to MAXBNDS do
    if BandExists(Bands[Bnds[i, bpData]]) then
      MaxLevel := i;
  HasGroups := Bands[btGroupHeader].Objects.Count > 0;
  DoLoop(1);
  if Mode = pmNormal then
    begin
      ShowBand(Bands[btStaticColumnFooter]);
      ShowBand(Bands[btReportSummary]);
      PrevY := CurY;
      PrevBottomY := CurBottomY;
      if CurColumn > 0 then
        PrevY := BottomMargin;
      CurColumn := 0;
      XAdjust := LeftMargin;
      sfPage := PageNo;
      WasPF := False;
      if PFonLast then
        begin
          WasPF := BandExists(Bands[btPageFooter]);
          if WasPF then DrawPageFooters(False);
        end;
      PageNo := sfPage + 1;
    end;
end;

function TfrPage.BandExists(b: TfrBand): Boolean;
begin
  Result := b.Objects.Count > 0;
end;

procedure TfrPage.LoadFromStream(Stream: TStream);
var
  b: Byte;
  w: word;
begin
   With Stream do
   begin
      Read(pgSize, 4);
      Read(pgWidth, 4);
      Read(pgHeight, 4);
      Read(pgMargins, Sizeof(pgMargins));
      Read(b, 1);
      pgOr := TPrinterOrientation(b);
      Read(PHonFirst, 2);
      Read(PFonLast, 2);
      Read(CHCopy, 2);
      Read(PrintToPrevPage, 2);
      if frVersion <= 28 then
      begin
          Read(w, 2); // Read the old UseMargins
      end;
      Read(ColCount, 4);
      Read(ColGap, 4);
      if frVersion >= 25 then
      begin
          Read(ZoomX, 4);
          Read(ZoomY, 4);
      end;
   end;
   ChangePaper(pgSize, pgWidth, pgHeight, pgOr);
end;

procedure TfrPage.SaveToStream(Stream: TStream);
var
  b: Byte;
begin
  with Stream do
    begin
      Write(pgSize, 4);
      Write(pgWidth, 4);
      Write(pgHeight, 4);
      Write(pgMargins, Sizeof(pgMargins));
      b := Byte(pgOr);
      Write(b, 1);
      Write(PHonFirst, 2);
      Write(PFonLast, 2);
      Write(CHCopy, 2);
      Write(PrintToPrevPage, 2);
      Write(ColCount, 4);
      Write(ColGap, 4);
      Write(ZoomX, 4);
      Write(ZoomY, 4);
    end;
end;

{-----------------------------------------------------------------------}
constructor TfrPages.Create(AOwner:TComponent);
begin
  inherited Create(TfrReport(AOwner));
  Parent := TfrReport(AOwner);
  FPages := TList.Create;
end;

destructor TfrPages.Destroy;
begin
  Clear;
  FPages.Free;
  inherited Destroy;
end;

function TfrPages.GetCount: Integer;
begin
  Result := FPages.Count;
end;

function TfrPages.GetPages(Index: Integer): TfrPage;
begin
  Result := FPages[Index];
end;

procedure TfrPages.Clear;
var
  i: Integer;
begin
  i := 0;
  while i <= FPages.Count - 1 do
    begin
      Pages[i].Free;
      inc(i);
    end;
  FPages.Clear;
end;

procedure TfrPages.Add;
begin
  FPages.Add(TfrPage.Create(9, 0, 0, poPortrait, Parent));
end;

procedure TfrPages.Delete(Index: Integer);
var
  i, j: integer;
  t: TfrView;
  s: TfrSubReportView;
  del: boolean;
begin
  del := false;
  Pages[Index].Free;
  FPages.Delete(Index);
  for i := 0 to Index - 1 do
    begin
      j := 0;
      while j <= Pages[i].Objects.Count - 1 do
        begin
          t := Pages[i].Objects[j];
          if t is TfrSubReportView then
            begin
              s := TfrSubReportView(t);

              // Delete the SubReport...
              if s.SubPage = Index then
                begin
                  if not s.Deleting then
                    begin
                      Pages[i].Objects.Delete(j);
                      s.Deleting := true;
                      s.free;
                      del := true;
                    end;
                end
              else

                // Shift the SubReport page...
                if s.SubPage > Index then
                  begin
                    s.SubPage := s.SubPage - 1;
                  end;
            end;
          if not del then
            inc(j)
          else
            del := false;
        end;
    end;
end;

procedure TfrPages.LoadFromStream(Stream: TStream);
var
  b: Byte;
  t: TfrView;
  w: word;
  procedure AddObject(ot: Byte; clname: string);
  begin
    Stream.Read(b, 1);
    Pages[b].Objects.Add(frCreateObject(ot, clname));
    t := Pages[b].Objects.Items[Pages[b].Objects.Count - 1];
  end;
begin
  Clear;
  if frVersion <= 28 then
  begin
     Stream.Read(w, 2); // Read the old "PrintToDefault" property.
  end;
  //
  Stream.Read(Parent.DoublePass, 2);
  if frVersion > 22 then
  begin
     Stream.Read(Parent.Fascicoli, 2);
     Stream.Read(Parent.Reimpose, 2);
  end
  else
  begin
      Parent.Fascicoli := False;
      Parent.Reimpose := False;
  end;
  if frVersion <= 28 then
  begin
      frReadMemo(Stream, SMemo);
  end;
  //
  while Stream.Position < Stream.Size do
  begin
      Stream.Read(b, 1);
      if b = $FF then // page info
        begin
          Add;
          Pages[Count - 1].LoadFromStream(Stream);
        end
      else
        if b = $FE then // values
          begin
            Parent.FVal.ReadBinaryData(Stream);
            frReadMemo(Stream, SMemo);
            Parent.Variables.Assign(SMemo);
          end
        else
          begin
            if b > Integer(gtAddIn) then break;
            if b = gtAddIn then
              begin
                frReadMemo(Stream, SMemo);
                AddObject(gtAddIn, SMemo[0]);
              end
            else
              AddObject(b, '');
            t.LoadFromStream(Stream);
          end;
    end;
end;

procedure TfrPages.SaveToStream(Stream: TStream);
var
  b: Byte;
  i, j: Integer;
  t: TfrView;
begin
  Stream.Write(Parent.DoublePass, 2);
  if frVersion > 22 then
    begin
      Stream.Write(Parent.Fascicoli, 2);
      Stream.Write(Parent.Reimpose, 2);
    end;
  for i := 0 to Count - 1 do // adding pages first
    begin
      b := $FF;
      Stream.Write(b, 1); // page info
      Pages[i].SaveToStream(Stream);
    end;
  for i := 0 to Count - 1 do
    begin
      for j := 0 to Pages[i].Objects.Count - 1 do // then adding objects
        begin
          t := Pages[i].Objects[j];
          b := Byte(t.Typ);
          Stream.Write(b, 1);
          if t.Typ = gtAddIn then
            begin
              SMemo.Clear;
              SMemo.Add(t.ClassName);
              frWriteMemo(Stream, SMemo);
            end;
          Stream.Write(i, 1);
          t.SaveToStream(Stream);
        end;
    end;
  b := $FE;
  Stream.Write(b, 1);
  Parent.FVal.WriteBinaryData(Stream);
  SMemo.Assign(Parent.Variables);
  frWriteMemo(Stream, SMemo);
end;

{-----------------------------------------------------------------------}

constructor TfrEMFPages.Create(AOwner: TComponent);
begin
  inherited Create(TfrReport(AOwner));
  Parent := TfrReport(AOwner);
  FPages := TList.Create;
end;

destructor TfrEMFPages.Destroy;
begin
  Clear;
  FPages.Free;
  inherited Destroy;
end;

function TfrEMFPages.GetCount: Integer;
begin
  if FPages <> nil then
    Result := FPages.Count
  else
    Result := 0;
end;

function TfrEMFPages.GetPages(Index: Integer): PfrPageInfo;
begin
  Result := FPages[Index];
end;

procedure TfrEMFPages.Clear;
var
  i: Integer;
begin
   for i := 0 to FPages.Count - 1 do
   begin
      if Pages[i]^.Pict <> nil then Pages[i]^.Pict.Free;
      Pages[i]^.Pict := nil;
      FreeMem(Pages[i], SizeOf(TfrPageInfo));
   end;
   FPages.Clear;
end;

procedure TfrEMFPages.Add(Page: TfrPage);
Var
   p     : PfrPageInfo;
   X, Y  : Double;
begin
   X := 100 / Page.ZoomX;
   Y := 100 / Page.ZoomY;
   GetMem(p, SizeOf(TfrPageInfo));
   FPages.Add(p);
   with p^ do
   begin
      Pict := TMetafile.Create;
      if (X = 1) and (Y = 1) then
        pgSize := Page.pgSize
      else
        pgSize := pgCustomSize;
      pgWidth := Round(Page.pgWidth / X);
      pgHeight := Round(Page.pgHeight / Y);
      pgOr := Page.pgOr;
      pgMargins := True;
      PrnInfo := Page.PrnInfo;
      // Zoom X
      PrnInfo.Pgw := Round(PrnInfo.Pgw / X);
      PrnInfo.Pw := Round(PrnInfo.Pw / X);
      // Zoom Y
      PrnInfo.Pgh := Round(PrnInfo.Pgh / Y);
      PrnInfo.Ph := Round(PrnInfo.Ph / Y);
      // Zoom X
      Pict.Width := Round(PrnInfo.Pgw * X);
      // Zoom Y
      Pict.Height := Round(PrnInfo.Pgh * Y);
      Canvas := TMetafileCanvas.Create(Pict, 0);
      MCanvas := Canvas;
      if frCharset <> DEFAULT_CHARSET then
        Canvas.Font.Charset := frCharset;
   end;
End;

procedure TfrEMFPages.LoadFromStream(Stream: TStream);
var
  i, o, c: Integer;
  b: Byte;
  p: PfrPageInfo;
begin
  Clear;
  frReadMemo(Stream, SMemo);
  Stream.Read(c, 4);
  i := 0;
  repeat
    Stream.Read(o, 4);
    GetMem(p, SizeOf(TfrPageInfo));
    FPages.Add(p);
    With p^ do
    begin
        Stream.Read(pgSize, 2);
        Stream.Read(pgWidth, 4);
        Stream.Read(pgHeight, 4);
        Stream.Read(b, 1);
        pgOr := TPrinterOrientation(b);
        Stream.Read(b, 1);
        pgMargins := Boolean(b);
        Pict := TMetaFile.Create;
        Pict.LoadFromStream(Stream);
        PrinterSettings.SetPrinterInfo(pgSize, pgWidth, pgHeight, pgOr);
        PrinterSettings.FillPrnInfo(PrnInfo);
    End;
    Stream.Seek(o, soFromBeginning);
    Inc(i);
  until i >= c;
end;

procedure TfrEMFPages.SaveToStream(Stream: TStream);
var
  i, o, n: Integer;
  b: Byte;
begin
  SMemo.Clear;
  frWriteMemo(Stream, SMemo);
  n := Count;
  Stream.Write(n, 4);
  i := 0;
  repeat
    o := Stream.Position;
    Stream.Write(o, 4); // dummy write
    with Pages[i]^ do
      begin
        Stream.Write(pgSize, 2);
        Stream.Write(pgWidth, 4);
        Stream.Write(pgHeight, 4);
        b := Byte(pgOr);
        Stream.Write(b, 1);
        b := Byte(pgMargins);
        Stream.Write(b, 1);
        Pict.SaveToStream(Stream);
      end;
    n := Stream.Position;
    Stream.Seek(o, soFromBeginning);
    Stream.Write(n, 4);
    Stream.Seek(0, soFromEnd);
    Inc(i);
  until i >= Count;
end;

{-----------------------------------------------------------------------}
constructor TfrValues.Create;
begin
  inherited Create;
  FItems := TStringList.Create;
end;

destructor TfrValues.Destroy;
begin
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TfrValues.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadBinaryData, WriteBinaryData,
    FItems.Count > 0);
end;

procedure TfrValues.WriteBinaryData(Stream: TStream);   //Itta
Var
   i, n : Integer;
   Ax   : AnsiString;
   procedure WriteStr(s: AnsiString);
   Var
      c : Integer;
   begin
      c := Length(s);
      Stream.WriteBuffer(c, 1);
      Stream.WriteBuffer(PAnsiChar(s)^, c);
   End;
begin
   with Stream do
   begin
      n := FItems.Count;
      WriteBuffer(n, SizeOf(n));
      for i := 0 to n - 1 do
        with Objects[i] do
          begin
            WriteBuffer(Typ, SizeOf(Typ));
            WriteBuffer(OtherKind, SizeOf(OtherKind));
            Ax:=UTF8Encode(DataSet);
            WriteStr(Ax);
            Ax:=UTF8Encode(Field);
            WriteStr(Ax);
            Ax:=UTF8Encode(FItems[i]);
            WriteStr(Ax);
          end;
    end;
end;

procedure TfrValues.ReadBinaryData(Stream: TStream);     //Itta
var
   i, j,
   n     : Integer;
   Ax    : AnsiString;
   Function ReadStr: AnsiString;
   var
      c : Integer;
   begin
      c := 0;
      Stream.ReadBuffer(c, 1);
      SetLength(Result, c);
      Stream.ReadBuffer(PAnsiChar(Result)^, c);
   End;
Begin
   Clear;
   FItems.Sorted:=False;
   With Stream do
   begin
      ReadBuffer(n, SizeOf(n));
      For i := 0 to n - 1 do
      begin
         j:=AddValue;
         With Objects[j] do
         Begin
            ReadBuffer(Typ,SizeOf(Typ));
            ReadBuffer(OtherKind,SizeOf(OtherKind));
            Ax:=ReadStr;
            DataSet:=UTF8ToString(Ax);
            Ax:=ReadStr;
            Field:=UTF8ToString(Ax);
            Ax:=ReadStr;
            FItems[j]:=UTF8ToString(Ax);
         End;
      End;
   End;
End;

function TfrValues.GetValue(Index: Integer): TfrValue;
begin
  Result := TfrValue(FItems.Objects[Index]);
end;

function TfrValues.AddValue: Integer;
begin
  Result := FItems.AddObject('', TfrValue.Create);
end;

procedure TfrValues.Clear;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    TfrValue(FItems.Objects[i]).Free;
  FItems.Clear;
end;

function TfrValues.FindVariable(const s: string): TfrValue;
var
  i  : Integer;
begin
  Result := nil;
  i := FItems.IndexOf(s);
  if i <> -1 then
    Result := Objects[i];
end;

{----------------------------------------------------------------------------}
constructor TfrReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsSequenced := True;
  FPixelsPerInch := Screen.PixelsPerInch;
  FScaled := True;
  FAutoLoad := '';
  FReportDir := '';
  FDsgOptions := [doSaveConfirm];
  FDisableDataSetControls := True;
  FModalPreview := True;
  DataSetList := TStringList.Create;
  DataSetList.Sorted := True;
  FPages := TfrPages.Create(Self);
  FEMFPages := TfrEMFPages.Create(Self);
  FVars := TStringList.Create;
  FVal := TfrValues.Create;
  FShowProgress := True;
  CurReport := Self;
  AssignNewFunction(SearchFunction);         

  NewReport;
end;

destructor TfrReport.Destroy;
begin
  CurReport:=Self;
  If Assigned(FVal) Then
     FreeAndNil(FVal);
  If Assigned(FVars) Then
     FreeAndNil(FVars);
{
  If Assigned(FEMFPages) Then
     FreeAndNil(FEMFPages);
  If Assigned(FPages) Then
     FreeAndNil(FPages);
}
  ClearDataSetList;
  CurReport := nil;
  inherited Destroy;
end;

procedure TfrReport.NewReport;
begin
  FEMFPages.Clear;
  FPages.Clear;
  FPages.Add; // Add new blank page
  FVars.Clear;
  FVal.Clear;
  Fascicoli := False;
  Reimpose := False;
  DoublePass := False;
  FileName := '';
  ClearDataSetList;
end;

procedure TfrReport.SetAutoLoad(Value: string);
begin
  if Value <> FAutoLoad then
    begin
      FAutoLoad := Value;
      if Value <> '' then
        LoadFromFile(Value)
      else
        NewReport;
    end;
end;

procedure TfrReport.ResetStatistic(ID: string; var V: Variant);
begin
  if (ID = 'SUM') or (ID = 'AVG') then
    V := 0
  else
    if ID = 'MIN' then
      V := 1E200
    else
      V := -1E200;
end;

procedure TfrReport.WritePixelsPerInch(Writer: TWriter);
begin
  Writer.WriteInteger(FPixelsPerInch);
end;

procedure TfrReport.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadBinaryData, WriteBinaryData, FVars.Count > 0);
  Filer.DefineProperty('PixelsPerInch', nil, WritePixelsPerInch, True);
end;

procedure TfrReport.WriteBinaryData(Stream: TStream);
var
  i, n: Integer;
  procedure WriteStr(s: string);
  var
    c: Integer;
  begin
    c := Length(s);
    Stream.WriteBuffer(c, 1);
    Stream.WriteBuffer(PChar(s)^, c);
  end;
begin
  n := FVars.Count;
  Stream.WriteBuffer(n, SizeOf(n));
  for i := 0 to n - 1 do
    WriteStr(FVars[i]);
end;

procedure TfrReport.ReadBinaryData(Stream: TStream);
var
  i, n: Integer;
  function ReadStr: string;
  var
    c: Integer;
  begin
    c := 0;
    Stream.ReadBuffer(c, 1);
    SetLength(Result, c);
    Stream.ReadBuffer(PChar(Result)^, c);
  end;
begin
  FVars.Clear;

  Stream.ReadBuffer(n, SizeOf(n));
  for i := 0 to n - 1 do
    FVars.Add(ReadStr);
end;

procedure TfrReport.CheckAutoLoad;
begin
  if FAutoLoad <> '' then
    if FileDateTime(FInternalAutoLoad) <> FInternalAutoLoadDateTime then
      LoadFromFile(FInternalAutoLoad);
end;

//report building events
procedure TfrReport.InternalOnDrawObject(View: TfrView);
begin
  if Assigned(FOnDrawObject) then FOnDrawObject(View);
end;

procedure TfrReport.InternalOnDrawedObject(View: TfrView);
begin
  if Assigned(FOnDrawedObject) then FOnDrawedObject(View);
end;

procedure TfrReport.InternalOnProgress(Percent: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Percent)
  else
    if FShowProgress then
      with ProgressForm do
        begin
          if (MasterReport <> nil) and (MasterReport.DoublePass) and
            (MasterReport.FinalPass) then
            Label1.Caption := FirstCaption + '  ' + IntToStr(Percent) + ' ' +
              FRConst_From + ' ' + IntToStr(SavedAllPages)
          else
            Label1.Caption := FirstCaption + '  ' + IntToStr(Percent);
          Application.ProcessMessages;
        end;
end;

function TfrReport.SearchFunction(Id: string; ParameterList: TStringList): Variant;
var
  V: TfrValue;
  Identifier, S, Fnc: string;
  DataSet: TDataSet;
  Vr, P1, P2, P3, Total: Variant;
  FnN, I, J, A, B: Integer;
  SL: TList;
  PV: ^Variant;
  Old: Byte;

  function CalcFillStr(X: Integer; Y: string): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to X do
      Result := Result + Y;
  end;

  function CalcCeil(X: Extended): Integer;
  begin
    Result := Integer(Trunc(X));
    if Frac(X) > 0 then Inc(Result);
  end;

  function CalcFloor(X: Extended): Integer;
  begin
    Result := Integer(Trunc(X));
    if Frac(X) < 0 then Dec(Result);
  end;

  function PhraseName(S: string): string;
  const
    NameChars = ['a'..'z', 'A'..'Z'];
  var
    I: Integer;
    C: Char;
  begin
    S := LowerCase(S);
    C := #0;
    for I := 1 to Length(S) do
      begin
        if not CharInSet(C,NameChars) then S[I]:=UpCase(S[I]);
        //if not (C in NameChars) then S[I] := UpCase(S[I]);
        C := S[I];
      end;
    Result := S;
  end;

  function NumberToLetter(A: Currency): string;
  var
    I, P: Integer;
    S, S1, R, L, Decimal, DecimalStr: string;
    Neg: Boolean;
  begin
    S := CurrToStr(A);
    Neg := S[1] = '-';
    if Neg then S := Copy(S, 2, Length(S) - 1);
    if Pos(FormatSettings.DecimalSeparator, S) > 0 then
      begin
        Decimal := '';
        DecimalStr := Copy(S, Pos(FormatSettings.DecimalSeparator, S) + 1, Length(S));
        while DecimalStr[1] = '0' do
          begin
            Delete(DecimalStr, 1, 1);
            Decimal := Decimal + FRConst_Zero + ' ';
          end;
        Decimal := Decimal + NumberToLetter(StrToInt(DecimalStr));
        S := Copy(S, 1, Pos(FormatSettings.DecimalSeparator, S) - 1);
      end
    else
      Decimal := '';
    P := 0;
    L := '';
    repeat
      R := '';
      S1 := Copy(S, Length(S) - 2, 3);
      S := Copy(S, 1, Length(S) - 3);
      if (S1 = '1') and (P > 0) then
        R := NumberFunction3[(P - 1) * 2]
      else
        begin
          for I := Length(S1) to 2 do
            S1 := '0' + S1;
          if S1[2] = '1' then
            R := NumberFunction1[StrToInt(Copy(S1, 2, 2))]
          else
            if (S1 = '000') and (S = '') then
              R := FRConst_Zero
            else
              begin
                R := NumberFunction2[StrToInt(Copy(S1, 2, 1))];
                if (S1[3] = '1') or (S1[3] = '8') then R := Copy(R, 1, Length(R) - 1);
                R := R + NumberFunction1[StrToInt(Copy(S1, 3, 1))]
              end;
          if S1[1] = '1' then
            R := FRConst_Hundred + R
          else
            if S1[1] > '1' then
              R := NumberFunction1[StrToInt(Copy(S1, 1, 1))] +
                FRConst_Hundred + R;
          if (P > 0) and (S1 <> '000') then
            R := R + NumberFunction3[(P - 1) * 2 + 1]
        end;
      L := R + L;
      Inc(P)
    until S = '';
    if Decimal <> '' then L := L + ' ' + FRConst_Point + ' ' + Decimal;
    if Neg then L := FRConst_Negative + ' ' + L;
    Result := L;
  end;

  function FindNewPage(PN: Integer): Integer;
  var
    i: Integer;
  begin
    I := 0;
    while NewpageArray[I] <> PN do
      Inc(I);
    Result := I + 1;
  end;

  {$WARNINGS Off}
begin
  Result := UnAssigned;
  if ErrorFlag then Exit;
  Id := Trim(Id);
  Identifier := UpperCase(Id);
  if ParameterList <> nil then
    begin
      try
        FnN := 0;
        if Identifier = 'COUNT' then
          begin
            if ParameterList.Count <= 1 then
              begin
                if ParameterList.Count = 1 then
                  begin
                    GetDefaultData(ParameterList[0], DataSet, CurField);
                    if DataSet <> nil then
                      Result := Real_Record_Count(DataSet)
                    else
                      DoError(FRConst_InvalideParameters + ': ' + Identifier);
                  end
                else
                  begin
                    if CheckColumnBand(btColumnData) then
                      Result := CurPage.Bands[btColumnData].RowCount
                    else
                      case CurBand.Typ of
                        btReportSummary, btPageFooter,
                          btMasterData, btMasterFooter,
                          btStaticColumnFooter, btGroupFooter:
                          Result := CurPage.Bands[btMasterData].DataCount;
                        btDetailData, btDetailFooter:
                          Result := CurPage.Bands[btDetailData].DataCount;
                        btSubDetailData, btSubDetailFooter:
                          Result := CurPage.Bands[btSubDetailData].DataCount;
                        btColumnFooter:
                          Result := CurPage.Bands[btColumnData].RowCount;
                      end;
                    if VarIsEmpty(Result) then DoError(FRConst_FailAggregation + ': ' + Identifier);
                  end;
              end
            else
              DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
          end
        else
          if Identifier = 'SUM' then
            begin
              if ParameterList.Count = 1 then
                FnN := 1
              else
                DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
            end
          else
            if Identifier = 'AVG' then
              begin
                if ParameterList.Count = 1 then
                  FnN := 2
                else
                  DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
              end
            else
              if Identifier = 'MIN' then
                begin
                  if ParameterList.Count = 1 then
                    FnN := 3
                  else
                    DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                end
              else
                if Identifier = 'MAX' then
                  begin
                    if ParameterList.Count = 1 then
                      FnN := 4
                    else
                      DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                  end
                else
                  if Identifier = 'STR' then
                    begin
                      if ParameterList.Count = 1 then
                        begin
                          Result := FloatToStr(Calc(ParameterList[0]));
                        end
                      else
                        DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                    end
                  else
                    if Identifier = 'FILLSTR' then
                      begin
                        if ParameterList.Count = 2 then
                          begin
                            Result := CalcFillStr(Calc(ParameterList[0]), Calc(ParameterList[1]));
                          end
                        else
                          DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                      end
                    else
                      if Identifier = 'CEIL' then
                        begin
                          if ParameterList.Count = 1 then
                            begin
                              Result := CalcCeil(Calc(ParameterList[0]));
                            end
                          else
                            DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                        end
                      else
                        if Identifier = 'FLOOR' then
                          begin
                            if ParameterList.Count = 1 then
                              begin
                                Result := CalcFloor(Calc(ParameterList[0]));
                              end
                            else
                              DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                          end
                        else
                          if Identifier = 'IF' then
                            begin
                              if ParameterList.Count = 3 then
                                begin
                                  if (StatisticBand <> nil) then
                                    begin
                                      Calc(ParameterList[0]);
                                      Calc(ParameterList[1]);
                                      Calc(ParameterList[2]);
                                      Result := 1;
                                    end
                                  else
                                    begin
                                      if Calc(ParameterList[0]) = 1 then
                                        Result := Calc(ParameterList[1])
                                      else
                                        Result := Calc(ParameterList[2]);
                                    end;
                                end
                              else
                                DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                            end
                          else
                            if Identifier = 'INT' then
                              begin
                                if ParameterList.Count = 1 then
                                  begin
                                    Result := Int(Calc(ParameterList[0]));
                                  end
                                else
                                  DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                              end
                            else
                              if Identifier = 'FRAC' then
                                begin
                                  if ParameterList.Count = 1 then
                                    begin
                                      Result := Frac(Calc(ParameterList[0]));
                                    end
                                  else
                                    DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                end
                              else
                                if Identifier = 'ABS' then
                                  begin
                                    if ParameterList.Count = 1 then
                                      begin
                                        Result := Abs(Calc(ParameterList[0]));
                                      end
                                    else
                                      DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                  end
                                else
                                  if Identifier = 'ARCTAN' then
                                    begin
                                      if ParameterList.Count = 1 then
                                        begin
                                          Result := ArcTan(Calc(ParameterList[0]));
                                        end
                                      else
                                        DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                    end
                                  else
                                    if Identifier = 'COS' then
                                      begin
                                        if ParameterList.Count = 1 then
                                          begin
                                            Result := Cos(Calc(ParameterList[0]));
                                          end
                                        else
                                          DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                      end
                                    else
                                      if Identifier = 'EXP' then
                                        begin
                                          if ParameterList.Count = 1 then
                                            begin
                                              Result := Exp(Calc(ParameterList[0]));
                                            end
                                          else
                                            DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                        end
                                      else
                                        if Identifier = 'LN' then
                                          begin
                                            if ParameterList.Count = 1 then
                                              begin
                                                Result := Ln(Calc(ParameterList[0]));
                                              end
                                            else
                                              DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                          end
                                        else
                                          if Identifier = 'SIN' then
                                            begin
                                              if ParameterList.Count = 1 then
                                                begin
                                                  Result := Sin(Calc(ParameterList[0]));
                                                end
                                              else
                                                DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                            end

                                          else
                                            if Identifier = 'SQR' then
                                              begin
                                                if ParameterList.Count = 1 then
                                                  begin
                                                    Result := Sqr(Calc(ParameterList[0]));
                                                  end
                                                else
                                                  DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                              end
                                            else
                                              if Identifier = 'SQRT' then
                                                begin
                                                  if ParameterList.Count = 1 then
                                                    begin
                                                      Result := Sqrt(Calc(ParameterList[0]));
                                                    end
                                                  else
                                                    DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                end
                                              else
                                                if Identifier = 'POS' then
                                                  begin
                                                    if ParameterList.Count = 2 then
                                                      begin
                                                        Result := Pos(Calc(ParameterList[0]), Calc(ParameterList[1]));
                                                      end
                                                    else
                                                      DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                  end
                                                else
                                                  if Identifier = 'LENGTH' then
                                                    begin
                                                      if ParameterList.Count = 1 then
                                                        begin
                                                          Result := Length(Calc(ParameterList[0]));
                                                        end
                                                      else
                                                        DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                    end
                                                  else
                                                    if Identifier = 'ROUND' then
                                                      begin
                                                        if ParameterList.Count = 1 then
                                                          begin
                                                            Result := Integer(Round(Calc(ParameterList[0])));
                                                          end
                                                        else
                                                          DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                      end
                                                    else
                                                      if Identifier = 'TRUNC' then
                                                        begin
                                                          if ParameterList.Count = 1 then
                                                            begin
                                                              Result := Integer(Trunc(Calc(ParameterList[0])));
                                                            end
                                                          else
                                                            DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                        end
                                                      else
                                                        if Identifier = 'POWER' then
                                                          begin
                                                            if ParameterList.Count = 2 then
                                                              begin
                                                                Result := Exp(Calc(ParameterList[1]) * Ln(Calc(ParameterList[0])));
                                                              end
                                                            else
                                                              DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                          end
                                                        else
                                                          if Identifier = 'UPPERCASE' then
                                                            begin
                                                              if ParameterList.Count = 1 then
                                                                begin
                                                                  Result := UpperCase(Calc(ParameterList[0]));
                                                                end
                                                              else
                                                                DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                            end
                                                          else
                                                            if Identifier = 'LOWERCASE' then
                                                              begin
                                                                if ParameterList.Count = 1 then
                                                                  begin
                                                                    Result := UpperCase(Calc(ParameterList[0]));
                                                                  end
                                                                else
                                                                  DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                              end
                                                            else
                                                              if Identifier = 'COPY' then
                                                                begin
                                                                  if ParameterList.Count = 3 then
                                                                    begin
                                                                      A := Calc(ParameterList[1]);
                                                                      B := Calc(ParameterList[2]);
                                                                      Result := Copy(Calc(ParameterList[0]), A, B);
                                                                    end
                                                                  else
                                                                    DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                end
                                                              else
                                                                if Identifier = 'VAL' then
                                                                  begin
                                                                    if ParameterList.Count = 1 then
                                                                      begin
                                                                        Result := StrToFloat(Calc(ParameterList[0]));
                                                                      end
                                                                    else
                                                                      DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                  end
                                                                else
                                                                  if Identifier = 'STRTODATE' then
                                                                    begin
                                                                      if ParameterList.Count = 1 then
                                                                        begin
                                                                          Result := StrToDate(Calc(ParameterList[0]));
                                                                        end
                                                                      else
                                                                        DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                    end
                                                                  else
                                                                    if Identifier = 'STRTOTIME' then
                                                                      begin
                                                                        if ParameterList.Count = 1 then
                                                                          begin
                                                                            Result := StrToTime(Calc(ParameterList[0]));
                                                                          end
                                                                        else
                                                                          DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                      end
                                                                    else
                                                                      if Identifier = 'NAMECASE' then
                                                                        begin
                                                                          if ParameterList.Count = 1 then
                                                                            begin
                                                                              S := Calc(ParameterList[0]);
                                                                              Result := UpperCase(Copy(S, 1, 1)) + LowerCase(Copy(S, 2, Length(S) - 1));
                                                                            end
                                                                          else
                                                                            DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                        end
                                                                      else
                                                                        if Identifier = 'PHRASECASE' then
                                                                          begin
                                                                            if ParameterList.Count = 1 then
                                                                              begin
                                                                                S := Calc(ParameterList[0]);
                                                                                Result := PhraseName(S);
                                                                              end
                                                                            else
                                                                              DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                          end
                                                                        else
                                                                          if Identifier = 'NUMBERTOLETTER' then
                                                                            begin
                                                                              if ParameterList.Count = 1 then
                                                                                begin
                                                                                  Result := NumberToLetter(Calc(ParameterList[0]))
                                                                                end
                                                                              else
                                                                                DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                            end
                                                                          else
                                                                            if Identifier = 'FORMATFLOAT' then
                                                                              begin
                                                                                if ParameterList.Count = 2 then
                                                                                  begin
                                                                                    Result := FormatFloat(Calc(ParameterList[0]), Calc(ParameterList[1]))
                                                                                  end
                                                                                else
                                                                                  DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                              end
                                                                            else
                                                                              if Identifier = 'FORMATDATETIME' then
                                                                                begin
                                                                                  if ParameterList.Count = 2 then
                                                                                    begin
                                                                                      Result := FormatDateTime(Calc(ParameterList[0]), Calc(ParameterList[1]))
                                                                                    end
                                                                                  else
                                                                                    DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                end
                                                                              else
                                                                                if Identifier = 'MONEYTOEURO' then
                                                                                  begin
                                                                                    if ParameterList.Count = 1 then
                                                                                      begin
                                                                                        Result := '€ ' + FloatToStrF(ROUND(Calc(ParameterList[0]) / MoneyToEuro *
                                                                                          100) / 100, ffNumber, 10, 2);
                                                                                      end
                                                                                    else
                                                                                      DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                  end
                                                                                else
                                                                                  if Identifier = 'EURO' then
                                                                                    begin
                                                                                      if ParameterList.Count = 1 then
                                                                                        begin
                                                                                          Result := '€ ' + FloatToStrF(Calc(ParameterList[0]), ffNumber, 10, 2);
                                                                                        end
                                                                                      else
                                                                                        DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                    end
                                                                                  else
                                                                                    if Identifier = 'MONEY' then
                                                                                      begin
                                                                                        if ParameterList.Count = 1 then
                                                                                          begin
                                                                                            Old := FormatSettings.NegCurrFormat;
                                                                                            FormatSettings.NegCurrFormat := 12;
                                                                                            Result := Format('%m', [Currency(Calc(ParameterList[0]))]);
                                                                                            FormatSettings.NegCurrFormat := Old;
                                                                                          end
                                                                                        else
                                                                                          DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                      end
                                                                                    else
                                                                                      if Identifier = 'EUROTOMONEY' then
                                                                                        begin
                                                                                          if ParameterList.Count = 1 then
                                                                                            begin
                                                                                              Old := FormatSettings.NegCurrFormat;
                                                                                              FormatSettings.NegCurrFormat := 12;
                                                                                              Result := Format('%m', [Currency(Calc(ParameterList[0]) * MoneyToEuro)]);
                                                                                              FormatSettings.NegCurrFormat := Old;
                                                                                            end
                                                                                          else
                                                                                            DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                        end
                                                                                      else
                                                                                        if Identifier = 'EUROTOMONEYVAL' then
                                                                                          begin
                                                                                            if ParameterList.Count = 1 then
                                                                                              begin
                                                                                                Result := Calc(ParameterList[0]) * MoneyToEuro;
                                                                                              end
                                                                                            else
                                                                                              DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                          end
                                                                                        else
                                                                                          if Identifier = 'MONEYTOEUROVAL' then
                                                                                            begin
                                                                                              if ParameterList.Count = 1 then
                                                                                                begin
                                                                                                  Result := ROUND(Calc(ParameterList[0]) / MoneyToEuro * 100) / 100;
                                                                                                end
                                                                                              else
                                                                                                DoError(FRConst_ErrorParamNumber + ': ' + Identifier);
                                                                                            end;

        if FnN <> 0 then
          begin
            if StatisticBand <> nil then
              if StatisticBand.Typ <> btNone then
                begin
                  if (not (CurBand.Typ in [btColumnData])) and
                    (not ((CurBand.Typ in [btColumnFooter]) and
                    (CheckFooterBand))) then
                    begin
                      Fnc := Identifier + '(' + ParameterList[0] + ')' +
                        CurView.Name +
                        Chr(Length(CurView.Name)) + Chr(CurBand.Num);
                      if StatisticBand.AggregateFunctions.IndexOf(Fnc) = -1 then
                        begin
                          New(PV);
                          PV^ := 0;
                          StatisticBand.AggregateFunctions.AddObject(Fnc,
                            TObject(PV));
                        end
                    end
                  else
                    begin
                      if (CurBand.Typ in [btColumnFooter]) and
                        (CheckFooterBand) then
                        TfrCustomMemoView(CurView).AllTotal := True;
                      Fnc := Identifier + '(' + ParameterList[0] + ')' +
                        CurView.Name +
                        Chr(Length(CurView.Name));
                      if StatisticBand.VerticalFunctions.IndexOf(Fnc) = -1 then
                        begin
                          SL := TList.Create;
                          StatisticBand.VerticalFunctions.AddObject(Fnc, SL);
                        end;
                    end;
                  Result := 1;
                end
              else
                DoError(FRConst_FailAggregation + ': ' + Identifier)
            else
              if (not CheckColumnBand(btColumnData)) and
                (not TfrCustomMemoView(CurView).AllTotal) then
                begin
                  if CheckColumnBand(btColumnFooter) then
                    AggregateBand := CurPage.Bands[btColumnData]
                  else
                    case CurBand.Typ of
                      btReportTitle, btReportSummary,
                        btPageHeader, btPageFooter,
                        btMasterHeader, btMasterData,
                        btMasterFooter, btStaticColumnHeader,
                        btStaticColumnFooter, btGroupHeader,
                        btGroupFooter: AggregateBand :=
                        CurPage.Bands[btMasterData];
                      btDetailHeader, btDetailData,
                        btDetailFooter: AggregateBand :=
                        CurPage.Bands[btDetailData];
                      btSubDetailHeader, btSubDetailData,
                        btSubDetailFooter: AggregateBand :=
                        CurPage.Bands[btSubDetailData];
                      btColumnHeader, btColumnData,
                        btColumnFooter: AggregateBand :=
                        CurPage.Bands[btColumnData];
                    end;
                  I := AggregateBand.AggregateFunctions.
                    IndexOf(Identifier + '(' + ParameterList[0] + ')' +
                    CurView.Name +
                    Chr(Length(CurView.Name)) + Chr(CurBand.Num));
                  if I <> -1 then
                    begin
                      PV :=
                        Pointer(AggregateBand.AggregateFunctions.Objects[I]);
                      Result := PV^;
                    end;
                end
              else
                begin
                  AggregateBand := CurPage.Bands[btColumnData];
                  if not TfrCustomMemoView(CurView).AllTotal then
                    begin
                      I := AggregateBand.VerticalFunctions.
                        IndexOf(Identifier + '(' + ParameterList[0] + ')' +
                        CurView.Name +
                        Chr(Length(CurView.Name)));
                      if I <> -1 then
                        begin
                          SL :=
                            Pointer(AggregateBand.VerticalFunctions.Objects[I]);
                          if SL.Count >= ColumnNumber then
                            begin
                              PV := SL[ColumnNumber - 1];
                              Result := PV^;
                            end;
                        end;
                    end
                  else
                    begin
                      J := AggregateBand.VerticalFunctions.
                        IndexOf(Identifier + '(' + ParameterList[0] + ')' +
                        CurView.Name +
                        Chr(Length(CurView.Name)));
                      if J <> -1 then
                        begin
                          SL :=
                            Pointer(AggregateBand.VerticalFunctions.Objects[J]);
                          if SL.Count >= AggregateBand.MaxDataCount then
                            begin
                              ResetStatistic(Identifier, Total);
                              for I := 1 to AggregateBand.MaxDataCount do
                                begin
                                  PV := SL[I - 1];
                                  if Identifier = 'SUM' then
                                    Total := Total + PV^
                                  else
                                    if Identifier = 'AVG' then
                                      Total := ((Total * I) + PV^) / (I + 1)
                                    else
                                      if Identifier = 'MIN' then
                                        begin
                                          if PV^ < Total then
                                            Total := PV^
                                        end
                                      else
                                        if Identifier = 'MAX' then
                                          begin
                                            if PV^ > Total then
                                              Total := PV^
                                          end;
                                end;
                              Result := Total;
                            end;
                        end;
                    end;
                end;
          end;
      except
        S := Identifier + ' (';
        for I := 0 to ParameterList.Count - 1 do
          S := S + ParameterList[I] + ',';
        if S[Length(S)] = ',' then S := Copy(S, 1, Length(S) - 1);
        S := S + ')';
        DoError(FRConst_FunctPrmError + ': ' + S);
      end;
    end
  else
    begin
      Vr := UnAssigned;
      CurField := nil;
      V := CurReport.Values.FindVariable(Identifier);
      if V <> nil then
        begin
          if Assigned(CurReport.FOnGetValue) then
            begin
              CurReport.FOnGetValue(Id, Vr);
              if not VarIsEmpty(Vr) then Result := Vr;
            end;
          if VarIsEmpty(Result) then
            if V.Typ = vtNotAssigned then
              Result := Null
            else
              begin
                if V.Typ = vtDBField then
                  begin
                    GetDefaultData(V.DataSet + '."' + V.Field + '"', DataSet,
                      CurField);
                    if CurField <> nil then
                      begin
                        Result := CurField.Value;
                        if Result = Null then
                          if (CurField is TNumericField) or
                            (CurField is TDateTimeField) or
                            (CurField is TBooleanField) then
                            Result := 0
                          else
                            if CurField is TStringField then Result := '';
                      end
                  end
                else
                  if V.OtherKind = 1 then
                    Result := Calc(V.Field)
                  else
                    Identifier := frSpecFuncs[V.OtherKind];
              end;
        end
      else
        if Identifier = 'PI' then Result := Pi;
      if VarIsEmpty(Result) then
      begin
          GetDefaultData(Identifier, DataSet, CurField);
          if CurField <> nil then
          begin
              Result := CurField.Value;
              if Result = Null then
                if (CurField is TNumericField) or
                  (CurField is TDateTimeField) or
                  (CurField is TBooleanField) then
                  Result := 0
                else
                Begin
                  if CurField is TStringField then Result := ''
                  Else
                     If CurField is TGraphicField Then
                     Begin


                     End;
                End;
          end
          else
            if (DataSet <> nil) and
              ((UpperCase(DataSet.Owner.Name + '.' + DataSet.Name) = Identifier)
              or
              (UpperCase(DataSet.Name) = Identifier)) then
              Result := Identifier
            else
              begin
                Vr := UnAssigned;
                if (Identifier = 'VALUE') or (Identifier = ValueStr) then
                  Vr := CurValue
                else
                  if Identifier = frSpecFuncs[0] then
                    begin
                      if (MasterReport.Fascicoli) and (MasterReport.Reimpose) then
                        Vr := FindNewPage(PageNo)
                      else
                        Vr := PageNo + 1
                    end
                  else
                    if Identifier = frSpecFuncs[2] then
                      Vr := CurDate
                    else
                      if Identifier = frSpecFuncs[3] then
                        Vr := CurTime
                      else
                        if Identifier = frSpecFuncs[4] then
                          Vr := CurBand.Positions[psLocal]
                        else
                          if Identifier = frSpecFuncs[5] then
                            Vr := CurBand.Positions[psGlobal]
                          else
                            if Identifier = frSpecFuncs[6] then
                              Vr := CurPage.ColPos
                            else
                              if Identifier = frSpecFuncs[7] then
                                Vr := CurPage.CurPos
                              else
                                if Identifier = frSpecFuncs[8] then
                                  Vr := SavedAllPages;
                if not VarIsEmpty(Vr) then Result := Vr;
              end;
        end;
    end;
  if VarIsEmpty(Result) then
    begin
      P1 := UnAssigned;
      P2 := UnAssigned;
      P3 := UnAssigned;
      if ParameterList <> nil then
        begin
          if ParameterList.Count > 0 then P1 := Calc(ParameterList[0]);
          if ParameterList.Count > 1 then P2 := Calc(ParameterList[1]);
          if ParameterList.Count > 2 then P3 := Calc(ParameterList[2]);
        end;
      I := 0;
      Vr := UnAssigned;
      while (I <= frFunctionsCount - 1) and
        (not frFunctions[I].FunctionLibrary.OnFunction(Id, P1, P2, P3, Vr)) do
        Inc(I);
      if (VarIsEmpty(Vr)) and (Assigned(FOnFunction)) then
        FOnFunction(Id, P1, P2, P3, Vr);
      if not VarIsEmpty(Vr) then Result := Vr;
    end;
  if (not VarIsEmpty(Result)) and (VarType(Result) = varBoolean) then
    if Result = True then
      Result := 1
    else
      Result := 0;
end;
{$WARNINGS On}



procedure TfrReport.InternalOnGetValue(const ParName: string; var ParValue: string);
var
  V: Variant;
begin
  (*  if ErrorFlag then Exit;
    try
      CurField := nil;
      V := SearchFunction(ParName, nil);
      if not VarIsEmpty(V) then
        begin
          if (CurField <> nil) then
            V := CurField.Value;
        end
      else
        V := Calc(ParName);
      if StatisticBand = nil then
        begin
          CurValue := V;
          try
            ParValue := FormatValue(CurValue, CurView.Format, CurView.FormatStr);
          except
          end;
          if (CurView is TfrCustomMemoView) and (Pos(#13#10, ParValue) > 0) then
            TfrCustomMemoView(CurView).ReturnPresent := True;
        end
      else
        ParValue := VarToStr(V);
    except
      on Ex: Exception do DoError(FRConst_GeneralError + ' ' + Ex.Message);
    end;*)

  if ErrorFlag then Exit;
  try
    V := SearchFunction(ParName, nil);
    if VarIsEmpty(V) then V := Calc(ParName);
    if StatisticBand = nil then
    begin
       CurValue := V;
       ParValue := FormatValue(CurValue, CurView.Format, CurView.FormatStr);
       if (CurView is TfrCustomMemoView) and (Pos(#13#10, ParValue) > 0) then
          TfrCustomMemoView(CurView).ReturnPresent := True;
    end
    else
       ParValue := VarToStr(V);
  except
    on Ex: Exception do DoError(FRConst_GeneralError + ' ' + Ex.Message);
  end;
end;

procedure TfrReport.InternalOnEnterRect(Memo: TStringList; View: TfrView);
var
  Value: TfrValue;
  s: string;
  i: Integer;
  DataSet: TDataSet;
  Field: TField;
begin
  if HasBlobs then
    if Memo.Count > 0 then
      begin
        s := Memo[0];
        i := Length(s);
        if (i > 2) and (s[1] = '[') then
          begin
            while (i > 0) and (s[i] <> ']') do
              Dec(i);
            s := Copy(s, 2, i - 2);
            DataSet := nil;
            Field := nil;
            Value := Values.FindVariable(s);
            if Value = nil then
              GetDefaultData(s, DataSet, Field)
            else
              if Value.Typ = vtDBField then
                Field := Value.DField;
            if (Field <> nil) and (Field.DataType in [ftBlob..ftTypedBinary]) then
              View.GetBlob(Field);
          end;
      end;
end;

function TfrReport.FormatValue(V: Variant; Format: Integer;
  const FormatStr: string): string;
const
  FormatArr: array[1..2, 0..3] of string[12] =
  (('dd/mm/yy', 'dd/mm/yyyy', 'd mmm yyyy', 'd mmmm yyyy'),
    ('hh:nn:ss', 'h:nn:ss', 'hh:nn', 'h:nn'));
  BoolStr: array[0..2, 0..1] of string[3] = (('0', '1'), ('', ''), (' ', 'X'));
var
  f1, f2: Integer;
  c, t: Char;
begin
  if VarIsNull(v) or VarIsEmpty(V) then
    begin
      Result := '';
      Exit;
    end;
  c := FormatSettings.DecimalSeparator;
  t := FormatSettings.TimeSeparator;
  FormatSettings.TimeSeparator := ':';
  f1 := (Format div $01000000) and $0F;
  f2 := (Format div $00010000) and $FF;
  try
    case f1 of
      0:
        if VarType(V) = varDate then
          begin
            if Int(V) <> 0 then
              if Int(V) <> V then
                Result := FormatDateTime('dd/mm/yyyy hh:nn:ss', V)
              else
                Result := FormatDateTime('dd/mm/yyyy', V)
            else
              if Int(V) <> V then
                Result := FormatDateTime('hh:nn:ss', V)
              else
                Result := '';
          end
        else
          Result := V;
      1:
        if VarType(V) <> varString then
          begin
            FormatSettings.DecimalSeparator := Chr(Format and $FF);
            case f2 of
              0: Result := FormatFloat('0.##', v);
              1: Result := FloatToStrF(v, ffFixed, 10, (Format div $0100) and
                  $FF);
              2: Result := FormatFloat('0,.##', v);
              3: Result := FloatToStrF(v, ffNumber, 10, (Format div $0100) and
                  $FF);
              4: Result := FormatFloat(FormatStr, v);
            end;
          end
        else
          Result := V;
      2:
        if f2 = 4 then
          Result := FormatDateTime(FormatStr, v)
        else
          Result:=FormatDateTime(UTF8ToString(FormatArr[1, f2]), v);
          //Result := FormatDateTime(FormatArr[1, f2], v);
      3:
        if f2 = 4 then
          Result := FormatDateTime(FormatStr, v)
        else
          Result := FormatDateTime(UTF8ToString(FormatArr[2, f2]), v);
          //Result := FormatDateTime(FormatArr[2, f2], v);
      4:
        begin
          if f2 = 1 then
            if StrToInt(v) = 0 then
              Result := FRConst_No
            else
              Result := FRConst_Yes
          else
            Result := UTF8ToString(BoolStr[f2, Integer(v)]);
        end;
    end;
  except
    Result := V;
  end;
  FormatSettings.DecimalSeparator := c;
  FormatSettings.TimeSeparator := t;
end;

// load/save methods
procedure TfrReport.LoadFromStream(Stream: TStream);
var
  I, J, Count: Integer;
  L: Byte;
  S, DsFilter: ShortString;
  TD: TfrDataSet;
  T: TfrView;
  Ds: TDataSet;
  R: TSaveDataSet;
  OK, OKLoad, DsFiltered: Boolean;
  X: string;

begin
  DsFiltered := False;
  DsFilter := '';
  OKLoad := True;
  CurReport := Self;
  with Stream do
    begin
      Read(frVersion, 1);
      if frVersion < 21 then
        begin
          frVersion := 21;
          Stream.Position := 0;
        end;

      Pages.Clear;

      if frVersion > 22 then
        begin
          Read(Count, SizeOf(Count));
          for I := 0 to Count - 1 do
            begin
              OK := True;
              TD := nil;
              Read(L, 1);
              if L = 0 then
                TD := TfrDataSet.Create(nil)
              else
                begin
                  Read(L, 1);
                  Read(S[1], L);
                  S[0] := AnsiChar(L);//Chr(L);
                  if frVersion > 26 then
                    begin
                      Read(L, 1);
                      DsFiltered := L = 1;
                      Read(L, 1);
                      Read(DsFilter[1], L);
                      DsFilter[0] := AnsiChar(L);//Chr(L);
                    end;
                  Ds := FindGlobalDataSet(UTF8ToString(S));
                  if Ds <> nil then
                    begin
                      TD := TfrDBDataSet.Create(nil);
                      TfrDBDataSet(TD).DataSet := Ds;
                      if frVersion > 26 then
                        begin
                          TfrDBDataSet(TD).Filtered := DsFiltered;
                          TfrDBDataSet(TD).Filter := UTF8ToString(DsFilter);
                        end;
                    end
                  else
                    begin
                      X := UTF8ToString(S);
                      Application.MessageBox(PChar(FRConst_ErrorLoadfrDataSet +
                        ' ' + X),
                        FRConst_Attenction,
                        MB_OK or MB_ICONWARNING);
                      OK := False;
                    end
                end;
              Read(L, 1);
              Read(S[1], L);
              S[0] := AnsiChar(L);//Chr(L);
              Read(R, SizeOf(R));
              if OK then
                begin
                  TD.Name := UTF8ToString(S);
                  TD.RangeBegin := R.Start;
                  TD.RangeEnd := R.TheEnd;
                  TD.RangeEndCount := R.Count;
                  DataSetList.AddObject(TD.Name, TD);
                end;
            end;
        end;
    end;

  try
    Pages.LoadFromStream(Stream);
  except
    Application.MessageBox(FRConst_ErrorInFormat, FRConst_Error,
      MB_OK or MB_ICONERROR);
    ClearDataSetList;
    Pages.Clear;
    Pages.Add;
    OKLoad := False;
  end;

  if not OKLoad then Exit;

  if frVersion <= 22 then
  begin
      for I := 0 to Pages.Count - 1 do
        for J := 0 to Pages.Pages[I].Objects.Count - 1 do
          begin
            T := Pages.Pages[I].Objects[J];
            if (T.Typ = gtBand) and (TfrBandType(T.FrameTyp) in
              [btMasterData, btDetailData, btSubDetailData, btColumnData]) then
              begin
                TD := Owner.FindComponent(T.FormatStr) as TfrDataSet;
                if TD = nil then
                  TD := FindGlobalComponent(T.FormatStr) as TfrDataSet;
                if TD = nil then
                  Application.MessageBox(PChar(FRConst_ErrorLoadfrDataSet + ' '
                    +
                    T.FormatStr), FRConst_Attenction,
                    MB_OK or MB_ICONWARNING);
              end
          end
  end;
end;

procedure TfrReport.SaveToStream(Stream: TStream);
var
  I: Integer;
  L: Byte;
  S: ShortString;
  TD: TfrDataSet;
  R: TSaveDataSet;
  Ds: TDataSet;
begin
  frVersion := frCurrentVersion;
  with Stream do
  begin
      Write(frVersion, 1);
      if frVersion > 22 then
        begin
          I := DataSetList.Count;
          Write(I, SizeOf(I));
          for I := 0 to DataSetList.Count - 1 do
            begin
              TD := TfrDataSet(DataSetList.Objects[I]);
              if TD.InheritsFrom(TfrDBDataSet) then
                L := 1
              else
                L := 0;
              Write(L, 1);
              if L = 1 then
                begin
                  Ds := TfrDBDataSet(TD).DataSet;
                  S := UTF8Encode(Ds.Owner.Name) +'.'+UTF8Encode(Ds.Name);
                  L := Length(S);
                  Write(L, 1);
                  Write(S[1], L);
                  if TfrDBDataSet(TD).Filtered then
                    L := 1
                  else
                    L := 0;
                  Write(L, 1);
                  S := UTF8Encode(TfrDBDataSet(TD).Filter);
                  L := Length(S);
                  Write(L, 1);
                  Write(S[1], L);
                end;
              S := UTF8Encode(TD.Name);
              L := Length(S);
              Write(L, 1);
              Write(S[1], L);
              R.Start := TD.RangeBegin;
              R.TheEnd := TD.RangeEnd;
              R.Count := TD.RangeEndCount;
              Write(R, SizeOf(R));
            end;
        end;
    end;
  Pages.SaveToStream(Stream);
end;

procedure TfrReport.LoadFromFile(FName: string);
var
  Stream: TFileStream;
  S: string;
  RDir, Dir, OldDir: string;
  NewDir: Boolean;
begin
  if (Pos('.', FName) = 0) then FName := ChangeFileExt(FName, '.frf');
  if ReportDir <> '' then
    begin
      RDir := ReportDir;
      if (Copy(RDir, Length(RDir), 1) <> '\') then RDir := RDir + '\';
      Dir := ExtractFileDir(FName);
      if Dir = '' then Dir := ReportDir;
      if (Copy(Dir, Length(Dir), 1) <> '\') then Dir := Dir + '\';
      if UpperCase(Dir) <> UpperCase(RDir) then
        begin
          if Owner <> nil then
            S := Owner.Name + '.'
          else
            S := '';
          raise Exception.CreateFmt(FRConst_DirLoadError + ' "' + ReportDir +
            '"',
            [S + Name]);
        end
      else
        FName := Dir + ExtractFileName(FName);
    end;
  NewDir := False;
  OldDir := '';
  if not FileExists(FName) then
    begin
      OldDir := GetCurrentDir;
      SetCurrentDir(ExtractFilePath(ParamStr(0)));
      if FPathFromExe <> '' then SetCurrentDir(FPathFromExe);
      if not FileExists(FName) then
        SetCurrentDir(OldDir)
      else
        NewDir := True;
    end;
  if FileExists(FName) then
    begin
      if FAutoLoad <> '' then
        begin
          FInternalAutoLoad := FName;
          FInternalAutoLoadDateTime := FileDateTime(FName);
        end;
      Stream := TFileStream.Create(FName, fmOpenRead or fmShareDenyNone);
      LoadFromStream(Stream);
      if NewDir then SetCurrentDir(OldDir);
      FileName := ExtractFileName(FName);
      Stream.Free;
      if frDesigner <> nil then frDesigner.ClearChangedList;
    end
  else
    begin
      S := '';
      if Owner <> nil then S := S + Owner.Name + '.';
      S := S + Self.Name;
      raise Exception.CreateFmt(FRConst_NoLoadReport, [S, FName]);
    end;
end;

procedure TfrReport.SaveToFile(FName: string);
var
  Stream: TFileStream;
  S, R: string;
begin
  if (Pos('.', FName) = 0) then FName := ChangeFileExt(FName, '.frf');
  if ReportDir <> '' then
    begin
      R := ReportDir;
      if R[Length(R)] <> '\' then R := R + '\';
      S := ExtractFileDir(FName);
      if S <> '' then
        begin
          if S[Length(S)] <> '\' then S := S + '\';
          if UpperCase(S) <> UpperCase(R) then
            begin
              if Owner <> nil then
                S := Owner.Name + '.'
              else
                S := '';
              raise Exception.CreateFmt(FRConst_DirSaveError + ' "' + ReportDir +
                '"',
                [S + Name]);
            end;
        end
      else
        FName := R + FName;
    end;
  try
    Stream := TFileStream.Create(FName, fmCreate);
    SaveToStream(Stream);
    FileName := ExtractFileName(FName);
    Stream.Free;
    if frDesigner <> nil then frDesigner.ClearChangedList;
  except
    raise Exception.Create(FRConst_SaveError);
  end;
end;

procedure TfrReport.LoadFromDB(DataSet: TDataSet; DocN: Integer);
var
  Stream: TStream;
begin
  if DataSet.Locate(DataSet.Fields[0].FieldName, DocN, []) then
    begin
      Stream :=DataSet.CreateBlobStream(DataSet.Fields[1], bmRead);
      Stream.Position := 0;
      LoadFromStream(Stream);
      Stream.Free;
    end;
End;

procedure TfrReport.SaveToDB(DataSet: TDataSet; DocN: Integer);
var
  Stream:TStream;
begin
  if DataSet.Locate(DataSet.Fields[0].FieldName, DocN, []) then
    DataSet.Edit
  else
  begin
     DataSet.Append;
     DataSet.Fields[0].AsInteger := DocN;
  end;
  Stream := DataSet.CreateBlobStream(DataSet.Fields[1], bmWrite);
  Stream.Position := 0;
  SaveToStream(Stream);
  Stream.Free;
  DataSet.Post;
end;

procedure TfrReport.LoadPreparedReport(FName: string);
var
  Stream: TFileStream;
  oldVersion: integer;
begin
  oldVersion := frVersion;
  frVersion := frCurrentVersion;
  if (Pos('.', FName) = 0) then FName := ChangeFileExt(FName, '.frp');
  Stream := TFileStream.Create(FName, fmOpenRead or fmShareDenyNone);
  EMFPages.LoadFromStream(Stream);
  Stream.Free;
  CanRebuild := False;
  frVersion := oldVersion;
end;

procedure TfrReport.SavePreparedReport(FName: string);
var
   Stream : TFileStream;
   XPath  : String;
   XFile  : String;
begin
   XPath:=ExtractFilePath(FName);
   XFile:=ExtractFileName(FName);
   if ExtractFileExt(XFile)<>'' Then
      XFile:=ReplaceStr(XFile,ExtractFileExt(XFile),'');
   XFile:=XFile+'.frp';
   Stream:=TFileStream.Create(XPath+XFile, fmCreate);
   Try
      EMFPages.SaveToStream(Stream);
   Finally
      Stream.Free;
   End;
End;

procedure TfrReport.LoadTemplate(FName: string; comm: TStrings;
  Bmp: TBitmap; Load: Boolean);
var
  Stream: TFileStream;
  b: Byte;
  fb: TBitmap;
  fm: TStringList;
  pos: Integer;
begin
  fb := TBitmap.Create;
  fm := TStringList.Create;
  Stream := TFileStream.Create(FName, fmOpenRead or fmShareDenyNone);
  if Load then
    begin
      frReadMemo(Stream, fm);
      Stream.Read(pos, 4);
      Stream.Read(b, 1);
      if b <> 0 then
        fb.LoadFromStream(Stream);
      Stream.Position := pos;
      Pages.LoadFromStream(Stream);
    end
  else
    begin
      frReadMemo(Stream, Comm);
      Stream.Read(pos, 4);
      Bmp.Assign(nil);
      Stream.Read(b, 1);
      if b <> 0 then
        Bmp.LoadFromStream(Stream);
    end;
  fm.Free;
  fb.Free;
  Stream.Free;
end;

procedure TfrReport.SaveTemplate(FName: string; Comm: TStrings; Bmp: TBitmap);
var
  Stream: TFileStream;
  b: Byte;
  pos, lpos: Integer;
begin
  Stream := TFileStream.Create(FName, fmCreate);
  frWriteMemo(Stream, Comm);
  b := 0;
  pos := Stream.Position;
  lpos := 0;
  Stream.Write(lpos, 4);
  if Bmp.Empty then
    Stream.Write(b, 1)
  else
    begin
      b := 1;
      Stream.Write(b, 1);
      Bmp.SaveToStream(Stream);
    end;
  lpos := Stream.Position;
  Stream.Position := pos;
  Stream.Write(lpos, 4);
  Stream.Position := lpos;
  Pages.SaveToStream(Stream);
  Stream.Free;
end;

//report manipulation methods
Procedure TfrReport.DesignReport(MStream:TMemoryStream=Nil);
Var
   PathName : String;
begin
  FToStream:=MStream;
  If Not Assigned(FToStream) Then
     CheckAutoLoad
  Else
  Begin
     PathName:=Self.FileName;
     If FToStream.Size>0 Then
        Self.LoadFromStream(FToStream);
     Self.FileName:=PathName;
  End;
  if Pages.Count = 0 then Pages.Add;
  CurReport := Self;
  if frDesignerClass <> nil then
    begin
      Application.ProcessMessages;
      frDesigner := TfrReportDesigner(frDesignerClass.NewInstance).Create(nil);
      frDesigner.ShowModal;
      If (Assigned(MStream)) Then
      Begin
         MStream.Clear;
         CurReport.SaveToStream(MStream);
         MStream.Seek(0,soFromBeginning);
      End;
      frDesigner.Free;
      frDesigner := nil;
    end;
end;

var
  FirstPassTerminated: Boolean;

procedure TfrReport.BuildBeforeModal(Sender: TObject);
begin
  DoBuildReport;
  if FinalPass then
    if Terminated then
      ProgressForm.ModalResult := mrCancel
    else
      ProgressForm.ModalResult := mrOk
  else
    begin
      FirstPassTerminated := Terminated;
      SavedAllPages := EMFPages.Count;
      DoublePass := False;
      PrepareReport; // do final pass
      DoublePass := True;
    end;
end;

function TfrReport.PrepareReport: Boolean;
var
  s: string;
begin
  if PreparedStream = nil then
  begin
      CheckAutoLoad;
      PreparedStream := TMemoryStream.Create;
      if (frDesigner <> nil) and (frDesigner.Visible) then
        SaveToStream(PreparedStream);
      ErrorFlag := False;
  end;
  CurPage := nil;
  CurReport := nil;
  CurView := nil;
  CurValue := null;
  CurVariable := '';
  s := FRConst_ReportPreparing;
  Terminated := False;
  Build := True;
  Result := True;
  Append := False;
  CurDate := Date;
  CurTime := SysUtils.Time;
  MasterReport := Self;
  DisableDrawing := False;
  FinalPass := True;
  PageNo := 0;
  EMFPages.Clear;
  try
    if DoublePass then
      begin
        DisableDrawing := True;
        FinalPass := False;
        if not Assigned(FOnProgress) and FShowProgress then
          with ProgressForm do
            begin
              if Title = '' then
                Caption := s
              else
                Caption := s + ' - ' + Title;
              FirstCaption := FRConst_FirstPass;
              Label1.Caption := FirstCaption + '  1';
              OnBeforeModal := BuildBeforeModal;
              Show_Modal(Self);
            end
        else
          BuildBeforeModal(nil);
        Exit;
      end;
    if not Assigned(FOnProgress) and FShowProgress then
      with ProgressForm do
        begin
          if Title = '' then
            Caption := s
          else
            Caption := s + ' - ' + Title;
          FirstCaption := FRConst_PagePreparing;
          Label1.Caption := FirstCaption + '  1';
          OnBeforeModal := BuildBeforeModal;
          if Visible then
            begin
              if not FirstPassTerminated then DoublePass := True;
              BuildBeforeModal(nil);
            end
          else
            begin
              SavedAllPages := 0;
              if Show_Modal(Self) = mrCancel then
                Result := False;
            end;
        end
    else
      BuildBeforeModal(nil);
  finally
    if PreparedStream<>nil then
      begin
        Application.ProcessMessages;
        DisableDrawing := False;
        Terminated := False;
        Build := False;
        PreparedStream.Position := 0;
        if (frDesigner <> nil) and (frDesigner.Visible) then
          LoadFromStream(PreparedStream);
        PreparedStream.Free;
        PreparedStream := nil;
      end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
Type
   TRec = Class
   Public
      Typ         : Byte;
      X, Y        : Integer;
      Text        : string;
      XFont       : TFont;
      FontName    : string;
      FontHeight  : Integer;
      FontColor   : TColor;
      FontStyle   : TFontStyles;
      BitMap      : TBitMap;
      Constructor Create;
      Destructor Destroy; override;
   End;

Constructor TRec.Create;
Begin
   Inherited;
   XFont:=TFont.Create;
   BitMap:=Nil;
End;

Destructor TRec.Destroy;
Begin
   If Assigned(XFont) Then
      XFont.Free;
   If Assigned(BitMap) Then
      BitMap.Free;
End;

procedure TfrReport.InternalExportTo(Sender: TObject);
Var
   Canvas    : TMetaFileCanvas;
   MetaFile  : TMetaFile;
   I, L      : Integer;
   R         : TRec;
   Font      : TFont;

   Procedure MainDraw(Canvas: TCanvas; emf: TMetafile; DrawRect: TRect);
      //
      Function EnumEMFRecordsProc(DC: HDC; HandleTable: PHandleTable;
         EMFRecord: PEnhMetaRecord; nObj: Integer; OptData: Pointer): Bool; stdcall;
      Var
         Typ   : Byte;
         T     : TEMRExtTextOut;
         S     : string;
         X,Y   : Integer;
         F     : TLogFont;
         R     : TRec;
         Sx    : String;
         Sy    : String;
         Ix    : Integer;
         //
         Function Complete(A: string; I: Integer): string;
         Var
            J : Integer;
         Begin
            For J:=Length(A)+1 to I do
              A := '0' + A;
            Result:=A;
         End;
      Begin
         Result := True;
         Typ:=EMFRecord^.iType;
         if Typ in [EMR_EXTTEXTOUTA,EMR_EXTTEXTOUTW] then // Draw text. [83,84]
         begin
            T:=PEMRExtTextOut(EMFRecord)^;
            S:='';
            If T.EMRText.nChars>0 Then
            Begin
               Ix:=0;
               While Ix<Abs(T.EMRText.nChars)*Abs(StringElementSize(S)) Do //2=StringElementSize
               Begin
                  S:=S+Utf8ToString(PAnsiChar(EMFRecord)+T.EMRText.offString+Ix);
                  Inc(Ix);
               End;
            End;
            X := t.emrtext.ptlReference.x;
            Y := t.emrtext.ptlReference.y;
            GetObject(GetCurrentObject(DC, OBJ_FONT), SizeOf(f), @f);
            R:=TRec.Create;
            R.Typ:=EMFRecord^.iType;
            R.X := X;
            R.Y := Y;
            R.Text := S;
            R.FontName := f.lfFaceName;
            R.FontHeight := f.lfHeight;
            R.FontStyle := [];
            if Boolean(f.lfItalic) then R.FontStyle := R.FontStyle + [fsItalic];
            if Boolean(f.lfUnderline) then
               R.FontStyle := R.FontStyle + [fsUnderline];
            if f.lfWeight = FW_BOLD then R.FontStyle := R.FontStyle + [fsBold];
              R.FontColor := GetTextColor(DC);
            Sx:=Complete(IntToSTr(R.Y),10);
            Sy:=Complete(IntToStr(R.X),10);
            Sx:=Sx+Sy;
            SortedList.AddObject(Sx,R);
         End;
         PlayEnhMetafileRecord(DC, HandleTable^, EMFRecord^, nObj);
      End;
   Begin
      EnumEnhMetafile(Canvas.Handle, emf.Handle, @EnumEMFRecordsProc, nil,DrawRect);
   End;
   //
Begin //TfrReport.InternalExportTo
   Font:=TFont.Create;
   MetaFile:=TMetaFile.Create;
   Canvas:=TMetaFileCanvas.Create(MetaFile, 0);
   Try
      ProgressFilterForm.ProgressBar1.Max := EMFPages.Count;
      ProgressFilterForm.ProgressBar1.Position := 0;
      I:=0;
      FCurrentFilter.OnBeginDoc;
      while (I<=EMFPages.Count-1) And (Not TerminatedFilter) Do
      begin
         FCurrentFilter.OnBeginPage(EMFPages[I].Pict.Width,EMFPages[I].Pict.Height);
         //
         FCurrentFilter.OnPaintPage(EMFPages[I].Pict,I);
         //
         SortedList:=TStringList.Create;
         Try
            SortedList.Sorted:=True;
            MainDraw(Canvas,EMFPages[I].Pict,Rect(0,0,EMFPages[I].Pict.Width,EMFPages[I].Pict.Height));
            //
            for L:=0 to SortedList.Count-1 do
            begin
               R:=TRec(SortedList.Objects[L]);
               //
               If R.Typ In [EMR_EXTTEXTOUTA,EMR_EXTTEXTOUTW] Then
               Begin
                  Font.Name := R.FontName;
                  Font.Height := R.FontHeight;
                  Font.Style := R.FontStyle;
                  Font.Color := R.FontColor;
                  FCurrentFilter.OnText(R.X, R.Y, R.Text, Font);
               End;
               //
               R.Free;
            end;
         Finally
            SortedList.Free;
         End;
         FCurrentFilter.OnEndPage;
         ProgressFilterForm.ProgressBar1.Position:=I+1;
         Inc(I);
         Application.ProcessMessages;
      End;
      FCurrentFilter.OnEndDoc;
   Finally
      ProgressFilterForm.Close;
      Canvas.Free;
      MetaFile.Free;
      Font.Free;
   End;
End;

Procedure TfrReport.ExportTo(Filter: TClass; Var FileName: string);
var
  XPath  : String;
  XFile  : String;
//  Stream : TFileStream;
  I      : Integer;
  S      : string;
begin
  I:=0;
  While (I<=frFiltersCount) And (frFilters[I].ClassRef<>Filter) Do
    Inc(I);
  //
  XPath:=ExtractFilePath(FileName);
  XFile:=ExtractFileName(FileName);
  If ExtractFileExt(XFile)='' Then
     XFile:=XFile+ExtractFileExt(frFilters[I].FilterExt);
  //
  FileName:=XPath+XFile;
  If FileExists(FileName) Then
     Try DeleteFile(PWideChar(FileName)); Except End;
  //
  S:=frFilters[I].FilterDesc;
//  Stream:=TFileStream.Create(FileName, fmCreate);
  FCurrentFilter:=TfrExportFilter(Filter.NewInstance);
//  FCurrentFilter.Create(Stream,FileName,Title,'FazzyReport');
  FCurrentFilter.Create(FileName,Title,'FazzyReport');
  FCurrentFilter.Doc:=Self;
  FCurrentFilter.FileName:=FileName;
  if FCurrentFilter.Execute then
  begin
      if EMFPages.Count=0 then PrepareReport;
      ProgressFilterForm:=TProgressFilterForm.Create(nil);
      ProgressFilterForm.Label1.Caption:=S;
      ProgressFilterForm.OnBeforeModal:=InternalExportTo;
      TerminatedFilter:=False;
      ProgressFilterForm.Show_Modal;
      ProgressFilterForm.Free;
  end;
  FCurrentFilter.Free;
  FCurrentFilter := nil;
//  If Assigned(Stream) Then Stream.Free;
End;

{
procedure TfrReport.ExportTo(Filter: TClass; FileName: string);
var
  XPath  : String;
  XFile  : String;
  Stream : TFileStream;
  I      : Integer;
  S      : string;
begin
  I := 0;
  while (I <= frFiltersCount) and (frFilters[I].ClassRef <> Filter) do
    Inc(I);
  //
  XPath:=ExtractFilePath(FileName);
  XFile:=ExtractFileName(FileName);
  If ExtractFileExt(XFile)<>'' Then
     XFile:=ReplaceStr(XFile,ExtractFileExt(XFile),'');
  XFile:=XFile+ExtractFileExt(frFilters[I].FilterExt);


  Stream:=Nil;
  FileName:=XPath+XFile;
  //
  S:=frFilters[I].FilterDesc;
  If UpperCase(ExtractFileExt(XFile))<>'.PDF' Then
     Stream:=TFileStream.Create(FileName, fmCreate);
  Try
     FCurrentFilter := TfrExportFilter(Filter.NewInstance);
     FCurrentFilter.Create(FileName,Title,'Fazzy2010',Stream);
     FCurrentFilter.Doc := Self;
     FCurrentFilter.FileName := FileName;
     if FCurrentFilter.Execute then
     begin
         if EMFPages.Count = 0 then PrepareReport;
         ProgressFilterForm := TProgressFilterForm.Create(nil);
         ProgressFilterForm.Label1.Caption := S;
         ProgressFilterForm.OnBeforeModal :=InternalExportTo;
         TerminatedFilter := False;
         ProgressFilterForm.Show_Modal;
         ProgressFilterForm.Free;
     end;
     FCurrentFilter.Free;
     FCurrentFilter := nil;
  Finally
     If Assigned(Stream) Then
        Stream.Free;
  End;
end;
}

procedure TfrReport.DoBuildReport;
var
  I, J, IR     : Integer;
  PagesArray   : array[0..999] of Word;
  CountArray   : array[0..999] of Word;
  PointerArray : array[0..999] of TMetaFile;
begin
   CanRebuild := True;
   DocMode := dmPrinting;
   Values.Items.Sorted := True;
   try StartReport; except end;
   if not ErrorFlag then
   begin
      InternalOnProgress(PageNo+1);
      //      SetLength (PagesArray,Pages.Count);
      //      SetLength (CountArray,Pages.Count);
      For I:=0 to Pages.Count-1 do
         Pages[i].Skip:=False;
      //
      IR:=0;
      While (IR<=Pages.Count-1) And (Not ErrorFlag) Do
      begin
         CurPageNumber:=IR+1;
         Pages[IR].InitReport;
         Inc(IR);
      End;
      //
      Dec(IR);
      if Not ErrorFlag then
      Begin
         for i:=0 to Pages.Count - 1 do
         begin
            FCurPage := Pages[i];
            if FCurPage.Skip then continue;
            if Assigned(FOnBeginPage) then
               FOnBeginPage(i);

            FCurPage.Mode := pmNormal;

            PagesArray[I] := EMFPages.Count;
            try
               CurPageNumber := I + 1; // Set the currently number page
               FCurPage.FormPage; //Itta ?????????????????? Costruzione Pagina
            Except
               on Ex: Exception do
                  DoError(FRConst_GeneralError + ' ' + Ex.Message);
            End;
            if (not ErrorFlag) and (Assigned(FOnEndPage)) then FOnEndPage(1);
            Append:=False;
            if PageNo>0 then
            begin
               if ((i = Pages.Count - 1) and CompositeMode) or
                  ((i <> Pages.Count - 1) and Pages[i + 1].PrintToPrevPage) then
               begin
                  Dec(PageNo);
                  Append:=True;
               end;
               if Not Append then
               begin
                  Dec(PageNo);
                  While (PageNo<MasterReport.EMFPages.Count) and
                     (MasterReport.EMFPages[PageNo].Pict<>nil) do
                  Begin
                     if MasterReport.EMFPages[PageNo].Canvas<>nil then
                     begin
                        MasterReport.EMFPages[PageNo].Canvas.Free;
                        MasterReport.EMFPages[PageNo].Canvas:=nil;
                     end;
                     Inc(PageNo);
                  end;
                  InternalOnProgress(PageNo);
               End;
            End;
            if not ErrorFlag then
              CountArray[I] := EMFPages.Count - PagesArray[I];
            //
            if MasterReport.Terminated then Break;
         End;
      End;
      if (Assigned(FOnEndDoc)) and (not ErrorFlag) then FOnEndDoc;

      // DownTo because if the second page use an egual dataset of first, it
      // must free it previos of the first page (sorry for bad english)
      For I:=IR DownTo 0 do
         Pages[i].DoneReport;
      //
      if Not ErrorFlag then
      Begin
         InternalOnProgress(PageNo);
         if (MasterReport.Fascicoli) and (not MasterReport.Terminated) then
         begin
            if ((MasterReport.DoublePass) and (DisableDrawing)) or
             ((not MasterReport.DoublePass) and (not DisableDrawing)) then
            begin
               J := 0;
               repeat
                  for I := 0 to Pages.Count - 1 do
                  Begin
                     if CountArray[I] > 0 then
                     Begin
                        NewPageArray[J] := PagesArray[I];
                        Inc(PagesArray[I]);
                        Dec(CountArray[I]);
                        Inc(J);
                     End;
                  End;
               Until J=EMFPages.Count;
            End;
            if not DisableDrawing then
            begin
               For I:=0 to MasterReport.EMFPages.Count-1 do
                  PointerArray[I]:=MasterReport.EMFPages.Pages[NewPageArray[I]].Pict;
               For I := 0 to MasterReport.EMFPages.Count - 1 do
                  MasterReport.EMFPages.Pages[I].Pict := PointerArray[I];
            End;
         End;
      End;
   End;
   Values.Items.Sorted:=False;
end;

procedure TfrReport.ShowReport;
begin
  try
    PrepareReport;
    if ErrorFlag then
      Application.MessageBox(PChar(ErrorStr), FRConst_Error, MB_OK + MB_ICONERROR)
    else
      ShowPreparedReport;
//    EMFPages.Clear;                  //Itta??????????????????????????????
  finally
    ErrorFlag := False;
  end;
end;

procedure TfrReport.ShowPreparedReport;
var
  S   : string;
  Preview: TfrPreview;
begin
  PrintMode := pmViewing;
  s := FRConst_Preview;
  if Title <> '' then s := s + ' - ' + Title;
  Preview:=PreviewClass.Create(Nil);
  PreviewActive:=Preview;
  Preview.Caption:=S;
  Preview.Show_Report(Self);
End;

procedure TfrReport.PrintBeforeModal(Sender: TObject);
begin
  Application.ProcessMessages;
  DoPrintReport(FFromPage, FToPage, Fn, FToPdf); //, FCollate);
  ProgressForm.ModalResult := mrOk;
end;

procedure TfrReport.PrintPreparedReport(FromPage, ToPage, n: Integer; ToPdf:String=''); //Collate:Boolean);
Var
   S : string;
begin
   S:=FRConst_ReportPreparing;
   Terminated := False;
   FFromPage := FromPage;
   FToPage := ToPage;
   Fn:=n;
   FToPdf:=ToPdf;
   //FCollate:=Collate;
   if Not Assigned(FOnProgress) And FShowProgress Then
   Begin
      With ProgressForm do
      Begin
         if Title = '' then
            Caption := s
         else
            Caption := s + ' - ' + Title;
         FirstCaption := FRConst_PagePrinting;
         Label1.Caption := FirstCaption;
         OnBeforeModal := PrintBeforeModal;
         Application.ProcessMessages;
         Show_Modal(Self);
      End
   End
   Else
   begin
      Application.ProcessMessages;
      PrintBeforeModal(nil);
   End;
   Terminated:=False;
end;

procedure TfrReport.PrintReport;
begin
  PrepareReport;
  PrintPreparedReport(1, EMFPages.Count, 1,'');//, False);
end;

procedure TfrReport.DoPrintReport(FromPage, ToPage, N: Integer; ToPdf:String=''); //Collate:Boolean);
Var
   Preview   : TfrPreview;
   nPages    : Integer;
   Rect      : TRect;
   I, J      : Integer;
   Inizio    : Boolean;
   Prosegui  : Boolean;
   //
   procedure CorrectZoomFactors(IPage: Integer);
   Var
      X, Y  : Double;
   begin
      EMFPages[IPage]^.PrnInfo.PPgw := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
      EMFPages[IPage]^.PrnInfo.PPgh := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
      EMFPages[IPage]^.PrnInfo.POfx := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX);
      EMFPages[IPage]^.PrnInfo.POfy := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY);
      X:=(GetDeviceCaps(Printer.Handle, LOGPIXELSX) / 96);
      Y:=(GetDeviceCaps(Printer.Handle, LOGPIXELSY) / 96);
      EMFPages[IPage]^.PrnInfo.PPgh:=Round(EMFPages[IPage]^.PrnInfo.Pgh * Y);
      EMFPages[IPage]^.PrnInfo.PPgw:=Round(EMFPages[IPage]^.PrnInfo.Pgw * X);
   End;
   //
   procedure PrintPage(IPage: Integer);
   Begin
      If ToPdf='' Then
      Begin
         if not PrinterSettings.IsEqual(
            EMFPages[IPage]^.pgSize,EMFPages[IPage]^.pgWidth,
            EMFPages[IPage]^.pgHeight,EMFPages[IPage]^.pgOr) then
         Begin
            Printer.EndDoc;
            PrinterSettings.SetPrinterInfo(
               EMFPages[IPage]^.pgSize,EMFPages[IPage]^.pgWidth,
               EMFPages[IPage]^.pgHeight,EMFPages[IPage]^.pgOr);
            Printer.BeginDoc;
         End;
         If Not Inizio then
            Printer.NewPage;
         PrinterSettings.FillPrnInfo(EMFPages[IPage]^.PrnInfo);
         CorrectZoomFactors(IPage);
      End;
      If ToPdf='' Then
      Begin
         Rect.Left:=-EMFPages[IPage]^.PrnInfo.POfx;
         Rect.Top:=-EMFPages[IPage]^.PrnInfo.POfy;
         Rect.Right:=EMFPages[IPage]^.PrnInfo.PPgw-EMFPages[IPage]^.PrnInfo.POfx;
         Rect.Bottom:=EMFPages[IPage]^.PrnInfo.PPgh-EMFPages[IPage]^.PrnInfo.POfy;
         Preview.DrawPage(Printer.Canvas.Handle, IPage, Rect);
      End
      Else
      Begin
{
         Rect.Left:=0;
         Rect.Top:=0;
         Rect.Right:=EMFPages[IPage]^.pgWidth;
         Rect.Bottom:=EMFPages[IPage]^.pgHeight;
         Picture:=TPicture.Create;
         Try
            If Not Assigned(Picture.Bitmap) Then
               Picture.Bitmap:=TBitmap.Create;
            Picture.Bitmap.SetSize(Rect.Right,Rect.Bottom);
            Picture.Bitmap.Canvas.StretchDraw(Rect,EMFPages[IPage]^.Pict);
            Picture.SaveToFile('A'+IntToStr(N)+'.Bmp');
            ExportPdf.BeginPage(Rect.Right,Rect.Bottom);
            ExportPdf.ShowPage(Picture.Bitmap);
            ExportPdf.EndPage;
        Finally
            Picture.Free;
        End;
}
      End;
      //
      InternalOnProgress(IPage+1);
      Application.ProcessMessages;
      Inizio:=False;
   End;
   //
Begin
   Preview:=Nil;
{
   ExportPdf:=Nil;
   If ToPdf<>'' Then
   Begin
      PrintMode:=pmViewing;
      ExportPdf:=TfrEPDFExportFilter.Create(ToPdf);
   End;
}
   //
   Try
      Preview:=PreviewClass.Create(Self);
      PrinterSettings.PrinterIndex:=Printer.PrinterIndex;
      Preview.FReport:=Self;
      Prosegui:=True;
      If ToPdf='' Then
      Begin
         if Assigned(FOnBeforePrint) Then
            FOnBeforePrint(Prosegui);
      End;
      if Prosegui then
      Begin
         CurReport:=Self;
         If ToPdf='' Then
            PrinterSettings.Printer:=Printer;
         Dec(FromPage);
         Dec(ToPage);
         if ToPage>=EMFPages.Count Then
            ToPage:=EMFPages.Count-1;
         nPages:=ToPage-FromPage+1;
         With EMFPages[0]^ do
         Begin
            If ToPdf='' Then
            Begin
               PrinterSettings.SetPrinterInfo(pgSize, pgWidth, pgHeight, pgOr);
               PrinterSettings.FillPrnInfo(PrnInfo);
               CorrectZoomFactors(0);
            End;
         End;
         If ToPdf='' Then
         Begin
            if Title<>'' then
               Printer.Title:=FRConst_ReportName+'-'+Title
            Else
               Printer.Title:=FRConst_ReportName+'-' +FRConst_RepNoName;
            Printer.BeginDoc;
         End
         Else
         Begin
{
            if Title<>'' then
               ExportPdf.BeginDoc(Title,'');
}
         End;
         //
         Try
            Inizio:=True;
            for I:=0 to nPages-1 Do      //Ciclo sulle Pagine
            Begin
               for J:=0 to N-1 do    //Ciclo sul numero di copie
               begin
                  PrintPage(I+FromPage);
                  if Assigned(OnProgress) then
                     OnProgress((I*N+J+1)*100 Div (nPages*N));
                  if Terminated then
                  begin
                     If ToPdf='' Then
                        Printer.Abort;
{
                     Else
                        ExportPdf.AbortDoc;
}
                     exit;
                  End;
               End;
            End;
            If ToPdf='' Then
               Printer.EndDoc;
{
            Else
               ExportPdf.EndDoc;
}
         Except
            If ToPdf='' Then
               Printer.Abort;
{
            Else
               ExportPdf.AbortDoc;
}
            Exit;
         End;
         If ToPdf='' Then
            if Assigned(FOnAfterPrint) then FOnAfterPrint;
      End;
   Finally
      PrintMode:=pmViewing;
      If Assigned(Preview) Then Try Preview.Free; Except End;
   End;
End;

// printer manipulation methods
function TfrReport.ChangePrinter(OldIndex, NewIndex: Integer): Boolean;
  procedure ChangePages;
  var
    i: Integer;
  begin
    for i := 0 to Pages.Count - 1 do
      with Pages[i] do
        ChangePaper(pgSize, pgWidth, pgHeight, pgOr);
  end;
begin
  Result := True;
  try
    PrinterSettings.PrinterIndex := NewIndex;
    PrinterSettings.PaperSize := -1;
    ChangePages;
  except
    on Exception do
      begin
        Application.MessageBox(FRConst_PrinterError, FRConst_Error, mb_IconError +
          mb_Ok);
        PrinterSettings.PrinterIndex := OldIndex;
        ChangePages;
        Result := False;
      end;
  end;
end;

// miscellaneous methods
procedure TfrReport.PrepareDataSets;
var
  i: Integer;
begin
  if ErrorFlag then Exit;
  //HasBlobs := False; //Itta???????????????????????????????????????? 
  HasBlobs := True;
  with Values do
    for i := 0 to Items.Count - 1 do
      with Objects[i] do
        if Typ = vtDBField then
          begin
            DSet := frGetDataSet(DataSet);
            if DSet <> nil then
              if DSet.Active then
                begin
                  DField := DSet.FindField(Field);
                  if DField <> nil then
                    if DField.DataType in [ftBlob..ftTypedBinary] then
                      HasBlobs := True
                    else
                  else
                    begin
                      CurView := nil;
                      DoError(FRConst_ErrorFindField + ' ' + Dset.Name + '.' +
                        Field);
                      Break
                    end;
                end
              else
            else
              begin
                CurView := nil;
                DoError(FRConst_DataSetError + ': ' + DataSet);
                Break
              end;
          end;
end;

procedure TfrReport.StartReport;
begin
  Application.ProcessMessages;
  CurReport := Self;
  if Assigned(FOnBeginDoc) then FOnBeginDoc;
  PrepareDataSets;
end;

procedure TfrReport.SetVars(Value: TStrings);
begin
  FVars.Assign(Value);
end;

procedure TfrReport.GetVarList(CatNo: Integer; List: TStrings);
var
  i, n: Integer;
  s: string;
begin
  List.Clear;
  i := 0;
  n := 0;
  if FVars.Count > 0 then
    repeat
      s := FVars[i];
      if Length(s) > 0 then
        if s[1] <> ' ' then Inc(n);
      Inc(i);
    until n > CatNo;
  while i < FVars.Count do
    begin
      s := FVars[i];
      if (s <> '') and (s[1] = ' ') then
        List.Add(Copy(s, 2, Length(s) - 1))
      else
        break;
      Inc(i);
    end;
end;

procedure TfrReport.GetCategoryList(List: TStrings);
var
  i: Integer;
  s: string;
begin
  List.Clear;
  for i := 0 to FVars.Count - 1 do
    begin
      s := FVars[i];
      if (s <> '') and (s[1] <> ' ') then List.Add(s);
    end;
end;

function TfrReport.FindVariable(Variable: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  Variable := ' ' + Variable;
  for i := 0 to FVars.Count - 1 do
    if Variable = FVars[i] then
      begin
        Result := i;
        break;
      end;
end;

function TfrReport.FindObject(Name: string): TfrView;
begin
  Result := CanAssignName(Self, UTF8Encode(Name), nil)
end;

function TfrReport.ObjectByName(Name: string): TfrView;
var
  T: TfrView;
  S: string;
begin
  T := CanAssignName(Self, UTF8Encode(Name), nil);
  if T <> nil then
    Result := T
  else
    begin
      S := '';
      if Owner <> nil then S := Owner.Name + '.';
      S := S + Self.Name + '.' + Name;
      raise Exception.Create(FRConst_ObjectNotFound + ': ' + S);
    end;
end;

procedure TfrReport.DeleteObject(T: TfrView);
var
  I, J: Integer;
  Found: Boolean;
begin
  I := 0;
  Found := False;
  repeat
    J := 0;
    while (J <= Pages.Pages[I].Objects.Count - 1) and
      (TfrView(Pages[I].Objects[J]) <> T) do
      Inc(J);
    if J <= Pages.Pages[I].Objects.Count - 1 then
      begin
        Pages[I].Objects.Delete(J);
        T.Free;
        Found := True;
      end
    else
      Inc(I);
  until Found;
end;

procedure TfrReport.InsertObject(T: TfrView; PageNo, Index: Integer);
begin
  Pages[PageNo].Objects.Insert(Index, T);
end;

procedure TfrReport.SetDataSetBand(BandName: string; DataSet: TfrDataSet);
var
  T: TfrView;
  TD: TfrDataSet;
  I: Integer;
begin
  CurReport := Self;
  T := FindObject(BandName);
  if T <> nil then
    if (T.Typ = gtBand) and (TfrBandType(T.FrameTyp) in
      [btMasterData, btDetailData, btSubDetailData, btColumnData]) then
      begin
        // Remove the old TfrDataSet assignet to band.
        if (DataSetList.Find(T.FormatStr, I)) Or 
           (DataSetList.Find(String(T.Name), I))  then
          begin
            if TfrDataSet(DataSetList.Objects[I]).Owner = nil then
              TfrDataSet(DataSetList.Objects[I]).Free
            else
              DataSetList.Delete(I);
          end;
        // Assign the new.
        TD := DataSet;
        DataSetList.AddObject(TD.Name, TD);
        T.FormatStr := TD.Name;
      end
    else
      raise Exception.Create(FRConst_NoAssignNoBand)
  else
    raise Exception.Create(FRConst_BandNoFound + ' ' + BandName);
end;

//Itta
function TfrReport.ReplaceDataSetBand(FromDataSet:String; ToDataSet: TfrDataSet): Boolean;
Var
  O      : TObject;
  T      : TfrView;
  IPage  : Integer;
  IObj   : Integer;
  DS     : TfrDataSet;
  Nome   : String;
   //
begin
   FromDataSet:=UpperCase(FromDataSet);
   //Ciclo sulle bande e se DataSet Associabile eseguire cambio 
   //se nome DataSet corrisponde a FromDataSet
   IPage:=0;
   While IPage<Pages.Count Do
   Begin
      For IObj:=0 To Pages[IPage].Objects.Count-1 Do
      Begin
         O:=Pages[IPage].Objects[IObj];
         //
         If O Is TfrView Then
         Begin
            T:=TfrView(O);
            DS:=GetDataSetBand(String(T.Name));
            If DS=Nil Then Continue;
            If FromDataSet=UpperCase(String(T.Name)) Then
               Self.SetDataSetBand(String(T.Name),ToDataSet);
            If FromDataSet=UpperCase(String(T.Name)) Then
               T.FName:= ShortString(ToDataSet.Name);
{
            If IsDataSetBand(T.Name) Then 
            Begin
               DS:=GetDataSetBand(T.Name);
               If DS=Nil Then Continue;
               If FromDataSet=UpperCase(T.Name) Then 
                  Self.SetDataSetBand(T.Name,ToDataSet);
            End;
}
            If (T Is TfrMemoView) Or (T Is TfrPictureView) Then 
            Begin
               Nome:=UpperCase(Trim(T.Memo.Text));
               If (Length(Nome)>0) And (Nome[1]='[') Then
                  If Pos(FromDataSet,Nome)>0 Then
                     T.Memo.Text:=ReplaceStr(T.Memo.Text,FromDataSet,ToDataSet.Name);
            End;
         End;
      End;
      //
      Inc(IPage);
   End;
   Result:=True;
End;

//Itta
function  TfrReport.IsDataSetBand(BandName:String):Boolean;
var
  T: TfrView;
begin
  Result:=False;
  CurReport:=Self;
  T:=FindObject(BandName);
  if T<>nil then
  Begin
    if (T.Typ = gtBand) and (TfrBandType(T.FrameTyp) in
      [btMasterData, btDetailData, btSubDetailData, btColumnData]) then
      Result:=True;
  End;
End;

//Itta
function TfrReport.GetDataSetBand(BandName: string): TfrDataSet;
var
  T: TfrView;
  I: Integer;
begin
  Result:=Nil;
  CurReport := Self;
  T := FindObject(BandName);
  if T <> nil then
  Begin
    if (T.Typ = gtBand) and (TfrBandType(T.FrameTyp) in
      [btMasterData, btDetailData, btSubDetailData, btColumnData]) then
      begin
        if (DataSetList.Find(T.FormatStr, I)) Or 
           (DataSetList.Find(String(T.Name), I))  then
           Result:=TfrDataSet(DataSetList.Objects[I]);
      end
    else
      Result:=Nil;
  End;
End;

procedure TfrReport.ClearDataSetList;
var
  I: Integer;
begin
  for I := 0 to DataSetList.Count - 1 do
  begin
      if TfrDataSet(DataSetList.Objects[0]).Owner = nil then
        TfrDataSet(DataSetList.Objects[0]).Free
      else
        DataSetList.Delete(0);
  end;
end;

function TfrReport.ChekBandType(BT: TfrBandType; PageNo: Integer): Boolean;
var
  I: Integer;
begin
  I := 0;
  while (I <= Pages.Pages[PageNo].Objects.Count - 1) and not
    ((TfrView(Pages.Pages[PageNo].Objects[I]).Typ = gtBand) and
    (TfrBandView(Pages.Pages[PageNo].Objects[I]).BandType = BT)) do
    Inc(I);
  if I > Pages.Pages[PageNo].Objects.Count - 1 then
    Result := False
  else
    Result := True;
end;
{----------------------------------------------------------------------------}
constructor TfrCompositeReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Reports := TList.Create;
end;

destructor TfrCompositeReport.Destroy;
begin
  Reports.Free;
  inherited Destroy;
end;

procedure TfrCompositeReport.DoBuildReport;
var
  i: Integer;
  Doc: TfrReport;
begin
  CanRebuild := True;
  PageNo := 0;
  if Assigned(FOnBeginDoc) then FOnBeginDoc;
  for i := 0 to Reports.Count - 1 do
    begin
      Doc := TfrReport(Reports[i]);
      CompositeMode := False;
      if i <> Reports.Count - 1 then
        if (TfrReport(Reports[i + 1]).Pages.Count > 0) and
          TfrReport(Reports[i + 1]).Pages[0].PrintToPrevPage then
          CompositeMode := True;
      Doc.FCurrentFilter := FCurrentFilter;
      Doc.DoBuildReport;
      Doc.FCurrentFilter := nil;
      Append := CompositeMode;
      CompositeMode := False;
      if Terminated then break;
    end;
  if Assigned(FOnEndDoc) then FOnEndDoc;
end;

{----------------------------------------------------------------------------}
procedure TfrObjEditorForm.ShowEditor(t: TfrView);
begin
  // abstract method
end;

{----------------------------------------------------------------------------}
constructor TfrExportFilter.Create(AFileName,ATitle,AAuthor:String);
begin
  inherited Create;
  FileName:=AFileName;
  Title:=ATitle;
  Author:=AAuthor;
End;

function TfrExportFilter.Execute: Boolean;
begin
  Result := True;
end;

procedure TfrExportFilter.OnBeginDoc;
begin
  // abstract method
end;

procedure TfrExportFilter.OnEndDoc;
begin
  // abstract method
end;

procedure TfrExportFilter.OnBeginPage(Width, Height: Integer);
begin
  // abstract method
end;

procedure TfrExportFilter.OnEndPage;
begin
  // abstract method
end;

procedure TfrExportFilter.OnPicture(BM: TBitMap; X, Y, H, E: Integer);
begin
  // abstract method
end;

Procedure TfrExportFilter.OnPaintPage(MF:TMetaFile; IPage:Integer);
Begin
  // abstract method
End;

procedure TfrExportFilter.OnText(x, y: Integer; const text: string; Font:TFont);
begin
  // abstract method
end;
{----------------------------------------------------------------------------}
constructor TfrFunctionLibrary.Create;
begin
  inherited Create;
  List := TStringList.Create;
  //  List.Sorted := True;
end;

destructor TfrFunctionLibrary.Destroy;
begin
  List.Free;
  inherited Destroy;
end;

function TfrFunctionLibrary.OnFunction(const FName: string; p1, p2, p3: Variant;
  var Val: Variant): Boolean;
var
  i: Integer;
begin
  Result := False;
  if List.Find(FName, i) then
    begin
      DoFunction(i, p1, p2, p3, val);
      Result := True;
    end;
end;
//------------------------------------------------------------------------------
procedure TfrPreview.DrawPage(Cnv: HDC; N: Integer; R: TRect);
begin
   EnumEnhMetafile(Cnv, Report.EMFPages.Pages[N].Pict.Handle, nil, nil, R);
end;

procedure TfrPreview.DoHide;
begin
  inherited;
  if Not FModal then  
   FReport.Free;
  If Assigned(PreviewActive) Then
  Begin
     PreviewActive:=Nil;
     //Release;   //Itta????????????????????????????
     //Genera un'eccezione se eseguita una ricerca .Find in FR_Prev
  End;
End;

procedure TfrPreview.Show_Report(AReport: TfrReport);
begin
  if Visible then Close;
  FModal := AReport.ModalPreview;
  if FModal then
  begin
      FReport := AReport;
      FormStyle := fsNormal;
      WindowState := wsMaximized;
      ShowModal;
  end
  else
  begin
      MS := TMemoryStream.Create;
      AReport.EMFPages.SaveToStream(MS);
      FReport := TfrReport.Create(Owner);
      MS.Position := 0;
      FReport.EMFPages.LoadFromStream(MS);
      MS.Free;
      FormStyle := fsStayOnTop;
      WindowState := wsMaximized;
      Show;
  end;
end;
{----------------------------------------------------------------------------}
procedure DoInit;
const
  Clr: array[0..1] of TColor = (clWhite, clSilver);
var
  i, j: Integer;
begin
  PrintMode:=pmViewing;
  frDesigner:=nil;
  frDesignerClass:=nil;
  PreviewActive:=Nil;
  ProgressForm:=TProgressForm.Create(nil);
  CurrentPixelsPerInch:=Screen.PixelsPerInch;
  ValueStr:=UpperCase(FRConst_Value);
  SMemo:=TStringList.Create;
  SBmp:=TBitmap.Create;
  SBmp.Width:=8;
  SBmp.Height:=8;
  for j := 0 to 7 do
    for i := 0 to 7 do
      SBmp.Canvas.Pixels[i, j] := Clr[(j + i) mod 2];
  frCharset := DEFAULT_CHARSET;

  CurValue := Unassigned;

  for i := 0 to 21 do
    frBandNames[i] := FRConst_Bands[i];
  for i := 0 to frSpecCount - 1 do
    frSpecArr[i] := FRConst_Vars[i];

  // Load language string for NumberToLetter function.
  for i := 0 to 19 do
    NumberFunction1[i] := FRConst_Number1[i];
  for i := 0 to 9 do
    NumberFunction2[i] := FRConst_Number2[i];
  for i := 0 to 9 do
    NumberFunction3[i] := FRConst_Number3[i];
  PreparedStream := nil;

  IntoMe := False;
end;

procedure DoExit;
var
  i: Integer;
begin
  SBmp.Free;
  SMemo.Free;
  ProgressForm.Free;
  for i := 0 to frFunctionsCount - 1 do
    frFunctions[i].FunctionLibrary.Free;
  If Assigned(PreviewActive) Then
  Begin
    PreviewActive.Free;
    PreviewActive:=Nil;
  End;
  
End;

procedure TfrReport.NewPage;
begin
  CurPage.NewPage;
end;

initialization
  DoInit;
  //
finalization
  DoExit;
  //

End.


