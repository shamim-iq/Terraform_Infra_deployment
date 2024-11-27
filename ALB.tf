#ALB
resource "aws_lb" "proj-alb" {
  name               = "proj-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.proj-Sg.id]
  subnets            = [for subnet in aws_subnet.proj_public : subnet.id]
}

#TG
resource "aws_lb_target_group" "proj-TG" {
  name     = "proj-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.proj-vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}
#Defining the target instances in the TG
resource "aws_lb_target_group_attachment" "proj-TG-attach" {
  for_each = aws_instance.proj-instance

  target_group_arn = aws_lb_target_group.proj-TG.arn
  target_id        = each.value.id
  port             = 80
}

#Connecting the TG with the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.proj-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.proj-TG.arn
    type             = "forward"
  }
}
