#!/bin/sh
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Variables
_script=$(readlink -f "$0")
_scriptpath=$(dirname "$_script")

_runnerargs="--server --gc=sgen -O=all"
_gameargs="-config $_scriptpath/data/serverconfig.txt"
# }}}

# {{{ Run server
cd $_scriptpath
mono $_runnerargs $_scriptpath/TerrariaServer.exe $_gameargs
# }}}
