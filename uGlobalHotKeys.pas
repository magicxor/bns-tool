unit uGlobalHotKeys;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ExtCtrls, TlHelp32, mmsystem,
  Menus, Spin;

function RegisterGlobalHotKey(HotKeyFromTHotkey: TShortCut; GlobalAtomName: string;
  AppWindowHandle: HWND): Word;
procedure RemoveGlobalHotKey(HkID: Word; AppWindowHandle: HWND);

implementation

// ========================================================
// Регистрация глобальных горячих клавиш на основе полученного значения THotKey:
// ========================================================
function RegisterGlobalHotKey(HotKeyFromTHotkey: TShortCut; GlobalAtomName: string;
  AppWindowHandle: HWND): Word;
// ========================================================
// Преобразование THotKey-кода клавиши в код для регистрации в системе:
// ========================================================
  procedure ShortCutToHotKey(HotKey: TShortCut; var Key: Word; var Modifiers: Uint);
  // Из ID'а компонента THotKey в WinAPI-ID клавиши
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
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var
  Key: Word;
  Modifiers: Uint;
begin
  ShortCutToHotKey(HotKeyFromTHotkey, Key, Modifiers);
  Result := GlobalAddAtom(PChar(GlobalAtomName)); // "атомный" временный HK_ID
  RegisterHotKey(AppWindowHandle, Result, Modifiers, Key);
end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ========================================================
// Удаление глобальных горячих клавиш:
// ========================================================
procedure RemoveGlobalHotKey(HkID: Word; AppWindowHandle: HWND);
begin
  GlobalDeleteAtom(HkID);
  UnRegisterHotKey(AppWindowHandle, HkID);
end;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

end.
