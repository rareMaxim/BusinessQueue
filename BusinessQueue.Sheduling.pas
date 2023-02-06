unit BusinessQueue.Sheduling;

interface

uses
  BusinessQueue.Core.JsonConverters,
  System.SysUtils,
  System.Generics.Collections,
  System.Json.Serializers,
  System.Json.Converters,
  System.TimeSpan;

type

  TBQSheduleItem = record
  private
    [JsonName('Start')]
    [JsonConverter(TJsonSimpleTimeConverter)]
    FStart: TTime;
    [JsonName('Stop')]
    [JsonConverter(TJsonSimpleTimeConverter)]
    FStop: TTime;
    [JsonName('Name')]
    FName: string;
    [JsonName('Tag')]
    FTag: Byte;
  public
    class function Create(AStart, AStop: TTime; const AName: string; ATag: Byte): TBQSheduleItem; static;
    class function CreateOffline(const AName: string): TBQSheduleItem; static;
    function ToString: string;
    function IsWorkTime: Boolean;
    function Duration: TTimeSpan;
    //08:00
    property Start: TTime read FStart write FStart;
    // 17:00
    property Stop: TTime read FStop write FStop;
    // Work time
    property Name: string read FName write FName;
    // 0..99 = not work time / 100..255 = work time
    property Tag: Byte read FTag write FTag;

  end;

  {
   1. 00:00 - 23:59 False - Default Offline
   2. 08:00 - 17:00 True  - Робочий час
   3. 10:00 - 11:00 False - Обідня перерва
   4. 14:00 - 15:00 False - Обідня перерва
   ------------------------------------
   00:00 .. 08:00 .. 10:00 .. 11:00 ..14:00 .. 15:00 .. 17:00 .. 23:59
   -------- +++++++++ ------- +++++++++ -------+++++++++--------------
   Offline  Роб. час  Обід    Роб. час  Обід   Роб. час Offline
   **************************************************
   1. 00:00 - 08:00 - Default Offline
   2. 08:00 - 10:00 - Робочий час
   3. 10:00 - 11:00 - Обід
   4. 11:00 - 14:00 - Робочий час
   5. 14:00 - 15:00 - Обід
   6. 15:00 - 17:00 - Робочий час
   7. 17:00 - 23:59 - Default Offline
   00:00 .. 08:00 = False   |   00:00 .. 12:00 = False
   08:00 .. 17:00 = True    |   12:00 .. 13:00 = False
   17:00 .. 23:59 = False   |   13:00 .. 23:59 = False

  }
  TBQSheduleItems = class
  private type
    TJsonSheduleItemListConverter = class(TJsonListConverter<TBQSheduleItem>);
  private
    [JsonName('Items')]
    [JsonConverter(TJsonSheduleItemListConverter)]
    FItems: TList<TBQSheduleItem>;
  protected
    function GetCompileItems: TArray<TBQSheduleItem>;
  public
    procedure Add(ASheduleItem: TBQSheduleItem);
    constructor Create; virtual;
    destructor Destroy; override;
    property Items: TList<TBQSheduleItem> read FItems;
    property Compiled: TArray<TBQSheduleItem> read GetCompileItems;
  end;

  IBQShedule = interface
    ['{DA0435FD-B193-4691-982C-D93FACF03336}']
    function GetSheduleByDate(const ADate: TDate): TArray<TBQSheduleItem>;
  end;

  TBQSheduling = class{(,TInterfacedObject IBQShedule) }
  private type
    TTJsonDateSheduleItemDictionaryConverter = class(TJsonDateDictionaryConverter<TBQSheduleItems>);
    TTJsonDaySheduleItemDictionaryConverter = class(TJsonWordDictionaryConverter<TBQSheduleItems>);
  private
    [JsonName('ByDate')]
    [JsonConverter(TTJsonDateSheduleItemDictionaryConverter)]
    FByDate: TObjectDictionary<TDate, TBQSheduleItems>;
    [JsonName('ByDay')]
    [JsonConverter(TTJsonDaySheduleItemDictionaryConverter)]
    FByDay: TObjectDictionary<Word, TBQSheduleItems>;
  public
    constructor Create;
    destructor Destroy; override;
    // high priority
    property ByDate: TObjectDictionary<TDate, TBQSheduleItems> read FByDate;
    // low  priority
    property ByDay: TObjectDictionary<Word, TBQSheduleItems> read FByDay;
    function GetSheduleByDate(const ADate: TDate): TArray<TBQSheduleItem>;
    function TotalWorkMinutes(const ADate: TDate): Double;
  end;

implementation

uses
  System.Generics.Defaults,
  System.DateUtils;

procedure TBQSheduleItems.Add(ASheduleItem: TBQSheduleItem);
begin
  //  if FItems.Count = 0 then
  //    AddDefaultItem;
  FItems.Add(ASheduleItem);
end;

function TBQSheduleItems.GetCompileItems: TArray<TBQSheduleItem>;
var
  LCompiledItems: TList<TBQSheduleItem>;
  Comparison: TComparison<TBQSheduleItem>;
  LComp1, LComp2: TBQSheduleItem;
  LCurComp: TBQSheduleItem;
  LDeleteFirstCompiled: Boolean;
begin
  for var I := 0 to FItems.Count - 1 do
    Writeln(FItems[I].ToString);
  Writeln('--------------------------');
  LCompiledItems := TList<TBQSheduleItem>.Create;
  try
    for var LShedule in FItems do
    begin
      if LCompiledItems.Count = 0 then
        LCompiledItems.Add(LShedule)
      else
        for var LCompiledIndex := LCompiledItems.Count - 1 downto 0 do
        begin
          //  LDeleteFirstCompiled := False;
          LCurComp := LCompiledItems[LCompiledIndex];
          if (LShedule.Start > LCurComp.Start) and (LShedule.Stop < LCurComp.Stop) then
          begin
            LComp1 := TBQSheduleItem.Create(LCurComp.Start, LShedule.Start, LCurComp.Name, LCurComp.Tag);
            LCompiledItems.Add(LComp1);
            LComp2 := TBQSheduleItem.Create(LShedule.Stop, LCurComp.Stop, LCurComp.Name, LCurComp.Tag);
            LCompiledItems.Add(LComp2);
            LDeleteFirstCompiled := True;
          end
          else
            Continue;
          LCompiledItems.Add(LShedule);
          if LDeleteFirstCompiled then
          begin
            Writeln('Delete Compliled:  ' + LCompiledItems[LCompiledIndex].ToString);
            LCompiledItems.Delete(LCompiledIndex);
          end;
        end;

      Comparison := function(const Left, Right: TBQSheduleItem): Integer
        begin
          Result := TComparer<TDateTime>.Default.Compare(Left.Start, Right.Start);
        end;
      LCompiledItems.Sort(TComparer<TBQSheduleItem>.Construct(Comparison));
      for var I := 0 to LCompiledItems.Count - 1 do
        Writeln(LCompiledItems[I].ToString);
      Writeln('--------------------------');
    end;
    Result := LCompiledItems.ToArray;
  finally
    LCompiledItems.Free;
  end;

end;

constructor TBQSheduleItems.Create;
begin
  inherited Create;
  FItems := TList<TBQSheduleItem>.Create();
end;

destructor TBQSheduleItems.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

class function TBQSheduleItem.Create(AStart, AStop: TTime; const AName: string; ATag: Byte): TBQSheduleItem;
begin
  Result.Start := AStart;
  Result.Stop := AStop;
  Result.Name := AName;
  Result.Tag := ATag;
end;

class function TBQSheduleItem.CreateOffline(const AName: string): TBQSheduleItem;
begin
  Result := TBQSheduleItem.Create(EncodeTime(0, 0, 0, 0), EncodeTime(23, 59, 59, 99), AName, 0);
  if AName.IsEmpty then
    Result.Name := 'Offline';
end;

function TBQSheduleItem.Duration: TTimeSpan;
begin
  Result := TTimeSpan.Subtract(Stop, Start);
end;

function TBQSheduleItem.IsWorkTime: Boolean;
begin
  Result := Tag >= 100;
end;

{ TBQSheduleItem }

function TBQSheduleItem.ToString: string;
begin
  Result := Format('%s - %s = %s @ %s', [TimeToStr(Start), TimeToStr(Stop), Tag.ToHexString, Name]);
end;

constructor TBQSheduling.Create;
begin
  inherited Create;
  FByDate := TObjectDictionary<TDate, TBQSheduleItems>.Create([doOwnsValues]);
  FByDay := TObjectDictionary<Word, TBQSheduleItems>.Create([doOwnsValues]);
end;

destructor TBQSheduling.Destroy;
begin
  FByDay.Free;
  FByDate.Free;
  inherited Destroy;
end;

function TBQSheduling.GetSheduleByDate(const ADate: TDate): TArray<TBQSheduleItem>;
var
  LShedule: TBQSheduleItems;
  LDayOfWeek: Word;
begin
  LDayOfWeek := DayOfWeek(ADate);
  if FByDate.TryGetValue(ADate, LShedule) or FByDay.TryGetValue(LDayOfWeek, LShedule) then
    Result := LShedule.Compiled
  else
    raise Exception.Create('Shedule not Found');
end;

function TBQSheduling.TotalWorkMinutes(const ADate: TDate): Double;
var
  LSheduleByDay: TArray<TBQSheduleItem>;
begin
  Result := 0;
  LSheduleByDay := GetSheduleByDate(ADate);
  for var LSheduleItem in LSheduleByDay do
    if LSheduleItem.IsWorkTime then
      Result := Result + LSheduleItem.Duration.TotalMinutes;
end;

end.
