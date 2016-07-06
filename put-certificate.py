#!/usr/bin/python

import json
import os
import requests
import sys

K8SBASE = os.getenv("K8SBASE") or "http://127.0.0.1:8000"
CERTIFICATE = sys.argv[1]

with open('/var/lib/acme-tiny/certs/%s/cert.pem' % CERTIFICATE) as f:
    cert = f.read()
with open('/var/lib/acme-tiny/certs/%s/chain.pem' % CERTIFICATE) as f:
    chain = f.read()

patch = json.dumps([{"op": "add",
                     "path": "/%s" % CERTIFICATE,
                     "value": "\n".join([cert, chain])}])

req = requests.patch(url=K8SBASE + "/api/v1/namespaces/lb/configmaps/certificates",
                     data=patch,
                     headers={"Content-Type": "application/json-patch+json"})

if req.status_code < 200 or req.status_code >= 300:
    print "Error saving certificate %s to configmap" % CERTIFICATE
    print req.text
    exit(1)
