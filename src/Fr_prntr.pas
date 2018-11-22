
{*****************************************}
{                                         }
{             FastReport v2.2             }
{              Printer info               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Prntr;

interface

{$I FR_Vers.inc}

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Printers, WinSpool, FR_Class, FR_Const;

Const
  pgCustomSize = $100;

type
  TPrinterSettings = class
  private
    FDevice: PChar;
    FDriver: PChar;
    FPort: PChar;
    DeviceMode: THandle;
    DevMode: PDeviceMode;
    FPrinter: TPrinter;
    FPaperNames: TStringList;
    FPrinters: TStringList;
    FPrinterIndex: Integer;
    function Supported(Setting: integer): boolean;
    procedure SetField(aField: integer);
    procedure SetPrinter(Value: TPrinter);
    procedure SetPrinterIndex(Value: Integer);
  public
    Orientation: TPrinterOrientation;
    PaperSize: Integer;
    PaperWidth: integer;
    PaperLength: integer;
    PixelsPerX: integer;
    PixelsPerY: integer;
    PaperSizes: array[0..255] of Word;
    PaperSizesNum: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure ApplySettings;
    procedure FillPrnInfo(var p: TfrPrnInfo);
    procedure SetPrinterInfo(pgSize, pgWidth, pgHeight: Integer; pgOr: TPrinterOrientation);
    function IsEqual(pgSize, pgWidth, pgHeight: Integer; pgOr: TPrinterOrientation): Boolean;
    function GetArrayPos(pgSize: Integer): Integer;
    property PaperNames: TStringList read FPaperNames;
    property Printer: TPrinter read FPrinter write SetPrinter;
    property Printers: TStringList read FPrinters;
    property PrinterIndex: Integer read FPrinterIndex write SetPrinterIndex;
  end;

Var
   PrinterSettings : TPrinterSettings;

implementation

Type
  TPaperInfo = record
    Typ  : Integer;
    Name : string;
    X, Y : Integer;
  end;

Const
  PaperInfo: array[0..PAPERCOUNT - 1] of TPaperInfo = (
    (Typ: 1; Name: ''; X: 2159; Y: 2794),
    (Typ: 2; Name: ''; X: 2159; Y: 2794),
    (Typ: 3; Name: ''; X: 2794; Y: 4318),
    (Typ: 4; Name: ''; X: 4318; Y: 2794),
    (Typ: 5; Name: ''; X: 2159; Y: 3556),
    (Typ: 6; Name: ''; X: 1397; Y: 2159),
    (Typ: 7; Name: ''; X: 1842; Y: 2667),
    (Typ: 8; Name: ''; X: 2970; Y: 4200),
    (Typ: 9; Name: ''; X: 2100; Y: 2970),
    (Typ: 10; Name: ''; X: 2100; Y: 2970),
    (Typ: 11; Name: ''; X: 1480; Y: 2100),
    (Typ: 12; Name: ''; X: 2500; Y: 3540),
    (Typ: 13; Name: ''; X: 1820; Y: 2570),
    (Typ: 14; Name: ''; X: 2159; Y: 3302),
    (Typ: 15; Name: ''; X: 2150; Y: 2750),
    (Typ: 16; Name: ''; X: 2540; Y: 3556),
    (Typ: 17; Name: ''; X: 2794; Y: 4318),
    (Typ: 18; Name: ''; X: 2159; Y: 2794),
    (Typ: 19; Name: ''; X: 984; Y: 2254),
    (Typ: 20; Name: ''; X: 1048; Y: 2413),
    (Typ: 21; Name: ''; X: 1143; Y: 2635),
    (Typ: 22; Name: ''; X: 1207; Y: 2794),
    (Typ: 23; Name: ''; X: 1270; Y: 2921),
    (Typ: 24; Name: ''; X: 4318; Y: 5588),
    (Typ: 25; Name: ''; X: 5588; Y: 8636),
    (Typ: 26; Name: ''; X: 8636; Y: 11176),
    (Typ: 27; Name: ''; X: 1100; Y: 2200),
    (Typ: 28; Name: ''; X: 1620; Y: 2290),
    (Typ: 29; Name: ''; X: 3240; Y: 4580),
    (Typ: 30; Name: ''; X: 2290; Y: 3240),
    (Typ: 31; Name: ''; X: 1140; Y: 1620),
    (Typ: 32; Name: ''; X: 1140; Y: 2290),
    (Typ: 33; Name: ''; X: 2500; Y: 3530),
    (Typ: 34; Name: ''; X: 1760; Y: 2500),
    (Typ: 35; Name: ''; X: 1760; Y: 1250),
    (Typ: 36; Name: ''; X: 1100; Y: 2300),
    (Typ: 37; Name: ''; X: 984; Y: 1905),
    (Typ: 38; Name: ''; X: 920; Y: 1651),
    (Typ: 39; Name: ''; X: 3778; Y: 2794),
    (Typ: 40; Name: ''; X: 2159; Y: 3048),
    (Typ: 41; Name: ''; X: 2159; Y: 3302),
    (Typ: 42; Name: ''; X: 2500; Y: 3530),
    (Typ: 43; Name: ''; X: 1000; Y: 1480),
    (Typ: 44; Name: ''; X: 2286; Y: 2794),
    (Typ: 45; Name: ''; X: 2540; Y: 2794),
    (Typ: 46; Name: ''; X: 3810; Y: 2794),
    (Typ: 47; Name: ''; X: 2200; Y: 2200),
    (Typ: 48; Name: ''; X: 2355; Y: 3048),
    (Typ: 49; Name: ''; X: 2355; Y: 3810),
    (Typ: 50; Name: ''; X: 2969; Y: 4572),
    (Typ: 51; Name: ''; X: 2354; Y: 3223),
    (Typ: 52; Name: ''; X: 2101; Y: 2794),
    (Typ: 53; Name: ''; X: 2100; Y: 2970),
    (Typ: 54; Name: ''; X: 2355; Y: 3048),
    (Typ: 55; Name: ''; X: 2270; Y: 3560),
    (Typ: 56; Name: ''; X: 3050; Y: 4870),
    (Typ: 57; Name: ''; X: 2159; Y: 3223),
    (Typ: 58; Name: ''; X: 2100; Y: 3300),
    (Typ: 59; Name: ''; X: 1480; Y: 2100),
    (Typ: 60; Name: ''; X: 1820; Y: 2570),
    (Typ: 61; Name: ''; X: 3220; Y: 4450),
    (Typ: 62; Name: ''; X: 1740; Y: 2350),
    (Typ: 63; Name: ''; X: 2010; Y: 2760),
    (Typ: 64; Name: ''; X: 4200; Y: 5940),
    (Typ: 65; Name: ''; X: 2970; Y: 4200),
    (Typ: 66; Name: ''; X: 3220; Y: 4450),
    (Typ: pgCustomSize; Name: ''; X: 0; Y: 0));

{----------------------------------------------------------------------------}
Constructor TPrinterSettings.Create;
Var
   I : Integer;
Begin
   inherited Create;
   GetMem(FDevice, 128);
   GetMem(FDriver, 128);
   GetMem(FPort, 128);
   FPaperNames:=TStringList.Create;
   FPrinters:=TStringList.Create;
   For I:=0 to PAPERCOUNT-1 do
   Begin
      if PaperInfo[i].Typ<>pgCustomSize then
         PaperInfo[i].Name:=FRConst_Paper[PaperInfo[i].Typ]
      Else
         PaperInfo[i].Name:=FRConst_Paper[0];
   End;
End;

Destructor TPrinterSettings.Destroy;
begin
   FreeMem(FDevice, 128);
   FreeMem(FDriver, 128);
   FreeMem(FPort, 128);
   FPaperNames.Free;
   FPrinters.Free;
   inherited Destroy;
end;

function TPrinterSettings.Supported(Setting: integer): boolean;
begin
   Supported:=(DevMode^.dmFields and Setting)=Round(Setting);
end;

procedure TPrinterSettings.SetField(aField: integer);
begin
   DevMode^.dmFields:=DevMode^.dmFields Or Round(aField);
end;

procedure TPrinterSettings.FillPrnInfo(Var P: TfrPrnInfo);
begin
   with P do
   begin
      Pgw := (PaperWidth * 96 div 254);
      Pgh := (PaperLength * 96 div 254);
      Ofx := (50 * 96 div 254);
      Ofy := (50 * 96 div 254);
      Pw  := Pgw - Ofx * 2;
      Ph  := Pgh - Ofy * 2;
   End;
End;

function TPrinterSettings.IsEqual(pgSize, pgWidth, pgHeight: Integer; pgOr: TPrinterOrientation): Boolean;
begin
   if (PaperSize=pgSize) And (pgSize=pgCustomSize) then
      Result:=(PaperSize=pgSize) And (PaperWidth=pgWidth) And
              (PaperLength=pgHeight) And (Orientation=pgOr)
   Else
      Result:=(PaperSize=pgSize) And (Orientation=pgOr);
end;

procedure TPrinterSettings.SetPrinterInfo(pgSize, pgWidth, pgHeight: Integer; pgOr: TPrinterOrientation);
begin
   if IsEqual(pgSize, pgWidth, pgHeight, pgOr) then Exit;
   PaperSize:=pgSize;
   PaperWidth:=pgWidth;
   PaperLength:=pgHeight;
   Orientation:=pgOr;
   ApplySettings;
End;

function TPrinterSettings.GetArrayPos(pgSize: Integer): Integer;
Var
   I : Integer;
Begin
   Result:=PaperSizesNum-1;
   for I:= 0 to PaperSizesNum-1 do
   Begin
      if PaperSizes[I]=pgSize then
      begin
         Result:=I;
         break;
      End;
   End;
End;

procedure TPrinterSettings.ApplySettings;
Var
   I, N  : Integer;
begin
   if PrintMode=pmViewing then
   begin
      FPaperNames.Clear;
      for i:=0 to PAPERCOUNT - 1 do
      begin
         FPaperNames.Add(PaperInfo[i].Name);
         PaperSizes[i]:=PaperInfo[i].Typ;
         if (PaperSize <> pgCustomSize) and (PaperSize = PaperInfo[i].Typ) then
         begin
            PaperWidth:=PaperInfo[i].X;
            PaperLength:=PaperInfo[i].Y;
            if Orientation = poLandscape then
            begin
               n:=PaperWidth;
               PaperWidth:=PaperLength;
               PaperLength:=n;
            end;
          end;
      end;
      PaperSizesNum:=PAPERCOUNT;
      Exit;
   end;
   //
   FPrinter.GetPrinter(FDevice, FDriver, FPort, DeviceMode);
   DevMode:=GlobalLock(DeviceMode);
   Try
      if PaperSize=pgCustomSize then
      begin
         SetField(dm_paperlength);
         DevMode^.dmPaperLength := PaperLength;
         SetField(dm_paperwidth);
         DevMode^.dmPaperWidth := PaperWidth;
      End;
      if Supported(dm_PaperSize) then
      begin
         SetField(dm_papersize);
         DevMode^.dmPaperSize := PaperSize;
      End;
      //
      if Supported(dm_orientation) then
      begin
         SetField(dm_orientation);
         if Orientation = poPortrait then
            DevMode^.dmOrientation := dmorient_portrait
         Else
            DevMode^.dmOrientation := dmorient_landscape;
      End;
      FPrinter.SetPrinter(FDevice, FDriver, FPort, DeviceMode);
   Finally
      GlobalUnlock(DeviceMode);
   End;
End;

procedure TPrinterSettings.SetPrinterIndex(Value: Integer);
Var
   DeviceMode : THandle;
   Device,
   Driver,
   Port       : Array[0..255] of Char;
begin
   FPrinterIndex:=Value;
   if PrintMode=pmViewing then
   begin
      ApplySettings;
   end
   else
   Begin
      if FPrinter.Printers.Count>0 then
      begin
         FPrinter.PrinterIndex:=Value;
         FPrinter.GetPrinter(Device, Driver, Port, DeviceMode);
         FPrinter.SetPrinter(Device, Driver, Port, 0);
      End;
   End;
end;

procedure TPrinterSettings.SetPrinter(Value: TPrinter);
begin
   FPrinters.Clear;
   FPrinterIndex:=0;
   FPrinter:=Value;
   if FPrinter.Printers.Count>0 then
   begin
      FPrinters.Assign(FPrinter.Printers);
      FPrinterIndex:=FPrinter.PrinterIndex;
      FPrinters.Clear;
      FPrinterIndex:=0;
   End;
   FPrinters.Add(FRConst_DefaultPrinter);
End;

{----------------------------------------------------------------------------}
INITIALIZATION
   PrinterSettings:=TPrinterSettings.Create;
   PrinterSettings.Printer:=Printer;

FINALIZATION
   PrinterSettings.Free;

END.


