resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "infra"

  ingress {
    from_port = local.ssh_from
    to_port   = local.ssh_to
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = local.https_from
    to_port   = local.https_to
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = local.http_from
    to_port   = local.http_to
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = local.http_from_1
    to_port   = local.http_to_1
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = local.db_from
    to_port   = local.db_to
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