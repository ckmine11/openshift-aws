variable "access_key" {
        description = "Access key to AWS console"
        default = "AKIAQEIP3KYVQDXEVHXO"
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
        default = "subnet-064c738d15b5e3da1"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-04efd0e2184af8ae0"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "test-key"
}

