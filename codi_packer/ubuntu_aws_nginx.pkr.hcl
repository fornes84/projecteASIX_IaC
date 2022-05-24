packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  secret_key = "XXXXXXXXXXXXXXXXXXXXXX"
  access_key = "XXXXXXXXXXXXXXXXXXXXXX" 
  ami_name        = "nginx-ami-ubuntu-{{timestamp}}"
  ami_description = "Nginx Web Server"
  instance_type   = "t3.micro"
  region          = "us-west-2"
  source_ami      = "ami-0ee8244746ec5d6d4"
  ssh_username    = "ubuntu"
  vpc_id = "vpc-092fb7ce2a9e2f011"
  subnet_id = "subnet-0ff1c6f3fd4a4b43d"
  associate_public_ip_address = "true"
  tags = {
    Name = "Nginx"
    Os   = "Ubuntu 20.04"
  }
}

build {
  name = "nginx-ami"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  provisioner "ansible" {
	playbook_file   = "ansible/playbook_ubuntu.yml"
  }

  provisioner "file" {
    source      = "config/webapp.conf"
    destination = "/tmp/webapp.conf"
  }
}
