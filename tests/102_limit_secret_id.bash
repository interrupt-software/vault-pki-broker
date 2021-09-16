source 01_env_bootstrap.bash

vault write auth/${ROLE_NAME}/role/${ROLE_NAME} \
  token_policies=${ROLE_NAME} \
  secret_id_num_uses=4 \
  token_num_uses=${TOKEN_NUM_USES}

source 05_broker_creds.bash

# This sequence simulates the broker accessing the secret store
# within the scope of the broker. We assume the access credentials
# are valid and should fail nicely. 
export ROLE_ID=$(cat .app_role_creds | jq -r '.role_id')
export SECRET_ID=$(cat .app_role_creds | jq -r '.secret_id')

count=1
while [ $count -le 10 ]                                          
do

export APP_TOKEN=$(vault write -format=json \
  auth/${ROLE_NAME}/login role_id=${ROLE_ID} \
  secret_id=${SECRET_ID} \
  | jq -r '.auth.client_token')

if [ -z "${APP_TOKEN}" ]
  then
    echo "Renewing app role secret id..."
    echo 
    source 05_broker_creds.bash
    export APP_TOKEN=$(vault write -format=json \
      auth/${ROLE_NAME}/login role_id=${ROLE_ID} \
      secret_id=${SECRET_ID} \
      | jq -r '.auth.client_token')
fi

echo ${count}": "${APP_TOKEN}
unset APP_TOKEN
(( count++ ))
done