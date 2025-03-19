module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "workstation-ekctl"
  ami = "ami-0b4f379183e5706b9"
  instance_type          = "t2.micro"
  # key_name               = "user1"
  # monitoring             = true
  #vpc_security_group_ids = [aws_security_group.allow_ekctl.id]
  #subnet_id              = "subnet-01c1c823852d19a68"
  user_data = file("workstation.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


