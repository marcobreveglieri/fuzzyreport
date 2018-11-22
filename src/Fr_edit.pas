
{*****************************************}
{                                         }
{             FastReport v2.2             }
{               Memo editor               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Edit;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Buttons, ClipBrd, FR_Class, FR_Insp, ExtCtrls;

type
  TEditorForm = class(TPropEditor)
    M1: TMemo;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Button3: TBitBtn;
    Button4: TBitBtn;
    Button5: TBitBtn;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure M1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowEditor: TModalResult; override;
  end;

var
  EditorForm: TEditorForm;

implementation

{$R *.DFM}

uses FR_Var, FR_Flds, EdExpr, FR_Const, FR_Hilit, FR_Fmted;

var
  T: TfrMemoView;

function TEditorForm.ShowEditor: TModalResult;
begin
  Result := mrCancel;
  if View <> nil then
    Result := inherited ShowEditor;
end;

procedure TEditorForm.FormActivate(Sender: TObject);
begin
  M1.Lines.Assign(View.Memo);
  M1.SetFocus;
  if View is TfrMemoView then T.Assign(View);
  BitBtn1.Enabled := View is TfrMemoView;
  BitBtn2.Enabled := View is TfrMemoView;
end;

procedure TEditorForm.FormDeactivate(Sender: TObject);
begin
  if ModalResult = mrOk then
    if View is TfrMemoView then
      begin
        T.Memo.Assign(M1.Lines);
        View.Assign(T);
      end
    else
      View.Memo.Assign(M1.Lines);
end;

procedure TEditorForm.Button3Click(Sender: TObject);
begin
  VarForm := TVarForm.Create(nil);
  with VarForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        if Variables.ItemIndex >= 0 then
          ClipBoard.AsText := '[' + Variables.Items[Variables.ItemIndex] + ']';
        M1.PasteFromClipboard;
      end;
  VarForm.Free;
  M1.SetFocus;
end;

procedure TEditorForm.M1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and (Shift = []) then Button3Click(Self);
  if Key = vk_Escape then ModalResult := mrCancel;
end;

procedure TEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Return) and (ssCtrl in Shift) then
    begin
      ModalResult := mrOk;
      Key := 0;
    end;
end;

procedure TEditorForm.Button4Click(Sender: TObject);
begin
  FieldsForm := TFieldsForm.Create(nil);
  with FieldsForm do
    if ShowModal = mrOk then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := '[' + DBField + ']';
        M1.PasteFromClipboard;
      end;
  FieldsForm.Free;
  M1.SetFocus;
end;

procedure TEditorForm.Button5Click(Sender: TObject);
var
  edEx: TExprEditor;
begin
  edEx := nil;
  try
    edEx := TExprEditor.Create(Self);
    edEx.moExpres.Text := '';
    if edEx.ShowModal = MrOk then
      begin
        ClipBoard.Clear;
        ClipBoard.AsText := '[' + edEx.moExpres.Text + ']';
        M1.PasteFromClipboard;
      end;
  finally
    edEx.Free;
  end;
end;

procedure TEditorForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_EditorFormCaption;
  Button1.Caption := FRConst_OK;
  Button2.Caption := FRConst_Cancel;
  Button3.Caption := FRConst_Var;
  Button4.Caption := FRConst_DB;
  Button5.Caption := FRConst_Exp;
  BitBtn1.Caption := FRConst_EditorFormBitBtn1;
  BitBtn2.Caption := FRConst_EditorFormBitBtn2;

  T := TfrMemoView.Create(nil);
end;

procedure TEditorForm.BitBtn2Click(Sender: TObject);
begin
  HilightForm := THilightForm.Create(nil);
  with HilightForm do
    begin
      FontColor := T.Highlight.FontColor;
      FillColor := T.Highlight.FillColor;
      CBX1.Checked := T.UseHighlight;
      Edit2.Text := T.HighlightStr;
      CB1.Checked := (fsBold in T.Highlight.FontStyle);
      CB2.Checked := (fsItalic in T.Highlight.FontStyle);
      CB3.Checked := (fsUnderline in T.Highlight.FontStyle);
      if ShowModal = mrOk then
        begin
          T.UseHighlight := CBX1.Checked;
          T.HighlightStr := Edit2.Text;
          T.Highlight.FontColor := FontColor;
          T.Highlight.FillColor := FillColor;
          T.Highlight.FontStyle := [];
          if CB1.Checked then T.Highlight.FontStyle := T.Highlight.FontStyle + [fsBold];
          if CB2.Checked then T.Highlight.FontStyle := T.Highlight.FontStyle + [fsItalic];
          if CB3.Checked then T.Highlight.FontStyle := T.Highlight.FontStyle + [fsUnderline];
        end;
    end;
  HilightForm.Free;
end;

procedure TEditorForm.BitBtn1Click(Sender: TObject);
begin
  FmtForm := TFmtForm.Create(nil);
  with FmtForm do
    begin
      Format := T.Format;
      Edit1.Text := T.FormatStr;
      if ShowModal = mrOk then
        begin
          T.Format := Format;
          T.FormatStr := Edit1.Text;
        end;
    end;
  FmtForm.Free;
end;

procedure TEditorForm.FormDestroy(Sender: TObject);
begin
  T.Free;
end;

end.

