///////// IGW
resource "aws_internet_gateway" "main_internet_gateway" { # creem una porta de sortida a internet(GW)
  vpc_id = aws_vpc.main_vpc.id  
  tags = {Name = "principal-igw"}
}

/////////  VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  //enable_dns_hostnames = true # Per defecte ja ve a "true", estem activant la resolució DNS dins la VPC.
  //enable_dns_support   = true
  tags = {Name = "principal"}
}

//NAT PER SORTIR A INTERNET O ANAR A UNA ALTRE XARXA, necesitem 2 una per cada subxarxa pub
// necesari pq les subxarxes privades contactin amb les publiques

resource "aws_nat_gateway" "nat1" { 
  count         = "1"
  allocation_id = aws_eip.loadbalancer[count.index].id                    
  subnet_id = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.main_internet_gateway]
  tags = {
   Name        = "nat_illa"
  }
}

resource "aws_nat_gateway" "nat2" { 
  count         = "1"
  allocation_id = aws_eip.loadbalancer2[count.index].id                          
  subnet_id = aws_subnet.public[1].id
  depends_on    = [aws_internet_gateway.main_internet_gateway]
  tags = {
   Name        = "nat_illa2"
  }
}

////////////// Publics Elastics IPs: una pq tenim 2 zones ! #################

resource "aws_eip" "loadbalancer" {  //OJU AMB EL NOM, REPE !!
  count = "1"
  vpc      = true
  depends_on                = [aws_internet_gateway.main_internet_gateway]
}

resource "aws_eip" "loadbalancer2" {  //OJU AMB EL NOM, REPE !!
  count = "1"
  vpc      = true
  depends_on                = [aws_internet_gateway.main_internet_gateway]
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////7

###############  SUBNETS PUBLIQUES

variable subnet_cidr { description = "CIDR de les xarxes publiques" }
variable subnet_cidr_pr { description = "CIDR de les xarxes privades" }

resource "aws_subnet" "public" {  // CREEM 2 zones = 2 subxarxes públiques
  vpc_id = aws_vpc.main_vpc.id
  count = "${length(var.subnet_cidr)}" 
  cidr_block = "${element(var.subnet_cidr,count.index)}"
  availability_zone       = "${element(var.Azones,count.index)}"
  map_public_ip_on_launch = true 
}

resource "aws_route_table" "main_public_rt_1" { # route table per a la subxarxa pública
  count="1"
  vpc_id = aws_vpc.main_vpc.id
  tags = {Name = "principal_public_rt_1"}
}

resource "aws_route" "default_route_pu1" {   // default_route, podem sortir on volguem
  count = "1"
  route_table_id = aws_route_table.main_public_rt_1[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_internet_gateway.id
}

resource "aws_route_table_association" "main_public_assoc" { # vinculem la subxarxa publica 1 a la taula d'enrutament
  count="1"
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.main_public_rt_1[count.index].id
}


resource "aws_route_table_association" "main_public_assoc2" { # vinculem la subxarxa publica a la taula d'enrutament
count = "1"
  subnet_id      = aws_subnet.public[1].id
  route_table_id = aws_route_table.main_public_rt_1[count.index].id
}

############### SUBNETS PRIVADES : PRIVADA 1 I PRIVADA 2

resource "aws_subnet" "private" {  // CREEM 2 zones = 2 subxarxes públiques
  vpc_id = aws_vpc.main_vpc.id
  count = "${length(var.subnet_cidr_pr)}" 
  cidr_block = "${element(var.subnet_cidr_pr,count.index)}"
  availability_zone       = "${element(var.Azones,count.index)}"
  map_public_ip_on_launch = false 
}

resource "aws_route_table" "main_private_rt" { # rt = route table, per a la subxarxa privada1
  vpc_id = aws_vpc.main_vpc.id
  tags =  { Name = "principal_private_rt" }
}

resource "aws_route" "default_route_pr1" {   // default_route, podem sortir on volguem
  count = "1"
  route_table_id         = aws_route_table.main_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat1[count.index].id
}

resource "aws_route_table_association" "main_private1_assoc" { 
# vinculem la subxarxa privada1 a la taula d'enrutament
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.main_private_rt.id
}


resource "aws_route_table" "main_private_rt2" { # rt = route table, per a la subxarxa privada1
  count = "1"
  vpc_id = aws_vpc.main_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
   //nat_gateway_id             = aws_nat_gateway.nat2[count.index].id
   nat_gateway_id             = aws_nat_gateway.nat2[count.index].id
  }

  tags =  { Name = "principal_private_rt2" }
}

resource "aws_route_table_association" "main_private2_assoc" { 
# vinculem la subxarxa privada1 a la taula d'enrutament
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.main_private_rt.id
}
