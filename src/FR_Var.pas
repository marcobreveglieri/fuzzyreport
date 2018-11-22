
{*****************************************}
{                                         }
{             FastReport v2.2             }
{             Variables form              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_Var;

interface

{$I FR_Vers.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FR_Const, Buttons;

type

  TVarForm = class(TForm)
    Variables: TListBox;
    Categories: TComboBox;
    Label1: TLabel;
    Button2: TBitBtn;
    procedure VariablesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CategoriesClick(Sender: TObject);
    procedure VariablesClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VarForm: TVarForm;

implementation

{$R *.DFM}

uses FR_Class;

procedure TVarForm.VariablesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Escape then ModalResult := mrCancel;
  if Key = vk_Return then ModalResult := mrOk;
end;

procedure TVarForm.CategoriesClick(Sender: TObject);
begin
  CurReport.GetVarList(Categories.ItemIndex, Variables.Items);
end;

procedure TVarForm.VariablesClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TVarForm.FormActivate(Sender: TObject);
begin
  CurReport.GetCategoryList(Categories.Items);
  Categories.ItemIndex := 0;
  CategoriesClick(nil);
end;

procedure TVarForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TVarForm.FormCreate(Sender: TObject);
begin
  Caption := FRConst_VarFormCaption;
  Label1.Caption := FRConst_VarFormLabelCaption1;
  Button2.Caption := FRConst_Cancel;
end;

end.

