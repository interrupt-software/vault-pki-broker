source ${PWD}/01_env_bootstrap.bash
mkdir -p ${APP_HOME}

vault secrets disable ${InterimCAName}
vault secrets enable -path ${InterimCAName} pki
vault secrets tune -max-lease-ttl=${CA_ttl} ${InterimCAName}

vault write -format=json ${InterimCAName}/intermediate/generate/internal \
common_name="${InterimCAName}" ttl=${IntCA_ttl} | tee \
>(jq -r .data.csr > ${CERTS_HOME}/${InterimCAName}.csr)

vault write -format=json ${RootCAName}/root/sign-intermediate \
csr=@${CERTS_HOME}/${InterimCAName}.csr \
common_name="${CommonName}" ttl=${CA_ttl} | tee \
>(jq -r .data.certificate > ${CERTS_HOME}/${InterimCAName}_certificate.pem) \
>(jq -r .data.issuing_ca >  ${CERTS_HOME}/${InterimCAName}_issuing_ca.pem)

vault write ${InterimCAName}/intermediate/set-signed \
certificate=@${CERTS_HOME}/${InterimCAName}_certificate.pem

vault write ${InterimCAName}/config/urls \
issuing_certificates="${VAULT_ADDR}/v1/${InterimCAName}/ca" \
crl_distribution_points="${VAULT_ADDR}/v1/${InterimCAName}/crl"

vault write ${InterimCAName}/roles/${IntRoleName} \
    allowed_domains="dev.${CommonName}" \
    allow_subdomains="true" \
    max_ttl=${Cert_ttl} \
    generate_lease=true

cat \
  ${CERTS_HOME}/${InterimCAName}_issuing_ca.pem \
  ${CERTS_HOME}/${InterimCAName}_certificate.pem \
  > ${CERTS_HOME}/${InterimCAName}_ca_bundle.crt

