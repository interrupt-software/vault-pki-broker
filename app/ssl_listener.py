#!/usr/bin/python3

import socket
import ssl
import logging

logging.basicConfig(filename='server.log', format='%(asctime)s %(name)s %(levelname)s: %(message)s ', level=logging.DEBUG)

# Bind the socket to the port
server_address = ('0.0.0.0', 10443)
server_cert = 'server.crt'
server_key = 'server.key'
client_certs = 'ca_bundle.crt'

context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.verify_mode = ssl.CERT_REQUIRED
context.load_cert_chain(certfile=server_cert, keyfile=server_key)
context.load_verify_locations(cafile=client_certs)

bindsocket = socket.socket()
bindsocket.bind(server_address)
bindsocket.listen(5)

while True:
    logging.info("Waiting for client")
    newsocket, fromaddr = bindsocket.accept()
    logging.info("Client connected: {}:{}".format(fromaddr[0], fromaddr[1]))
    conn = context.wrap_socket(newsocket, server_side=True)
    logging.info("SSL established. Peer: {}".format(conn.getpeercert()))
    buf = b''  # Buffer to hold received client data
    try:
        while True:
            data = ""
            try:
                data = conn.recv(4096)
            except ConnectionResetError:
                logging.warning("ConnectionResetError: No client.")
            if data:
                # Client sent us data. Append to buffer
                buf += data
                # conn.send(b"ACK")
            else:
                # No more data from client. Show buffer and close connection.
                logging.info("Data received: %s", buf)
                break
    finally:
        logging.info("Closing connection")
        try:
            conn.shutdown(socket.SHUT_RDWR)
        except OSError:
            logging.warning("OSError: Connection reset by peer. No connection to shutdown.")
        conn.close()

