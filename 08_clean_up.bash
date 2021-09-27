source ${PWD}/01_env_bootstrap.bash

rm -f ${CERTS_HOME}/*
rm -f ${APP_HOME}/*.crt
rm -f ${APP_HOME}/*.key
rm -f ${SECRET_STORE_APP_ROLE_CREDS}
rm -f ${SECRET_STORE_WRAPPED_TOKEN}

vault secrets disable ${RootCAName}
vault secrets disable ${InterimCAName}
vault auth disable ${ROLE_NAME}
