# teamcity-starter-kits

Este projeto armazena os scripts de implantação do servidor de CI/CD da JetBrains TeamCity, esses scripts vão ajudar você nas seguintes tarefas:

  - Provisionar novas instâncias do servidor **JetBrains TeamCity Server**
  - Provisionar novos agentes para o seu servidor já implantado

## novos recursos

- Template de criação de uma instância de testes do servidor TeamCity no [ElasticBeanstalk](https://aws.amazon.com/pt/elasticbeanstalk/).

## roadmap

- Adicionar novos templates do Chef....

## como usar

Para cada template, execute os passos a seguir para provisionar os servidores:

### elasticbeanstalk

- Crie uma nova aplicação no ElasticBeanstalk no console da AWS;
- Adicione um novo ambiente de servidor web nessa aplicação, selecione as seguintes opções na momento de configurar o novo ambiente;
  - Plataforma: Multi-container Docker
  - Tipo da Instância: t2.medium
- Após criar o novo ambiente, faça a upload do arquivo **elasticbeanstalk/Dockerrun.aws.json** como uma nova versão da sua aplicação e implante essa versão no seu ambiente;
- Acesse o seu novo ambiente do TeamCity e **Enjoy!!!!!!!!**.

### terraform

- No console, acesse a pasta "terraform";
- Adicione as seguintes variáveis de ambiente para acesso a API da AWS:
  - AWS_ACCESS_KEY_ID="access_key_id"
  - AWS_SECRET_ACCESS_KEY="secret_key_id"
  - AWS_DEFAULT_REGION="region"
- No arquivo "variables.tf", preencha o variável "availability_zone" com uma zona de disponibilidade de acordo com a região escolhida.
- Execute os comandos abaixo para provisionar o ambiente do TeamCity;
  - terraform init
  - terraform plan
  - terraform apply
- Veja o endereço do novo servidor de CI/CD no output "teamcity_url", acesse o seu novo ambiente do TeamCity e **Enjoy!!!!!!!!**.

*OBS:* As imagens do docker são baixadas diretamente no Docker Hub, se quiser mais acesse a descrição das imagens aqui [JetBrains TeamCity Server](https://hub.docker.com/r/jetbrains/teamcity-server/) e [JetBrains TeamCity Agent](https://hub.docker.com/r/jetbrains/teamcity-agent/).
