#!/bin/bash

RESET_COLOR=`echo -e "\e[00m"`
LIGHT_RED=`echo -e "\e[1;31m"`
LIGHT_GREEN=`echo -e "\e[1;32m"`
LIGHT_YELLOW=`echo -e "\e[1;33m"`
LIGHT_BLUE=`echo -e "\e[1;34m"`
PURPLE=`echo -e "\e[0;35m"`
LIGHT_CYAN=`echo -e "\e[1;36m"`

function git_cleanup_merged_branches()
{
    local git_main_branch
    local git_sed_color_deleted="s/Deleted branch \([^ ]*\) (was \([a-fA-F0-9]*\))/Successfully deleted branch ${LIGHT_GREEN}\1${RESET_COLOR} (was ${LIGHT_CYAN}\2${RESET_COLOR})/"
    local git_sed_color_unmerged="s/error: The branch '\([^']*\)' is not fully merged./Can't delete branch ${LIGHT_RED}\1${RESET_COLOR} (not fully merged)/"

	# List whatever origin branch available for a merged status in this loop
    # You can use $(git branch -r | grep/awk/sed "<regex>")
    for git_main_branch in origin/master; do
        # Remove all branch merged in each main branches
        git branch --merged $git_main_branch | grep -v '^\*' \
                                             | xargs --no-run-if-empty -n 1 git branch -d 2>&1 \
                                             | sed "${git_sed_color_deleted};${git_sed_color_unmerged}"
    done
}

function warn_if_old_fetch()
{
    local warn_date_min_days=2
    # Get git root dir and format it to unix path (c:/ => /c/)
    local git_root_dir=$(git rev-parse --git-dir 2>/dev/null | sed "s#^\([A-Za-z]\):#/\1#")

    local git_fetch_file="${git_root_dir}/FETCH_HEAD"
    if [ ! -f "${git_fetch_file}" ]; then
        return
    fi

    local git_last_fetch_date=$(stat -c %Y "${git_fetch_file}")
    local current_date=$(date +%s)
    local git_last_fetch_elapsed_time=$((($current_date - $git_last_fetch_date) / (60 * 60 * 24)))

    if [ $git_last_fetch_elapsed_time -ge $warn_date_min_days ]; then
        echo " ${LIGHT_RED}"'!'"${git_last_fetch_elapsed_time}days${RESET_COLOR}"
    fi
}

function deduce_origin_branch_or_commit()
{
    local git_local_branch=$1

    # Count commit only available on this branch (starts with ! using git show-branch -g)
    local exclusif_commit_count=$(git show-branch -g --sha1-name $git_local_branch | grep '!' | tail -n1 | sed "s/.*@{\([0-9]*\)}].*/\1/")

    local origin_commit="HEAD"
    if [ "$exclusif_commit_count" != "" ]; then
        origin_commit=$(git rev-parse HEAD~${exclusif_commit_count})
    fi

    # If we find nothing, return fork-point sha1
    local forkpoint_result="${origin_commit}"

    local branch_name
    local branch_count=0
    for branch_name in $(git branch -r --contains ${origin_commit} | grep -v HEAD); do
        ((branch_count++))
        # Look for release branch 1st (You can modify, add patterns here)
        if [ "$branch_name" == "origin/release/"* ]; then
            forkpoint_result="$branch_name"
            break
        fi

        # Then look for master
        if [ "$branch_name" == "origin/master" ]; then
            forkpoint_result="$branch_name"
            continue
        fi

        # Then look for current origin
        if [ "$branch_name" == "origin/${git_local_branch}" ]; then
            forkpoint_result="$branch_name"
        fi
    done

    # If no branch matched and there is only one available, select it
    if [ $branch_count -eq 1 ]; then
        forkpoint_result="$branch_name"
    fi

    # No fork-point found, return current branch on origin if exists
    if [ "${forkpoint_result}" == "${origin_commit}" ]; then
        local own_origin_branch_origin_commit=$(git branch --all | grep origin/${git_local_branch})

        if [ "${own_origin_branch_origin_commit}" != "" ]; then
            forkpoint_result="origin/${git_local_branch}"
        fi
    fi

    echo "${forkpoint_result}"
}

function get_repository_info()
{
    # Try to simply use git branch to extract upstream branch
    local origin_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null)
    local is_upstream_branch=1
    if [ "$origin_branch" == "" ]; then
        # No upstream branch found, try to deduce origin branch (if multiple, get fork-point commit)
        origin_branch=$(deduce_origin_branch_or_commit ${git_local_branch})
        is_upstream_branch=0
    fi

    local upstream_branch_prefix=""
    if [ $is_upstream_branch -eq 0 ]; then
        upstream_branch_prefix="${LIGHT_RED}no-up:${RESET_COLOR}"
    fi

    local commit_diff_count=$(git rev-list --left-right --count ${origin_branch}...HEAD)
    local behind_commit_count=$(echo -e "$commit_diff_count" | cut -f 1)
    local ahead_commit_count=$(echo -e "$commit_diff_count" | cut -f 2)

    if [ "$ahead_commit_count" != "0" ]; then
        commit_diff_str="${LIGHT_GREEN}+${ahead_commit_count}${RESET_COLOR}"
    fi

    if [ "$behind_commit_count" != "0" ]; then
        if [ "$commit_diff_str" != "" ]; then
            commit_diff_str="${commit_diff_str}|"
        fi
        commit_diff_str="${commit_diff_str}${LIGHT_RED}-${behind_commit_count}${RESET_COLOR}"
    fi

    if [ "${commit_diff_str}" != "" ]; then
        commit_diff_str=":${commit_diff_str}"
    fi

    commit_diff_str=" [${upstream_branch_prefix}${LIGHT_YELLOW}${origin_branch}${RESET_COLOR}${commit_diff_str}]"

    local operation_status=$(git diff-index HEAD | cut -d ' ' -f 5)

    local modified=$(echo -e "$operation_status" | grep '^[^DA]')
    if [ "$modified" != "" ]; then
        # Added operations
       operation_indicator="${LIGHT_CYAN}*${RESET_COLOR}"
    fi

    local deleted=$(echo -e "$operation_status" | grep '^D')
    if [ "$deleted" != "" ]; then
        # Deleted operations
        operation_indicator="${operation_indicator}${LIGHT_RED}-${RESET_COLOR}"
    fi

    local added=$(echo -e "$operation_status" | grep '^A')
    if [ "$added" != "" ]; then
        # Added operations
       operation_indicator="${operation_indicator}${LIGHT_GREEN}+${RESET_COLOR}"
    fi
}

function custom_git_ps1()
{
    git rev-parse --git-dir &> /dev/null
    if [ $? -ne 0 ]; then
        # Not a git repo
        return
    fi

    git rev-parse --abbrev-ref HEAD &> /dev/null
    if [ $? -ne 0 ]; then
        # Empty git repo
        echo " (${LIGHT_YELLOW}Initial commit${RESET_COLOR})"
       return
    fi

    local git_local_branch=$(git rev-parse --abbrev-ref HEAD)

    local commit_diff_str=""
    local operation_indicator=""

    local git_is_bare_repository=$(git rev-parse --is-bare-repository)
    if [ "$git_is_bare_repository" == "true" ]; then
        operation_indicator=" [${LIGHT_RED}bare repository${RESET_COLOR}]"
    else
        get_repository_info
    fi

    if [ "$git_local_branch" == "HEAD" ]; then
        local rev_short_number=`git rev-parse --short HEAD`
        git_local_branch="${LIGHT_RED}HEAD detached at ${RESET_COLOR}${rev_short_number}"
    else
        git_local_branch="${LIGHT_CYAN}${git_local_branch}${RESET_COLOR}"
    fi

    local warn_if_old_fetch_status=$(warn_if_old_fetch)
    echo " (${git_local_branch}${operation_indicator}${commit_diff_str})${warn_if_old_fetch_status}"
}
