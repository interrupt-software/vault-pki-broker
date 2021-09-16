source ${PWD}/01_env_bootstrap.bash
source ${PWD}/06_broker_auth.bash

export VAULT_TOKEN=${APP_TOKEN}
export APP_NAME="app1.dev"

cp ${CERTS_HOME}/${InterimCAName}_ca_bundle.crt ${APP_HOME}/ca_bundle.crt

export CRT_CONSUMER_ROLE="server"
vault write -format=json ${InterimCAName}/issue/${IntRoleName} common_name=${APP_NAME}.${CommonName} |  tee \
>(jq -r .data.ca_chain    > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_ca_chain.pem") \
>(jq -r .data.certificate > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem") \
>(jq -r .data.issuing_ca  > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_issuing_ca.pem") \
>(jq -r .data.private_key > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem")

cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem ${APP_HOME}/server.key
cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem ${APP_HOME}/server.crt

export CRT_CONSUMER_ROLE="client"
vault write -format=json ${InterimCAName}/issue/${IntRoleName} common_name=${APP_NAME}.${CommonName} |  tee \
>(jq -r .data.ca_chain    > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_ca_chain.pem") \
>(jq -r .data.certificate > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem") \
>(jq -r .data.issuing_ca  > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_issuing_ca.pem") \
>(jq -r .data.private_key > "${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem")

cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_private_key.pem ${APP_HOME}/client.key
cp ${CERTS_HOME}/${APP_NAME}.${CommonName}-${CRT_CONSUMER_ROLE}_certificate.pem ${APP_HOME}/client.crt

unset VAULT_TOKEN
unset APP_TOKEN