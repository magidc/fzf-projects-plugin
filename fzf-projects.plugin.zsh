projects_file_path="${FZF_PROJECTS_FILE_PATH:-"$HOME/.projects"}"

fzf-cd-project-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "cat $projects_file_path" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_P_OPTS-}" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="builtin cd -- ${(q)dir}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}

add-project(){
  sed -i '$a\'"$1"'' $projects_file_path
}

remove-project(){
  sed -i '/\<sds\>/d' $projects_file_path 
}

zle     -N             fzf-cd-project-widget
bindkey -M emacs '\ep' fzf-cd-project-widget
bindkey -M vicmd '\ep' fzf-cd-project-widget
bindkey -M viins '\ep' fzf-cd-project-widget

