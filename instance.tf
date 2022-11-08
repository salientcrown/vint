resource "aws_instance" "iac_instance" {
  count = 1


  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = element(aws_subnet.public.*.id, count.index)
  user_data              = file("image.sh")
  tags = {
    Name = "${var.env}_iac_instance_demo"
  }
}