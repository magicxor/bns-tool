unit uFindWnd;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ExtCtrls, uIniManager;

type
  HWNDArr = array of HWND;

function FindHWDNsByWndClass(WndClass: string): HWNDArr;

implementation

// ========================================================
// v2 Получение списка окон:
// ========================================================
function FindHWDNsByWndClass(WndClass: string): HWNDArr;
var
  wd: HWND;
  ClassName: array [0 .. 255] of Char;
  WndVisible, WndDisabled: Longint;
begin
  ClassName := '';
  Result := [];
  wd := FindWindow(nil, nil); // Найдем первое окно верхн. уровня любого класса
  while (wd <> 0) do // Если такое окно существует
  begin
    GetClassName(wd, ClassName, 255);
    WndVisible := (GetWindowLong(wd, GWL_STYLE) and Longint(WS_VISIBLE));
    WndDisabled := (GetWindowLong(wd, GWL_STYLE) and Longint(WS_DISABLED));
    if (UpperCase(ClassName) = UpperCase(WndClass)) and (WndVisible > 0) and (WndDisabled = 0) then
    begin
      // GetWindowThreadProcessId(wd, @PID);
      Result := Result + [wd];
    end;
    Application.ProcessMessages; // Дадим возможность поработать другим
    wd := GetNextWindow(wd, GW_HWNDNEXT); // Найдем следующее окно в системе.
  end;
end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end.
