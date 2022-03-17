#!/usr/bin/bash
source ${PWD}/01_env_bootstrap.bash

export SOURCE="/Users/gilberto/hashicorp/lab/pki/app"
export DEST="/Users/gilberto/hashicorp/FAST/field-demo-explainers/pki-demo-explainer/flask"

cp $SOURCE/server.* $DEST/.
cp $SOURCE/client.* $DEST/.
cp $SOURCE/ca_bundle.crt $DEST/.
rm -f $DEST/server.log