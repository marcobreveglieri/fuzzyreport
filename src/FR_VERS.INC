
{*****************************************}
{                                         }
{             FastReport v2.2             }
{              Include file               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}


{$B-} {- Complete Boolean Evaluation }
{$R-} {- Range-Checking }
{$V-} {- Var-String Checking }
{$T-} {- Typed @ operator }
{$X+} {- Extended syntax }
{$P+} {- Open string params }
{$J+} {- Writeable structured consts }
{$H+} {- Use long strings by default }

{$IFDEF VER200}           // Delphi 2009
  {$DEFINE Delphi2009}
{$ENDIF}

{$IFDEF VER210}           // Delphi 2010
  {$DEFINE Delphi2010}
  {$DEFINE Delphi2009}
{$ENDIF}

{$IFDEF VER260}           // Delphi XE6
  {$DEFINE Delphi2010}
  {$DEFINE Delphi2009}
{$ENDIF}

