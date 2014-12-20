#!/bin/bash

# Ensure in home dir
# Do we use ENV_VARS for this instead?
cd ~/

# Make directory, including parents
mkdir -p /srv/formulas

cd /srv/formulas

# Clone the graphite formula
git clone https://github.com/saltstack-formulas/graphite-formula









