#!/bin/bash

# Script to compare two JMH benchmark result files

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <original_results.txt> <optimized_results.txt>"
    echo ""
    echo "Example:"
    echo "  $0 results/original_version.txt results/optimized_version.txt"
    exit 1
fi

ORIGINAL_FILE=$1
OPTIMIZED_FILE=$2

if [ ! -f "$ORIGINAL_FILE" ]; then
    echo "Error: Original results file not found: $ORIGINAL_FILE"
    exit 1
fi

if [ ! -f "$OPTIMIZED_FILE" ]; then
    echo "Error: Optimized results file not found: $OPTIMIZED_FILE"
    exit 1
fi

echo "=========================================="
echo "JSqlParser Performance Comparison"
echo "=========================================="
echo ""
echo "Original Version Results: $ORIGINAL_FILE"
echo "Optimized Version Results: $OPTIMIZED_FILE"
echo ""
echo "=========================================="
echo ""

# Extract benchmark results from both files and display them side by side
echo "Extracting benchmark scores..."
echo ""

# This is a simple comparison - for more sophisticated analysis,
# consider using JMH's built-in comparison tools or visualization tools

echo "Original Version:"
echo "----------------------------------------"
grep "avgt" "$ORIGINAL_FILE" | grep "us/op" || echo "No results found in original file"
echo ""

echo "Optimized Version:"
echo "----------------------------------------"
grep "avgt" "$OPTIMIZED_FILE" | grep "us/op" || echo "No results found in optimized file"
echo ""

echo "=========================================="
echo "Comparison complete!"
echo ""
echo "Note: Lower scores (us/op) indicate better performance."
echo "Compare the 'Score' column for each benchmark."
echo ""
echo "For detailed analysis, consider:"
echo "1. Using JMH Visualizer: https://jmh.morethan.io/"
echo "2. Importing JSON results into visualization tools"
echo "3. Running with more iterations for statistical significance"
echo "=========================================="
