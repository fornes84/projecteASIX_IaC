// VARIABLES A MODIFICAR SEGONS PROJECTE o MAQUINA ON EXECUTEM TERRAFORM ETC

ssh_pub = "/var/tmp/projecte_asix2/ssh_keys/id_ed25519.pub"
Azones = ["us-west-2a", "us-west-2b"] //de moment només tenim una
Azone = "us-west-2a"
Azone2 = "us-west-2b"
subnet_cidr = ["10.0.0.0/24","10.0.1.0/24"]
subnet_cidr_pr = ["10.0.3.0/24","10.0.4.0/24"] //privades