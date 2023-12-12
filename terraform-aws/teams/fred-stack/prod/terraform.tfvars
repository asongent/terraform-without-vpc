### Backend
dynamodb_table-name = "fred-statefile-lock"
s3-bucket-name      = "843825445314-us-east-1-terraform-state"
#Network Details
region   = "us-east-1"
vpc_name = "SocVpn"
vpc_id   = "vpc-0020f7b333b57c9e4"
vpc_cidr = "10.0.0.0/16"
igw_id   = "igw-0a49a4ac5d480d781"
#Cluster Details
cluster_name    = "stack-cluster"
cluster_version = "1.27"
csi-role-name   = "ebs-csi-role"
#Ncpu ode Group Details
node_group_name = "stack-core-ng"
max_size        = "16"
min_size        = "4"
desired_size    = "4"

##GPU node Group Name
gpu_group_name   = "gpu-manage-ng"
gpu_max_size     = "2"
gpu_min_size     = "1"
gpu_desired_size = "1"

##Bastion Host Daetails
bastion-host_name = "soc-bastion"
key_name          = "apache-keypair"
account_id        = "843825445314"