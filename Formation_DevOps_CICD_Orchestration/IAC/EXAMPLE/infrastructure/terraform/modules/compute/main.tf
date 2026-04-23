variable "name" { type = string }
variable "instance_type" { type = string }
variable "instance_count" { type = number }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "key_name" { type = string }
variable "user_data" { type = string }
variable "tags" { type = map(string) }

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index)

  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  user_data              = var.user_data

  tags = merge(var.tags, {
    Name = "${var.name}-${count.index + 1}"
  })
}
