data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]

}

resource "aws_instance" "jenkins-server" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3.medium"
  security_groups = [aws_security_group.jenkins-sg.name]
  key_name        = "k8proj_key"
  user_data = "${file("${path.module}/install_jenkins.sh")}"
  tags = {
    "Name" = "Jenkins"
  }
}