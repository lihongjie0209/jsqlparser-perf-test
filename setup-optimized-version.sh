#!/bin/bash

# Script to download and setup the optimized JSqlParser version

set -e

echo "=========================================="
echo "JSqlParser Optimized Version Setup"
echo "=========================================="
echo ""

# Create lib directory
mkdir -p lib

# Download URL for the optimized version
DOWNLOAD_URL="https://github.com/lihongjie0209/JSqlParser/releases/download/jsqlparser-4.5-ext-v1.0/jsqlparser-jsqlparser-4.5-ext-v1.0.jar"
OUTPUT_FILE="lib/jsqlparser-4.5-ext-v1.0.jar"

echo "Downloading optimized JSqlParser version from:"
echo "$DOWNLOAD_URL"
echo ""

# Check if file already exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "File already exists: $OUTPUT_FILE"
    read -p "Do you want to re-download it? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Using existing file."
        exit 0
    fi
    rm "$OUTPUT_FILE"
fi

# Download the JAR file
if command -v wget &> /dev/null; then
    wget -O "$OUTPUT_FILE" "$DOWNLOAD_URL"
elif command -v curl &> /dev/null; then
    curl -L -o "$OUTPUT_FILE" "$DOWNLOAD_URL"
else
    echo "Error: Neither wget nor curl is installed."
    echo "Please install one of them and try again, or download manually from:"
    echo "$DOWNLOAD_URL"
    exit 1
fi

# Verify download
if [ -f "$OUTPUT_FILE" ]; then
    FILE_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE" 2>/dev/null)
    echo ""
    echo "✓ Download successful!"
    echo "  File: $OUTPUT_FILE"
    echo "  Size: $FILE_SIZE bytes"
    echo ""
    echo "Setup complete! You can now run benchmarks with the optimized version using:"
    echo "  mvn clean package -Djsqlparser.optimized"
    echo "  or"
    echo "  ./run-benchmarks.sh optimized"
    echo ""
else
    echo "Error: Download failed."
    exit 1
fi
