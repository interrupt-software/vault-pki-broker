vault login -tls-skip-verify

vault login \
  -client-cert=client.crt \
  -client-key=client.key   \
  -ca-cert=ca_bundle.crt

vault token lookup -tls-skip-verify

vault token lookup \
  -client-cert=client.crt \
  -client-key=client.key  \
  -ca-cert=ca_bundle.crt

curl -k \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  --request LIST \
  ${VAULT_ADDR}/v1/auth/token/accessors

curl \
  --cert client.crt \
  --key client.key \
  --cacert ca_bundle.crt \
  --request LIST \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  ${VAULT_ADDR}/v1/auth/token/accessors

