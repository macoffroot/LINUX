#!/bin/bash

# Define a lista de clientes
declare -A CLIENTES
CLIENTES=(
    ["Acesso1"]="192.168.0.1,administrador,dominio.local"
    ["Acesso2"]="teste.com.br:33899,administrador"
    ["Acesso3"]="192.168.0.2:33893,Administrador"
)

# Caminho para a pasta local a ser compartilhada
PASTA_COMPARTILHADA="$HOME/compartilhamento_rdesktop"

# Função para exibir o menu
exibir_menu() {
    echo "Escolha um cliente para conectar:"
    for chave in "${!CLIENTES[@]}"; do
        IFS=',' read -r ip usuario dominio <<< "${CLIENTES[$chave]}"
        echo "$chave) IP: $ip, Usuário: $usuario, Domínio: $dominio"
    done
}

# Função principal
conectar_cliente() {
    exibir_menu

    read -p "Digite o número da opção: " escolha

    if [[ -z "${CLIENTES[$escolha]}" ]]; then
        echo "Opção inválida."
        exit 1
    fi

    IFS=',' read -r IP USUARIO DOMINIO <<< "${CLIENTES[$escolha]}"

    # Verifica se a pasta de compartilhamento existe, se não existir, cria
    if [ ! -d "$PASTA_COMPARTILHADA" ]; then
        mkdir -p "$PASTA_COMPARTILHADA"
        echo "Pasta de compartilhamento criada em: $PASTA_COMPARTILHADA"
    fi

    # Inicia a sessão rdesktop com a pasta de compartilhamento
    rdesktop -u "$USUARIO" -d "$DOMINIO" -r clipboard:CLIPBOARD -r disk:shared="$PASTA_COMPARTILHADA" -g "1024x768" "$IP"
}

# Executa a função principal
conectar_cliente
