#!bash
#
# bash completion support for the github gem.
#
# Written by Pedro Melo <melo@simplicidade.org>, October 1, 2009
#

_gh_commands='
  browse clone config create-from-local create
  fetch fetch_all fork home ignore info network
  pull-request pull track
'

_gh_trace()
{
  if [ -n "$GH_TRACE_TO" ] ; then
    echo "$@" >> "$GH_TRACE_TO"
  fi
}

_gh_comp()
{
  local possible_comps=$1
  local partial=$2
  _gh_trace "Got possibles '$possible_comps', partial '$partial'"
  
  if [ -z "$partial" ] ; then
    partial=${COMP_WORDS[COMP_CWORD]}
    _gh_trace "No partial given, using last word '$partial'"
  fi
  
  COMPREPLY=( $( compgen -W "$possible_comps" -- $partial ))
}

_gh_next_word()
{
  local c=${1:-1} i
  
  while [ $c -lt $COMP_CWORD ]; do
    i="${COMP_WORDS[c]}"
    _gh_trace "  iter i='$i', c is '$c'"
    case "$i" in
      -*) ;; # ignore options before command
      *)  echo $i; break ;;
    esac
		c=$((++c))
  done
}

_gh_gem_completion()
{
  local c=1 command partial
  _gh_trace $( set | egrep '^COMP_(CWORD|WORDS|LINE|POINT)=' )
  
  while [ $c -lt $COMP_CWORD ]; do
    i="${COMP_WORDS[c]}"
    _gh_trace "  iter i='$i', c is '$c'"
    case "$i" in
      -*) ;; # ignore options before command
      *) command="$i"; c=$((++c)); break ;;
    esac
		c=$((++c))
  done
  
  if [ -z "$command" ] ; then
    _gh_trace "No command, complete from global list of commands"
    _gh_comp "$_gh_commands"
    return 0
  fi
  
  _gh_trace "Got command '$command', c is '$c'"
  case "$command" in
    *)         _gh_trace "Command not handled"; COMPREPLY=() ;;
  esac
  
  return 0
}

complete -F _gh_gem_completion gh

