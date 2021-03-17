# Terramox

Variable driven Terraform provisioning of Proxmox VMs on a **single** PVE host.

This utility repository exists solely to make my life easier. It wil not apply to all use cases.

## Usage

Fill out variables. Any `tfvars` file whose name is not `example` is ignored by default in this repository, so don't worry about accidentally committing your variables.

```
cp example.tfvars terraform.tfvars
```

Terraform as usual!

```
# To bring it up
terraform init
terraform plan
terraform apply

# To bring it down
terraform destroy
```

> Use the `-target` option to restrict resource scopes.

## Note

- Variable `qemu.*.clone` refers to the template VM name created manually by following instructions [here](https://gist.github.com/KrustyHack/fa39e509b5736703fb4a3d664157323f)