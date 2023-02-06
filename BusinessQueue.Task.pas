unit BusinessQueue.Task;

interface

uses
  BusinessQueue.Client,
  BusinessQueue.Service;

type
  TBQTask = class
  private
    FClient: TBQClient;
    FService: TBQService;
    FCreated: TDateTime;
    FStarted: TDateTime;
    FFinished: TDateTime;
  public
    constructor Create(AClient: TBQClient; AService: TBQService);
    property Created: TDateTime read FCreated write FCreated;
    property Started: TDateTime read FStarted write FStarted;
    property Finished: TDateTime read FFinished write FFinished;
  end;

implementation

constructor TBQTask.Create(AClient: TBQClient; AService: TBQService);
begin
  inherited Create;
  FClient := AClient;
end;

end.
