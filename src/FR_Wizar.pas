{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_Wizar;

interface

{$I FR_Vers.inc}

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, DB, FR_Class, FR_Const, ExtCtrls,
  Printers;

const
  Millimeters = 794 / 210;

type
  TReportWizard = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SrcList: TListBox;
    DstList: TListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    ComboBox: TComboBox;
    Label1: TLabel;
    RepTitle: TEdit;
    Label2: TLabel;
    Options: TGroupBox;
    imgLandScape: TImage;
    imgPortrait: TImage;
    Landscape: TRadioButton;
    Portrait: TRadioButton;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure FormActivate(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PortraitClick(Sender: TObject);
  private
    { Private declarations }
    SelDataSet: TDataSet;
  public
    { Public declarations }
  end;

var
  ReportWizard: TReportWizard;

implementation

{$R *.DFM}

uses FR_Desgn;

procedure TReportWizard.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
  if DstList.Items.Count > 0 then OKBtn.Enabled := True;
end;

procedure TReportWizard.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TReportWizard.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I],
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
  if DstList.Items.Count > 0 then OKBtn.Enabled := True;
end;

procedure TReportWizard.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
end;

procedure TReportWizard.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  i: Integer;
begin
  i := 0;
  while (i <= List.Items.Count - 1) do
    begin
      if List.Selected[I] then
        begin
          Items.AddObject(List.Items[I], List.Items.Objects[I]);
          List.Items.Delete(I);
        end 
      else inc(i);
    end;
end;

procedure TReportWizard.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TReportWizard.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TReportWizard.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
    begin
      SetFocus;
      MaxIndex := List.Items.Count - 1;
      if Index = LB_ERR then
        Index := 0
      else
        if Index > MaxIndex then Index := MaxIndex;
      Selected[Index] := True;
    end;
  SetButtons;
end;

procedure TReportWizard.FormActivate(Sender: TObject);
var
  i, j: Integer;
  s: TStringList;
  procedure EnumDataSets(f: TComponent);
  var
    i: Integer;
    c: TComponent;
  begin
    for i := 0 to f.ComponentCount - 1 do
      begin
        c := f.Components[i];
        if c is TDataSet then s.Add(f.Name + '.' + c.Name);
      end;
  end;
begin
  s := TStringList.Create;
  for i := 0 to Screen.FormCount - 1 do
    EnumDataSets(Screen.Forms[i]);
  for i := 0 to Screen.DataModuleCount - 1 do
    EnumDataSets(Screen.DataModules[i]);
  for i := 0 to Screen.FormCount - 1 do
    for j := 0 to Screen.Forms[i].ComponentCount - 1 do
      if Screen.Forms[i].Components[j] is TDataModule then
        EnumDataSets(Screen.Forms[i].Components[j]);
  s.Sort;
  ComboBox.Items.Assign(s);
  s.Free;
end;

procedure TReportWizard.ComboBoxChange(Sender: TObject);
var
  I: Integer;
  SaveAct: Boolean;
begin
  if ComboBox.ItemIndex >= 0 then
    begin
      SelDataSet := FindGlobalDataSet(ComboBox.Items[ComboBox.ItemIndex]);
      SaveAct := SelDataSet.Active;
      SelDataSet.Active := True;
      SelDataSet.FieldDefs.Update;
      SrcList.Items.Clear;
      DstList.Items.Clear;
      for I := 0 to SelDataSet.FieldCount - 1 do
        if not (SelDataSet.Fields[I] is TBlobField) then
          SrcList.Items.Add(SelDataSet.Fields[I].FieldName);
      SelDataSet.Active := SaveAct;
    end;
  if SrcList.Items.Count > 0 then
    begin
      SrcList.ItemIndex := 0;
      IncludeBtn.Enabled := True;
      IncAllBtn.Enabled := True;
    end;
end;

procedure TReportWizard.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TReportWizard.OKBtnClick(Sender: TObject);
var
  Band: TfrBandView;
  Memo: TfrMemoView;
  St, X: Double;
  I, MaxWidth: Integer;
  DSet: TfrDBDataSet;
  S: string;
  SaveAct: Boolean;
begin
  CurReport.NewReport;
  DesignerForm.ClearChangedList;
  CurReport.Title := RepTitle.Text;
  CurReport.DoublePass := True;
  with CurReport.Pages.Pages[0] do
    begin
      if Landscape.Checked then
        begin
          pgMargins.Left := Round(10 * Millimeters);
          pgMargins.Top := Round(10 * Millimeters);
          pgMargins.Right := Round(15 * Millimeters);
          pgMargins.Bottom := Round(10 * Millimeters);
          ChangePaper(pgSize, 0, 0, poLandscape);
          MaxWidth := 1028;
        end
      else
        MaxWidth := 719;
      Objects.Add(frCreateObject(gtBand, ''));
      Band := Objects.Last;
      Band.BandType := btReportTitle;
      Band.Top := 50;
      Band.Height := 29;
      Objects.Add(frCreateObject(gtBand, ''));
      Band := Objects.Last;
      Band.BandType := btPageHeader;
      Band.Top := 116;
      Band.Height := 33;
      Objects.Add(frCreateObject(gtBand, ''));
      Band := Objects.Last;
      Band.BandType := btMasterData;
      Band.Top := 206;
      Band.Height := 21;
      DSet := TfrDBDataSet.Create(nil);
      DSet.DataSet := SelDataSet;
      CurReport.SetDataSetBand(String(Band.Name), DSet);
      Objects.Add(frCreateObject(gtBand, ''));
      Band := Objects.Last;
      Band.BandType := btpageFooter;
      Band.Top := 272;
      Band.Height := 29;
      Objects.Add(frCreateObject(gtMemo, ''));
      Memo := Objects.Last;
      Memo.Left := 37;
      Memo.Top := 54;
      Memo.Width := MaxWidth;
      Memo.Height := 21;
      Memo.Caption := RepTitle.Text;
      Memo.Alignment := frCenter;
      Memo.Color := clTeal;
      Memo.Font.Size := 12;
      Memo.Font.Style := [fsBold];
      Memo.Font.Color := clWhite;
      Objects.Add(frCreateObject(gtMemo, ''));
      Memo := Objects.Last;
      Memo.Left := 37;
      Memo.Top := 281;
      Memo.Width := MaxWidth;
      Memo.Height := 17;
      Memo.Caption := 'Pagina [Page#] di [TotalPages]';
      Memo.Alignment := frRightJustify;
      Memo.FrameWidth := 2;
      Memo.DrawFrameTop := True;
      SaveAct := SelDataSet.Active;
      SelDataSet.Active := True;
      SelDataSet.FieldDefs.Update;
      St := 0;
      for I := 0 to DstList.Items.Count - 1 do
        St := St + (32 * SelDataSet.FieldByName(DstList.Items[I]).DisplayWidth) + 8;
      St := St - 8;
      St := MaxWidth / St;
      X := 0;
      for I := 0 to DstList.Items.Count - 1 do
        begin
          // Draw Title Field.
          Objects.Add(frCreateObject(gtMemo, ''));
          Memo := Objects.Last;
          Memo.Alignment := TFrAlignment(SelDataSet.
            FieldByName(DstList.Items[I]).Alignment);
          Memo.Font.Size := 10;
          Memo.Left := Round(X + 37);
          Memo.Top := 124;
          Memo.Height := 21;
          Memo.Font.Color := clMaroon;
          Memo.Font.Style := [fsBold];
          Memo.FrameWidth := 1;
          Memo.DrawFrameBottom := True;
          Memo.Width := Round(SelDataSet.FieldByName(
            DstList.Items[I]).DisplayWidth * 32 * St);
          Memo.Caption := SelDataSet.FieldByName(DstList.Items[I]).DisplayLabel;
          // Draw Data Fields.
          Objects.Add(frCreateObject(gtMemo, ''));
          Memo := Objects.Last;
          Memo.Alignment := TFrAlignment(SelDataSet.
            FieldByName(DstList.Items[I]).Alignment);
          Memo.Font.Size := 10;
          Memo.Left := Round(X + 37);
          Memo.Top := 206;
          Memo.Height := 21;
          Memo.Width := Round(SelDataSet.FieldByName(
            DstList.Items[I]).DisplayWidth * 32 * St);
          S := '"' + SelDataSet.FieldByName(DstList.Items[I]).FieldName + '"';
          if SelDataSet.FieldByName(DstList.Items[I]) is TCurrencyField then
            S := 'MONEY(' + S + ')';
          Memo.Caption := '[' + S + ']';
          X := X + (SelDataSet.FieldByName(
            DstList.Items[I]).DisplayWidth * 32 + 8) * St;
        end;
      SelDataSet.Active := SaveAct;
    end;
  DesignerForm.ChangeObject;
  ModalResult := mrOK;
end;

procedure TReportWizard.FormCreate(Sender: TObject);
begin
  Caption := FRConst_ReportWizardCaption;
  Label1.Caption := FRConst_ReportWizardLabCapt1;
  Label2.Caption := FRConst_ReportWizardLabCapt2;
  SrcLabel.Caption := FRConst_ReportWizardSrcLabCap;
  DstLabel.Caption := FRConst_ReportWizardDstLabCap;
  Options.Caption := FRConst_ReportWizardOptionsCap;
  Landscape.Caption := FRConst_ReportWizardLandCap;
  Portrait.Caption := FRConst_ReportWizardPortCap;
  OKBtn.Caption := FRConst_OK;
  CancelBtn.Caption := FRCOnst_Cancel;
end;

procedure TReportWizard.PortraitClick(Sender: TObject);
begin
  imgPortrait.Visible := Portrait.Checked;
  imgLandscape.Visible := not Portrait.Checked;
end;

end.
