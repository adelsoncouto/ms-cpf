#!/bin/bash

# armazana a linha GET
query=''
id=''

# loop nos parametros
while read line;do

  # verifico se é a linha GET
  if [[ $(echo "$line" | grep -i '^(GET|HEAD) ' | wc -l) -gt 0 ]]; then

    # salvo a query
    query="$line"

    # paro o loop
    break

  fi

done

# extrai o valor de um parâmetro
# $1 key do parâmbero
# $2 query string
function params(){
  echo "$2" | grep -io '[&\?]'"$1"'=[^& ]*' | awk -F '=' '{print $2}'
}


# identifica o dígito verificador, fonte: https://www.devmedia.com.br/validar-cpf-com-javascript/23916
# $1 qtd a verificar 9 ou 10
# $2 numero do cpf
function somar() {

  # armazenda a soma
  total=0

  # mutiplicador 
  x=$(($1+1))

  # posição
  n=1

  # loop nos números do cpf
  while [[ $n -lt $1 || $n -eq $1 ]];do 

    # pego o número na posição atual
    nu=$(echo "$2" | awk -F '' '{print $'$n'}')

    # multiplico e somo
    total=$(($total+$(($nu*$x))))

    # decremento o multiplicador
    x=$(($x-1))

    # incremento a posição
    n=$(($n+1))
  done

  # multiplico o total por 10
  total=$(($total*10))

  # pego o resto da divisão por 11
  resto=$(($total%11))

  # armazendo o dígito
  dig=0

  if [[ $resto -eq 10 || $resto -eq 11 ]]; then

    # se o resto for 10 ou 11
    dig=0

  else

    # se o resto for inferior a 10
    dig=$resto
  fi

  echo $dig
}

# pego o id
id=$(params 'id' "$query")

# pego o cpf
cpfPr=$(params 'params' "$query")

#$(echo "$query" | grep -o 'cpf=[0-9]\{11\}' | grep -o '[0-9]\{11\}')

# pego o parâmentro cpf completo
cpf=$(echo "$cpfPr" | grep -o '[0-9]\{11\}')

# verifico se o valor enviado tem 11 caracteres
if [[ "$cpf" != "$cpfPr" ]];then
  printf 'HTTP/1.1 200 OK\nConnection: close\nContent-Type: application/json; charset=UTF-8\n\n{"id":"'"$id"'","result":false}'
  exit 0
fi

# verifico se todos são iguais
p=$(echo "$cpf" | awk -F '' '{print $1}')
p=$(echo "$cpf" | grep -o "$p" | wc -l)

if [[ $p -gt 10 ]];then
  printf 'HTTP/1.1 200 OK\nConnection: close\nContent-Type: application/json; charset=UTF-8\n\n{"id":"'"$id"'","result":false}'
  exit 0
fi

# cpf vazio
if [[ -z "$cpf" ]];then
  printf 'HTTP/1.1 200 OK\nConnection: close\nContent-Type: application/json; charset=UTF-8\n\n{"id":"'"$id"'","result":false}'
  exit 0
fi


digs=$(echo "$cpf" | awk -F '' '{print $10$11}')

dig1=$(somar 9 $cpf)
dig="$dig1"$(somar 10 $cpf)


if [[ "$dig" == "$digs" ]];then
  printf 'HTTP/1.1 200 OK\nConnection: close\nContent-Type: application/json; charset=UTF-8\n\n{"id":"'"$id"'","result":true}'
else
  printf 'HTTP/1.1 200 OK\nConnection: close\nContent-Type: application/json; charset=UTF-8\n\n{"id":"'"$id"'","result":false}'
fi
