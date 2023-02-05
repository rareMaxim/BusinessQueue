unit BusinessQueue.Client;

interface

type
  TBQClient = class
  private
    FFirstName: string;
    FLastName: string;
    FSurName: string;
    FDate: TDateTime;
    FIsPriority: Boolean;
  public
    // Ім'я
    property FirstName: string read FFirstName write FFirstName;
    // Призвіще
    property LastName: string read FLastName write FLastName;
    // По-Батькові
    property SurName: string read FSurName write FSurName;
    // Час, на коли назначена послуга
    property Date: TDateTime read FDate write FDate;
    // Пріоритетний клієнт
    property IsPriority: Boolean read FIsPriority write FIsPriority;
  end;

implementation

end.
