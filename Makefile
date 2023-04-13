SHELL := /bin/bash
init:
	@echo "==> Initializing Packer..."
	packer --version
	cd $(ENVIRONMENT)/$(OS_TYPE)/$(SERVER_TYPE) && \
	cp -v ../../../vsphere.auto.pkrvars.hcl . && \
	packer init .

validate:
	@echo "==> Validating Packer Build..."
	cd $(ENVIRONMENT)/$(OS_TYPE)/$(SERVER_TYPE) && \
	packer validate -var-file="../../datacenter-variables/$(DESTINATION).pkrvars.hcl" .

build:
	@echo "==> Build Packer Template..."
	cd $(ENVIRONMENT)/$(OS_TYPE)/$(SERVER_TYPE) && \
	packer build -force -var-file="../../datacenter-variables/$(DESTINATION).pkrvars.hcl" .

fmt:
	@echo "==> Formatting Packer files..."
	@find ./ -type f -iname "*.hcl" -not -iname "*tpl*" -exec packer fmt '{}' \;