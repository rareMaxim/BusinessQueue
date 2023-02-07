unit Unit5;

interface

uses
  BusinessQueue.Sheduling,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid, FMX.ListBox, BusinessQueue, BusinessQueue.Clerk;

type
  TForm5 = class(TForm)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Grid1: TGrid;
    GroupBox1: TGroupBox;
    Layout1: TLayout;
  private
    { Private declarations }
    FBQ: TBussinessQueue;
  protected
    function CreateClerkSysoev: TBQClerk;
    function CreateClerkSarzhan: TBQClerk;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
    property BQ: TBussinessQueue read FBQ;
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

type
  TBQSheduleItemsWorkDay = class(TBQSheduleItems)
  protected
    procedure AddDefaultItem; virtual;
    procedure AddWorkTime; virtual;
    procedure AddEatTime; virtual;
  public
    constructor Create; override;
  end;

  TBQSheduleItemsWorkDay2EatTime = class(TBQSheduleItems)
  protected
    procedure AddDefaultItem; virtual;
    procedure AddWorkTime; virtual;
    procedure AddEatTime; virtual;
  public
    constructor Create; override;
  end;

constructor TForm5.Create(AOwner: TComponent);
begin
  ReportMemoryLeaksOnShutdown := True;
  inherited Create(AOwner);
  FBQ := TBussinessQueue.Create();
  FBQ.LoadConfigFromJson('cnap.json');
  FBQ.Provider.Name := 'Центр надання адміністративних послуг м. Мелітополь';
  FBQ.Clerks.AddClerk(CreateClerkSysoev);
  FBQ.Clerks.AddClerk(CreateClerkSarzhan);
  var
  LSheduleItems := FBQ.Clerks.Clerks['0934985555'].Shedule.GetSheduleByDate(EncodeDate(2023, 02, 01));
  var
  LTotalWorkDay := FBQ.Clerks.Clerks['0934985555'].Shedule.TotalWorkMinutes(EncodeDate(2023, 02, 01));
end;

function TForm5.CreateClerkSarzhan: TBQClerk;
begin
  Result := TBQClerk.Create;
  Result.Login := '0934985555';
  Result.FirstName := 'Alyona';
  Result.LastName := 'S';
  Result.IsActive := True;
  Result.Shedule.ByDate.Add(EncodeDate(2023, 02, 01), TBQSheduleItemsWorkDay2EatTime.Create);
  Result.Shedule.ByDay.AddOrSetValue(1, TBQSheduleItemsWorkDay.Create);
  Result.Shedule.ByDay.AddOrSetValue(2, TBQSheduleItemsWorkDay.Create);
  Result.Shedule.ByDay.AddOrSetValue(3, TBQSheduleItemsWorkDay.Create);
  Result.Shedule.ByDay.AddOrSetValue(4, TBQSheduleItemsWorkDay.Create);
  Result.Shedule.ByDay.AddOrSetValue(5, TBQSheduleItemsWorkDay.Create);
end;

function TForm5.CreateClerkSysoev: TBQClerk;
begin
  Result := TBQClerk.Create;
  Result.Login := '0684985555';
  Result.FirstName := 'Maxim';
  Result.LastName := 'S';
  Result.IsActive := True;
end;

destructor TForm5.Destroy;
begin
  FBQ.SaveConfigFromJson('cnap.json');
  FBQ.Free;
  inherited Destroy;
end;

{ TBQSheduleItemsWorkDay }

procedure TBQSheduleItemsWorkDay.AddDefaultItem;
begin
  Add(TBQSheduleItem.CreateOffline('Default shedule'));
end;

procedure TBQSheduleItemsWorkDay.AddEatTime;
begin
  Add(TBQSheduleItem.Create(EncodeTime(12, 0, 0, 0), EncodeTime(13, 0, 0, 0), 'EatTime', 1));
end;

procedure TBQSheduleItemsWorkDay.AddWorkTime;
begin
  Add(TBQSheduleItem.Create(EncodeTime(8, 0, 0, 0), EncodeTime(17, 0, 0, 0), 'WorkTime', 100));
end;

constructor TBQSheduleItemsWorkDay.Create;
begin
  inherited Create;
  AddDefaultItem;
  AddWorkTime;
  AddEatTime;
end;

{ TBQSheduleItemsWorkDay2EatTime }

procedure TBQSheduleItemsWorkDay2EatTime.AddDefaultItem;
begin
  Add(TBQSheduleItem.CreateOffline('Default shedule'));
end;

procedure TBQSheduleItemsWorkDay2EatTime.AddEatTime;
begin
  Add(TBQSheduleItem.Create(EncodeTime(10, 0, 0, 0), EncodeTime(11, 0, 0, 0), 'EatTime', 1));
  Add(TBQSheduleItem.Create(EncodeTime(13, 0, 0, 0), EncodeTime(14, 0, 0, 0), 'EatTime', 1));
end;

procedure TBQSheduleItemsWorkDay2EatTime.AddWorkTime;
begin
  Add(TBQSheduleItem.Create(EncodeTime(8, 0, 0, 0), EncodeTime(17, 0, 0, 0), 'WorkTime', 100));
end;

constructor TBQSheduleItemsWorkDay2EatTime.Create;
begin
  inherited;
  AddDefaultItem;
  AddWorkTime;
  AddEatTime;
end;

end.
