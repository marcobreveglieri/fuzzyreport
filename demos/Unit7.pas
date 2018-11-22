unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class;

type
  TForm7 = class(TForm)
    frReport1: TfrReport;
    Dialog1: TOpenDialog;
    procedure frReport1BeginDoc;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure StartReport;
  end;

var
  Form7: TForm7;

implementation

{$R *.DFM}

var FName: String;

procedure TForm7.StartReport;
begin
  with Dialog1 do
    if Execute then
    begin
      FName := FileName;
      frReport1.ShowReport
    end;
end;

procedure TForm7.frReport1BeginDoc;
begin
  // Utilizzando il metodo FindObject, è possibile individuare un oggetto
  // tramite il suo nome per modificarloa run-time.
  TfrMemoView(frReport1.FindObject ('Titolo')).Memo.Add(FName);
  TfrMemoView(frReport1.FindObject ('Testo')).Memo.LoadFromFile(FName);
end;

end.
