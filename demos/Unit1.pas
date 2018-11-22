unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DB, ComCtrls, ImgList, Buttons,
  FR_Class, FR_Desgn, FR_Rich, Fr_Graph, FR_CBar, FR_OLE, FR_FMemo,
  Fr_Shape, FR_ERtf, FR_ETxt, FR_EPdf, jpeg;

type
  TForm1 = class(TForm)
    Button1: TSpeedButton;
    Button2: TSpeedButton;
    Button3: TSpeedButton;
    frCompositeReport1: TfrCompositeReport;
    frDesigner1: TfrDesigner;
    TreeView1: TTreeView;
    ImageList1: TImageList;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Memo2: TMemo;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    frRichObject1: TfrRichObject;
    frCodeBarreObject1: TfrCodeBarreObject;
    frGraphObject1: TfrGraphObject;
    frOLEObject1: TfrOLEObject;
    frFramedMemoObject1: TfrFramedMemoObject;
    frShapeObject1: TfrShapeObject;
    frTextExportObject1: TfrTextExportObject;
    frRichExportObject1: TfrRichExportObject;
    Generazione: TSpeedButton;
    FrEPDFExportObject1: TFrEPDFExportObject;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenerazioneClick(Sender: TObject);
  private
    procedure GoReport(Rep: TfrReport);
    { Private declarations }
  public
    { Public declarations }
    function CurDoc:Integer;
  end;

var
  Form1: TForm1;

implementation

uses DataSets, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8;

{$R *.DFM}

var
   DocArr: Array[0..19] of TfrReport;
   Path: String;

{-----------------------------------------------------------------------------}
function TForm1.CurDoc:Integer;
begin
  If TreeView1.Selected=Nil Then Result := -1
                            Else Result := TreeView1.Selected.StateIndex;
end;

procedure TForm1.FormActivate(Sender: TObject);
var i: Integer;
begin
  DocArr[0] := Form3.frReport1; 
  DocArr[1] := Form3.frReport2;
  DocArr[2] := Form4.frReport1; 
  DocArr[3] := Form3.frReport3;
  DocArr[4] := Form5.frReport1; 
  DocArr[5] := Form6.frReport1;
  DocArr[6] := Form7.frReport1; 
  DocArr[7] := frCompositeReport1;
  DocArr[8] := Form6.frReport1; 
  DocArr[9] := Form3.frReport4;
  DocArr[10]:= Form8.frReport1; 
  DocArr[11]:= Form8.frReport2;
  DocArr[12]:= Form3.frReport5; 
  DocArr[13]:= Form3.frReport6;
  DocArr[14]:= Form3.frReport7; 
  DocArr[15]:= Form3.frReport8;
  DocArr[16]:= Form3.frReport9; 
  DocArr[17]:= Form3.frReport10;
  DocArr[18]:= Form3.frReport11; 
  DocArr[19]:= Form3.frReport12;
  with frCompositeReport1 do
  begin
    Reports.Clear;
    for i := 0 to 5 do
      Reports.Add(DocArr[i]);
    DoublePass := True;
  end;
  Path := ExtractFilePath(ParamStr(0));
  TreeView1.Selected := TreeView1.Items[1];
  TreeView1Change (Nil,TreeView1.Selected);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DocArr[CurDoc].DesignReport;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
   MS : TMemoryStream;
begin
  DocArr[CurDoc].SaveToFile(Path + 'Doc' + IntToStr(CurDoc) + '.frf');
  MS:=TMemoryStream.Create;
  Try
     DocArr[CurDoc].SaveToStream(MS);
     MS.SaveToFile(Path + 'Doc' + IntToStr(CurDoc) + '.frs');
  Finally
     MS.Free;
  End;
end;

Procedure TForm1.GoReport(Rep:TfrReport);
Begin
   Try
      Rep.ShowReport;
   Except
      Exit;
   End;
End;

procedure TForm1.Button3Click(Sender: TObject);
var i: Integer;
begin
  //ShowMessage(IntToStr(CurDoc)+' '+DocArr[CurDoc].FileName);
  if CurDoc = 4 then
    Form5.StartReport
  else 
     if CurDoc = 6 then
       Form7.StartReport
     Else 
     Begin
        if CurDoc=7 then
        Begin
          for i:=0 to 6 do
            DocArr[i].LoadFromFile(Path + 'Doc' + IntToStr(i) + '.frf');
          DocArr[CurDoc].ShowReport;
        End
        Else
        Begin
           I:=CurDoc;
           Try
              GoReport(DocArr[I]);//DocArr[I].ShowReport;
           Except   
              Exit;
           End;
        End;
     End;

  If CurDoc=0 Then
     DataSets.CustomerData.Customers.Open;
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
Var N_Line,N_Count: Integer;
begin
  If (CurDoc <> 7) And (CurDoc <> -1) Then
    Begin
      Button1.Enabled := True;
      Button2.Enabled := True;
      Button3.Enabled := True;
      Generazione.Enabled := True;
      DocArr[CurDoc].LoadFromFile(Path + 'Doc' + IntToStr(CurDoc) + '.frf');
    End
    Else
    Begin
      Button1.Enabled := False;
      Button2.Enabled := False;
      Generazione.Enabled := False;
      If CurDoc = -1 Then Begin
                            Button3.Enabled := False;
                            Memo1.Lines.Clear;
                          End
                     Else Button3.Enabled := True;
    End;
    If CurDoc<>-1 Then Begin
                         N_Line := 0;
                         N_Count := 0;
                         While N_Count<>CurDoc Do
                           Begin
                             If Memo2.Lines[N_Line]='|' Then Inc (N_Count);
                             Inc (N_Line);
                           End;
                         Memo1.Lines.Clear;
                         While Memo2.Lines[N_Line]<>'|' Do
                           Begin
                             Memo1.Lines.Add (Memo2.Lines[N_Line]);
                             Inc (N_Line);
                           End;
                       End;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.GenerazioneClick(Sender: TObject);
Var
   FName : String;
begin
  //DocArr[CurDoc].PrepareReport;
  If DocArr[CurDoc].PrepareReport Then
  Begin
     FName:=ChangeFileExt(DocArr[CurDoc].FileName,'.Frp');
     DocArr[CurDoc].SavePreparedReport(FName);
     FName:=ChangeFileExt(DocArr[CurDoc].FileName,'.Pdf');
     DocArr[CurDoc].ExportTo(TfrEPDFExportFilter,FName);
     ShowMessage('Report '+FName+' generazione Pdf O.K.');
     FName:=ChangeFileExt(DocArr[CurDoc].FileName,'.Txt');
     DocArr[CurDoc].ExportTo(TfrTextExportFilter,FName);
     ShowMessage('Report '+FName+' generazione Txt O.K.');
     FName:=ChangeFileExt(DocArr[CurDoc].FileName,'.Rtf');
     DocArr[CurDoc].ExportTo(TfrRichExportFilter,FName);
     ShowMessage('Report '+FName+' generazione Rtf O.K.');
  End;
  If DocArr[CurDoc].FileName='DOC0' Then
     DataSets.CustomerData.Customers.Open;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TreeView1.FullExpand;
end;

end.
