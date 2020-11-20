unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,uDelphiStart;

type
  TForm4 = class(TForm)
    pnl1: TPanel;
    btn1: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  star: TDStar;

implementation

{$R *.dfm}

procedure TForm4.btn1Click(Sender: TObject);
begin
  if star = nil then star := TDStar.create(pnl1);

  star.StarR := 10;
  star.StarCount := 6;
  star.FillColor := $FF9ACD32;
  star.SideColor := $FF9ACD32;
  star.DrawStart();

  
end;

procedure TForm4.btn2Click(Sender: TObject);
begin
  if star = nil then Exit;
  ShowMessage(star.Star.ToString());
end;

end.
