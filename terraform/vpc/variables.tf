### TAGS ###
variable "tag_environment" {
  type        = string
  description = "This environment for which you create"
}

variable "tag_product" {
  type        = string
  description = "Product name"
}

variable "tag_provisioner" {
  type        = string
  description = "Provide name of provisioner with which you are run. Eg. github, manual, manual-script"
}

variable "tag_contact" {
  type        = string
  description = "Responsible contact"
}

variable "tag_cost_code" {
  type        = string
  description = "Code that use for calculation product expenses"
}

### VPC ###
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "azs" {
  type    = list(string)
  default = []
}
