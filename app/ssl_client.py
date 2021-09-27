#!/usr/bin/python3

import socket
import ssl

server_address = ('0.0.0.0', 10443)
server_sni_hostname = 'app1.dev.interrupt.com'
client_cert = 'client.crt'
client_key  = 'client.key'
client_certs = 'ca_bundle.crt'

context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH, cafile=client_certs)
context.load_cert_chain(certfile=client_cert, keyfile=client_key)
context.load_verify_locations(cafile=client_certs)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
conn = context.wrap_socket(s, server_side=False, server_hostname=server_sni_hostname)
conn.connect(server_address)
print("SSL established. Peer: {}".format(conn.getpeercert()))
print("Sending: 'Hello, world!")
conn.send(b"Hello, world!")
print("Closing connection")
conn.close()

