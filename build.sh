#!/bin/bash

# chmod +x build.sh

# Define o diretório do ambiente virtual
VENV_DIR="$HOME/venv"

# Atualiza o sistema
sudo apt update

# Instala o Node.js e npm se não estiverem instalados
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null
then
    echo "Node.js e/ou npm não encontrados. Instalando Node.js e npm..."
    
    # Instala dependências
    sudo apt install -y curl

    # Adiciona o repositório NodeSource
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    
    # Instala Node.js e npm
    sudo apt install -y nodejs
    
    # Verifica se a instalação foi bem-sucedida
    if command -v node &> /dev/null && command -v npm &> /dev/null
    then
        echo "Node.js e npm instalados com sucesso."
    else
        echo "Falha ao instalar Node.js e npm."
        exit 1
    fi
else
    echo "Node.js e npm já estão instalados."
fi

# Instala o Chromium
if ! command -v chromium-browser &> /dev/null
then
    echo "Chromium não encontrado. Instalando Chromium..."
    sudo apt install -y chromium-browser
    if command -v chromium-browser &> /dev/null
    then
        echo "Chromium instalado com sucesso."
    else
        echo "Falha ao instalar Chromium."
        exit 1
    fi
else
    echo "Chromium já está instalado."
fi

# Instala o Git
if ! command -v git &> /dev/null
then
    echo "Git não encontrado. Instalando Git..."
    sudo apt install -y git
    if command -v git &> /dev/null
    then
        echo "Git instalado com sucesso."
    else
        echo "Falha ao instalar Git."
        exit 1
    fi
else
    echo "Git já está instalado."
fi

# Instala o Python e ferramentas associadas
if ! command -v python3 &> /dev/null
then
    echo "Python não encontrado. Instalando Python..."
    sudo apt install -y python3 python3-venv
    if command -v python3 &> /dev/null
    then
        echo "Python instalado com sucesso."
    else
        echo "Falha ao instalar Python."
        exit 1
    fi
else
    echo "Python já está instalado."
fi

# Instala o pip para Python 3 se não estiver instalado
if ! command -v pip3 &> /dev/null
then
    echo "Pip3 não encontrado. Instalando Pip3..."
    sudo apt install -y python3-pip
    if command -v pip3 &> /dev/null
    then
        echo "pip instalado com sucesso."
    else
        echo "Falha ao instalar pip."
        exit 1
    fi
else
    echo "Pip3 já está instalado."
fi

# Verifica se o Python 3 e o módulo venv estão instalados
if ! python3 -m venv --help &> /dev/null; then
    echo "O módulo venv não está instalado. Instalando..."
    sudo apt install -y python3-venv
fi

# Atualiza o PATH para incluir o diretório do Poetry
export PATH="$HOME/.local/bin:$PATH"

# Verifica se o Poetry está instalado
if ! command -v poetry &> /dev/null
then
    echo "Poetry não encontrado. Instalando Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    if command -v poetry &> /dev/null
    then
        echo "Poetry instalado com sucesso."

        # Adiciona o diretório do Poetry ao PATH
        if ! grep -q '/home/luizotavio/.local/bin' ~/.bashrc; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo "Diretório do Poetry adicionado ao PATH no ~/.bashrc"
        fi
    else
        echo "Falha ao instalar Poetry."
        exit 1
    fi
else
    echo "Poetry já está instalado."
fi

# Cria e ativa um ambiente virtual para Python
# rm -rf $HOME/venv # Remove ambiente virtual
if [ ! -d "$VENV_DIR" ]; then
    echo "Criando ambiente virtual em $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi

# Verifica se o ambiente virtual foi criado com sucesso
if [ ! -d "$VENV_DIR/bin" ]; then
    echo "Falha ao criar o ambiente virtual."
    exit 1
fi

# Verifica o conteúdo do diretório bin
echo "Conteúdo do diretório $VENV_DIR/bin:"
ls -l $VENV_DIR/bin

echo "Ativando ambiente virtual..."
source "$VENV_DIR/bin/activate"

# Verifica se a ativação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Falha ao ativar o ambiente virtual."
    exit 1
fi

# Instala o Django dentro do ambiente virtual
if ! command -v django-admin &> /dev/null; then
    echo "Django não encontrado. Instalando Django..."
    pip install django
    if command -v django-admin &> /dev/null; then
        echo "Django instalado com sucesso."
    else
        echo "Falha ao instalar Django."
        deactivate
        exit 1
    fi
else
    echo "Django já está instalado."
fi

# Desativa o ambiente virtual
deactivate


#!/bin/bash

# Verifica se o Ruby on Rails está instalado
if ! command -v rails &> /dev/null
then
    echo "Ruby on Rails não encontrado. Instalando Ruby on Rails..."

    # Atualiza a lista de pacotes
    sudo apt update

    # Instala o Ruby e suas dependências
    sudo apt install -y ruby-full

    # Configura o RubyGems para instalar gems no diretório do usuário
    gem install --user-install rails

    # Adiciona o diretório local de gems ao PATH se ainda não estiver presente
    GEMS_BIN_PATH=$(ruby -e "puts Gem.user_dir")/bin
    if ! grep -q "$GEMS_BIN_PATH" ~/.bashrc; then
        echo "Adicionando o diretório local de gems ao PATH..."
        echo "export PATH=\"$GEMS_BIN_PATH:$PATH\"" >> ~/.bashrc
        source ~/.bashrc
    else
        echo "Diretório local de gems já está no PATH."
    fi

    # Verifica se o Ruby on Rails foi instalado com sucesso
    if command -v rails &> /dev/null
    then
        echo "Ruby on Rails instalado com sucesso."
    else
        echo "Falha ao instalar Ruby on Rails."
        echo "Verifique se o PATH está configurado corretamente."
        echo "GEMS_BIN_PATH: $GEMS_BIN_PATH"
        echo "PATH: $PATH"
        exit 1
    fi
else
    echo "Ruby on Rails já está instalado."
fi

# Instala o Postman
if ! command -v postman &> /dev/null
then
    echo "Postman não encontrado. Instalando Postman..."
    sudo snap install postman
    if command -v postman &> /dev/null
    then
        echo "Postman instalado com sucesso."
    else
        echo "Falha ao instalar Postman."
        exit 1
    fi
else
    echo "Postman já está instalado."
fi

# Instala o Terraform
if ! command -v terraform &> /dev/null
then
    echo "Terraform não encontrado. Instalando Terraform..."
    sudo apt install -y software-properties-common
    sudo add-apt-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt update
    sudo apt install -y terraform
    if command -v terraform &> /dev/null
    then
        echo "Terraform instalado com sucesso."
    else
        echo "Falha ao instalar Terraform."
        exit 1
    fi
else
    echo "Terraform já está instalado."
fi

# Instala ferramentas de compilação
sudo apt install -y build-essential gcc g++ make

# Instala o Visual Studio Code
if ! command -v code &> /dev/null
then
    echo "Visual Studio Code não encontrado. Instalando Visual Studio Code..."
    sudo apt update
    sudo apt install -y software-properties-common apt-transport-https
    sudo sh -c 'wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -'
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    if command -v code &> /dev/null
    then
        echo "Visual Studio Code instalado com sucesso."
    else
        echo "Falha ao instalar Visual Studio Code."
        exit 1
    fi
else
    echo "Visual Studio Code já está instalado."
fi

# Instala o Docker se não estiver instalado
if ! command -v docker &> /dev/null
then
    echo "Docker não encontrado. Instalando Docker..."
    
    # Instala pacotes necessários
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Adiciona a chave GPG do Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Adiciona o repositório Docker
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Atualiza o índice de pacotes
    sudo apt update

    # Instala Docker
    sudo apt install -y docker-ce

    # Verifica se a instalação foi bem-sucedida
    if command -v docker &> /dev/null
    then
        echo "Docker instalado com sucesso."
    else
        echo "Falha ao instalar Docker."
        exit 1
    fi
else
    echo "Docker já está instalado."
fi

# Instala o Docker Compose se não estiver instalado
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose não encontrado. Instalando Docker Compose..."

    # Baixa o Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

    # Torna o binário executável
    sudo chmod +x /usr/local/bin/docker-compose

    # Verifica se a instalação foi bem-sucedida
    if command -v docker-compose &> /dev/null
    then
        echo "Docker Compose instalado com sucesso."
    else
        echo "Falha ao instalar Docker Compose."
        exit 1
    fi
else
    echo "Docker Compose já está instalado."
fi

# Adiciona o usuário ao grupo docker
if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adicionando o usuário $USER ao grupo docker..."
    sudo usermod -aG docker $USER

    # Solicita ao usuário que faça logout e login novamente
    echo "O usuário $USER foi adicionado ao grupo docker."
    echo "Script de configuração concluído."
    
    # Reinicia o sistema
    echo "O sistema será reiniciado para que as alterações tenham efeito."
    sudo reboot
else
    echo "O usuário $USER já está no grupo docker."
    echo "Execute o Makefile!"
fi
