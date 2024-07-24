variable "access_key" {
        description = "Access key to AWS console"
        default = "AKIA47CRVBT23UFIACCH"
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
        default = "ami-074d61a739422fd74"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "test_key"
}

