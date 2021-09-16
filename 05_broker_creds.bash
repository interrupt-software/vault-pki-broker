source ${PWD}/01_env_bootstrap.bash

export ROLE_ID=$(vault read -format=json \
  auth/${ROLE_NAME}/role/${ROLE_NAME}/role-id \
  | jq -r '.data.role_id')

# vault write -force auth/approle/role/broker/secret-id
# Key                   Value
# ---                   -----
# secret_id             06f4a18d-d9e4-b627-9e2a-7370782daa12
# secret_id_accessor    9a5b772f-6012-4aeb-cda3-e824f9146758
# secret_id_ttl         0s

export WRAPPED_TOKEN=$(vault write -format=json \
  -wrap-ttl=60s -force \
  auth/${ROLE_NAME}/role/${ROLE_NAME}/secret-id \
  | jq -r '.wrap_info.token')

# This simulates storing the wrapped token for the secret id in a secret store
# within the scope of the broker. We are limiting the use of the wrapped token
# to about 60 seconds. 
cat <<EOF > ${SECRET_STORE_WRAPPED_TOKEN}
{
  "token" : "${WRAPPED_TOKEN}"
}
EOF

unset WRAPPED_TOKEN

export WRAPPED_TOKEN=$(cat ${SECRET_STORE_WRAPPED_TOKEN} | jq -r '.token')

export SECRET_ID=$(VAULT_TOKEN=${WRAPPED_TOKEN} vault unwrap -format=json \
  | jq -r '.data.secret_id')

# export SECRET_ID=$(vault write -format=json -force \
#   auth/approle/role/${ROLE_NAME}/secret-id \
#   | jq -r '.data.secret_id')

# This simulates storing the app role and secret id in a secret store
# within the scope of the broker. These are the access credentials to 
# exchange secrets with Vault and should not be exposed.
cat <<EOF > ${SECRET_STORE_APP_ROLE_CREDS}
{
  "role_id" : "${ROLE_ID}",
  "secret_id" : "${SECRET_ID}"
}
EOF

# Next Step:
# vault write -format=json auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID}