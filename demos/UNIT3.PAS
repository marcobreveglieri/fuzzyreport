unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class;

type
  TForm3 = class(TForm)
    frReport1: TfrReport;
    frReport3: TfrReport;
    frReport2: TfrReport;
    frReport4: TfrReport;
    frReport5: TfrReport;
    frReport6: TfrReport;
    frReport7: TfrReport;
    frReport8: TfrReport;
    frReport9: TfrReport;
    frReport10: TfrReport;
    frReport11: TfrReport;
    frReport12: TfrReport;
    procedure frReport1BeginDoc;
    procedure frReport1EndDoc;
    procedure frReport2BeginDoc;
    procedure frReport2EndDoc;
    procedure frReport3EndDoc;
    procedure frReport3BeginDoc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses datasets;

{$R *.DFM}

procedure TForm3.frReport1BeginDoc;
begin
//   ShowMessage('Inizio: '+frReport1.Title);
end;

procedure TForm3.frReport1EndDoc;
begin
//   ShowMessage('Fine: '+frReport1.Title);
end;

procedure TForm3.frReport2BeginDoc;
begin
//   ShowMessage('Inizio: '+frReport2.Title);
end;

procedure TForm3.frReport2EndDoc;
begin
//   ShowMessage('Fine: '+frReport2.Title);
end;

procedure TForm3.frReport3BeginDoc;
begin
//   ShowMessage('Inizio: '+frReport3.Title);
end;

procedure TForm3.frReport3EndDoc;
begin
//   ShowMessage('Fine: '+frReport3.Title);
end;

end.
 