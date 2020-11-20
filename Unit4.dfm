object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 224
    Top = 32
    Width = 345
    Height = 121
    Caption = 'pnl1'
    TabOrder = 0
  end
  object btn1: TButton
    Left = 120
    Top = 48
    Width = 75
    Height = 25
    Caption = 'create'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 120
    Top = 96
    Width = 75
    Height = 25
    Caption = 'ShowStar'
    TabOrder = 2
    OnClick = btn2Click
  end
end
