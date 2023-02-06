unit BusinessQueue.Core.JsonConverters;

interface

uses
  System.JSON.Converters, System.JSON.Serializers, System.JSON.Writers,
  System.Rtti, System.JSON.Readers, System.TypInfo;

type
  // --------------------------------------------------------------------- //
  // Converter for TDictionary with TDate keys
  // --------------------------------------------------------------------- //

  TJsonDateDictionaryConverter<V> = class(TJsonDictionaryConverter<TDate, V>)
  protected
    function PropertyToKey(const APropertyName: string): TDate; override;
    function KeyToProperty(const AKey: TDate): string; override;
  end;

  TJsonIntegerDictionaryConverter<V> = class(TJsonDictionaryConverter<Integer, V>)
  protected
    function PropertyToKey(const APropertyName: string): Integer; override;
    function KeyToProperty(const AKey: Integer): string; override;
  end;

  TJsonWordDictionaryConverter<V> = class(TJsonDictionaryConverter<Word, V>)
  protected
    function PropertyToKey(const APropertyName: string): Word; override;
    function KeyToProperty(const AKey: Word): string; override;
  end;

  // --------------------------------------------------------------------- //
  // Converter for TTime - simple version
  // --------------------------------------------------------------------- //
  TJsonSimpleTimeConverter = class(TJsonConverter)
  public
    procedure WriteJson(const AWriter: TJsonWriter; const AValue: TValue; const ASerializer: TJsonSerializer); override;
    function ReadJson(const AReader: TJsonReader; ATypeInf: PTypeInfo; const AExistingValue: TValue;
      const ASerializer: TJsonSerializer): TValue; override;
    function CanConvert(ATypeInf: PTypeInfo): Boolean; override;
  end;

implementation

uses
  System.SysUtils;

{ TJsonDateDictionaryConverter<V> }

function TJsonDateDictionaryConverter<V>.KeyToProperty(const AKey: TDate): string;
begin
  Result := DateToStr(AKey);
end;

function TJsonDateDictionaryConverter<V>.PropertyToKey(const APropertyName: string): TDate;
begin
  if not APropertyName.IsEmpty then
    Result := StrToDate(APropertyName)
  else
    Result := Now;
end;

{ TJsonIntegerDictionaryConverter<V> }

function TJsonIntegerDictionaryConverter<V>.KeyToProperty(const AKey: Integer): string;
begin
  Result := AKey.ToString;
end;

function TJsonIntegerDictionaryConverter<V>.PropertyToKey(const APropertyName: string): Integer;
begin
  Result := APropertyName.ToInteger;
end;

{ TJsonWordDictionaryConverter<V> }

function TJsonWordDictionaryConverter<V>.KeyToProperty(const AKey: Word): string;
begin
  Result := AKey.ToString;
end;

function TJsonWordDictionaryConverter<V>.PropertyToKey(const APropertyName: string): Word;
begin
  if APropertyName.IsEmpty then
    Result := Word.MaxValue
  else
    Result := APropertyName.ToInteger;
end;

{ TJsonSimpleTimeConverter }

function TJsonSimpleTimeConverter.CanConvert(ATypeInf: PTypeInfo): Boolean;
begin
  Result := ATypeInf^.Kind = tkString;
end;

function TJsonSimpleTimeConverter.ReadJson(const AReader: TJsonReader; ATypeInf: PTypeInfo;
  const AExistingValue: TValue; const ASerializer: TJsonSerializer): TValue;
var
  LRawStr: string;
  LTime: TTime;
begin
  LRawStr := AReader.Value.AsString;
  LTime := StrToTime(LRawStr);
  TValue.Make(@LTime, ATypeInf, Result);
end;

procedure TJsonSimpleTimeConverter.WriteJson(const AWriter: TJsonWriter; const AValue: TValue;
  const ASerializer: TJsonSerializer);
begin
  AWriter.WriteValue(TimeToStr(AValue.AsType<TDateTime>));
end;

end.
