SHELL:=/usr/bin/env bash
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Makefile
# NOTE: Do not change the contents of this file!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

include .env

################################
# VARIABLES
################################

PYTHON:=python3
ifeq ($(OS),Windows_NT)
PYTHON=py -3
endif

################################
# Macros
################################

define delete_if_file_exists
	@if [ -f "$(1)" ]; then rm "$(1)"; fi
endef

define delete_if_folder_exists
	@if [ -d "$(1)" ]; then rm -rf "$(1)"; fi
endef

define clean_all_files
	@find . -type f -name "$(1)" -exec basename {} \;
	@find . -type f -name "$(1)" -exec rm {} \; 2> /dev/null
endef

define clean_all_folders
	@find . -type d -name "$(1)" -exec basename {} \;
	@find . -type d -name "$(1)" -exec rm -rf {} \; 2> /dev/null
endef

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TARGETS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

################################
# BASIC TARGETS: setup, build, run
################################
setup:
	@${PYTHON} -m pip install -r requirements
run:
	@${PYTHON} src/enter.py
all: setup run
################################
# TARGETS: testing
################################
tests:
	@cd tests && \
		${PYTHON} -m unittest discover -v \
			--start-directory "." \
			--top-level-directory ".." \
			--pattern "test_*.py"
################################
# TARGETS: clean
################################
clean:
	@echo "All system artefacts will be force removed."
	@$(call clean_all_files,.DS_Store)
	@echo "All build artefacts will be force removed."
	@$(call clean_all_folders,__pycache__)
	@$(call delete_if_file_exists,package-lock.json)
	@$(call delete_if_folder_exists,node_modules)
	@exit 0
