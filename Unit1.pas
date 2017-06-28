unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  Svc, System.ImageList, FMX.ImgList, FMX.Objects, FMX.Edit, FMX.ComboEdit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    Label1: TLabel;
    ComboBox2: TComboBox;
    SpeedButton1: TSpeedButton;
    ButtonImageList: TImageList;
    SpeedButton2: TSpeedButton;
    ImageControl1: TImageControl;
    SpeedButton3: TSpeedButton;
    Image1: TImage;
    ComboEdit1: TComboEdit;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FInitialized: Boolean;
    FServiceManager: IWindowsServiceManager;
    procedure Initialize;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses WinSvc, FMX.MultiResBitmap;

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

procedure TForm1.FormShow(Sender: TObject);
begin
  Initialize;
end;

procedure TForm1.Initialize;
begin
  if FInitialized then
    Exit;
  FInitialized := True;

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
