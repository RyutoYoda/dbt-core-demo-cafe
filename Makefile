VENV_DIR := .venv
PYTHON := $(VENV_DIR)/bin/python

.PHONY: help up down create-secrets upload-to-gcs gcs-to-duckdb generate-duckdb-master-data

# Check for python3
ifeq ($(shell command -v python3),)
$(error "python3 is not installed. Please install python3.")
endif

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  up          		    Create virtualenv and install dependencies"
	@echo "  down        		    Clean up the project"
	@echo "  create-secrets  	    Create secrets.toml"
	@echo "  upload-to-gcs 		    Upload the data to GCS"
	@echo "  gcs-to-duckdb 		    Load the data from GCS to DuckDB"
	@echo "  generate-duckdb-master-data	Generate master data for DuckDB"

up:
	test -d $(VENV_DIR) || python3 -m venv $(VENV_DIR)
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt
	@echo "----------------------------------------------------------------------"
	@echo "Virtual environment created and dependencies installed."
	@echo "Run 'source $(VENV_DIR)/bin/activate' to activate the virtual environment."
	@echo "You can now run dbt commands manually."
	@echo "----------------------------------------------------------------------"

down:
	rm -rf dbt_packages dbt_modules logs target .venv

create-secrets:
	$(PYTHON) ./.github/workflows/scripts/create_secrets.py

upload-to-gcs:
	$(PYTHON) ./.github/workflows/scripts/upload_to_gcs.py

gcs-to-duckdb:
	$(PYTHON) ./.github/workflows/scripts/gcs_to_duckdb.py

generate-duckdb-master-data:
	$(PYTHON) ./.github/workflows/scripts/generate_duckdb_master_data.py
