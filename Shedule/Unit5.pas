unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Grid, FMX.ListBox;

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
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

end.
