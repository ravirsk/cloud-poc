
resource "aws_instance" "IAC-ec2-Standalone" {
	ami           				= "${var.aws_ami_id}"
	instance_type 				= "${var.aws_ec2_instance_type}"
	subnet_id                  	= var.aws_subnet_id
	vpc_security_group_ids = [aws_security_group.instance.id]
	key_name       = "OOAKeyLinux"
	
	user_data = templatefile("user-data.sh",{
		instance_desc = var.aws_ec2_instance_type
	})
  
	user_data_replace_on_change = true
	
	tags = {
		Name = "${var.aws_instance_name}"
	}

}

resource "aws_security_group" "instance" {
  name = "ec2-standalone-instance-SG"
  description = "Allow http inbound traffic"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "${var.aws_instance_name}-SG"
  }
}