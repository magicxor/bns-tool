/// <summary>
///   Tool for paste text from clipboard into Blade &amp; Soul® MMORPG window <br />
/// </summary>
/// <remarks>
///   This software is released under the GPLv3 license. See LICENSE.md.
///   Author: mailparser@mail.ru
/// </remarks>
program BnS_tool;

uses
  Vcl.Forms,
  uGlobalHotKeys in 'uGlobalHotKeys.pas',
  uMain in 'uMain.pas' {FormMain},
  uFindWnd in 'uFindWnd.pas',
  uIniManager in 'uIniManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
