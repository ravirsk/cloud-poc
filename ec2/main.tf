provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "TerraExample" {
  #ami           = "ami-022e1a32d3f742bd8"
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  #subnet_id 	  = "subnet-089fdd231c885854"
  subnet_id 	  = "subnet-004eb3b855ddc44fb"
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
			  
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example-instance"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance-SG"
  description = "Allow http inbound traffic"
  #vpc_id		= "vpc-00b194f71bbeada9d"
  vpc_id		=  "vpc-0b4af206588ab6928"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   tags = {
    Name = "terraform-instance-SG"
  }

}