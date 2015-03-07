unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ExtCtrls, uIniManager, Clipbrd,
  System.Math;

type
  TFormMain = class(TForm)
    HotKeyPaste: THotKey;
    LabelHotKeyPaste: TLabel;
    ButtonSave: TButton;
    LabelHotKeyMultilinePaste: TLabel;
    HotKeyMultilinePaste: THotKey;
    procedure FormCreate(Sender: TObject);
    procedure ButtonApplyAndSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure WMHotKey(var CurWMHotKey: TWMHotKey); message WM_HOTKEY;
    procedure FindWndAndPaste(Multiline: boolean);
    procedure RegAllGlobalHotKeys;
    procedure UnRegAllGlobalHotKeys;

  var
    HotKeyPasteAtomCode, HotKeyMultilinePasteAtomCode: Word;

  const
    CSettingsIniShortFileName     = 'Settings.ini';
    CHotKeyPasteAtomName          = 'HK_Paste';
    CHotKeyMultilinePasteAtomName = 'HK_MultilinePaste';
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses uGlobalHotKeys, uFindWnd;

procedure TFormMain.RegAllGlobalHotKeys;
begin
  HotKeyPasteAtomCode := RegisterGlobalHotKey(IniSettings.HotKeysPaste, CHotKeyPasteAtomName,
    FormMain.Handle);
  HotKeyMultilinePasteAtomCode := RegisterGlobalHotKey(IniSettings.HotKeysMultilinePaste,
    CHotKeyMultilinePasteAtomName, FormMain.Handle);
end;

procedure TFormMain.UnRegAllGlobalHotKeys;
begin
  RemoveGlobalHotKey(HotKeyPasteAtomCode, FormMain.Handle);
  RemoveGlobalHotKey(HotKeyMultilinePasteAtomCode, FormMain.Handle);
end;

procedure TFormMain.ButtonApplyAndSaveClick(Sender: TObject);
begin
  // Освобождаем хоткеи
  UnRegAllGlobalHotKeys;
  // Сохраняем настройки
  IniSettings.HotKeysPaste := HotKeyPaste.HotKey;
  IniSettings.HotKeysMultilinePaste := HotKeyMultilinePaste.HotKey;
  IniSettings.SaveToFile(ExtractFilePath(Application.ExeName) + CSettingsIniShortFileName);
  // Регистрируем и запоминаем хоткеи
  RegAllGlobalHotKeys;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Освобождаем хоткеи
  UnRegAllGlobalHotKeys;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // Загружаем хоткей
  IniSettings.LoadFromFile(ExtractFilePath(Application.ExeName) + CSettingsIniShortFileName);
  HotKeyPaste.HotKey := IniSettings.HotKeysPaste;
  HotKeyMultilinePaste.HotKey := IniSettings.HotKeysMultilinePaste;
  // Регистрируем и запоминаем хоткеи
  RegAllGlobalHotKeys;
end;

procedure TFormMain.WMHotKey(var CurWMHotKey: TWMHotKey);
// Обработчик глобальных горячих клавиш
begin
  if CurWMHotKey.HotKey = HotKeyPasteAtomCode then
    FindWndAndPaste(false);
  if CurWMHotKey.HotKey = HotKeyMultilinePasteAtomCode then
    FindWndAndPaste(true);
end;

procedure TFormMain.FindWndAndPaste(Multiline: boolean);
var
  hlarr: HWNDArr;
  hl: HWND;
  clipboardStrings: TArray<System.string>;
  oneStr, previousStr, separatorString: string;
  oneChr: Char;
  separatorArr: array of Char;
begin
  // другой признак: Window Text = "PlayBNS.COM :: Blade&Soul"
  hlarr := FindHWDNsByWndClass('LaunchUnrealUWindowsClient');
  if Length(hlarr) > 0 then
  begin
    hl := hlarr[0];
    //
    separatorString := sLineBreak;
    separatorArr := [];
    for oneChr in separatorString do
      separatorArr := separatorArr + [oneChr];
    //
    clipboardStrings := Clipboard.AsText.Split(separatorArr);
    //
    previousStr := '';
    for oneStr in clipboardStrings do
    begin
      if (not(oneStr.Trim = '') and not(oneStr = previousStr) and Multiline) or not(Multiline) then
      begin
        if Multiline then
        // активируем чат
        begin
          PostMessage(hl, WM_KEYDOWN, VK_RETURN, 0);
          Sleep(200);
        end;
        // пишем сообщение
        for oneChr in oneStr do
        begin
          Sleep(RandomRange(20, 50));
          PostMessage(hl, WM_CHAR, Ord(oneChr), 0);
        end;
        // либо отправляем и пишем следующее, либо добавяем пробел
        if Multiline then
        begin
          PostMessage(hl, WM_KEYDOWN, VK_RETURN, 0);
          Sleep(RandomRange(300, 600));
        end
        else
          PostMessage(hl, WM_CHAR, Ord(' '), 0);
        previousStr := oneStr;
      end;
    end;
  end
  else
    ShowMessage('Окно игры не найдено');
end;

end.
