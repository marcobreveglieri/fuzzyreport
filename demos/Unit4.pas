unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class, DB;

type
  TForm4 = class(TForm)
    frReport1: TfrReport;
    procedure frReport1DataSetWork(BandName: String; DataSet: TDataSet;
      var RecordCount: Integer; Operation: TfrDataSetOperation);
  private
    { Private declarations }
    Bookmark: TBookmark;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses datasets;

{$R *.DFM}

var LastLetter: Char;

procedure TForm4.frReport1DataSetWork(BandName: String; DataSet: TDataSet;
  var RecordCount: Integer; Operation: TfrDataSetOperation);
begin
   If Not CustomerData.Customers.Active Then
      CustomerData.Customers.Active:=True;

  If BandName='Master' Then
    Case Operation of
      opInit  : RecordCount := CustomerData.Customers.RecordCount; // Setta la lunghezza del vettore
      opFirst : Begin
                  // Porta il vettore al primo elemento
                  CustomerData.Customers.First;
                  Bookmark := CustomerData.Customers.Bookmark;
                End;
      OpNext  : Begin
                  // Sposta il vettore all'elemento successivo
                  If CustomerData.Customers.EOF Then RecordCount:=0
                                                Else
                    Bookmark := CustomerData.Customers.Bookmark;
                End;
    End
                       Else
  If BandName='Dettagli' Then
    Case Operation of
      opInit  : Begin
                  // Setta la lunghezza del vettore
                  RecordCount :=CustomerData.Customers.RecordCount;
                End;
      opFirst : Begin
                  // Porta il vettore al primo elemento
                  RecordCount :=CustomerData.Customers.RecordCount;
                  CustomerData.Customers.Bookmark := Bookmark;
                  LastLetter := CustomerData.CustomersCompany.AsString[1];
                End;
      OpNext  : Begin
                  // Sposta il vettore all'elemento successivo
                  CustomerData.Customers.Next;
                  If (CustomerData.CustomersCompany.AsString[1] <> LastLetter) or
                     (CustomerData.Customers.EOF) Then
                    RecordCount:=0;
                End;
    End
end;

end.
