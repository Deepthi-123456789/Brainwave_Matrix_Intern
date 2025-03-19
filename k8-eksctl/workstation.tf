module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "workstation-ekctl"
  ami = "ami-0b4f379183e5706b9"
  instance_type          = "t2.micro"
  # key_name               = "user1"
  # monitoring             = true
  vpc_security_group_ids = [aws_security_group.eksctl.id]
  subnet_id              = "subnet-02cc37d094c8acc11"
  user_data = file("workstation.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "ekctl" {
  name        = "ekctl"
  description = "created for ekctl"
  tags = {
    Name = "ekctl"
  }
  ingress {
    description = "all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


