unit BusinessQueue;

interface

uses
  BusinessQueue.Clerk,
  BusinessQueue.Client,
  BusinessQueue.Provider,
  BusinessQueue.Service,
  BusinessQueue.Task,
  System.JSON.Converters,
  System.JSON.Serializers,
  System.Generics.Collections, System.JSON.Types;

type

  TBussinessQueue = class
  private type
    TJsonClerkConverter = class(TJsonStringDictionaryConverter<TBQClerk>);
    TJsonTaskConverter = class(TJsonListConverter<TBQTask>);
  private
    [JsonName('Clerks')]
    [JsonConverter(TJsonClerkConverter)]
    FClerks: TObjectDictionary<string, TBQClerk>;
    [JsonName('Tasks')]
    [JsonConverter(TJsonTaskConverter)]
    FTasks: TObjectList<TBQTask>;
    [JsonName('Provider')]
    FProvider: TBQProvider;
  public
    procedure AddClerk(AClerk: TBQClerk);
    constructor Create;
    destructor Destroy; override;
    procedure LoadConfigFromJson(const AFileName: string);
    procedure SaveConfigFromJson(const AFileName: string);
    procedure NewTask(AService: TBQService; AClient: TBQClient); virtual; abstract;
    property Provider: TBQProvider read FProvider;
    property Clerks: TObjectDictionary<string, TBQClerk> read FClerks;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils;

procedure TBussinessQueue.AddClerk(AClerk: TBQClerk);
begin
  FClerks.AddOrSetValue(AClerk.Login, AClerk);
end;

constructor TBussinessQueue.Create;
begin
  inherited Create;
  FClerks := TObjectDictionary<string, TBQClerk>.Create([doOwnsValues]);
  FTasks := TObjectList<TBQTask>.Create();
  FProvider := TBQProvider.Create();
end;

destructor TBussinessQueue.Destroy;
begin
  FProvider.Free;
  FTasks.Free;
  FClerks.Free;
  inherited Destroy;
end;

procedure TBussinessQueue.LoadConfigFromJson(const AFileName: string);
var
  LSerializer: TJsonSerializer;
  LDB: string;
begin
  if not TFile.Exists(AFileName) then
    Exit;
  LSerializer := TJsonSerializer.Create;
  try
    LDB := TFile.ReadAllText(AFileName);
    LSerializer.Populate<TBussinessQueue>(LDB, Self);
  finally
    LSerializer.Free;
  end;
end;

procedure TBussinessQueue.SaveConfigFromJson(const AFileName: string);
var
  LSerializer: TJsonSerializer;
  LDB: string;
begin
  LSerializer := TJsonSerializer.Create;
  try
    LSerializer.Formatting := TJsonFormatting.Indented;
    LDB := LSerializer.Serialize<TBussinessQueue>(Self);
    TFile.WriteAllText(AFileName, LDB);
  finally
    LSerializer.Free;
  end;
end;

end.
