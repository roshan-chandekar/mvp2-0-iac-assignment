locals {
  nginx_user_data = <<-EOT
    #!/bin/bash
    set -e
    sudo yum install -y amazon-ssm-agent
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    sudo yum update -y
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo mkdir -p /usr/share/nginx/html
    TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    IID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
    sudo tee /usr/share/nginx/html/index.html > /dev/null <<EOF
    <h1>Hello Roshan, this is MVP2-0 IaC assignment</h1>
    <h1>Nginx on $IID ($AZ)</h1>
    EOF
  EOT
}

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "public_web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  #subnet_id              = values(aws_subnet.public)[0].id
  #subnet_id              = one([for s in aws_subnet.public : s.id])
  subnet_id = element([for s in aws_subnet.public : s.id], 0)
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  key_name               = var.ssh_key_name
  user_data              = local.nginx_user_data

  tags = {
    Name = "${var.project_name}-public-nginx"
    Role = "public-web"
  }
}

resource "aws_instance" "private_web" {
  for_each               = aws_subnet.private_app
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = each.value.id
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  key_name               = var.ssh_key_name
  user_data              = local.nginx_user_data

  depends_on = [aws_nat_gateway.main]

  tags = {
    Name = "${var.project_name}-private-nginx-${each.key}"
    Role = "private-web"
  }
}
