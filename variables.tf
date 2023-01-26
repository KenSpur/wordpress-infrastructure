variable "infix" {
  type    = string
  default = "test"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "image_resource_group_name" {
  type    = string
  default = ""
}

variable "mysqldb_image_name" {
  type    = string
  default = "img-wordpress-mysql"
}

variable "wordpress_image_name" {
  type    = string
  default = "img-wordpress"
}

variable "ssh_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_password" {
  type      = string
  default   = ""
  sensitive = true
}