
{*****************************************}
{                                         }
{             FastReport v2.2             }
{            Various routines             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Utils;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  DB, Forms, StdCtrls, ClipBrd, Menus ,Buttons, AnsiStrings;

Procedure AddDescription (FunctionName,Category,Help:String;ParamNum:Integer);
procedure frReadMemo(Stream:TStream; l:TStrings);
procedure frWriteMemo(Stream:TStream; l:TStrings);
procedure frEnableControls(c: Array of TControl; e:Boolean);
function  frGetDataSet(ComplexName:String): TDataSet;
procedure frGetDataSetAndField(ComplexName:String; var DataSet:TDataSet; var Field:TField);
//Itta
Function  BmpStartInBlobField(BlobStream:TStream):Integer;
Function  JpegStartInBlobField(BlobStream:TStream):Integer;
Function  EmfStartInBlobField(BlobStream:TStream):Integer;
Function  IcoStartInBlobField(BlobStream:TStream):Integer;

Var
   DescriptionList: TStringList;
   //
   
implementation

uses FR_Class, FR_Const, TypInfo;

Procedure AddDescription (FunctionName,Category,Help:String;ParamNum:Integer);
Const Parametri:Array [1..3] Of String=('<X>','<Y>','<Z>');
Var I:Integer;
    ParamStr:String;
Begin
  ParamStr:='';
  For I:=1 To ParamNum Do
    Begin
      ParamStr:=ParamStr+Parametri[I];
      If I<>ParamNum Then ParamStr:=ParamStr+','
    End;
  DescriptionList.Add(FunctionName+'='+Category+'|'+FunctionName+'('+ParamStr+') |'+Help);
End;

procedure RemoveQuotes(var s:String);
begin
  if (s[1] = '"') and (s[Length(s)] = '"') then
    s := Copy(s,2,Length(s)-2);
end;

procedure frReadMemo(Stream:TStream; l:TStrings);
var
   s: String[255];
   Y: AnsiString;
   I,J: Integer;
   B: Byte;
   W,X: Word;
   A: Array [0..1023] Of AnsiChar;
begin
   l.Clear;
   If frVersion<26 Then
   Begin
      i := 1;
      repeat
         Stream.Read(b,1);
         if (b = 13) or (b = 0) then
         begin
            s[0] := AnsiChar(i-1);
            if not ((b = 0) and (i = 1)) then
               l.Add(UTF8ToString(s));
            i := 1;
         end
         else
            if b <> 0 then
            begin
               s[i] := AnsiChar(b);
               Inc(i);
            end;
      until b = 0;
   End
   Else
   Begin
      Stream.Read (X,2);
      For I := 0 To X-1 Do
      Begin
         Stream.Read(W,2);
         Stream.Read(A,W);
         Y:='';
         For J:=0 To W-1 Do Y:=Y+A[J];
         L.Add(UTF8ToString(Y));
      End;
   End;
end;

procedure frWriteMemo(Stream:TStream; L:TStrings);
var
   I: Integer;
   B: Word;
   Y: AnsiString;
   A: Array [0..1023] Of AnsiChar;
begin
  B:=L.Count;
  Stream.Write(B,2);
  For I := 0 To L.Count-1 Do
  Begin
     Y:=UTF8Encode(L[I]);
     AnsiStrings.StrCopy(A,PAnsiChar(Y));
     B:=Length(Y);
     If B>SizeOf(A) Then
        B:=SizeOf(A);
     Stream.Write(B,2);
     Stream.Write(A,B);
  End;
end;

procedure frEnableControls(c: Array of TControl; e:Boolean);
const
  Clr1: Array[Boolean] of TColor = (clGrayText,clWindowText);
  Clr2: Array[Boolean] of TColor = (clBtnFace,clWindow);
var i: Integer;
begin
  for i := Low(c) to High(c) do
    if c[i] is TLabel then
      with c[i] as TLabel do
      begin
        Font.Color := Clr1[e];
        Enabled := e;
      end
    else if c[i] is TEdit then
      with c[i] as TEdit do
      begin
        Color := Clr2[e];
        Enabled := e;
      end;
end;

function frGetDataSet(ComplexName:String): TDataSet;
var n: Integer;
    f: TComponent;
    s1,s2: String;
    X : TComponent;
begin
  Result := nil;
  f := CurReport.Owner;
  n := Pos('.',ComplexName);
  if n = 0 then 
  Begin
     X:=f.FindComponent(ComplexName);
     If X.InheritsFrom(TfrDBDataSet) Then
        f:=TfrDBDataSet(X).DataSet 
     Else
        f:=f.FindComponent(ComplexName)
     //f:=f.FindComponent(ComplexName)
  End
  else
  begin
    s1 := Copy(ComplexName, 1, n-1);        // module name
    s2 := Copy(ComplexName, n+1, 255);      // database name
    f:=FindGlobalComponent(s1);
    if f<>nil then 
    Begin
       X:=f.FindComponent(s2);
       If X.InheritsFrom(TfrDBDataSet) Then
        f:=TfrDBDataSet(X).DataSet 
       Else
         f:=f.FindComponent(s2)
       //f:=f.FindComponent(s2);
    End;
  end;
  If f<>nil Then Result:=f as TDataSet
            Else
     DoError (FRConst_ErrorLoadfrDataSet+' '+ComplexName);
end;

procedure frGetDataSetAndField(ComplexName:String; var DataSet:TDataSet;
  var Field:TField);
var n: Integer;
    f: TComponent;
    s1,s2,s3: String;
    X : TComponent;
begin
  Field := nil;
  f := CurReport.Owner;
  n := Pos('.',ComplexName);
  if n <> 0 then
  begin
    s1 := Copy(ComplexName, 1, n-1);        // table name
    s2 := Copy(ComplexName, n+1, 255);      // field name
    if (s2[1]<>'"') And (Pos('.',s2) <> 0) then   // module name present
    begin
      s3 := Copy(s2,Pos('.',s2)+1,255);
      s2 := Copy(s2,1,Pos('.',s2)-1);
      f := FindGlobalComponent(s1);
      if f <> nil then
      begin
         X:=f.FindComponent(s2);
         If X.InheritsFrom(TfrDBDataSet) Then
            DataSet:=TfrDBDataSet(X).DataSet 
         Else
            DataSet:=f.FindComponent(s2) as TDataSet;
      
         //DataSet := f.FindComponent(s2) as TDataSet;
         //Itta :Fine

        RemoveQuotes(s3);
        if DataSet <> nil then Field := DataSet.FindField(s3);
      end;
    end
    else
    begin
      //Itta : Inizio
      X:=f.FindComponent(s1);
      If (X<>Nil) And (X.InheritsFrom(TfrDBDataSet)) Then
         DataSet:=TfrDBDataSet(X).DataSet 
      Else
         DataSet:=f.FindComponent(s1) as TDataSet;
      
      //DataSet := f.FindComponent(s1) as TDataSet;
      //Itta :Fine
      RemoveQuotes(s2);
      if DataSet <> nil then Field := DataSet.FindField(s2)
                        Else
        Begin
          f := FindGlobalComponent(s1);
          if f <> nil then DataSet := f.FindComponent(s2) as TDataSet
        End;
    end;
  end
  else
  if DataSet <> nil then
  begin
    RemoveQuotes(ComplexName);
    Field:=DataSet.FindField(ComplexName);
  end;
end;

Function  BmpStartInBlobField(BlobStream:TStream):Integer;
Const
   MaxPos = $10;
Var
   Buffer : Word;
   Hex    : AnsiString;
Begin
   Result:=-1;
   If Not Assigned(BlobStream) Then Exit;
   BlobStream.Seek(0,soFromBeginning);
   While (Result=-1) And (BlobStream.Position<MaxPos) And
      (BlobStream.Position+1<BlobStream.Size) Do
   Begin
      BlobStream.ReadBuffer(Buffer,1);
      Hex:=UTF8Encode(IntToHex(Buffer Mod 256,2));
      If Hex='42' then
      Begin
        BlobStream.ReadBuffer(Buffer,1);
        Hex:=UTF8Encode(IntToHex(Buffer Mod 256,2));
        If Hex='4D' Then
           Result:=BlobStream.Position-2;
      End;
   End;
End;

Function  JpegStartInBlobField(BlobStream:TStream):Integer;
Const
   MaxPos = $10;
Var
   Buffer : Word;
   Hex    : AnsiString;
Begin
   Result:=-1;
   If Not Assigned(BlobStream) Then Exit;
   BlobStream.Seek(0,soFromBeginning);
   While (Result=-1) And (BlobStream.Position<MaxPos) And
      (BlobStream.Position+1<BlobStream.Size) Do
   Begin
      BlobStream.ReadBuffer(Buffer,1);
      Hex:=UTF8Encode(IntToHex(Buffer Mod 256,2));
      If Hex='FF' then
      Begin
        BlobStream.ReadBuffer(Buffer,1);
        Hex:=UTF8Encode(IntToHex(Buffer Mod 256,2));
        If Hex='D8' Then
           Result:=BlobStream.Position-2
        Else
           If Hex='FF' then
              BlobStream.Position:=BlobStream.Position-1;
      End;
   End;
End;

Function  IcoStartInBlobField(BlobStream:TStream):Integer;
Var
   Buffer : Word;
   W0, W1,
   W8, W9 : Word;
Begin
   Result:=-1;
   If Not Assigned(BlobStream) Then Exit;
   BlobStream.Seek(0,soFromBeginning);
   BlobStream.ReadBuffer(Buffer,1);   //1
   W0:=Buffer; // Move(S[1], W0, 2);
   BlobStream.ReadBuffer(Buffer,1);   //2
   BlobStream.ReadBuffer(Buffer,1);   //3
   W1:=Buffer; //Move(S[3], W1, 2);
   BlobStream.ReadBuffer(Buffer,1);   //4
   BlobStream.ReadBuffer(Buffer,1);   //5
   BlobStream.ReadBuffer(Buffer,1);   //6
   BlobStream.ReadBuffer(Buffer,1);   //7
   BlobStream.ReadBuffer(Buffer,1);   //8
   BlobStream.ReadBuffer(Buffer,1);   //9
   W8:=Buffer; //Move(S[9], W1, 2);
   BlobStream.ReadBuffer(Buffer,1);   //10
   BlobStream.ReadBuffer(Buffer,1);   //11
   W9:=Buffer; //Move(S[11], W1, 2);
   //
   if ((W0 = 0) And (W1 = 1)) Or
      ((W8 = 0) And (W9 = 1)) Then
   begin
      Result:=0;
      if (W8 = 0) and (W9 = 1) then
         Result:=8;
   end;
End;

Function  EmfStartInBlobField(BlobStream:TStream):Integer;
Const
   MaxPos = $30;
Var
   Buffer : Word;
   Hex    : AnsiString;
Begin
   Result:=-1;
   If Not Assigned(BlobStream) Then Exit;
   BlobStream.Seek(0,soFromBeginning);
   While (Result=-1) And (BlobStream.Position<MaxPos) And
      (BlobStream.Position+1<BlobStream.Size) Do
   Begin
      BlobStream.ReadBuffer(Buffer,1);
      Hex:=UTF8Encode(IntToHex(Buffer Mod 256,2));
      If Hex='45' then
      Begin
        BlobStream.ReadBuffer(Buffer,1);
        Hex:=UTF8Encode(IntToHex(Buffer Mod 256,2));
        If Hex='4D' Then
           Result:=BlobStream.Position-2
        Else
           If Hex='46' then
              BlobStream.Position:=BlobStream.Position-1;
      End;
   End;
   If Result>0 Then
   Begin
      Result:=0;
      If Result>$20 Then
         Result:=8;
   End;
End;

INITIALIZATION
   DescriptionList := TStringList.Create;
   //

FINALIZATION
   DescriptionList.Free;
   //
   
END.
