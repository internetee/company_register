#!/bin/bash

# Qlty coverage upload script
# Usage: ./upload_coverage.sh

echo "Installing Qlty CLI..."
curl https://qlty.sh | sh

echo "Running tests with coverage..."
bundle exec rake test

echo "Uploading coverage to Qlty..."
if [ -f coverage/coverage.json ]; then
    QLTY_COVERAGE_TOKEN=$QLTY_COVERAGE_TOKEN qlty coverage publish coverage/coverage.json
    echo "Coverage uploaded successfully!"
else
    echo "No coverage file found. Make sure SimpleCov is configured correctly."
    exit 1
fi
