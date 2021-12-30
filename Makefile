SHELL := /bin/bash

all: build

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lint:  ## Linting
	@echo "Linting"
	flake8 functions tests/pytests lambda-layer/python --count --max-line-length=127 --statistics
	terraform fmt -recursive

test:  ## Run Python tests
	@echo "Running pytests"
	bash -c "cd tests/pytests && python3 -m pytest && rm jwt_cache*"

deploy:  ## Terraform apply
	@echo "Running Terraform apply"
	terraform apply -var-file env/prod.tfvars --auto-approve



.DEFAULT_GOAL := all
.PHONY: all