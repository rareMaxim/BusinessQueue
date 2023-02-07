unit BusinessQueue;

interface

uses
  BusinessQueue.Clerk,
  BusinessQueue.Client,
  BusinessQueue.Provider,
  BusinessQueue.Services,
  BusinessQueue.Task,
  System.JSON.Converters,
  System.JSON.Serializers,
  System.Generics.Collections, System.JSON.Types;

type

  TBussinessQueue = class
  private type
    TJsonTaskConverter = class(TJsonListConverter<TBQTask>);
    TJsonServisesConverter = class(TJsonListConverter<TBQService>);
  private
    [JsonName('Clerks')]
    FClerks: TBQClerks;
    [JsonName('Tasks')]
    [JsonConverter(TJsonTaskConverter)]
    FTasks: TObjectList<TBQTask>;
    [JsonName('Provider')]
    FProvider: TBQProvider;
    [JsonName('Services')]
    [JsonConverter(TJsonServisesConverter)]
    FServices: TObjectList<TBQService>;
  public

    constructor Create;
    destructor Destroy; override;
    procedure LoadConfigFromJson(const AFileName: string);
    procedure SaveConfigFromJson(const AFileName: string);
    procedure NewTask(AService: TBQService; AClient: TBQClient); virtual; abstract;
    property Provider: TBQProvider read FProvider;
    property Clerks: TBQClerks read FClerks write FClerks;
    property Services: TObjectList<TBQService> read FServices;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils;

constructor TBussinessQueue.Create;
begin
  inherited Create;
  FTasks := TObjectList<TBQTask>.Create();
  FProvider := TBQProvider.Create();
  FServices := TObjectList<TBQService>.Create();
  FClerks := TBQClerks.Create();
end;

destructor TBussinessQueue.Destroy;
begin
  FServices.Free;
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
