unit ufileops;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  TAGraph, TASeries, DateUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    ProgressBar1: TProgressBar;
    procedure Sort(var A: array of real);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  txtfile:TextFile;
  pdata:array of real;

implementation

{$R *.lfm}

{ TForm1 }

procedure Tform1.Sort(var A: array of real);
 var
   I, J: Integer;
   htop, min, look:integer;
   temp:real;
 begin
   htop:=High(A);
   ProgressBar1.Min:=Low(A);
   ProgressBar1.Max:=High(A);
   for i:=0 to hTop do
   begin
     ProgressBar1.Position:=i;
     min:=i;
     for look:=i+1 to htop do if A[look]>A[min] then min:=look;
     temp:=A[min]; A[min]:=A[i];
     A[i]:=temp;
   end;
 end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Lines.SaveToFile('test1.txt');
end;

procedure TForm1.Button2Click(Sender: TObject);
var txt:string;
begin
  txt:=Memo1.Text;
  AssignFile(txtfile,'test2.txt');

  Rewrite(txtfile);

  Write(txtfile, txt);

  CloseFile(txtfile);
end;

procedure TForm1.Button3Click(Sender: TObject);
var i,l:integer;
    start,finish:TDateTime;
    dt:integer;
    dataset:string;
begin
  l:=100000;

  ProgressBar1.Min:=0;
  ProgressBar1.Max:=l-1;

  SetLength(pdata,l);
  for i:=0 to l-1 do
  pdata[i]:=random(1000)+random(1000)/1000;


  //memo write
  start:=Now;

  Memo1.Clear;

  for i:=0 to l-1 do
  begin
  Memo1.Lines.Add(floattostr(pdata[i]));
  ProgressBar1.Position:=i;
  end;

  Memo1.Lines.SaveToFile('data1.txt');

  finish:=Now;
  dt:=MilliSecondsBetween(finish,start);
  Label4.Caption:=inttostr(dt);

  //memo direct
  start:=Now;

  Memo1.Clear; dataset:='';

  for i:=0 to l-1 do
  begin
  dataset:=dataset+floattostr(pdata[i])+sLineBreak;
  ProgressBar1.Position:=i;
  end;

  Memo1.Text:=dataset;

  Memo1.Lines.SaveToFile('data2.txt');

  finish:=Now;
  dt:=MilliSecondsBetween(finish,start);
  Label5.Caption:=inttostr(dt);

  //file direct
  start:=Now;

  AssignFile(txtfile,'data3.txt');

  Rewrite(txtfile);

  for i:=0 to l-1 do
  begin
    Writeln(txtfile, FloatToStr(pdata[i]));
    ProgressBar1.Position:=i;
  end;

  CloseFile(txtfile);

  finish:=Now;
  dt:=MilliSecondsBetween(finish,start);
  Label6.Caption:=inttostr(dt);

end;

procedure TForm1.Button4Click(Sender: TObject);
var dataset,dataline,fn:string;
    dataarr:array of real;
    i:integer;
begin
   SetLength(dataarr,0);
   fn:=Edit1.Text;
   AssignFile(txtfile,fn);
   Reset(txtfile);
   while not eof(txtfile) do
   begin
     ReadLn(txtfile,dataline);
     SetLength(dataarr,Length(dataarr)+1);
     dataarr[High(dataarr)]:=strtofloat(dataline);
   end;
   CloseFile(txtfile);

   Sort(dataarr);

   Memo2.Clear;
   dataset:='';
   for i:=0 to High(dataarr) do
   begin
     dataset:=dataset+floattostr(dataarr[i])+sLineBreak;
   end;

   Chart1LineSeries1.AddArray(dataarr);

   Memo2.Text:=dataset;
end;

end.

