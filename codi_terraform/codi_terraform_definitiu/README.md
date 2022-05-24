# PASSOS, ORDRES I CONCEPTES: TERRAFORM I AWS.

## Passos fets:

- 0) Crear una 'VPC'.
- 1) Afegir una 'Public Subnet', una 'Private Subent' i el GW.
- 2) Afegir 'Route Table' i la ruta per defecte de la 'Private Subnet' i de la 'Public Subnet' i vincular-les).
- 3) Crear i vincular a una interficie del 'ALB' una Elastic IP (pública).
- 4) Crear servei 'ALB' (Application Load Balancer de proxy invers).
- 5) Crear 'SecurityGroup' per la 'Private Subnet' i la 'Public Subnet'.
- 6) Configurar l'AutoScaling i el seu grup i vincular amb el ALB.
- 7) Configurar les alarmes del 'CloudWatch' (més del 60 % CPU) i accions (aixecar una altre instancia de la AMI).

## Ordres més importants:

**terraform init**  --> Inizilitza refrescant/baixant tots els fitxers de configuració dins del directori de treball (proveïdors, dependències,pluggins etc). Executar quan s'afegeixi/canviï un proveïdor.

**terraform plan** --> Veiem els canvis que es faràn.

**terraform apply -auto-approve** --> Executem el plà de terraform sense necessitat de dir 'yes'.

**terraform fmt** --> Identar correctament el fitxer.

**terraform destroy** --> Desmuntem tot el que hem fet.

**terraform state show aws_instance.nginx_instance** --> Mostra informació del 'resource' escollit.

**terraform refresh** --> 

## Conceptes Terraform:

**resource** --> Accedir a un recurs del proveïdor.

**var.XXX**  --> Referenciem una variable del fitxer '<fitxer>.tfvars'.

**${var.XXX} -p 6000** --> Fem interpolació entre text variable i constant.

**data.**  --> Accedir a dades d'algun fitxer. *P.E:* Un 'simbolic link'.

**${ }**  --> Una forma de cridar una variable.

**[]**  --> Llista que espera més d'un resultat.

**file**  --> Referència a les dades dins d'un fitxer.

**tag** --> Com es dirà a AWS el nostre recurs.

## Conceptes AWS:

**arn:** Els noms de recursos d'Amazon (ARN) identifiquen de forma exclusiva els recursos d'AWS.

**tag:** Argument que permet identificiar els recursos configurats pel client a AWS.

**SNS:** Simple Notification Service.

**ASG:** Auto Scaling Group.

## Codi per permetre connectar-se vía 'SSH' desde 'Visual Studio Code' a la instància 'xxx':

```
/*
  provisioner "local-exec" {   //pemetre executar el fitxer que permet connexió ssh VS-host 
    command = templatefile("linux-ssh-config.tpl", {
      hostname = self.public_ip,7     user = "ubuntu",
      identityfile = "~/.ssh/id_ed25519"
    })
    interpreter = ["bash", "-c"]
  }
}
*/
```
