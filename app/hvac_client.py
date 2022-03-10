#!/usr/bin/python3

import hvac
import os

VAULT_ADDR =  os.environ.get('VAULT_ADDR')
VAULT_TOKEN =  os.environ.get('VAULT_TOKEN')

client = hvac.Client(
    url=VAULT_ADDR,
    token=VAULT_TOKEN,
    verify=True,
)

# print(client.is_authenticated())

generate_certificate_response = client.secrets.pki.generate_certificate(
   name='hashicat-int-role',
   common_name='app1.dev.hashicat.io',
   mount_point='hashicat-ca-intermediate'
)

rr = generate_certificate_response

f = open("server.crt","w+")
f.write(rr['data']['certificate'])
f.close()

f = open("server.key","w+")
f.write(rr['data']['private_key'])
f.close()

rr = generate_certificate_response

f = open("client.crt","w+")
f.write(rr['data']['certificate'])
f.close()

f = open("client.key","w+")
f.write(rr['data']['private_key'])
f.close()

