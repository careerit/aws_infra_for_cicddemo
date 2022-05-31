prefix      = "mysite"
environment = "dev"
project     = "drupal"

# Variables related to VPC and subnets
vpc_cidr        = "10.10.0.0/18"
pubsubnet_cidrs = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24", "10.10.7.0/24", "10.10.9.0/24", "10.10.11.0/24", ]
websubnet_cidrs = ["10.10.2.0/24", "10.10.4.0/24", "10.10.6.0/24", "10.10.8.0/24", "10.10.10.0/24", "10.10.12.0/24", ]
dbsubnet_cidrs =  ["10.10.15.0/24", "10.10.16.0/24", "10.10.17.0/24", "10.10.18.0/24", "10.10.19.0/24", "10.10.20.0/24", ]

# Bastion
bastion_size = "t2.micro"

# Web instances
web_node_size = "t2.micro"
webnodes      = 2


# db instances
db_node_size = "t2.micro"
dbnodes      = 0


