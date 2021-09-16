source 01_env_bootstrap.bash

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
echo ${count}": "${APP_TOKEN}
unset APP_TOKEN
(( count++ ))
done