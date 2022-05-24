variable Azones { description = "zones disponibles dins la regió AWS" }
variable Azone { description = "zona única a assignada" }
variable Azone2 { description = "zona única b assignada" }

///// LOAD BALANCER ////

resource "aws_lb" "loadbalancer" {       //ok 
  name               = "terraform-alb"    //OK 
  internal = false // ??????????????????????????????????
  load_balancer_type = "application" //default
  subnets =  [aws_subnet.public[0].id,aws_subnet.public[1].id]
  security_groups = [aws_security_group.permetre_http_s.id]
  //enable_deletion_protection = false
  tags = {Name = "terraform-alb"}
}

 //  ENLLACEM AMB EL GRUP !!

resource "aws_lb_listener" "escolta_loadbalancer" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  //ssl_policy        = "ELBSecurityPolicy-2016-08"
  //certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn   # es el tarjet group?
  }
}

/*
resource "aws_alb_target_group_attachment" "attachment" {
  count            = length(aws_instance.instance.*.id) == 2 ? 2 : 0 // Aixecarem 2 instàncies
  target_group_arn = aws_lb_target_group.GrupInstancies.arn
  target_id        = element(aws_instance.instance.*.id, count.index) //totes les instancies aniran alg GrupInstancies del lb
}
*/

resource "aws_lb_target_group" "test" {
  name     = "targetgrouplb"
  port     = 80
  //target_type = "instance"  //default
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 70
    protocol            = "HTTP"
  }

}

///////// LAUNCH CONFIGURATION GROUP  (PEL AUTOSCALING GROUP) //////////////////////

resource "aws_launch_configuration" "launch_instancie" {  

  name_prefix   = "launch_nginx_instancie" //posa nom i varia el final del string 
  instance_type = "t3.micro" //t3.micro va lligat a su posem cluster !
  enable_monitoring = true // --> DEFAULT 'true' !!!
  image_id      =  data.aws_ami.server_web.id  
# NOTA:  EN CAS DE VOLER UTILITZAR LA IMATGE D'NGINX CREADA AMB PACKER, COMENTAR LA LINEA D'ABAIX I CAMBIAR DE LA LIENEA D'ADALT AMB EL ID DE LA IMATGE GENRADA PER PACKER, EXEMPLE "ami-0f94be30c76b51446"
  user_data = file("userdata.tpl")  //instalem nginx
  security_groups = [aws_security_group.permetre_http_s.id]

  root_block_device {
    volume_size = 10    // ampliem a 10 GB el disc dur (it's free)
    encrypted   = true
  }
  key_name = aws_key_pair.key_pair_server_web.id
  
  lifecycle {
    create_before_destroy = true
  }
 
  associate_public_ip_address = true  // no crec que calgui
}

variable ssh_pub { 
  description = "ruta on estan la clau pública i que es propagarà per a cada instancia" 
}


//////////////// ASG=AUTO SCAING GROUP  per les "InstanciaRandom" que crea el launch ////////////////
// L'AUTOESCALCING EL FA A LA SUBXARXA PRIVADA !

resource "aws_autoscaling_group" "group_autoscal" { 

  name                      = "group_autoscal"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300   // 300 --> valor anterior (5 min)
  health_check_type         = "EC2"  
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch_instancie.name  
  vpc_zone_identifier       = [aws_subnet.private[0].id, aws_subnet.private[1].id] 
  target_group_arns = [aws_lb_target_group.test.arn] // MIRAR
  lifecycle {
    create_before_destroy = true
  }
  metrics_granularity = "1Minute"  //DEFAULT
  wait_for_capacity_timeout = "3m" //

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  depends_on 	     = [aws_lb.loadbalancer]

  tag {
   key                 = "Name"
    value               = "InstanciaRandom" 
    propagate_at_launch = true  
  }
}

//////////// on es la clau pública de la maquina ssh /////////////////////////////////////////////////////////

resource "aws_key_pair" "key_pair_server_web" {   // 
  key_name   = "server_web_key"
  public_key = file(var.ssh_pub)   // 
}
