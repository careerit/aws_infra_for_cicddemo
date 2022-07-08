# Infrastructure Setup for CICD Demo with AWS Developer tools


## Prerequisites

- Subscription to [AWS Account](https://aws.amazon.com/free/)
- [Terraform](https://www.terraform.io/downloads) installed on your laptop


## Terraform

The Terraform configuration creates the following resources:\66fbbbb

1. VPC
2. Internet Gateway
3. 3 Public Subnets & 3 Private Subnets in 3 Availability Zones
4. NAT Gateway
5. Route Tables
6. Bastion host


Additional Resources required: Create an IAM role for web  instances, here it is listed as "Ec2


| Resource               |       Quanity          |       Remarks          | 
|:------------------------|:-----------------------:|:------------------------|
| VPC                    |          1             | Region can be selected in `terraform.tfvars` |
| Internet Gateway       |     1| |
| Public Subnets| Variable| Varies as per the region - a subnet each in each Availability zones |
| Private Subnets| Variable| Varies as per the region - a subnet each in each Availability zones | 
| Route tables | 2 | A private route and A Public route table |
| Security Groups | 6 | All required security groups |
| Bastion | 1 | Jump server to connect to the web and DB servers|
| Web instances | As specified | No of `web_nodes` specified in the `terraform.tfvars` |
| Db instances | As specified | No of `db_nodes` specified in the `terraform.tfvars` |
| ALB     | 1 | Adds target group and adds web instances as part of it and security Groups | 



## Deployment

- Clone this [repository](https://github.com/careerit/aws_infra_for_cicddemo) and cd into `aws_infra_for_cicddemo`
- Update values in `terraform.tfvars`
- Initialize terraform
```bash
terraform init
```
- Terraform plan - to check what resources are being created 
```bash
terraform plan
```

- Once the plan is verified, apply the configuration
```bash
terraform apply
```






## Install Apache

- Install apache2 
```bash
sudo apt-get install apache2 -y
```

- Enable apache modules

```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
```

* Virtual Host forwarding.

```bash
cd /etc/apache2/sites-enabled
```

Create file in `/etc/apache2/sites-enabled` with the  name `000-default.conf` with the below content

```java
<VIRTUALHOST *:80>

    ProxyPreserveHost On

    # ...

    ProxyPass / http://localhost:8080/
</VIRTUALHOST>
```


Restart apache2

```bash
sudo systemctl restart apache