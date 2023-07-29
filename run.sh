git clone https://github.com/upendraugrarapu/$2 /app
cd /app
case $1 in
  mongo)
    curl -L https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/rds-combined-ca-bundle.pem
    mongo --ssl \
    --host $(aws ssm get-parameter --name ${env}.docdb.endpoint --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g'):27017 \
    --sslCAFile /app/rds-combined-ca-bundle.pem \
    --username $(aws ssm get-parameter --name ${env}.docdb.user --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
    --password $(aws ssm get-parameter --name ${env}.docdb.pass --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
          </app/schema/${2}.js
    ;;
  mysql)
    mysql -h $(aws ssm get-parameter --name ${env}.rds.endpoint --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
         -u$(aws ssm get-parameter --name ${env}.rds.user --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
         -p$(aws ssm get-parameter --name ${env}.rds.pass --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
          < /app/schema/${2}.sql
    ;;
  *)
    echo schema loading supportedonly for mongo and mysql
    exit 1
    ;;
esac



# mysql and mongo schema load code from ansible schemasetup.yml file