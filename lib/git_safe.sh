#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=sh
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/landonb/git-smart#💡
# License: MIT

# *** A Git command wrapper to provide a few enhancements.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE:
#
# - Source this file from your ~/.bashrc.
#
#   It'll alias `git` to the function below.
#
# - Read on to learn what it does.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# This wrapper double-checks with the user on destructive commands,
# e.g., when they're about to clobber unstaged and untracked files.
#
# This applies to commands like
#
#   `git co -- {}` and `git reset --hard {}`
#
# (and for which `git reflog` won't save you).
#
# - Basically, this wrapper prompts the user to continue if any of
#   these commands are called:
#
#       git co -- {}
#       git co .
#       git reset --hard {}
#
#   - In some cases, you can recover from `git reset` by looking in the
#     reflog and just checking out the branch identified before the reset.
#     But not if `--hard` is specified, in which case you might lose
#     unstaged changes and/or untracked files.

# HISTORY/2017-06-06: We all make mistakes sometimes, so I 
# like to make destructive commands less easily destructive.
#
# - E.g., I alias the `rm` command in my environment to `rm_safe`
#  (from https://github.com/landonb/sh-rm_safe), which "removes"
#  file objects to the ~/.trash directory (that you can remove
#  for real later with the `rmtrash` command).
#
# - Likewise, Git has a few destructive commands that I wanted to
#   make less easily destructive.
#
#   - For instance, when I first started using Git, I'd sometimes type
#
#       git co -- blurgh
#
#     when I meant to type instead
#
#       git reset HEAD blurgh
#
#     So I decided to add a prompt before running the clobbery checkout command.

# NOTE: The name of this function appears in the terminal window title, e.g., on
#       `git log`, the tmux window title might be, `_git_safe log | {tmux-title}`.

_git_safe () {
  local disallowed=false

  _git_prompt_user_where_reflog_wont_save_them () {
    local prompt_yourself=false

    _git_prompt_determine_if_destructive () {
      # Check if `git co` or git-reset command.
      # NOTE: `co` is a simple alias, `co = checkout`.
      #       See .gitconfig in the root of this project.
      # NOTE: (lb): I'm not concerned with the long-form counterpart, `checkout`,
      #       a command I almost never type, and for which can remain unchecked,
      #       as a sort of "force-checkout" option to avoid being prompted.
      if [ "$1" = "co" ] && [ "$2" = "--" ]; then
        prompt_yourself=true
      fi
      # Also catch `git co .`.
      if [ "$1" = "co" ] && [ "$2" = "." ]; then
        prompt_yourself=true
      fi

      # Verify `git reset --hard ...` command.
      if [ "$1" = "reset" ] && [ "$2" = "--hard" ]; then
        prompt_yourself=true
      fi
    }

    _git_prompt_ask_user_to_continue () {
      printf "Are you sure this is absolutely what you want? [Y/n] "
      read -e YES_OR_NO
      # As writ for Bash 4.x+ only:
      #   if [[ ${YES_OR_NO^^} =~ ^Y.* ]] || [ -z "${YES_OR_NO}" ]; then
      # Or as writ for POSIX-compliance:
      if [ -z "${YES_OR_NO}" ] || [ "$(_first_char_capped ${YES_OR_NO})" = 'Y' ]; then
        # FIXME/2017-06-06: Someday soon I'll remove this sillinessmessage.
        # WHEN?/2020-01-08: (lb): I'll see it when I believe it. Still here!
        echo "YASSSSSSSSSSSSS"
      else
        echo "I see"
        disallowed=true
      fi
    }

    if [ $# -lt 2 ]; then
      return
    fi

    _git_prompt_determine_if_destructive "$@"

    if ${prompt_yourself}; then
      _git_prompt_ask_user_to_continue
    fi
  }

  _first_char_capped () {
    printf "$1" | cut -c1-1 | tr '[:lower:]' '[:upper:]'
  }

  # Prompt user if command consequences are undoable,
  # i.e., if previous file state would be *unrecoverable*.
  _git_prompt_user_where_reflog_wont_save_them "$@"

  # ***

  local exit_code=0

  if ! ${disallowed}; then
    command git "$@"
    exit_code=$?
  fi

  return ${exit_code}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    >&2 echo "ERROR: Trying sourcing the file instead: . $0" && exit 1
  else
    # To remove the alias, try:
    #
    #   unalias git 2> /dev/null
    alias git='_git_safe'
  fi
}

main "$@"
unset -f main

