#!/bin/sh
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Message
  echo "\033[34m#### Terraria Server Docker Image: building... ####"
# }}}

# {{{ Installing dependencies
  echo "\033[34m\n#### Installing dependencies ####\033[0m\n"
  apt update
  apt install --yes curl unzip mono-runtime screen
# }}}

# {{{ Variables
  _game="terraria"

  _terrariaver="1449"
  _archive="terraria-server-${_terrariaver}.zip"
  _source="https://terraria.org/api/download/pc-dedicated-server/${_archive}"

  _user=$_game
  _terrariafolder="/home/$_user"
  _uid=2112
# }}}

# {{{ Create user
  echo "\033[34m\n#### Creating user ####\033[0m\n"
  useradd --uid $_uid --home-dir $_terrariafolder --comment "Terraria Server" $_user
  mkdir $_terrariafolder
# }}}

# {{{ Download Terraria
  echo "\033[34m\n#### Downloading Terraria ####\033[0m\n"
  cd $_terrariafolder
  curl -SLO $_source
  unzip $_archive
  rm $_archive
  cp --verbose -a "${_terrariaver}/Linux/." .
  mkdir -p $_terrariafolder/worlds
# }}}

# {{{ Move files in server's folder
  echo "\033[34m\n#### Moving required files ####\033[0m\n"
  mv /terrariactl $_terrariafolder
  mv /startServer.sh $_terrariafolder

  mkdir $_terrariafolder/data
  mv /serverconfig.txt $_terrariafolder/data
# }}}

# {{{ Final steps/cleanup
  echo "\033[34m\n#### Cleanup ####\033[0m\n"
  ln -s $_terrariafolder/terrariactl /bin                  # Link scripts to the path
  apt remove --yes curl unzip                              # Remove no longer needed programs
  apt clean                                                # Clear apt cache
  chown -R $_user:$_user $_terrariafolder                  # Fix file permissions
  rm /setup.sh                                             # Cleanup
  rm -rf "${_terrariaver}"                                 # Remove server utils for other OSes
  rm TerrariaServer TerrariaServer.bin.x86_64 Terraria.png # Remove unnecessary files, we use mono on the exe, don't need those
  rm System.dll                                            # This stops the server from working on non-x86 systems
# }}}
