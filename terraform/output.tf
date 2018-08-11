###############################################################
# Saída do comando de 'terraform apply'
###############################################################
output "teamcity_url" {
  value = "http://${aws_instance.teamcity_instance.public_dns}"
}
