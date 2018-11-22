{*****************************************}
{                                         }
{             FastReport v2.2             }
{        'Values' property editor         }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Ev_ed;

interface

{$I FR_Vers.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ImgList, ComCtrls, DB, TypInfo, Buttons, FR_Class, ExtCtrls,
  FR_Const, FR_Utils;

type
  TEvForm = class(TForm)
    ValCombo: TComboBox;
    ValList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TBitBtn;
    Panel1: TPanel;
    Edit1: TEdit;
    Label3: TLabel;
    Button2: TBitBtn;
    Panel2: TPanel;
    VarTree: TTreeView;
    ImageList: TImageList;
    BEditor: TSpeedButton;
    Panel3: TPanel;
    NewCategory: TSpeedButton;
    NewVariable: TSpeedButton;
    DeleteItem: TSpeedButton;
    ModifyItem: TSpeedButton;
    procedure ValComboClick(Sender: TObject);
    procedure VarList2Click(Sender: TObject);
    procedure ValListClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BEditorClick(Sender: TObject);
    procedure NewCategoryClick(Sender: TObject);
    procedure NewVariableClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VarTreeChange(Sender: TObject; Node: TTreeNode);
    procedure DeleteItemClick(Sender: TObject);
    procedure ModifyItemClick(Sender: TObject);
    procedure VarTreeEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure VarTreeEdited(Sender: TObject; Node: TTreeNode;
      var S: string);
    procedure VarTreeChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure VarTreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    function NewCat: string;
    function NewVar: string;
    function CurVar: string;
    function CurVal: string;
    function CurDataSet: string;
    procedure GetFields(Value: string);
    procedure GetSpecValues;
    procedure FillValCombo;
    procedure ShowVarValue(Value: string);
    procedure SetValTo(Value: string);
    procedure CheckForExpr;
    procedure PostVal;
    procedure CheckButtons;
  public
    { Public declarations }
    Doc: TfrReport;
    Str: TMemoryStream;
    Sl: TStringList;
    procedure Init;
    procedure RefreshVarList(Memo: TStrings);
    procedure CancelChanges;
  end;

var
  EvForm: TEvForm;

function ShowEvEditor(Component: TfrReport): Boolean;

implementation

{$R *.DFM}

uses edExpr;

var
  SMemo: TStringList;
  VarClipbd: TMemoryStream;
  OldValue: string;

function ShowEvEditor(Component: TfrReport): Boolean;
begin
  Result := False;
  with TEvForm.Create(nil) do
  try
    Doc := Component;
    Str := TMemoryStream.Create;
    Sl := TStringList.Create;
    Doc.Values.WriteBinaryData(Str);
    Sl.Assign(Doc.Variables);
    Init;
    if ShowModal = mrOk then
      Result := True
    else
      CancelChanges;
  finally
    Str.Free;
    Sl.Free;
    Free;
  end
end;

procedure TEvForm.Init;
begin
  FillValCombo;
  CheckForExpr;
end;

procedure TEvForm.RefreshVarList(Memo: TStrings);
var
  i, j, n: Integer;
  l: TStringList;
begin
  for I := 0 to Memo.Count - 1 do
    if Copy(Memo[I], 1, 1) = ' ' then Memo[I] := ' ' + Trim(Memo[I]);
  l := TStringList.Create;
  //  Doc.Variables.Assign(Memo);
  with Doc.Values do
    for i := Items.Count - 1 downto 0 do
      if Doc.FindVariable(Items[i]) = -1 then
        begin
          Objects[i].Free;
          Items.Delete(i);
        end;
  Doc.GetCategoryList(l);
  n := l.Count;
  for i := 0 to n - 1 do
    begin
      Doc.GetVarList(i, l);
      for j := 0 to l.Count - 1 do
        with Doc.Values do
          if FindVariable(l[j]) = nil then
            Items[AddValue] := l[j];
    end;
  l.Free;
end;

procedure TEvForm.CancelChanges;
begin
  Str.Position := 0;
  Doc.Values.ReadBinaryData(Str);
  Doc.Variables.Assign(Sl);
end;

function TEvForm.CurVar: string;
begin
  Result := '';
  if (VarTree.Selected <> nil) and
    (VarTree.Parent <> nil) then Result := VarTree.Selected.Text;
end;

function TEvForm.CurVal: string;
begin
  Result := '';
  if ValList.ItemIndex <> -1 then
    Result := ValList.Items[ValList.ItemIndex];
end;

function TEvForm.CurDataSet: string;
begin
  Result := '';
  if ValCombo.ItemIndex <> -1 then
    Result := ValCombo.Items[ValCombo.ItemIndex];
end;

procedure TEvForm.FillValCombo;
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
        if c is TDataSet then
          if f = Doc.Owner then
            s.Add(c.Name)
          else
            s.Add(f.Name + '.' + c.Name);
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
  s.Add(FRConst_SpecVal);
  ValCombo.Items.Assign(s);
  s.Free;
end;

procedure TEvForm.ValComboClick(Sender: TObject);
begin
  if CurDataSet <> FRConst_SpecVal then
    GetFields(CurDataSet)
  else
    GetSpecValues;
end;

procedure TEvForm.VarList2Click(Sender: TObject);
begin
  ShowVarValue(CurVar);
end;

procedure TEvForm.GetFields(Value: string);
var
  DataSet: TDataSet;
  i: Integer;
  SaveAct: Boolean;
begin
  ValList.Items.Clear;
  ValList.Items.Add(FRConst_NotAssigned);
  CurReport := Doc;
  DataSet := frGetDataSet(Value);
  if DataSet <> nil then
    with DataSet do
      begin
        SaveAct := Active;
        try
          Active := True;
          if FieldCount > 0 then
            for i := 0 to FieldCount - 1 do
              ValList.Items.Add(Fields[i].FieldName)
          else
            for i := 0 to FieldDefs.Count - 1 do
              ValList.Items.Add(FieldDefs.Items[i].Name);
        except
          on Exception do ;
        end;
        Active := SaveAct;
      end;
end;

procedure TEvForm.GetSpecValues;
var
  i: Integer;
begin
  with ValList.Items do
    begin
      Clear;
      Add(FRCOnst_NotAssigned);
      for i := 0 to frSpecCount - 1 do
        Add(frSpecArr[i]);
    end;
end;

procedure TEvForm.ShowVarValue(Value: string);
Var
   XVar : TfrValue;
begin
   XVar:=Doc.Values.FindVariable(Value);
   If Not Assigned(XVar) Then
   Begin
      VarTree.Selected.Delete;
      Exit;
   End;
   with XVar do
   case Typ of
      vtNotAssigned:    SetValTo(CurDataSet + '.' + FRConst_NotAssigned);
      vtDBField:        SetValTo(DataSet + '.' + Field);
      vtOther:          begin
          SetValTo(FRConst_SpecVal + '.' + frSpecArr[OtherKind]);
          if OtherKind = 1 then
             Edit1.Text := Field;
      end;
   end;
end;

procedure TEvForm.SetValTo(Value: string);
var
  s1, s2, s3: string;
  i, j: Integer;
begin
  s1 := Copy(Value, 1, Pos('.', Value) - 1);
  s2 := Copy(Value, Pos('.', Value) + 1, 255);
  if Pos('.', s2) <> 0 then
    begin
      s3 := Copy(s2, Pos('.', s2) + 1, 255);
      s2 := Copy(s2, 1, Pos('.', s2) - 1);
      s1 := s1 + '.' + s2;
      s2 := s3;
    end;
  with ValCombo do
    for i := 0 to Items.Count - 1 do
      if Items[i] = s1 then
        begin
          if ItemIndex <> i then
            begin
              ItemIndex := i;
              ValComboClick(nil);
            end;
          with ValList do
            for j := 0 to Items.Count - 1 do
              if Items[j] = s2 then
                begin
                  ItemIndex := j;
                  break;
                end;
          break;
        end;
  CheckForExpr;
end;

procedure TEvForm.ValListClick(Sender: TObject);
begin
  if (VarTree.Selected <> nil) and
    (VarTree.Selected.Parent <> nil) then
    begin
      CheckForExpr;
      PostVal;
    end;
end;

procedure TEvForm.CheckForExpr;
begin
  Edit1.Enabled := (CurDataSet = FRConst_SpecVal) and
    (CurVal = frSpecArr[1]);
  Label3.Enabled := Edit1.Enabled;
  if not Edit1.Enabled then
    begin
      Edit1.Text := '';
      Edit1.Color := clBtnFace;
    end
  else
    Edit1.Color := clWindow;

  BEditor.Enabled := Edit1.Enabled;
end;

procedure TEvForm.PostVal;
var
  Val: TfrValue;
  i: Integer;
  s: string;
begin
  Val := Doc.Values.FindVariable(CurVar);
  if Val <> nil then
    with Val do
      begin
        if CurVal = FRConst_NotAssigned then
          Typ := vtNotAssigned
        else
          if CurDataSet = FRConst_SpecVal then
            begin
              Typ := vtOther;
              s := CurVal;
              for i := 0 to frSpecCount - 1 do
                if s = frSpecArr[i] then
                  begin
                    OtherKind := i;
                    if i = 1 then // SExpr
                      Field := Edit1.Text;
                    break;
                  end;
            end
          else
            begin
              Typ := vtDBField;
              DataSet := CurDataSet;
              Field := CurVal;
              OtherKind := 0;
            end;
      end;
end;

procedure TEvForm.CheckButtons;
begin
  if VarTree.Selected = nil then
    begin
      NewVariable.Enabled := False;
      DeleteItem.Enabled := False;
      ModifyItem.Enabled := False;
    end
  else
    begin
      NewVariable.Enabled := True;
      DeleteItem.Enabled := True;
      ModifyItem.Enabled := True;
    end;
end;

procedure TEvForm.Button1Click(Sender: TObject);
begin
  PostVal;
end;

procedure TEvForm.BEditorClick(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := Edit1.Text;
    if edEx.ShowModal = MrOk then
      edit1.Text := edEx.moExpres.Text;
  finally
    edEx.Free;
  end;
end;

function TEvForm.NewCat: string;
var
  I: Integer;
begin
  Result := FRConst_CatName;
  I := 0;
  repeat
    Inc(I);
  until Doc.Variables.IndexOf(Result + IntToStr(I)) = -1;
  Result := Result + IntToStr(I);
end;

function TEvForm.NewVar: string;
var
  I: Integer;
begin
  Result := FRConst_VarName;
  I := 0;
  repeat
    Inc(I);
  until Doc.Variables.IndexOf(' ' + Result + IntToStr(I)) = -1;
  Result := Result + IntToStr(I);
end;

procedure TEvForm.NewCategoryClick(Sender: TObject);
var
  T: TTreeNode;
begin
  T := VarTree.Items.Add(nil, NewCat);
  Doc.Variables.Add(NewCat);

  { 08/03/2001 - Si posiziona sul nuovo gruppo inserito }
  if VarTree.Items.Count >= 1 then VarTree.Selected := T;
  { 08/03/2001 - Fine }
end;

procedure TEvForm.NewVariableClick(Sender: TObject);
var
  T, V: TTreeNode;
  I: Integer;
  OldActiveCtrl: TWinControl;
begin
  // This 3 lines are used for kill focus to VarTree control,
  // so if it's in edit, save the text value.
  OldActiveCtrl := ActiveControl;
  ValList.SetFocus;
  OldActiveCtrl.SetFocus;

  if VarTree.Selected = nil then Exit;
  if VarTree.Selected.Parent = nil then
    T := VarTree.Selected
  else
    T := VarTree.Selected.Parent;
  V := VarTree.Items.AddChild(T, NewVar);
  V.ImageIndex := 1;
  V.SelectedIndex := 1;
  I := Doc.Variables.IndexOf(T.Text);
  if I = Doc.Variables.Count - 1 then
    Doc.Variables.Add(' ' + NewVar)
  else
    begin
      if (Copy(Doc.Variables[I + 1], 1, 1) = ' ') then
        begin
          while (I < Doc.Variables.Count - 1) and
            (Copy(Doc.Variables[I + 1], 1, 1) = ' ') do Inc(I);
          if I < Doc.Variables.Count - 1 then
            Doc.Variables.Insert(I + 1, ' ' + NewVar)
          else
            Doc.Variables.Add(' ' + NewVar);
        end
      else
        Doc.Variables.Insert(I + 1,' ' + NewVar);
    end;
  RefreshVarList(Doc.Variables);

  { 08/03/2001 - Si posiziona automaticamente sul nuovo elemento inserito }
  VarTree.Selected := V;
  { 08/03/2001 - Fine }
end;

procedure TEvForm.FormShow(Sender: TObject);
var
  C, V: TStringList;
  I, J: Integer;
  T, P: TTreeNode;
begin
  VarTree.Items.Clear;
  C := TStringList.Create;
  V := TStringList.Create;
  Doc.GetCategoryList(C);
  for I := 0 to C.Count - 1 do
  begin
     T := VarTree.Items.Add(nil, C[I]);
     V.Clear;
     Doc.GetVarList(I, V);
     for J := 0 to V.Count - 1 do
     begin
        P := VarTree.Items.AddChild(T, V[J]);
        P.ImageIndex := 1;
        P.SelectedIndex := 1;
     end;
  end;
  C.Free;
  V.Free;
  VarTree.FullExpand;
  ValCombo.ItemIndex := ValCombo.Items.Count - 1;
  ValCombo.OnClick(nil);
  BEditor.Flat := False;
end;

procedure TEvForm.VarTreeChange(Sender: TObject; Node: TTreeNode);
begin
  CheckButtons;
  if (VarTree.Selected <> nil) and (VarTree.Selected.Parent <> nil) then
    ShowVarValue(VarTree.Selected.Text);
end;

procedure TEvForm.DeleteItemClick(Sender: TObject);
var
  I: Integer;
begin
  if VarTree.Selected <> nil then
    if Application.MessageBox(PChar(FRConst_ItemDelete),
      PChar(FRConst_Attenction),
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_Yes then
      begin
        if VarTree.Selected.Parent <> nil then
          begin
            I := Doc.Variables.IndexOf(' ' + VarTree.Selected.Text);
            Doc.Variables.Delete(I);
          end
        else
          begin
            I := Doc.Variables.IndexOf(VarTree.Selected.Text);
            Doc.Variables.Delete(I);
            while (I <= Doc.Variables.Count - 1) and
              (Copy(Doc.Variables[I], 1, 1) = ' ') do
              Doc.Variables.Delete(I);
          end;
        VarTree.Selected.Delete;
        CheckButtons;
      end;
end;

procedure TEvForm.ModifyItemClick(Sender: TObject);
begin
  if VarTree.Selected <> nil then VarTree.Selected.EditText;
end;

procedure TEvForm.VarTreeEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if VarTree.Selected.Parent = nil then
    OldValue := VarTree.Selected.Text
  else
    OldValue := ' ' + VarTree.Selected.Text;
end;

procedure TEvForm.VarTreeEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  I: Integer;
begin
  I := Doc.Variables.IndexOf(OldValue);
  if OldValue[1] = ' ' then
    Doc.Variables[I] := ' ' + S
  else
    Doc.Variables[I] := S;
  RefreshVarList(Doc.Variables);
  Node.Text := S;
  PostVal;
end;

procedure TEvForm.VarTreeChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if Edit1.Enabled then PostVal;
end;

procedure TEvForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_EvFrmCaption;
  Label1.Caption := FRConst_EvFrmLabelCaption1;
  Label2.Caption := FRConst_EvFrmLabelCaption2;
  Label3.Caption := FRConst_EvFrmLabelCaption3;
  NewCategory.Hint := FRConst_EvFrmNewCategoryHint;
  NewVariable.Hint := FRConst_EvFrmNewVariableHint;
  DeleteItem.Hint := FRConst_EvFrmDeleteItemHint;
  ModifyItem.Hint := FRConst_EvFrmModifyItemHint;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
  NewCategory.Flat := True;
  NewVariable.Flat := True;
  DeleteItem.Flat := True;
  ModifyItem.Flat := True;
end;

procedure TEvForm.VarTreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  { 08/03/2001 - Zanella
    Abilitata la modifica degli elementi anche premendo F2 }
  case Key of
    VK_F2: // F2 --> Modifica elemento corrente
      begin
        if (Assigned(VarTree.Selected)) and
          (not VarTree.IsEditing) then
          begin
            VarTree.Selected.EditText;
          end;
      end;
    VK_ESCAPE: // ESC --> Annullamento modifica elemento corrente
      begin
        { Se l'utente preme ESC mentre sta modificando un elemento... }
        if (Assigned(VarTree.Selected)) and
          (VarTree.IsEditing) then
          begin
            { ...Annulla le modifiche }
            VarTree.Selected.EndEdit(True);
          end;
      end;
    VK_INSERT: // INS/CTRL+INS --> Inserimento nuovo elemento/gruppo
      begin
        { Se non si è in modifica... }
        if (not VarTree.IsEditing) then
          begin
            { Se l'utente ha premuto CTRL+INS... }
            if (ssCTRL in Shift) then
              begin
                { ...Aggiunge un nuovo gruppo }
                NewCategoryClick(nil);
              end
            else
              begin
                { ...Altrimenti aggiunge una nuova variabile }
                NewVariableClick(nil);
              end;
          end;
      end;
    VK_DELETE: // CANC --> Cancellazione elemento
      begin
        { Se l'utente preme CANC... }
        if (Assigned(VarTree.Selected)) and
          (not VarTree.IsEditing) then
          begin
            { ...Chiede conferma per cancellare l'elemento }
            DeleteItemClick(nil);
          end;
      end;
  end;
  { 08/03/2001 - Fine }
end;

initialization
  SMemo := TStringList.Create;
  VarClipbd := TMemoryStream.Create;

finalization
  SMemo.Free;
  VarClipbd.Free;

end.
