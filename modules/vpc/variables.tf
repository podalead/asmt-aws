### TAGS ###
variable "environment" {
  type = string
  description = "This environment for which you create"
}

variable "product" {
  type = string
  description = "Product name"
}

variable "tags" {
  type = map(string)
}

### VPC ###
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}
