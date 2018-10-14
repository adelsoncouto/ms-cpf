#!/bin/bash


# recupera a versão
function getVersao(){

  # para tratar a seção histórico
  ehHistorico=0

  # resultados
  versao='0.0.1'
  alias='docker-image'

  # loop no README
  while read line;do
    
    # verifico se a linha é um tópico
    if [[ -n $(echo "$line" | grep -o '^#[^#]') ]];then
      
      if [[ -n $(echo "$line" | grep -o '^# *Histórico *$') ]]; then

        # ser for o histórico
        ehHistorico=1

      else

        #não é histórico
        ehHistorico=0

      fi

    fi

    if [[ $ehHistorico -eq 1 ]];then

      # recupero a segunda coluna 
      colVersao=$(echo "$line" | awk -F '|' '{print $3}')
      colAlias=$(echo "$line" | awk -F '|' '{print $4}')

      # verifico se a versão é válida
      if [[ -n $(echo "$colVersao" | grep -o '^ *[0-9]*\.[0-9]*\.[0-9]* *$') ]];then
        versao="$colVersao"
        alias="$colAlias"
      fi
      
    fi

  done < README.md

  echo "$alias:$versao"
}

versao=$(getVersao)

docker build -t $versao .

