#!/bin/sh

#   -------------------------------------------------------------
#   pre-commit :: hooks :: tf-format
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Call tofu fmt or terraform fmt as pre-commit hook
#   License:        BSD-2-Clause
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Determine which command to use
#
#   Prefer OpenTofu, fallback to Terraform
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

TF_CMD="tofu"
if ! command -v tofu >/dev/null 2>&1; then
    if command -v terraform >/dev/null 2>&1; then
        TF_CMD="terraform"
    else
        echo "Error: Neither 'tofu' nor 'terraform' found in PATH." >&2
        exit 1
    fi
fi

#   -------------------------------------------------------------
#   Check
#
#   :: 1. run in check mode to print a diff
#   :: 2. actual run in write mode, when needed
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

$TF_CMD fmt -check -diff "$@"
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    $TF_CMD fmt -write=true "$@"
fi

exit $EXIT_CODE
