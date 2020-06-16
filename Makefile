branch = $(shell git rev-parse --abbrev-ref HEAD)

.ONESHELL .PHONY: build up down test
.DEFAULT_GOAL := build

custom_ca:
ifdef CUSTOM_CA
	cp -rf $(CUSTOM_CA)/* ca_certificates/ || cp -f $(CUSTOM_CA) ca_certificates/
endif

build: custom_ca
	docker build . -t local/hive:$(branch)
	docker tag  local/hive:$(branch) local/hive:latest
up:
	vagrant up
down:
	vagrant destroy
test:
	ANSIBLE_ARGS='--extra-vars "mode=test"' vagrant up --provision
up-acl:
	ANSIBLE_ARGS='--extra-vars "acl_enabled=true"' vagrant up --provision

