#!/usr/bin/env bash

if [ -z $COMMON_SOURCED ]; then
  source include/common.sh
fi

if [ -z $SYSTEM_VARIABLES_SOURCED ]; then
  source include/system_variables.sh
fi

uninstall_unity_scope() {
  warning "Note:  to remove online search (wikipedia, amazon, ect.)"
  warning "       go to 'Security & Privacy' settings -> Search tab"
  warning "       and disable Online search"

  gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', \
        'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', \
        'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

  sudo apt-get remove --purge unity-lens-friends -y
  sudo apt-get remove --purge unity-lens-music -y
  sudo apt-get remove --purge unity-lens-music -y
  sudo apt-get remove --purge unity-lens-photos -y
  sudo apt-get remove --purge unity-lens-video -y

  sudo apt-get remove --purge unity-scope-audacious -y
  sudo apt-get remove --purge unity-scope-calculator -y
  sudo apt-get remove --purge unity-scope-chromiumbookmarks -y
  sudo apt-get remove --purge unity-scope-clementine -y
  sudo apt-get remove --purge unity-scope-colourlovers -y
  sudo apt-get remove --purge unity-scope-devhelp -y
  sudo apt-get remove --purge unity-scope-firefoxbookmarks -y
  sudo apt-get remove --purge unity-scope-gdrive -y
  sudo apt-get remove --purge unity-scope-gmusicbrowser -y
  sudo apt-get remove --purge unity-scope-gourmet -y
  sudo apt-get remove --purge unity-scope-guayadeque -y
  sudo apt-get remove --purge unity-scope-manpages -y
  sudo apt-get remove --purge unity-scope-musicstores -y
  sudo apt-get remove --purge unity-scope-musique -y
  sudo apt-get remove --purge unity-scope-openclipart -y
  sudo apt-get remove --purge unity-scope-exdoc -y
  sudo apt-get remove --purge unity-scope-tomboy -y
  sudo apt-get remove --purge unity-scope-video-remote -y
  sudo apt-get remove --purge unity-scope-virtualbox -y
  sudo apt-get remove --purge unity-scope-yelp -y
  sudo apt-get remove --purge unity-scope-zotero -y

  sudo apt-get clean -y
  sudo apt-get autoremove -y
}

uninstall_libreoffice() {
  # Remove the Libre Office installation
  # Useful if you need the extra rom
  sudo apt-get remove --purge libreoffice* -y
  sudo apt-get clean -y
  sudo apt-get autoremove -y
}

case $OS_TYPE in
  Linux*)
    confirm uninstall_libreoffice "Remove libreoffice"
    confirm uninstall_unity_scope "Remove unity_scope"
    ;;
  Darwin*)
    warning "No need to clean"
    ;;
  *)
    echo "OS $OS_TYPE is not supported"
esac
