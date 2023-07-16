data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

#this data block defines a default vpc pre-existing in our aws account
#this will be different when we use a custom vpc
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "blog" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  #this syntax "security_group_id" was gotten from the outputs section of registry.terraform.aws.SG url
  vpc_security_group_ids = [module.demo_sg.security_group_id]

  tags = {
    Name = "Learning Terraform"
  }
}

#this module reference is https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
#you can give the module any name
#the actual module code is defined by the "source" parameter
#the "name = my-sg" is just a tag
#the vpc_id is an input from the "default vpc block" above
#we are gonna add the security-group id that will be output from this module to our instance above
module "demo_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"
  name = "my_sg"
  vpc_id  = data.aws_vpc.default.id
  #the syntax for the corresponding (right) value pairs of the (left) keys is defined under Features.Named rules of ref. below
  #https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
  ingress_rules = ["https-443-tcp","http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}