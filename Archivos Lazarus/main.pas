unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, LazSerial, TAGraph, TAIntervalSources, TASeries, Math,
  fphttpclient, opensslsockets, fpjson;

type

  { TMyApp }

  TMyApp = class(TForm)
    Chart1: TChart;
    Bar1: TBarSeries;
    StatusBar1: TStatusBar;
    Te: TLabel;
    Hr: TLabel;
    Serie1: TLineSeries;
    Serie2: TLineSeries;
    Serie3: TLineSeries;
    Chart2: TChart;
    Histo: TLabel;
    MySerial: TLazSerial;
    CHB1: TCheckBox;
    CHB2: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    Image5: TImage;
    DataAmb: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RB1: TRadioButton;
    RB2: TRadioButton;
    RB3: TRadioButton;
    Timer1: TTimer;
    procedure Chart1BeforeDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect; var ADoDefaultDrawing: Boolean);
    procedure Chart2BeforeDrawBackWall(ASender: TChart; ACanvas: TCanvas;
      const ARect: TRect; var ADoDefaultDrawing: Boolean);
    procedure CHB1Change(Sender: TObject);
    procedure CHB2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MySerialRxData(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RB1Change(Sender: TObject);
    procedure RB2Change(Sender: TObject);
    procedure RB3Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    img1 : TPicture;
    img2 : TPicture;
  public
    procedure SendData(jsonData: Array of Integer);
    procedure ClearData;
  end;

var
  MyApp : TMyApp;
  MP01 : Array[0..11] of Integer;
  MP25 : Array[0..11] of Integer;
  MP10 : Array[0..11] of Integer;
  Histogram: Array[0..5] of Integer;
  aClr  : Array[0..5] of TColor;
  id   : Byte;
  FlaskMode: Boolean;


implementation

{$R *.lfm}

{ TMyApp }

procedure TMyApp.FormCreate(Sender: TObject);
Var
  nPos : Byte;
begin
  //LazSerial Off, Checkbox1 y 2 Off
  MySerial.close;
  CHB1.Checked:=False;
  CHB2.Checked:=False;

  // Inicializamos un array de colores a utilizar
  aClr[0] := clRed ; aClr[1] := clGreen; aClr[2] := clBlue;
  aClr[3] := clYellow; aClr[4] := clLime; aClr[5] := clSkyBlue;

  // Inicializamos y marcamos dos RadioButtons
  RB1.Checked := True;
  RadioButton1.Checked := True;
  id := 1;
  FlaskMode := False;
  Serie1.Marks.Visible := True;
  Serie2.Marks.Visible := False;
  Serie3.Marks.Visible := False;

   // Creamos dos objetos TPicture con imágenes
  img1 := TPicture.Create;
  img1.LoadFromFile('bkg1.png');
  img2 := TPicture.Create;
  img2.LoadFromFile('bkg2.png');

  //Randomize; // generación de números aleatorios

  // Inicializamos arreglos y agregamos puntos a las series de gráficos
  For nPos := 0 To 11 Do
   Begin
     MP01[nPos] := 0; // Iniciamos con 0
     MP25[nPos] := 0;
     MP10[nPos] := 0;
     Serie1.AddXY(nPos, MP01[nPos]);
     Serie2.AddXY(nPos, MP25[nPos]);
     Serie3.AddXY(nPos, MP10[nPos]);
   end;

  // Inicializamos un arreglo y agregamos barras a la serie de gráfico de barras
  For nPos := 0 To 5 Do
   Begin
     Histogram[nPos] := 0;
     Bar1.AddXY(nPos, Histogram[nPos], '', aClr[nPos]);
   end;
end;
procedure TMyApp.SendData(jsonData: Array of Integer);
Var
  Data : TJSONObject;
  Response : String;
Begin
  Data := TJSONObject.Create();
  Data.Add('id', jsonData[0]);
  Data.Add('mp01', jsonData[1]);
  Data.Add('mp02', jsonData[2]);
  Data.Add('mp03', jsonData[3]);
  Data.Add('hi01', jsonData[4]);
  Data.Add('hi02', jsonData[5]);
  Data.Add('hi03', jsonData[6]);
  Data.Add('hi04', jsonData[7]);
  Data.Add('hi05', jsonData[8]);
  Data.Add('hi06', jsonData[9]);
  Data.Add('te', jsonData[10]);
  Data.Add('hr', jsonData[11]);
  with TFPHttpClient.Create(Nil) do
   Try
     AddHeader('Content-type','application/json');
     RequestBody := TStringStream.Create(Data.AsJSON);
     Response := Post('http://127.0.0.1:7070/data');
   finally
     Free;
   end;
end;
procedure TMyApp.ClearData;
Var
  nPos : Integer;
Begin
  for nPos := 0 to 11 do
   Begin
     MP01[nPos] := 0;
     MP25[nPos] := 0;
     MP10[nPos] := 0;
     Serie1.AddXY(nPos, MP01[nPos]);
     Serie2.AddXY(nPos, MP25[nPos]);
     Serie3.AddXY(nPos, MP10[nPos]);
   end;
  for nPos := 0 to 5 do
   Begin
     Histogram[nPos] := 0;
     Bar1.AddXY(nPos,Histogram[nPos],'',aClr[nPos]);
   end;
end;

procedure TMyApp.Chart1BeforeDrawBackWall(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect; var ADoDefaultDrawing: Boolean);
begin
  ACanvas.StretchDraw(ARect, img1.Graphic);
  ADoDefaultDrawing := false;
end;

procedure TMyApp.Chart2BeforeDrawBackWall(ASender: TChart; ACanvas: TCanvas;
  const ARect: TRect; var ADoDefaultDrawing: Boolean);
begin
  ACanvas.StretchDraw(ARect, img2.Graphic);
  ADoDefaultDrawing := false;
end;

procedure TMyApp.CHB1Change(Sender: TObject);
begin
  MySerial.Active := CHB1.Checked;
end;

procedure TMyApp.CHB2Change(Sender: TObject);
begin
  FlaskMode := CHB2.Checked;
end;

procedure TMyApp.FormDestroy(Sender: TObject);
begin
  img1.Free;
  img2.Free;
  MySerial.Close;
end;

procedure TMyApp.MySerialRxData(Sender: TObject);
Var
  data : Array[0..11] of Integer;
  sLine : String;
  sPaq: String;
  i: Byte;
  nPos: Byte;
begin
  // Leemos datos desde MySerial
  sLine := MySerial.ReadData;
  sPaq := sLine;

  // Formato String a Integer
  for i := 0 to 10 do
   Begin
    // Find posicion ','
    nPos := Pos(',', sLine);
    // Extraemos el dato antes de la coma y se convierte a Int
    data[i] := StrToInt(Copy(sLine,1,nPos-1));
    Delete(sLine,1,nPos);
  end;
  data[11] := StrToInt(sLine);

  // Verificamos si el primer dato coincide con 'id'
  if data[0] = id then
     begin
       // Enviamos datos si CHB2 esta marcado
       if CHB2.Checked then SendData(data);
       StatusBar1.Panels[1].Text := 'Data : ' + sPaq;

       // Grafica Tempe y Humedad
       Te.Caption := IntToStr(data[10]);
       Hr.Caption := IntToStr(data[11]);
       Serie1.Clear;
       Serie2.Clear;
       Serie3.Clear;
       Bar1.Clear;

       // Actualizamos gráfico de barras con datos del array
       for nPos := 0 to 5 do
        Begin
         Histogram[nPos] := data[nPos + 4];
         Bar1.AddXY(nPos,Histogram[nPos],'',aClr[nPos]);
        end;

       // Actualizamos series de gráficos con datos anteriores
       MP01[10] := data[1];
       MP25[10] := data[2];
       MP10[10] := data[3];
       for nPos := 0 to 10 do
        Begin
         Serie1.AddXY(nPos, MP01[nPos]);
         Serie2.AddXY(nPos, MP25[nPos]);
         Serie3.AddXY(nPos, MP10[nPos]);
         // Se mantiene historial de valores anteriores
         MP01[nPos] := MP01[nPos + 1];
         MP25[nPos] := MP25[nPos + 1];
         MP10[nPos] := MP10[nPos + 1];
        end;
       end;
end;

procedure TMyApp.RadioButton1Change(Sender: TObject);
begin
  id := 1;
  Serie1.Clear; Serie2.Clear; Serie3.Clear; Bar1.Clear;
  ClearData;
end;

procedure TMyApp.RadioButton2Change(Sender: TObject);
begin
  id := 2;
  Serie1.Clear; Serie2.Clear; Serie3.Clear; Bar1.Clear;
  ClearData;
end;

procedure TMyApp.RadioButton3Change(Sender: TObject);
begin
  id := 3;
  Serie1.Clear; Serie2.Clear; Serie3.Clear; Bar1.Clear;
  ClearData;
end;

procedure TMyApp.RadioButton4Change(Sender: TObject);
begin
  id := 4;
  Serie1.Clear; Serie2.Clear; Serie3.Clear; Bar1.Clear;
  ClearData;
end;

procedure TMyApp.RadioButton5Change(Sender: TObject);
begin
  id := 5;
  Serie1.Clear; Serie2.Clear; Serie3.Clear; Bar1.Clear;
  ClearData;
end;

procedure TMyApp.RB1Change(Sender: TObject);
begin
   Serie1.Marks.Visible := True;
   Serie2.Marks.Visible := False;
   Serie3.Marks.Visible := False;
end;

procedure TMyApp.RB2Change(Sender: TObject);
begin
   Serie1.Marks.Visible := False;
   Serie2.Marks.Visible := True;
   Serie3.Marks.Visible := False;
end;

procedure TMyApp.RB3Change(Sender: TObject);
begin
   Serie1.Marks.Visible := False;
   Serie2.Marks.Visible := False;
   Serie3.Marks.Visible := True;
end;

procedure TMyApp.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Fecha : ' + FormatDateTime('dd-mm-yyyy', Now) +
    ' - Hora : ' + FormatDateTime('hh:nn:ss', Now);
end;

end.

