unit BusinessQueue.Service;

interface

type
  TBQService = class
  private
    FName: string;
    FDuration: TTime;
  public
    // Назва послуги - Реєстрація місця проживання
    property Name: string read FName write FName;
    // 00:30:00 - скільки часу відведено під надання послуги
    property Duration: TTime read FDuration write FDuration;
  end;

implementation

end.
