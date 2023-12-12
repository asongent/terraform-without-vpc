resource "aws_security_group" "bastion_host-sg" {
  name   = "bastion_host_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.139.80.159/32"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_instance" "bastion_host" {
  instance_type          = var.instance_type
  associate_public_ip_address = false
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  ami                    = var.ami
  user_data              = file("user_data/data.sh")
  vpc_security_group_ids = [aws_security_group.bastion_host-sg.id]
  tags = {
    Name = "bastion-host"
  }
  # depends_on = [
  #   cluster_create_wait
  # ]
}

/* resource "aws_iam_instance_profile" "bastion" {
  name = "demo_profile"
  role = aws_iam_role.demo-role.name
} */