## (SLIDE 1):

Good morning / good afternoon, we are Marc Fornés and Rubén Rodríguez, and now we are going to talk about the automation of an infrastructure with IaC’s philosophy (Infrastructure as Code). The objective is to lift a ticketing infrastructure for a massive event, and we are going to use AWS as a dealer of infrastructure and resources / net services and Terraform software, to automate the deployment. 

---------------------------------------------------------------------------------------------------------------------------

## (SLIDE 2):

Terraform is an IaC multiplatform which constructs, lifts, dismantles, climbs, copies and manages infrastructures. With Terraform we can do a reengineering or inverse engineering; that is to say, from the AWS’ infrastructure, it is going to create a file with the code of all the instructions on how to lift the infrastructure.

---------------------------------------------------------------------------------------------------------------------------
## (SLIDE 3, 4 and 5):

We are going to start from an empty AWS environment, we will carry out ‘terraform apply’ and (approximately) 3 minutes later, our infrastructure will be lifted. We will have an Autoscaling group in which we will put the AMI instances that are going to have a service named ‘EC2 Autoscaling’; moreover, they are going to be formed by a ‘Cluster’. Therefore, AWS gives us the service ‘Cloud Watch’  that we are going to use in order to create an alarm which will notify us that another instance will be lifted when the machine’s CPU reaches the 60%. All this will be inside a private subnet that, at the same time, will be inside a previously created VPC. 

The browsers’ requests from the clients will be balanced by a ‘Reverse Proxy’ which acts as a front (that is to say, it will be exposed to internet through gateway) with an ELB service (Elastic Load Balancer) inside a public subnet that, simultaneously, will be inside the VPC.

---------------------------------------------------------------------------------------------------------------------------

## (SLIDE 6 and 7):

Once we have what we have previously explained functioning, if we had left something to lift, for instance, an ‘S3 Bucket’ (an AWS’ service for file’s storage), when we do ‘terraform apply’, Terraform will look at the status of the actual structure and will only add the new changes without the necessity of having to lift all the previous information (referring to the explained structure). 

---------------------------------------------------------------------------------------------------------------------------

## (SLIDE 8):

Once we have finished, we want to empty everything since we are not going to make use of it, and because it wastes money too. In order to do that, we will use ‘terraform destroy’ that will dismantle everything in a safe and fast way. 

---------------------------------------------------------------------------------------------------------------------------

## (SLIDE 9):

Even though we already have everything we need, we can make it easier using ‘Anisble + Packer’. These will help us create a customised NGINX image to let AWS take it for its AMI.
