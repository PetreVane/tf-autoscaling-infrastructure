
data "aws_ami" "selected_ami" {
  most_recent = true

  filter {
    name = "name"
    # This filter targets Amazon Linux 2 images
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]  # Free tier eligible typically supports the x86_64 architecture
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "state"
    values = ["available"]  # Only select AMIs that are available
  }
}

// Terraform template file capability is used to interpolate values directly into the (bash) script.
// See the script extension
data "template_file" "init-script" {
  template = file("${path.module}/user-data.sh.tpl")

  vars = {
    BUCKET_NAME = var.bucket_name
    JAR_KEY     = var.jar_file_key
  }
}


resource "aws_launch_template" "tf-launch_template" {
  name_prefix = "tf-launch-template"

  image_id = data.aws_ami.selected_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.aws_security_group_id]

  iam_instance_profile {
    name = var.iam_role_name
  }

  user_data = base64encode(data.template_file.init-script.rendered)
  tag_specifications {
    resource_type = "instance"
    tags = {
      name = "asg-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}