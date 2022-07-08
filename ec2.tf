data "template_file" "ansible_user_data" {
  template = file("${path.module}/Templates/ansible_cloudinit.tpl")

}

data "template_file" "web_user_data" {
  template = file("${path.module}/Templates/web_cloudinit.tpl")

}


resource "aws_network_interface" "bastion" {
  subnet_id       = aws_subnet.public[1].id
  security_groups = [aws_security_group.bastion.id]
  
  tags = {
    Name        = "${var.prefix}-bastion-nic"
    Project     = var.project
    Environment = var.environment
  }

}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_size
  key_name        = aws_key_pair.mainkey.key_name 
  user_data     = base64encode(data.template_file.ansible_user_data.rendered)
  # user_data_replace_on_change = true
  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }

  tags = {
    Name        = "${var.prefix}-bastion"
    Project     = var.project
    Environment = var.environment
    Tier        = "bastion"
  }
}

data "aws_iam_role" "ec2role" {
  name = "Ec2InstanceRole"
}

resource "aws_iam_instance_profile" "webprofile" {
  name = "webinstanceprofile"
  role = data.aws_iam_role.ec2role.name
}

resource "aws_network_interface" "web" {
  count = var.webnodes
  subnet_id       = element(aws_subnet.web.*.id, count.index)
  security_groups = [aws_security_group.web.id]
  tags = {
    Name        = "${var.prefix}-web-nic-${count.index}"
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
  }

}

resource "aws_instance" "web" {
  count         = var.webnodes
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_node_size
  key_name      = aws_key_pair.mainkey.key_name
  iam_instance_profile = aws_iam_instance_profile.webprofile.name
  depends_on    = [aws_nat_gateway.mynatgw]
  network_interface {
    network_interface_id = element(aws_network_interface.web.*.id, count.index)
    device_index         = 0
  }

  tags = {
    Name        = "${var.prefix}-web-${count.index}"
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
  }


}