resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

 resource "aws_security_group" "mysg" {
    name = "web-sg"
    vpc_id = aws_vpc.myvpc.id

   ingress  {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
   tags = {
        Name = "web"
    }
 }

 resource "aws_s3_bucket" "example" {
 bucket = "my-unique-terraform-project-bucket-2025-05-10"
 }

 resource "aws_instance" "webserver1" {
   ami           = var.ami
   instance_type = var.instance_type
   subnet_id     = aws_subnet.sub1.id
   key_name      = var.key_name
   vpc_security_group_ids = [aws_security_group.mysg.id]
   user_data = base64encode(file("userdata.sh"))
 }

  resource "aws_instance" "webserver2" {
   ami           = var.ami
   instance_type = var.instance_type
   subnet_id     = aws_subnet.sub2.id
   vpc_security_group_ids = [aws_security_group.mysg.id]
   user_data = base64encode(file("userdata1.sh"))
 }

 resource "aws_lb" "myalb" {
   name               = "my-alb"
   internal           = false
   load_balancer_type = "application"
   security_groups    = [aws_security_group.mysg.id]
   subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
 }

 resource "aws_lb_target_group" "tg" {
   name = "mytg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.myvpc.id
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        path                = "/"
        protocol            = "HTTP"
        port = "traffic-port"
    }
 }

 resource "aws_lb_target_group_attachment" "attach1" {
   target_group_arn = aws_lb_target_group.tg.arn
   target_id        = aws_instance.webserver1.id
   port             = 80
   
 }

 resource "aws_lb_target_group_attachment" "attach2" {
   target_group_arn = aws_lb_target_group.tg.arn
   target_id        = aws_instance.webserver2.id
   port             = 80
   
 }

  resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.myalb.arn
    port              = 80
    protocol          = "HTTP"
  
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
  }