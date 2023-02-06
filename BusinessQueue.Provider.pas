unit BusinessQueue.Provider;

interface

type
  TBQProvider = class
  private
    FName: string;
  public
    property Name: string read FName write FName;
  end;

implementation

end.
