{�ڱ�������  }
unit uDelphiStart;

interface

uses
  gdipapi, gdipobj, Vcl.ExtCtrls, system.Types, Vcl.Graphics, Vcl.Controls,
  system.Classes;

type
  TStarStatus = record
    StarPoint: TPoint; //��������
    StarStatus: Boolean; //����״̬

  end;

type
  TDStar = class(TImage)
  private
    FStarCount: Integer; //���Ǹ���
    FStarR: Cardinal; //���� �뾶
    FFillColor: Cardinal; //�����ɫ
    FSideColor: Cardinal; //����ɫ
    FStarStatus: array of TStarStatus; //��������״̬
    FMousePoint: TPoint; //��굥������
    FCurseq, FSeqCount: Integer;  //��껬�� ��ǰ����  ������

    //˫��ȫѡ
    procedure StarOnDbClick(Sender: TObject);
    //����
    procedure StarOnClick(Sender: TObject);
    //���
    procedure StarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    //����ƶ�
    procedure StarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    //��ȡѡ��������
    function GetStar: Integer;
    //�޸�����
    procedure UpdateStar(vSeq: Integer);
    //��ѯ������ĸ�������
    function GetStarSeq(): Integer;
  public

    constructor create(AOwner: TWinControl); overload;
    destructor destroy();
    //��ʼ��������
    procedure DrawStart(vfill: boolean = false);

  published
    property StarR: Cardinal read FStarR write FStarR;
    property StarCount: Integer read FStarCount write FStarCount;
    property FillColor: Cardinal read FFillColor write FFillColor;
    property SideColor: Cardinal read FSideColor write FSideColor;
    property Star: Integer read GetStar ;
  end;

implementation

{ TDStar }

constructor TDStar.create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  if AOwner = nil then
    Exit;
  Transparent := True;
  FStarR := 10;
  FStarCount := 1;
  FFillColor := aclLime;
  FSideColor := aclLime;

  Self.Width := FStarR * 2 * FStarCount + 10;
  Self.Height := FStarR * 2;
  Self.Parent := AOwner;
  Self.Top := 10;
  Self.Left := 10;
//  Self.OnDblClick := StarOnDbClick;
  Self.OnMouseDown := StarMouseDown;
  Self.OnClick := StarOnClick;
  Self.OnMouseMove := StarMouseMove;

end;

destructor TDStar.destroy;
begin
  SetLength(FStarStatus,0);
end;

procedure TDStar.DrawStart(vfill: boolean = false);
const
  colors: array[0..0] of TGPColor = (clWhite);
var
  g: TGPGraphics;
  p: TGPPen;
  path: TGPGraphicsPath;
  pb: TGPPathGradientBrush;
  pts: array[0..9] of TGPPoint;
  radian: Single;
  i, j, num: Integer;
  rx: Single;
  pt: TPoint;
  r: Cardinal;
  lcl: Cardinal;
begin
  if FStarR <= 5 then
    Exit;
  if FStarCount <= 0 then
    Exit;
  r := FStarR;
  Self.Width := FStarR * 2 * FStarCount + 10;
  Self.Height := FStarR * 2;

  //��ձ�������

  FillChar(FStarStatus, SizeOf(FStarStatus), 0);
  SetLength(FStarStatus, FStarCount);

  //���ͼ��
  Canvas.FillRect(Canvas.ClipRect);

  pt.X := 0;
  pt.Y := 0;

  for j := 0 to FStarCount - 1 do
  begin
    if j = 0 then
      pt.X := r
    else
      pt.X := pt.X + r + 10;
    pt.Y := r;
    //��������
    FStarStatus[j].StarPoint.X := pt.X;
    FStarStatus[j].StarPoint.Y := pt.Y;

    for i := 0 to 9 do
    begin
      rx := r;
      if Odd(i) then
        rx := r * (1 - (Sqrt(5) - 1) / 2); {(Sqrt(5)-1)/2 �ǻƽ�ָ��, ԼΪ 0.618}
      radian := i * (360 / 10) * (Pi / 180);
      pts[i].X := pt.X + Round(Sin(radian) * rx);
      pts[i].Y := pt.Y - Round(Cos(radian) * rx);
    end;

    g := TGPGraphics.Create(Canvas.Handle);
    path := TGPGraphicsPath.Create;
    path.AddPolygon(PGPPoint(@pts), Length(pts));
    pb := TGPPathGradientBrush.Create(path);

    num := Length(colors);
    pb.SetSurroundColors(@colors, num);

    pb.SetCenterColor(FFillColor);   //�����ɫ

  {�����}
    p := TGPPen.Create(FSideColor);  //����ɫ
    //�����
    g.SetSmoothingMode(SmoothingModeAntiAlias);
    g.DrawPath(p, path);

    if vfill then
    begin
      for i := 0 to 10 do
        g.FillPath(pb, path);
    end;

    pb.Free;
    path.Free;
    p.Free;
    g.Free;

  end;

end;

function TDStar.GetStar: Integer;
var
  i: Integer;
begin
  Result := 0;
  for I := Low(FStarStatus) to High(FStarStatus) do
  begin
    if FStarStatus[i].StarStatus then  inc(result);

  end;
end;

function TDStar.GetStarSeq: Integer;
var
  i: Integer;
  p: TPoint;
begin
  Result := -1;
  for i := Low(FStarStatus) to High(FStarStatus) do
  begin
    p := FStarStatus[i].StarPoint;

    if (FMousePoint.X <= p.X + FStarR) and (FMousePoint.y <= p.y + FStarR) then
    begin
      Result := i;
      Break;
    end;

  end;

end;

procedure TDStar.StarOnClick(Sender: TObject);
var
  lseq: Integer;
begin
  lseq := GetStarSeq;
  UpdateStar(lseq);
end;

procedure TDStar.StarOnDbClick(Sender: TObject);
begin
  DrawStart(true);

end;

procedure TDStar.UpdateStar(vSeq: Integer);
const
  colors: array[0..0] of TGPColor = (clWhite);
var
  g: TGPGraphics;
  p: TGPPen;
  path: TGPGraphicsPath;
  pb: TGPPathGradientBrush;
  pts: array[0..9] of TGPPoint;
  radian: Single;
  i, j, num: Integer;
  rx: Single;
  pt: TPoint;
  r: Cardinal;
  lcl: Cardinal;
  lrect: TRect;
begin
  if FStarR <= 5 then
    Exit;
  if FStarCount <= 0 then
    Exit;
  if vSeq < 0 then
    Exit;
  if vSeq > Length(FStarStatus) then
    Exit;

  r := FStarR;

  //���

  Canvas.FillRect(Canvas.ClipRect);

  for j := 0 to FStarCount - 1 do
  begin
    if j = vSeq then
      FStarStatus[j].StarStatus := not FStarStatus[j].StarStatus;

    pt.X := FStarStatus[j].StarPoint.X;
    pt.Y := FStarStatus[j].StarPoint.y;

    for i := 0 to 9 do
    begin
      rx := r;
      if Odd(i) then
        rx := r * (1 - (Sqrt(5) - 1) / 2); {(Sqrt(5)-1)/2 �ǻƽ�ָ��, ԼΪ 0.618}
      radian := i * (360 / 10) * (Pi / 180);
      pts[i].X := pt.X + Round(Sin(radian) * rx);
      pts[i].Y := pt.Y - Round(Cos(radian) * rx);
    end;

    g := TGPGraphics.Create(Canvas.Handle);
    path := TGPGraphicsPath.Create;
    path.AddPolygon(PGPPoint(@pts), Length(pts));
    pb := TGPPathGradientBrush.Create(path);

    num := Length(colors);
    pb.SetSurroundColors(@colors, num);

    pb.SetCenterColor(FFillColor);   //�����ɫ

    {�����}
    p := TGPPen.Create(FSideColor);  //����ɫ
      //�����
    g.SetSmoothingMode(SmoothingModeAntiAlias);
    g.DrawPath(p, path);

    if FStarStatus[j].StarStatus then
    begin
      for i := 0 to 10 do
        g.FillPath(pb, path);
    end;

    pb.Free;
    path.Free;
    p.Free;
    g.Free;

  end;

end;

procedure TDStar.StarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMousePoint.X := X;
  FMousePoint.Y := Y;

end;

procedure TDStar.StarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  lseq: Integer;
begin
  FMousePoint.X := X;
  FMousePoint.Y := Y;
  lseq := GetStarSeq;

  if lseq = Low(FStarStatus) then  //��һ������
  begin
    if FSeqCount = Low(FStarStatus) then
    begin
      UpdateStar(lseq);
      inc(FSeqCount);
    end;
  end
  else    //��������
  begin
    if lseq = FCurseq then
      Exit;
    FSeqCount := 0;
    UpdateStar(lseq);
    FCurseq := lseq;

  end;

end;

end.

