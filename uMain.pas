/// <summary>
/// Main application form
/// </summary>
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

uses uGlobalHotKeys;

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
  // Remove all hotkeys from the system
  UnRegAllGlobalHotKeys;
  // Save settings
  IniSettings.HotKeysPaste := HotKeyPaste.HotKey;
  IniSettings.HotKeysMultilinePaste := HotKeyMultilinePaste.HotKey;
  IniSettings.SaveToFile(ExtractFilePath(Application.ExeName) + CSettingsIniShortFileName);
  // Register and remember all hotkeys
  RegAllGlobalHotKeys;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnRegAllGlobalHotKeys;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // Load settings (hotkeys)
  IniSettings.LoadFromFile(ExtractFilePath(Application.ExeName) + CSettingsIniShortFileName);
  HotKeyPaste.HotKey := IniSettings.HotKeysPaste;
  HotKeyMultilinePaste.HotKey := IniSettings.HotKeysMultilinePaste;
  // Register all hotkeys
  RegAllGlobalHotKeys;
end;

procedure TFormMain.WMHotKey(var CurWMHotKey: TWMHotKey);
// Hotkeys processing
begin
  if CurWMHotKey.HotKey = HotKeyPasteAtomCode then
    FindWndAndPaste(false);
  if CurWMHotKey.HotKey = HotKeyMultilinePasteAtomCode then
    FindWndAndPaste(true);
end;

procedure TFormMain.FindWndAndPaste(Multiline: boolean);
var
  hl: HWND;
  clipboardStrings: TArray<System.string>;
  oneStr, previousStr, separatorString: string;
  oneChr: Char;
  separatorArr: array of Char;
begin
  // or Window Text = "PlayBNS.COM :: Blade&Soul"
  hl := FindWindow('LaunchUnrealUWindowsClient', nil);
  if hl > 0 then
  begin
    separatorString := sLineBreak;
    separatorArr := [];
    for oneChr in separatorString do
      separatorArr := separatorArr + [oneChr];

    clipboardStrings := Clipboard.AsText.Split(separatorArr);

    previousStr := '';
    for oneStr in clipboardStrings do
    begin
      if (not(oneStr.Trim = '') and not(oneStr = previousStr) and Multiline) or not(Multiline) then
      begin
        if Multiline then
        // activate chat window
        begin
          PostMessage(hl, WM_KEYDOWN, VK_RETURN, 0);
          Sleep(200);
        end;
        // write a message
        for oneChr in oneStr do
        begin
          Sleep(RandomRange(20, 50));
          PostMessage(hl, WM_CHAR, Ord(oneChr), 0);
        end;
        // send it (or add space character)
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
    ShowMessage('The game window is not found');
end;

end.
