#! /usr/bin/env bash

set -e

test -e client || git clone https://github.com/google/gdata-python-client.git client
pushd client > /dev/null
sudo python setup.py install
sudo pip install --upgrade tlslite
./tests/run_data_tests.py
popd > /dev/null
