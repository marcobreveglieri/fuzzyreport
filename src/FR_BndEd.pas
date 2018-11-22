
{*****************************************}
{                                         }
{             FastReport v2.2             }
{     Select Band datasource dialog       }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_BndEd;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Class, FR_Const, ComCtrls, DB, Buttons;

type
  TBandEditorForm = class(TForm)
    Label1: TLabel;
    CB1: TComboBox;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    UpDown1: TUpDown;
    BitBtn1: TBitBtn;
    GroupFilter: TGroupBox;
    ActiveFilter: TCheckBox;
    Label5: TLabel;
    Filter: TEdit;
    procedure CB1Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ActiveFilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure FillCombo;
  public
    { Public declarations }
    procedure ShowEditor(t: TfrView);
  End;

var
  BandEditorForm: TBandEditorForm;

implementation

{$R *.DFM}

var
  View: TfrView;

procedure TBandEditorForm.ShowEditor(t: TfrView);
var
  i: Integer;
  TD: TfrDataSet;
begin
  View := T;
  FillCombo;
  if CurReport.DataSetList.Find(T.FormatStr, I) then
    begin
      TD := CurReport.DataSetList.Objects[I] as TfrDataSet;
      if TD is TfrDBDataSet then
        begin
          try
            I := CB1.Items.IndexOf(TfrDBDataSet(TD).DataSet.Owner.Name + '.' +
              TfrDBDataSet(TD).DataSet.Name);
          except
            I := -1;
          end;
          ActiveFilter.Enabled := True;
          ActiveFilter.Checked := TfrDBDataSet(TD).Filtered;
          Label5.Enabled := ActiveFilter.Checked;
          Filter.Enabled := ActiveFilter.Checked;
          Filter.Text := TfrDBDataSet(TD).Filter;
        end
      else
        I := CB1.Items.IndexOf(FRConst_VirtualDataSet);

      if I = -1 then
        I := CB1.Items.IndexOf(FRConst_NotAssigned);
      CB1.ItemIndex := I;
      case TD.RangeBegin of
        rbFirst: ComboBox1.ItemIndex := 0;
        rbCurrent: ComboBox1.ItemIndex := 1;
      end;
      case TD.RangeEnd of
        reLast: ComboBox2.ItemIndex := 0;
        reCurrent: ComboBox2.ItemIndex := 1;
        reCount: ComboBox2.ItemIndex := 2;
      end;
      UpDown1.Position := TD.RangeEndCount;
    end
  else
    begin
      ComboBox1.ItemIndex := 0;
      ComboBox2.ItemIndex := 0;
      UpDown1.Position := 0;
      i := CB1.Items.IndexOf(FRConst_NotAssigned);
      CB1.ItemIndex := i;
    end;
  CB1Change(CB1);
  ComboBox2Change(nil);
  if ShowModal = mrOk then
    begin
      if CurReport.DataSetList.Find(T.FormatStr, I) then
        begin
          if TfrDataSet(CurReport.DataSetList.Objects[I]).Owner = nil then
            TfrDataSet(CurReport.DataSetList.Objects[I]).Free
          else
            CurReport.DataSetList.Delete(I);
        end;
      if CB1.Items[CB1.ItemIndex] = FRConst_NotAssigned then
        begin
          T.FormatStr := '';
          Exit;
        end
      else
        if CB1.Items[CB1.ItemIndex] = FRConst_VirtualDataSet then
          TD := TfrDataSet.Create(nil)
        else
          TD := TfrDBDataSet.Create(nil);

      if T.ParentReport <> nil then
        TD.Name := T.ParentReport.Name + '_' +UTF8ToString(T.Name) + '_DataSet'
      else
        TD.Name := UTF8ToString(T.Name) + '_' + IntToStr(T.Left) + '_DataSet';

      if TD is TfrDBDataSet then
        begin
          TfrDBDataSet(TD).DataSet := FindGlobalDataSet(CB1.Items[CB1.ItemIndex]);
          TfrDBDataSet(TD).Filtered := ActiveFilter.Checked;
          TfrDBDataSet(TD).Filter := Filter.Text;
        end;

      case ComboBox1.ItemIndex of
        0: TD.RangeBegin := rbFirst;
        1: TD.RangeBegin := rbCurrent;
      end;
      case ComboBox2.ItemIndex of
        0: TD.RangeEnd := reLast;
        1: TD.RangeEnd := reCurrent;
        2: TD.RangeEnd := reCount;
      end;
      TD.RangeEndCount := UpDown1.Position;
      CurReport.DataSetList.AddObject(TD.Name, TD);
      T.FormatStr := TD.Name;
    end;
End;

procedure TBandEditorForm.FillCombo;
var
  i, j: Integer;

  procedure EnumComponents(C: TComponent);
  var
    I: Integer;
    F: TComponent;
    X: String; 
  begin
    for I := 0 to C.ComponentCount - 1 do
    begin
        F := C.Components[I];
        if F is TDataSet then 
        Begin
           X:=C.Name+'.'+F.Name;
           If CB1.Items.IndexOf(X)<0 Then
              CB1.Items.Add(X);
        End;
    End;
  end;

Begin
  CB1.Items.Add(FRConst_NotAssigned);
  CB1.Items.Add(FRConst_VirtualDataSet);

  for i := 0 to Screen.FormCount - 1 do
    EnumComponents(Screen.Forms[i]);
  for i := 0 to Screen.DataModuleCount - 1 do
    EnumComponents(Screen.DataModules[i]);
  for i := 0 to Screen.FormCount - 1 do
    for j := 0 to Screen.Forms[i].ComponentCount - 1 do
      if Screen.Forms[i].Components[j] is TDataModule then
        EnumComponents(Screen.Forms[i].Components[j]);
end;

procedure TBandEditorForm.CB1Change(Sender: TObject);
begin
  if CB1.Items[CB1.ItemIndex] = FRConst_VirtualDataSet then
    begin
      Label2.Enabled := False;
      Label3.Enabled := False;
      ComboBox1.ItemIndex := 0;
      ComboBox1.Enabled := False;
      ComboBox2.ItemIndex := 2;
      ComboBox2.Enabled := False;
      Button1.Enabled := True;
      ActiveFilter.Enabled := False;
      Filter.Enabled := False;
      Label5.Enabled := Filter.Enabled;
      ComboBox2Change(nil);
    end
  else
    if CB1.Items[CB1.ItemIndex] = FRConst_NotAssigned then
      begin
        Label2.Enabled := False;
        Label3.Enabled := False;
        ComboBox1.Enabled := False;
        ComboBox2.Enabled := False;
        Label4.Enabled := False;
        Edit3.Enabled := False;
        UpDown1.Enabled := False;
        //      Button1.Enabled:=False;
        ActiveFilter.Enabled := False;
        Filter.Enabled := False;
        Label5.Enabled := Filter.Enabled;
      end
    else
      if not Label2.Enabled then
        begin
          Label2.Enabled := True;
          Label3.Enabled := True;
          ComboBox1.Enabled := True;
          ComboBox2.Enabled := True;
          Button1.Enabled := True;
          Label4.Enabled := True;
          Edit3.Enabled := True;
          UpDown1.Enabled := True;
          ActiveFilter.Enabled := True;
          Filter.Enabled := ActiveFilter.Checked;
          Label5.Enabled := Filter.Enabled;
          ComboBox2Change(nil);
        end
end;

procedure TBandEditorForm.BitBtn1Click(Sender: TObject);
begin
  if View.FormatStr = '' then
    Application.MessageBox(PChar(FRConst_NofrDataset),
      PChar(FRConst_Information),
      MB_OK or MB_ICONINFORMATION)
  else
    Application.MessageBox(PChar(FRConst_frDatasetName + ' ' + View.FormatStr),
      PChar(FRConst_Information),
      MB_OK or MB_ICONINFORMATION)
end;

procedure TBandEditorForm.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex <> 2 then
    begin
      Label4.Enabled := False;
      Edit3.Enabled := False;
      UpDown1.Enabled := False;
    end
  else
    begin
      Label4.Enabled := True;
      Edit3.Enabled := True;
      UpDown1.Enabled := True;
    end
end;

procedure TBandEditorForm.ActiveFilterClick(Sender: TObject);
begin
  Filter.Enabled := ActiveFilter.Checked;
  Label5.Enabled := Filter.Enabled;
end;

procedure TBandEditorForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_BndEdCaption;
  Label1.Caption := FRConst_BndEdLabelCaption1;
  Label2.Caption := FRConst_BndEdLabelCaption2;
  Label3.Caption := FRConst_BndEdLabelCaption3;
  Label4.Caption := FRConst_BndEdLabelCaption4;
  ComboBox1.Items.Text := FRConst_BndEdComboBoxItems1;
  ComboBox2.Items.Text := FRConst_BndEdComboBoxItems2;
  BitBtn1.Hint := FRConst_BndEdBitBtnHint;
  GroupFilter.Caption := FRConst_BndEdGrpFilterCaption;
  Label5.Caption := FRConst_BndEdLabelCaption5;
  ActiveFilter.Caption := FRConst_BndEdActiveFiltCaption;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
end;

end.

