Para executar precisa do erlang instalado e após instalação siga o passo a passo:

1 - Compile o projeto com o comendo: erlc .\start.erl

2 - Rode o erlang com o comando: erl

3 - Carregue o projeto na bash do erlang: c(start).

4 - Execute o módulo do projeto: start:start().

================================================================

Gerador de Oxigegnio e de hidrogenio gera em um tempo constante parametrizavel
Deve retornar quando criado a molecola informando qual e o identificador

Oxigenio:
Demora um tempo de 10s a 30s para retornar que esta pronta para realizar ligação

hidrogenio:
Demora um tempo de 10s a 30s para retornar que esta pronta para realizar ligação

Para gerar agua precisa de 2 molecolas de de hidrogenio e 1 de oxigenio

=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

cada molecola deve ser um processo em erlang

Quando combinado deverá retornar quem foi combiado

================================================================

Todo:

Esta funcionando, mas o sistema realiza a geração das 3 moleculas e aguarda pra fazer a ligação de todas.
Após fazer a agua, ai sim ele realiza a geração de 2 hidrogenios e 1 oxigenio.
