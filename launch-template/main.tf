
resource "aws_launch_template" "tf-launch_template_1" {
  name_prefix = "tf-launch-template-"
  image_id = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.aws_security_group_id]
  user_data = filebase64("${path.module}/user-data.sh")

  iam_instance_profile {
#     name = var.instance_profile_name
  }
}