
data "aws_ami" "server_web" {
    most_recent = true # utilitza la ver més recent, compte amb això !
    owners = ["099720109477"] # Canonical en aquest cas 
    # owner id del creador de la imatge
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]  # ruta on es la ami
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
