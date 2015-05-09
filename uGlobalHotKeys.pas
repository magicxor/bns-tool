/// <summary>
/// Working with global system hotkeys
/// </summary>
unit uGlobalHotKeys;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ExtCtrls, TlHelp32, mmsystem,
  Menus, Spin;

/// <summary>
/// Register global hotkey by code retrieved from TShortCut (THotKey) and window handle
/// </summary>
function RegisterGlobalHotKey(HotKeyFromTHotkey: TShortCut; GlobalAtomName: string;
  AppWindowHandle: HWND): Word;
/// <summary>
/// Remove global hotkey by it's id and window handle
/// </summary>
procedure RemoveGlobalHotKey(HkID: Word; AppWindowHandle: HWND);

implementation

function RegisterGlobalHotKey(HotKeyFromTHotkey: TShortCut; GlobalAtomName: string;
  AppWindowHandle: HWND): Word;
  procedure ShortCutToHotKey(HotKey: TShortCut; var Key: Word; var Modifiers: Uint);
  // THotKey id -> WinApi id
  var
    Shift: TShiftState;
  begin
    ShortCutToKey(HotKey, Key, Shift);
    Modifiers := 0;
    if (ssShift in Shift) then
      Modifiers := Modifiers or MOD_SHIFT;
    if (ssAlt in Shift) then
      Modifiers := Modifiers or MOD_ALT;
    if (ssCtrl in Shift) then
      Modifiers := Modifiers or MOD_CONTROL;
  end;

var
  Key: Word;
  Modifiers: Uint;
begin
  ShortCutToHotKey(HotKeyFromTHotkey, Key, Modifiers);
  Result := GlobalAddAtom(PChar(GlobalAtomName)); // "atomic" HK_ID
  RegisterHotKey(AppWindowHandle, Result, Modifiers, Key);
end;

procedure RemoveGlobalHotKey(HkID: Word; AppWindowHandle: HWND);
begin
  GlobalDeleteAtom(HkID);
  UnRegisterHotKey(AppWindowHandle, HkID);
end;

end.
