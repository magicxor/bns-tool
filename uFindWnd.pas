/// <summary>
/// Window finding routines
/// </summary>
unit uFindWnd;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ExtCtrls, uIniManager;

type
  /// <summary>
  /// Array of window handle
  /// </summary>
  HWNDArr = array of HWND;

  /// <summary>
  /// Find window handle by window class name
  /// </summary>
  /// <param name="WndClass">
  /// Window class name
  /// </param>
function FindHWDNsByWndClass(WndClass: string): HWNDArr;

implementation

function FindHWDNsByWndClass(WndClass: string): HWNDArr;
var
  wd: HWND;
  ClassName: array [0 .. 255] of Char;
  WndVisible, WndDisabled: Longint;
begin
  ClassName := '';
  Result := [];
  wd := FindWindow(nil, nil); // Top level window of any class
  while (wd <> 0) do
  begin
    GetClassName(wd, ClassName, 255);
    WndVisible := (GetWindowLong(wd, GWL_STYLE) and Longint(WS_VISIBLE));
    WndDisabled := (GetWindowLong(wd, GWL_STYLE) and Longint(WS_DISABLED));
    if (UpperCase(ClassName) = UpperCase(WndClass)) and (WndVisible > 0) and (WndDisabled = 0) then
    begin
      // GetWindowThreadProcessId(wd, @PID); // If we want to go deeper...
      Result := Result + [wd];
    end;
    Application.ProcessMessages;
    wd := GetNextWindow(wd, GW_HWNDNEXT); // Finding of a next window
  end;
end;

end.
