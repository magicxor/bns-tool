unit uIniManager;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  csIniHotKeysSection = 'HotKeys';

  {Section: HotKeys}
  csIniHotKeysPaste = 'Paste';
  csIniHotKeysMultilinePaste = 'MultilinePaste';

type
  TIniManager = class(TObject)
  private
    {Section: HotKeys}
    FHotKeysPaste: Integer;
    FHotKeysMultilinePaste: Integer;
  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    {Section: HotKeys}
    property HotKeysPaste: Integer read FHotKeysPaste write FHotKeysPaste;
    property HotKeysMultilinePaste: Integer read FHotKeysMultilinePaste write FHotKeysMultilinePaste;
  end;

var
  IniSettings: TIniManager = nil;

implementation

procedure TIniManager.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: HotKeys}
    FHotKeysPaste := Ini.ReadInteger(csIniHotKeysSection, csIniHotKeysPaste, 16470 {ctrl + V});
    FHotKeysMultilinePaste := Ini.ReadInteger(csIniHotKeysSection, csIniHotKeysMultilinePaste, 220 {\});
  end;
end;

procedure TIniManager.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: HotKeys}
    Ini.WriteInteger(csIniHotKeysSection, csIniHotKeysPaste, FHotKeysPaste);
    Ini.WriteInteger(csIniHotKeysSection, csIniHotKeysMultilinePaste, FHotKeysMultilinePaste);
  end;
end;

procedure TIniManager.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    LoadSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TIniManager.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

initialization
  IniSettings := TIniManager.Create;

finalization
  IniSettings.Free;

end.

