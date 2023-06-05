#!/usr/bin/env bash

#   -------------------------------------------------------------
#   pre-commit :: hooks :: shellcheck
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Forked from:    gruntwork-io/pre-commit
#   Authors:        06kellyjac
#                   Mark Butcher
#                   Yevgeniy Brikman
#   Description:    Call shellcheck as pre-commit hook
#   License:        Apache License 2.0
#   -------------------------------------------------------------

set -e

exit_status=0
enable_list=""
severity="style"

parse_arguments() {
    while (($# > 0)); do
        # Grab param and value splitting on " " or "=" with parameter expansion
        local PARAMETER="${1%[ =]*}"
        local VALUE="${1#*[ =]}"
        if [[ "$PARAMETER" == "$VALUE" ]]; then VALUE="$2"; fi
        shift
        case "$PARAMETER" in
        --enable)
            enable_list="$enable_list $VALUE"
            ;;
        --severity)
            severity=$VALUE
            ;;
        -*)
            echo "Error: Unknown option: $PARAMETER" >&2
            exit 1
            ;;
        *)
            files="$files $PARAMETER"
            ;;
        esac
    done
    enable_list="${enable_list## }" # remove preceeding space
}

parse_arguments "$@"

for FILE in $files; do
    SHEBANG_REGEX='^#!\(/\|/.*/\|/.* \)\(\(ba\|da\|k\|a\)*sh\|bats\)$'
    if (head -1 "$FILE" | grep "$SHEBANG_REGEX" >/dev/null); then
        if ! shellcheck ${enable_list:+ --enable="$enable_list"} --severity="$severity" "$FILE"; then
            exit_status=1
        fi
    elif [[ "$FILE" =~ .+\.(sh|bash|dash|ksh|ash|bats)$ ]]; then
        echo "$FILE: missing shebang"
        exit_status=1
    fi
done

exit $exit_status
