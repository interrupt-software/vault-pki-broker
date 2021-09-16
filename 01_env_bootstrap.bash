export VAULT_ADDR="http://127.0.0.1:8200"

export CERTS_HOME="${PWD}/certs"
export APP_HOME="${PWD}/app"

export RootName="interrupt"

export RootCAName="${RootName}-ca-root"
export CommonName="${RootName}.com"
export CARoleName="${RootName}-ca-role"
export CA_ttl="24h"

export InterimCAName="${RootName}-ca-intermediate"
export IntCA_ttl="60m"
export Cert_ttl="1m"
export IntRoleName="${RootName}-int-role"

# For PKI distribution
export ROLE_NAME="broker"
export SECRET_ID_NUM_USES=0
export TOKEN_NUM_USES=0
export SECRET_STORE_APP_ROLE_CREDS=".app_role_creds"
export SECRET_STORE_WRAPPED_TOKEN=".wrapped_token"