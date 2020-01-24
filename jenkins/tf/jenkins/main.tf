# Jenkins master launch configaration
provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_launch_configuration" "jmaster" {
  image_id        = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.jmaster.id]
  depends_on      = [aws_security_group.jmaster]
  user_data       = data.template_file.master_user_data.rendered
  root_block_device {
    volume_size = 20
  }
  ebs_block_device {
    volume_size = 100
    device_name = "/dev/xvdf"
  }
}

resource "aws_efs_file_system" "jmaster" {
  creation_token = "JenkinsMaster"
  tags           = var.resources_tags
}

data "template_file" "master_user_data" {
  template = "${file("${path.module}/scripts/startup-master.sh.tpl")}"

  vars = {
    efs_dns_name = aws_efs_file_system.jmaster.dns_name
  }
}

resource "aws_efs_mount_target" "jmaster" {
  file_system_id  = aws_efs_file_system.jmaster.id
  subnet_id       = element(var.private_subnet_ids, 0)
  security_groups = [aws_security_group.master-efs-storage.id]
}
