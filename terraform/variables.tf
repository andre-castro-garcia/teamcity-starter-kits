###############################################################
# Variáveis gerais para provisionamento dos recursos
###############################################################
variable "availability_zone" {
  default = "sa-east-1a" # Não esqueça de alterar esse valor para um nova de disponibilidade disponível na sua região.
}

variable "tag_name" {
  default = "TeamCity"
}

variable "instance_user" {
  default = "ec2-user"
}

variable "bootstrap_shell_script_location" {
  default = "/home/ec2-user/bootstrap.sh"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlWjrOCySrQzXy50sH/ljQmIg+l7GMK+4DvoPH/hyZsdx/mSIvX2yN+LZ4tI0VWX+L44wo6GRv6oNv8SQfZdQBi0eA4ixPoh0KZ2XvNjV7rmqsU3n0aP7P8EfpKxzyrwVriW0S+PPMQeZWzxnsJSHtY7Ow0JL098JSvdYLMm6wncjvLFZjSrA6RUu9heYPtXD1a7BSi+L5chRxOpQ8qmrQ467VCf8fvmuQZpFHEI4l8CNRh0l0pqYxOLTgve8Xr+crnPxICGzCOdUUK2HnSbDr0HoPmyjqEoQwspGjYwNFc+dvHZBcJ5JMvHUt+vh/u3F8k8lJe5PIbj1rN2qgHQ5kw== rsa-key-20180804"
}

variable "private_key_file" {
  default = "teamcity_key_private_key.pem"
}

locals {
  private_key = "${file(var.private_key_file)}"
}
