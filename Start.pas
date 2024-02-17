unit Start;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections,Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.DateUtils;

type
  TF_Start = class(TForm)
    Memo_Resultados: TMemo;
    Lbl_Titulo: TLabel;
    Lbl_ComprarEstruturas: TLabel;
    Btn_ListvsArray: TButton;
    Btn_ListvsArrayvsDictionary: TButton;
    Pnl_ListContainsvsListIndexOfvsListBinarySearchvsDictionary: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure Btn_ListvsArrayClick(Sender: TObject);
    procedure Btn_ListvsArrayvsDictionaryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Pnl_ListContainsvsListIndexOfvsListBinarySearchvsDictionaryClick(
      Sender: TObject);
  private
    { Private declarations }
    procedure PreparaListaBase(var ListaBase: TList<Integer>; TamanhoAproximadoLista: Integer);

     procedure PreencheListaDeInteiros
               (var Lista: TList<Integer>; var ListaBase: TList<Integer>;
                ExibirRelatorioInsercoes: Bool);

     procedure PreencheArrayDeInteiros
               (var Array_: array of Integer; var ListaBase: TList<Integer>;
                ExibirRelatorioInsercoes: Bool);

     procedure PreencheDicionarioDeInteiros
               (var DicionarioInteirosAleatorios: TDictionary<Integer, Bool>;
                var ListaBase: TList<Integer>; ExibirRelatorioInsercoes: Bool);

     procedure TesteDesempenhoListaContains
               (var Lista: TList<Integer>; var ListaInteirosAleatoriosBuscar: TList<Integer>);

     procedure TesteDesempenhoArrayContains
               (var Array_: array of Integer; var ListaInteirosAleatoriosBuscar: TList<Integer>);

     procedure TesteDesempenhoIndexOF
               (var Lista: TList<Integer>; var ListaInteirosAleatoriosBuscar: TList<Integer>);

     procedure TesteDesempenhoDicionarioContains
               (var Dicionario: TDictionary<Integer, Bool>;
               var ListaInteirosAleatoriosBuscar: TList<Integer>);

     procedure TesteDesempenhoBinarySearch
               (var Lista: TList<Integer>; var ListaInteirosAleatoriosBuscar: TList<Integer>);

     procedure ExibeRelatorioInsercoes
     (NumeroElementosEstrutura: Integer; Segundos: Integer; Estrutura: String);

     procedure ExibeRelatorioDesempenho
     (NumeroElementosEstrutura: Integer; NumeroDeBuscas: Integer;
     MetodoBusca: String ;Segundos: Integer; Estrutura: String;
     Arigo1: String; Artigo2: String);

     function ArrayContains(const MyArray: array of Integer; ValueToCheck: Integer): Boolean;

  public
    { Public declarations }
  end;

var
  F_Start: TF_Start;

implementation

{$R *.dfm}


{

-> Finalidade do estudo:

O estudo realizado tem por objetivo mensurar de forma clara a efici�ncia de
determinadas estruturas de dados e seus m�todos dispon�veis para verifica��o de
pertencimento de elementos. Os testes de desempenho englobam: velocidade em
preencher as estruturas em quest�o e verifica��es de pertencimento utilizando
os m�todos CONTAINS e BINARY SEARCH.

-> Fluxo que o estudo segue:

Fica ao encargo do usu�rio selecionar qual teste ele deseja realizar.
Testes de desempenho dispon�veis:

List vs Array
List vs Array vs Dictionary
List Contains vs List BinarySearch vs Dicionary

Para cada teste, existem dois testes de desempenho que ser�o realizados
para cada estrutura presente no teste selecionado: teste de desempenho para
inser��es de elementos dentro da estrutura e teste de verifica��es de
pertencimento de determinados valores dentro das estruturas referidas.

Antes do teste escolhido pelo usu�rio ser iniciado de fato, duas estruturas
s�o instanciadas e preenchidas: duas "Listas Base"
Uma delas com os valores que estar�o presentes nas demais estruturas para a
realiza��o dos testes de desempenho de inser��es, e a outra ser� utilizada
para as verifica��es de pertencimento. Gra�as as "Listas Base" todas as
estruturas selecionadas para os testes de desempenho ter�o os mesmos elementos,
o mesmo comprimento, e os mesmos valores ser�o buscados nas estruturas
selecionadas para os testes de pertencimento.

Ap�s preencher as "Listas Base", os testes de desempenho j� referidos s�o
iniciados e seus resultados s�o exibidos no componente TMEMO ap�s a finaliza��o
dos mesmos.

OBS:
As "Listas Base" n�o possuem duplica��es de valores, para n�o impossibilitar o
funcionamento das estruturas implementadas do tipo TDictionary
e n�o impedir o melhor funcionamento do m�todo BINARY SEARCH; al�m de permitir
com que os testes sejam minimamente din�micos.

As descri��es das funcionalidades e inten��es dos m�todos implementados est�o
sob o cabe�alho dos mesmos no contexto de implementa��o.

Documenta��o:
https://docwiki.embarcadero.com/Libraries/Sydney/en/System.Generics.Collections

}


// Exibe no componente 'TMEMO' os resultados do teste de desempenho de INSER��ES
// realizadas na estrutura selecionada
procedure TF_Start.ExibeRelatorioInsercoes(NumeroElementosEstrutura: Integer;
Segundos: Integer; Estrutura: String);
begin
     Memo_Resultados.Lines.Add('');
     Memo_Resultados.Lines.Add('Foram adicionados ' +
        IntToStr(NumeroElementosEstrutura) + ' elementos na ' + Estrutura);
     Memo_Resultados.Lines.Add('Tempo decorrido para realizar as ope��es de inser��o ' +
        IntToStr(Segundos) + ' segundos');
end;

procedure TF_Start.FormShow(Sender: TObject);
begin

end;

// Exibe no componente 'TMEMO' os resultados do teste de desempenho relativo
// as verifica��es de pertencimento realizados na estrutura selecionada
procedure TF_Start.ExibeRelatorioDesempenho
(NumeroElementosEstrutura: Integer; NumeroDeBuscas: Integer;
MetodoBusca: String ;Segundos: Integer; Estrutura: String;
Arigo1: String; Artigo2: String);
begin
     Memo_Resultados.Lines.Add('');
     Memo_Resultados.Lines.Add(Arigo1 + ' ' + Estrutura + ' possui ' +
        IntToStr(NumeroElementosEstrutura) + ' elementos');
     Memo_Resultados.Lines.Add('Foram ' + IntToStr(NumeroDeBuscas) +
        ' verifica��es de pertencimento ' + Artigo2 + ' ' + Estrutura +
        ' utilizando o m�todo ' + MetodoBusca);
     Memo_Resultados.Lines.Add('Tempo decorrido para as verifica��es de pertencimento: ' +
        IntToStr(Segundos) + ' segundos');
end;

// Lista base utilizada para preencher as demais estruturas, seja um Array,
// TList ou Dictionary. Essa Lista base � �nica e seu valor � repassado para
// as demais estruturas para que todas possuam o mesmo conte�do, impedindo desta
// forma distor��es involunt�rias relativas ao n�mero de elementos e como est�o
// organizados nas estrutudas testadas
procedure TF_Start.PreparaListaBase(var ListaBase: TList<Integer>; TamanhoAproximadoLista: Integer);
Var
   NumeroAleatorio : Integer;
   i               : Integer;
begin
     // Inicializa o gerador de n�meros aleat�rios
     Randomize;

     for i := 0 to TamanhoAproximadoLista do
      begin
           // Gerar n�mero aleat�rio no intervalo de 0 a 1000000
           NumeroAleatorio := Random(1000001);

           if not ListaBase.Contains(NumeroAleatorio) then
              ListaBase.Add(NumeroAleatorio);
      end;
end;

// M�todo utilizado para inserir e medir o tempo necess�rio para inserir valores
// na estrutura TLIST a fim de determinar sua efici�ncia em receber valores
procedure TF_Start.PreencheListaDeInteiros(var Lista: TList<Integer>;
var ListaBase: TList<Integer>; ExibirRelatorioInsercoes: Bool);
Var
   NumeroAleatorio : Integer;
   i               : Integer;
   ElapsedTime     : TDateTime;
   StartTime       : TDateTime;
begin
     // Cronometro o tempo que leva para inserir valores dentro do TList
     StartTime := Now;

     for I := 0 to ListaBase.Count - 1 do
         Lista.Add(ListaBase[i]);

     ElapsedTime := Now - StartTime;

     if ExibirRelatorioInsercoes then
        ExibeRelatorioInsercoes(Lista.Count, SecondsBetween(StartTime, Now), 'List');
end;

// TList CONTAINS vs List IndexOF vs TList BINARY SEARCH vs TDictionary CONTAINSKEY
procedure TF_Start.Pnl_ListContainsvsListIndexOfvsListBinarySearchvsDictionaryClick(
  Sender: TObject);
Var
   ListaBaseInteirosAleatorios       : TList<Integer>;
   ListaBaseInteirosAleatoriosBuscar : TList<Integer>;
   ListaInteirosAleatorios           : TList<Integer>;
   DicionarioInteirosAleatorios      : TDictionary<Integer, Bool>;
   i                                 : Integer;
   NumeroAleatorio                   : Integer;
begin
     Try
        Try
           Memo_Resultados.Lines.Clear;
           Memo_Resultados.Lines.Add('List Contains vs List Binary Search');
           Memo_Resultados.Lines.Add('Calculando...');

           // Instancio as estruturas que ser�o utilizadas como Listas Base.
           ListaBaseInteirosAleatorios       := TList<Integer>.Create();
           ListaBaseInteirosAleatoriosBuscar := TList<Integer>.Create();

           // Instancio as estruturas que ser�o utilizadas nos testes
           // de desempenho.
           ListaInteirosAleatorios      := TList<Integer>.Create();
           DicionarioInteirosAleatorios := TDictionary<Integer, Bool>.Create;

           // Alimenta as listas bases que ser�o utilizadas como refer�ncia
           // para as opera��es de alimenta��o das estruturas testadas e
           // para verifica��es de pertencimento.
           PreparaListaBase(ListaBaseInteirosAleatorios, 600000);
           PreparaListaBase(ListaBaseInteirosAleatoriosBuscar, 150000);

           // Alimento as estruturas utilizadas nos testes de desempenho
           PreencheListaDeInteiros(ListaInteirosAleatorios, ListaBaseInteirosAleatorios, true);
           PreencheDicionarioDeInteiros(DicionarioInteirosAleatorios, ListaBaseInteirosAleatorios, true);

           // Teste de desempenho para TList CONTAINS
           TesteDesempenhoListaContains(ListaInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);

           // Teste de desempenho para TList INDEXOF
           TesteDesempenhoIndexOF(ListaInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);

           // Precisam ser feitos depois dos demais testes de desempenho,
           // pois ordena a Lista e isso pode gerar distor��es.
           TesteDesempenhoBinarySearch(ListaInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);
           TesteDesempenhoDicionarioContains(DicionarioInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);

           Memo_Resultados.Lines.Delete(1);
           Memo_Resultados.Lines.Insert(1, 'C�lculos completos!');

        Finally
           FreeAndNil(ListaBaseInteirosAleatorios);
           FreeAndNil(ListaInteirosAleatorios);
           FreeAndNil(ListaBaseInteirosAleatoriosBuscar);
        End;

     Except
      on E: Exception do
          ShowMessage('Erro inesperado, List Contains vs List Binary Search: ' + E.Message);
     End;
end;


// M�todo utilizado para inserir e medir o tempo necess�rio para inserir valores
// na estrutura ARRAY a fim de determinar sua efici�ncia em receber valores
procedure TF_Start.PreencheArrayDeInteiros
(var Array_: array of Integer; var ListaBase: TList<Integer>;
ExibirRelatorioInsercoes: Bool);
Var
   NumeroAleatorio : Integer;
   i               : Integer;
   ElapsedTime     : TDateTime;
   StartTime       : TDateTime;
begin
     // Cronometro o tempo que leva para inserir valores dentro do array
     StartTime := Now;

     for I := 0 to ListaBase.Count - 1 do
         Array_[i] := ListaBase[i];

     ElapsedTime := Now - StartTime;

     // Exibo os relat�rios referente as inser��es
     if ExibirRelatorioInsercoes then
        ExibeRelatorioInsercoes(Length(Array_), SecondsBetween(StartTime, Now), 'Array');
end;

// M�todo utilizado para inserir e medir o tempo necess�rio para inserir valores
// na estrutura DICTIONARY a fim de determinar sua efici�ncia em receber valores
procedure TF_Start.PreencheDicionarioDeInteiros
(var DicionarioInteirosAleatorios: TDictionary<Integer, Bool>;
 var ListaBase: TList<Integer>; ExibirRelatorioInsercoes: Bool);
Var
   ElapsedTime     : TDateTime;
   StartTime       : TDateTime;
   i               : Integer;
   NumeroAleatorio : Integer;
begin
     // Cronometro o tempo que leva para inserir valores dentro do TDictionary
     StartTime := Now;

     for I := 0 to ListaBase.Count - 1 do
         DicionarioInteirosAleatorios.Add(ListaBase[i], true);

     ElapsedTime := Now - StartTime;

     if ExibirRelatorioInsercoes then
      begin
           ExibeRelatorioInsercoes(DicionarioInteirosAleatorios.Count,
              SecondsBetween(StartTime, Now), 'Dictionary');
      end;
end;

// M�todo Contains criado manualmente para verificar se determinado elemento
// j� est� presente no Array.
function TF_Start.ArrayContains(const MyArray: array of Integer; ValueToCheck: Integer): Boolean;
var
   i: Integer;
begin
     Result := False;

     for i := Low(MyArray) to High(MyArray) do
      begin
           if MyArray[i] = ValueToCheck then
            begin
                 Result := True;
                 Exit; // Se encontrar o valor, sai do loop
            end;
      end;
end;

// Realiza e exibe os resultados do teste de desempenho de uma TList utilizando
// o m�todo CONTAINS para verifica��es de pertencimento.
procedure TF_Start.TesteDesempenhoListaContains
(var Lista: TList<Integer>; var ListaInteirosAleatoriosBuscar: TList<Integer>);
Var
   ElapsedTime : TDateTime;
   StartTime   : TDateTime;
   i           : Integer;
   Existe      : Bool;
begin
     StartTime := Now;

     for i := 0 to ListaInteirosAleatoriosBuscar.Count - 1 do
         Existe := Lista.Contains(ListaInteirosAleatoriosBuscar[i]);

     ElapsedTime := Now - StartTime;

     ExibeRelatorioDesempenho(Lista.Count, ListaInteirosAleatoriosBuscar.Count,
        'Contains', SecondsBetween(StartTime, Now), 'List', 'A', 'na');
end;

// Realiza e exibe os resultados do teste de desempenho de um Array utilizando
// o m�todo CONTAINS para verifica��es de pertencimento
// Observa��o: o m�todo CONTAINS n�o � implementado automaticamente pela
// linguagem; fez-se necess�rio criar e implementar o m�todo CONTAINS para
// estrutura de Array.
procedure TF_Start.TesteDesempenhoArrayContains
(var Array_: array of Integer; var ListaInteirosAleatoriosBuscar: TList<Integer>);
Var
   ElapsedTime : TDateTime;
   StartTime   : TDateTime;
   i           : Integer;
   Existe      : Bool;
begin
     StartTime := Now;

     for i := 0 to ListaInteirosAleatoriosBuscar.Count - 1 do
         Existe := ArrayContains(Array_, ListaInteirosAleatoriosBuscar[i]);

     ElapsedTime := Now - StartTime;

     ExibeRelatorioDesempenho(Length(Array_), ListaInteirosAleatoriosBuscar.Count,
        'Contains', SecondsBetween(StartTime, Now), 'Array', 'O', 'no');
end;

// Realiza e exibe os resultados do teste de desempenho de uma TDictionary
// utilizando o m�todo CONTAINSKEY para verifica��es de pertencimento.
procedure TF_Start.TesteDesempenhoDicionarioContains
(var Dicionario: TDictionary<Integer, Bool>;
var ListaInteirosAleatoriosBuscar: TList<Integer>);
Var
   ElapsedTime : TDateTime;
   StartTime   : TDateTime;
   i           : Integer;
begin
     StartTime := Now;

     for i := 0 to ListaInteirosAleatoriosBuscar.Count - 1 do
         Dicionario.ContainsKey(ListaInteirosAleatoriosBuscar[i]);

     ElapsedTime := Now - StartTime;

     ExibeRelatorioDesempenho(Dicionario.Count, ListaInteirosAleatoriosBuscar.Count,
        'ContainsKey', SecondsBetween(StartTime, Now), 'Dicionario', 'O', 'no');
end;

procedure TF_Start.TesteDesempenhoIndexOF(var Lista,
  ListaInteirosAleatoriosBuscar: TList<Integer>);
Var
   ElapsedTime : TDateTime;
   StartTime   : TDateTime;
   i           : Integer;
   Valor      : Integer;
begin
     StartTime := Now;

     for i := 0 to ListaInteirosAleatoriosBuscar.Count - 1 do
         Valor := Lista.IndexOf(ListaInteirosAleatoriosBuscar[i]);

     ElapsedTime := Now - StartTime;

     ExibeRelatorioDesempenho(Lista.Count, ListaInteirosAleatoriosBuscar.Count,
        'IndexOf', SecondsBetween(StartTime, Now), 'List', 'A', 'na');
end;

// Realiza e exibe os resultados do teste de desempenho de uma TList
// utilizando o m�todo BINARY SEARCH para verifica��es de pertencimento.
procedure TF_Start.TesteDesempenhoBinarySearch
(var Lista: TList<Integer>; var ListaInteirosAleatoriosBuscar: TList<Integer>);
Var
   i                     : Integer;
   indiceValorEncontrado : Integer;
   ElapsedTime           : TDateTime;
   StartTime             : TDateTime; 
begin
     // BinarySearch retorna o �ndice do valor encontrado ou um valor negativo 
     // se o valor n�o for encontrado
     indiceValorEncontrado := 0;

     // O cronometro deve come�ar no momento em que a lista precisa ser 
     // ordenada, pois � uma opera��o obrigat�ria para o BinarySearch
     // funcionar e o tempo utilizado para realiza-la deve ser contabilizado
     StartTime := Now;

     Lista.Sort();

     for I := 0 to ListaInteirosAleatoriosBuscar.Count - 1  do
         Lista.BinarySearch(ListaInteirosAleatoriosBuscar[i], indiceValorEncontrado);	 
       
     ElapsedTime := Now - StartTime;

     ExibeRelatorioDesempenho(Lista.Count, ListaInteirosAleatoriosBuscar.Count,
        'BinarySearch', SecondsBetween(StartTime, Now), 'List', 'A', 'na');
end;

// TList vs Array
procedure TF_Start.Btn_ListvsArrayClick(Sender: TObject);
Var
   ListaBaseInteirosAleatorios        : TList<Integer>;
   ListaBaseInteirosAleatoriosBuscar  : TList<Integer>;
   ListaInteirosAleatorios            : TList<Integer>;
   ArrayNumerosAleatorios             : array of Integer;
   i                                  : Integer;
   NumeroAleatorio                    : Integer;
begin
     Try
        Try
           Memo_Resultados.Lines.Clear;
           Memo_Resultados.Lines.Add('List vs Array');
           Memo_Resultados.Lines.Add('Calculando...');

           // Instancio as estruturas que ser�o utilizadas nos como
           // Listas Base
           ListaBaseInteirosAleatorios       := TList<Integer>.Create();
           ListaBaseInteirosAleatoriosBuscar := TList<Integer>.Create();

           // Instancio a estrutura que ser� utilizada nos testes
           // de desempenho.
           ListaInteirosAleatorios := TList<Integer>.Create();

           // Alimenta as listas bases que ser�o utilizadas como refer�ncia
           // para as opera��es de alimenta��o das estruturas testadas e
           // para verifica��es de pertencimento
           PreparaListaBase(ListaBaseInteirosAleatorios, 400000);
           PreparaListaBase(ListaBaseInteirosAleatoriosBuscar, 100000);

           // Determino que o Array ter� a mesma quantidade de itens que a
           // Lista Base
           SetLength(ArrayNumerosAleatorios, ListaBaseInteirosAleatorios.Count);

           // Alimento as estruturas utilizadas nos testes de desempenhoS
           PreencheListaDeInteiros(ListaInteirosAleatorios, ListaBaseInteirosAleatorios, true);
           PreencheArrayDeInteiros(ArrayNumerosAleatorios, ListaBaseInteirosAleatorios, true);

           // Realizo testes de desempenho para a��es de verifica��o
           // de pertencimento.
           TesteDesempenhoListaContains(ListaInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);
           TesteDesempenhoArrayContains(ArrayNumerosAleatorios, ListaBaseInteirosAleatoriosBuscar);

           Memo_Resultados.Lines.Delete(1);
           Memo_Resultados.Lines.Insert(1, 'C�lculos completos!');

        Finally
            FreeAndNil(ListaBaseInteirosAleatorios);
            FreeAndNil(ListaInteirosAleatorios);
            FreeAndNil(ListaBaseInteirosAleatoriosBuscar);
            ArrayNumerosAleatorios := Nil;
        End;

     Except
      on E: Exception do
         ShowMessage('Erro inesperado, List vs Array: ' + E.Message);
     End;
end;

// TList vs Array vs TDictionary
procedure TF_Start.Btn_ListvsArrayvsDictionaryClick(Sender: TObject);
Var
   ListaBaseInteirosAleatorios       : TList<Integer>;
   ListaBaseInteirosAleatoriosBuscar : TList<Integer>;
   ListaInteirosAleatorios           : TList<Integer>;
   ArrayNumerosAleatorios            : array of Integer;
   DicionarioInteirosAleatorios      : TDictionary<Integer, Bool>;
   i                                 : Integer;
   NumeroAleatorio                   : Integer;
begin
     Try
        Try
           Memo_Resultados.Lines.Clear;
           Memo_Resultados.Lines.Add('List vs Array vs Dictionary');
           Memo_Resultados.Lines.Add('Calculando...');

           // Instancio as estruturas que ser�o utilizadas nos como
           // Listas Base
           ListaBaseInteirosAleatorios   := TList<Integer>.Create();
           ListaBaseInteirosAleatoriosBuscar := TList<Integer>.Create();

           // Instancio as estruturas que ser�o utilizadas nos testes
           // de desempenho.
           ListaInteirosAleatorios       := TList<Integer>.Create();
           DicionarioInteirosAleatorios := TDictionary<Integer, Bool>.Create;

           // Alimento as listas bases que ser�o utilizadas como refer�ncia
           // para as opera��es de alimenta��o das estruturas testadas e
           // para verifica��es de pertencimento
           PreparaListaBase(ListaBaseInteirosAleatorios, 400000);
           PreparaListaBase(ListaBaseInteirosAleatoriosBuscar, 100000);

           // Alimento as estruturas utilizadas nos testes de desempenho e
           // determino que o Array ter� a mesma quantidade de itens que a
           // Lista Base
           PreencheListaDeInteiros(ListaInteirosAleatorios, ListaBaseInteirosAleatorios, true);
           SetLength(ArrayNumerosAleatorios, ListaBaseInteirosAleatorios.Count);
           PreencheArrayDeInteiros(ArrayNumerosAleatorios, ListaBaseInteirosAleatorios, true);
           PreencheDicionarioDeInteiros(DicionarioInteirosAleatorios, ListaBaseInteirosAleatorios, true);

           // Realizo testes de desempenho para a��es de verifica��o
           // de pertencimento.
           TesteDesempenhoListaContains(ListaInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);
           TesteDesempenhoArrayContains(ArrayNumerosAleatorios, ListaBaseInteirosAleatoriosBuscar);
           TesteDesempenhoDicionarioContains(DicionarioInteirosAleatorios, ListaBaseInteirosAleatoriosBuscar);

           Memo_Resultados.Lines.Delete(1);
           Memo_Resultados.Lines.Insert(1, 'C�lculos completos!');

        Finally
            FreeAndNil(ListaBaseInteirosAleatorios);
            FreeAndNil(ListaInteirosAleatorios);
            FreeAndNil(ListaBaseInteirosAleatoriosBuscar);
            FreeAndNil(DicionarioInteirosAleatorios);
            ArrayNumerosAleatorios := Nil;
        End;

     Except
       on E: Exception do
          ShowMessage('Erro inesperado, TList vs Array vs TDictionary: ' + E.Message);
     End;
end;

end.
