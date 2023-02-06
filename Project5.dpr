program Project5;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  BusinessQueue in 'BusinessQueue.pas',
  BusinessQueue.Service in 'BusinessQueue.Service.pas',
  BusinessQueue.Client in 'BusinessQueue.Client.pas',
  BusinessQueue.Clerk in 'BusinessQueue.Clerk.pas',
  BusinessQueue.Sheduling in 'BusinessQueue.Sheduling.pas',
  BusinessQueue.Task in 'BusinessQueue.Task.pas',
  BusinessQueue.Provider in 'BusinessQueue.Provider.pas',
  BusinessQueue.Core.JsonConverters in 'BusinessQueue.Core.JsonConverters.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
