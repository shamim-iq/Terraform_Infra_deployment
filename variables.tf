variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "sg_cidr_blocks" {
  description = "sg_cidr_blocks"
  type        = list(string)
}
