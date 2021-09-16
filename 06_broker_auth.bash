source ${PWD}/01_env_bootstrap.bash

# This sequence simulates the broker accessing the secret store
# within the scope of the broker. We assume the access credentials
# are valid and should fail nicely. 
export ROLE_ID=$(cat ${SECRET_STORE_APP_ROLE_CREDS} | jq -r '.role_id')
export SECRET_ID=$(cat ${SECRET_STORE_APP_ROLE_CREDS} | jq -r '.secret_id')

export APP_TOKEN=$(vault write -format=json \
  auth/${ROLE_NAME}/login role_id=${ROLE_ID} \
  secret_id=${SECRET_ID} \
  | jq -r '.auth.client_token')