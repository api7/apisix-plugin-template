# Makefile basic env setting
.DEFAULT_GOAL := help
## add pipefail support for default shell
SHELL := /bin/bash -o pipefail

# Project basic setting
project_name      ?= apisix-plugin-template
project_version   ?= 0.0.1
project_ci_runner ?= $(CURDIR)/ci/utils/linux-common-runnner.sh


# Hyper-converged Infrastructure
ENV_OS_NAME          ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
ENV_HELP_PREFIX_SIZE ?= 15
ENV_HELP_AWK_RULE    ?= '{ if(match($$0, /^\s*\#{3}\s*([^:]+)\s*:\s*(.*)$$/, res)){ printf("    make %-$(ENV_HELP_PREFIX_SIZE)s : %-10s\n", res[1], res[2]) } }'

# ENV patch for darwin
ifeq ($(ENV_OS_NAME), darwin)
	ENV_HELP_AWK_RULE := '{ if(match($$0, /^\#{3}([^:]+):(.*)$$/)){ split($$0, res, ":"); gsub(/^\#{3}[ ]*/, "", res[1]); _desc=$$0; gsub(/^\#{3}([^:]+):[ \t]*/, "", _desc); printf("    make %-$(ENV_HELP_PREFIX_SIZE)s : %-10s\n", res[1], _desc) } }'
endif


# Makefile basic extension function
_color_red    =\E[1;31m
_color_green  =\E[1;32m
_color_yellow =\E[1;33m
_color_blue   =\E[1;34m
_color_wipe   =\E[0m
_echo_format  ="[%b info %b] %s\n"


define func_echo_status
	printf $(_echo_format) "$(_color_blue)" "$(_color_wipe)" $(1)
endef


define func_echo_warn_status
	printf $(_echo_format) "$(_color_yellow)" "$(_color_wipe)" $(1)
endef


define func_echo_success_status
	printf $(_echo_format) "$(_color_green)" "$(_color_wipe)" $(1)
endef


define func_echo_error_status
	printf $(_echo_format) "$(_color_red)" "$(_color_wipe)" $(1)
endef


# Makefile target
### help : Show Makefile rules
.PHONY: help
help:
	@$(call func_echo_success_status, "Makefile rules:")
	@echo
	@awk $(ENV_HELP_AWK_RULE) Makefile
	@echo


### init_apisix : Fetch apisix code
.PHONY: init_apisix
init_apisix:
	@$(call func_echo_status, "$@ -> [ Start ]")
	$(project_ci_runner) get_apisix_code
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### patch_apisix : Patch apisix code
.PHONY: patch_apisix
patch_apisix:
	@$(call func_echo_status, "$@ -> [ Start ]")
	$(project_ci_runner) patch_apisix_code
	@$(call func_echo_success_status, "$@ -> [ Done ]")


### install : Install custom plugin
.PHONY: install
install:
	@$(call func_echo_status, "$@ -> [ Start ]")
	$(project_ci_runner) install_module
	@$(call func_echo_success_status, "$@ -> [ Done ]")
