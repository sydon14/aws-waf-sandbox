SHELL := /bin/bash
# AWS Region
REGION ?= $(shell aws configure get region)

# The Environment, i.e dev/qa/prod
ENV ?= $(shell aws configure get env)

# The deploy color
COLOR ?= $(shell aws configure get deploy-color)

# Account
ACCOUNT ?= $(shell aws configure get account)

# Vars file path
VAR_FILE ?= vars/$(ACCOUNT)-$(ENV)-$(COLOR)-$(REGION).tfvars

# Extracted variables from tfvars
ServiceName    := $(shell grep -E '^[[:space:]]*ServiceName[[:space:]]*=' $(VAR_FILE) | sed 's/.*= *"//;s/"//')
STATE_STORE    := $(shell grep -E '^[[:space:]]*STATE_STORE[[:space:]]*=' $(VAR_FILE) | sed 's/.*= *"//;s/"//')
ROLE_ARN       := $(shell grep -E '^[[:space:]]*ROLE_ARN[[:space:]]*=' $(VAR_FILE) | sed 's/.*= *"//;s/"//')
waf_acl_name   := $(shell grep -E '^[[:space:]]*waf_acl_name[[:space:]]*=' $(VAR_FILE) | sed 's/.*= *"//;s/"//')
AccountNumber  := $(shell grep -E '^[[:space:]]*AccountNumber[[:space:]]*=' $(VAR_FILE) | sed 's/.*= *"//;s/"//')

BACKEND_KEY := env:/$(ACCOUNT)-$(ENV)-$(COLOR)-$(REGION)/$(ServiceName)/root_tfstate.json

export TF_IN_AUTOMATION ?= true
export TF_INPUT         ?= false

ENT_AWS_PROFILE := entss-ss-tf-user
SECRET_NAME := entss-ss-tf-user

ifdef GITHUB_ACTIONS
AWS_PROFILE_ARG :=
AWS_PROFILE_ENV :=
else
AWS_PROFILE_ARG := --profile $(ENT_AWS_PROFILE)
AWS_PROFILE_ENV := AWS_PROFILE=$(ENT_AWS_PROFILE)
endif

_var_file:
	@$(MAKE) _workspace_create ws=$(ACCOUNT)-$(ENV)-$(COLOR)-$(REGION)
	@echo "Using var file: $(VAR_FILE)"
	@echo "ServiceName : $(ServiceName)"
	@echo "STATE_STORE : $(STATE_STORE)"
	@echo "ROLE_ARN    : $(ROLE_ARN)"

_workspace_create:
	@terraform workspace new $(ws) >/dev/null 2>&1 || terraform workspace select $(ws) >/dev/null 2>&1 || true

_workspace_show:
	@terraform workspace show

_create_backend:
	@echo "Creating backend.tf for $(ACCOUNT)-$(ENV)-$(COLOR)-$(REGION)"
	@{ \
	  echo 'terraform {'; \
	  echo '  backend "s3" {'; \
	  echo '    bucket = "$(STATE_STORE)"'; \
	  echo '    key    = "$(BACKEND_KEY)"'; \
	  echo '    region = "$(REGION)"'; \
	  if [ -n "$(ROLE_ARN)" ]; then \
	    echo '    assume_role = {'; \
	    echo '      role_arn = "$(ROLE_ARN)"'; \
	    echo '    }'; \
	  fi; \
	  echo '  }'; \
	  echo '}'; \
	} > backend.tf

_tf_init:
	@$(AWS_PROFILE_ENV) terraform init -reconfigure -no-color -var-file=$(VAR_FILE)

_check_init:
	@if [ -d ".terraform" ]; then \
	  if [ ! -f "backend.tf" ]; then $(MAKE) _create_backend; fi; \
	else \
	  $(MAKE) init; \
	fi

fetch_creds:
	@if [ "$$GITHUB_ACTIONS" = "true" ]; then \
		echo "Running inside GitHub Actions — using OIDC credentials already provided by aws-actions/configure-aws-credentials."; \
		echo "Skipping manual profile setup."; \
	else \
		echo "Fetching credentials from Secrets Manager: $(SECRET_NAME) using profile $(ENT_AWS_PROFILE)"; \
		CREDS=$$(aws secretsmanager get-secret-value \
			--secret-id $(SECRET_NAME) \
			--region $(REGION) \
			$(AWS_PROFILE_ARG) \
			--query SecretString \
			--output text); \
		AWS_ACCESS_KEY_ID=$$(echo $$CREDS | jq -r '.access_key_id'); \
		AWS_SECRET_ACCESS_KEY=$$(echo $$CREDS | jq -r '.secret_access_key'); \
		AWS_SESSION_TOKEN=$$(echo $$CREDS | jq -r '.session_token // empty'); \
		if [ -z "$$AWS_ACCESS_KEY_ID" ] || [ -z "$$AWS_SECRET_ACCESS_KEY" ]; then \
			echo "Missing or invalid credentials in secret $(SECRET_NAME)"; exit 1; \
		fi; \
		aws configure set "profile.$(ENT_AWS_PROFILE).aws_access_key_id" $$AWS_ACCESS_KEY_ID; \
		aws configure set "profile.$(ENT_AWS_PROFILE).aws_secret_access_key" $$AWS_SECRET_ACCESS_KEY; \
		if [ -n "$$AWS_SESSION_TOKEN" ]; then \
		  aws configure set "profile.$(ENT_AWS_PROFILE).aws_session_token" $$AWS_SESSION_TOKEN; \
		else \
		  if aws configure get "profile.$(ENT_AWS_PROFILE).aws_session_token" >/dev/null 2>&1; then \
		    aws configure set "profile.$(ENT_AWS_PROFILE).aws_session_token" ""; \
		  fi; \
		fi; \
		echo "Credentials configured for profile $(ENT_AWS_PROFILE)"; \
		AWS_PROFILE=$(ENT_AWS_PROFILE) aws sts get-caller-identity --region $(REGION) >/dev/null && \
		echo "Verified identity via STS"; \
	fi

cleanup_creds:
	@echo "Cleaning up credentials for $(ENT_AWS_PROFILE)"
	@aws configure set "profile.$(ENT_AWS_PROFILE).aws_access_key_id" "" || true
	@aws configure set "profile.$(ENT_AWS_PROFILE).aws_secret_access_key" "" || true
	@aws configure set "profile.$(ENT_AWS_PROFILE).aws_session_token" "" || true

init: fetch_creds _create_backend _tf_init _var_file _workspace_show

plan: fetch_creds init _check_init _var_file
	@echo "Backend key: $(BACKEND_KEY)"
	@$(AWS_PROFILE_ENV) terraform plan -no-color -var-file=$(VAR_FILE) -out=plan.tfplan

apply: fetch_creds _check_init _var_file
	@if [ -f plan.tfplan ]; then \
	  $(AWS_PROFILE_ENV) terraform apply -no-color plan.tfplan; \
	else \
	  $(AWS_PROFILE_ENV) terraform apply -no-color -var-file=$(VAR_FILE); \
	fi

delete: fetch_creds _check_init _var_file
	@$(AWS_PROFILE_ENV) terraform destroy -no-color -var-file=$(VAR_FILE) -lock=false

output:
	@$(AWS_PROFILE_ENV) terraform output

clean:
	@rm -rf backend*.tf .terraform terraform.tfstate* .terraform.lock.hcl plan.tfplan refresh.tfplan state-*.json
	