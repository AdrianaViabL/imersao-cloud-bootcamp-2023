# imersao-cloud-bootcamp-2023
 curso feito em fevereiro de 2023 com exemplo pratico de utilização de ferramentas devops para trabalhar com o ambiente cloud

Para subir o terraform (ja tendo se conectado a ele antes localmente)
```
terraform init
terraform apply
```

# Aula 1 (parte prática)

projeto rede de hoteis 

passos feitos (copiados do documento disponibilizado para o curso): 

Acessar a console da AWS. Na barra de pesquisas, digite IAM. Na seção Services, clique em IAM.

Clique em Add user, insira o nome terraform-pt-1 e clique em Next para criar o usuário do tipo programmatic
 
Após avançar, em Set permissions, clique no botão Attach existing policies directly.

- Digite **AmazonS3FullAccess** em **Filter distributions by text, property or value** e aperte **Enter.**
- Selecione **AmazonS3FullAccess**- Clique em **Next** - Revise todos os detalhes
- Clique em **Create user**
- Acesse o usuário **terraform-pt-1**
- Clique em **Security credentials**
- Navegue até a seção Access keys
- Clique em **Create access key**

- Selecione Command Line Interface (CLI) e **I understand the above recommendation and want to proceed to create an access key.**
- Clique em **Next**.
- Clique em **Create access key**
- Clique em **Download .csv file**
- Após o download finalizar, clique em Done.
- Com o download feito, renomeie o **.csv** para **accessKeys.csv**


- Acessar a console da GCP e abrir o Cloud Shell
- Fazer o upload dos arquivos accessKeys.csv e mission1.zip para o Cloud Shell
- Após fazer o upload, executar os comandos de preparação dos arquivos:
```
mkdir mission1_pt
mv mission1.zip mission1_pt
cd mission1_pt
unzip mission1.zip
mv ~/accessKeys.csv mission1/pt
cd mission1/pt
chmod +x *.sh
```

Execute os comandos abaixo para preparar o ambiente da AWS e GCP
```
./aws_set_credentials.sh accessKeys.csv - efetua a configuração das credenciais do aws para conseguir ter acesso atraves do cloud shell
gcloud config set project <your-project-id>  -  o id é encontrado na pagina do gcp, 'my first project' - id

```

Clique em Autorize e execute o comando abaixo para setar o projeto no Google Cloud Shell
```
./gcp_set_project.sh
```

Execute o comando para habilitar as APIs do Kubernetes, Container Registry e Cloud SQL
```
gcloud services enable containerregistry.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com
```

**OBS IMPORTANTE (NÃO PULE ESTE PASSO):**

- **Antes de executar os comandos do terraform, abra o Google Cloud Editor e atualizar o arquivo tcb_aws_storage.tf substituindo o nome do bucket para um exclusivo (na AWS, os buckets precisam ter nomes únicos).**
    - Na linha 4 do arquivo tcb_aws_storage.tf: 
        - Abra o Google Cloud Editor - editor do proprio gcp shell
        - Substituir xxxx pelas iniciais do seu nome mais dois números:
        Exemplo: luxxy-covid-testing-system-pdf-pt-jr29
- Execute os seguintes comandos para provisionar os recursos de infraestrutura

```
cd ~/mission1_pt/mission1/pt/terraform/

terraform init
terraform plan
terraform apply
```

Após acessar o servço do GKE para criar o cluster, clicar no botão Compare para "Comparar os modes de cluster para entender mais sobre as suas diferenças".

## Configuração de Rede SQL

- Após a conclusão do provisionamento da instância do CloudSQL, acesse o serviço do Cloud SQL.
- Clique na sua instância do Cloud SQL.
- Na lateral direita, em Primary Instance, clique em **“Connections”.**
- Em **Instance IP assignment**, habilite o Private IP.
    - Em **Associated Network**, selecione “Default”.
    - Clique em **Set up connection**
    - Enable **Service Networking API (se solicitar)**
    - Selecione **Use an automatically allocated IP range in your network**.
    - Clique em **Continue.**
    - Clique em **Create connection** e aguarde alguns minutos.
- Após finalizar, em **“Connections”**, **Autorized Networks**, clique em **"Adicionar Rede (Add Network)".**
    - Em **New Network**, insira as seguintes informações:
        - **Nome:** Public Access (Apenas para testes)
        - **Network:** 0.0.0.0/0
        - Clique em **Done**.
        - Clique em **Save** e aguarde finalizar a edição do Cloud SQL Instance.

PS: Para ambientes de produção, é recomendado utilizar apenas a Rede Privada para o acesso ao banco de dados. 
⚠️ Nunca fornecer acesso à rede pública (0.0.0.0/0) para os banco de dados de produção.

===================================================================================================================================

# aula 2

# Amazon Web Services

- Acessar a console da AWS. Na barra de pesquisas, digite IAM. Na seção Services, clique em IAM.
- Clique em Add user, insira o nome **luxxy-covid-testing-system-pt-app1** e clique em Next para criar o usuário do tipo programmatic.


- Após avançar, em Set permissions, clique no botão Attach existing policies directly.
- Digite **AmazonS3FullAccess** em **Filter distributions by text, property or value** e aperte **Enter.**
- Selecione **AmazonS3FullAccess**
- Clique em **Next** - Revise todos os detalhes - Clique em **Create user**

### Passos para fazer o download da chave de acesso

- Acesse o usuário **luxxy-covid-testing-system-pt-app1**
- Clique em **Security credentials**
- Navegue até a seção Access keys
- Clique em **Create access key**
- Selecione Command Line Interface (CLI) e **I understand the above recommendation and want to proceed to create an access key.**
- Clique em **Next**.
- Clique em **Create access key**
- Clique em **Download .csv file**
- Após o download finalizar, clique em Done.
- Com o download feito, renomeie o **.csv** para **accessKeys.csv**

### Google Cloud Platform (GCP)

- Navegue até a Cloud SQL instance e crie um novo usuário **app** com a senha **welcome123456** no Cloud SQL MySQL database.
- Se conecte ao Google Cloud Shell
- Faça o download dos arquivos da missão 2 **diretamente para o Cloud Shell usando o comando wget abaixo:**
```
cd
mkdir mission2_pt
cd mission2_pt
wget https://tcb-public-events.s3.amazonaws.com/icp/mission2.zip
unzip mission2.zip
```
- Conecte ao MySQL DB em execução no Cloud SQL (assim que aparecer a janela para colocar a senha, insira welcome123456)
```
mysql --host=<public_ip_cloudsql> --port=3306 -u app -p
```
obs.: o ip publico está na tela da aba 'visão geral' no sql do google cloud

- Após estar conectado ao banco de dados da instância, crie a tabela de produtos para testes.
```
use dbcovidtesting;
source mission2/pt/db/create_table.sql;
show tables;
desc records;
exit;
```

- Habilite a Cloud Build API através do Cloud Shell.
```
# Comando para habilitar Cloud Build API
gcloud services enable cloudbuild.googleapis.com
```
## Known issue during this step
```
ERROR: (gcloud.builds.submit) INVALID_ARGUMENT: could not resolve source: googleapi: Error 403: 989404026119@cloudbuild.gserviceaccount.com does not have storage.objects.get access to the Google Cloud Storage object., forbidden

Para solucionar:

1. Acesse o IAM & Admin;
2. Clique na sua Cloud Build Service Account

Exemplo: 989404026119@cloudbuild.gserviceaccount.com Cloud Build Service Account

3. Na sua Cloud Build Service Account, do lado direito, clique em Edit principal
4. Clique em Add another role (Adicionar outra função);
5. Clique em Select Role, e filtre por Storage Admin ou gcs. Selecione Storage Admin (Full control of GCS resources).
6. Clique em Save and retorno para o Cloud Shell.
```

- Faça o Build da Docker image e suba para o Google Container Registry. Por gentileza, substitua o <PROJECT_ID> com o My First Project ID
```
cd ~/mission2_pt/mission2/pt/app
gcloud builds submit --tag gcr.io/<PROJECT_ID>/luxxy-covid-testing-system-app-pt
```
- Abra o Cloud Editor e edite o Kubernetes deployment file (luxxy-covid-testing-system.yaml) e atualize as variáveis abaixo (em vermelho) com o seu <PROJECT_ID> no caminho da imagem Docker no Google Container Registry, AWS Bucket, AWS Keys (do arquivo luxxy-covid-testing-system-pt-app1.csv) e o IP Privado do Cloud SQL Database.


Obs.: A alteração tambem pode ser feita pelo editor do proprio clowd shell (iniciando pela linha 33 (PROJECT_ID), linha 42 (bucket name), 44 e 46 (S3 access e secret key)
e a linha 48 (Endereço IP particular))
Ir em Files e clicar em save (para salvar as alterações feitas com o editor do shell)

```
cd ~/mission2_pt/mission2/pt/kubernetes
luxxy-covid-testing-system.yaml

				image: gcr.io/<PROJECT_ID>/luxxy-covid-testing-system-app-pt:latest
...
				- name: AWS_BUCKET
          value: "luxxy-covid-testing-system-pdf-pt-xxxx"
        - name: S3_ACCESS_KEY
          value: "xxxxxxxxxxxxxxxxxxxxx"
        - name: S3_SECRET_ACCESS_KEY
          value: "xxxxxxxxxxxxxxxxxxxx"
        - name: DB_HOST_NAME
          value: "172.21.0.3"
```
- Se conecte ao GKE (Google Kubernetes Engine) cluster via Console (seguir video)
- Faça o Deploy da aplicação COVID-19 Testing Status System no Cluster
```
cd ~/mission2_pt/mission2/pt/kubernetes
kubectl apply -f luxxy-covid-testing-system.yaml
```
- Obtenha o IP Público e faça o teste da aplicação ([CLIQUE AQUI para baixar exemplo de Teste de COVID-19](https://tcb-public-events.s3.amazonaws.com/icp/mission2.zip))
- Você deve visualizar a aplicação up & running! Congrats! 🎉

# Aula 3

# Google Cloud Platform - Passos para Migração do Banco de Dados MySQL

- Conectar ao Google Cloud Shell
- Download o dump do banco de dados
```
cd
mkdir mission3_pt
cd mission3_pt
wget https://tcb-public-events.s3.amazonaws.com/icp/mission3.zip
unzip mission3.zip
```
- Conectar ao banco de dados MySQL no Cloud SQL. Senha: welcome123456
```
mysql --host=<public_ip_address> --port=3306 -u app -p
```
- Importar o dump do banco de dados no Cloud SQL
```
use dbcovidtesting;
source ~/mission3_pt/mission3/pt/db/db_dump.sql
```
- Checar se os dados foram importados com sucesso
```
SELECT * FROM records;
exit;
```

# Amazon Web Services - Passos para a Migração dos arquivos PDF

- Conectar no AWS Cloud Shell
- Download dos arquivos PDF (Comprovante de teste negativo escaneado em PDF)
```
mkdir mission3_pt
cd mission3_pt
wget https://tcb-public-events.s3.amazonaws.com/icp/mission3.zip
unzip mission3.zip
```
- Sincronizar os arquivos PDF com o seu bucket criado no AWS S3 usado para o COVID-19 Testing Status System. **Altere o nome do bucket para o seu bucket**.
```
cd mission3/pt/pdf_files
aws s3 sync . s3://luxxy-covid-testing-system-pdf-pt-xxxx
```
- Testar a aplicação. Ao testar a aplicação e navegar na opção "Ver registros" você deverá ser capaz de visualizar os dados importados!


**Parabéns! Você migrou uma aplicação e seu banco de dados do "on-premises" para uma Arquitetura MultiCloud!**


