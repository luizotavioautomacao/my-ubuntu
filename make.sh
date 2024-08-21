#!/bin/bash

# chmod +x make.sh

# Atualiza a lista de pacotes
sudo apt update

# Instala o make
sudo apt install -y make

# Verifica se a instalação foi bem-sucedida
if command -v make &> /dev/null
then
    echo "make foi instalado com sucesso."
else
    echo "Falha ao instalar o make."
    exit 1
fi
