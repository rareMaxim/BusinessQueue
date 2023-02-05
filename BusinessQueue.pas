unit BusinessQueue;

interface

uses
  BusinessQueue.Service,
  BusinessQueue.Client;

type

  TBussinessQueue = class
  public
    procedure NewTask(AService: TBQService; AClient: TBQClient); virtual; abstract;
  end;

implementation

end.
