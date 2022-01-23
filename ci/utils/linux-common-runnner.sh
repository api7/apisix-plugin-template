#!/usr/bin/env bash

VAR_CUR_PATH="$(cd $(dirname ${0}); pwd)"

source "${VAR_CUR_PATH}/linux-common.sh"

# =======================================
# Linux common config
# =======================================
get_apisix_code() {
    # ${1} branch name
    git_branch=${1:-release/2.10}
    git clone --recursive https://github.com/apache/apisix.git -b "${git_branch}" && cd apisix || exit 1
}

# =======================================
# Entry
# =======================================
case_opt=$1
shift

case ${case_opt} in
get_apisix_code)
    get_apisix_code "$@"
    ;;
*)
    func_echo_error_status "Unknown method: ${case_opt}"
    ;;
esac
