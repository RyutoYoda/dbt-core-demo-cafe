.PHONY: help sync deps seed run test build docs-generate docs-serve streamlit duckdb clean

help:
	@echo "Available commands:"
	@echo "  make sync           - Install dependencies using uv"
	@echo "  make deps           - Install dbt packages"
	@echo "  make seed           - Load seed data"
	@echo "  make run            - Run dbt models"
	@echo "  make test           - Run dbt tests"
	@echo "  make build          - Run seed, run, and test"
	@echo "  make docs-generate  - Generate dbt documentation"
	@echo "  make docs-serve     - Serve dbt documentation"
	@echo "  make streamlit      - Run Streamlit app"
	@echo "  make duckdb         - Open DuckDB CLI"
	@echo "  make clean          - Clean up generated files"

sync:
	uv sync

deps: sync
	uv run dbt deps

seed: deps
	uv run dbt seed

run: deps
	uv run dbt run

test: deps
	uv run dbt test

build: seed run test

docs-generate:
	uv run dbt docs generate

docs-serve:
	uv run dbt docs serve

streamlit:
	uv run streamlit run app.py

duckdb:
	uv run duckdb dbt_core_demo_cafe.duckdb

clean:
	rm -rf .venv dbt_packages logs target
