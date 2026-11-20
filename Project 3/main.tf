resource "aws_security_group" "ec2_sg" {
  name = "ec2-monitoring-sg"

  ingress {
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
}
resource "aws_instance" "monitoring_server" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "Monitoring-Server"
  }
}
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {

  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"

  period    = 120
  statistic = "Average"

  threshold = 70

  alarm_description = "Alarm when CPU exceeds 70%"

  dimensions = {
    InstanceId = aws_instance.monitoring_server.id
  }
}