unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  Svc, System.ImageList, FMX.ImgList;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Timer1: TTimer;
    Label1: TLabel;
    ComboBox2: TComboBox;
    SpeedButton1: TSpeedButton;
    ButtonImageList: TImageList;
    SpeedButton2: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    FServiceManager: IWindowsServiceManager;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

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
    Caption := FServiceManager.GetService(ComboBox1.Selected.Text).Status.ToString;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  FServiceManager := NewWindowsServiceManager(ComboBox2.Selected.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ComboBox2Change(Self);
  Timer1.Enabled := True;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if Assigned(FServiceManager) then
    FServiceManager.GetService(ComboBox1.Selected.Text).Start;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if Assigned(FServiceManager) then
    FServiceManager.GetService(ComboBox1.Selected.Text).Stop;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Assigned(FServiceManager) then
    Caption := FServiceManager.GetService(ComboBox1.Selected.Text).Status.ToString;
end;

end.
