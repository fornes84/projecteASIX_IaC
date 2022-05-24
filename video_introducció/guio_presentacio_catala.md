## (DIAPO 1):

Bon dia / bona tarda, som Marc Fornés i Rubén Rodríguez i ara us parlarem del nostre projecte sobre automatitzar una infraestructura amb la filosofía IaC (Infrastructure as Code). L’objectiu és aixecar una infraestructura de venta d’entrades per un event massiu. Utilitzarem AWS com a proveïdor d’infraestructura i recursos / serveis de xarxa i el software Terraform, per automatitzar el desplegament.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 2):

Terraform és una IaC multiplataforma que construeix, aixeca, desmonta, escala, replica i gestiona infraestructures. Amb Terraform podem fer reingeniería o ingeniería inversa, és a dir, a partir de la infraestructura d’AWS, ens crearà un fitxer amb el codi de totes les instruccions de com aixecar la infraestructura.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 3, 4 i 5):

Partirem amb un entorn AWS buit, nosaltres executarem ‘terraform apply’ i aproximadament 3 minuts després la nostra infraestructura estarà aixecada. Tindrem un grup d’Autoscaling on posarem les instàncies de la AMI que tindràn un servei anomenat ‘EC2 Autoscaling’ les quals estaràn formades per un ‘Cluster’. Així mateix, AWS ens proporciona el servei ‘Cloud Watch’ que nosaltres utilitzarem per crear una alarma que quan la CPU de la màquina arribi al 60% ens avisarà conforme comença a aixecar un altre instància. Tot això dins d’una subxarxa privada que a l’hora estarà dins d’una VPC prèviament creada.

Les peticions dels navegadors dels clients estaràn balancejades per un ‘Reverse Proxy’ que fa de frontal (és a dir, estarà exposat a internet vía gateway) amb un servei ELB (Elastic Load Balancer) dins una subxarxa pública que a l’hora estarà dins de la VPC.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 6 i 7):

Un cop tinguem tot l’anterior en marxa, si ens haguèssim deixat alguna cosa per aixecar, com per exemple, un ‘S3 Bucket’ (es un servei d’AWS per emmagatzematge de fitxers), quan fem ‘terraform apply’, Terraform mirarà l’estat de l’estructura actual i només afegirà les noves modificacions sense necessitat de tornar a aixecar lo anteriorment mencionat.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 8):

Un cop haguem acabat ens interesa tornar a buidar tot ja que no li donarem ús i això gasta diners. Per fer-ho utilitzarem ‘terraform destroy’ que “desmuntarà” tot de forma segura i ràpida.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 9):

Encara que ja tenim tot el que necessitem, ho podem facilitar més utilitzant ‘Anisble + Packer’. Aquests ens ajudaràn a crear una imatge customitzada NGINX per a què AWS l’agafi per a la seva AMI.
