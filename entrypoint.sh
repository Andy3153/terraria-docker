#!/bin/sh
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Variables
  _game="terraria"
  _user=$_game
  _terrariafolder="/home/${_user}"
  _terrariafolder2="/home/${_user}2"
# }}}

# {{{ Move folder where it belongs if needed
if [ ! -d $_terrariafolder ] then
  mv $_terrariafolder2 $_terrariafolder
  chown -R $_user:$_user $_terrariafolder
fi
# }}}

su terraria -c "terrariactl start"
