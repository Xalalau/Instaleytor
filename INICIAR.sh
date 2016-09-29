#!/bin/bash
#-----------
# INSTALEYTOR
#------------------------------------------------------------v1.1---20/09/16
#-----------------------------------------------------Pacotes de:---29/09/16
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
# Um script que serve para instalar a droga toda no Ubuntu (versão deb)!!
# Ele também é capaz de detectar o que já foi feito no sistema e com isso
# evita problemas e perda de tempo.
#
# Licença: GPL v2
# https://github.com/xalalau/Instalator
# Por Xalalau Xubilozo
# __________________________________________________________________________



# -------------------------------------------------------------
# Variáveis globais
# -------------------------------------------------------------

# Pasta atual
DIR_BASE="$(cd "${0%/*}" && echo $PWD)"

# Codinome e versão do sistema
CODENOME="$(lsb_release -c | awk '{print $2}')"
VERSAO="$(lsb_release -r | awk '{print $2}')"

# Opções a serem preenchidas pelo usuário
ADICIONAR_REPOSITORIOS=""
ADICIONAR_CHAVES=""
PROCESSAR_DEBS=""
LIBERAR_PARCEIROS=""

# Terminal secundário
CONSOLE=""

# Listagem de pacotes instalados
LISTA=""
LISTA2=""

# Variável para guardar a quantidade de itens em LISTA
QUANTPACOTES=0

# Variável auxiliar para imprimirmos alguns espaços corretamente
LIB=0


# -------------------------------------------------------------
# DIRETÓRIO BASE
# -------------------------------------------------------------

cd "$DIR_BASE"

# -------------------------------------------------------------
# FUNÇÕES
# -------------------------------------------------------------

# Funções gerais
source "funcoes.sh"

# Função com os entradas
source "entrada.sh"

# -------------------------------------------------------------
# INÍCIO
# -------------------------------------------------------------

clear
ativarSudo
gerarTerminalSecundario
instalarTtyecho
echo
definirOpcoes
clear

# -------------------------------------------------------------
# CHAVES E REPOSITÓRIOS
# -------------------------------------------------------------

liberarRepositorioParceirosUbuntu

if [ "$ADICIONAR_CHAVES" == "s" ] || [ "$ADICIONAR_CHAVES" == "S" ]; then
    echo "[SCRIPT] Adicionando chaves..."
    entrada 1 0 0 0 0
    LIB=1
fi

if [ "$ADICIONAR_REPOSITORIOS" == "s" ] || [ "$ADICIONAR_REPOSITORIOS" == "S" ]; then 
    echo "[SCRIPT] Adicionando repositórios..."
    entrada 0 1 0 0 0
    LIB=1
fi

if [ $LIB -eq 1 ]; then
    echo
fi

# -------------------------------------------------------------
# PREPARAÇÕES COM OS PACOTES DO SISTEMA
# -------------------------------------------------------------

apt-get_update
apt-get_upgrade
criarListasDePacotes1 1
criarListasDePacotes2
echo

# -------------------------------------------------------------
# ACEITAÇÃO DE EULAS
# -------------------------------------------------------------

LIB=0

entrada 0 0 1 0 0

if [ $LIB -eq 1 ]; then
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES VIA DEB
# -------------------------------------------------------------

if [ "$PROCESSAR_DEBS" == "s" ] || [ "$PROCESSAR_DEBS" == "S" ]; then 
    echo "[SCRIPT] Instalando debs:"
    echo
    cd ~/Downloads
    entrada 0 0 0 1 0
    cd "$DIR_BASE"
    echo
fi

# -------------------------------------------------------------
# INSTALAÇÕES VIA APT-GET
# -------------------------------------------------------------

echo "[SCRIPT] Instalando programas por apt-get:"
echo
entrada 0 0 0 0 1
echo

# -------------------------------------------------------------
# AJUSTES FINAIS
# -------------------------------------------------------------

iniciarTlp
echo
apt-get_autoremove
echo
finalizar
echo

exit
