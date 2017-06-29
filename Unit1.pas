unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  Svc, System.ImageList, FMX.ImgList, FMX.Objects, FMX.Edit, FMX.ComboEdit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView,
  System.Generics.Collections;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    ComboBox2: TComboBox;
    ButtonImageList: TImageList;
    Image1: TImage;
    ComboEdit1: TComboEdit;
    ListView1: TListView;
    QuarkImageList: TImageList;
    StatusImageList: TImageList;
    Button2: TButton;
    SpeedButton4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    type
      TServiceItem = record
        Name: string;
        ImageIndex: Integer;
      end;

    const
      Defaults: array [0..2] of TServiceItem = (
        (Name: 'Schedule'; ImageIndex: -1),
        (Name: 'QPPServer'; ImageIndex: 0),
        (Name: 'QuarkXPressServer2016'; ImageIndex: 1));
  private
    { Private declarations }
    FInitialized: Boolean;
    FServiceManager: IWindowsServiceManager;

    FMonitoredServices: TList<TServiceItem>;
    procedure Initialize;
    procedure DisplayMonitoredServices;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses WinSvc, FMX.MultiResBitmap;

procedure TForm1.DisplayMonitoredServices;
var
  ListItem: TListViewItem;
  MonitoredItem: TServiceItem;
begin
  for MonitoredItem in FMonitoredServices do
  begin
    ListItem := ListView1.Items.Add;
    ListItem.Text := MonitoredItem.Name;
    ListItem.ImageIndex := MonitoredItem.ImageIndex;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  if (ServiceStart('\\ComputerName', 'alerter')) then
//  begin
//
//    // ..
//  end;
//  if (ServiceStop('', 'alerter')) then
//  begin
//
//    // ..
//  end;


//// Check if Eventlog Service is running
//procedure TForm1.Button1Click(Sender: TObject);
//begin
//  if ServiceRunning(nil, 'Eventlog') then
//    ShowMessage('Eventlog Service Running')
//  else
//    ShowMessage('Eventlog Service not Running')
//end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Item: TListViewItem;
  ldes, lOrder, lLegal : TListItemText;
begin
//   ldes := list.Objects.FindObjectT<TListItemText>('Description');
//   lOrder := list.Objects.FindObjectT<TListItemText>('OrderId');
//   lLegal := list.Objects.FindObjectT<TListItemText>('LegalCode');
//   ldes.Text := 'Mouri';
//   lOrder.Text := 'Love';
//   lLegal.Text := 'You'
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if Assigned(FServiceManager) then
    Caption := FServiceManager.GetService(ComboEdit1.Text).Status.ToString;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex > -1 then
    FServiceManager := NewWindowsServiceManager(ComboBox2.Selected.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Item: TServiceItem;
begin
  FMonitoredServices := TList<TServiceItem>.Create;

  for Item in Defaults do
    FMonitoredServices.Add(Item);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FMonitoredServices);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Initialize;
end;

procedure TForm1.Initialize;
begin
  if FInitialized then
    Exit;
  FInitialized := True;

  DisplayMonitoredServices;

  ComboBox2Change(Self);
  Timer1.Enabled := True;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if Assigned(FServiceManager) then
    FServiceManager.GetService(ComboEdit1.Text).Start;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if Assigned(FServiceManager) then
    FServiceManager.GetService(ComboEdit1.Text).Stop;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Item: TCustomBitmapItem;
  Size: TSize;
begin
  Item := nil;

  if Assigned(FServiceManager) then
    case FServiceManager.GetService(ComboEdit1.Text).Status of
      SERVICE_STOPPED: ButtonImageList.BitmapItemByName('Stopped', Item, Size);
      SERVICE_START_PENDING: ButtonImageList.BitmapItemByName('Starting', Item, Size);
      SERVICE_STOP_PENDING: ButtonImageList.BitmapItemByName('Stopping', Item, Size);
      SERVICE_RUNNING: ButtonImageList.BitmapItemByName('Running', Item, Size);
      SERVICE_CONTINUE_PENDING: ButtonImageList.BitmapItemByName('Continuing', Item, Size);
      SERVICE_PAUSE_PENDING: ButtonImageList.BitmapItemByName('Pausing', Item, Size);
      SERVICE_PAUSED: ButtonImageList.BitmapItemByName('Paused', Item, Size);

//      else
// *** -1 = Error opening service *** }
    end;
    if Assigned(Item) then
      Image1.Bitmap := Item.MultiResBitmap.Bitmaps[1.0]
    else
      Image1.Bitmap := nil;
end;

end.
