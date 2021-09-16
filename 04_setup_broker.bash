source ${PWD}/01_env_bootstrap.bash

vault auth disable ${ROLE_NAME}

vault auth enable -path ${ROLE_NAME} approle
# Success! Enabled approle auth method at: approle/

vault policy write ${ROLE_NAME} -<<EOF 
# Full permissions on pki intermediate. To issue certificates, the
# minimus requirement is "write" but to access the secret path we
# need "read" as well.
path "${InterimCAName}/*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOF

vault write auth/${ROLE_NAME}/role/${ROLE_NAME} \
  token_policies=${ROLE_NAME} \
  secret_id_num_uses=${SECRET_ID_NUM_USES} \
  token_num_uses=${TOKEN_NUM_USES}

# Success! Data written to: auth/approle/role/broker
