program Project5;

{$APPTYPE CONSOLE}
{$R *.res}

uses

  System.SysUtils,
  BusinessQueue in 'BusinessQueue.pas',
  BusinessQueue.Services in 'BusinessQueue.Services.pas',
  BusinessQueue.Client in 'BusinessQueue.Client.pas',
  BusinessQueue.Clerk in 'BusinessQueue.Clerk.pas',
  BusinessQueue.Sheduling in 'BusinessQueue.Sheduling.pas',
  BusinessQueue.Task in 'BusinessQueue.Task.pas',
  BusinessQueue.Provider in 'BusinessQueue.Provider.pas',
  BusinessQueue.Core.JsonConverters in 'BusinessQueue.Core.JsonConverters.pas',
  BQ.Server in 'BQ.Server.pas';

procedure RunQueue;
var
  LServer: TBQServer;
begin
  LServer := TBQServer.Create;
  try
    LServer.StartServer;
  finally
    LServer.Free;
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    RunQueue;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
