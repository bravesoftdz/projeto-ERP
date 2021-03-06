unit uBanco;

interface

uses Forms, DBClient, SysUtils, SqlExpr, DB, Provider, DBCtrls, IniFiles;

procedure conexaoDB(var conect: TSQLConnection; arqIni: TIniFile);
function TabelaVazia(cds: TClientDataSet): boolean;
procedure Ctrl_DataSet(cds: TClientDataSet; estado: boolean);
procedure criarSQL(var cds: TClientDataSet; tabela: string; field1: string;
  param1: string; abrir: boolean);
procedure destruirSQL(var cds: TClientDataSet);

procedure configDB(var cds: TClientDataSet);

var
  dsp: TDataSetProvider;
  qry: TSQLQuery;
  connect: TSQLConnection;

implementation

procedure configDB(var cds: TClientDataSet);
var
  Provider: string;
begin
  Randomize;
  Provider := FormatFloat('000', Random(999));

  // Instanciar os componentes
  qry := TSQLQuery.Create(Application);
  cds := TClientDataSet.Create(Application);
  dsp := TDataSetProvider.Create(Application);

  // Ligacao entre componentes
  qry.SQLConnection := connect;
  dsp.DataSet := qry;
  dsp.Name := 'prov' + Provider;
  cds.ProviderName := dsp.Name;

end;

procedure conexaoDB(var conect: TSQLConnection; arqIni: TIniFile);
begin
  conect.Params.Values['DATABASE'] := arqIni.ReadString('CONNECTION',
    'DATABASE', '');
end;

function TabelaVazia(cds: TClientDataSet): boolean;
begin
  if cds.IsEmpty then
    result := True
  else
    result := False;
end;

procedure Ctrl_DataSet(cds: TClientDataSet; estado: boolean);
begin
  if (cds <> nil) then
    cds.active := estado;
end;

procedure criarSQL(var cds: TClientDataSet; tabela: string; field1: string;
  param1: string; abrir: boolean);
begin
  configDB(cds);
  if abrir then
  begin
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM ' + tabela);
    qry.SQL.Add('WHERE ' + field1 + ' = :vParam1');
    qry.ParamByName('vParam1').Value := param1;
    Ctrl_DataSet(cds, True);
  end;

end;

procedure destruirSQL(var cds: TClientDataSet);
begin
  Ctrl_DataSet(cds, False);
  qry.Free;
  cds.Free;
  dsp.Free;
end;

end.
