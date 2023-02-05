unit BusinessQueue.Sheduling;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type

  TBQSheduleItem = record
  private
    FStart: TTime;
    FStop: TTime;
    FName: string;
    FIsWork: Boolean;
  public
    //08:00
    property Start: TTime read FStart write FStart;
    // 17:00
    property Stop: TTime read FStop write FStop;
    // Work time
    property Name: string read FName write FName;
    // True
    property IsWork: Boolean read FIsWork write FIsWork;
  end;

  {
   08:00 - 17:00 True - Робочий час
   12:00 - 13:00 False - Обідня перерва
   ------------------------------------
   00:00 .. 08:00 .. 12:00 .. 13:00 .. 17:00 .. 23:59
   -------- +++++++++ ------- +++++++++ -------------
  }
  IBQShedule = interface
    ['{DA0435FD-B193-4691-982C-D93FACF03336}']
    function GetSheduleByDate(const ADate: TDate): TArray<TBQSheduleItem>;
  end;

  TBQSheduling = class
  private
    FByDate: TDictionary<TDate, Boolean>;
    FByDay: TDictionary<Byte, Boolean>;
  public
    property ByDate: TDictionary<TDate, Boolean> read FByDate write FByDate;
    property ByDay: TDictionary<Byte, Boolean> read FByDay write FByDay;
  end;

implementation

end.
