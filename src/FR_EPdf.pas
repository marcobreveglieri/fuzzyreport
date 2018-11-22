{$G+}
unit FR_EPdf;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, FR_Class{, SynPdf, SQLite3Pages};

Type

   TFrEPDFExportObject = class(TComponent)
   end;

   TfrEPDFExportFilter = class(TfrExportFilter)
   Private
{
     GDIPages     : TGDIPages;
     PrimaPagina  : Boolean;
     PDF          : TPDFDocument;
     PDFPage      : TPdfPage;
}
   Public
     Constructor Create(AFileName,ATitle,AAuthor:String); Override;
     Destructor Destroy;  Override;
     //
     Procedure OnBeginDoc; Override;
     Procedure OnEndDoc; Override;
     Procedure OnBeginPage(Width, Height: Integer); Override;
     Procedure OnEndPage; Override;
     Procedure OnPaintPage(MF:TMetaFile; IPage:Integer); Override;
   End;

IMPLEMENTATION

{$R frEPdf.dcr}

Const
    PDFEscx = 0.75;
    PDFEscy = 0.75;

////////////////////////////////////////////////////////////////////////////////////
Constructor TfrEPDFExportFilter.Create(AFileName,ATitle,AAuthor:String);
begin
   Inherited Create(AFileName,ATitle,AAuthor);
   If Trim(AFileName)<>'' Then
      FileName:=AFileName
   Else
      FileName:='FR_PDF.Pdf';
   //
{
   GDIPages:=Nil;
   PDF:=Nil;
}

End;

Destructor TfrEPDFExportFilter.Destroy;
begin
{
   If Assigned(PDF) Then PDF.Free;
   If Assigned(GDIPages) Then GDIPages.Free;
 }
   Inherited;
End;

procedure TfrEPDFExportFilter.OnBeginDoc;
begin
   inherited;
 {
   GDIPages:=TGDIPages.Create(Application.MainForm);
   GDIPages.Caption:=Title;
   GDIPages.UseOutlines:=True;
   GDIPages.ExportPDFApplication:='FuzzyRep';
   GDIPages.BeginDoc;
   PrimaPagina:=True;
 }

 {
   PDF:=TPdfDocument.Create;
   PDF.Info.Creator:='FuzzyRep';
   PDF.Info.CreationDate:=Now;
   PDF.Info.Author:=Author;
   PDF.Info.Title:=Title;
   PDF.UseOutlines:=True;
   PDF.NewDoc;
 }
End;

procedure TfrEPDFExportFilter.OnBeginPage(Width, Height: Integer);
begin
   inherited;
{
   GDIPages.Width:=Width;
   GDIPages.Height:=Height;
   If Not PrimaPagina Then
      GDIPages.NewPage;
   PrimaPagina:=False;
}

{
   PDFPage:=PDF.AddPage;
   PDFPage.PageWidth:=Trunc(Width*PDFEscx);
   PDFPage.PageHeight:=Trunc(Height*PDFEscy);
   //PDFPage.PageLandscape:=False;
}
End;

procedure TfrEPDFExportFilter.OnEndDoc;
begin
   Inherited;
{
   GDIPages.EndDoc;
   GDIPages.ExportPDF(FileName,False,False);
   If Assigned(GDIPages) Then GDIPages.Free;
   GDIPages:=Nil;
}
{
   PDF.SaveToFile(FileName);
   If Assigned(PDF) Then PDF.Free;
   PDF:=Nil;
}
End;

procedure TfrEPDFExportFilter.OnEndPage;
begin
   Inherited;
   //
end;

procedure TfrEPDFExportFilter.OnPaintPage(MF:TMetaFile; IPage:Integer);
{
Var
//   R   : TRect;
}
begin
{
   R.Left:=0;
   R.Top:=0;
   R.Right:=GDIPages.PaperSize.cx;
   R.Bottom:=GDIPages.PaperSize.cy;
   //
   GDIPages.DrawMeta(R,MF);
}

{
   PDF.Canvas.RenderMetaFile(MF);
}
End;

INITIALIZATION
{
  frRegisterExportFilter(TfrEPDFExportFilter,
     'Adobe Acrobat PDF'+'(*.pdf)','*.pdf');
}

END.


