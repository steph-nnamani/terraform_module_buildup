#creating key-private key pair for ssh access
#must run terraform init anytime you introduce a module, so terraform can download necessary plugins
#Documentation for attrubes while using modules is found under Outputs
#https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest?tab=outputs
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "tests"
  create_private_key = true
}
