# Atividade de Linux PB COMPASS - AWS & DEVSECOPS


   - ### Instalação e Configuração do Servidor NFS

 **Atualização e instalação de pacotes necessários:**
 - Aqui é utilizado o comando update -y e install nfs-utils para verificar se o sistema está na última versão, e instalar (caso necessário) o NFS:
    - `sudo yum update -y` 
    - `sudo yum install -y nfs-utils`
    
 **Criar o diretório para exportação:**
 - Utilizando o seguintes comandos abaixo, foi criada as pastas /nfs/guilherme, modificando o proprietário do diretório (e grupo): 
    - Cria o diretório com o seu nome `sudo mkdir -p /srv/nfs/guilherme` 
    - Muda o proprietário do diretório/grupo e de todos os seus arquivos `sudo chown -R nobody:nobody /srv/nfs/guilherme`
    - Concede permissões de leitura, gravação e execução para todos os usuários no diretório. `sudo chmod 777 /srv/nfs/guilherme` 

 **Edição do arquivo de exportação do NFS:**
- Nesta etapa, foi utilizado o nano dentro do etc/exports para criar uma nova linha de configuração:

   - Comando utilizado para abrir o editor de texto nano e editar o arquivo:
      - `sudo nano /etc/exports`

   - Nova linha a ser adicionada:
     
      ```
      /srv/nfs/guilherme *(rw,sync,no_subtree_check)
      ```
   - Esta linha adicionada configura o diretório /guilherme para ser exportado via Network File System, concedendo acesso de leitura e escrita (rw) a qualquer host (*), garantindo que as operações de escrita sejam feitas de forma síncrona (sync) e desativando a verificação de subárvores (no_subtree_check).

**Exportando o diretório NFS:**

   - Com o comando abaixo, reinicia-se as exportações do NFS, aplicando mudanças feitas no arquivo /etc/exports sem a necessidade de reiniciar o serviço:
     
        `sudo exportfs -r` 
  
**Inicialização e Habilitação do Serviço NFS**
 
 - O comando abaixo inicia o serviço do servidor NFS:
   
     `sudo systemctl start nfs-server`

- O seguinte comando configura o serviço NFS para iniciar automaticamente junto com o sistema:
  
     `sudo systemctl enable nfs-server`

- Aqui, o comando imprime o status do servidor NFS, como ativo, inativo, ou desabilitado:
  
     `sudo systemctl status nfs-server` 

 **Instalação e configuração do Apache (httpd)**
 
  Segue o comando para a instalação do Web Apache:
    - `sudo yum install -y httpd` 

**Iniciar e habilitar o Apache:**
 - O presente comando inicia serviço do Apache:
    - `sudo systemctl start httpd` 
        
 - Com o comando abaixo, o apache será inicializado automaticamente após o boot do sistema:
    - `sudo systemctl enable httpd` 
        
 - Este comando imprime o estado atual do serviço Apache:
    - `systemctl status httpd`  

**Criação do arquivo do Script:**

 - `sudo nano /usr/local/bin/verificacao_apache.sh` cria e abre o nano para editar o script de verificação do Apache, para podermos escrever o script e depois torna-lo executável. O diretório escolhido para a criação foi o /usr/local/bin.

 **Criação e Configuração do Script de Verificação:**


      - Adicionar o seguinte conteúdo ao script:
      ```
      #!/bin/bash

      # Diretório de saída
      OUTPUT_DIR="/srv/nfs/guilherme"

      # Nome do serviço
      SERVICE_NAME="httpd"

      # Data e Hora atuais
      CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

      # Verificar status do serviço
      if systemctl is-active --quiet $SERVICE_NAME; then
          STATUS="ONLINE"
          MESSAGE="$CURRENT_DATE - $SERVICE_NAME - Status: ONLINE - O serviço está em execução."
          echo "$MESSAGE" > "$OUTPUT_DIR/servico_online.txt"
      else
          STATUS="OFFLINE"
          MESSAGE="$CURRENT_DATE - $SERVICE_NAME - Status: OFFLINE - O serviço não está em execução."
          echo "$MESSAGE" > "$OUTPUT_DIR/servico_offline.txt"
      fi
      ```
**Tornando o Script acima executável**
    - `sudo chmod +x /usr/local/bin/verificacao_apache.sh` Concede as permissões de execução ao script, tornando-o executável.

**Configuração do Cron**
    - `sudo crontab -e` Este comando abre o editor de crontab para que possamos adicionar a linha que fará a execução do mesmo ser agendada para a cada cinco minutos.

**Adicionamos a seguinte linha ao crontab:**
    ```
    */5 * * * * /usr/local/bin/verificacao_apache.sh
    ``` 
    - Esta linha configura o script para ser executado a cada 5 minutos.
