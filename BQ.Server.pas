unit BQ.Server;

interface

uses
  Horse,
  BusinessQueue,
  System.JSON.Serializers;

type
  TBQServer = class
  private
    FBussinessQueue: TBussinessQueue;
    FSerializer: TJsonSerializer;
  public
    procedure StartServer;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  System.JSON.Types,
  System.Generics.Collections, BusinessQueue.Clerk;

constructor TBQServer.Create;
begin
  inherited Create;
  FBussinessQueue := TBussinessQueue.Create();
  FBussinessQueue.LoadConfigFromJson('D:\git\BusinessQueue\Shedule\Win32\Debug\cnap.json');
  FSerializer := TJsonSerializer.Create();
  FSerializer.Formatting := TJsonFormatting.Indented;
end;

destructor TBQServer.Destroy;
begin
  FSerializer.Free;
  FBussinessQueue.Free;
  inherited Destroy;
end;

procedure TBQServer.StartServer;
begin
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TNextProc)
    begin
      Res.RawWebResponse.ContentType := 'application/json; charset=UTF-8';
      Res.Send('pong');
    end);
  THorse.Get('/getClerks',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TNextProc)
    begin
      Res.RawWebResponse.ContentType := 'application/json; charset=UTF-8';
      Res.Send(FSerializer.Serialize<TBQClerks>(FBussinessQueue.Clerks));
    end);

  THorse.Listen(9000,
    procedure(Horse: THorse)
    begin
      Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
      Readln;
    end);
end;

end.
