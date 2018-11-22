{*******************************************}
{                                           }
{            FastReport v2.2                }
{          Objet complémentaire             }
{       Dessin géométrique standard         }
{                                           }
{ FastReport :(c) 1998-99 by Tzyganenko A.  }
{ RoundRect  : Guilbaud Olivier             }
{                golivier@worldnet.fr       }
{ Merci de transmettre vos commantaires     }
{                                           }
{Ce composant est un FREEWARE               }
{*******************************************}
{Histo :                                    }
{ 01/06/1999 : Création                     }
{Aggiornato alla versione Plus Italiana e   }
{corretto da Dell'Aria Fabio il 23/08/1999  }
{*******************************************}

unit Fr_Shape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, FR_Class, FR_Const, Buttons;

type
  TFrShape = (shCircle, shRectangle, shRoundRect, shFirstLine, shSecondLine);

  TfrShapeObject = class(TComponent) // fake component
  end;

  TfrShapeView = class(TfrView)
  public
    TypeShape: TFrShape;
    Trans: Boolean;
    constructor Create(Rep: TfrReport); override;
    procedure Assign(From: TfrView); override;
    procedure Draw(Canvas: TCanvas); override;
    procedure ShowBackGround; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

  // Propertie's editor
  TFrShapeEditor = class(TfrObjEditorForm)
    RBShape: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbTrans: TCheckBox;
    procedure FormCreate(Sender: TObject);
  public
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

{$R frshape.dcr}

{$R *.DFM}

{$R Shape.res}

//---------------------- DEFINE SHAPE -----------------//
constructor TfrShapeView.Create(Rep: TfrReport);
begin
  inherited;

  Flags := 1;
  TypeShape := shCircle;
  Trans := True;
  Color := clWhite;
end;

procedure TfrShapeView.Assign(From: TfrView);
begin
  inherited Assign(From);

  TypeShape := (From as TFrShapeView).TypeShape;
  Trans := (From as TFrShapeView).Trans;
end;

procedure TFrShapeView.ShowBackGround;
begin
  if (DisableDrawing) or ((Trans) and (DocMode <> dmDesigning)) then Exit;

  with Canvas do
    begin
      Brush.Style := bsSolid;
      Pen.Color := clWhite;
      Brush.Color := clWhite;
      Rectangle(Left, Top, Left + Width + 1, Top + Height + 1);
    end;
end;

procedure TFrShapeView.Draw(Canvas: TCanvas);
var
  min: Integer;
begin
  if (DocMode = dmPrinting) and (not Visible) then Exit;
  if DisableDrawing then Exit;
  BeginDraw(Canvas); // Initialise le canvas utilisé
  CalcGaps; // Calcule les coordonnées utiles
  with Canvas do
    begin
      ShowBackground;
      ShowFrame;

      Pen.Style := psSolid;
      Pen.Width := FrameWidth;
      Pen.Color := FrameColor;

      Brush.Color := Color;
      if Color = clNone then
        Brush.Style := bsClear
      else
        Brush.Style := bsSolid;

      case TypeShape of
        shCircle: Ellipse(Left, Top, Left + Width, Top + Height);
        shRectangle: Rectangle(Left, Top, Left + Width, Top + Height);
        shRoundRect:
          begin
            if Width < Height then
              Min := Width div 4
            else
              Min := Height div 4;
            RoundRect(Left, Top, Left + Width, Top + Height, Min, Min);
          end;
        shFirstLine:
          begin
            MoveTo(Left, Top);
            LineTo(Left + Width, Top + Height);
          end;
        shSecondLine:
          begin
            MoveTo(Left, Top + Height);
            LineTo(Left + Width, Top);
          end;
      end;
    end;
  if not Visible then
    begin
      Canvas.Pen.Color := ClRed;
      Canvas.Pen.Width := 2;
      Canvas.MoveTo(Left, Top);
      Canvas.LineTo(Left + Width, Top + Height);
      Canvas.MoveTo(Left + Width, Top);
      Canvas.LineTo(Left, Top + Height);
    end;
end;

procedure TFrShapeView.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  Stream.Read(TypeShape, SizeOf(TypeShape));
  Stream.Read(Trans, SizeOf(Trans));
end;

procedure TFrShapeView.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  Stream.Write(TypeShape, SizeOf(TypeShape));
  Stream.Write(Trans, SizeOf(Trans));
end;

//--------------------- EDITOR ------------------------//

procedure TFrShapeEditor.ShowEditor(t: TfrView);
begin
  RBShape.ItemIndex := Ord((t as TFrShapeView).TypeShape);
  CBTrans.Checked := (t as TFrShapeView).Trans;

  if ShowModal = mrOk then
    begin
      (t as TFrShapeView).TypeShape := TFrShape(RBShape.ItemIndex);
      (t as TFrShapeView).Trans := CBTrans.Checked;
    end;
end;

procedure TFrShapeEditor.FormCreate(Sender: TObject);
begin
  Caption := FRConst_ShapeEditCaption;
  RBShape.Caption := FRConst_ShapeEditRBShapeCapt;
  cbTrans.Caption := FRConst_ShapeEditcbTransCapt;
  RBShape.Items.Text := FRConst_ShapeEditRBShapeItems;
  BitBtn1.Caption := FRConst_OK;
  BitBtn2.Caption := FRConst_Cancel;
end;

var
  Bmp: TBitMap;

initialization
  Bmp := TBitmap.Create;
  Bmp.Handle := LoadBitmap(HInstance, 'SHAPEBITMAP');
  frRegisterObject(TfrShapeView, Bmp, FRConst_InsShape, TFrShapeEditor);

finalization
  Bmp.Free;

end.

