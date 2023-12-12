#Network Variables
variable "region" {
  default = ""
}
variable "vpc_name" {
  default = "stack_eks_cluster_VPC"
}
variable "vpc_cidr" {
  type = string

}
variable "igw_id" {
  type = string
}

variable "cidr_block_subnet_priv" {
 default = ""
  
}

variable "vpc_id" {
  type = string
  
 }
# variable "cidr_pub" {
#   type        = list(string)
  
# }

# variable "cidr_priv" {
#   type        = list(string)
  
# }
#Cluster Configuration
variable "cluster_name" {
  default = ""
}
variable "cluster_version" {
  type        = string
  default     = ""
  description = "The desired eks cluster that the team needs. Team must make sure their desired EKS version exists"
}

variable "node_group_name" {
  default = "stack_node_group"
}

variable "ami" {
  type    = string
  default = "AL2_x86_64"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "bastion_host_name" {
  default = "public_ip"
}

### Additional variables for node groups
variable "desired_size" {
  type        = number
  description = "desired node count for cluster node group"
}
variable "max_size" {
  type        = number
  description = "Max size for nodes in the node group"
}
variable "min_size" {
  type        = number
  description = "Min size for nodes in the node group"
}

### Additional variables for node groups
## GPU

variable "gpu_group_name" {
  description = "EKS node group name"
}

variable "gpu_desired_size" {
  type        = number
  description = "desired node count for cluster node group"
}
variable "gpu_max_size" {
  type        = number
  description = "Max size for nodes in the node group"
}
variable "gpu_min_size" {
  type        = number
  description = "Min size for nodes in the node group"
}


## Bastion Host
variable "key_name" {
  default = ""
}

variable "aws_eks_cluster" {
  default = ""
}

variable "csi-role-name" {
  default = ""
}

variable "bastion-host_name" {
  default = ""
}

###backend
variable "dynamodb_table-name" {

  default = ""
}

variable "s3-bucket-name" {
  default = ""
}

variable "account_id" {
  type = number

}