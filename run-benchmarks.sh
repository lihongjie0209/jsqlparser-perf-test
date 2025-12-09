#!/bin/bash

# Script to run JMH benchmarks for JSqlParser performance testing

set -e

# Determine which version to test
VERSION_TYPE="${1:-original}"

echo "=========================================="
echo "JSqlParser Performance Benchmark Runner"
echo "=========================================="
echo ""

if [ "$VERSION_TYPE" == "optimized" ]; then
    echo "Testing: Optimized version (4.5-ext-v1.0)"
    echo ""
    
    # Check if optimized JAR exists
    if [ ! -f "lib/jsqlparser-4.5-ext-v1.0.jar" ]; then
        echo "Error: Optimized JSqlParser JAR not found."
        echo "Please run ./setup-optimized-version.sh first."
        exit 1
    fi
    
    BUILD_PROFILE="-Djsqlparser.optimized"
    VERSION_LABEL="optimized"
else
    echo "Testing: Original version (4.5)"
    echo ""
    BUILD_PROFILE=""
    VERSION_LABEL="original"
fi

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Error: Maven is not installed. Please install Maven first."
    exit 1
fi

# Clean and build the project
echo "Building the project..."
mvn clean package $BUILD_PROFILE

# Check if build was successful
if [ ! -f "target/benchmarks.jar" ]; then
    echo "Error: Build failed. benchmarks.jar not found."
    exit 1
fi

echo ""
echo "Build successful!"
echo ""

# Create results directory
mkdir -p results

# Run benchmarks
echo "Running benchmarks for $VERSION_LABEL version..."
echo "This may take several minutes..."
echo ""

# Get current timestamp for results file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="results/benchmark_${VERSION_LABEL}_${TIMESTAMP}.txt"

# Run all benchmarks with JSON output
java -jar target/benchmarks.jar \
    -rf json \
    -rff "results/benchmark_${VERSION_LABEL}_${TIMESTAMP}.json" \
    2>&1 | tee "${RESULTS_FILE}"

echo ""
echo "=========================================="
echo "Benchmark completed!"
echo "Results saved to:"
echo "  - ${RESULTS_FILE}"
echo "  - results/benchmark_${VERSION_LABEL}_${TIMESTAMP}.json"
echo "=========================================="
echo ""

if [ "$VERSION_TYPE" == "original" ]; then
    echo "To run benchmarks with the optimized version, use:"
    echo "  ./run-benchmarks.sh optimized"
    echo ""
fi

# Optional: Run specific benchmark
# java -jar target/benchmarks.jar JSqlParserBenchmark.parseSimpleSelect
