#!/bin/bash

# Take down all nodes
yes | salt-cloud -P -m cloud.map -d

# Clean out existing keys
yes | salt-key -D