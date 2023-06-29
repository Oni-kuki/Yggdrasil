yggdrasil_completion() {
    local current_word previous_word

    current_word="${COMP_WORDS[COMP_CWORD]}"
    previous_word="${COMP_WORDS[COMP_CWORD-1]}"

    case "$previous_word" in
        "build"|"start"|"stop"|"enter"|"manexec"|"extract"|"remove"|"stoprm"|"remove-image"|"list")
            local options_file="./configuration/autocompletion/options.txt"
            if [[ -f "$options_file" ]]; then
                COMPREPLY=($(compgen -W "$(cat "$options_file")" -- "$current_word"))
            else
                COMPREPLY=()
            fi
            ;;
        "exec")
            local options_file="./configuration/autocompletion/tools_options.txt"
            if [[ -f "$options_file" ]]; then
                COMPREPLY=($(compgen -W "$(cat "$options_file")" -- "$current_word"))
            else
                COMPREPLY=()
            fi
            ;;
        *)
            case "$current_word" in
                "build"|"start"|"stop"|"stoprm"|"list"|"enter"|"status"|"exec"|"manexec"|"record"|"extract"|"remove"|"remove-image"|"help"|"about")
                    COMPREPLY=()
                    ;;
                *)
                    COMPREPLY=($(compgen -W "build start stop stoprm list enter status exec manexec record extract remove remove-image help about" -- "$current_word"))
                    ;;
            esac
            ;;
    esac
}

complete -F yggdrasil_completion Yggdrasil.sh
