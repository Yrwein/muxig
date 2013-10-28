_muxig()
{
    local cur opts

    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=`muxig command-list`

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -F _muxig muxig
