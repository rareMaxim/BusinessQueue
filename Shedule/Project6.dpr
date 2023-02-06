program Project6;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit5 in 'Unit5.pas' {Form5},
  BusinessQueue.Clerk in '..\BusinessQueue.Clerk.pas',
  BusinessQueue.Client in '..\BusinessQueue.Client.pas',
  BusinessQueue in '..\BusinessQueue.pas',
  BusinessQueue.Service in '..\BusinessQueue.Service.pas',
  BusinessQueue.Sheduling in '..\BusinessQueue.Sheduling.pas',
  BusinessQueue.Task in '..\BusinessQueue.Task.pas',
  BusinessQueue.Provider in '..\BusinessQueue.Provider.pas',
  BusinessQueue.Core.JsonConverters in '..\BusinessQueue.Core.JsonConverters.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
