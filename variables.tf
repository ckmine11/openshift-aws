variable "access_key" {
        description = "Access key to AWS console"
        default = "Enter AWS access_key"
}
variable "secret_key" {
        description = "Secret key to AWS console"
        sensitive   = true
}

variable "instance_type" {
        default = "t2.medium"
}

variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        default = "subnet-075549e275a0b1613"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-03f4878755434977f"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "test_key"
}

