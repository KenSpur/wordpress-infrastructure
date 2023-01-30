# naming parts
variable "infix" {
  type    = string
  default = "test"
}

variable "env" {
  type    = string
  default = "dev"
}

# images
variable "image_resource_group_name" {
  type    = string
  default = ""
}

variable "image_gallery_name" {
  type    = string
  default = ""
}

variable "mysqldb_image_name" {
  type    = string
  default = "img-wordpress-mysql"
}

variable "mysqldb_image_version" {
  type    = string
  default = "1.0.0"
}

variable "wordpress_image_name" {
  type    = string
  default = "img-wordpress"
}

variable "wordpress_image_version" {
  type    = string
  default = "1.0.0"
}

# network
variable "private_domain_name" {
  type    = string
  default = ""
}

# ssh username and password
variable "ssh_username" {
  type    = string
  default = "azureadmin"
}

variable "ssh_password" {
  type      = string
  default   = ""
  sensitive = true
}