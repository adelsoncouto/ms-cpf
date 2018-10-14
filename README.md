# Microserviço para validar CPF

Este microserviço tem por finalidade verificar se um CPF é ou não válido

# Histórico

|Data|Versão|Alias|Responsável|Nota
|---|---|---|---|---
|2018-10-13|1.0.0|adelsoncouto/ms-cpf|Adelson Silva Couto <adscouto@gmail.com>| Primeira versão

# Uso

Exemplo de requisição

```shell
curl 'http://{host}[:{porta}]/?jsonrpc=2.0&auth=interno&method=CPF.validar&params={numeroDoCpf}&id={idDeControle}'
```

Exemplo de resposta, no campo *result* se *true* o CPF é válido do contrário não

```json
{
  "id":"MesmoInformadoNaRequisição",
  "result":true|false
}
```

# Imagem DOCKER

O versionamento é recuperado do tópico *Histórico*

```shell
./build.sh
```

# Container DOCKER

```shell

docker run --restart always -d {imagem}

```

