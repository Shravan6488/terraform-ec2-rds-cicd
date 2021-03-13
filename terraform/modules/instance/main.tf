#================ Fetching Latest AMI ================
data "aws_ami" "latest_amazon_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-*-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}
#================ Key Pair ================
resource "aws_key_pair" "web_server_key" {
  key_name = "web_server_key"
  public_key = file(var.key_pair_path)
}
#================ Instance ================a
resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  iam_instance_profile = var.iam_instance_profile_name
  subnet_id = var.subnet_public_id
  vpc_security_group_ids = var.security_group_ids
  user_data = file(var.user_data_path)
  availability_zone = var.availability_zone
  key_name = aws_key_pair.web_server_key.key_name
  tags = {
    "Name" = "web server" 
    }
     }
#================ Load Balancer ================
resource "aws_alb" "web_server_alb" {
  name = "webserveralb"
  internal = "false"
  security_groups = var.lb_sg_id
  subnets = var.pub_subnet_1_id, var.pub_subnet_2_id

  tags {
    Name = "web_server_clb"
  }
}
#================ Load Balancer Listener ================
resource "aws_clb_listener" "clb_http_listener" {
  load_balancer_arn = aws_clb.web_server_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_clb_target_group.web_server_clb_tg.arn
    type = "forward"
  }
}
#================ Optional Start ================
#================ HTTPS Listener ================
resource "aws_clb_listener" "clb_https_listener" {
  load_balancer_arn = aws_clb.web_server_clb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2015-05"
  certificate_arn = "arn:aws:iam::account-id:server-certificate/certificate-name"
#================ Launch Configuration ================
resource "aws_launch_configuration" "web_server_lc" {
  name = "web_server_lc"
  image_id = data.aws_ami.latest_amazon_ami.id
  instance_type = var.instance_type
  iam_instance_profile = var.iam_instance_profile_name
  security_groups = var.web_server_sg_id
  key_name = aws_key_pair.web_server_key.key_name
  user_data = file(var.user_data_path)
  enable_monitoring = "false"   #For enhanced monitoring you can set this to "true"
}

#================ Auto Scaling Group ================
resource "aws_autoscaling_group" "web_server_asg" {
  launch_configuration = aws_launch_configuration.web_server_lc.id
  name = "web_server_asg"
  availability_zones = var.pub_subnet_1_id, var.pub_subnet_2_id
  max_size = var.asg_max_size
  min_size = var.asg_min_size
  health_check_grace_period = var.asg_health_check_gc
  health_check_type = var.asg_health_check_type
  desired_capacity = var.asg_desired_size
  target_group_arns = aws_alb_target_group.web_server_alb_tg.arn
}

#================ Auto Scaling Policies ================
resource "aws_autoscaling_policy" "web_server_asg_add_policy" {
  name = "web_server_asg_add_policy"
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.name
  policy_type = "SimpleScaling"
  scaling_adjustment = "1"
  adjustment_type = "ChangeInCapacity"
}

resource "aws_autoscaling_policy" "web_server_asg_minus_policy" {
  name = "web_server_asg_minus_policy"
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.name
  policy_type = "SimpleScaling"
  scaling_adjustment = "-1"
  adjustment_type = "ChangeInCapacity"
}

  default_action {
    target_group_arn = aws_clb_target_group.web_server_clb_tg.arn
    type = "forward"
  }
}
#================ Load Balancer TG ================
resource "aws_clb_target_group" "web_server_clb_tg" {
  name = "web-server-lb-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id  =var.vpc_id
}

#================ Load Balancer TG Attach ================
resource "aws_alb_target_group_attachment" "web_server_clb_tg_attach" {
  target_group_arn = aws_clb_target_group.web_server_clb_tg.arn
  target_id = aws_instance.web_server.id
  port = "80"
}