resource "aws_instance" "lighting_instance" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = var.security_group_ids
  key_name      = "UYScutiKey"
  associate_public_ip_address = true

  tags = {
    Name = "lighting"
  }
}

resource "aws_instance" "heating_instance" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnets[1]
  vpc_security_group_ids = var.security_group_ids
  key_name      = "UYScutiKey"
  associate_public_ip_address = true

  tags = {
    Name = "heating"
  }
}

resource "aws_instance" "status_instance" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnets[2]
  vpc_security_group_ids = var.security_group_ids
  key_name               = "UYScutiKey"
  associate_public_ip_address = true


  tags = {
    Name = "status"
  }
}

resource "aws_instance" "auth_instance" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnets[0]
  vpc_security_group_ids = var.security_group_ids
  key_name      = "UYScutiKey"
  associate_public_ip_address = true

  tags = {
    Name = "auth"
  }
}

