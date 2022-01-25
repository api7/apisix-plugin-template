#!/usr/bin/env bash

set -euo pipefail

VAR_CUR_PATH="$(cd $(dirname ${0}); pwd)"
VAR_CUR_HOME="$(cd $(dirname ${0})/../..; pwd)"

source "${VAR_CUR_PATH}/linux-common.sh"

# =======================================
# Linux common config
# =======================================
get_apisix_code() {
    # ${1} branch name
    git_branch=${1:-release/2.12}
    git clone --depth 1 --recursive https://github.com/apache/apisix.git -b "${git_branch}" && cd apisix || exit 1
}


install_module(){
    # copy custom apisix folder to origin apisix
    cp -av "${VAR_CUR_HOME}/apisix" "${VAR_CUR_HOME}/../apisix"

    # copy test case to origin apisix
    cp -av "${VAR_CUR_HOME}/t" "${VAR_CUR_HOME}/../apisix"
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
install_module)
    install_module "$@"
    ;;
*)
    func_echo_error_status "Unknown method: ${case_opt}"
    ;;
esac
