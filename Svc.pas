unit Svc;

interface

uses
  Winapi.Windows;

type
  IWindowsService = interface
    ['{13DCA152-4CB0-4A3D-A773-54EA64922FEF}']
    function Start: Boolean;
    function Stop: Boolean;
    function GetStatus: DWORD;
    property Status: DWORD read GetStatus;
  end;

  IWindowsServiceManager = interface
    ['{37ED310C-ECCA-4637-BC4D-705D983D2678}']
    function GetService(const AName: string): IWindowsService;
  end;

function NewWindowsServiceManager(const AMachineName: string): IWindowsServiceManager;

implementation

{ Thanks to Andrea Canu for pointing out a problem in this code (fixed now). }

uses
  Winapi.WinSvc;

type
  TWindowsService = class(TInterfacedObject, IWindowsService)
  strict private
    FName: string;
    FMachineName: string;
  public
    constructor Create(const AName, AMachineName: string);
    function Start: Boolean;
    function Stop: Boolean;
    function GetStatus: DWORD;
  end;

  TWindowsServiceManager = class(TInterfacedObject, IWindowsServiceManager)
  strict private
    FMachineName: string;
  public
    constructor Create(const AMachineName: string);
    function GetService(const AName: string): IWindowsService;
  end;

constructor TWindowsService.Create(const AName, AMachineName: string);
begin
  FName := AName;
  FMachineName := AMachineName;
end;

function NewWindowsServiceManager(const AMachineName: string): IWindowsServiceManager;
begin
  Result := TWindowsServiceManager.Create(AMachineName);
end;

constructor TWindowsServiceManager.Create(const AMachineName: string);
begin
  inherited Create;
  FMachineName := AMachineName;
end;

function TWindowsServiceManager.GetService(const AName: string): IWindowsService;
begin
  Result := TWindowsService.Create(AName, FMachineName);
end;

{ sc-----------------------------------------------------------------------
  ServiceStart

  sMachine:
  machine name, ie: \\SERVER
  empty = local machine

  return TRUE if successful
  -----------------------------------------------------------------------sc }
function TWindowsService.Start: Boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  psTemp: PChar;
  dwChkP: DWORD;
begin
  ss.dwCurrentState := 1; // originally -1, corrected by Henk Mulder
  schm := OpenSCManager(PChar(FMachineName), nil, SC_MANAGER_CONNECT);
  if schm > 0 then
  begin
    schs := OpenService(schm, PChar(FName), SERVICE_START or SERVICE_QUERY_STATUS);
    if schs > 0 then
    begin
      psTemp := nil;
      if StartService(schs, 0, psTemp) then
        if QueryServiceStatus(schs, ss) then
//          while ss.dwCurrentState <> SERVICE_RUNNING do
//          begin
//            dwChkP := ss.dwCheckPoint;
//            Sleep(ss.dwWaitHint);
//            if not QueryServiceStatus(schs, ss) then
//              Break;
//            if ss.dwCheckPoint < dwChkP then
//              Break;
//          end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := ss.dwCurrentState = SERVICE_RUNNING;
end;

function TWindowsService.Stop: Boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwChkP: DWORD;
begin
  schm := OpenSCManager(PChar(FMachineName), nil, SC_MANAGER_CONNECT);
  if schm > 0 then
  begin
    schs := OpenService(schm, PChar(FName), SERVICE_STOP or SERVICE_QUERY_STATUS);
    if schs > 0 then
    begin
      if ControlService(schs, SERVICE_CONTROL_STOP, ss) then
        if QueryServiceStatus(schs, ss) then
//          while ss.dwCurrentState <> SERVICE_STOPPED do
//          begin
//            dwChkP := ss.dwCheckPoint;
//            Sleep(ss.dwWaitHint);
//            if not QueryServiceStatus(schs, ss) then
//              Break;
//            if ss.dwCheckPoint < dwChkP then
//              Break;
//          end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := ss.dwCurrentState = SERVICE_STOPPED;
end;

function TWindowsService.GetStatus: DWORD;
{ ****************************************** }
{ *** Parameters: *** }
{ *** sService: specifies the name of the service to open
  {*** sMachine: specifies the name of the target computer
  {*** *** }
{ *** Return Values: *** }
{ *** -1 = Error opening service *** }
{ *** 1 = SERVICE_STOPPED *** }
{ *** 2 = SERVICE_START_PENDING *** }
{ *** 3 = SERVICE_STOP_PENDING *** }
{ *** 4 = SERVICE_RUNNING *** }
{ *** 5 = SERVICE_CONTINUE_PENDING *** }
{ *** 6 = SERVICE_PAUSE_PENDING *** }
{ *** 7 = SERVICE_PAUSED *** }
{ ****************************************** }
var
  SCManHandle, SvcHandle: SC_Handle;
  ss: TServiceStatus;
  dwStat: DWORD;
begin
  dwStat := 0;
  // Open service manager handle.
  SCManHandle := OpenSCManager(PChar(FMachineName), nil, SC_MANAGER_CONNECT);
  if SCManHandle > 0 then
  begin
    SvcHandle := OpenService(SCManHandle, PChar(FName), SERVICE_QUERY_STATUS);
    // if Service installed
    if SvcHandle > 0 then
    begin
      // SS structure holds the service status (TServiceStatus);
      if QueryServiceStatus(SvcHandle, ss) then
        dwStat := ss.dwCurrentState;
      CloseServiceHandle(SvcHandle);
    end;
    CloseServiceHandle(SCManHandle);
  end;
  Result := dwStat;
end;

// function ServiceRunning(sMachine, sService: PChar): Boolean;
// begin
// Result := ServiceGetStatus(sMachine, sService) =SERVICE_RUNNING ;
// end;

/// / Check if Eventlog Service is running
// procedure TForm1.Button1Click(Sender: TObject);
// begin
// if ServiceRunning(nil, 'Eventlog') then
// ShowMessage('Eventlog Service Running')
// else
// ShowMessage('Eventlog Service not Running')
// end;

end.
