###############################################################
# Adiciona o provedor da AWS na inicialização do TerraForm
###############################################################
provider "aws" {}


###############################################################
# Consulta a VPC Padrão e a imagem AMI mais recente com o
# sistema operacional Amazon Linux
###############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}


###############################################################
# Provisiona os recursos para o novo TeamCity, cria um novo
# volume do EBS (20GB) para armazenar as configurações do
# servidor e dos agentes, adiciona um novo Security Group
# com as regras de acesso via SSH e HTTP, adiciona uma nova
# instância de EC2 para hospedar as imagens públicas do
# Docker, e por final, anexa o volume do EBS na nova instância
###############################################################
resource "aws_key_pair" "teamcity_key" {
  key_name = "teamcity-ssh-key"
  public_key = "${var.public_key}"
}

resource "aws_ebs_volume" "teamcity_ebs" {
  availability_zone = "${var.availability_zone}"
  size = 20
  type = "gp2"

  tags {
    Name = "${var.tag_name}"
  }
}

resource "aws_security_group" "teamcity_sg" {
  name = "teamcity_sg"
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.tag_name}"
  }
}

resource "aws_instance" "teamcity_instance" {
  ami = "${data.aws_ami.amazon_linux.id}"
  availability_zone = "${var.availability_zone}"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.teamcity_key.key_name}"
  ebs_optimized = false
  vpc_security_group_ids = ["${aws_security_group.teamcity_sg.id}"]

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "${var.bootstrap_shell_script_location}"

    connection {
      user = "${var.instance_user}"
      private_key = "${local.private_key}"
    }
  }

  tags {
    Name = "${var.tag_name}"
  }
}

resource "aws_volume_attachment" "teamcity_ebs_attach" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.teamcity_ebs.id}"
  instance_id = "${aws_instance.teamcity_instance.id}"
}

###############################################################
# O "Null Resource" é o workaround sugerido pela HashiCorp
# para executar o script de bootstrap somente após anexar o
# volume do EBS na instância
###############################################################
resource "null_resource" "cluster" {

  triggers {
    volume_attachment = "${aws_volume_attachment.teamcity_ebs_attach.id}"
  }

  connection {
    host = "${element(aws_instance.teamcity_instance.*.public_ip, 0)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sh ${var.bootstrap_shell_script_location}"
    ]

    connection {
      user = "${var.instance_user}"
      private_key = "${local.private_key}"
    }
  }
}
