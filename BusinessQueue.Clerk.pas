unit BusinessQueue.Clerk;

interface

uses
  BusinessQueue.Services,
  BusinessQueue.Sheduling,
  System.Generics.Collections,
  System.JSON.Serializers,
  System.JSON.Converters;

type
  TBQClerk = class
  private type
    TJsonServicesConverter = class(TJsonListConverter<TBQService>);
  private
    [JsonName('FirstName')]
    FFirstName: string;
    [JsonName('LastName')]
    FLastName: string;
    [JsonName('SurName')]
    FSurName: string;
    [JsonName('Login')]
    FLogin: string;
    [JsonName('Password')]
    FPassword: string;
    [JsonName('IsActive')]
    FIsActive: Boolean;
    [JsonName('SupportedServices')]
    [JsonConverter(TJsonServicesConverter)]
    FSupportedServices: TList<TBQService>;
    [JsonName('Shedule')]
    FShedule: TBQSheduling;
  public
    constructor Create;
    destructor Destroy; override;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property SurName: string read FSurName write FSurName;
    property Login: string read FLogin write FLogin;
    property Password: string read FPassword write FPassword;
    property IsActive: Boolean read FIsActive write FIsActive;
    property SupportedServices: TList<TBQService> read FSupportedServices;
    property Shedule: TBQSheduling read FShedule write FShedule;
  end;

  TBQClerks = class
  private type
    TJsonClerkConverter = class(TJsonStringDictionaryConverter<TBQClerk>);
  private
    [JsonName('Clerks')]
    [JsonConverter(TJsonClerkConverter)]
    FClerks: TObjectDictionary<string, TBQClerk>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddClerk(AClerk: TBQClerk);
    property Clerks: TObjectDictionary<string, TBQClerk> read FClerks;
  end;

implementation

constructor TBQClerk.Create;
begin
  inherited Create;
  FSupportedServices := TList<TBQService>.Create();
  FShedule := TBQSheduling.Create();
end;

destructor TBQClerk.Destroy;
begin
  FShedule.Free;
  FSupportedServices.Free;
  inherited Destroy;
end;

constructor TBQClerks.Create;
begin
  inherited Create;
  FClerks := TObjectDictionary<string, TBQClerk>.Create([doOwnsValues]);
end;

destructor TBQClerks.Destroy;
begin
  FClerks.Free;
  inherited Destroy;
end;

{ TBQClerks }

procedure TBQClerks.AddClerk(AClerk: TBQClerk);
begin
  FClerks.AddOrSetValue(AClerk.Login, AClerk);
end;

end.
