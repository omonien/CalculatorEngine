unit Calculator.Engine;

interface

uses
  System.Classes, System.SysUtils, Data.FMTBcd;

{$SCOPEDENUMS on}


type
  TCalculatorEngine = class(TObject)

  public
    type
    TOperator = (None, Equal, PlusMinus, Decimal, Plus, Minus, Multiply, Divide, Clear);
  strict private
    FPreviousValue: TBCD;
    FValueString: string;
    FActiveOperator: TOperator;
    procedure ProcessNumber(AKey: char);
    procedure ProcessOperator(AKey: char);
    function GetOperatorFromKey(AKey: char): TOperator;
    function GetValue: TBCD;
    procedure SetValue(const Value: TBCD);
    function GetValueString: string;

  protected
    procedure TransferValue;

    procedure Decimal;
    procedure Plus;
    procedure Minus;
    procedure Multiply;
    procedure Divide;

    procedure Clear;
    procedure Equal;

    procedure DoPlus;
    procedure DoMinus;
    procedure DoMultiply;
    procedure DoDivide;

    procedure DoAfterCalc;
  public
    constructor Create;
    property Value: TBCD read GetValue write SetValue;
    property ValueString: string read GetValueString;
    Procedure KeyIn(AKey: char); overload;
  end;

implementation

type
  TOp = TCalculatorEngine.TOperator;

const
  NUMBERS = ['0' .. '9'];
  NON_CALC_OPERATORS = [TOp.Clear, TOp.Equal, TOp.PlusMinus, TOp.Decimal];
  CALC_OPERATORS = [TOp.Multiply, TOp.Plus, TOp.Minus, TOp.Divide];
  OPERATORS = NON_CALC_OPERATORS + CALC_OPERATORS;

  { TCalculatorEngine }

procedure TCalculatorEngine.Clear;
begin
  FActiveOperator := TOperator.None;
  FValueString := '0';
  FPreviousValue := 0.0;
end;

constructor TCalculatorEngine.Create;
begin
  inherited;
  Clear;
end;

procedure TCalculatorEngine.Decimal;
begin
  if not FValueString.Contains('.') then
  begin
    FValueString := FValueString + FormatSettings.DecimalSeparator;
  end;
end;

procedure TCalculatorEngine.Divide;
begin
  TransferValue;
  FActiveOperator := TOp.Divide;
end;

procedure TCalculatorEngine.DoAfterCalc;
begin
  FPreviousValue := 0;
  FActiveOperator := TOp.None;
end;

procedure TCalculatorEngine.DoDivide;
begin
  Value := FPreviousValue / Value;
  DoAfterCalc;
end;

procedure TCalculatorEngine.DoMinus;
begin
  Value := FPreviousValue - Value;
  DoAfterCalc;
end;

procedure TCalculatorEngine.DoMultiply;
begin
  Value := FPreviousValue * Value;
  DoAfterCalc;
end;

procedure TCalculatorEngine.DoPlus;
begin
  Value := FPreviousValue + Value;
  DoAfterCalc;
end;

procedure TCalculatorEngine.Equal;
begin
  if FActiveOperator in CALC_OPERATORS then
  begin
    case FActiveOperator of
      TCalculatorEngine.TOperator.Plus:
        DoPlus;
      TCalculatorEngine.TOperator.Minus:
        DoMinus;
      TCalculatorEngine.TOperator.Multiply:
        DoMultiply;
      TCalculatorEngine.TOperator.Divide:
        DoDivide;
    end;
  end;
end;

procedure TCalculatorEngine.KeyIn(AKey: char);
begin
  if CharInSet(AKey, NUMBERS) then
    ProcessNumber(AKey)
  else
    ProcessOperator(AKey);
end;

procedure TCalculatorEngine.Multiply;
begin
  TransferValue;
  FActiveOperator := TOp.Multiply;
end;

function TCalculatorEngine.GetOperatorFromKey(AKey: char): TOperator;
begin
  case AKey of
    '=':
      result := TOp.Equal;
    '.':
      result := TOp.Decimal;
    'p':
      result := TOp.PlusMinus;
    '-':
      result := TOp.Minus;
    '+':
      result := TOp.Plus;
    '*':
      result := TOp.Multiply;
    '/':
      result := TOp.Divide;
    'c':
      result := TOp.Clear;
  else
    raise Exception.Create('Invalid operator!');
  end;
end;

function TCalculatorEngine.GetValue: TBCD;
begin
  result := StrToBcd(FValueString);
end;

function TCalculatorEngine.GetValueString: string;
begin
  result := FValueString;
end;

procedure TCalculatorEngine.Plus;
begin
  TransferValue;
  FActiveOperator := TOp.Plus;
end;

procedure TCalculatorEngine.Minus;
begin
  TransferValue;
  FActiveOperator := TOp.Minus;
end;

procedure TCalculatorEngine.ProcessNumber(AKey: char);
begin
  FValueString := FValueString + AKey;
  // cut off  leading zeros
  while (FValueString.Length >= 2) And FValueString.StartsWith('0') do
  begin
    FValueString := FValueString.Remove(0, 1);
  end;
end;

procedure TCalculatorEngine.ProcessOperator(AKey: char);
var
  LOperator: TOperator;
begin
  LOperator := GetOperatorFromKey(AKey);
  case LOperator of
    TOp.None:
      ;
    TOp.PlusMinus:
      Value := Value * -1;
    TOp.Decimal:
      Decimal;
    TOp.Plus:
      Plus;
    TOp.Minus:
      Minus;
    TOp.Multiply:
      Multiply;
    TOp.Divide:
      Divide;
    TOp.Equal:
      Equal;
    TOp.Clear:
      Clear;
  else
    raise Exception.Create('Operator not implemented!');
  end;
end;

procedure TCalculatorEngine.SetValue(const Value: TBCD);
begin
  FValueString := BcdToStr(Value);
end;

procedure TCalculatorEngine.TransferValue;
begin
  FPreviousValue := Value;
  FValueString := '0';
end;

end.
