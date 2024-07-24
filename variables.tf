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
        default = "subnet-002e0b47e6a9ee2e6"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-068e0f1a600cd311c"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "test_key"
}

