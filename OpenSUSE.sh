#!/usr/bin/env bash
set -e

    #criando a primeira Snapshot pos instalação
SNAPSHOT_NAME="MeuPrimeiroSnapshot"
sudo snapper create --description "Snapshot criado via script"
    #add repositorios
sudo zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/Essentials/' packman
sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo zypper ar -f https://repo.vivaldi.com/archive/vivaldi-suse.repo

    #importando as chaves
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo rpm --import https://repo.vivaldi.com/archive/linux_signing_key.pub

    #atualizando os repositorios
sudo zypper ref

    #removendo pacotes e bloqueando instalação
sudo zypper --non-interactive rm -u libreoffice patterns-kde-kde_games kmail kaddressbook kontact korganizer ktnef konversation akregator tigervnc kompare
sudo zypper --non-interactive al libreoffice patterns-kde-kde_games kmail kaddressbook kontact korganizer ktnef konversation akregator tigervnc kompare

    #array dos app do repositorios openSUSE
zypper_apps=(
    "MirrorCache"
    "flatpak"
    "vivaldi-stable"
    "brave-browser"
    "flameshot"
    "fastfetch"
    "noto-serif-fonts"
    "noto-sans-cjk-fonts"
    "fetchmsttfonts"
)
    #array dos apps flatpak
flatpak_apps=(
    "com.github.tchx84.Flatseal"
    "io.github.giantpinkrobots.flatsweep"
    "io.github.flattool.Warehouse"
    "it.mijorus.gearlever"
    "org.onlyoffice.desktopeditors"
    "net.agalwood.Motrix"
    "org.zotero.Zotero"
    "net.sourceforge.scidavis"
    "me.hyliu.fluentreader"
    "com.discordapp.Discord"
    "com.visualstudio.code"
    "org.gimp.GIMP"
    "org.prismlauncher.PrismLauncher"
    "com.google.AndroidStudio"
    "org.flameshot.Flameshot"
    "com.jetbrains.IntelliJ-IDEA-Community"
    "io.github.shiftey.Desktop"
    "io.github.jeffshee.Hidamari"
    "com.github.phase1geo.minder"
    "org.kde.kolourpaint"
    "com.github.KRTirtho.Spotube"
    "org.upscayl.Upscayl"
    "org.apache.netbeans"
    "org.sqlitebrowser.sqlitebrowser"
    "com.jetbrains.PyCharm-Community"
)

    #instalando os codecs
sudo zypper --non-interactive install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full

    #instalando os app do repositorios openSUSE
    echo "Instalando $1..."
    sudo zypper --non-interactive install  $1
}

for app in "${zypper_apps[@]}"; do
    install_native_app $app
done

    #instalando os apps flatpak
install_flatpak_app() {
    echo "Instalando $1..."
    flatpak install flathub $1 -y
}

for app in "${flatpak_apps[@]}"; do
    install_flatpak_app $app
done

    #atualizando o sistema
sudo zypper --non-interactive dup

clear
fastfetch

YELLOW='\033[0;33m'
NC='\033[0m'
echo -e "${YELLOW} \n TODAS AS APLICAÇÕES FORAM FEITAS ${NC}\n"

