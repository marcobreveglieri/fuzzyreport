unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class, DB;

type
  TForm5 = class(TForm)
    frReport1: TfrReport;
    procedure frReport1GetValue(const ParName: string;
      var ParValue: Variant);
    procedure FormCreate(Sender: TObject);
    procedure frReport1DataSetWork(BandName: String; DataSet: TDataSet;
      var RecordCount: Integer; Operation: TfrDataSetOperation);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure StartReport;
  end;

var
  Form5: TForm5;

implementation

uses datasets, Unit2;

{$R *.DFM}

var i,j: Integer;
    RowCount,ColCount: Integer;

procedure TForm5.FormCreate(Sender: TObject);
begin
  ColCount := 16; RowCount := 20;
end;

procedure TForm5.StartReport;
begin
  if Form2.ShowModal = mrOk then
  begin
    ColCount := StrToInt(Form2.Edit1.Text);
    RowCount := StrToInt(Form2.Edit2.Text);
    frReport1.ShowReport;
  end;
end;

procedure TForm5.frReport1GetValue(const ParName: string;
  var ParValue: Variant);
begin
  if AnsiUpperCase(ParName) = 'CELL' then
    ParValue := IntToStr(i*ColCount+j+1);
end;

procedure TForm5.frReport1DataSetWork(BandName: String; DataSet: TDataSet;
  var RecordCount: Integer; Operation: TfrDataSetOperation);
begin
  If BandName='Righe' Then
    Case Operation of
      opInit  : RecordCount := RowCount; // Setta la lunghezza del vettore
      opFirst : i := 0;                  // Porta il vettore al primo elemento
      OpNext  : Inc(i);                  // Sposta il vettore all'elemento successivo
    End
                      Else
  If BandName='Colonne' Then
    Case Operation of
      opInit  : RecordCount := ColCount; // Setta la lunghezza del vettore
      opFirst : j := 0;                  // Porta il vettore al primo elemento
      OpNext  : Inc(j);                  // Sposta il vettore all'elemento successivo
    End;

end;

end.
