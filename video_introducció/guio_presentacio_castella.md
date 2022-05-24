## (DIAPO 1):

Buenos días / buenas tardes, somos Marc Fornés y Rubén Rodríguez y ahora os hablaremos de nuestro proyecto sobre automatizar una infraestructura con la filosofía IaC (Infrastructure as Code). El objetivo es levantar una infraestructura de venta de entradas para un evento masivo. Utilizaremos AWS como proveedor de infraestructura y recursos / servicios de red y el software Terraform, para automatizar el despliegue.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 2):

Terraform és una IaC multiplataforma que construye, levanta, desmonta, escala, replica y gestiona infraestructuras. Con Terraform podemos hacer reingeniería o ingeniería inversa, es decir, a partir de la infraestructura de AWS, nos creará un fichero con el código de todas las instrucciones de como levantar la infraestructura.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 3, 4 y 5):

Partiremos desde un entorno AWS vacío, nosotros ejecutaremos ‘terraform apply’ y aproximadamente 3 minutos después nuestra infraestructura estará levantada. Tendremos un grupo de Autoscaling dónde pondremos las instancias de la AMI que tendrán un servicio llamado ‘EC2 Autoscaling’ los cuales estarán formados por un ‘Cluster’. Así mismo, AWS nos proporciona el servicio ‘Cloud Watch’ que nosotros utilizaremos para crear una alarma que cuando la CPU de la máquina llegue al 60% nos avisará conforme empiece a levantar otra instancia. Todo esto dentro de una subred privada que a la vez estará dentro de una VPC previamente creada.

Las peticiones de los navegadores de los clientes estarán balanceadas por un ‘Reverse Proxy’ que hace de frontal (es decir, estará expuesta a internet vía gateway) con un servicio ELB (Elastic Load Balancer) dentro de una subred pública que a la vez estará dentro de la VPC.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 6 y 7):

Una vez tengamos todo lo anterior en marcha, si hubiésemos dejado otra cosa por levantar, como por ejemplo, un ‘S3 Bucket’ (es un servicio de AWS para almacenamiento de ficheros), cuando hagamos ‘terraform apply’, Terraform mirará el estado de la estructura actual y solo añadirá las nuevas modificaciones sin necesidad de volver a levantar lo anteriormente mencionado.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 8):

Una vez hayamos acabado nos interesa volver a vaciar todo ya que no le daremos uso y esto gasta dinero. Para hacerlo utilizaremos ‘terraform destroy’ que “desmontará” todo de forma segura y rápida.

---------------------------------------------------------------------------------------------------------------------------

## (DIAPO 9):

Aunque ya tengamos todo lo que necesitamos, aún podemos facilitarlo más utilizando ‘Anisble + Packer’. Estos nos ayudarán a crear una imagen customizada NGINX para que AWS la coja para su AMI.
