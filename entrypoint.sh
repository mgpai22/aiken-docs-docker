#!/bin/bash

echo "Generating documentation..."
aiken docs

echo "Starting HTTP server on port 8000..."
python3 -m http.server 8000 --directory /app/stdlib/docs
