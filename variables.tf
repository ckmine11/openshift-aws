variable "access_key" {
        description = "Access key to AWS console"
        default = "AKIAQEIP3ODWED26QJ5A"
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
        default = "subnet-02172d48278918222"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-066ff578af81f8abf"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        default = "test-key"
}

