unit FR_Pages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, FR_Const;

type
  TPagesList = class(TForm)
    Pages: TListBox;
    Label1: TLabel;
    Cancel: TBitBtn;
    OK: TBitBtn;
    procedure PagesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PagesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PagesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PagesList: TPagesList;

implementation

{$R *.DFM}

var
  DragStartY, DragIndex: Integer;

procedure TPagesList.PagesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
begin
  Index := TListBox(Sender).ItemIndex;
  if Index <> -1 then
    begin
      DragStartY := Y;
      DragIndex := Index;
      TControl(Sender).BeginDrag(True);
    end;
end;

procedure TPagesList.PagesDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  List: TListBox;
  Index, StartY: Integer;
begin
  if Source is TListBox then
    begin
      List := TListBox(Source);
      if Y > DragStartY then
        StartY := (DragStartY div List.ItemHeight) *
          List.ItemHeight
      else
        StartY := (DragStartY div List.ItemHeight) *
          List.ItemHeight + List.ItemHeight;
      Index := DragIndex + ((Y - StartY) div List.ItemHeight);
      Accept := (List = Pages) and (Index < List.Items.Count);
      if Accept then List.ItemIndex := Index;
    end;
end;

procedure TPagesList.PagesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  List: TListBox;
  Item: string;
  Index, StartY: Integer;
begin
  List := TListBox(Sender);
  with List do
    begin
      if Y > DragStartY then
        StartY := (DragStartY div List.ItemHeight) *
          List.ItemHeight
      else
        StartY := (DragStartY div List.ItemHeight) *
          List.ItemHeight + List.ItemHeight;
      Index := DragIndex + ((Y - StartY) div ItemHeight);
      Item := List.Items[DragIndex];
      List.Items.Delete(DragIndex);
      List.Items.Insert(Index, Item);
    end;
end;

procedure TPagesList.FormCreate(Sender: TObject);
begin
  Caption := FRConst_PagesListCaption;
  Label1.Caption := FRConst_PagesListLabelCaption;
  OK.Caption := FRConst_OK;
  Cancel.Caption := FRConst_Cancel;
end;

end.

