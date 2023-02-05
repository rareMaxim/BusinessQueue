unit BusinessQueue.Clerk;

interface

uses
  BusinessQueue.Service,
  System.Generics.Collections;

type
  TBQClerk = class
  private
    FFirstName: string;
    FLastName: string;
    FSurName: string;
    FLogin: string;
    FPassword: string;
    FIsActive: Boolean;
    FSupportedServices: TList<TBQService>;
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
  end;

implementation

constructor TBQClerk.Create;
begin
  inherited Create;
  FSupportedServices := TList<TBQService>.Create();
end;

destructor TBQClerk.Destroy;
begin
  FSupportedServices.Free;
  inherited Destroy;
end;

end.
