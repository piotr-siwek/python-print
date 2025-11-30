#!/bin/bash

echo "Aktualizacja systemu i narzędzi DevOps..."

# Aktualizacja systemu
sudo apt update && sudo apt upgrade -y

# Lista narzędzi do sprawdzenia
tools=("git" "curl" "wget" "unzip" "htop" "tree" "jq")

echo ""
echo "Sprawdzanie i instalacja narzędzi..."

for tool in "${tools[@]}";
do
    if ! command -v "$tool" &> /dev/null;
    then
        echo "✗ $tool nie jest zainstalowany - instaluję..."
        sudo apt install -y "$tool"
    else
        echo "✓ $tool już zainstalowany - sprawdzam aktualizacje..."
        sudo apt install -y --only-upgrade "$tool"
    fi
done

# Docker - specjalna obsługa
echo ""
if ! command -v docker &> /dev/null;
then
    echo "✗ Docker nie jest zainstalowany - instaluję..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker "$USER"
    rm get-docker.sh
    echo "⚠ WYLOGUJ SIĘ I ZALOGUJ PONOWNIE!"
else
    echo "✓ Docker już zainstalowany ($(docker --version))"

    # Sprawdź czy to docker-ce czy docker.io
    if dpkg -l | grep -q "docker-ce"; then
        echo "  Wykryto Docker CE - aktualizuję..."
        sudo apt update && sudo apt install -y --only-upgrade docker-ce docker-ce-cli containerd.io
    elif dpkg -l | grep -q "docker.io"; then
        echo "  Wykryto Docker.io - aktualizuję..."
        sudo apt install -y --only-upgrade docker.io
    else
        echo "  Docker zainstalowany spoza apt - pomiń automatyczną aktualizację"
    fi
fi

echo ""
echo "✓ Konfiguracja zakończona"

