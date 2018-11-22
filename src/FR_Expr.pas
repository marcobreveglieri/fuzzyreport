{*******************************************
 *             FuzzyReport 2.0             *
 *                                         *
 *  Copyright (c) 2000 by Fabio Dell'Aria  *
 *                                         *
 *-----------------------------------------*
 * For to use this source code, you must   *
 * read and agree all license conditions.  *
 *******************************************}

unit FR_Expr;

interface

{$I FR_Vers.inc}

uses Classes, SysUtils, Variants, FR_Const;

type

  TErrorType = (StopOnException, ContinueOnExpection);

  TNewFunction = function(Id: string; PapameterList: TStringList): Variant of object;

  TfrExpr = class
  private
    FOnNewFunction: TNewFunction;
  protected
    ErrorType: TErrorType;
  public
    function InternalCalc(var P: PChar): Variant;
    property OnNewFunction: TNewFunction read FOnNewFunction write FOnNewFunction;
  end;

procedure SetErrorType(E: TErrorType);
procedure AssignNewFunction(P: TNewFunction);
function Calc(const s: string): Variant;

var
  LastError: string;
  Digits: set of AnsiChar = ['0'..'9', '.'];
  PrimaryIdentChars: set of AnsiChar = ['a'..'z', 'A'..'Z', '_', '"', '#'];
  IdentChars: set of AnsiChar = ['a'..'z', 'A'..'Z', '_', '"', '#', '0'..'9', '.'];

implementation

var
  Expr: TfrExpr;

procedure SetErrorType(E: TErrorType);
begin
  if Expr = nil then Expr := TfrExpr.Create;
  Expr.ErrorType := E;
end;

procedure AssignNewFunction(P: TNewFunction);
begin
  if Expr = nil then 
   Expr := TfrExpr.Create;
  Expr.OnNewFunction := P;
end;

function Calc(const s: string): Variant;
var
  P: PChar;
  Quote, Quote2: Boolean;
  Op, Cl, I: Integer;
begin
  Quote := False;
  Quote2 := False;
  Op := 0;
  Cl := 0;
  I := 1;
  while I <= Length(S) do
    begin
      if S[I] = '"' then
        Quote := not Quote
      else
        if S[I] = '''' then
          Quote2 := not Quote2
        else
          if not (Quote or Quote2) then
            if S[I] = '(' then
              Inc(Op)
            else
              if S[I] = ')' then Inc(Cl);
      Inc(I);
    end;
  if Op = Cl then
    begin
      P := PChar(S);
      if Expr = nil then Expr := TfrExpr.Create;
      Result := Expr.InternalCalc(P);
    end
  else
    raise Exception.CreateFmt(FRConst_ErrateParentersNum, [S, Op, Cl]);
end;

function TfrExpr.InternalCalc(var P: PChar): Variant;
var
  V: Variant;
  LastOperator, MinOperator: Integer;
  Ex: PChar;

  procedure KillSpaces;
  begin
    while (P^ <= #32) and (P^ <> #0) do
      Inc(P);
  end;

  function Identifier: Variant;
  var
    S: PChar;
    X, Y: string;
    Prm: TStringList;
    I, CloseP, OpenP: Integer;
    Quote, Quote2, Variable: Boolean;
  begin
    Result := Unassigned;
    KillSpaces;
    if P^ = '(' then
      begin
        Inc(P);
        Result := InternalCalc(P);
      end
    else
      if CharInSet(P^,Digits) then
        begin
          S := P;
          while CharInSet(P^,Digits) do
            Inc(P);
          KillSpaces;
          X := Copy(S, 1, (P - S));
          I := Pos('.', X);
          if I > 0 then X[I] := FormatSettings.DecimalSeparator;
          Result := StrToFloat(X);
        end
      else
        if P^ = '[' then
          begin
            X := '';
            Inc(P);
            S := P;
            while (P^ <> #0) and (P^ <> ']') do
              Inc(P);
            if P^ = ']' then
              begin
                Inc(P);
                if Assigned(FOnNewFunction) then
                  Result := FOnNewFunction(Copy(S, 1, (P - S) - 1), nil);
              end;
          end
        else
          if P^ = '''' then
            begin
              X := '';
              repeat
                Inc(P);
                while (P^ <> #0) and (P^ <> '''') do
                  begin
                    X := X + P^;
                    Inc(P);
                  end;
                if P^ = '''' then
                  begin
                    Inc(P);
                    if P^ = '''' then X := X + '''';
                  end;
              until (P^ = #0) or (P^ <> '''');
              Result := X;
            end
          else
            if UpCase(P^) = 'N' then
              begin
                if UpCase((P + 1)^) = 'O' then
                  if UpCase((P + 2)^) = 'T' then
                    if not CharInSet((P + 3)^,IdentChars) then
                      begin
                        Inc(P, 3);
                        Result := not Identifier;
                        if Result = True then
                          Result := 1
                        else
                          Result := 0;
                      end;
              end;
    if (VarIsEmpty(Result)) and (CharInSet(P^,PrimaryIdentChars)) then
      begin
        S := P;
        while (P^ <> #0) and (P^ <> '"') and (CharInSet(P^,IdentChars)) do
          Inc(P);
        if P^ = '"' then
          begin
            Inc(P);
            while (P^ <> #0) and (P^ <> '"') do
              Inc(P);
            if P^ = '"' then Inc(P);
          end;
        X := Copy(S, 1, (P - S));
        KillSpaces;
        if P^ = '(' then
          begin
            Prm := TStringList.Create;
            repeat
              S := P + 1;
              OpenP := 1;
              CloseP := 0;
              Quote := False;
              Quote2 := False;
              Variable := False;
              repeat
                Inc(P);
                if not Variable then
                  begin
                    if P^ = '[' then
                      Variable := True
                    else
                      begin
                        if P^ = '"' then
                          Quote := not Quote
                        else
                          if P^ = '''' then Quote2 := not Quote2;
                        if not (Quote or Quote2) then
                          if P^ = '(' then
                            Inc(OpenP)
                          else
                            if P^ = ')' then Inc(CloseP);
                      end
                  end
                else
                  if P^ = ']' then Variable := False;
              until (P^ = #0) or (not (Variable or Quote or Quote2) and
                (((P^ = ',') and (OpenP - CloseP = 1)) or (OpenP = CloseP)));
              Y := Copy(S, 1, (P - S));
              if Y <> '' then Prm.Add(Y);
            until (P^ = #0) or (P^ = ')');
            if P^ = ')' then Inc(P);
          end
        else
          Prm := nil;
        try
          if Assigned(FOnNewFunction) then Result := FOnNewFunction(X, Prm);
        finally
          if Prm <> nil then Prm.Free;
        end;
      end
    else
      if (VarIsEmpty(Result)) and ((P^ = '-') or (P^ = '+')) then Result := 0;
    if VarIsEmpty(Result) then raise Exception.Create(FRConst_UnknownIdentifier + ': ' + Ex);
  end;

  function Operator: Integer;
  const
    OperatorChars = ['A', 'M', 'D'];
  var
    X: string;
  begin
    KillSpaces;
    if P^ = '^' then
      Result := 1000
    else
      if P^ = '*' then
        Result := 1001
      else
        if P^ = '/' then
          Result := 1002
        else
          if P^ = '+' then
            Result := 100
          else
            if P^ = '-' then
              Result := 101
            else
              if P^ = '=' then
                Result := 10
              else
                if P^ = '>' then
                  begin
                    if (P + 1)^ = '=' then
                      begin
                        Inc(P);
                        Result := 11
                      end
                    else
                      Result := 12
                  end
                else
                  if P^ = '<' then
                    begin
                      if (P + 1)^ = '=' then
                        begin
                          Inc(P);
                          Result := 13
                        end
                      else
                        if (P + 1)^ = '>' then
                          begin
                            Inc(P);
                            Result := 14
                          end
                        else
                          Result := 15
                    end
                  else
                    if CharInSet(UpCase(P^),OperatorChars) then
                      begin
                        X := UpperCase(P^ + (P + 1)^ + (P + 2)^);
                        Inc(P, 3);
                        if X = 'AND' then
                          Result := 1003
                        else
                          if X = 'MOD' then
                            Result := 1004
                          else
                            if X = 'DIV' then
                              Result := 1005
                            else
                              Result := 0;
                      end
                    else
                      if UpCase(P^) = 'O' then
                        begin
                          X := UpperCase(P^ + (P + 1)^);
                          Inc(P, 2);
                          if X = 'OR' then
                            Result := 102
                          else
                            Result := 0;
                        end
                      else
                        Result := 0;
    if Result <> 0 then Inc(P);
  end;

  function Value(V: Variant): Variant;
  var
    A: Variant;
    OldOperator: Integer;

  begin
    if P^ <> #0 then
      begin
        A := Identifier;
        OldOperator := LastOperator;
        LastOperator := Operator;
        if (LastOperator div 10 > OldOperator div 10) or
          ((LastOperator div 10 = OldOperator div 10) and
          (MinOperator div 10 < LastOperator div 10)) then A := Value(A);
        try
          MinOperator := OldOperator;
          case OldOperator of
            1000: Result := Exp(A * Ln(V));
            1001: Result := V * A;
            1002: Result := V / A;
            1003: Result := V and A;
            1004: Result := V mod A;
            1005: Result := V div A;
            100: Result := V + A;
            101: Result := V - A;
            102: Result := V or A;
            10: Result := V = A;
            11: Result := V >= A;
            12: Result := V > A;
            13: Result := V <= A;
            14: Result := V <> A;
            15: Result := V < A;
          end;
        except
          case ErrorType of
            StopOnException:
              begin
                LastError := FRConst_IncompatDataType + ': ' + Ex;
                raise Exception.Create(FRConst_IncompatDataType + ': ' + Ex);
              end;
            ContinueOnExpection:
              begin
                LastError := FRConst_IncompatDataType + ': ' + Ex;
                Result := 0;
              end;
          end;
        end;
        if VarType(Result) = varBoolean then
          if Result = True then
            Result := 1
          else
            Result := 0;
      end;
  end;

begin
  Ex := P;
  if P^ <> #0 then
    begin
      V := Identifier;
      LastOperator := Operator;
      MinOperator := LastOperator;
      while (P^ <> #0) and (P^ <> ')') do
        V := Value(V);
      if P^ = ')' then Inc(P);
      Result := V;
    end
  else
    Result := Null;
end;

initialization
  Expr := nil;
  LastError := '';

finalization
  if Expr <> nil then Expr.Free;

end.

