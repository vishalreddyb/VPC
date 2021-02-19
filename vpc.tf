resource "aws_vpc" "ravi-dev" {
  cidr_block = "10.4.0.0/16"
  tags = {
    Name = "ravi-dev"
  }

}

resource "aws_default_security_group" "ravi-dev-frontend" {
  vpc_id = aws_vpc.ravi-dev.id
 ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = {
    Name = "ravi-dev-frontend"
  }

  }
