# OCI Network Setup FAST

How to setup your OCI network FAST, this project contains Terraform code and additional scripts to build out a fully functional and secure network for Oracle Cloud Infrastrucutre.

## Folder structure

Each high level build component has it's own folder to make it easier to deploy / update / manage the Terraform code.

- compartments - this builds out the compartments
- network - this builds out all network components (VCN, subnets, security lists, route tables, etc.)
- servers - this builds out all the servers
- test - this is a simple Terraform script to test your OCI connection
- scripts - these are automation scripts used to build out servers during the demonstration

The layout is based on how (in-general) changes would be implimented to the infrastructure.

There are two shared files that are duplicated to each directory

- secret.auto.tfvars - you must make this file and populate it with your secure OCI connection information
- variables.tf - definition of variables used in the Terraform scripts

## Design


### compartments

The basic design has two compartments for seperation of cloud console administrators.

- Network - this will hold all the network settings, security, VNC, subnets, and load balancers
- Servers - this will hold all the servers

This could easily be expanded if you want additioanl compartments for production vs non-production or to split things out by application such as ERP vs a web application.

### network

![Alt text](./network-diagram.jpg)

### servers

