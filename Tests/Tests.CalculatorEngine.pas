unit Tests.CalculatorEngine;

interface

uses
  System.Classes, System.SysUtils, Data.FMTBcd,
  DUnitX.TestFramework,
  Calculator.Engine;

type

  [TestFixture]
  TTestCalculatorEngine = class
  private
    FEngine: TCalculatorEngine;
    FOriginalSeparator: Char;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    procedure TestEnterKeys(const AKeys: string; AExpectedValue: string);

    [Test]
    procedure TestInitial;
    [Test]
    [TestCase('Test Integer 1', '1')]
    [TestCase('Test Integer 0', '0')]
    [TestCase('Test Integer Negative', '-1')]
    [TestCase('Test Integer Large', '9999999999')]
    procedure TestInteger(const AValue: Integer);

    [Test]
    [TestCase('Test 0 simple', '0, 0')]
    [TestCase('Test 0 multiple', '0000, 0')]
    [TestCase('Test misc 1', '42, 42')]
    [TestCase('Test misc 2', '999, 999')]
    [TestCase('Test negative 1', '999p, -999')]
    procedure TestEnterNumbers(const AKeys: string; AExpectedValue: Integer);

    [Test]
    [TestCase('Test decimal 1.23', '1.23,1.23')]
    [TestCase('Test decimal 1 -1.23', '1.23p,-1.23')]
    [TestCase('Test decimal 2 -1.23', '1p.23,-1.23')]
    procedure TestEnterDecimals(const AKeys: string; AExpectedValue: string);

    [Test]
    [TestCase('Test Clear 1', '1.23c,0')]
    [TestCase('Test Clear 2', '1456.c,0')]
    procedure TestClear(const AKeys: string; AExpectedValue: string);

    [Test]
    [TestCase('Test multiply (still open)', '123*10,10')]
    [TestCase('Test multiply', '123*10=,1230')]
    [TestCase('Test multiply', '12.3*10=,123')]
    [TestCase('Test add', '12.3+10=,22.3')]
    [TestCase('Test minus', '12.3-100.1=,-87.8')]
    [TestCase('Test divide', '12/4=,3')]
    [TestCase('Test divide', '10/4=,2.5')]
    procedure TestOperation(const AKeys: string; AExpectedValue: string);
  end;

implementation

procedure TTestCalculatorEngine.Setup;
begin
  FOriginalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  FEngine := TCalculatorEngine.Create;
end;

procedure TTestCalculatorEngine.TearDown;
begin
  FreeAndNil(FEngine);
  FormatSettings.DecimalSeparator := FOriginalSeparator;
end;

procedure TTestCalculatorEngine.TestClear(const AKeys: string; AExpectedValue: string);
begin
  TestEnterKeys(AKeys, AExpectedValue);
end;

procedure TTestCalculatorEngine.TestEnterDecimals(const AKeys: string; AExpectedValue: string);
begin
  TestEnterKeys(AKeys, AExpectedValue);
end;

procedure TTestCalculatorEngine.TestEnterKeys(const AKeys: string; AExpectedValue: string);
begin
  for var c in AKeys do
  begin
    FEngine.KeyIn(c);
  end;
  Assert.AreEqual(AExpectedValue, FEngine.ValueString);
end;

procedure TTestCalculatorEngine.TestEnterNumbers(const AKeys: string; AExpectedValue: Integer);
begin
  for var c in AKeys do
  begin
    FEngine.KeyIn(c);
  end;
  Assert.AreEqual(AExpectedValue, Integer(FEngine.Value));
end;

procedure TTestCalculatorEngine.TestInitial;
begin
  Assert.AreEqual(0, Integer(FEngine.Value), 'Value Zero')
end;

procedure TTestCalculatorEngine.TestInteger(const AValue: Integer);
begin
  FEngine.Value := AValue;
  Assert.AreEqual(AValue, Integer(FEngine.Value));
end;

procedure TTestCalculatorEngine.TestOperation(const AKeys: string; AExpectedValue: string);
begin
  TestEnterKeys(AKeys, AExpectedValue);
end;

initialization

TDUnitX.RegisterTestFixture(TTestCalculatorEngine);

end.
