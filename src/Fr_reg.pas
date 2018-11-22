
{*****************************************}
{                                         }
{             FastReport v2.2             }
{            Registration unit            }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_reg;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DesignIntf, DesignEditors, DB, Dialogs,
  FR_Const, FR_Class, FR_Ev_ed, FR_Newrp, FR_Rich, FR_Desgn, FR_Utils, FR_Shape,
  FR_CBar, FR_Graph, FR_OLE, FR_FMemo, FR_ETxt, FR_ERtf, FR_EPdf;

procedure Register;

implementation

{-----------------------------------------------------------------------}
type
  TVarEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure DoCreateNew;
    procedure DoCreateTempl;
    procedure DoOpen;
    procedure DoDesign;
    procedure DoPreview;
  end;

procedure TVarEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: DoDesign;
    1: DoPreview;
    2, 6: ;
    3: DoCreateNew;
    4: DoCreateTempl;
    5: DoOpen;
    7: if ShowEvEditor(TfrReport(Component)) then Designer.Modified;
  end;
end;

function TVarEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := FRConst_DesignReport;
    1: Result := FRConst_PreviewReport;
    2, 6: Result := '-';
    3: Result := FRConst_NewReport;
    4: Result := FRConst_NewFromTemplate;
    5: Result := FRConst_OpenReport;
    7: Result := FRConst_VarEditor;
  end;
end;

function TVarEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;

procedure TVarEditor.DoCreateNew;
begin
  TfrReport(Component).Pages.Clear;
  TfrReport(Component).DesignReport;
end;

procedure TVarEditor.DoCreateTempl;
begin
  TemplForm := TTemplForm.Create(nil);
  with TemplForm do
    if ShowModal = mrOk then
      begin
        TfrReport(Component).LoadTemplate(TemplName, nil, nil, True);
        TfrReport(Component).DesignReport;
      end;
  TemplForm.Free;
end;

procedure TVarEditor.DoOpen;
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(nil);
  od.Filter := FRConst_FormFile + ' (*.frf)|*.frf';
  if od.Execute then
    begin
      TfrReport(Component).LoadFromFile(od.Filename);
      TfrReport(Component).DesignReport;
    end;
  od.Free;
end;

procedure TVarEditor.DoDesign;
begin
  TfrReport(Component).DesignReport;
end;

procedure TVarEditor.DoPreview;
begin
  TfrReport(Component).ShowReport;
end;

{-----------------------------------------------------------------------}
type
  TValuesProperty = class(TPropertyEditor)
  public
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

function TValuesProperty.GetValue: string;
begin
  Result := Format('(%s)', [TfrValues.ClassName]);
end;

function TValuesProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog];
end;

procedure TValuesProperty.Edit;
begin
  if ShowEvEditor(TfrReport(GetComponent(0))) then Designer.Modified;
end;

{-----------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents(FRConst_ReportName, [TfrReport, TfrCompositeReport]);
  RegisterComponents(FRConst_ReportName, [TfrUserDataset, TfrDBDataSet, 
     TfrRichObject, TfrShapeObject, TfrCodeBarreObject,
     TfrGraphObject, TfrOLEObject, TfrFramedMemoObject, TfrDesigner,
     TfrTextExportObject, TfrRichExportObject, TFrEPDFExportObject]);
  RegisterComponentEditor(TfrReport, TVarEditor);
  RegisterPropertyEditor(TypeInfo(TfrValues), TfrReport, 'Values', TValuesProperty);
end;

end.

