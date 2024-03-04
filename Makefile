# const
.DEFAULT_GOAL := help

# MAIN TASKS ##################################################################

.PHONY: help
help: all
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# PROJECT DEPENDENCIES ########################################################

install: .install .cache ## Install project dependencies

.install: poetry.lock
	$(MAKE) configure
	poetry install
#	poetry run python -m pip install --upgrade torch torchaudio
#	poetry check
#	@touch $@

poetry.lock: pyproject.toml
	$(MAKE) configure
	poetry lock
	@touch $@

.cache:
	@mkdir -p .cache


.PHONY: configure
configure:
	poetry config virtualenvs.in-project true
	poetry self add poetry-plugin-export
	poetry self add 'poethepoet[poetry_plugin]'
	poetry run python -m pip install --upgrade pip
	poetry run python -m pip install --upgrade setuptools
	poetry run python -m pip install packaging wheel
	poetry run python -m pip install torch==2.2.0
	poetry run python -m pip install xformers==0.0.22.post7 --no-dependencies
