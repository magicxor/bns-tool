object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'B&S tool 1.1'
  ClientHeight = 93
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelHotKeyPaste: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 97
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Paste:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelHotKeyMultilinePaste: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 38
    Width = 97
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Multiline Paste:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object HotKeyPaste: THotKey
    Left = 111
    Top = 8
    Width = 90
    Height = 19
    AutoSize = False
    HotKey = 16470
    InvalidKeys = [hcAlt, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
    Modifiers = [hkCtrl]
    TabOrder = 1
  end
  object ButtonSave: TButton
    AlignWithMargins = True
    Left = 3
    Top = 65
    Width = 213
    Height = 25
    Align = alBottom
    Caption = 'Apply && Save'
    TabOrder = 0
    OnClick = ButtonApplyAndSaveClick
  end
  object HotKeyMultilinePaste: THotKey
    Left = 111
    Top = 38
    Width = 90
    Height = 19
    AutoSize = False
    HotKey = 121
    InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
    Modifiers = []
    TabOrder = 2
  end
end
