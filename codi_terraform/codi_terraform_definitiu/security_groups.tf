//Definim el grup de seguretat per la subxarxa pública (elb)

resource "aws_security_group" "permetre_http_s" {  
  name        = "permetre_trafic_http_s"
  description = "Permetre trafic HTTP i HTTPS inbound (entrada a la publica)"
  vpc_id      = aws_vpc.main_vpc.id

  ingress { # PROVISIONAL
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    //ipv6_cidr_blocks = [aws_vpc.main_vpc.ipv6_cidr_block]
  }

  ingress { # En el cas de que tinguem els certificats Let's Encrypt, eliminar aquesta regla
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    //ipv6_cidr_blocks = [aws_vpc.main_vpc.ipv6_cidr_block]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    //ipv6_cidr_blocks = [aws_vpc.main_vpc.ipv6_cidr_block]
  }

  egress {  //permetem sortir tot tipus de traffic , podem veure com es fa el STATE,... afegir una per cada entrada
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "permetre_http_s"
  }
}