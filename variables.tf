#variable mysql
variable "database_admin_login" {
  default = "mysqladminun"
}

variable "database_admin_password" {
  default = "W0rdpr3ss@p4ss"
}

#Mysql database name
variable "dbname" {
  default = "db-wordpress"
}

#lb http rule and lb_probe
variable "application_port" {
  default = 80
}


variable "ssh_port" {
  default = 22
}

#VM username and password
variable "admin_username" {
  default = "wordpress"
}

variable "admin_password" {
  description = "Default password for admin account"
  default     = "W0rdpr3ss@p4ss"
}