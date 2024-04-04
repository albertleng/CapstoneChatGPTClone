provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "albertleng_web" {
  ami           = "ami-051f8a213df8bc089"
  instance_type = "t2.micro"
  key_name      = "albert-ollama-test"

  tags = {
    Name = "AlbertLengWebServer-GPT-Clone"
  }

  vpc_security_group_ids = [aws_security_group.albertleng_web_sg.id]
}

resource "aws_security_group" "albertleng_web_sg" {
  name        = "albertleng_web_sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

output "public_ip" {
  value = aws_instance.albertleng_web.public_ip
}
