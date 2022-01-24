set -${ENTRYPOINT_MODE:-e}

# =======================================
# Linux basic extension module
# =======================================

_color_red='\E[1;31m'
_color_green='\E[1;32m'
_color_yellow='\E[1;33m'
_color_blue='\E[1;34m'
_color_wipe='\E[0m'


function func_echo_status() {
    printf "[%b info %b] %b\n" "${_color_blue}" "${_color_wipe}" "${1}"
}


function func_echo_warn_status() {
    printf "[%b info %b] %b\n" "${_color_yellow}" "${_color_wipe}" "${1}"
}


function func_echo_success_status() {
    printf "[%b info %b] %b\n" "${_color_green}" "${_color_wipe}" "${1}"
}


function func_echo_error_status() {
    printf "[%b info %b] %b\n" "${_color_red}" "${_color_wipe}" "${1}"
}
