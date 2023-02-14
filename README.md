# imersao-cloud-bootcamp-2023
 curso feito em fevereiro de 2023 com exemplo pratico de utilização de ferramentas devops para trabalhar com o ambiente cloud
Aula 2
Para subir o terraform (ja tendo se conectado a ele antes localmente)
```
terraform init
terraform apply
```

Aula 1 (parte prática)



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

