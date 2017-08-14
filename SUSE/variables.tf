variable "region" {
  description = "Default Region: Ireland"
  default     = "eu-west-1"
}

variable "availability_zone" {
  description = "Default AZ: Ireland"
  default     = "eu-west-1a"
}

variable "ami" {
  description = "Default SuSe 12 SP2"
  default     = "ami-f5776f93"
}

variable "instance_type" {
  description = "Default t2.micro"
  default     = "t2.micro"
}

variable "profile" {
  description = "AWS API Credentials: terraform"
  default     = "terraform"
}

variable "name" {
  default = "suse-hana.keytree.io"
}

variable "project" {
  description = "AWS Tag Project"
  default     = "KEYTREE - DEVOPS"
}

variable "environment" {
  description = "AWS Tag Environment"
  default     = "INFRASTRUCTURE"
}

variable "landscape" {
  description = "AWS Tag Landscape"
  default     = "PROTOTYPE"
}

variable "tier" {
  description = "AWS Tag Tier"
  default     = "5"
}

variable "type" {
  description = "TAG Resource"
  default     = "TERRAFORM"
}

variable "estimated_cost" {
  description = "TAG Resource"
  default     = "0"
}

variable "cr_ref" {
  description = "TAG Resource"
  default     = "CR00000"
}

variable "cost_code" {
  description = "TAG Resource"
  default     = "KTDEVOPS"
}

variable "requestor" {
  description = "TAG Resource"
  default     = "devops@keytree.co.uk"
}
